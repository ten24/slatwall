
class MonatFlexshipCartContainerController {
    public orderTemplateId: string;
    public orderTemplate:any; // orderTemplateDetails
    constructor(public orderTemplateService) {
    }
    public $onInit = () => {
    	console.warn('FLX cart', this);
    	
        if (this.orderTemplate == null) {
            this.orderTemplateService.getOrderTemplateDetails(this.orderTemplateId)
            .then(
	            (response) => {
	                this.orderTemplate = response.orderTemplate;
	                console.log('FLX cart container ot: ', this.orderTemplate); 
	            }, 
	            (reason) => {
	                throw (reason);
	            }
	        );
        }
        
    };
    
    public removeOrderTemplateItem = (item) => {
    	console.warn('removeOrderTemplateItem :', item);
    }
    
    public increaseOrderTemplateItemQuantity = (item) => {
    	console.warn('increaseOrderTemplateItemQuantity :', item);
    }
    
     public decreaseOrderTemplateItemQuantity = (item) => {
    	console.warn('decreaseOrderTemplateItemQuantity :', item);
    }
}

class MonatFlexshipCartContainer {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplateId:'@',
	    orderTemplate:'<?'
	};
	public controller=MonatFlexshipCartContainerController;
	public controllerAs="monatFlexshipCartContainer";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipCartContainer(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexship-cart-container.html";
		this.restrict = "EA";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipCartContainer
};

