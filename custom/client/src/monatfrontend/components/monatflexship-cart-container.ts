declare var angular;
class MonatFlexshipCartContainerController {
    public restrict = 'EA'
    public orderTemplateId: string;
    public orderTemplate:any; // orderTemplateDetails
    public orderTemplateItems: any[];
    public context:string;
    public isOpened: boolean = false;
    public orderTemplateItemTotal: number = 0;
    public showCanPlaceOrderAlert:false;
    public loading: boolean = false;
    
    public qualifiesForOFYAndFreeShipping = false;
    //@ngInject
    constructor(
    	public orderTemplateService, 
    	public rbkeyService,
    	public ModalService,
    	public observerService,
    	private monatAlertService,
    	public $location
    ) {   
        this.observerService.attach(this.fetchOrderTemplate,'addOrderTemplateItemSuccess');
        this.observerService.attach(this.fetchOrderTemplate,'removeOrderTemplateItemSuccess');
        this.observerService.attach(this.fetchOrderTemplate,'editOrderTemplateItemSuccess');
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
    
    public toggleOpened = () => {
        this.isOpened = !this.isOpened;
    }
    
    public previousEnrollmentStep = () => {
        this.observerService.notify('onPrevious');
    }
    
    private setOrderTemplate = ( orderTemplate ) => {
        this.orderTemplate = orderTemplate;
        this.qualifiesForOFYAndFreeShipping = this.orderTemplate.cartTotalThresholdForOFYAndFreeShipping <= this.orderTemplate.calculatedSubTotal;
    }

    private makeCurrentStepTranslation = ( currentStep:number=1, totalSteps:number=2 ) => {
    	 let stepsPlaceHolderData = {
    	 	'currentStep' : currentStep,
    	 	'totalSteps': totalSteps,
    	 };
    	 this.translations['currentStepOfTtotalSteps'] = this.rbkeyService.rbKey('frontend.flexshipCartContainer.currentStepOfTtotalSteps', stepsPlaceHolderData);
    	 this.translations['confirmFlexshipRemoveItemDialogTitleText'] = this.rbkeyService.rbKey('alert.frontend.confirmTitleTextDelete');
    	 this.translations['confirmFlexshipRemoveItemDialogBodyText'] = this.rbkeyService.rbKey('alert.frontend.confirmBodyTextDelete');
    }
    
    public next(){
        this.observerService.notify('onNext');
    }
    
    private fetchOrderTemplate = () => {
        this.loading = true;
		if(this.$location.search().orderTemplateId){
			this.orderTemplateId = this.$location.search().orderTemplateId;
		}else if(localStorage.getItem('flexshipID') && this.context == 'enrollment'){
		    this.orderTemplateId = localStorage.getItem('flexshipID');
		}
		
		if(!angular.isDefined(this.orderTemplateId) || this.orderTemplateId.trim().length == 0){
		    return; // if there's no orderTemplateID, we can't fetch the details
		}
		
		let extraProperties = "cartTotalThresholdForOFYAndFreeShipping";
		
		if(this.context == 'enrollment'){
		    extraProperties += ",canPlaceOrderFlag"; //mind the comma
		}
		
        this.orderTemplateService
        .getOrderTemplateDetails(this.orderTemplateId, extraProperties)
        .then(data => {
    		if(data.orderTemplate){
                this.setOrderTemplate( data.orderTemplate );
                this.orderTemplateItems = this.orderTemplate.orderTemplateItems;
    		} else {
    			throw(data);
    		}
        }).catch((error)=>{
            this.monatAlertService.showErrorsFromResponse(error);
        }).finally(()=>{
            this.loading = false;
        });
    }
    
    public showFlexshipConfirmDeleteItemModal = (item) => {
		this.ModalService.showModal({
		      component: 'monatConfirmMessageModel',
		      bodyClass: 'angular-modal-service-active',
			  bindings: {
			    title: this.translations['confirmFlexshipRemoveItemDialogTitleText'],
			    bodyText: this.translations['confirmFlexshipRemoveItemDialogBodyText']
			  },
			  preClose: (modal) => {
				modal.element.modal('hide');
			},
		}).then( (modal) => {
			modal.element.modal(); //it's a bootstrap element, using '.modal()' to show it
		    modal.close.then( (confirm) => {
		        if(confirm){
		            this.removeOrderTemplateItem(item);
		        }else{
		            item.loading=false;
		        }
		    });
		}).catch((error) => {
			console.error("unable to open showFlexshipConfirmModal :",error);	
		});
    }
    
    public removeOrderTemplateItem = (item) => {
    	this.orderTemplateService
    	.removeOrderTemplateItem(item.orderTemplateItemID)
    	.then( (data) => {
        	if(data.successfulActions && data.successfulActions.indexOf('public:order.removeOrderTemplateItem') > -1) {
				this.monatAlertService.success(this.rbkeyService.rbKey('alert.flexship.removeItemSuccessful'))
    		} else {
    		    throw (data);
            }
    	})
        .catch((error)=>{
            this.monatAlertService.showErrorsFromResponse(error);
        })
        .finally(()=>{
            this.loading = false;
        });
    }
    
    public increaseOrderTemplateItemQuantity = (item) => {
        this.loading = true;
    	this.orderTemplateService
    	.editOrderTemplateItem(item.orderTemplateItemID, item.quantity + 1)
    	.then( (data) => {
        	if(data.successfulActions && data.successfulActions.indexOf('public:order.editOrderTemplateItem') > -1) {
				this.monatAlertService.success(this.rbkeyService.rbKey('alert.flexship.editItemSuccessful'))
    		} else {
    		    throw (data);
            }
        }) 
        .catch((error)=>{
            this.monatAlertService.showErrorsFromResponse(error);
        }).finally(()=>{
            this.loading = false;
        });
    }
    
    public decreaseOrderTemplateItemQuantity = (item) => {
        this.loading = true;
    	this.orderTemplateService
    	.editOrderTemplateItem(item.orderTemplateItemID, item.quantity - 1)
    	.then( (data) => {
        	if(data.successfulActions && data.successfulActions.indexOf('public:order.editOrderTemplateItem') > -1) {
				this.monatAlertService.success(this.rbkeyService.rbKey('alert.flexship.editItemSuccessful'))
    		} else {
    		    throw (data);
            }
        }) 
        .catch((error)=>{
            this.monatAlertService.showErrorsFromResponse(error);
        }).finally(()=>{
            this.loading = false;
        });
        
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
    
    public template = require('./monatflexship-cart-container.html');

	public static Factory() {
		return () => new this();
	}
	public link = (scope, element, attrs) =>{
		
	}

}

export {
	MonatFlexshipCartContainer
};
