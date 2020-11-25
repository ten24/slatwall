<!---- form element stops modal from closing ----->
<form> 
    <div ng-repeat-start="orderItem in slatwall.cart.orderItems" swf-cart-items order-item="orderItem" ng-cloak>
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
        <div class="row">
            <div class="col-3">
                <img class="img-fluid" ng-src="{{orderItem.sku.imagePath}}" alt="{{orderItem.sku.product.productName}}">
            </div>
            <div class="col-9">
                <h6><strong ng-bind="orderItem.sku.product.productName"></strong></h6>
                <span class="quantity">Qty: {{orderItem.quantity}}</span>
                <strong class="float-right" ng-bind="orderItem.extendedPriceAfterDiscount | currency"></strong>
            </div>
        </div>
    </div>
    <hr ng-repeat-end ng-if="!$last">
</form>