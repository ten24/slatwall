
class PromoModalController {
	public close; // injected from angularModalService
	public loading;
	public cart;
	public promotions;
	public selectedPromotion;
	public currentPage;
	public rewardSkus;
    private maxUseCount: number;
    private maxUsePerItem: number;
	
    //@ngInject
    constructor(public rbkeyService, public observerService, public publicService, public monatService, private ModalService, private monatAlertService) {
        // this.observerService.attach(this.closeModal,'saveEnrollmentSuccess')
        this.cart = monatService.cart;
        this.promotions = this.cart.qualifiedMerchandiseRewardsArray;
        this.selectPromotion(this.promotions[0]);
        this.currentPage = 'promoList';
        
        this.observerService.attach(this.closeModal,'addOrderItemSuccess');
    }
    
    public selectPromotion = (promotion)=>{
        if(!promotion.title){
            promotion.title = promotion.promotionPeriod.promotion.promotionName;
        }
        if(!promotion.rewardHeader){
            promotion.rewardHeader = promotion.title
        }
        if(!promotion.description){
            promotion.description = promotion.promotionPeriod.promotion.promotionName;
        }
        this.selectedPromotion = promotion;
    }
    
    public viewSelectedPromotion = ()=>{
        this.loading = true;
        this.monatService.getPromotionRewardSkus(this.selectedPromotion.promotionRewardID).then(skuArray=>{
            this.rewardSkus = this.formatRewardSkus(skuArray);
            this.selectedPromotion.currentUseCount = 0;
            this.currentPage = 'reward';
            this.loading=false;
        });
        this.setCurrentQualificationLimits(this.selectedPromotion);
    }
    
    public formatRewardSkus = (skuArray)=>{
        for(let sku of skuArray){
            sku.title = sku.product_productName;
            sku.listPrice = parseFloat(sku.listPrice);
            sku.listPrice = isNaN(sku.listPrice) ? sku.skuPrices_price : sku.listPrice;
            sku.addToCartQuantity = 0;
            
            var adjustmentAmount = this.selectedPromotion.amount;
            var adjustmentType = this.selectedPromotion.amountType;
            
            switch(adjustmentType){
                case 'amountOff':
                    sku.price = sku.skuPrices_price - adjustmentAmount;
                    break;
                case 'percentageOff':
                    sku.price = sku.skuPrices_price * (100-adjustmentAmount)/100;
                    break;
                case 'amount':
                    sku.price = adjustmentAmount;
                    break;
            }
        }
        return skuArray;
    }
    
    public updateQuantity = (sku,delta)=>{
        sku.addToCartQuantity += delta;
        this.selectedPromotion.currentUseCount += delta;
        if( ( this.maxUseCount && this.selectedPromotion.currentUseCount > this.maxUseCount )
            || ( this.maxUsePerItem && sku.addToCartQuantity > this.maxUsePerItem )
            || sku.addToCartQuantity > sku.stocks_calculatedQATS
            || sku.addToCartQuantity < 0){
            this.updateQuantity(sku,-delta);
        }
    }
    
    public addToCart = () =>{
        let skuIds=[], quantities=[]
        for(let sku of this.rewardSkus){
            if(sku.addToCartQuantity > 0){
                skuIds.push(sku.skuID);
                quantities.push(sku.addToCartQuantity);
            }
        }
        if(skuIds.length){
            this.loading=true;
            let data = {
                skuIds: skuIds.join(','),
                quantities: quantities.join(',')
            };
            this.monatService.addMultipleToCart(data).then(result=>{
                if(result.hasErrors){
    				this.monatAlertService.showErrorsFromResponse(result);
    			}else{
    				this.monatAlertService.success(this.rbkeyService.rbKey('alert.cart.addProductSuccessful'));
    			}
            }).catch(err=>{
                console.error(err);
                this.monatAlertService.showErrorsFromResponse(err);
            }).finally(()=>{
                this.loading=false;
            });
        }
    }
    
    public setCurrentQualificationLimits(promotion){
        let maxUseCount;
        const qualifications = parseInt(promotion.qualifications);
        const maxUsePerQualification = parseInt(promotion.maximumUsePerQualification);
        const maxUsePerOrder = parseInt(promotion.maximumUsePerOrder);
        const maxUsePerItem = parseInt(promotion.maximumUsePerItem);
        
        if(!isNaN(maxUsePerQualification)){
            maxUseCount = qualifications * maxUsePerQualification;
        }
        if(!isNaN(maxUsePerOrder)){
            maxUseCount = Math.min(maxUseCount,maxUsePerOrder);
        }
        
        this.maxUseCount = maxUseCount;
        
        if(!isNaN(maxUsePerItem)){
            this.maxUsePerItem = maxUsePerItem;
        }
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
