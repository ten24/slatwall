<!---- form element stops modal from closing ----->
<form class="text-center"> 
        <div ng-show="slatwall.successfulActions.includes('public:cart.removeOrderItem')" class="alert alert-success">Item removed from cart</div>
        <div ng-show="slatwall.failureActions.includes('public:cart.removeOrderItem')" class="alert alert-danger">Item removed failure</div>
        <div ng-show="slatwall.successfulActions.includes('public:cart.updateOrderItem')" class="alert alert-success">Quantity updated</div>
        <div ng-show="slatwall.failureActions.includes('public:cart.updateOrderItem')" class="alert alert-danger">Quantity update failure</div>
    
    <ul class="col-xs-12" style="min-width:400px;">
        <li class="row" ng-repeat-start="orderItem in slatwall.cart.orderItems" swf-cart-items order-item="orderItem" ng-cloak>
        <!---- the directive swf-cart-items passed in as an attribute above drives all the functionality in this template.
               all methods and variables (excluding the ones preceded by "slatwall") will be applied to the current orderItem 
               and belong to the swf-cart-items directive's scope.
               They are:
                METHODS
                    - updateOrderItemQuantity(newQuantity:number,child:optional)
                        Sets the current order item's quantity to the number passed in. The child parameter is optional
                        and will cause the change to be applied to that child order item instead of its parent
                        
                    - removeOrderItem(child:optional)
                        Removes the current order item. The child parameter is optional
                        and will cause the change to be applied to that child order item instead of its parent
                VARIABLES
                    - updateOrderItemQuantityIsLoading:boolean
                        flag that indicates if an update request is being loaded. Useful for driving loading spinners.
                    - removeOrderItemIsLoading:boolean
                        flag that indicates if a remove order item request is being loaded. Useful for driving loading spinners.
               ------>
        
            <div class="col-4 text-center">
                <img class="img-fluid" ng-src="{{orderItem.sku.imagePath}}" alt="preview">
                <h6><a href="##" ng-bind="orderItem.sku.product.productName"></a></h6>
            </div>
            
            <div class="col-8 text-center row">
                <div class="col-5">
                    <input
                        type="number" 
                        class="form-control"
                        min="1" 
                        ng-value="orderItem.quantity" 
                        ng-model="newQuantity" 
                        ng-change="swfCartItems.updateOrderItemQuantity(newQuantity)" 
                    required>
                </div>
                <div class="col-5">
                    <i ng-show="swfCartItems.updateOrderItemQuantityIsLoading" class="fa fa-refresh fa-spin fa-fw float-left mb-2 mr-1"></i>
                    <small><strong ng-bind="orderItem.extendedPriceAfterDiscount | currency"></strong></small>
                </div>
                <div class="col-2">
                        <button 
                            ng-disabled="swfCartItems.removeOrderItemIsLoading" 
                            ng-click="swfCartItems.removeOrderItem()" 
                            ng-class="{disabled: swfCartItems.removeOrderItemIsLoading}" 
                            type="button" 
                            class="btn btn-danger btn-sm rounded">
                            &times;
                            <i ng-show="swfCartItems.removeOrderItemIsLoading" class="fa fa-refresh fa-spin fa-fw"></i>
                        </button>
                </div>
            </div>
        </li>
        <hr ng-repeat-end ng-if="!$last">
        <!-- don't show horizontal rule if last element in loop -->
    </ul>
    <button class="btn btn-primary">Continue To Checkout</button>
</form>