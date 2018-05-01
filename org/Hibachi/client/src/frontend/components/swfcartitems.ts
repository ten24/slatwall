/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
 
class SWFCartItems{
    public static Factory(){
        var directive = (
            $rootScope
        )=> new SWFCartItems(
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
            require: "^ngModel",

            link: function(scope, element, attributes, ngModel) {
                console.log($rootScope.slatwall);
                
                scope.updateOrderItemQuantity = (newQuantity,child?)=>{
                    let orderItemID = child ? child.orderItemID : scope.orderItem.orderItemID;
                    scope.updateOrderItemQuantityIsLoading = true;
                    let data = {
                            'orderItem.orderItemID':orderItemID,
                            'orderItem.quantity':newQuantity
                    };
                    $rootScope.slatwall.doAction('updateOrderItemQuantity',data).then(result=>{
                        $rootScope.slatwall.cart = result.cart;
                        $rootScope.slatwall.account = result.account;
                        scope.updateOrderItemQuantityIsLoading = false;
                    });
                }
                
                scope.removeOrderItem = (child?)=>{
                    let orderItemID = child ? child.orderItemID  : scope.orderItem.orderItemID;
                    scope.removeOrderItemIsLoading = true;
                    let data = {
                        'orderItemID':scope.orderItem.orderItemID
                    };
                    $rootScope.slatwall.doAction('removeOrderItem',data).then(result=>{
                        $rootScope.slatwall.cart = result.cart;
                        $rootScope.slatwall.account = result.account;
                        scope.removeOrderItemIsLoading = false;
                    });
                }
            }
        };
    }
}
export{
    SWFCartItems
}
