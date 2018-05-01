<div class="card mb-5">
    <div class="card-header">
        <h5 class="mb-0">Order Summary</h5>
    </div>
    <div class="card-body p-0">
        <ul class="list-group list-group-flush">
            <li ng-if="slatwall.cart.subtotal" class="list-group-item">
                <span>Order Subtotal</span>
                <span class="float-right" ng-bind="slatwall.cart.subtotal | currency"></span>
            </li>
            <li ng-if="slatwall.cart.itemDiscountAmountTotal" class="list-group-item">
                <span>Item Discount Total</span>
                <span class="text-danger float-right" ng-bind=" '-' + slatwall.cart.itemDiscountAmountTotal | currency"></span>
            </li>
            <li ng-if="slatwall.cart.discountTotal" class="list-group-item">
                <span>Order Discount Total</span>
                <span class="text-danger float-right" ng-bind="'-' + slatwall.cart.discountTotal | currency"></span>
            </li>
            <li ng-if="slatwall.cart.fulfillmentDiscountAmountTotal" class="list-group-item">
                <span>Shipping Discount Total</span>
                <span class="text-danger float-right" ng-bind="'-' + slatwall.cart.fulfillmentDiscountAmountTotal | currency"></span>
            </li>
            <li ng-if="slatwall.cart.fulfillmentTotal" class="list-group-item">
                <span>Shipping and handling</span>
                <span class="float-right" ng-bind="slatwall.cart.fulfillmentTotal | currency"></span>
            </li>
            <li ng-if="slatwall.cart.taxTotal" class="list-group-item">
                <span>Tax</span>
                <span class="float-right" ng-bind="slatwall.cart.taxTotal | currency"></span>
            </li>
            <li ng-if="slatwall.cart.total" class="list-group-item">
                <span>Total</span>
                <strong class="float-right" ng-bind="slatwall.cart.total | currency"></strong>
            </li>
        </ul>
    </div>
</div>
<!---<i class="fa fa-refresh fa-spin fa-fw float-right my-1 mr-1"></i>--->