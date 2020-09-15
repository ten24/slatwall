<cfoutput>
<!--- Place Order alert fail --->
<div class="alert alert-danger" ng-show="slatwall.requests['placeOrder'].failureActions.length">Order could not be placed.</div>

<div class="row">
    <div class="col-md-6">
        <!--- Shipping  --->
        <div class="card-deck mb-3">
            <!--- Shipping Address --->
            <address class="card">
                <div class="card-header">
                    <i class="fa fa-check-circle"></i> Shipping
                </div>
                <div class="card-body">
                    <strong ng-bind="slatwall.cart.orderFulfillments[0].shippingMethod.shippingMethodName"></strong><br>
                    
                    <hr>
                    
                    <strong ng-bind="slatwall.cart.orderFulfillments[0].shippingAddress.name"></strong><br>
                    {{slatwall.cart.orderFulfillments[0].shippingAddress.streetAddress}}<br>
                    {{slatwall.cart.orderFulfillments[0].shippingAddress.street2Address}}<br ng-if="slatwall.cart.orderFulfillments[0].shippingAddress.street2Address"/>
                    {{slatwall.cart.orderFulfillments[0].shippingAddress.city}}, {{slatwall.cart.orderFulfillments[0].shippingAddress.stateCode}} {{slatwall.cart.orderFulfillments[0].shippingAddress.postalCode}}<br>
                    {{slatwall.cart.orderFulfillments[0].shippingAddress.phoneNumber}}
                </div>
            </address>
        </div>
    </div>
        
    <div class="col-md-6">
        <!--- Billing --->
        <div ng-if="slatwall.cart.orderPayments.length">
            <div class="card-deck mb-3">
                <!--- Billing Address --->
                <address class="card">
                    <div class="card-header">
                        <i class="fa fa-check-circle"></i> Billing
                    </div>
                    <div class="card-body">
                        <div ng-switch="slatwall.cart.orderPayments[slatwall.cart.orderPayments.length - 1].creditCardType.toLowerCase()" ng-if="slatwall.cart.orderPayments[0].paymentMethod.paymentMethodName == 'Credit Card'">
                            <i class="fa fa-cc-visa fa-lg" ng-switch-when="visa"></i>
                            <i class="fa fa-cc-mastercard fa-lg" ng-switch-when="mastercard"></i>
                            <i class="fa fa-cc-discover fa-lg" ng-switch-when="discover"></i>
                            <i class="fa fa-cc-amex fa-lg" ng-switch-when="amex"></i>
                
                            Credit Card ending in {{slatwall.cart.orderPayments[slatwall.cart.orderPayments.length - 1].creditCardLastFour}}
                        </div>
                        <div ng-switch="slatwall.cart.orderPayments[slatwall.cart.orderPayments.length - 1].creditCardType.toLowerCase()" ng-if="slatwall.cart.orderPayments[0].paymentMethod.paymentMethodName == 'Purchase Order'">
                            <strong>Purchase Order</strong><br>
                
                            ##{{slatwall.cart.orderPayments[slatwall.cart.orderPayments.length - 1].purchaseOrderNumber}}
                        </div>
                        
                        <hr>
                        
                        <strong ng-bind="slatwall.cart.orderPayments[0].billingAddress.name"></strong><br>
                        {{slatwall.cart.orderPayments[0].billingAddress.streetAddress}}<br>
                        {{slatwall.cart.orderPayments[0].billingAddress.street2Address}}<br ng-if="slatwall.cart.orderPayments[0].billingAddress.street2Address"/>
                        {{slatwall.cart.orderPayments[0].billingAddress.city}}, {{slatwall.cart.orderPayments[0].billingAddress.stateCode}} {{slatwall.cart.orderPayments[0].billingAddress.postalCode}}<br>
                        {{slatwall.cart.orderPayments[0].billingAddress.phoneNumber}}
                    </div>
                </address>
            </div>
        </div>
    </div>
</div>

<div ng-if="slatwall.cart.orderNotes" class="mb-5">
    <h4>Shipping Notes/Instructions</h4>
    <p class="shippingNotes">{{slatwall.cart.orderNotes}}</p>
</div>

<!--- Place Order Button  --->
<div class="input_box">
    <button ng-click="slatwall.doAction('placeOrder')" class="btn btn-secondary big" ng-class="{disabled:slatwall.getRequestByAction('placeOrder').loading || slatwall.hasSuccessfulAction('placeOrder')}">{{slatwall.getRequestByAction('placeOrder').loading || slatwall.hasSuccessfulAction('placeOrder') ? '' : 'Place Order'}}
        <span ng-show="slatwall.getRequestByAction('placeOrder').loading || slatwall.hasSuccessfulAction('placeOrder')"><i class="fa fa-refresh fa-spin fa-fw"></i></span>
    </button>
</div>
</cfoutput>