
<!---- form element stops modal from closing ----->
<form> 
    <div style="min-width: 300px;">
        <swf-alert data-alert-trigger="removeOrderItemSuccess" data-alert-type="success small" data-message="Item removed from cart" data-duration="3"></swf-alert>
        <swf-alert data-alert-trigger="removeOrderItemFailure" data-alert-type="danger small" data-message="Item removed failure" data-duration="3"></swf-alert>
        <swf-alert data-alert-trigger="updateOrderItemSuccess" data-alert-type="success small" data-message="Quantity Updated" data-duration="3"></swf-alert>
        <swf-alert data-alert-trigger="updateOrderItemFailure" data-alert-type="danger small" data-message="Quantity update failure" data-duration="3"></swf-alert>
        
        <div class="row" ng-repeat-start="orderItem in slatwall.cart.orderItems" swf-cart-items order-item="orderItem" ng-cloak>
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
            <div class="col-3">
                <a href="/{{slatwall.globalURLKeyProduct}}/{{orderItem.sku.product.urlTitle}}/">
                    <img class="img-fluid mt-2 text-center" ng-src="{{orderItem.sku.imagePath}}" ng-show="orderItem.sku.smallImagePath" alt="{{orderItem.sku.product.productName}}">
                </a>                    
            </div>
            
            <div class="col-9 pl-0">
                <a href="/{{slatwall.globalURLKeyProduct}}/{{orderItem.sku.product.urlTitle}}/" ng-bind="orderItem.sku.product.productName" class="small"></a>
                <div class="row mt-2">
                    <div class="col-4">
                        <input
                            type="number" 
                            class="form-control form-control-sm text-center"
                            min="1" 
                            ng-value="orderItem.quantity" 
                            ng-model="newQuantity" 
                            ng-change="swfCartItems.updateOrderItemQuantity(newQuantity)" 
                        required>
                    </div>
                    <div class="col-4">
                        <i ng-show="swfCartItems.updateOrderItemQuantityIsLoading" class="fa fa-refresh fa-spin fa-fw mb-2 mr-1"></i>
                        <small><strong ng-bind="orderItem.extendedPriceAfterDiscount | currency" ng-show="!swfCartItems.updateOrderItemQuantityIsLoading"></strong></small>
                    </div>
                    <div class="col-3">
                        <a  href="#"
                            ng-disabled="swfCartItems.removeOrderItemIsLoading" 
                            ng-click="swfCartItems.removeOrderItem()" 
                            ng-class="{disabled: swfCartItems.removeOrderItemIsLoading}">
                            <i ng-show="!swfCartItems.removeOrderItemIsLoading" class="fa fa-times-circle fa-lg text-secondary"></i>
                            <i ng-show="swfCartItems.removeOrderItemIsLoading" class="fa fa-refresh fa-spin fa-fw"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div ng-if="$last" class="mt-3 mb-2 text-center">
            <button ng-if="slatwall.cart.orderItems.length" ng-click="swfCartItems.clearCartItems()" class="btn btn-info btn-sm">Clear Cart</button>
            <a href="/shopping-cart/" class="btn btn-primary btn-sm">Go to Cart</a>
        </div>
        <hr ng-repeat-end ng-if="!$last">
    </div>
</form>
<div class="alert alert-info mb-0 small" ng-if="!slatwall.cart.orderItems.length">There are no items in your cart</div>