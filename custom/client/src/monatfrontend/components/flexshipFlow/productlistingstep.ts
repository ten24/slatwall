class ProductListingStepController {
	public FlexshipSteps;
	public orderTemplate;
	
    //@ngInject
    constructor(public orderTemplateService) {

    }
    
    public $onInit = () => { 
    }
	
}

class ProductListingStep {

	public restrict:string;
	public templateUrl:string;
	public bindToController = {
	
	};
	
	public controller = ProductListingStepController;
	public controllerAs = "productListingStep";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			rbkeyService,
        ) => new ProductListingStep(
			monatFrontendBasePath,
			rbkeyService,
        );
        directive.$inject = [
			'monatFrontendBasePath',
			'rbkeyService',
        ];
        return directive;
    }

	constructor(private monatFrontendBasePath, 
				private rbkeyService
	){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/flexshipFlow/productlistingstep.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	ProductListingStep
};

