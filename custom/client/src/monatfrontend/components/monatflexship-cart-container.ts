
class MonatFlexshipCartContainerController {
    public orderTemplateId: string;
    public orderTemplate:any; // orderTemplateDetails
    public orderTemplateItems: any[];
    constructor(public orderTemplateService) {
    }
    public $onInit = () => {
    	console.warn('FLX cart', this);
    	
        if (this.orderTemplate == null) {
            this.orderTemplateService.getOrderTemplateDetails(this.orderTemplateId)
            .then(
	            (response) => {
	                this.orderTemplate = response.orderTemplate;
	                this.orderTemplateItems = this.orderTemplate.orderTemplateItems;
	                console.log('FLX cart container ot: ', this.orderTemplate); 
	                //TODO handle errors / success
	            }, 
	            (reason) => {
	                throw (reason);
	            }
	        );
        }
        
    };
    
    public removeOrderTemplateItem = (item) => {
    	
    	this.orderTemplateService.removeOrderTemplateItem(item.orderTemplateItemID).then(
            (data) => {
            	if(data.successfulActions && data.successfulActions.indexOf('public:orderTemplate.removeItem') > -1) {
            		let index = this.orderTemplateItems.findIndex(it => it.id === item.orderTemplateItemID); //find index in your array
    				this.orderTemplateItems = this.orderTemplateItems.splice(index, 1).splice(index, 1);//remove element from array
 
        		} else {
                	console.log('removeOrderTemplateItem res: ', data); 
            	}
            	//TODO handle errors / success
            	
            }, (reason) => {
                throw (reason);
            }
        );
    }
    
    public increaseOrderTemplateItemQuantity = (item) => {

    	this.orderTemplateService.editOrderTemplateItem(item.orderTemplateItemID, item.quantity + 1).then(
            (data) => {
            	console.log('increaseOrderTemplateItemQuantity res: ', data); 
            	if(data.orderTemplateItem) {
            		let index = this.orderTemplateItems.findIndex(it => it.id === data.orderTemplateItem.orderTemplateItemID); //find index in your array
    				this.orderTemplateItems[index] = data.orderTemplateItem;//replace element from array
        		} else {
            	}
            	//TODO handle errors / success
            	
            }, (reason) => {
                throw (reason);
            }
        );
    }
    
     public decreaseOrderTemplateItemQuantity = (item) => {
    	this.orderTemplateService.editOrderTemplateItem(item.orderTemplateItemID, item.quantity - 1).then(
            (data) => {
            	console.log('decreaseOrderTemplateItemQuantity res: ', data); 
            	if(data.orderTemplateItem) {
            		let index = this.orderTemplateItems.findIndex(it => it.id === data.orderTemplateItem.orderTemplateItemID); //find index in your array
    				this.orderTemplateItems[index] = data.orderTemplateItem;//replace element from array
        		} else {
            	}
            	//TODO handle errors / success
            	
            }, (reason) => {
                throw (reason);
            }
        );
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

