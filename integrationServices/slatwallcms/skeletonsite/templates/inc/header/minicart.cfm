<!---- form element stops modal from closing ----->
<form class="text-center"> 
    <swf-alert data-alert-trigger="removeOrderItemSuccess" data-alert-type="success" data-message="Item removed from cart" data-duration="3"></swf-alert>
    <swf-alert data-alert-trigger="removeOrderItemFailure" data-alert-type="danger" data-message="Item removed failure" data-duration="3"></swf-alert>
    <swf-alert data-alert-trigger="updateOrderItemSuccess" data-alert-type="success" data-message="Quantity Updated" data-duration="3"></swf-alert>
    <swf-alert data-alert-trigger="updateOrderItemFailure" data-alert-type="danger" data-message="Quantity update failure" data-duration="3"></swf-alert>
    <swf-alert data-alert-trigger="clearSuccess" data-alert-type="success" data-message="Cart Cleared" data-duration="3"></swf-alert>
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
        <li ng-if="$last" class="row">
            <div class="col-12 text-center">
                <button ng-click="swfCartItems.clearCartItems()" class="btn btn-info">Clear Cart</button>
                <button class="btn btn-primary">Continue To Checkout</button>
            </div>    
        </li>
        <hr ng-repeat-end ng-if="!$last">
        <!-- don't show horizontal rule if last element in loop -->
            
    </ul>
</form>