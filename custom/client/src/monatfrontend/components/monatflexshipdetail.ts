
class MonatFlexshipDetailController {
    public orderTemplateId: string;
    public orderTemplate: {};
    
    //@ngInject
    constructor(public orderTemplateService) {
    }
    
    public $onInit = () => {
        if (this.orderTemplate == null) {
            this.orderTemplateService.getOrderTemplateDetails(this.orderTemplateId)
            .then(
	            (response) => {
	                this.orderTemplate = response.orderTemplate;
	                console.log('ot', this.orderTemplate); 
	            }, 
	            (reason) => {
	                throw (reason);
	            }
	        );
        }
        
    };
}

class MonatFlexshipDetail {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplateId:'@',
	    orderTemplate:'<'
	};
	public controller=MonatFlexshipDetailController;
	public controllerAs="monatFlexshipDetail";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipDetail(
			monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        );
        directive.$inject = [
			'monatFrontendBasePath',
			'$hibachi',
			'rbkeyService',
			'requestService'
        ];
        return directive;
    }

	constructor(private monatFrontendBasePath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexshipdetail.html";
		this.restrict = "EA";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipDetail
};

