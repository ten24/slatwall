class MonatFlexshipMenuController{
    
	public orderTemplate:any; 
	
	public accountAddresses: any[];
	public accountPaymentMethods: any[];
	public shippingMethodOptions: any[]; 
	public stateCodeOptions: any[];
	public cancellationReasonTypeOptions: any[];
	public scheduleDateChangeReasonTypeOptions: any[];
	
	public expirationMonthOptions: any[];
	public expirationYearOptions: any[];

	constructor( 
		public orderTemplateService,
		public observerService,
		public ModalService
	){

	}
	
	public $onInit = () =>{
	}
	
	public showCancelFlexshipModal = () => {
		this.ModalService.closeModals();
		this.ModalService.showModal({
		      component: 'monatFlexshipCancelModal',
			  bindings: {
			    orderTemplate: this.orderTemplate,
			    cancellationReasonTypeOptions: this.cancellationReasonTypeOptions
			  },
		      preClose: (modal) => { modal.element.modal('hide'); }
		}).then( 
			(modal) => {
				  //it's a bootstrap element, use 'modal' to show it
			      modal.element.modal();
			      
			      modal.close.then(function(result) { 
			      	//....
			      });
			}, 
			(error) => {
			    console.error("model error",error);	
			}
		);
	}
	
   public activateFlexship() {
 
    	let payload = {};
    	payload['orderTemplateID'] = this.orderTemplate.orderTemplateID;
 
    	payload = this.orderTemplateService.getFlattenObject(payload);
    	// make api request
        this.orderTemplateService.activate(payload).then(
            (data) => {
            	if(data.orderTemplate) {
	                this.orderTemplate = data.orderTemplate;
	                this.observerService.notify("orderTemplateUpdated" + data.orderTemplate.orderTemplateID, data.orderTemplate);
            	} else{
            		console.error(data);
            	}
            	// TODO: show alert
            }, 
            (reason) => {
                throw (reason);
                // TODO: show alert
            }
        );
    }
    

}

class MonatFlexshipMenu{

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
	    orderTemplate:'<',
	    accountAddresses:'<',
	    accountPaymentMethods:'<',
	    shippingMethodOptions: '<',
	    stateCodeOptions: '<',
	    cancellationReasonTypeOptions: '<',
	    scheduleDateChangeReasonTypeOptions: '<',
	    expirationMonthOptions: '<',
		expirationYearOptions: '<'
	};
	public controller=MonatFlexshipMenuController;
	public controllerAs="monatFlexshipMenu";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipMenu(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexshipmenu.html";
		this.restrict = "EA";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipMenu
};

