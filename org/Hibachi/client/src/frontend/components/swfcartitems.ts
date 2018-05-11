/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWFCartItemsController{
    //@ngInject
    public updateOrderItemQuantityIsLoading:boolean;
    public removeOrderItemIsLoading:boolean;
    public orderItem:any;
    
    constructor(private $rootScope){
        this.$rootScope = $rootScope;
    }
    public updateOrderItemQuantity = (newQuantity,child?)=>{
        let orderItemID = child ? child.orderItemID : this.orderItem.orderItemID;
        this.updateOrderItemQuantityIsLoading = true;
        let data = {
                'orderItem.orderItemID':orderItemID,
                'orderItem.quantity':newQuantity
        };
        this.$rootScope.slatwall.doAction('updateOrderItemQuantity',data).then(result=>{
            this.$rootScope.slatwall.cart = result.cart;
            this.$rootScope.slatwall.account = result.account;
            this.$rootScope.slatwall.successfulActions = result.successfulActions;
            this.$rootScope.slatwall.errors = result.errors;
            this.updateOrderItemQuantityIsLoading = false;
        });
    }
    public removeOrderItem = (child?)=>{
        let orderItemID = child ? child.orderItemID  : this.orderItem.orderItemID;
        this.removeOrderItemIsLoading = true;
        let data = {
            'orderItemID':this.orderItem.orderItemID
        };
        this.$rootScope.slatwall.doAction('removeOrderItem',data).then(result=>{
            this.$rootScope.slatwall.cart = result.cart;
            this.$rootScope.slatwall.account = result.account;
            this.$rootScope.slatwall.successfulActions = result.successfulActions;
            this.$rootScope.slatwall.errors = result.errors;
            this.removeOrderItemIsLoading = false;
        });
    }
}
 
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
            controller:SWFCartItemsController,
            controllerAs:"swfCartItems",
            bindToController: {
                orderItem: "<"
            },
            restrict: "A",
            link: function(scope, element, attributes, ngModel) {
            }
        };
    }
}
export{
    SWFCartItemsController,
    SWFCartItems
}
