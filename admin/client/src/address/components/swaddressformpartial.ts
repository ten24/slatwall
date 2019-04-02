/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAddressFormPartialController{

	public address;
    public defaultCountry;
    public defaultCountryCode:string;
	public countryCodeOptions;
	public stateCodeOptions;
	
	public stateSelect:boolean = true;

	constructor(public $hibachi,
	            public collectionConfigService,
				public observerService,
				public requestService,
				public rbkeyService
	){
        this.defaultCountry =  this.countryCodeOptions[0];
        
        if(this.address.stateCode == null){
            this.address.stateCode = this.stateCodeOptions[0]
        }
       
        for(var i=0; i<this.countryCodeOptions.length; i++){
			var country = this.countryCodeOptions[i];
			if(country['countryCode'] === this.defaultCountryCode){
				this.address.countryCode = country;
                break;
			}
		}
	}
	
	public updateStateCodes = () =>{
	    //load appropriate state codes, or update UI
	    
	    console.log('country', this.address.countryCode);
	    
	    var queryString = 'entityName=State&f:countryCode=' + 
	    				     this.address.countryCode.countryCode + 
	    				  '&allRecords=true&propertyIdentifiers=stateCode,stateName';
	    
	    var processUrl = this.$hibachi.buildUrl('api:main.get',queryString);
		
		var adminRequest = this.requestService.newAdminRequest(processUrl);
		
		adminRequest.promise.then(
			(response)=>{
				this.stateSelect = response.records.length !== 0;
				
				if(this.stateSelect){
					this.stateCodeOptions = response.records;
					this.address.stateCode = this.stateCodeOptions[0];
				} else {
					delete this.address.stateCode;
				}
			}	
		)
	}

}

class SWAddressFormPartial implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		address: "=",
		countryCodeOptions: "<",
		defaultCountryCode: "@?",
		stateCodeOptions: "<"
	};
	public controller=SWAddressFormPartialController;
	public controllerAs="swAddressFormPartial";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    addressPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWAddressFormPartial(
			addressPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        );
        directive.$inject = [
			'addressPartialsPath',
			'slatwallPathBuilder',
			'$hibachi',
			'rbkeyService'
        ];
        return directive;
    }

	constructor(private addressPartialsPath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(addressPartialsPath) + "/addressformpartial.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWAddressFormPartial
};

