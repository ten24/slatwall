
class MonatFlexshipCartContainerController {
    public orderTemplateId: string;
    public orderTemplate:any; // orderTemplateDetails
    public orderTemplateItems: any[];
    
    //@ngInject
    constructor(
    	public orderTemplateService, 
    	public rbkeyService,
    	public ModalService
    ) { }
    
    public $onInit = () => {
    	
    	this.makeTranslations();

        if (this.orderTemplate == null) {
            this.orderTemplateService.getOrderTemplateDetails(this.orderTemplateId)
            .then(
	            (response) => {
	                this.orderTemplate = response.orderTemplate;
	                this.orderTemplateItems = this.orderTemplate.orderTemplateItems;
	                //TODO handle errors / success
	            }, 
	            (reason) => {
	                throw (reason);
	            }
	        );
        }
        
    };
    
    public translations = {};
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    	this.makeCurrentStepTranslation();
    }
    
    public showFlexshipConfirmStep = () => {
        this.ModalService.closeModals();
		this.ModalService.showModal({
		      component: 'monatFlexshipConfirm',
			  bindings: {
			    orderTemplate: this.orderTemplate,
			  },
			  bodyClass: 'overlay'
		}).then((modal) => {
				  //it's not a bootstrap modal
			      modal.close.then(function(result) { 
			      	console.log("closing modal awesome, result: ", result);
			      });
			} 
		).catch((error) => {
			    console.error("unable to open model :",error);	
		});
        
    }

    private makeCurrentStepTranslation = ( currentStep:number=1, totalSteps:number=2 ) => {
    	 //TODO BL?
    	 let stepsPlaceHolderData = {
    	 	'currentStep' : currentStep,
    	 	'totalSteps': totalSteps,
    	 };
    	 this.translations['currentStepOfTtotalSteps'] = this.rbkeyService.rbKey('frontend.flexshipCartContainer.currentStepOfTtotalSteps', stepsPlaceHolderData);
    }
    
    private getOrderTemplateItemIndexByID = (orderTemplateItemID:string) => {
    	return this.orderTemplateItems.findIndex(it => it.orderTemplateItemID === orderTemplateItemID); 
    }
    
    public removeOrderTemplateItem = (item) => {
    	
    	this.orderTemplateService.removeOrderTemplateItem(item.orderTemplateItemID).then(
            (data) => {
            	if(data.successfulActions && data.successfulActions.indexOf('public:orderTemplate.removeItem') > -1) {
            		let index = this.getOrderTemplateItemIndexByID(item.orderTemplateItemID); 
    				this.orderTemplateItems.splice(index, 1);
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
            	if(data.orderTemplateItem) {
            		let index = this.getOrderTemplateItemIndexByID(item.orderTemplateItemID); 
    				this.orderTemplateItems[index] = data.orderTemplateItem;
        		} else {
        			console.error('increaseOrderTemplateItemQuantity res: ', data); 
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
            	if(data.orderTemplateItem) {
            		let index = this.getOrderTemplateItemIndexByID(item.orderTemplateItemID); 
    				this.orderTemplateItems[index] = data.orderTemplateItem;
        		} else {
        			console.error('decreaseOrderTemplateItemQuantity res: ', data); 
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

