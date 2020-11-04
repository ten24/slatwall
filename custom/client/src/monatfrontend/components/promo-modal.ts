
class PromoModalController {
	public close; // injected from angularModalService
	public loading;
	public cart;
	public promotions;
	public selectedPromotion;
	
    //@ngInject
    constructor(public rbkeyService, public observerService, public publicService, public monatService) {
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
    
    public closeModal = () => {
     	this.close(null);
    }
    
}

class PromoModal {

	public restrict = 'E';
	
	public scope = {};
	public bindToController = {
		close:'=' //injected by angularModalService
	};
	
	public controller = PromoModalController;
	public controllerAs = "promoModal";

	public template = require('./promo-modal.html');

	public static Factory() {
		return () => new this();
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	PromoModal
};
