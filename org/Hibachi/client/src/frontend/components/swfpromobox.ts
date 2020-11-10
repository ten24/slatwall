/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWFPromoBoxController{
    //@ngInject
    public addPromotionCodeIsLoading:boolean;
    public removePromotionCodeIsLoading:boolean;
    public alertDisplaying:boolean = false;
    
    constructor(private $rootScope, private $timeout){
        this.$rootScope = $rootScope;
    }
    public addPromotionCode = (promoCode)=>{
        this.addPromotionCodeIsLoading = true;
        let data = {
            'promotionCode':promoCode
        }
        this.$rootScope.slatwall.doAction('addPromotionCode',data).then(result=>{
            this.addPromotionCodeIsLoading = false;
            this.displayAlert();
           
        });
    }
    public removePromotionCode = (promoCode)=>{
        this.removePromotionCodeIsLoading = true;
        let data = {
            'promotionCode':promoCode.promotionCode
        }
        this.$rootScope.slatwall.doAction('removePromotionCode',data).then(result=>{
            this.removePromotionCodeIsLoading = false;
        }); 
    }
    
    public displayAlert(){
        this.alertDisplaying = true
         this.$timeout(()=>{
            this.alertDisplaying = false;
        },3000);
    }
}

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
            controller:SWFPromoBoxController,
            controllerAs:"swfPromoBox",
            restrict: "A",
            link: function(scope, element, attributes, ngModel) {
            }
        };
    }
}
export{
    SWFPromoBoxController,
    SWFPromoBox
}
