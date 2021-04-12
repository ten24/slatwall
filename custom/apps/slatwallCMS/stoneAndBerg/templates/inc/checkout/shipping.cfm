<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
<div ng-repeat="orderFulfillment in slatwall.cart.orderFulfillments">
    <div ng-if="orderFulfillment.fulfillmentMethod.fulfillmentMethodType === 'shipping'">
        <!--- Select Shipping Method --->

        <!--- Alert message if no shipping methods available --->
        <div class="alert alert-danger" ng-show="orderFulfillment.shippingMethodOptions.length === 0">There are no shipping methods available.</div>

        <!--- Create Shipping Address form - opens by default if none exist --->
        <!--- NOTE: if we have an account then we should save accountaddresses otherwise only addresses --->
        <div class="new_address">
            
            <!--- Close button for create/edit address - only should show if other addresses exists show address listing on close --->
            <button type="button" name="closeAddress" 
                    ng-show="orderFulfillment.selectedAccountAddress && slatwall.account.accountAddresses.length" 
                    ng-click="orderFulfillment.selectedAccountAddress=undefined" 
                    class="btn btn-link">Close</button>
            
            <sw:SwfAddressForm 
                selectedAccountAddress="orderFulfillment.selectedAccountAddress" 
                method="addEditAccountAddress,addShippingAddressUsingAccountAddress"
                visible="orderFulfillment.selectedAccountAddress || !slatwall.account.accountAddresses.length"
                additionalParameters="{fulfillmentID:orderFulfillment.orderFulfillmentID}"
                formID="{{orderFulfillment.orderFulfillmentID}}"
                tagContext="fulfillment"/>
                    
            <button type="button"
                    ng-hide="orderFulfillment.selectedAccountAddress || !slatwall.account.accountAddresses.length"
                    ng-click="orderFulfillment.selectedAccountAddress=slatwall.accountAddressService.newAccountAddress()" 
                    class="btn btn-link">
                <i class="fa fa-plus-circle"></i> Add Shipping Address
            </button>
        </div>
		<div ng-show="!orderFulfillment.selectedAccountAddress">
            <!--- Select Existing Shipping address --->
            <div ng-show="slatwall.account.accountAddresses.length">
                <h3>Address Book</h3>
                <div class="alert alert-danger" ng-show="slatwall.requests['addShippingAddressUsingAccountAddress'].failureActions.length" ng-repeat="error in slatwall.errors['shippingAddress']">{{error}}</div>
                <form>
                    <div class="row">
                        <div class="col-sm-6 col-lg-4" ng-repeat="accountAddress in slatwall.account.accountAddresses track by accountAddress.accountAddressID">
                            <!--- Shipping Address block selector --->
                            <address class="address">
                                <!--- Select Address Loader --->
                                <i ng-show="slatwall.loadingThisRequest('addShippingAddressUsingAccountAddress',{accountAddressID:accountAddress.accountAddressID})" class="fa fa-refresh fa-spin fa-fw my-1 float-right"></i>
                                
                                <label for="checked-{{accountAddress.accountAddressID}}">
                                    <input id="checked-{{accountAddress.accountAddressID}}" type="radio" name="address"
                                        	ng-checked="accountAddress.accountAddressID === orderFulfillment.accountAddress.accountAddressID" ng-click="slatwall.selectShippingAccountAddress(accountAddress.accountAddressID,orderFulfillment.orderFulfillmentID)">
                                    
                                    <strong ng-bind="accountAddress.address.name"></strong>
                                    
                                    <small>
                                        {{accountAddress.address.streetAddress}}<br>
                                        {{accountAddress.address.street2Address}}<br ng-if="accountAddress.address.street2Address">
                                        {{accountAddress.address.city}}, {{accountAddress.address.stateCode}} {{accountAddress.address.postalCode}}<br>
                                        {{accountAddress.address.phoneNumber}}
                                    </small>
                                </label>      
                                
                                <a href="##" role="button" ng-click="orderFulfillment.selectedAccountAddress=accountAddress;" class="card-link float-left">Edit</a>
                                <a href="##" role="button" ng-disabled="slatwall.getRequestByAction('removeAccountAddress').loading" 
                                    ng-click="slatwall.deleteAccountAddress(accountAddress.accountAddressID)" class="card-link float-right">
                                    {{slatwall.getRequestByAction('deleteAccountAddress').loading ? '':'Delete'}}
                                    <i ng-show="slatwall.loadingThisRequest('deleteAccountAddress',{accountAddressID:accountAddress.accountAddressID})" class="fa fa-refresh fa-spin fa-fw"></i>
                                </a>

                            </address>
                        </div>
                    </div>
                </form>
            </div>

            <!--- Shipping Delievery Options --->
            <div class="shipping_sec" ng-show="orderFulfillment.accountAddress">
                <h4>Select Shipping Method</h4>
                
                <div class="radiobox" ng-repeat="shippingMethodOption in orderFulfillment.shippingMethodOptions | orderBy:shippingMethod.sortOrder">
                    <label>
                        <input class="form-check-input" type="radio" name="shipping" 
                	    ng-value="shippingMethodOption.value" ng-checked="shippingMethodOption.value == orderFulfillment.shippingMethod.shippingMethodID"
                	    ng-model="orderFulfillment.shippingMethod.shippingMethodID" 
                	    ng-click="slatwall.selectShippingMethod(shippingMethodOption,orderFulfillment)">
                        <strong>{{shippingMethodOption.name}}</strong>
                    </label>
                            
                    <!--- Select Address Loader --->
                    <i class="fa fa-refresh fa-spin fa-fw my-1" ng-show="slatwall.loadingThisRequest('addShippingMethodUsingShippingMethodID',{shippingMethodID:shippingMethodOption.value})"></i>
                </div>
            
                <!--- Save & Continue to Payment --->
                <button ng-click="swfNavigation.showTab('payment')" class="btn btn-secondary" ng-disabled="swfNavigation.paymentTabDisabled" disabled="disabled">Continue to Payment</button>
            </div>
        </div>
    </div>
</div>
</cfoutput>