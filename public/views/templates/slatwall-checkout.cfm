<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

	The core of the checkout revolves around a value called the 'orderRequirementsList'
	There are 3 major elements that all need to be in place for an order to be placed:

	account
	fulfillment
	payment

	With that in mind you will want to display different UI elements & forms based on
	if one ore more of those items are in the orderRequirementsList.  In the eample
	below we go in that order listed above, but you could very easily do it in a
	different order if you like.


--->
<cfinclude template="_slatwall-header.cfm" />

<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../tags" />

<!---[DEVELOPER NOTES]

	If you would like to customize any of the public tags used by this
	template, the recommended method is to uncomment the below import,
	copy the tag you'd like to customize into the directory defined by
	this import, and then reference with swc:tagname instead of sw:tagname.
	Technically you can define the prefix as whatever you would like and use
	whatever directory you would like but we recommend using this for
	the sake of convention.

	<cfimport prefix="swc" taglib="/Slatwall/custom/public/tags" />

--->

<!--- IMPORTANT: Get the orderRequirementsList to drive your UI Below --->
<cfset orderRequirementsList = $.slatwall.cart().getOrderRequirementsList() />

<!---[DEVELOPER NOTES]

	IMPORTANT: The orderRequirementsList just makes sure that there is an
	account attached to the order, however it does not ensure that the user be
	logged in because we allow by default for "guest checkout".  By leaving in
	the conditionals below it will require that the user is logged in, or that
	they are currently submitting the form as a guest checkout person

--->

<!--- Because we are going to potentially be dynamically adding 'account' back into the orderRequirementsList, we need to make sure that it isn't already part of the list, and that the session account ID's doesn't match the cart account ID --->
<cfif not listFindNoCase(orderRequirementsList, "account") and $.slatwall.cart().getAccount().getAccountID() neq $.slatwall.account().getAccountID()>

	<!--- Add account to the orderRequirements list --->
	<cfset orderRequirementsList = listPrepend(orderRequirementsList, "account") />

	<!--- OPTIONAL: This should be left in if you would like to allow for guest checkout --->
	<cfif $.slatwall.cart().getAccount().getGuestAccountFlag()>

		<!--- OPTIONAL: This condition can be left in if you would like to make it so that a guest checkout is only valid if the page submitted with a slatAction.  This prevents guest checkouts from still being valid if the user navigates away, and then back --->
		<cfif arrayLen($.slatwall.getCalledActions())>
			<cfset orderRequirementsList = listDeleteAt(orderRequirementsList, listFindNoCase(orderRequirementsList, "account")) />
		</cfif>
		<!--- IMPORTANT: If you delete the above contitional so that a guest can move about the site without loosing their checkout data, then you will want to uncomment below --->
		<!--- <cfset orderRequirementsList = listDeleteAt(orderRequirementsList, listFindNoCase(orderRequirementsList, "account")) /> --->

	</cfif>
</cfif>

<!--- IMPORTANT: This is here so that the checkout layout is never cached by the browser --->
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate" />
<cfheader name="cache-control" value="post-check=0, pre-check=0" />
<cfheader name="last-modified" value="#now()#" />
<cfheader name="pragma"  value="no-cache" />

<!--- We are paraming this variable so that we can use it later to see if a specific step was clicked on.  Using the url.step is just a templating thing and it has nothing to do really with the core of Slatwall.  This could be changed to anything --->
<cfparam name="url.step" default="" />

<cfset paymentFormAction="?s=1">

<!--- If using HTTP, override the form to send over http if the setting Force Credit Card Over SSL is true --->
<cfif $.slatwall.setting('globalForceCreditCardOverSSL') EQ true AND (findNoCase("off", CGI.HTTPS) OR NOT CGI.SERVER_PORT_SECURE)>
	<cfset paymentFormAction = replace($.slatwall.getURL(), 'http://', 'https://') />
</cfif>

<cfoutput>
	<div class="container">
		<!--- START CHECKOUT EXAMPLE 1 --->
		<div class="row">
			<div class="col-md-12">
				<h3>Checkout Example (4 Step)</h3>

				<!--- Display any errors associated with actually placing the order, and running those transactions --->
				<sw:ErrorDisplay object="#$.slatwall.cart()#" errorName="runPlaceOrderTransaction" displayType="p" />
			</div>
		</div>

		<!--- Verify that there are items in the cart --->
		<cfif arrayLen($.slatwall.cart().getOrderItems())>
			<div class="row">
				<!--- START: CHECKOUT DETAIL --->
				<div class="col-md-8">

<!--- ============== ACCOUNT ========================================= --->
					<cfif listFindNoCase(orderRequirementsList, "account") or url.step eq 'account'>

						<!--- START: ACCOUNT --->
						<h4>Step 1 - Account Details</h4>

						<div class="row">
							<!--- LOGIN --->
							<div class="col-md-4">
								<h4>Login with Existing Account</h4>

								<!--- Sets up the account login processObject --->
								<cfset accountLoginObj = $.slatwall.getAccount().getProcessObject('login') />

								<!--- Start: Login Form --->
								<form action="?s=1" method="post">
									<!--- This hidden input is what tells slatwall to try and login the account --->
									<input type="hidden" name="slatAction" value="public:account.login" />

									<!--- Email Address --->
									<div class="form-group">
				    					<label for="emailAddress">Email Address</label>
										<sw:FormField type="text" valueObject="#accountLoginObj#" valueObjectProperty="emailAddress" class="form-control" />
										<sw:ErrorDisplay object="#accountLoginObj#" errorName="emailAddress" />
				  					</div>

									<!--- Password --->
									<div class="form-group">
				    					<label for="password">Password</label>
										<sw:FormField type="password" valueObject="#accountLoginObj#" valueObjectProperty="password" class="form-control" />
										<sw:ErrorDisplay object="#accountLoginObj#" errorName="password" />
				  					</div>

									<!--- Login Button --->
									<div class="form-group">
				      					<button type="submit" class="btn btn-primary">Login & Continue</button>
				  					</div>
								</form>
								<!--- End: Login Form --->

								<hr />

								<h4>Forgot Password</h4>

								<!--- Sets up the account login processObject --->
								<cfset forgotPasswordObj = $.slatwall.getAccount().getProcessObject('forgotPassword') />

								<!--- Start: Forgot Password Form --->
								<form action="?s=1" method="post">
									<!--- This hidden input is what tells slatwall to try and login the account --->
									<input type="hidden" name="slatAction" value="public:account.forgotPassword" />

									<!--- Email Address --->
									<div class="form-group">
				    					<label for="emailAddress">Email Address</label>
										<sw:FormField type="text" valueObject="#accountLoginObj#" valueObjectProperty="emailAddress" class="form-control" />
										<sw:ErrorDisplay object="#forgotPasswordObj#" errorName="emailAddress" />
				  					</div>

									<!--- Reset Email Button --->
									<div class="form-group">
				      					<button type="submit" class="btn btn-default">Send Me Reset Email</button>
				  					</div>
								</form>
								<!--- End: Forgot Password Form --->
							</div>

							<!--- CREATE ACCOUNT --->
							<div class="col-md-4">
								<h4>Create New Account</h4>

								<!--- Sets up the create account processObject --->
								<cfset createAccountObj = $.slatwall.account().getProcessObject('create') />

								<!--- Create Account Form --->
								<form action="?s=1" method="post">
									<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
									<input type="hidden" name="slatAction" value="public:account.create,public:account.login" />

									<!--- Name --->
									<div class="row">
										<!--- First Name --->
										<div class="col-md-6">
											<div class="form-group">
						    					<label for="firstName">First Name</label>
												<sw:FormField type="text" valueObject="#createAccountObj#" valueObjectProperty="firstName" class="form-control" />
												<sw:ErrorDisplay object="#createAccountObj#" errorName="firstName" />
						  					</div>
										</div>

										<!--- Last Name --->
										<div class="col-md-6">
											<div class="form-group">
						    					<label for="lastName">Last Name</label>
												<sw:FormField type="text" valueObject="#createAccountObj#" valueObjectProperty="lastName" class="form-control" />
												<sw:ErrorDisplay object="#createAccountObj#" errorName="lastName" />
						  					</div>
										</div>
									</div>

									<!--- Phone Number --->
									<div class="form-group">
				    					<label for="phoneNumber">Phone Number</label>
										<sw:FormField type="text" valueObject="#createAccountObj#" valueObjectProperty="phoneNumber" class="form-control" />
										<sw:ErrorDisplay object="#createAccountObj#" errorName="phoneNumber" />
				  					</div>

									<!--- Email Address --->
									<div class="form-group">
				    					<label for="emailAddress">Email Address</label>
										<sw:FormField type="text" valueObject="#createAccountObj#" valueObjectProperty="emailAddress" class="form-control" />
										<sw:ErrorDisplay object="#createAccountObj#" errorName="emailAddress" />
				  					</div>

									<!--- Email Address Confirm --->
									<div class="form-group">
				    					<label for="emailAddressConfirm">Confirm Email Address</label>
										<sw:FormField type="text" valueObject="#createAccountObj#" valueObjectProperty="emailAddressConfirm" class="form-control" />
										<sw:ErrorDisplay object="#createAccountObj#" errorName="emailAddressConfirm" />
				  					</div>

									<!--- Guest Checkout --->
									<div class="form-group">
				    					<label for="createAuthenticationFlag">Save Account ( No for Guest Checkout )</label>
										<sw:FormField type="yesno" valueObject="#createAccountObj#" valueObjectProperty="createAuthenticationFlag" />
										<sw:ErrorDisplay object="#createAccountObj#" errorName="createAuthenticationFlag" />
				  					</div>

									<!--- SCRIPT IMPORTANT: This jQuery is just here for example purposes to show/hide the password fields if guestCheckout it set to true / false --->
									<script type="text/javascript">
										(function($){
											$(document).ready(function(){
												$('body').on('change', 'input[name="createAuthenticationFlag"]', function(e){
													if( $(this).val() == 0 ) {
														$('##password-details').hide();
														$(this).closest('form').find('input[name="slatAction"]').val('public:cart.guestaccount');
													} else {
														$('##password-details').show();
														$(this).closest('form').find('input[name="slatAction"]').val('public:account.create,public:account.login');
													}
												});
												$('input[name="createAuthenticationFlag"]:checked').change();
											});
										})( jQuery )
									</script>

									<!--- Password --->
									<div id="password-details" >
										<div class="form-group">
					    					<label for="password">Password</label>
											<sw:FormField type="password" valueObject="#createAccountObj#" valueObjectProperty="password" class="form-control" />
											<sw:ErrorDisplay object="#createAccountObj#" errorName="password" />
					  					</div>

										<!--- Password Confirm --->
										<div class="form-group">
					    					<label for="passwordConfirm">Confirm Password</label>
											<sw:FormField type="password" valueObject="#createAccountObj#" valueObjectProperty="passwordConfirm" class="form-control" />
											<sw:ErrorDisplay object="#createAccountObj#" errorName="password" />
					  					</div>
									</div>

									<!--- Create Button --->
									<div class="form-group pull-right">
				      					<button type="submit" class="btn btn-primary">Create Account & Continue</button>
				  					</div>
								</form>
								<!--- End: Create Account Form --->
							</div>
						</div>
						<!--- END: ACCOUNT --->

<!--- ============= FULFILLMENT ============================================== --->
					<cfelseif listFindNoCase(orderRequirementsList, "fulfillment") or url.step eq 'fulfillment'>

						<!--- START: FULFILLMENT --->
						<h4>Step 2 - Fulfillment Details</h4>

						<form action="?s=1" method="post">
							<!--- Hidden slatAction to trigger a cart update with the new fulfillment information --->
							<input type="hidden" name="slatAction" value="public:cart.update" />

							<!--- Setup a fulfillment index, so that when the form is submitted all of the data is is compartmentalized --->
							<cfset orderFulfillmentIndex = 0 />

							<!--- We loop over the orderFulfillments and check if they are processable --->
							<cfloop array="#$.slatwall.cart().getOrderFulfillments()#" index="orderFulfillment">
								<!--- We need to check if this order fulfillment is one that needs to be updated, by checking if it is already processable or by checking if it has errors --->
								<cfif not orderFulfillment.isProcessable( context="placeOrder" ) or orderFulfillment.hasErrors() or url.step eq 'fulfillment'>
									<!--- Increment the orderFulfillment index so that we can update multiple order fulfillments at once --->
									<cfset orderFulfillmentIndex++ />

									<input type="hidden" name="orderFulfillments[#orderFulfillmentIndex#].orderFulfillmentID" value="#orderFulfillment.getOrderFulfillmentID()#" />

									<div class="row">
										<!---[DEVELOPER NOTES]

											Based on the fulfillmentMethodType we will display different form elements for the
											end user to fill out.  The 'auto' fulifllment method type and 'download' fulfillment
											method type, have no values that need to get input and that is why you don't see
											them in the conditionals below.

										--->

										<!--- EMAIL --->
										<cfif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "email">
											<div class="col-md-8">
												<!--- Email Address --->
												<div class="form-group">
							    					<label for="emailAddress">Email Address</label>
													<sw:FormField type="text" name="orderFulfillments[#orderFulfillmentIndex#].emailAddress" valueObject="#orderFulfillment#" valueObjectProperty="emailAddress" class="form-control" />
													<sw:ErrorDisplay object="#orderFulfillment#" errorName="emailAddress" />
							  					</div>
											</div>

										<!--- PICKUP --->
										<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup">

											<div class="col-md-8">
												<!--- Pickup Location --->
												<div class="form-group">
							    					<label for="pickupLocation">Pickup Location</label>
													<sw:FormField type="select" name="orderFulfillments[#orderFulfillmentIndex#].pickupLocation.locationID" valueObject="#orderFulfillment#" valueObjectProperty="pickupLocation" valueOptions="#orderFulfillment.getPickupLocationOptions()#" class="form-control" />
													<sw:ErrorDisplay object="#orderFulfillment#" errorName="pickupLocation" />
							  					</div>
											</div>

										<!--- SHIPPING --->
										<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">

											<div class="col-md-4">
												<h4>Shipping Address</h4>

												<!--- Get the options that the person can choose from --->
												<cfset accountAddressOptions = orderFulfillment.getAccountAddressOptions() />

												<!--- Add a 'New' Attribute so that we can drive the new form below --->
												<cfset arrayAppend(accountAddressOptions, {name='New', value=''}) />

												<!--- As long as there are no errors for the orderFulfillment, we can setup the default accountAddress value to be selected --->
												<cfset accountAddressID = "" />

												<cfif !isNull(orderFulfillment.getAccountAddress())>
													<cfset accountAddressID = orderFulfillment.getAccountAddress().getAccountAddressID() />
												<cfelseif orderFulfillment.getShippingAddress().getNewFlag() && not orderFulfillment.getShippingAddress().hasErrors()>
													<cfset accountAddressID = $.slatwall.cart().getAccount().getPrimaryAddress().getAccountAddressID() />
												</cfif>

												<!--- If there are existing account addresses, then we can allow the user to select one of those --->
												<cfif arrayLen(accountAddressOptions) gt 1>
													<!--- Account Address --->
													<div class="form-group">
								    					<label for="accountAddress">Select Address</label>
														<sw:FormField type="select" name="orderFulfillments[#orderFulfillmentIndex#].accountAddress.accountAddressID" valueObject="#orderFulfillment#" valueObjectProperty="accountAddress" valueOptions="#accountAddressOptions#" value="#accountAddressID#" class="form-control" />
														<sw:ErrorDisplay object="#orderFulfillment#" errorName="accountAddress" />
								  					</div>

													<hr />
												</cfif>

												<!--- New Shipping Address --->
												<div id="new-shipping-address#orderFulfillmentIndex#"<cfif len(accountAddressID)> class="hide"</cfif>>
													<cfif isNull(orderFulfillment.getAccountAddress())>
														<sw:AddressForm id="newShippingAddress" address="#orderFulfillment.getAddress()#" fieldNamePrefix="orderFulfillments[#orderFulfillmentIndex#].shippingAddress." fieldClass="form-control" />

													<cfelse>

														<sw:AddressForm id="newShippingAddress" address="#orderFulfillment.getNewPropertyEntity( 'shippingAddress' )#" fieldNamePrefix="orderFulfillments[#orderFulfillmentIndex#].shippingAddress." fieldClass="form-control" />
													</cfif>

													<!--- As long as the account is not a guest account, and this is truely new address we are adding, then we can offer to save as an account address for use on later purchases --->
													<cfif not $.slatwall.getCart().getAccount().getGuestAccountFlag()>
														<!--- Save As Account Address --->
														<div class="form-group">
									    					<label for="saveAccountAddressFlag">Save In Address Book</label>
															<sw:FormField type="yesno" name="orderFulfillments[#orderFulfillmentIndex#].saveAccountAddressFlag" valueObject="#orderFulfillment#" valueObjectProperty="saveAccountAddressFlag" />
									  					</div>

														<!--- Save Account Address Name --->
														<div id="save-account-address-name#orderFulfillmentIndex#"<cfif not orderFulfillment.getSaveAccountAddressFlag()> class="hide"</cfif>>
															<div class="form-group">
										    					<label for="saveAccountAddressName">Address Nickname (optional)</label>
																<sw:FormField type="text" name="orderFulfillments[#orderFulfillmentIndex#].saveAccountAddressName" valueObject="#orderFulfillment#" valueObjectProperty="saveAccountAddressName" class="form-control" />
										  					</div>
														</div>
													</cfif>
												</div>

												<!--- SCRIPT IMPORTANT: This jQuery is just here for example purposes to show/hide the new address field if there are account addresses --->
												<script type="text/javascript">
													(function($){
														$(document).ready(function(){
															$('body').on('change', 'select[name="orderFulfillments[#orderFulfillmentIndex#].accountAddress.accountAddressID"]', function(e){
																if( $(this).val() === '' ) {
																	$('##new-shipping-address#orderFulfillmentIndex#').show();
																} else {
																	$('##new-shipping-address#orderFulfillmentIndex#').hide();
																}
															});
															$('body').on('change', 'input[name="orderFulfillments[#orderFulfillmentIndex#].saveAccountAddressFlag"]', function(e){
																if( $(this).val() ) {
																	$('##save-account-address-name#orderFulfillmentIndex#').show();
																} else {
																	$('##save-account-address-name#orderFulfillmentIndex#').hide();
																}
															});
															$('select[name="orderFulfillments[#orderFulfillmentIndex#].accountAddress.accountAddressID"]').change();
														});
													})( jQuery )
												</script>
											</div>

											<!--- START: Shipping Method Selection --->
											<div class="col-md-4">
												<h4>Shipping Method</h4>

												<!--- If there are multiple shipping methods to select from, then display that --->
												<cfif arrayLen(orderFulfillment.getShippingMethodOptions()) gt 1>

													<!--- Start: Shipping Method Example 1 --->
													<div class="form-group">
								    					<label for="shippingMethod">Shipping Method Example</label>
														<!--- OPTIONAL: You can use this formField display to show options as a select box
														<sw:FormField type="select" name="orderFulfillments[#orderFulfillmentIndex#].shippingMethod.shippingMethodID" valueObject="#orderFulfillment#" valueObjectProperty="shippingMethod" valueOptions="#orderFulfillment.getShippingMethodOptions()#" class="col-md-4" />
														--->
														<cfset shippingMethodID = "" />
														<cfif not isNull(orderFulfillment.getShippingMethod())>
															<cfset shippingMethodID = orderFulfillment.getShippingMethod().getShippingMethodID() />
														</cfif>

														<sw:FormField type="radiogroup" name="orderFulfillments[#orderFulfillmentIndex#].shippingMethod.shippingMethodID" value="#shippingMethodID#" valueOptions="#orderFulfillment.getShippingMethodOptions()#" class="form-control" />
														<sw:ErrorDisplay object="#orderFulfillment#" errorName="shippingMethod" />
								  					</div>
													<!--- End: Shipping Method Example 1 --->

												<!--- If there is only 1 shipping method option that comes back, then we can just tell the customer how there order will be shipped --->
												<cfelseif arrayLen(orderFulfillment.getShippingMethodOptions()) and len(orderFulfillment.getShippingMethodOptions()[1]['value'])>

													<!--- We should still pass the shipping method as a hidden value --->
													<input type="hidden" name="orderFulfillments[#orderFulfillmentIndex#].shippingMethod.shippingMethodID" value="#orderFulfillment.getShippingMethodOptions()[1]['value']#" />

													<p>This order will be shipped via: #orderFulfillment.getFulfillmentShippingMethodOptions()[1].getShippingMethodRate().getShippingMethod().getShippingMethodName()# ( #orderFulfillment.getFulfillmentShippingMethodOptions()[1].getFormattedValue('totalCharge')# )</p>

												<!--- Show message to customer telling them that they need to fill in an address before we can provide a shipping method quote --->
												<cfelse>

													<!--- If the user has not yet defined their shipping address, then we can display a note for them --->
													<cfif orderFulfillment.getAddress().getNewFlag()>
														<p>Please update your shipping address first so that we can provide you with the correct shipping rates.</p>

													<!--- If they have already provided an address, and there are still no shipping method options, then the address they entered is not one that can be shipped to --->
													<cfelse>

														<p>Unfortunately the shipping address that you have provided is not one that we ship to.  Please update your shipping address and try again, or contact customer service for more information.</p>
													</cfif>
												</cfif>
											</div>
											<!--- END: Shipping Method Selection --->
										</cfif>

										<!--- Action Buttons --->
										<div class="col-md-8">
											<div class="form-group pull-right">
												<!--- Continue, just submits the form --->
												<button type="submit" class="btn btn-primary">Save & Continue</button>
											</div>
										</div>
									</div>
								</cfif>
							</cfloop>
						</form>
						<!--- END: FULFILLMENT --->

<!--- ============= PAYMENT ============================================== --->
					<cfelseif listFindNoCase(orderRequirementsList, "payment") or url.step eq 'payment'>

						<!--- get the eligable payment methods for this order --->
						<cfset eligiblePaymentMethods = $.slatwall.cart().getEligiblePaymentMethodDetails() />

						<!--- START: PAYMENT --->
						<h4>Step 3 - Payment Details</h4>

						<br />

						<!--- Get the applied payments smart list, and filter by only payments that are active --->
						<cfset appliedPaymentsSmartList = $.slatwall.cart().getOrderPaymentsSmartList() />
						<cfset appliedPaymentsSmartList.addFilter('orderPaymentStatusType.systemCode', 'opstActive') />

						<!--- Display existing order payments, we are using the smart list here so that any non-persisted order payments don't show up --->
						<cfif appliedPaymentsSmartList.getRecordsCount()>
							<h4>Payments Applied</h4>

							<!--- Applied Payments Table --->
							<table class="table">
								<tr>
									<th>Payment Details</th>
									<th>Amount</th>
									<th>&nbsp;</th>
								</tr>

								<cfloop array="#appliedPaymentsSmartList.getRecords()#" index="orderPayment">
									<tr>
										<td>#orderPayment.getSimpleRepresentation()#</td>
										<td>#orderPayment.getAmount()#</td>
										<td><a href="?slatAction=public:cart.removeOrderPayment&orderPaymentID=#orderPayment.getOrderPaymentID()#">Remove</a></td>
									</tr>
								</cfloop>
							</table>
						</cfif>

						<!--- Display any errors associated with adding order payment --->
						<sw:ErrorDisplay object="#$.slatwall.cart()#" errorName="addOrderPayment" />

						<!--- Payment Method Nav Tabs --->
						<ul class="nav nav-tabs" role="tablist">
							<!--- This first variables here is only used to define the 'active' tab for bootstrap css to take over --->
							<cfset first = true />

							<!--- If the user has "AccountPaymentMethods" then we can first display a tab that allows them to select from existing payment methods --->
							<cfif arrayLen($.slatwall.account().getAccountPaymentMethods())>
								<li role="presentation" class="active"><a href="##account-payment-methods" aria-controls="account-payment-methods" role="tab" data-toggle="tab">Use Saved Payment Info</a></li>
								<cfset first = false />
							</cfif>

							<!--- Loop over all of the eligible payment methods --->
							<cfloop array="#eligiblePaymentMethods#" index="paymentDetails">
								<li role="presentation" class="#iif(first, de('active'), de(''))#"><a href="##tab#paymentDetails.paymentMethod.getPaymentMethodID()#" aria-controls="tab#paymentDetails.paymentMethod.getPaymentMethodID()#" role="tab" data-toggle="tab">Pay with #paymentDetails.paymentMethod.getPaymentMethodName()#</a></li>
								<cfset first = false />
							</cfloop>
						</ul>

						<!--- Setup the addOrderPayment entity so that it can be used for each of these --->
						<cfset addOrderPaymentObj = $.slatwall.cart().getProcessObject("addOrderPayment") />

						<!--- Payment Tab Content --->
						<div class="tab-content">

							<!--- This first variables here is only used to define the 'active' tab for bootstrap css to take over --->
							<cfset first = true />

							<!--- If the user has "AccountPaymentMethods" then we can first display a tab that allows them to select from existing payment methods --->
							<cfif arrayLen($.slatwall.account().getAccountPaymentMethods())>
								<div class="tab-pane active" id="account-payment-methods">
									<form action="?s=1" method="post">
										<!--- Hidden value to setup the slatAction --->
										<input id="slatActionApplyAccountPaymentMethod" type="hidden" name="slatAction" value="public:cart.addOrderPayment" />

										<cfset apmFirst = true />

										<!--- Loop over all of the account payment methods and display them as a radio button to select --->
										<cfloop array="#$.slatwall.account().getAccountPaymentMethods()#" index="accountPaymentMethod">
											<input type="radio" name="accountPaymentMethodID" value="#accountPaymentMethod.getAccountPaymentMethodID()#" <cfif apmFirst>checked="checked" <cfset ampFirst = false /></cfif>/>

											<!--- CASH --->
											<cfif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "cash">
												#accountPaymentMethod.getSimpleRepresentation()#
												<hr />
											<!--- CHECK --->
											<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "check">
												#accountPaymentMethod.getSimpleRepresentation()#
												<hr />
											<!--- CREDIT CARD --->
											<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "creditCard">
												#accountPaymentMethod.getSimpleRepresentation()#
												<hr />
											<!--- GIFT CARD --->
											<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "giftCard">
												#accountPaymentMethod.getSimpleRepresentation()#
												<hr />
											<!--- TERM PAYMENT --->
											<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "termPayment">
												#accountPaymentMethod.getSimpleRepresentation()#
												<hr />
											</cfif>

											<cfset apmFirst = false />
										</cfloop>

										<div class="form-group">
											<!--- This button will just add the order payment, but not actually process the order --->
											<button type="submit" class="btn btn-default" onClick="$('##slatActionApplyAccountPaymentMethod').val('public:cart.addOrderPayment');">Apply Payment Method & Review</button>

											<!--- Clicking this button will not only add the payment, but it will also attempt to place the order. --->
											<button type="submit" class="btn btn-primary" onClick="$('##slatActionApplyAccountPaymentMethod').val('public:cart.placeOrder');">Apply Payment Method & Place Order</button>
										</div>
									</form>
								</div>
								<cfset first = false />
							</cfif>

							<!--- Loop over all of the eligible payment methods --->
							<cfloop array="#eligiblePaymentMethods#" index="paymentDetails">

								<div class="tab-pane#iif(first, de(' active'), de(''))#" id="tab#paymentDetails.paymentMethod.getPaymentMethodID()#">

									<!--- EXTERNAL --->
									<cfif paymentDetails.paymentMethod.getPaymentMethodType() eq "external">
										#paymentDetails.paymentMethod.getExternalPaymentHTML()#

									<!--- CASH, CHECK, CREDIT CARD, GIFT CARD, TERM PAYMENT --->
									<cfelse>
										<form action="#paymentFormAction#" method="post">

											<!--- Hidden value to setup the slatAction --->
											<input id="slatActionAddOrderPayment" type="hidden" name="slatAction" value="public:cart.addOrderPayment" />

											<!--- Hidden value to identify the type of payment method this is --->
											<input type="hidden" name="newOrderPayment.orderPaymentID" value="#addOrderPaymentObj.getNewOrderPayment().getOrderPaymentID()#" />
											<input type="hidden" name="newOrderPayment.paymentMethod.paymentMethodID" value="#paymentDetails.paymentMethod.getPaymentMethodID()#" />

											<sw:ErrorDisplay object="#$.slatwall.cart()#" errorName="addOrderPayment" />

											<!--- CASH --->
											<cfif paymentDetails.paymentMethod.getPaymentMethodType() eq "cash">

											<!--- CHECK --->
											<cfelseif paymentDetails.paymentMethod.getPaymentMethodType() eq "check">

											<!--- CREDIT CARD --->
											<cfelseif paymentDetails.paymentMethod.getPaymentMethodType() eq "creditCard">
												<div class="row">
													<div class="col-md-4">
														<h4>Billing Address</h4>

														<sw:AddressForm id="newBillingAddress" address="#addOrderPaymentObj.getNewOrderPayment().getBillingAddress()#" fieldNamePrefix="newOrderPayment.billingAddress." fieldClass="form-control" />
													</div>
													<div class="col-md-4">
														<h4>Credit Card Info</h4>

														<!--- Credit Card Number --->
														<div class="form-group">
									    					<label for="creditCardNumber">Credit Card Number</label>
															<sw:FormField type="text" name="newOrderPayment.creditCardNumber" valueObject="#addOrderPaymentObj.getNewOrderPayment()#" valueObjectProperty="creditCardNumber" class="form-control" />
															<sw:ErrorDisplay object="#addOrderPaymentObj.getNewOrderPayment()#" errorName="creditCardNumber" />
									  					</div>

														<!--- Name on Credit Card --->
														<div class="form-group">
									    					<label for="nameOnCreditCard">Name on Card</label>
															<sw:FormField type="text" name="newOrderPayment.nameOnCreditCard" valueObject="#addOrderPaymentObj.getNewOrderPayment()#" valueObjectProperty="nameOnCreditCard" class="form-control" />
															<sw:ErrorDisplay object="#addOrderPaymentObj.getNewOrderPayment()#" errorName="nameOnCreditCard" />
									  					</div>

														<!--- Security & Expiration Row --->
														<div class="row">
															<div class="col-md-4">
																<!--- Security Code --->
																<div class="form-group">
											    					<label for="securityCode">Security Code</label>
																	<sw:FormField type="text" name="newOrderPayment.securityCode" valueObject="#addOrderPaymentObj.getNewOrderPayment()#" valueObjectProperty="securityCode" class="form-control" />
																	<swc:ErrorDisplay object="#addOrderPaymentObj.getNewOrderPayment()#" errorName="securityCode" />
											  					</div>
															</div>

															<div class="col-md-2">
																<!--- Expiration --->
																<div class="form-group">
											    					<label class="pull-right" for="expirationMonth">Expiration ( MM / YYYY )</label>
											    					<div class="col-md-6">
																		<sw:FormField type="select" name="newOrderPayment.expirationMonth" valueObject="#addOrderPaymentObj.getNewOrderPayment()#" valueObjectProperty="expirationMonth" valueOptions="#addOrderPaymentObj.getNewOrderPayment().getExpirationMonthOptions()#" class="form-control" />
											    					</div>
											    					<div class="col-md-6">
																		<sw:FormField type="select" name="newOrderPayment.expirationYear" valueObject="#addOrderPaymentObj.getNewOrderPayment()#" valueObjectProperty="expirationYear" valueOptions="#addOrderPaymentObj.getNewOrderPayment().getExpirationYearOptions()#" class="form-control" />
																		<swc:ErrorDisplay object="#addOrderPaymentObj.getNewOrderPayment()#" errorName="expirationMonth" />
																		<swc:ErrorDisplay object="#addOrderPaymentObj.getNewOrderPayment()#" errorName="expirationYear" />
											    					</div>
											  					</div>
															</div>
														</div>

														<!--- SPLIT PAYMENTS (OPTIONAL) - Just delete this section if you don't want to allow for split payments --->
														<cfset splitPaymentID = "sp" & lcase(createUUID()) />
														<div class="form-group">
									    					<label for="newOrderPayment.amount">Amount</label>
								    						#$.slatwall.formatValue(paymentDetails.maximumAmount, 'currency')#
								    						<a href="##" id='#splitPaymentID#'>Split Payment</a>
									  					</div>
														<script type="text/javascript">
															(function($){
																$(document).ready(function(e){

																	// Bind to split button
																	$('body').on('click', '###splitPaymentID#', function(e){
																		e.preventDefault();
																		$(this).closest('div').html('<input type="text" name="newOrderPayment.amount" value="#paymentDetails.maximumAmount#" class="col-md-4" />');
																	});

																});
															})( jQuery );
														</script>
														<!--- END: SPLIT PAYMENT --->
													</div>
												</div>

											<!--- GIFT CARD --->
											<cfelseif paymentDetails.paymentMethod.getPaymentMethodType() eq "giftCard">

											<!--- TERM PAYMENT --->
											<cfelseif paymentDetails.paymentMethod.getPaymentMethodType() eq "termPayment">

											</cfif>

											<div class="form-group pull-right">
												<!--- This button will just add the order payment, but not actually process the order --->
												<button type="submit" class="btn" name="slatAction" onClick="$('##slatActionAddOrderPayment').val('public:cart.addOrderPayment');">Add Payment & Review</button>

												<!--- Clicking this button will not only add the payment, but it will also attempt to place the order. --->
												<button type="submit" class="btn btn-primary" name="slatAction" onClick="$('##slatActionAddOrderPayment').val('public:cart.placeOrder');">Add Payment & Place Order</button>
											</div>
										</form>
									</cfif>
								</div>

								<cfset first = false />
							</cfloop>
						</div>

						<!--- END: PAYMENT --->

<!--- ============= CONFIRMATION ============================================== --->
<!--- ============= ORDER REVIEW ============================================== --->
					<cfelseif not len(orderRequirementsList) or url.step eq 'review'>

						<h4>Step 4 - Order Review</h4>

						<form action="?s=1" method="post">
							<input type="hidden" name="slatAction" value="public:cart.placeOrder" />

							<!--- Account Details --->
							<cfif not listFindNoCase(orderRequirementsList, "account") and not $.slatwall.cart().getAccount().isNew()>
								<div class="row-fluid">
									<div class="col-md-12">
										<h5>Account Details <cfif $.slatwall.cart().getAccount().getGuestAccountFlag()><a href="?step=account" title="Edit"><span class="glyphicon glyphicon-pencil"></span></a></cfif></h5>

										<p>
											<!--- Name --->
											<strong>#$.slatwall.cart().getAccount().getFullName()#</strong><br />

											<!--- Email Address --->
											<cfif len($.slatwall.cart().getAccount().getEmailAddress())>#$.slatwall.cart().getAccount().getEmailAddress()#<br /></cfif>

											<!--- Phone Number --->
											<cfif len($.slatwall.cart().getAccount().getPhoneNumber())>#$.slatwall.cart().getAccount().getPhoneNumber()#<br /></cfif>

											<!--- Logout Link --->
											<cfif not $.slatwall.cart().getAccount().getGuestAccountFlag()>
												<br />
												<a href="?slatAction=public:account.logout">That isn't me ( Logout )</a>
											</cfif>
										</p>
										<hr>
									</div>
								</div>
							</cfif>

							<!--- Fulfillment Details --->
							<cfif not listFindNoCase(orderRequirementsList, "account") and not $.slatwall.cart().getAccount().isNew()>
								<div class="row-fluid">
									<div class="col-md-12">
										<h4>Fulfillment Details <a href="?step=fulfillment" title="Edit"><span class="glyphicon glyphicon-pencil"></span></a></h4>
										<cfloop array="#$.slatwall.cart().getOrderFulfillments()#" index="orderFulfillment">
											<div class="row-fluid">
												<div class="col-md-6">
													<!--- Fulfillment Method --->
													<h5>Shipping Via:</h5>
													#orderFulfillment.getFulfillmentMethod().getFulfillmentMethodName()#<br />
													#arrayLen(orderFulfillment.getOrderFulfillmentItems())# Item(s)
												</div>
												<div class="col-md-6">
													<h5>Shipping To:</h5>
													<!--- EMAIL --->
													<cfif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "email">
														Email Address: #htmlEditFormat( orderFulfillment.getEmailAddress() )#<br />

													<!--- PICKUP --->
													<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup">
														Pickup Location: #htmlEditFormat( orderFulfillment.getPickupLocation().getLocationName() )#

													<!--- SHIPPING --->
													<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
														<cfif not isNull(orderFulfillment.getAddress().getName())>
															#htmlEditFormat( orderFulfillment.getAddress().getName() )#<br />
														</cfif>
														<cfif not isNull(orderFulfillment.getAddress().getCompany())>
															#htmlEditFormat( orderFulfillment.getAddress().getCompany() )#<br />
														</cfif>
														<cfif not isNull(orderFulfillment.getAddress().getStreetAddress())>
															#htmlEditFormat( orderFulfillment.getAddress().getStreetAddress() )#<br />
														</cfif>
														<cfif not isNull(orderFulfillment.getAddress().getStreet2Address())>
															#htmlEditFormat( orderFulfillment.getAddress().getStreet2Address() )#<br />
														</cfif>
														<cfif not isNull(orderFulfillment.getAddress().getLocality())>
															#htmlEditFormat( orderFulfillment.getAddress().getLocality() )#<br />
														</cfif>
														<cfif not isNull(orderFulfillment.getAddress().getCity()) and not isNull(orderFulfillment.getAddress().getStateCode()) and not isNull(orderFulfillment.getAddress().getPostalCode())>
															#htmlEditFormat( orderFulfillment.getAddress().getCity() )#, #htmlEditFormat( orderFulfillment.getAddress().getStateCode() )# #htmlEditFormat( orderFulfillment.getAddress().getPostalCode() )#<br />
														<cfelse>
															<cfif not isNull(orderFulfillment.getAddress().getCity())>
																#htmlEditFormat( orderFulfillment.getAddress().getCity() )#<br />
															</cfif>
															<cfif not isNull(orderFulfillment.getAddress().getStateCode())>
																#htmlEditFormat( orderFulfillment.getAddress().getStateCode() )#<br />
															</cfif>
															<cfif not isNull(orderFulfillment.getAddress().getPostalCode())>
																#htmlEditFormat( orderFulfillment.getAddress().getPostalCode() )#<br />
															</cfif>
														</cfif>
														<cfif not isNull(orderFulfillment.getAddress().getCountryCode())>
															#htmlEditFormat( orderFulfillment.getAddress().getCountryCode() )#<br />
														</cfif>
													</cfif>
												</div>
											</div>
										</cfloop>
										<hr>
									</div>
								</div>
							</cfif>

							<!--- Payment Details --->
							<div class="row-fluid">
								<div class="col-md-12">
									<h4>Payment Details <a href="?step=payment" title="Edit"><span class="glyphicon glyphicon-pencil"></span></a></h4>

									<!--- Get the applied payments smart list, and filter by only payments that are active --->
									<cfset appliedPaymentsSmartList = $.slatwall.cart().getOrderPaymentsSmartList() />
									<cfset appliedPaymentsSmartList.addFilter('orderPaymentStatusType.systemCode', 'opstActive') />

									<cfset orderPaymentReviewIndex = 0 />

									<!--- List the payment methods applied to this order --->
									<cfloop array="#appliedPaymentsSmartList.getRecords()#" index="orderPayment">
										<cfset orderPaymentReviewIndex++ />

										<div class="row-fluid">
											<!--- Display payment method details and payment amount --->
											<div class="col-md-6">
												<h5>Method:</h5>

												<input type="hidden" name="orderPayments[#orderPaymentReviewIndex#].orderPaymentID" value="#orderPayment.getOrderPaymentID()#" />

												<cfif orderPayment.getPaymentMethodType() EQ "creditcard">
													Name on Card: #htmlEditFormat( orderPayment.getNameOnCreditCard() )#<br />
													Card: #orderPayment.getCreditCardType()# ***#orderPayment.getCreditCardLastFour()#<br />
													Expiration: #htmlEditFormat( orderPayment.getExpirationMonth() )# / #htmlEditFormat( orderPayment.getExpirationYear() )#<br />
													Payment Amount: #orderPayment.getFormattedValue('amount')#<br />

													<cfif isNull(orderPayment.getProviderToken()) && !isNull(orderPayment.getSecurityCode())>
														<input type="hidden" name="orderPayments[#orderPaymentReviewIndex#].securityCode" value="#orderPayment.getSecurityCode()#" />

													<cfelseif isNull(orderPayment.getProviderToken())>

														<div class="form-group">
									    					<label for="securityCode">Re-Enter Security Code</label>
									    					<input type="text" name="orderPayments[#orderPaymentReviewIndex#].securityCode" value="" class="form-control required" />
									  					</div>
													</cfif>

												<cfelse>

													#orderPayment.getSimpleRepresentation()#<br />
													Payment Amount: #orderPayment.getFormattedValue('amount')#

												</cfif>
											</div>
											<!--- Display Payment Billing Address, if there one --->
											<cfif not isNull(orderPayment.getBillingAddress())>
												<div class="col-md-6">
													<h6>Billing Address:</h6>
													#htmlEditFormat( orderPayment.getBillingAddress().getName() )#<br />
													<cfif isNull(orderPayment.getBillingAddress().getCompany()) && len(orderPayment.getBillingAddress().getCompany())>
														#htmlEditFormat( orderPayment.getBillingAddress().getCompany() )#<br />
													</cfif>
													<cfif !isNull(orderPayment.getBillingAddress().getPhoneNumber()) && len(orderPayment.getBillingAddress().getCompany())>
														#htmlEditFormat( orderPayment.getBillingAddress().getPhoneNumber() )#<br />
													</cfif>
													#htmlEditFormat( orderPayment.getBillingAddress().getStreetAddress() )#<br />
													<cfif not isNull(orderPayment.getBillingAddress().getStreet2Address()) && len(orderPayment.getBillingAddress().getStreet2Address())>#htmlEditFormat( orderPayment.getBillingAddress().getStreet2Address() )#<br /></cfif>
													#htmlEditFormat( orderPayment.getBillingAddress().getCity() )#, #htmlEditFormat( orderPayment.getBillingAddress().getStateCode() )# #htmlEditFormat( orderPayment.getBillingAddress().getPostalCode() )#<br />
													#htmlEditFormat( orderPayment.getBillingAddress().getCountryCode() )#
												</div>
											</cfif>
										</div>
									</cfloop>
								</div>
							</div>

							<div class="form-group pull-right">
								<!--- Clicking this button will not only add the payment, but it will also attempt to place the order. --->
								<button type="submit" class="btn btn-primary">Place Order</button>
							</div>
						</form>
					</cfif>
				</div>
				<!--- END: CHECKOUT DETAIL --->


				<!--- START: ORDER SUMMARY --->
				<div class="col-md-4">
					<h4>Order Summary</h4>
					<hr />

					<!--- Account Details --->
					<cfif not listFindNoCase(orderRequirementsList, "account") and not $.slatwall.cart().getAccount().isNew()>
						<h5>Account Details <cfif $.slatwall.cart().getAccount().getGuestAccountFlag()><a href="?step=account" title="Edit"><span class="glyphicon glyphicon-pencil"></span></a></cfif></h5>

						<p>
							<!--- Name --->
							<strong>#htmlEditFormat( $.slatwall.cart().getAccount().getFullName() )#</strong><br />

							<!--- Email Address --->
							<cfif len($.slatwall.cart().getAccount().getEmailAddress())>#$.slatwall.cart().getAccount().getEmailAddress()#<br /></cfif>

							<!--- Phone Number --->
							<cfif len($.slatwall.cart().getAccount().getPhoneNumber())>#$.slatwall.cart().getAccount().getPhoneNumber()#<br /></cfif>

							<!--- Logout Link --->
							<cfif not $.slatwall.cart().getAccount().getGuestAccountFlag()>
								<br />
								<a href="?slatAction=public:account.logout">That isn't me ( Logout )</a>
							</cfif>
						</p>

						<hr />
					</cfif>

					<!--- Fulfillment Details --->
					<cfif not listFindNoCase(orderRequirementsList, "account") and not listFindNoCase(orderRequirementsList, "fulfillment")>
						<h5>Fulfillment Details <a href="?step=fulfillment" title="Edit"><span class="glyphicon glyphicon-pencil"></span></a></h5>
						<cfloop array="#$.slatwall.cart().getOrderFulfillments()#" index="orderFulfillment">
							<p>
								<!--- Fulfillment Method --->
								<strong>#orderFulfillment.getFulfillmentMethod().getFulfillmentMethodName()# - #arrayLen(orderFulfillment.getOrderFulfillmentItems())# Item(s)</strong><br />

								<!--- EMAIL --->
								<cfif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "email">
									Email Address: #orderFulfillment.getEmailAddress()#<br />

								<!--- PICKUP --->
								<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup">
									Pickup Location: #orderFulfillment.getPickupLocation().getLocationName()#

								<!--- SHIPPING --->
								<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
									<sw:AddressDisplay address="#orderFulfillment.getAddress()#" />
									<cfif not isNull(orderFulfillment.getShippingMethod())>
										<strong>Shipping Method:</strong> #orderFulfillment.getShippingMethod().getShippingMethodName()#<br />
									</cfif>
								</cfif>
							</p>

							<hr />
						</cfloop>
					</cfif>

					<!--- Order Totals --->
					<h5>Order Totals</h5>
					<table class="table table-condensed">
						<!--- The Subtotal is all of the orderItems before any discounts are applied --->
						<tr>
							<td>Subtotal</td>
							<td>#$.slatwall.cart().getFormattedValue('subtotal')#</td>
						</tr>
						<!--- This displays a delivery cost, some times it might make sense to do a conditional here and check if the amount is > 0, then display otherwise show something like TBD --->
						<tr>
							<td>Delivery</td>
							<td>#$.slatwall.cart().getFormattedValue('fulfillmentTotal')#</td>
						</tr>
						<!--- Displays the total tax that was calculated for this order --->
						<tr>
							<td>Tax</td>
							<td>#$.slatwall.cart().getFormattedValue('taxTotal')#</td>
						</tr>
						<!--- If there were discounts they would be displayed here --->
						<cfif $.slatwall.cart().getDiscountTotal() gt 0>
							<tr>
								<td>Discounts</td>
								<td>#$.slatwall.cart().getFormattedValue('discountTotal')#</td>
							</tr>
						</cfif>
						<!--- The total is the finished amount that the customer can expect to pay --->
						<tr>
							<td><strong>Total</strong></td>
							<td><strong>#$.slatwall.cart().getFormattedValue('total')#</strong></td>
						</tr>
					</table>
				</div>
				<!--- END: ORDER SUMMARY --->
			</div>

<!--- ======================= ORDER PLACED & CONFIRMATION ============================= --->
		<cfelseif not isNull($.slatwall.getSession().getLastPlacedOrderID())>

			<!--- setup the order that just got placed in a local variable to be used by the following display --->
			<cfset order = $.slatwall.getService('orderService').getOrder( $.slatwall.getSession().getLastPlacedOrderID() ) />

			<!--- Overview & Status --->
			<h3>Your Order Has Been Placed!</h3>

			<!--- START: SAVE GUEST ACCOUNT --->

			<!---[DEVELOPER NOTES]

				The below code allows for users to checkout as a guest, and then later once their
				order has been placed they can create just the password so that the my-account section
				just works.  Some website opt to never give the option to create a password up front
				and to only create the password once the order is placed.  It is totally fine to
				remove this functionality all together from the confirmation page

			--->

			<!--- If the createPassword form has been submitted sucessfully display message --->
			<cfif $.slatwall.hasSuccessfulAction( "public:cart.guestAccountCreatePassword" )>
				<div class="alert bg-success">
					Account saved successfully.
				</div>

			<!--- If the form has not been submitted and the account on the order is a guest account, then display the form to create a password --->
			<cfelseif order.getAccount().getGuestAccountFlag()>
				<div class="well">
					<h5>Your order was placed as a guest account.
					Enter a password now so that you can access your order history at a later time from my account.</h5>

					<!--- Setup the createPassword object to be used by form for errors --->
					<cfset createPasswordObj = order.getAccount().getProcessObject("createPassword") />

					<form action="?s=1" method="post">
						<input type="hidden" name="slatAction" value="public:cart.guestAccountCreatePassword" />
						<input type="hidden" name="orderID" value="#order.getOrderID()#" />
						<input type="hidden" name="accountID" value="#order.getAccount().getAccountID()#" />

						<!--- Password --->
						<div class="form-group">
							<label for="password">Password</label>
							<sw:FormField type="password" valueObject="#createPasswordObj#" valueObjectProperty="password" class="form-control" />
							<sw:ErrorDisplay object="#createPasswordObj#" errorName="password" />
						</div>

						<!--- Password Confirm --->
						<div class="form-group">
							<label for="passwordConfirm">Confirm Password</label>
							<sw:FormField type="password" valueObject="#createPasswordObj#" valueObjectProperty="passwordConfirm" class="form-control" />
							<sw:ErrorDisplay object="#createPasswordObj#" errorName="passwordConfirm" />
						</div>

						<!--- Save Account Password --->
						<div class="form-group pull-left">
							<button type="submit" class="btn btn-primary">Save Account Password</button>
						</div>
					</form>

					<br />
				</div>
			</cfif>
			<!--- END: SAVE GUEST ACCOUNT --->

			<div class="row">
				<div class="col-md-4">
					<table class="table table-bordered table-condensed">
						<tr>
							<td>Order Status</td>
							<td>#order.getOrderStatusType().getTypeName()#</td>
						</tr>
						<tr>
							<td>Order ##</td>
							<td>#order.getOrderNumber()#</td>
						</tr>
						<tr>
							<td>Order Placed</td>
							<td>#order.getFormattedValue('orderOpenDateTime')#</td>
						</tr>
					</table>
				</div>
				<div class="col-md-4 offset3 pull-right">
					<table class="table table-bordered table-condensed">
						<tr>
							<td>Subtotal</td>
							<td>#order.getFormattedValue('subTotalAfterItemDiscounts')#</td>
						</tr>
						<tr>
							<td>Delivery Charges</td>
							<td>#order.getFormattedValue('fulfillmentChargeAfterDiscountTotal')#</td>
						</tr>
						<tr>
							<td>Taxes</td>
							<td>#order.getFormattedValue('taxTotal')#</td>
						</tr>
						<tr>
							<td><strong>Total</strong></td>
							<td><strong>#order.getFormattedValue('total')#</strong></td>
						</tr>
						<cfif order.getDiscountTotal() gt 0>
							<tr>
								<td colspan="2" class="text-error">You saved #order.getFormattedValue('discountTotal')# on this order.</td>
							</tr>
						</cfif>
					</table>
				</div>
			</div>

			<!--- Start: Order Details --->
			<hr />
			<h4>Order Details</h4>
			<cfloop array="#order.getOrderFulfillments()#" index="orderFulfillment">
				<!--- Start: Fulfillment Table --->
				<table class="table table-bordered table-condensed">
					<tr>
						<!--- Fulfillment Details --->
						<td class="well col-md-3" rowspan="#arrayLen(orderFulfillment.getOrderFulfillmentItems()) + 1#">
							<!--- Fulfillment Name --->
							<strong>#orderFulfillment.getFulfillmentMethod().getFulfillmentMethodName()#</strong><br />

							<!--- Fulfillment Details: Email --->
							<cfif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "email">
								<strong>Email Address:</strong> #orderFulfillment.getEmailAddress()#<br />

							<!--- Fulfillment Details: Pickup --->
							<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup" and not isNull(orderFulfillment.getPickupLocation())>
								<strong>Pickup Location:</strong> #orderFulfillment.getPickupLocation().getLocationName()#<br />
								<sw:AddressDisplay address="#orderFulfillment.getPickupLocation().getPrimaryAddress().getAddress()#" />

							<!--- Fulfillment Details: Shipping --->
							<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
								<sw:AddressDisplay address="#orderFulfillment.getAddress()#" />
								<cfif not isNull(orderFulfillment.getShippingMethod())>
									<strong>Shipping Method:</strong> #orderFulfillment.getShippingMethod().getShippingMethodName()#<br />
								</cfif>
							</cfif>

							<br />
							<!--- Delivery Fee --->
							<strong>Delivery Fee:</strong> #orderFulfillment.getFormattedValue('chargeAfterDiscount')#
						</td>

						<!--- Additional Header Rows --->
						<th>Sku Code</th>
						<th>Product Title</th>
						<th>Qty.</th>
						<th>Price</th>
						<th>Status</th>
					</tr>

					<!--- Loop over the actual items in this orderFulfillment --->
					<cfloop array="#orderFulfillment.getOrderFulfillmentItems()#" index="orderItem">
						<tr>
							<!--- Sku Code --->
							<td>#orderItem.getSku().getSkuCode()#</td>

							<!--- Product Title --->
							<td>#orderItem.getSku().getProduct().getTitle()#</td>

							<!--- Quantity --->
							<td>#htmlEditFormat( orderItem.getQuantity())#</td>

							<!--- Price --->
							<td>
								<cfif orderItem.getExtendedPrice() gt orderItem.getExtendedPriceAfterDiscount()>
									<span style="text-decoration:line-through;">#orderItem.getFormattedValue('extendedPrice')#</span> <span class="text-error">#orderItem.getFormattedValue('extendedPriceAfterDiscount')#</span><br />
								<cfelse>
									#orderItem.getFormattedValue('extendedPriceAfterDiscount')#
								</cfif>
							</td>

							<!--- Status --->
							<td>#orderItem.getOrderItemStatusType().getTypeName()#</td>
						</tr>
					</cfloop>
				</table>
				<!--- End: Fulfillment Table --->
			</cfloop>
			<!--- End: Order Details --->

			<!--- Start: Order Payments --->
			<hr />
			<h4>Order Payments</h4>
			<table class="table table-bordered table-condensed table-striped">
				<tr>
					<th>Billing</td>
					<th>Payment Details</td>
					<th>Amount</td>
				</tr>
				<cfloop array="#order.getOrderPayments()#" index="orderPayment">
					<cfif orderPayment.getOrderPaymentStatusType().getSystemCode() EQ "opstActive">
						<tr>
							<td class="well col-md-3">
								<sw:AddressDisplay address="#orderPayment.getBillingAddress()#" />
							</td>
							<td>#orderPayment.getSimpleRepresentation()#</td>
							<td>#orderPayment.getFormattedValue('amount')#</td>
						</tr>
					</cfif>
				</cfloop>
			</table>
			<!--- End: Order Payments --->

<!--- ======================= NO ITEMS IN CART ============================= --->
		<cfelse>

			<div class="row">
				<div class="col-md-12">
					<p>There are no items in your cart.</p>
				</div>
			</div>
		</cfif>
		<!--- END CHECKOUT EXAMPLE 1 --->
	</div>
</cfoutput>

<cfinclude template="_slatwall-footer.cfm" />