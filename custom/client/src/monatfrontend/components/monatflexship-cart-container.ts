class MonatFlexshipCartContainerController {
    public orderTemplateId: string;
    public orderTemplate:any; // orderTemplateDetails
    public orderTemplateItems: any[];
    public urlParams = new URLSearchParams(window.location.search);
    public context:string;
    public canPlaceOrder:boolean;
    public isOpened: boolean = false;
    public orderTemplateItemTotal: number = 0;
    public showCanPlaceOrderAlert:false;
    public loading: boolean = false;
    
    //@ngInject
    constructor(
    	public orderTemplateService, 
    	public rbkeyService,
    	public ModalService,
    	public observerService,
    	private monatAlertService
    ) {   
        this.observerService.attach(this.fetchOrderTemplate,'addItemSuccess');
        this.observerService.attach(this.fetchOrderTemplate,'removeItemSuccess');
        this.observerService.attach(this.fetchOrderTemplate,'editItemSuccess');
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
        
        // Update the order quantity based on data returned. 
        // If we have order items, we will grab the length, if not, grab the calculated total.
        this.orderTemplateItemTotal = 0;
        if ( 'undefined' !== typeof orderTemplate.orderTemplateItems ) {
            this.orderTemplateItemTotal = orderTemplate.orderTemplateItems.length;
        } else if ( 'undefined' !== typeof orderTemplate.calculatedOrderTemplateItemsCount ) {
            this.orderTemplateItemTotal = +orderTemplate.calculatedOrderTemplateItemsCount;
        }
    }

    private makeCurrentStepTranslation = ( currentStep:number=1, totalSteps:number=2 ) => {
    	 //TODO BL?
    	 let stepsPlaceHolderData = {
    	 	'currentStep' : currentStep,
    	 	'totalSteps': totalSteps,
    	 };
    	 this.translations['currentStepOfTtotalSteps'] = this.rbkeyService.rbKey('frontend.flexshipCartContainer.currentStepOfTtotalSteps', stepsPlaceHolderData);
    	 this.translations['title'] = this.rbkeyService.rbKey('frontend.flaxship.confirmTitleTextDelete');
    	 this.translations['bodyText'] = this.rbkeyService.rbKey('frontend.flaxship.confirmBodyTextDelete');
    }
    
    public next(){
        this.observerService.notify('onNext');
    }
    
    private fetchOrderTemplate = () => {
        this.loading = true;
		if(this.urlParams.get('orderTemplateId')){
			this.orderTemplateId = this.urlParams.get('orderTemplateId');
		}else if(localStorage.getItem('flexshipID') && this.context == 'enrollment'){
		    this.orderTemplateId = localStorage.getItem('flexshipID');
		}
		
        this.orderTemplateService
        .getOrderTemplateDetails(this.orderTemplateId)
        .then(data => {
    		if(data.orderTemplate){
                this.setOrderTemplate( data.orderTemplate );;
                this.orderTemplateItems = this.orderTemplate.orderTemplateItems;
                this.canPlaceOrder = this.orderTemplate.canPlaceOrderFlag;
    		} else {
    			throw(data);
    		}
        }).catch((error)=>{
            this.monatAlertService.showErrorsFromResponse(error);
        }).finally(()=>{
            this.loading = false;
        });
    }
    
    private getOrderTemplateItemIndexByID = (orderTemplateItemID:string) => {
    	return this.orderTemplateItems.findIndex(it => it.orderTemplateItemID === orderTemplateItemID); 
    }
    
    public showFlexshipConfirmDeleteItemModal = (item) => {
		this.ModalService.showModal({
		      component: 'monatFlexshipConfirmMessageModel',
		      bodyClass: 'angular-modal-service-active',
			  bindings: {
			    title: this.translations['title'],
			    bodyText: this.translations['bodyText']
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
    	this.orderTemplateService.removeOrderTemplateItem(item.orderTemplateItemID).then(
            (data) => {
            	if(data.successfulActions && data.successfulActions.indexOf('public:orderTemplate.removeItem') > -1) {
            		let index = this.getOrderTemplateItemIndexByID(item.orderTemplateItemID); 
    				this.orderTemplateItems.splice(index, 1);
    				if(data.orderTemplate){
    					this.setOrderTemplate( data.orderTemplate );
    					this.monatAlertService.success(this.rbkeyService.rbKey('alert.flaxship.removeItemsucessfull'))
    				}
        		} else {
        		    throw (data);
            	}})
                .catch((error)=>{
                    this.monatAlertService.showErrorsFromResponse(error);
                })
                .finally(()=>{
                    this.loading = false;
                });
    }
    
    public increaseOrderTemplateItemQuantity = (item) => {
            this.loading = true;
    	this.orderTemplateService.editOrderTemplateItem(item.orderTemplateItemID, item.quantity + 1).then(
            (data) => {
            	if(data.orderTemplateItem) {
            		let index = this.getOrderTemplateItemIndexByID(item.orderTemplateItemID); 
    				this.orderTemplateItems[index] = data.orderTemplateItem;
    				
    				if(data.orderTemplate){
    					this.setOrderTemplate( data.orderTemplate );;
    				}
        		} else {
        		    throw(data);
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
    	this.orderTemplateService.editOrderTemplateItem(item.orderTemplateItemID, item.quantity - 1).then(
            (data) => {
            	if(data.orderTemplateItem) {
            		let index = this.getOrderTemplateItemIndexByID(item.orderTemplateItemID); 
    				this.orderTemplateItems[index] = data.orderTemplateItem;
    				
    				if(data.orderTemplate){
    					this.setOrderTemplate( data.orderTemplate );;
    				}
    				
        		} else {
        		    throw(data);
            	}
            })
            .catch((error)=>{
            this.monatAlertService.showErrorsFromResponse(error);
            })
            .finally(()=>{
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
