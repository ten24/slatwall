class MonatFlexshipDetailController {
    public orderTemplateID: string;
    public orderTemplate: any;
    constructor(public orderTemplateService) {
    }
    public $onInit = () => {
        if (this.orderTemplate == null) {
            this.orderTemplateService.getOrderTemplate(this.orderTemplateID).then((response) => {
                this.orderTemplate = response.orderTemplate;
            }, (reason) => {
                throw (reason);
            });
        }
    };
}

class MonatFlexshipDetail {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
	    orderTemplateID:'@',
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

