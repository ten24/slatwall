/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWFCartItemsController{
    //@ngInject
    public updateOrderItemQuantityIsLoading:boolean;
    public removeOrderItemIsLoading:boolean;
    public orderItem:any;
    public loadingImages:any;
    
    constructor(private $rootScope, private observerService){
        this.loadingImages = true;
        this.$rootScope = $rootScope;
        this.$rootScope.slatwall.doAction('getResizedImageByProfileName',{profileName:'small',skuIds:this.orderItem.sku.skuID})
        .then((result:any)=>{
            this.orderItem.sku.smallImagePath = result.resizedImagePaths[this.orderItem.sku.skuID];
            this.loadingImages = false;
        });
    }
    
    public getProductDescriptionAndTruncate = (length=4000)=>{
        return this.stripHtml(this.orderItem.sku.product.productDescription).substring(0,length);
    }
    
    private stripHtml = (html)=>{
       let tmp = document.createElement("DIV");
       tmp.innerHTML = html;
       return tmp.textContent || tmp.innerText || "";
    }
    
    public updateOrderItemQuantity = (newQuantity,child?)=>{
        let orderItemID = child ? child.orderItemID : this.orderItem.orderItemID;
        this.updateOrderItemQuantityIsLoading = true;
        let data = {
                'orderItem.orderItemID':orderItemID,
                'orderItem.quantity':newQuantity
        };
        this.$rootScope.slatwall.doAction('updateOrderItemQuantity',data).then(result=>{
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
            this.removeOrderItemIsLoading = false;
        });
    }
    public clearCartItems = ()=>{
        let cartItems = this.$rootScope.slatwall.cart.orderItems;
        let data = {
            'orderItemIDList': ""
        };
        let orderItemIDs = [];
        for(var i=0; i<cartItems.length; i++){
            orderItemIDs.push(cartItems[i].orderItemID);
        }
        data['orderItemIDList'] = orderItemIDs.join();
        this.$rootScope.slatwall.doAction('removeOrderItem',data);
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
