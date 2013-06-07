<!---
	
    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC
	
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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.
	
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
<cfimport prefix="sw" taglib="/Slatwall/public/tags" />

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
	<cfif $.slatwall.account().getGuestAccountFlag()>
		
		<!--- OPTIONAL: This condition can be left in if you would like to make it so that a guest checkout is only valid if the page is refreshed via a form post with guestCheckoutFlag always passed across --->
		<cfif structKeyExists(form, "guestAccountFlag") && form.guestAccountFlag>
			<cfset orderRequirementsList = listDeleteAt(orderRequirementsList, listFindNoCase(orderRequirementsList, "account")) />
		</cfif>
		<!--- IMPORTANT: If you delete the above contitional so that a guest can move about the site without loosing their checkout data, then you will want to uncomment below --->
		<!--- <cfset orderRequirementsList = listDeleteAt(orderRequirementsList, listFindNoCase(orderRequirementsList, "account")) /> ---> 
		
	</cfif>
</cfif>

<cfoutput>
	<div class="container">
		
		<!--- START CEHECKOUT EXAMPLE 1 --->
		<div class="row">
			<div class="span12">
				<h3>Checkout Example ( 3 or 4 Step Process: Account-Fulfillment-Payment-Confirm )</h3>
			</div>
		</div>
		
		<!--- Verify that there are items in the cart --->
		<cfif arrayLen($.slatwall.cart().getOrderItems())>
			<div class="row">
				
				<!--- START: CHECKOUT DETAIL --->
				<div class="span8">
					
					
<!--- ============== ACCOUNT ========================================= --->
					<cfif listFindNoCase(orderRequirementsList, "account")>
						
						<!--- START: ACCOUNT --->
						<h4>Step 1 - Account Details</h4>
						
						<div class="row">
							
							<!--- LOGIN --->
							<div class="span4">
								
								<h5>Login with Existing Account</h5>
								
								<!--- Sets up the account login processObject --->
								<cfset accountLoginObj = $.slatwall.getAccount().getProcessObject('login') />
								
								<!--- Start: Login Form --->
								<form action="?s=1" method="post">
									
									<!--- This hidden input is what tells slatwall to try and login the account --->
									<input type="hidden" name="slatAction" value="public:account.login" />
									
									<!--- Email Address --->
									<div class="control-group">
				    					<label class="control-label" for="rating">Email Address</label>
				    					<div class="controls">
				    						
											<sw:formField type="text" valueObject="#accountLoginObj#" valueObjectProperty="emailAddress" class="span4" />
											<sw:errorDisplay object="#accountLoginObj#" errorName="emailAddress" />
											
				    					</div>
				  					</div>
									
									<!--- Password --->
									<div class="control-group">
				    					<label class="control-label" for="rating">Password</label>
				    					<div class="controls">
				    						
											<sw:formField type="password" valueObject="#accountLoginObj#" valueObjectProperty="password" class="span4" />
											<sw:errorDisplay object="#accountLoginObj#" errorName="password" />
											
				    					</div>
				  					</div>
									
									<!--- Login Button --->
									<div class="control-group">
				    					<div class="controls">
				      						<button type="submit" class="btn btn-primary">Login & Continue</button>
				    					</div>
				  					</div>
									
								</form>
								<!--- End: Login Form --->
									
								<hr />
								
								<h5>Forgot Password</h5>
								
								<!--- Sets up the account login processObject --->
								<cfset forgotPasswordObj = $.slatwall.getAccount().getProcessObject('forgotPassword') />
								
								<!--- Start: Forgot Password Form --->
								<form action="?s=1" method="post">
									
									<!--- This hidden input is what tells slatwall to try and login the account --->
									<input type="hidden" name="slatAction" value="public:account.forgotPassword" />
									
									<!--- Email Address --->
									<div class="control-group">
				    					<label class="control-label" for="rating">Email Address</label>
				    					<div class="controls">
				    						
											<sw:formField type="text" valueObject="#accountLoginObj#" valueObjectProperty="emailAddress" class="span4" />
											<sw:errorDisplay object="#forgotPasswordObj#" errorName="emailAddress" />
											
				    					</div>
				  					</div>
									
									<!--- Reset Email Button --->
									<div class="control-group">
				    					<div class="controls">
				      						<button type="submit" class="btn">Send Me Reset Email</button>
				    					</div>
				  					</div>
									
								</form>
								<!--- End: Forgot Password Form --->
								
							</div>
							
							<!--- CREATE ACCOUNT --->
							<div class="span4">
								<h5>Create New Account</h5>
								
								<!--- Sets up the create account processObject --->
								<cfset createAccountObj = $.slatwall.account().getProcessObject('create') />
								
								<!--- Create Account Form --->
								<form action="?s=1" method="post">
									<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
									<input type="hidden" name="slatAction" value="public:account.create,public:account.login" />
									
									<!--- This is also passed so that guestCheckout will work when the page is reloaded --->
									<input type="hidden" name="guestCheckoutFlag" value="1" />
									
									<!--- Name --->
									<div class="row">
										
										<!--- First Name --->
										<div class="span2">
											<div class="control-group">
						    					<label class="control-label" for="rating">First Name</label>
						    					<div class="controls">
						    						
													<sw:formField type="text" valueObject="#createAccountObj#" valueObjectProperty="firstName" class="span2" />
													<sw:errorDisplay object="#createAccountObj#" errorName="firstName" />
													
						    					</div>
						  					</div>
										</div>
										
										<!--- Last Name --->
										<div class="span2">
											<div class="control-group">
						    					<label class="control-label" for="rating">Last Name</label>
						    					<div class="controls">
						    						
													<sw:formField type="text" valueObject="#createAccountObj#" valueObjectProperty="lastName" class="span2" />
													<sw:errorDisplay object="#createAccountObj#" errorName="lastName" />
													
						    					</div>
						  					</div>
										</div>
										
									</div>
									
									<!--- Phone Number --->
									<div class="control-group">
				    					<label class="control-label" for="rating">Phone Number</label>
				    					<div class="controls">
				    						
											<sw:formField type="text" valueObject="#createAccountObj#" valueObjectProperty="phoneNumber" class="span4" />
											<sw:errorDisplay object="#createAccountObj#" errorName="phoneNumber" />
											
				    					</div>
				  					</div>
									
									<!--- Email Address --->
									<div class="control-group">
				    					<label class="control-label" for="rating">Email Address</label>
				    					<div class="controls">
				    						
											<sw:formField type="text" valueObject="#createAccountObj#" valueObjectProperty="emailAddress" class="span4" />
											<sw:errorDisplay object="#createAccountObj#" errorName="emailAddress" />
											
				    					</div>
				  					</div>
									
									<!--- Email Address Confirm --->
									<div class="control-group">
				    					<label class="control-label" for="rating">Confirm Email Address</label>
				    					<div class="controls">
				    						
											<sw:formField type="text" valueObject="#createAccountObj#" valueObjectProperty="emailAddressConfirm" class="span4" />
											<sw:errorDisplay object="#createAccountObj#" errorName="emailAddressConfirm" />
											
				    					</div>
				  					</div>
									
									<!--- Guest Checkout --->
									<div class="control-group">
				    					<label class="control-label" for="rating">Save Account ( No for Guest Checkout )</label>
				    					<div class="controls">
				    						
											<sw:formField type="yesno" valueObject="#createAccountObj#" valueObjectProperty="createAuthenticationFlag" />
											<sw:errorDisplay object="#createAccountObj#" errorName="createAuthenticationFlag" />
											
				    					</div>
				  					</div>
									
									<!--- SCRIPT IMPORTANT: This jQuery is just here for example purposes to show/hide the password fields if guestCheckout it set to true / false --->
									<script type="text/javascript">
										(function($){
											$(document).ready(function(){
												$('body').on('change', 'input[name="createAuthenticationFlag"]', function(e){
													if( $(this).val() == 0 ) {
														$('##password-details').hide();
													} else {
														$('##password-details').show();	
													}
												});
												$('input[name="createAuthenticationFlag"]:checked').change();
											});
										})( jQuery )
									</script>
									
									<!--- Password --->
									<div id="password-details" >
										<div class="control-group">
					    					<label class="control-label" for="rating">Password</label>
					    					<div class="controls">
					    						
												<sw:formField type="password" valueObject="#createAccountObj#" valueObjectProperty="password" class="span4" />
												<sw:errorDisplay object="#createAccountObj#" errorName="password" />
												
					    					</div>
					  					</div>
										
										<!--- Password Confirm --->
										<div class="control-group">
					    					<label class="control-label" for="rating">Confirm Password</label>
					    					<div class="controls">
					    						
												<sw:formField type="password" valueObject="#createAccountObj#" valueObjectProperty="passwordConfirm" class="span4" />
												<sw:errorDisplay object="#createAccountObj#" errorName="password" />
												
					    					</div>
					  					</div>
									</div>
									
									<!--- Create Button --->
									<div class="control-group pull-right">
				    					<div class="controls">
				      						<button type="submit" class="btn btn-primary">Create Account & Continue</button>
				    					</div>
				  					</div>
									
								</form>
								<!--- End: Create Account Form --->
								
								
							</div>
							
						</div>
						<!--- END: ACCOUNT --->
					
<!--- ============= FULFILLMENT ============================================== --->
					<cfelseif listFindNoCase(orderRequirementsList, "fulfillment")>
						
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
								<cfif not orderFulfillment.isProcessable( context="placeOrder" ) or orderFulfillment.hasErrors()>
									
									<div class="row">
										
										<!---[DEVELOPER NOTES]																		
																																	
											Based on the fulfillmentMethodType we will display different form elements for the		
											end user to fill out.  The 'auto' fulifllment method type and 'download' fulfillment	
											method type, have no values that need to get input and that is why you don't see		
											them in the conditionals below.															
																																	
										--->
										
										<!--- EMAIL --->
										<cfif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "email">
											
											<!--- Email Address --->
											<div class="control-group">
						    					<label class="control-label" for="rating">Email Address</label>
						    					<div class="controls">
						    						
													<sw:formField type="text" name="orderFulfillments[#orderFulfillmentIndex#].emailAddress" valueObject="#orderFulfillment#" valueObjectProperty="emailAddress" class="span4" />
													<sw:errorDisplay object="#orderFulfillment#" errorName="emailAddress" />
													
						    					</div>
						  					</div>
											
										<!--- PICKUP --->
										<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup">
											
											<!--- Pickup Location --->
											<div class="control-group">
						    					<label class="control-label" for="rating">Pickup Location</label>
						    					<div class="controls">
						    						
													<sw:formField type="select" name="orderFulfillments[#orderFulfillmentIndex#].pickupLocation.locationID" valueObject="#orderFulfillment#" valueObjectProperty="pickupLocation" valueOptions="#orderFulfillment.getPickupLocationOptions()#" class="span4" />
													<sw:errorDisplay object="#orderFulfillment#" errorName="pickupLocation" />
													
						    					</div>
						  					</div>
										
										<!--- SHIPPING --->
										<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
											
											<!--- Increment the orderFulfillment index so that we can update multiple order fulfillments at once --->
											<cfset orderFulfillmentIndex++ />
											<input type="hidden" name="orderFulfillments[#orderFulfillmentIndex#].orderFulfillmentID" value="#orderFulfillment.getOrderFulfillmentID()#" />
											
											<div class="span4">
												<h5>Shipping Address</h5>
												
												<!--- If there are existing account addresses, then we can allow the user to select one of those --->
												<cfif arrayLen(orderFulfillment.getAccountAddressOptions())>
													
													<!--- Account Address --->
													<div class="control-group">
								    					<label class="control-label" for="rating">Select Existing Address</label>
								    					<div class="controls">
								    						
															<sw:formField type="select" name="orderFulfillments[#orderFulfillmentIndex#].accountAddress.accountAddressID" valueObject="#orderFulfillment#" valueObjectProperty="accountAddress" valueOptions="#orderFulfillment.getAccountAddressOptions()#" class="span4" />
															<sw:errorDisplay object="#orderFulfillment#" errorName="accountAddress" />
															
								    					</div>
								  					</div>
													
													<hr />
												</cfif>
												
												<!--- New Shipping Address --->
												<sw:addressForm id="newShippingAddress" address="#orderFulfillment.getAddress()#" fieldNamePrefix="orderFulfillments[#orderFulfillmentIndex#].shippingAddress." fieldClass="span4" />
												
											</div>
											
											<!--- START: Shipping Method Selection --->
											<div class="span4">
												<h5>Shipping Method</h5>
												
												<!--- If there are multiple shipping methods to select from, then display that --->
												<cfif arrayLen(orderFulfillment.getShippingMethodOptions()) gt 1>
													
													<!--- Start: Shipping Method Example 1 --->
													<div class="control-group">
								    					<label class="control-label" for="rating">Shipping Method Example</label>
								    					<div class="controls">
								    						
															<!--- OPTIONAL: You can use this formField display to show options as a select box
															<sw:formField type="select" name="orderFulfillments[#orderFulfillmentIndex#].shippingMethod.shippingMethodID" valueObject="#orderFulfillment#" valueObjectProperty="shippingMethod" valueOptions="#orderFulfillment.getShippingMethodOptions()#" class="span4" />
															--->
															
															<sw:formField type="radiogroup" name="orderFulfillments[#orderFulfillmentIndex#].shippingMethod.shippingMethodID" valueObject="#orderFulfillment#" valueObjectProperty="shippingMethod" valueOptions="#orderFulfillment.getShippingMethodOptions()#" />
															<sw:errorDisplay object="#orderFulfillment#" errorName="shippingMethod" />
															
								    					</div>
								  					</div>
													<!--- End: Shipping Method Example 1 --->
														
												<!--- If there is only 1 shipping method option that comes back, then we can just tell the customer how there order will be shipped --->
												<cfelseif arrayLen(orderFulfillment.getShippingMethodOptions()) and len(orderFulfillment.getShippingMethodOptions()[1]['value'])>
												
													<!--- We should still pass the shipping method as a hidden value --->
													<input type="hidden" name="orderFulfillments[#orderFulfillmentIndex#].shippingMethod.shippingMethodID" value="#orderFulfillment.getShippingMethodOptions()[1]['value']#" />
													
													<p>This order will be shipped via: #orderFulfillment.getShippingMethodOptions()[1].getShippingMethodRate().getShippingMethod().getShippingMethodName()# ( #orderFulfillment.getShippingMethodOptions()[1].getFormattedValue('totalCharge')# )</p>
													
												<!--- Show message to customer telling them that they need to fill in an address before we can provide a shipping method quote --->
												<cfelse>
													
													<!--- If the user has not yet defined their shipping address, then we can display a note for them --->
													<cfif orderFulfillment.getAddress().getNewFlag()>
														<p>Please update your shipping address first so that we can provide you with the correct shipping rates.</p>
														
													<!--- If they have already provided an address, and there are still no shipping method options, then the address they entered is not one that can be shipped to --->
													<cfelse>
														
														<p>Unfortunatly the shipping address that you have provided is not one that we ship to.  Please update your shipping address and try again, or contact customer service for more information.</p>
														
													</cfif>
													
												</cfif>
											</div>
											<!--- END: Shipping Method Selection --->
											
											<!--- Action Buttons --->
											<div class="span8">
												<div class="control-group pull-right">
													<div class="controls">
														<!--- Continue, just submits the form --->
														<button type="submit" class="btn btn-primary">Save & Continue</button>
													</div>
												</div>
											</div>
											
										</cfif>
										
									</div>
									
								</cfif>
								
							</cfloop>
							
						</form>
						<!--- END: FULFILLMENT --->
							
<!--- ============= PAYMENT ============================================== --->
					<cfelseif listFindNoCase(orderRequirementsList, "payment")>
					
						<!--- get the eligable payment methods for this order --->
						<cfset eligiblePaymentMethods = $.slatwall.cart().getEligiblePaymentMethodDetails() />
						
						<!--- START: PAYMENT --->
						<h4>Step 3 - Payment Details</h4>
						
						<br />
						<!--- Display existing order payments --->
						<cfif arrayLen($.slatwall.cart().getOrderPayments())>
							<h5>Payments Applied</h5>
							<table class="table">
								<tr>
									<th>Payment Details</th>
									<th>Amount</th>
									<th>&nbsp;</th>
								</tr>
								<cfloop array="#$.slatwall.cart().getOrderPayments()#" index="orderPayment">
									<cfdump var="#orderPayment.getErrors()#" />
									<tr>
										<td>#orderPayment.getSimpleRepresentation()#</td>
										<td>#orderPayment.getAmount()#</td>
										<td><a href="?slatAction=public:cart.removeOrderPayment&orderPaymentID=#orderPayment.getOrderPaymentID#">Remove</a></td>
									</tr>
								</cfloop>
							</table>
						</cfif>
						
						<!--- Payment Method Nav Tabs --->
						<ul class="nav nav-tabs" id="myTab">
							
							<!--- This first variables here is only used to define the 'active' tab for bootstrap css to take over --->
							<cfset first = true />
							
							<!--- If the user has "AccountPaymentMethods" then we can first display a tab that allows them to select from existing payment methods ---> 
							<cfif arrayLen($.slatwall.account().getAccountPaymentMethods())>
								<li class="active"><a href="##account-payment-methods" data-toggle="tab">Use Saved Payment Info</a></li>
								<cfset first = false />
							</cfif>
							
							<!--- Loop over all of the eligible payment methods --->
							<cfloop array="#eligiblePaymentMethods#" index="paymentDetails">
								<li class="#iif(first, de('active'), de(''))#"><a href="##tab#paymentDetails.paymentMethod.getPaymentMethodID()#" data-toggle="tab">Pay with #paymentDetails.paymentMethod.getPaymentMethodName()#</a></li>
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
										</cfloop>
										
										<!--- This button will just add the order payment, but not actually process the order --->
										<button type="submit" class="btn" name="slatAction" value="public:cart.addOrderPayment">Apply Payment Method & Review</button>
										
										<!--- Clicking this button will not only add the payment, but it will also attempt to place the order. --->
										<button type="submit" class="btn btn-primary" name="slatAction" value="public:cart.placeOrder">Apply Payment Method & Place Order</button>
									</form>
								</div>
								<cfset first = false />
							</cfif>
							
							<!--- Loop over all of the eligible payment methods --->
							<cfloop array="#eligiblePaymentMethods#" index="paymentDetails">
								
								<div class="tab-pane#iif(first, de(' active'), de(''))#" id="tab#paymentDetails.paymentMethod.getPaymentMethodID()#">
									
									<form action="?s=1" method="post">
										
										<!--- Hidden value to identify the type of payment method this is --->
										<input type="hidden" name="newOrderPayment.orderPaymentID" value="" />
										<input type="hidden" name="newOrderPayment.order.orderID" value="#$.slatwall.cart().getOrderID()#" />
										<input type="hidden" name="newOrderPayment.paymentMethod.paymentMethodID" value="#paymentDetails.paymentMethod.getPaymentMethodID()#" />
										
										<!--- CASH --->
										<cfif paymentDetails.paymentMethod.getPaymentMethodType() eq "cash">
											
										<!--- CHECK --->
										<cfelseif paymentDetails.paymentMethod.getPaymentMethodType() eq "check">
											
										<!--- CREDIT CARD --->
										<cfelseif paymentDetails.paymentMethod.getPaymentMethodType() eq "creditCard">
											<div class="row">
												<div class="span4">
													<h5>Billing Address</h5>
													
													<sw:addressForm id="newBillingAddress" address="#addOrderPaymentObj.getNewOrderPayment().getBillingAddress()#" fieldNamePrefix="newOrderPayment.billingAddress." fieldClass="span4" />
												</div>
												<div class="span4">
													<h5>Credit Card Info</h5>
													
													<!--- Credit Card Number --->
													<div class="control-group">
								    					<label class="control-label" for="rating">Credit Card Number</label>
								    					<div class="controls">
								    						
															<sw:formField type="text" name="newOrderPayment.creditCardNumber" valueObject="#addOrderPaymentObj.getNewOrderPayment()#" valueObjectProperty="creditCardNumber" class="span4" />
															<sw:errorDisplay object="#addOrderPaymentObj.getNewOrderPayment()#" errorName="newOrderPayment" />
															
								    					</div>
								  					</div>
													
													<!--- Name on Credit Card --->
													<div class="control-group">
								    					<label class="control-label" for="rating">Name on Card</label>
								    					<div class="controls">
								    						
															<sw:formField type="text" name="newOrderPayment.nameOnCreditCard" valueObject="#addOrderPaymentObj.getNewOrderPayment()#" valueObjectProperty="nameOnCreditCard" class="span4" />
															<sw:errorDisplay object="#addOrderPaymentObj.getNewOrderPayment()#" errorName="nameOnCreditCard" />
															
								    					</div>
								  					</div>
													
													<!--- Security & Expiration Row --->
													<div class="row">
														
														<div class="span2">
															
															<!--- Security Code --->
															<div class="control-group">
										    					<label class="control-label" for="rating">Security Code</label>
										    					<div class="controls">
										    						
																	<sw:formField type="text" name="newOrderPayment.securityCode" valueObject="#addOrderPaymentObj.getNewOrderPayment()#" valueObjectProperty="securityCode" class="span2" />
																	<sw:errorDisplay object="#addOrderPaymentObj.getNewOrderPayment()#" errorName="securityCode" />
																	
										    					</div>
										  					</div>
															
														</div>
														
														
														<div class="span2">
															
															<!--- Expiration --->	
															<div class="control-group">
										    					<label class="control-label pull-right" for="rating">Expiration ( MM / YYYY )</label>
										    					<div class="controls pull-right">
										    						
																	<sw:formField type="select" name="newOrderPayment.expirationMonth" valueObject="#addOrderPaymentObj.getNewOrderPayment()#" valueObjectProperty="expirationMonth" valueOptions="#addOrderPaymentObj.getNewOrderPayment().getExpirationMonthOptions()#" class="span1" />
																	<sw:formField type="select" name="newOrderPayment.expirationYear" valueObject="#addOrderPaymentObj.getNewOrderPayment()#" valueObjectProperty="expirationYear" valueOptions="#addOrderPaymentObj.getNewOrderPayment().getExpirationYearOptions()#" class="span1" />
																	<sw:errorDisplay object="#addOrderPaymentObj.getNewOrderPayment()#" errorName="expirationMonth" />
																	<sw:errorDisplay object="#addOrderPaymentObj.getNewOrderPayment()#" errorName="expirationYear" />
																	
										    					</div>
										  					</div>
															
														</div>
													</div>
													
													<!--- SPLIT PAYMENTS (OPTIONAL) - Just delete this section if you don't want to allow for split payments --->
													<cfset splitPaymentID = "sp" & lcase(createUUID()) />
													<div class="control-group">
								    					<label class="control-label" for="rating">Amount</label>
								    					<div class="controls">
								    						
								    						#$.slatwall.formatValue(paymentDetails.maximumAmount, 'currency')#
								    						<a href="##" id='#splitPaymentID#'>Split Payment</a>
								    						
								    					</div>
								  					</div>
													<script type="text/javascript">
														(function($){
															$(document).ready(function(e){
																
																// Bind to split button
																$('body').on('click', '###splitPaymentID#', function(e){
																	e.preventDefault();
																	$(this).closest('div').html('<input type="text" name="newOrderPayment.amount" value="#paymentDetails.maximumAmount#" class="span4" />');
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
										
										<div class="control-group pull-right">
											<div class="controls">
												<!--- This button will just add the order payment, but not actually process the order --->
												<button type="submit" class="btn" name="slatAction" value="public:cart.addOrderPayment">Add Payment & Review</button>
												
												<!--- Clicking this button will not only add the payment, but it will also attempt to place the order. --->
												<button type="submit" class="btn btn-primary" name="slatAction" value="public:cart.placeOrder">Add Payment & Place Order</button>
											</div>
										</div>
									</form>
								</div>
								
								<cfset first = false />
							</cfloop>
						</div>
						
						<!--- END: PAYMENT --->
							
<!--- ============= CONFIRMATION ============================================== --->
					<cfelseif not len(orderRequirementsList)>
						<h4>Step 4 - Confirmation</h4>
						
						
					</cfif>
						
				</div>
				<!--- END: CHECKOUT DETAIL --->
				
				
				<!--- START: ORDER SUMMARY --->
				<div class="span4">
					
					<h4>Order Summary</h4>
					<hr />
					
					<!--- Account Details --->
					<cfif not listFindNoCase(orderRequirementsList, "account") and not $.slatwall.cart().getAccount().isNew()>
						<h5>Account Details</h5>
						
						<p>
							<!--- Name --->
							<strong>#$.slatwall.cart().getAccount().getFullName()#</strong><br />
							
							<!--- Email Address --->
							<cfif len($.slatwall.cart().getAccount().getEmailAddress())>#$.slatwall.cart().getAccount().getEmailAddress()#<br /></cfif>
							
							<!--- Phone Number --->
							<cfif len($.slatwall.cart().getAccount().getPhoneNumber())>#$.slatwall.cart().getAccount().getPhoneNumber()#<br /></cfif>
							
							<!--- Logout Link --->
							<a href="?slatAction=public:account.logout">That isn't me ( logout )</a>
								
						</p>
						
						<hr />
					</cfif>
					
					<!--- Fulfillment Details --->
					<cfif not listFindNoCase(orderRequirementsList, "account") and not $.slatwall.cart().getAccount().isNew()>
						<h5>Fulfillment Details</h5>
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
									<cfif not isNull(orderFulfillment.getAddress().getName())>
										#orderFulfillment.getAddress().getName()#<br />
									</cfif>
									<cfif not isNull(orderFulfillment.getAddress().getCompany())>
										#orderFulfillment.getAddress().getCompany()#<br />
									</cfif>
									<cfif not isNull(orderFulfillment.getAddress().getStreetAddress())>
										#orderFulfillment.getAddress().getStreetAddress()#<br />
									</cfif>
									<cfif not isNull(orderFulfillment.getAddress().getStreet2Address())>
										#orderFulfillment.getAddress().getStreet2Address()#<br />
									</cfif>
									<cfif not isNull(orderFulfillment.getAddress().getLocality())>
										#orderFulfillment.getAddress().getLocality()#<br />
									</cfif>
									<cfif not isNull(orderFulfillment.getAddress().getCity()) and not isNull(orderFulfillment.getAddress().getStateCode()) and not isNull(orderFulfillment.getAddress().getPostalCode())>
										#orderFulfillment.getAddress().getCity()#, #orderFulfillment.getAddress().getStateCode()# #orderFulfillment.getAddress().getPostalCode()#<br />
									<cfelse>
										<cfif not isNull(orderFulfillment.getAddress().getCity())>
											#orderFulfillment.getAddress().getCity()#<br />
										</cfif>
										<cfif not isNull(orderFulfillment.getAddress().getStateCode())>
											#orderFulfillment.getAddress().getStateCode()#<br />
										</cfif>
										<cfif not isNull(orderFulfillment.getAddress().getPostalCode())>
											#orderFulfillment.getAddress().getPostalCode()#<br />
										</cfif>
									</cfif>
									<cfif not isNull(orderFulfillment.getAddress().getCountryCode())>
										#orderFulfillment.getAddress().getCountryCode()#<br />
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
		<cfelseif $.slatwall.hasSessionValue('confirmationOrderID')>
			
			<!--- setup the order that just got placed in a local variable to be used by the following display --->
			<cfset order = $.slatwall.getService('orderService').getOrder( $.slatwall.getSessionValue('confirmationOrderID') ) />
			
			<!--- Overview & Status --->
			<h5>Your Order Has Been Placed!</h5>
			<div class="row">
				
				<div class="span4">
					<table class="table table-bordered table-condensed">
						<tr>
							<td>Order Status</td>
							<td>#order.getOrderStatusType().getType()#</td>
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
				<div class="span3">
					<div class="btn-group">
					    <a class="btn btn-large" href="##"><i class="icon-phone"></i></a>
					    <a class="btn btn-large" href="##"><i class="icon-envelope"></i></a>
					    <a class="btn btn-large" href="##"><i class="icon-print"></i></a>
					</div>
					<br />
					<br />
					<p>
						If you have questions about your order, please contact customer service <a href="tel:888.555.5555">888.555.5555</a>
					</p>
				</div>
				<div class="span4 pull-right">
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
			<h5>Order Details</h5>
			<cfloop array="#order.getOrderFulfillments()#" index="orderFulfillment">
				
				<!--- Start: Fulfillment Table --->
				<table class="table table-bordered table-condensed">
					<tr>
						<!--- Fulfillment Details --->
						<td class="well span3" rowspan="#arrayLen(orderFulfillment.getOrderFulfillmentItems()) + 1#">
							
							<!--- Fulfillment Name --->
							<strong>#orderFulfillment.getFulfillmentMethod().getFulfillmentMethodName()#</strong><br />
							
							<!--- Fulfillment Details: Email --->
							<cfif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "email">
								<strong>Email Address:</strong> #orderFulfillment.getEmailAddress()#<br />
								
							<!--- Fulfillment Details: Pickup --->
							<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup" and not isNull(orderFulfillment.getPickupLocation())>
								<strong>Pickup Location:</strong> #orderFulfillment.getPickupLocation().getLocationName()#<br />
								<sw:addressDisplay address="#orderFulfillment.getPickupLocation().getPrimaryAddress().getAddress()#" />
								
							<!--- Fulfillment Details: Shipping --->
							<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
								<sw:addressDisplay address="#orderFulfillment.getAddress()#" />
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
							<td>#orderItem.getQuantity()#</td>
							
							<!--- Price --->
							<td>
								<cfif orderItem.getExtendedPrice() gt orderItem.getExtendedPriceAfterDiscount()>
									<span style="text-decoration:line-through;">#orderItem.getFormattedValue('extendedPrice')#</span> <span class="text-error">#orderItem.getFormattedValue('extendedPriceAfterDiscount')#</span><br />
								<cfelse>
									#orderItem.getFormattedValue('extendedPriceAfterDiscount')#	
								</cfif>
							</td>
							
							<!--- Status --->
							<td>#orderItem.getOrderItemStatusType().getType()#</td>
						</tr>
					</cfloop>
					
				</table>
				<!--- End: Fulfillment Table --->
					
			</cfloop>
			<!--- End: Order Details --->
			
			<!--- Start: Order Payments --->
			<hr />
			<h5>Order Payments</h5>
			<table class="table table-bordered table-condensed table-striped">
				<tr>
					<th>Payment Details</td>
					<th>Amount</td>
				</tr>
				<cfloop array="#order.getOrderPayments()#" index="orderPayment">
					<tr>
						<td>#orderPayment.getSimpleRepresentation()#</td>
						<td>#orderPayment.getFormattedValue('amount')#</td>
					</tr>
				</cfloop>
			</table>
			<!--- End: Order Payments --->
			
<!--- ======================= NO ITEMS IN CART ============================= --->
		<cfelse> 
			<div class="row">
				<div class="span12">
					<p>There are no items in your cart.</p>
				</div>
			</div>
			
		</cfif>
		
		<!--- END CHECKOUT EXAMPLE 1 --->
		
	</div>
</cfoutput>
<cfinclude template="_slatwall-footer.cfm" />