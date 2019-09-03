import { IOrderTotalDetail } from "../models";

class MonatFlexshipOrderTotalCardController {
    public orderTotalDetail: IOrderTotalDetail;
    constructor(public orderTemplateService) {
    }
    public $onInit = () => {};
}

class MonatFlexshipOrderTotalCard {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTotalDetail:'='
	};
	public controller = MonatFlexshipOrderTotalCardController;
	public controllerAs = "monatFlexshipOrderTotalCard";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipOrderTotalCard(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexship-ordertotalcard.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipOrderTotalCard
};

