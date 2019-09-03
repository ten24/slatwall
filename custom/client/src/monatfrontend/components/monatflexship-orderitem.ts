import { IOrderItem } from "../models";

class MonatFlexshipOrdereItemController {
    public orderItem: IOrderItem;
    constructor(public orderTemplateService) {
    }
    public $onInit = () => {};
}

class MonatFlexshipOrderItem {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderItem:'='
	};
	public controller=MonatFlexshipOrdereItemController;
	public controllerAs="monatFlexshipOrderItem";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipOrderItem(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexship-orderitem.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipOrderItem
};

