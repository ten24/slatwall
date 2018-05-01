/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWFPromoBox{
    public static Factory(){
        var directive = (
            $rootScope
        )=> new SWFPromoBox(
            $rootScope
        );
        directive.$inject = ['$rootScope'];
        return directive;
    }
    
    //@ngInject
    constructor(
        $rootScope
    ){
        return {
            restrict: "A",
            require:"^ngModel",
            link: function(scope, element, attributes, ngModel) {
                
                scope.addPromotionCode = (promoCode)=>{
                    scope.addPromotionCodeIsLoading = true;
                    let data = {
                        'promotionCode':promoCode
                    }
                    $rootScope.slatwall.doAction('addPromotionCode',data).then(result=>{
                        scope.result = result;
                        $rootScope.slatwall.cart = result.cart;
                        $rootScope.slatwall.account = result.account;
                        scope.addPromotionCodeIsLoading = false;
                    });
                }
                
                scope.removePromotionCode = (promoCode)=>{
                    scope.removePromotionCodeIsLoading = true;
                    let data = {
                        'promotionCode':promoCode.promotionCode
                    }
                    $rootScope.slatwall.doAction('removePromotionCode',data).then(result=>{
                        scope.result = result;
                        $rootScope.slatwall.cart = result.cart;
                        $rootScope.slatwall.account = result.account;
                        scope.removePromotionCodeIsLoading = false;
                    }); 
                }
            }
        };
    }
}
export{
    SWFPromoBox
}
