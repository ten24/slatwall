<div class="order_sec">
    <ul>
        <li ng-if="slatwall.cart.subtotal != undefined">
            <span>Order Subtotal</span>
            <strong ng-bind="slatwall.cart.subtotal | currency"></strong>
        </li>
        <li ng-if="slatwall.cart.itemDiscountAmountTotal" class="list-group-item">
            <span>Item Discount Total</span>
            <strong ng-bind=" '-' + slatwall.cart.itemDiscountAmountTotal | currency"></strong>
        </li>
        <li ng-if="slatwall.cart.taxTotal != undefined">
            <span>Tax</span>
            <strong ng-bind="slatwall.cart.taxTotal | currency"></strong>
        </li>
        <li class="shipping" ng-if="slatwall.cart.fulfillmentDiscountAmountTotal">
            <span>Shipping Discount Total</span>
            <strong class="text-danger" ng-bind="'-' + slatwall.cart.fulfillmentDiscountAmountTotal | currency"></strong>
        </li>
        <li class="shipping" ng-if="slatwall.cart.fulfillmentTotal != undefined">
            <span>Shipping and handling</span>
            <strong ng-bind="slatwall.cart.fulfillmentTotal | currency"></strong>
        </li>
        <li ng-if="slatwall.cart.discountTotal">
            <span>Order Discount Total</span>
            <strong ng-bind="'-' + slatwall.cart.discountTotal | currency"></strong>
        </li>
        <li class="last" ng-if="slatwall.cart.total != undefined">
            <span>Order Total</span>
            <strong ng-bind="slatwall.cart.total | currency"></strong>
        </li>
    </ul>
    
    <cfif m.content('filename') EQ 'store-new/shopping-cart'>
        <div class="row">
            <div class="col-lg-6">
                <a href="/store-new/" class="btn btn-link">RETURN TO SHOPPING</a>
			</div>
            <div class="col-lg-6">
                <a href="/store-new/checkout/" class="btn btn-secondary big">CONTINUE TO CHECKOUT</a>
    		</div>
        </div>
    <cfelse>
        <button ng-disabled="swfNavigation.reviewTabDisabled" ng-click="slatwall.doAction('placeOrder')" class="btn btn-secondary big" ng-class="{disabled:slatwall.getRequestByAction('placeOrder').loading || slatwall.hasSuccessfulAction('placeOrder')}">{{slatwall.getRequestByAction('placeOrder').loading || slatwall.hasSuccessfulAction('placeOrder') ? '' : 'Place Order'}}
        <span ng-show="slatwall.getRequestByAction('placeOrder').loading || slatwall.hasSuccessfulAction('placeOrder')"><i class="fa fa-refresh fa-spin fa-fw"></i></span>
    </button>
    </cfif>
</div>