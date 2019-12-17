
class MonatFlexshipAddGiftCardModalController {
	public orderTemplate; 
	public giftCards;
	public close; // injected from angularModalService
	public loading: boolean = false;
	public selectedGiftCard;
	public amountToApply;
	public hasGiftCards = false;

    //@ngInject
	constructor(public orderTemplateService, public observerService, public rbkeyService, public monatAlertService) { }
    
    public $onInit = () => {
    	this.fetchGiftCrds();
    	this.makeTranslations();
    };
    
    private fetchGiftCrds() {
        this.loading = true;
    	this.orderTemplateService.getAccountGiftCards()
    	.then( (giftCards) => {
    	    if(giftCards) {
    	        this.hasGiftCards = true;
    		    this.giftCards = giftCards;
    	    } else {
    	        this.monatAlertService.error(this.rbkeyService.rbKey('frontend.flexshipAddGiftCardModal.noGiftavailbale'))
    	        throw(giftCards);
    	    }
    	})
    	.catch( (error) => {
    		this.monatAlertService.showErrorsFromResponse(error);
    	}).finally(()=>{
    	    this.loading = false;
    	});
    }
    
    public translations = {};
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    	 this.translations['giftCards'] = this.rbkeyService.rbKey('frontend.flexshipAddGiftCardModal.giftCards');
    	 this.translations['amountToApply'] = this.rbkeyService.rbKey('frontend.flexshipAddGiftCardModal.amountToApply');
    }
    
    public setSelectedGiftCard( giftCard ) {
    	this.selectedGiftCard = giftCard;
    }
    
    public applyGiftCard() {

    	//TODO frontend validation
		this.loading = true;
		
    	// make api request
        this.orderTemplateService.applyGiftCardToOrderTemplate(
        	this.orderTemplate.orderTemplateID, 
        	this.selectedGiftCard.giftCardID,
        	this.amountToApply
	    ).then(data => {
        	if(data.orderTemplate) {
                this.orderTemplate = data.orderTemplate;
                this.observerService.notify("orderTemplateUpdated" + data.orderTemplate.orderTemplateID, data.orderTemplate);
                this.monatAlertService.success("GiftCard has been successfully added to the flexship");
                this.closeModal();
        	} else {
        		throw(data);
        	}
        }).catch(error => {
            this.monatAlertService.showErrorsFromResponse(error);
        }).finally(() => {
        	this.loading = false;
        });
    }
    
    public closeModal = () => {
     	this.close(null);
    };
}

class MonatFlexshipAddGiftCardModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'<',
	    close:'=' //injected by angularModalService
	};
	public controller=MonatFlexshipAddGiftCardModalController;
	public controllerAs="monatFlexshipAddGiftCardModal";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipAddGiftCardModal(
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

	//@ngInject
	constructor(private monatFrontendBasePath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexship-modal-add-giftcard.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipAddGiftCardModal
};

