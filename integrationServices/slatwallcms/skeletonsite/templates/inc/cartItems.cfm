<div ng-if="false" class="alert alert-success">Item removed from cart</div>
<div ng-if="false" class="alert alert-danger">Item removed failure</div>
<div ng-if="false" class="alert alert-success">Quantity updated</div>
<div ng-if="false" class="alert alert-danger">Quantity update failure</div>

<div class="row" ng-repeat-start="orderItem in slatwall.cart.orderItems" swf-cart-items ng-model="orderItem">

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

    <div class="col-12 col-sm-12 col-md-2 text-center">
        <img class="img-fluid" ng-src="{{orderItem.sku.imagePath}}" alt="preview">
    </div>
    
    <div class="col-12 text-sm-center col-sm-12 text-md-left col-md-4">
        <small class="text-secondary" ng-bind="orderItem.sku.product.productType.productTypeName"></small>
        <h4><a href="##" ng-bind="orderItem.sku.product.productName"></a></h4>
        <small ng-if="orderItem.sku.skuCode"><strong>Sku Code: </strong>{{orderItem.sku.skuCode}}</small>
        <p ng-if="orderItem.sku.skuDefinition" class="mb-3"><small><strong>SKU Defintion Label: </strong>{{orderItem.sku.skuDefinition}}</small></p>
    </div>
    
    <div class="col-12 col-sm-12 text-sm-center col-md-6 text-md-right row">
        <div class="col-3 col-sm-3 col-md-4 text-md-right pt-2">
            <h6>{{orderItem.extendedUnitPriceAfterDiscount | currency}} <small class="text-muted" ng-if="orderItem.extendedPriceAfterDiscount < orderItem.extendedPrice"><s ng-bind="orderItem.extendedUnitPrice | currency"></s></small></h6>
        </div>
        <div class="col-3 col-sm-3">
            <input
                type="number" 
                class="form-control"
                min="1" 
                ng-value="orderItem.quantity" 
                ng-model="newQuantity" 
                ng-change="updateOrderItemQuantity(newQuantity)" 
            required>
        </div>
        <div class="col-4 col-sm-3 text-md-right pt-2">
            <i ng-show="updateOrderItemQuantityIsLoading" class="fa fa-refresh fa-spin fa-fw float-left mb-2 mr-1"></i>
            <h6><strong ng-bind="orderItem.extendedPriceAfterDiscount | currency"></strong></h6>
        </div>
        <div class="col-2 col-sm-2 text-right">
            <button ng-show="!removeOrderItemIsLoading" ng-click="removeOrderItem()" type="button" class="btn btn-danger btn-sm rounded">&times;</button>
            <button ng-show="removeOrderItemIsLoading" type="button" class="btn btn-danger btn-sm rounded disabled"><i class="fa fa-refresh fa-spin fa-fw"></i></button>
        </div>
    </div>
</div>
<!-- If Nested child order item -->
<div ng-if="orderItem.childOrderItems.length" ng-repeat="child in orderItem.childOrderItems" class="row mt-2">
    
    <div class="col-12 text-sm-center col-sm-12 text-md-left col-md-4 offset-lg-2">
        <small class="text-secondary" ng-bind="child.sku.product.productType.productTypeName"></small>
        <h6><a href="##" ng-bind="child.sku.product.productName"></a></h6>
        <small ng-if="child.sku.skuCode"><strong>Sku Code: </strong>{{child.sku.skuCode}}</small>
        <p ng-if="child.sku.skuDefinition" class="mb-3"><small><strong>SKU Defintion Label: </strong>{{child.sku.skuDefinition}}</small></p>
    </div>
    
    <div class="col-12 col-sm-12 text-sm-center col-md-6 text-md-right row">
        <div class="col-3 col-sm-3 col-md-4 text-md-right pt-1">
            <small>{{child.extendedUnitPriceAfterDiscount | currency}} <span class="text-muted" ng-if="child.extendedPriceAfterDiscount < child.extendedPrice"><s ng-bind="child.extendedUnitPrice | currency"></s></span></small>
        </div>
        <div class="col-3 col-sm-3">
            <input 
                type="number" 
                class="form-control form-control-sm text-center" 
                min="1" 
                ng-value="child.quantity" 
                ng-model="childQuantity"
                ng-change="updateOrderItemQuantity(newQuantity,child)" 
            required>
        </div>
        <div class="col-3 col-sm-3 text-md-right pt-1">
            <i ng-show="updateOrderItemQuantityIsLoading" class="fa fa-refresh fa-spin fa-fw float-left mt-1 mr-1"></i>
            <small><strong ng-bind="child.extendedPriceAfterDiscount | currency"></strong></small>
        </div>
        <div class="col-2 col-sm-2 text-right">
            <button ng-show="!removeOrderItemIsLoading" ng-click="removeOrderItem(child)" type="button" class="btn btn-danger btn-sm rounded">&times;</button>
            <button ng-show="removeOrderItemIsLoading" type="button" class="btn btn-danger btn-sm rounded disabled" ng-if="false"><i class="fa fa-refresh fa-spin fa-fw"></i></button>
        </div>
    </div>
    
</div>
<!-- don't show horizontal rule if last element in loop -->
<hr ng-repeat-end ng-if="!$last">