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

	public restrict = 'E'
	public templateUrl:string;
	public bindToController = {
	
	};
	
	public controller = ProductListingStepController;
	public controllerAs = "productListingStep";

	public template = require('./productlistingstep.html');

	public static Factory() {
		return () => new this();
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	ProductListingStep
};

