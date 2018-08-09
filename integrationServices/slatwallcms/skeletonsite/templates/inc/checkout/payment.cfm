<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	<!--- Close button for create/edit address - only should show if other addresses exists show address listing on close --->
    <button type="button" name="closeAddress" 
        ng-show="slatwall.selectedBillingAccountAddress && slatwall.account.accountAddresses.length" 
        ng-click="slatwall.selectedBillingAccountAddress=undefined" 
        class="btn btn-link">Close</button>
	<sw:SwfAddressForm 
        selectedAccountAddress="slatwall.selectedBillingAccountAddress" 
        method="addEditAccountAddress,addBillingAddressUsingAccountAddress"
        visible="slatwall.selectedBillingAccountAddress || !slatwall.account.accountAddresses.length" />
	
	<div ng-show="!slatwall.selectedBillingAccountAddress && slatwall.account.accountAddresses.length">
		<button type="button" ng-click="slatwall.selectedBillingAccountAddress=slatwall.accountAddressService.newAccountAddress()" class="btn btn-link">
		    <i class="fa fa-plus-circle"></i> Add Billing Address
		</button>
		
		<!--- Select Existing Billing address --->
		<h3>Select Billing Address</h3>
		
		<!--- Billing is same as shipping? ---->
		<div class="form-check">
			<input class="form-check-input" ng-model="slatwall.billingSameAsShipping" type="checkbox" value="" id="billingsameshipping" ng-checked="slatwall.cart.billingAccountAddress.accountAddressID == slatwall.cart.orderFulfillments[0].accountAddress.accountAddressID">
			<label class="form-check-label" for="billingsameshipping">Billing address is same as shipping address?</label>
			<span ng-if="slatwall.billingSameAsShipping" ng-init="slatwall.selectBillingAccountAddress(slatwall.cart.orderFulfillments[0].accountAddress.accountAddressID)"></span>
		</div>
		
		<!--- Billing Dropdown Select --->
		<select class="form-control mt-3 mb-5" name="billingAddress" required 
			ng-model="slatwall.cart.billingAccountAddress.accountAddressID"
			ng-change="slatwall.selectBillingAccountAddress(slatwall.cart.billingAccountAddress.accountAddressID)"
			ng-disabled="slatwall.getRequestByAction('addBillingAddressUsingAccountAddress').loading"
			ng-hide="slatwall.billingSameAsShipping">
			<option  value="">Select Account Address</option>
		    <option ng-repeat="accountAddress in slatwall.account.accountAddresses track by accountAddress.accountAddressID" 
		    	ng-selected="accountAddress.accountAddressID == slatwall.cart.billingAccountAddress.accountAddressID"
		    	ng-value="accountAddress.accountAddressID" 
		    	ng-bind="accountAddress.getSimpleRepresentation()">
		    </option>
		</select>
		
		<!--- Select Payment Method --->
		<div ng-if="!slatwall.requests['addOrderPayment'].successfulActions.length">
			<h3>Select Payment Method</h3>
			
			<div class="radio_sec">
			    <div class="radiobox">
			        <input ng-model="slatwall.activePaymentMethod" value="creditCard" type="radio" name="pmt" id="cc">
			        <label for="cc">Pay By Credit Card</label>
			    </div>
			    
			    <div class="radiobox">
			        <input ng-model="slatwall.activePaymentMethod" value="purchaseOrder" type="radio" name="pmt" id="po">
			        <label for="po">Bill Me / Invoice</label>
			    </div>
			</div>
		</div>
		
		<!--- Add Payment Success/Fail --->
        <div class="alert alert-info" ng-show="slatwall.requests['addOrderPayment'].successfulActions.length">Payment added successfully.</div>
        <div
			class="alert alert-danger" 
			ng-repeat="errorArray in slatwall.getRequestByAction('addOrderPayment').errors track by $index"  
			ng-show="slatwall.failureActions.indexOf('addOrderPayment') !== -1 && $index === 0"
			ng-bind="errorArray[0]"
		></div>
		
	    <!--- Credit Card --->
			<form ng-model="OrderPayment_addOrderPayment" swf-form data-method="addOrderPayment" s-action="slatwall.clearPaymentMethod" ng-show="slatwall.activePaymentMethod === 'creditCard'">
				
				<h4>Credit Card</h4>
				
				<div class="row">
					<input type="hidden" name="accountAddressID" id="billingAccountAddress-addressID" class="form-control"
						ng-model="slatwall.cart.billingAccountAddress.accountAddressID"
					>
					<div class="form-group col-md-6">
						<label for="card-name" class="form-label">Name on Card</label>
						<input type="text" name="newOrderPayment.nameOnCreditCard" id="card-name" class="form-control"
							ng-model="OrderPayment_addOrderPayment.nameOnCreditCard" swvalidationrequired="true"
						>
	                    <sw:SwfErrorDisplay propertyIdentifier="nameOnCreditCard"/>
					</div>
					<div class="form-group col-md-6">
						<label for="card-number" class="form-label">Card Number</label>
						<input type="text" name="newOrderPayment.creditCardNumber" id="card-number" class="form-control" 
							ng-model="OrderPayment_addOrderPayment.creditCardNumber" swvalidationrequired="true"
						>
	                    <sw:SwfErrorDisplay propertyIdentifier="creditCardNumber"/>
					</div>
					<div class="form-group col-md-4">
						<label for="expiry-date-month" class="form-label">Expiration Month</label>
						<input type="text" name="newOrderPayment.expirationMonth" placeholder="MM" id="expiry-date-month" class="form-control"
							ng-model="OrderPayment_addOrderPayment.expirationMonth" swvalidationrequired="true"
						>
	                    <sw:SwfErrorDisplay propertyIdentifier="expirationMonth"/>
					</div>
					<div class="form-group col-md-4">
						<label for="expiry-date-year" class="form-label">Expiration Year</label>
						<input type="text" name="newOrderPayment.expirationYear" placeholder="YYYY" id="expiry-date-year" class="form-control" 
							ng-model="OrderPayment_addOrderPayment.expirationYear" swvalidationrequired="true"
						>
	                    <sw:SwfErrorDisplay propertyIdentifier="expirationYear"/>
					</div>
					<div class="form-group col-md-4">
						<label for="cvv" class="form-label">CVC/CVV</label>
						<input type="text" name="newOrderPayment.securityCode" id="cvv" class="form-control" 
							ng-model="OrderPayment_addOrderPayment.securityCode" swvalidationrequired="true"
						>
					</div>
				</div>
	            <!---<div class="form-group custom-control custom-checkbox">
	                <input type="checkbox" class="custom-control-input" id="payment_save">
	                <label class="custom-control-label" for="payment_save">Set as default payment?</label>
	            </div>--->
	
	            <!--- Credit Card Payment Submit & Close buttons --->
	            <button ng-click="swfForm.submitForm()" ng-disabled="swfForm.loading || slatwall.getRequestByAction('addBillingAddressUsingAccountAddress').loading" class="btn btn-secondary">
	            	{{(swfForm.loading ? '' : 'Add Payment')}}
	            	<span  ng-show="swfForm.loading"><i class='fa fa-refresh fa-spin fa-fw'></i></span>
	            </button>
			</form>
		<!--- //Credit Card --->
	
	    <!--- Purchase Order --->
	       <form ng-model="OrderPayment_addOrderPayment_PO" swf-form data-method="addOrderPayment" s-action="slatwall.clearPaymentMethod" ng-show="slatwall.activePaymentMethod === 'purchaseOrder'">
	    		
	    		<h4>Purchase Order</h4>
	            
	            <div class="row">
	            	<input type="hidden" name="accountAddressID" id="billingAccountAddress-addressID" class="form-control"
						ng-model="slatwall.cart.billingAccountAddress.accountAddressID"
					>
	                <div class="form-group col-md-7">
	                    <label for="card-name" class="form-label">Purchase Order Number</label>
	                    <input 
	                        type="text"
	                        name="newOrderPayment.purchaseOrderNumber"
	                        id="po-number" 
	                        class="form-control" 
							ng-model="OrderPayment_addOrderPayment_PO.purchaseOrderNumber" 
							swvalidationrequired="true"
						>
						<input 
	                        type="hidden"
	                        name="newOrderPayment.paymentMethod.paymentMethodID" 
	                        id="po-paymentMethodName" 
	                        class="form-control" 
							ng-model="OrderPayment_addOrderPayment_PO.paymentMethod.paymentMethodID" 
							ng-init="OrderPayment_addOrderPayment_PO.paymentMethod.paymentMethodID = '2c928083637466c70163747770710007'"
						>
	                    <sw:SwfErrorDisplay propertyIdentifier="purchaseOrderNumber"/>
	                </div>
	            </div>
	            
	            <!--- Purchase Order Submit & Close buttons --->
	            <button ng-click="swfForm.submitForm()" ng-disabled="swfForm.loading || slatwall.getRequestByAction('addBillingAddressUsingAccountAddress').loading" class="btn btn-secondary">
	            	{{(swfForm.loading ? '' : 'Add Payment')}}
	            	<span ng-show="swfForm.loading"><i class='fa fa-refresh fa-spin fa-fw'></i></span>
	            </button>
	        </form>
		<!--- //Purchase Order --->
		
		<!--------- Tax Exempt Certificate Upload ------->
		<form swf-form method="updateAccount" data-file-flag="true" name="taxExemptCert" ng-model="taxExemptCert" class="mt-5">
		    <label>Upload Tax Exempt Certificate</label>
		    <small ng-if="slatwall.account.taxExemptCert" ng-bind="slatwall.account.taxExemptCert"></small>
		    
		    <div class="custom-file">
		    	<input type="file" swf-file-input data-file-model="taxExemptCert" name="taxExemptCertInput" class="custom-file-input" />
		    	<label class="custom-file-label" for="customFile">Choose file</label>
		    </div>
		    
	        <div class="row my-4">
	            <div class="col-md-3">
		            <button ng-click="swfForm.submitForm()" ng-class="{disabled:swfForm.loading}" class="btn btn-secondary">
		            	{{(swfForm.loading ? '' : 'Upload')}}
		            	<i ng-show="swfForm.loading" class='fa fa-refresh fa-spin fa-fw'></i>
		            </button>
	            </div>
	        </div>
		</form>
		
		<!--------- // END Of Tax Exempt Certificate Upload ------->
		
		<!--- Shipping Notes --->
		<form swf-form method="updateOrderNotes" ng-model="slatwall.cart" class="mt-5">
		    <label>Shipping Notes/Instructions</label>
		    <textarea ng-model="slatwall.cart.orderNotes" name="orderNotes" class="form-control"></textarea>
		    <!--- Select Shipping Submit Button
		    <button swf-save-shipping ng-click="swfSaveShipping.save()" class="btn btn-secondary" ng-class="{disabled:swfForm.loading}">
		        {{swfForm.loading ? '' : 'Save & Continue'}}
		        <i class="fa fa-refresh fa-spin fa-fw" ng-show="swfForm.loading"></i>
		    </button>
		    --->
			<!--- Place Orders & Review Order buttons --->
	        <!--- Add disabled class until all criteria is met --->
	        <div class="row my-4">
	            <div class="col-md-3">
	                <button type="button" swf-save-notes ng-click="swfSaveNotes.save()" name="review" class="btn btn-secondary" ng-class="{disabled:swfForm.loading}" ng-disabled="swfNavigation.reviewTabDisabled">Review Order</button>
	            </div>
	        </div>
		</form>
            <!--<div class="col-md-3">-->
            <!--    <button type="submit" name="submit" class="btn btn-secondary" ng-disabled="swfNavigation.reviewTabDisabled">Place Order</button>-->
            <!--</div>-->
	</div>
</cfoutput>