
class PromoRewardModalController {
	public close; // injected from angularModalService
	public loading;
	public cart;
	public promotions;
	public selectedPromotion;
	
    //@ngInject
    constructor(public rbkeyService, public observerService, public publicService, public monatService, private ModalService) {
        // this.observerService.attach(this.closeModal,'saveEnrollmentSuccess')
        this.cart = monatService.cart;
        this.promotions = this.cart.qualifiedMerchandiseRewardsArray;
        this.selectPromotion(this.promotions[0]);
    }
    
    public selectPromotion = (promotion)=>{
        if(!promotion.title){
            promotion.title = promotion.promotionPeriod.promotion.promotionName;
        }
        if(!promotion.description){
            promotion.description = promotion.promotionPeriod.promotion.promotionName;
        }
        this.selectedPromotion = promotion;
    }
    
    public launchPromoRewardModal = ()=>{
        if(this.selectedPromotion){
            this.ModalService.showModal({
                component: 'promoRewardModal',
                bodyClass: 'angular-modal-service-active',
                bindings: {
                    title: this.rbkeyService.rbKey('frontend.enrollment.promoRewardModal'),
                },
                preClose: (modal) => {
                    modal.element.modal('hide');
    			},
    		}).then( (modal) => {
    			modal.element.modal(); //it's a bootstrap element, using '.modal()' to show it
    		    modal.close.then( (confirm) => {
    		    });
    		}).catch((error) => {
    			console.error("unable to open promoRewardModal :",error);	
    		});
    		this.closeModal();
        }
    }
    
    public closeModal = () => {
     	this.close(null);
    }
    
}

class PromoRewardModal {

	public restrict = 'E';
	
	public scope = {};
	public bindToController = {
		close:'=' //injected by angularModalService
	};
	
	public controller = PromoRewardModalController;
	public controllerAs = "promoRewardModal";

	public template = require('./promo-reward-modal.html');

	public static Factory() {
		return () => new this();
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	PromoRewardModal
};
