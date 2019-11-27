
class MonatFlexshipCartContainerController {
    public orderTemplateId: string;
    public orderTemplate:any; // orderTemplateDetails
    public orderTemplateItems: any[];
    public urlParams = new URLSearchParams(window.location.search);
    public context:string;
    public canPlaceOrder:boolean;
    
    //@ngInject
    constructor(
    	public orderTemplateService, 
    	public rbkeyService,
    	public ModalService,
    	public observerService
    ) { 
        this.observerService.attach(this.fetchOrderTemplate,'addItemSuccess') 
        this.observerService.attach(this.fetchOrderTemplate,'removeItemSuccess') 
    }
    
    public $onInit = () => {
    	
    	this.makeTranslations();
    	
    	if(this.orderTemplate == null) {
    		this.fetchOrderTemplate(); 
    	}
    };
    
    public translations = {};
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    	this.makeCurrentStepTranslation();
    }

    private makeCurrentStepTranslation = ( currentStep:number=1, totalSteps:number=2 ) => {
    	 //TODO BL?
    	 let stepsPlaceHolderData = {
    	 	'currentStep' : currentStep,
    	 	'totalSteps': totalSteps,
    	 };
    	 this.translations['currentStepOfTtotalSteps'] = this.rbkeyService.rbKey('frontend.flexshipCartContainer.currentStepOfTtotalSteps', stepsPlaceHolderData);
    }
    
    public next(){
        this.observerService.notify('onNext');
    }
    
    private fetchOrderTemplate = () => {
		if(this.urlParams.get('orderTemplateId')){
			this.orderTemplateId = this.urlParams.get('orderTemplateId');
		}else if(localStorage.getItem('flexshipID') && this.context == 'enrollment'){
		    this.orderTemplateId = localStorage.getItem('flexshipID');
		}
		
        this.orderTemplateService
        .getOrderTemplateDetails(this.orderTemplateId)
        .then(data => {
    		if(data.orderTemplate){
                this.orderTemplate = data.orderTemplate;
                this.orderTemplateItems = this.orderTemplate.orderTemplateItems;
                this.canPlaceOrder = this.orderTemplate.canPlaceOrderFlag;
                //TODO handle errors / success
    		} else {
    			throw(data);
    		}
        }).catch(error => {
        	//TODO deal with the error
        	throw(error); 
        }).finally(()=>{
        //TODO deal with the loader ui
        });
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
    				if(data.ordertemplate){
    					this.orderTemplate = data.orderTemplate;
    				}
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
    				
    				if(data.ordertemplate){
    					this.orderTemplate = data.orderTemplate;
    				}
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
    				
    				if(data.ordertemplate){
    					this.orderTemplate = data.orderTemplate;
    				}
    				
        		} else {
        			console.error('decreaseOrderTemplateItemQuantity res: ', data); 
            	}
            	//TODO handle errors / success
            }, (reason) => {
                throw (reason);
            }
        );
    }
    
    public showFlexshipConfirmModal = () => {
        this.ModalService.closeModals();
		this.ModalService.showModal({
		      component: 'monatFlexshipConfirm',
			  bindings: {
			    orderTemplate: this.orderTemplate,
			    redirectUrl: '/my-account/flexships/'
			  }
		}).then((modal) => {
			//it's not a bootstrap modal
		    modal.close.then(result => {});
		}).catch((error) => {
			console.error("unable to open showFlexshipConfirmModal :",error);	
		});
    }
}

class MonatFlexshipCartContainer {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplateId:'@',
	    orderTemplate:'<?',
	    context:'@?'
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

