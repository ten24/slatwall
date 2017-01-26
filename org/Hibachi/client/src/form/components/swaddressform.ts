/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
//Displays an address form. Pass in an address object to bind to.
declare var hibachiConfig:any;

class SWAddressFormController {
	public slatwallScope:any;
	public slatwall:any;
	public action:any;
	public customPartial:any;
	public fieldList:string;
	public showAddressBookSelect:boolean = false;
	public showCountrySelect:boolean = true;
	public showSubmitButton:boolean = true;
    public address:any;
    public addressName:string;
    public param:string = "?slataction=";
    public showAlerts:string = "true";

	//@ngInject
    constructor(private $log) {
		//if exists, just name it slatwall.
		if (angular.isDefined(this.slatwallScope)){
			this.slatwall = this.slatwallScope;
		}

		if (this.fieldList == undefined) {
	        this.fieldList = "countryCode,name,company,streetAddress,street2Address,locality,city,stateCode,postalCode";
		}
		if (this.showAddressBookSelect == undefined) {
			this.showAddressBookSelect = false;
		}
		if (this.showCountrySelect == undefined) {
			this.showCountrySelect = true;
		}
		if (this.action == undefined) {
			this.showSubmitButton = false;
		}

        let addressName = this.addressName;

        if(this.address){
            this.address.getData = function(){
                let formData = {};
                let form = this.forms[addressName];
                for(let key in form){
                    let val = form[key];
                    if(typeof val === 'object' && val.hasOwnProperty('$modelValue')){
                        console.log(val);
                        if(val.$modelValue){
                            val = val.$modelValue;
                        }else if(val.$viewValue){
                            val = val.$viewValue;
                        }

                        if(angular.isString(val)){
                            formData[key] = val;
                        }
                        if(val.$modelValue){
                            formData[key] = val.$modelValue;
                        }else if(val.$viewValue){
                            formData[key] = val.$viewValue;
                        }
                    }
                }
                return formData || "";
            }
        } 
    }

	public getAction = () => {
		if (!angular.isDefined(this.action)){
			this.action="addAddress";
		}

		if (this.action.indexOf(":") != -1 && this.action.indexOf(this.param) == -1){
			this.action = this.param + this.action;

		}
		return this.action;
	}

	public hasField = (field) => {
		if (this.fieldList.indexOf(field) != -1) {
			return true;
		}
		return false;
	}

} 

class SWAddressForm implements ng.IComponentOptions {

    public templateUrl:string = "";
    public bindings:any;
    public controller:any=SWAddressFormController;
    public controllerAs:string='SwAddressForm';
    public template:string;
    public bindToController = {
        action: '@',
        actionText: '@',
        customPartial:'@',
        slatwallScope: '=',
        address: "=",
        id: "@?",
        fieldNamePrefix: "@",
        fieldList: "@",
        fieldClass: "@",
        tabIndex: "@",
        addressName: "@",
        showAddressBookSelect: "@",
        showCountrySelect: "@",
        showSubmitButton: "@",
        showAlerts: "@"
    };
    public scope={};
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        var directive = (
            coreFormPartialsPath,
            hibachiPathBuilder
        ) => new SWAddressForm(
            coreFormPartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = ['coreFormPartialsPath','hibachiPathBuilder'];
        return directive;
    }

    // @ngInject
    constructor( public coreFormPartialsPath, public hibachiPathBuilder) {
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + "addressform.html";
    }
}
export {SWAddressFormController, SWAddressForm};