
class MonatFlexshipChangeOrSkipOrderModalController {
    public ChangeOrSkipOrderModal: {};
    constructor(public orderTemplateService) {
    }
    public $onInit = () => {};
}

class MonatFlexshipChangeOrSkipOrderModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'=',
	    orderTemplateId:'@'
	};
	public controller=MonatFlexshipChangeOrSkipOrderModalController;
	public controllerAs="monatFlexshipChangeOrSkipOrderModal";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipChangeOrSkipOrderModal(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexship-modal-changeorskiporder.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipChangeOrSkipOrderModal
};

