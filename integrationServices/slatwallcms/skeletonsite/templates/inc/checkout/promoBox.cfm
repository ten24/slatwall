<div class="promotion_code" swf-promo-box ng-cloak>
    <div class="alert alert-success" ng-show="slatwall.successfulActions.includes('public:cart.addPromotionCode')">Promotion successfully added.</div>
    <div class="alert alert-danger" ng-show="slatwall.errors.promotionCode" ng-bind="slatwall.errors.promotionCode[0]"></div>
    
    <label>Promotion Code</label>
    
    <input type="text" ng-model="promoCode" class="form-control" placeholder="Enter Promo Code..." required>
            
    <button 
        ng-disabled="swfPromoBox.addPromotionCodeIsLoading"
        ng-class="{disabled:swfPromoBox.addPromotionCodeIsLoading}"
        ng-click="swfPromoBox.addPromotionCode(promoCode)"
        class="btn btn-link">
        Apply
        <i ng-class="{'fa fa-refresh fa-spin fa-fw':swfPromoBox.addPromotionCodeIsLoading}"></i>
    </button>
    
    <span ng-repeat-start="appliedPromoCode in slatwall.cart.promotionCodes" class="badge badge-pill badge-primary" ng-bind="appliedPromoCode.promotion.promotionName"></span>
    
    <button ng-repeat-end ng-click="swfPromoBox.removePromotionCode(appliedPromoCode)" type="button btn-sm" class="btn btn-link btn-sm disabled">Remove</button>
    
    <i ng-class="{'fa fa-refresh fa-spin fa-fw':swfPromoBox.removePromotionCodeIsLoading}"></i>
</div>