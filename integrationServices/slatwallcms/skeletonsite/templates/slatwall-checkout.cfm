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
<cfimport prefix="sw" taglib="../tags" />

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
<cfoutput>

	<!--- initial data--->
	<span ng-init="slatwall.currentAccountPage = 'Login'"></span>
	
	
	<!---new template start--->
	<div class="container">
        <h1 class="my-4">Checkout</h4>

        <div class="row">
            <!-- Checkout body -->
            <div class="col-12 col-md-8">
                <div class="card">
                    <div class="card-header">
                        <!-- Checkout tabbed nav -->
                        <ul class="nav nav-pills nav-fill" id="pills-tab" role="tablist" swf-navigation>
                            <li class="nav-item">
                                <a class="nav-link" ng-class="{disabled:swfNavigation.accountTabDisabled}" id="account-tab" data-toggle="pill" href="##pills-account" role="tab" aria-controls="account" aria-selected="true">Account</a>
                            </li>
                            <!---disabled commented out but is used to when logic wants a button to be unclickable--->
                            <li class="nav-item">
                                <a class="nav-link" ng-class="{disabled:swfNavigation.fulfillmentTabDisabled}" id="fulfillment-tab" data-toggle="pill" href="##pills-shipping" role="tab" aria-controls="shipping" aria-selected="true">Shipping</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" ng-class="{disabled:swfNavigation.paymentTabDisabled}" id="payment-tab" data-toggle="pill" href="##pills-payment" role="tab" aria-controls="payment" aria-selected="true">Payment</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" ng-class="{disabled:swfNavigation.reviewTabDisabled}" id="review-tab" data-toggle="pill" href="##pills-review" role="tab" aria-controls="review" aria-selected="true">Order Review</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content">
                        	<div class="tab-pane fade active" id="pills-account" role="tabpanel" aria-labelledby="account">
                                
                                <!---ACCOUNT BEGIN--->

                                <div id="accountCollapse">
                                    <!-- Account Login -->
                                    <div class="collapse show" id="login" ng-show="slatwall.currentAccountPage == 'Login'">
                                		<form  ng-model="Account_Login" 
											ng-submit="swfForm.submitForm()" 
											swf-form 
											data-method="Login"
										>
                                			<h5>Account Login</h5>

                                            <!-- Invalid account error -->

                                			<div class="row">
                                                <div class="col-6 offset-md-3">
                                    				<div class="form-group">
                                    					<label for="emailAddress_Login" class="form-label">Email Address</label>
                                    					<input id="emailAddress_Login" name="emailAddress" placeholder="Email Address" 
                                    						class="form-control success" 
                                    						ng-model="Account_Login.emailAddress" swvalidationdatatype="email" swvalidationrequired="true"
                                    					>
                                    					<sw:SwfErrorDisplay propertyIdentifier="emailAddress"/>
                                    				</div>
                                                    <div class="form-group">
                                    					<label for="password_Login" class="form-label">Password</label>
                                    					<input id="password_Login" type="password" name="password" placeholder="Password" class="form-control success"
                                    						ng-model="Account_Login.password" swvalidationrequired="true"
                                    					>
                                    					<sw:SwfErrorDisplay propertyIdentifier="password"/>
                                    				</div>

                                                    <!-- Create Account toggle  -->
                                                    <a class="btn btn-link float-left" ng-click="slatwall.currentAccountPage = 'CreateAccount'"  role="button" aria-expanded="false" aria-controls="forgotPassword">Create Account</a>

                                                    <!-- Reset Password toggle -->
                                                    <a class="btn btn-link float-right" ng-click="slatwall.currentAccountPage = 'ForgotPassword'"  role="button" aria-expanded="false" aria-controls="forgotPassword">Reset Password</a>

                                                    <!-- Login Button -->
                                                    <button ng-click="swfForm.submitForm()" ng-class="{disabled:slatwall.getRequestByAction('Login').loading}" class="btn btn-primary btn-block">
                                                    	{{(swfForm.loading ? '' : 'Login & Continue')}}
                                                    	<i ng-show="swfForm.loading" class='fa fa-refresh fa-spin fa-fw'></i>
                                            		</button>

                                                    <!-- Continue as Guest -->
                                                    <button type="button" class="btn btn-link btn-block" ng-click="slatwall.currentAccountPage = 'GuestAccount'">Continue as Guest <i class="fa fa-angle-double-right"></i></a>
                                                </div>
                                			</div>
                                        </form>
                                    </div>

                                    <!-- Reset Password -->
                                    <div class="collapse" id="forgotPassword" ng-show="slatwall.currentAccountPage == 'ForgotPassword'">
                                		<form 
                                			ng-model="Account_ForgotPassword" 
											ng-submit="swfForm.submitForm()" 
											swf-form 
											data-method="ForgotPassword"
                                		>
                                			<h5>Reset Password</h5>
                                            <!-- Reset Password Success Message -->
                                            
                                            <div ng-show="swfForm.successfulActions.length" class="alert alert-success">An email with instructions to reset your password has been sent to your inbox.</div>

                                			<div class="row">
                                                <div class="col-6 offset-md-3">
                                                    <p>Enter your email to receive a password reset email or login.</p>
                                    				<div class="form-group">
                                    					<label for="emailAddress_ForgotPassword" class="form-label">Email Address</label>
                                    					<input id="emailAddress_ForgotPassword" name="emailAddress" type="text" placeholder="Email Address" class="form-control"
                                    						ng-model="Account_ForgotPassword.emailAddress" swvalidationdatatype="email" swvalidationrequired="true"
                                    					>
                                                        <sw:SwfErrorDisplay propertyIdentifier="emailAddress"/>
                                    				</div>
                                    				<!-- Login toggle  -->
                                                    <a class="btn btn-link float-left" ng-click="slatwall.currentAccountPage = 'Login'"  role="button" aria-expanded="false" aria-controls="login">&lt;- Back to Login</a>
                                                    
                                                    <button ng-click="swfForm.submitForm()" ng-class="{disabled:swfForm.loading}" class="btn btn-primary btn-block">
                                                    	{{(swfForm.loading ? '' : 'Reset Password')}}
                                                    	<i ng-show="swfForm.loading" class='fa fa-refresh fa-spin fa-fw'></i>
                                                	</button>
                                                </div>
                                			</div>
                                        </form>
                                    </div>

                                    <!-- Create Account -->
                                    <div class="collapse" id="createAccount" ng-show="slatwall.currentAccountPage == 'CreateAccount'">
                                			<h5>Create Account</h5>

                                            <div ng-show="swfForm.errors.length" class="alert alert-danger">Error creating account. See errors below.</div>

                                            <form 
                                            	ng-model="Account_CreateAccount" 
												ng-submit="swfForm.submitForm()" 
												swf-form 
												data-method="CreateAccount"
                                            >
                                            	<div class="row">
                                            		<div class="form-group col-md-6">
                                            			<label for="firstname_CreateAccount" class="form-label">First Name</label>
                                            			<input id="firstname_CreateAccount" type="text" name="firstName" placeholder="First Name" class="form-control"
                                            				ng-model="Account_CreateAccount.firstName" swvalidationrequired="true"
                                            			>
                                                        <sw:SwfErrorDisplay propertyIdentifier="firstName"/>
                                                    </div>
                                            		<div class="form-group col-md-6">
                                            			<label for="lastname_CreateAccount" class="form-label">Last Name</label>
                                            			<input id="lastname_CreateAccount" type="text" name="lastName" placeholder="Last Name" class="form-control" 
                                            				ng-model="Account_CreateAccount.lastName" swvalidationrequired="true"
                                            			>
                                                        <sw:SwfErrorDisplay propertyIdentifier="lastName"/>
                                                    </div>
                                            		<div class="form-group col-md-6">
                                            			<label for="email_CreateAccount" class="form-label">Email Address</label>
                                            			<input id="email_CreateAccount" type="text" name="emailAddress" placeholder="Email Address" class="form-control"
                                            				ng-model="Account_CreateAccount.emailAddress" swvalidationdatatype="email" swvalidationrequired="true"
                                            			>
                                                        <sw:SwfErrorDisplay propertyIdentifier="emailAddress"/>
                                                    </div>
                                            		<div class="form-group col-md-6">
                                            			<label for="emailAddressConfirm_CreateAccount" class="form-label">Confirm Email Address</label>
                                            			<input id="emailAddressConfirm_CreateAccount" type="text" name="emailAddressConfirm" placeholder="Confirm Email Address" class="form-control" 
                                            				ng-model="Account_CreateAccount.emailAddressConfirm" swvalidationrequired="true"
                                            			>
                                                        <sw:SwfErrorDisplay propertyIdentifier="emailAddresConfirm"/>
                                                    </div>
                                            		<div class="form-group col-md-6">
                                            			<label for="password_CreateAccount" class="form-label">Password</label>
                                            			<input id="password_CreateAccount" type="password" name="password" placeholder="Password" class="form-control"
                                            				ng-model="Account_CreateAccount.password" swvalidationrequired="true"
                                            			>
                                                        <sw:SwfErrorDisplay propertyIdentifier="password"/>
                                                    </div>
                                            		<div class="form-group col-md-6">
                                            			<label for="confirmPassword_CreateAccount" class="form-label">Confirm Password</label>
                                            			<input id="confirmPassword_CreateAccount" type="password" name="confirmPassword" placeholder="Confirm Password" class="form-control" 
                                            				ng-model="Account_CreateAccount.passwordConfirm" swvalidationrequired="true"
                                            			>
                                                        <sw:SwfErrorDisplay propertyIdentifier="passwordConfirm"/>
                                                    </div>

                                                    <div class="form-group col-md-6">
                                            			<label for="phoneNumber_CreateAccount" class="form-label">Phone Number</label>
                                            			<input id="phoneNumber_CreateAccount" type="text" name="phoneNumber" placeholder="Phone Number" class="form-control"
                                            				ng-model="Account_CreateAccount.phoneNumber"
                                            			>
                                            			<sw:SwfErrorDisplay propertyIdentifier="phoneNumber"/>
                                            		</div>

                                                    <div class="col-6 offset-md-3">
                                                    	<!-- Login toggle  -->
                                                    	<a class="btn btn-link float-left" ng-click="slatwall.currentAccountPage = 'Login'"  role="button" aria-expanded="false" aria-controls="login">&lt;- Back to Login</a>
                                                    
                                                        <button type="submit" class="btn btn-primary btn-block" ng-class="{disabled:swfForm.loading}">{{swfForm.loading ? '' : 'Create Account & Continue'}}
                                                        	<i ng-show="swfForm.loading" class="fa fa-refresh fa-spin fa-fw"></i>
                                                        </button>
                                                    </div>
                                            	</div>
                                            </form>
                            			</div>
                            		<span ng-init="Account_GuestAccount={
                            		    createAuthenticationFlag:0
                            		}"></span>
                                    <!-- Guest Account -->
                                    <div class="collapse" id="guestAccount" ng-show="slatwall.currentAccountPage == 'GuestAccount'">
                                			<h5>Continue as Guest</h5>
                                            
                                            <form 
                                            	ng-model="Account_GuestAccount" 
												ng-submit="swfForm.submitForm()" 
												swf-form 
												data-method="CreateAccount"
                                            >
                                                <input type="hidden" id="createAuthenticationFlag_GuestAccount" ng-model="Account_GuestAccount.createAuthenticationFlag" name="createAuthenticationFlag" value="0">
                                            	<div class="row">
                                            		<div class="form-group col-md-6">
                                            			<label for="firstname_GuestAccount" class="form-label">First Name</label>
                                            			<input id="firstname_GuestAccount" type="text" name="firstName" placeholder="First Name" class="form-control"
                                            				ng-model="Account_GuestAccount.firstName" swvalidationrequired="true"
                                            			>
                                                        <sw:SwfErrorDisplay propertyIdentifier="firstName"/>
                                                    </div>
                                            		<div class="form-group col-md-6">
                                            			<label for="lastname_GuestAccount" class="form-label">Last Name</label>
                                            			<input id="lastname_GuestAccount" type="text" name="lastName" placeholder="Last Name" class="form-control" 
                                            				ng-model="Account_GuestAccount.lastName" swvalidationrequired="true"
                                            			>
                                                        <sw:SwfErrorDisplay propertyIdentifier="lastName"/>
                                                    </div>
                                            		<div class="form-group col-md-6">
                                            			<label for="email_GuestAccount" class="form-label">Email Address</label>
                                            			<input id="email_GuestAccount" type="text" name="emailAddress" placeholder="Email Address" class="form-control"
                                            				ng-model="Account_GuestAccount.emailAddress" swvalidationdatatype="email" swvalidationrequired="true"
                                            			>
                                                        <sw:SwfErrorDisplay propertyIdentifier="emailAddress"/>
                                                    </div>
                                                    <div class="col-6 offset-md-3">
                                                    	<!-- Login toggle  -->
                                                    	<a class="btn btn-link float-left" ng-click="slatwall.currentAccountPage = 'Login'"  role="button" aria-expanded="false" aria-controls="login">&lt;- Back to Login</a>
                                                    
                                                        <button type="submit" class="btn btn-primary btn-block" ng-class="{disabled:swfForm.loading}">{{swfForm.loading ? '' : 'Continue'}}
                                                        	<i ng-show="swfForm.loading" class="fa fa-refresh fa-spin fa-fw"></i>
                                                        </button>
                                                    </div>
                                            	</div>
                                            </form>
                            			</div>
                                    </div>
                                </div>

                                <!---ACCOUNT END--->

                			<!--- SHIPPING BEGIN--->
                			<div class="tab-pane fade" id="pills-shipping" role="tabpanel" aria-labelledby="pill-shipping-tab">
                                <div ng-repeat="orderFulfillment in slatwall.cart.orderFulfillments">
                                    <!-- Store & Pickup Shipping Methods -->
                                    <!--- <div class="card-deck">
                                        <label class="card border-secondary bg-light mb-3" style="max-width: 18rem;">
                                            <div class="card-body">
                                                <i class="fa fa-truck fa-3x d-block text-center"></i>
                                                <h5 class="card-title text-center mt-3">Shipping</h5>
                                            </div>
                                        </label>
    									<!---TODO: implement pickup--->
                                        <!---<label class="card bg-light mb-3" style="max-width: 18rem;">
                                            <div class="card-body">
                                                <i class="fa fa-building fa-3x d-block text-center"></i>
                                                <h5 class="card-title text-center mt-3">Store Pickup</h5>
                                            </div>
                                        </label>--->
                                    </div>--->
                                    <div ng-if="orderFulfillment.fulfillmentMethod.fulfillmentMethodType === 'shipping'">
                                        <!-- Select Shipping Method -->
                                        <h5>Select Shipping Method</h5>
        
                                        <!-- Alert message if no shipping methods available -->
                                        <div class="alert alert-danger" ng-show="orderFulfillment.shippingMethodOptions.length === 0">There are no shipping methods available.</div>
        
        
        
                                        <!-- Create Shipping Address form - opens by default if none exist -->
                                        <!--- NOTE: if we have an account then we should save accountaddresses otherwise only addresses--->
                                        <sw:SwfAddressForm 
                                            selectedAccountAddress="orderFulfillment.selectedAccountAddress" 
                                            method="addEditAccountAddress,addShippingAddressUsingAccountAddress"
                                            visible="orderFulfillment.selectedAccountAddress || !slatwall.account.accountAddresses.length"
                                            additionalParameters="{fulfillmentID:orderFulfillment.orderFulfillmentID}"
                                            formID="{{orderFulfillment.orderFulfillmentID}}" />
                                            
                                        <!-- Close button for create/edit address - only should show if other addresses exists show address listing on close -->
                                        <button type="button" name="closeAddress" 
                                                ng-show="orderFulfillment.selectedAccountAddress && slatwall.account.accountAddresses.length" 
                                                ng-click="orderFulfillment.selectedAccountAddress=undefined" 
                                                class="btn btn-link">Close</button>
        	                            <button type="button"
        	                                    ng-hide="orderFulfillment.selectedAccountAddress || !slatwall.account.accountAddresses.length"
        	                                    ng-click="orderFulfillment.selectedAccountAddress=slatwall.accountAddressService.newAccountAddress()" 
        	                                    class="btn btn-secondary btn-sm float-right">
                                            <i class="fa fa-plus-circle"></i> Add Shipping Address
                                        </button>
                                        
        
                                        
        								
                                        <!-- Select Existing Shipping address -->
                                        <div ng-show="slatwall.account.accountAddresses.length">
                                            <h5>Select Shipping Address</h5>
            
                                            <!-- Shipping Dropdown Select -->
                                            <select class="form-control my-3" name="shippingAddress" required 
                                            	ng-model="orderFulfillment.accountAddress.accountAddressID"
                                            	ng-change="slatwall.selectShippingAccountAddress(orderFulfillment.accountAddress.accountAddressID,orderFulfillment.orderFulfillmentID)"
                                            	ng-disabled="slatwall.getRequestByAction('addShippingAddressUsingAccountAddress').loading"
                                            >
                                            	<option  value="">Select Account Address</option>
                                                <option ng-repeat="accountAddress in slatwall.account.accountAddresses track by accountAddress.accountAddressID" 
                                                	ng-selected="accountAddress.accountAddressID == orderFulfillment.accountAddress.accountAddressID"
                                                	ng-value="accountAddress.accountAddressID" 
                                                	ng-bind="accountAddress.getSimpleRepresentation()"
                                                >
                                                </option>
                                            </select>
                                            <form>
                                                <div class="card-deck mb-3" ng-repeat="accountAddress in slatwall.account.accountAddresses track by accountAddress.accountAddressID">
                                                    <!-- Shipping Address block selector -->
                                                    
                                                        <address class="card border-secondary" >
                                                            
                                                            <div class="card-header">
                                                                <div class="form-check">
                                                                    <input class="form-check-input" type="radio" name="address" 
                                                                    	ng-value="accountAddress.accountAddressID" 
                                                                    	ng-model="orderFulfillment.accountAddress.accountAddressID" ng-click="slatwall.selectShippingAccountAddress(accountAddress.accountAddressID,orderFulfillment.orderFulfillmentID)" 
                                                                    >
                                                                    <label class="form-check-label" for="address1">Selected</label>
                                                                    <!-- Select Address Loader -->
                                                                    <i ng-show="slatwall.loadingThisRequest('addShippingAddressUsingAccountAddress',{accountAddressID:accountAddress.accountAddressID})" class="fa fa-refresh fa-spin fa-fw my-1 float-right"></i>
                                                                </div>
                                                            </div>
                                                            
                                                            <div class="card-body">
                                                                <strong ng-bind="accountAddress.address.name"></strong><br>
                                                                {{accountAddress.address.streetAddress}}<br>
                                                                {{accountAddress.address.street2Address}}<br ng-if="accountAddress.address.street2Address">
                                                                {{accountAddress.address.city}}, {{accountAddress.address.stateCode}} {{accountAddress.address.postalCode}}<br>
                                                                {{accountAddress.address.phoneNumber}}
                                                                <hr>
                                                                <a href="##" ng-click="slatwall.selectedAccountAddress=accountAddress;" class="card-link float-left">Edit</a>
                                                                <a href="##" ng-disabled="slatwall.getRequestByAction('removeAccountAddress').loading" 
                                                                	ng-click="slatwall.deleteAccountAddress(accountAddress.accountAddressID)" class="card-link float-right"
                                                                >
                                                                	{{slatwall.getRequestByAction('deleteAccountAddress').loading ? '':'Delete'}}
                                                                	<i ng-show="slatwall.loadingThisRequest('deleteAccountAddress',{accountAddressID:accountAddress.accountAddressID})" class="fa fa-refresh fa-spin fa-fw my-1 float-right"></i>
                                                                </a>
                                                            </div>
                                                        </address>
                                                    
                
                                                    <!-- Address block -->
                                                    
                                                </div>
                                            </form>
                                        </div>
        
                                        <!-- Shipping Delievery Options -->
                                        <h5>Select Delivery Method</h5>
        
                                        <div class="card-deck mb-3">
                                            <div class="card border-secondary" 
                                            	ng-repeat="shippingMethodOption in orderFulfillment.shippingMethodOptions | orderBy:shippingMethod.sortOrder"
                                        	>
                                                <div class="card-header">
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="radio" name="shipping" 
                                                        	ng-value="shippingMethodOption.value" ng-checked="shippingMethodOption.value == orderFulfillment.shippingMethod.shippingMethodID"
                                                        	ng-model="orderFulfillment.shippingMethod.shippingMethodID" 
                                                        	ng-click="slatwall.selectShippingMethod(shippingMethodOption,orderFulfillment)" 
                                                        >
                                                        <label class="form-check-label" for="shipping1">
                                                            Selected
                                                        </label>
                                                        <!-- Select Address Loader -->
                                                        <i class="fa fa-refresh fa-spin fa-fw my-1 float-right" ng-show="slatwall.loadingThisRequest('addShippingMethodUsingShippingMethodID',{shippingMethodID:shippingMethodOption.value})"></i>
                                                    </div>
                                                </div>
                                                <div class="card-body">
                                                    {{shippingMethodOption.name}}<br>
                                                </div>
                                            </div>
                                        </div>
        
        
                                        <!-- Shipping Notes -->
                                        <form swf-form
                                            method="updateOrderFulfillment"
                                            ng-model="orderFulfillment"
                                            ng-submit="swfForm.submitForm()">
                                            <h6 class="pt-3">Shipping Notes/Instructions</h6>
                                            <textarea ng-model="orderFulfillment.shippingInstructions" name="shippingInstructions" rows="5" cols="80" class="form-control mb-3"></textarea>
                                            <input type="hidden" name="orderFulfillmentID" ng-model="orderFulfillment.orderFulfillmentID">
                                            <!-- Select Shipping Submit Button -->
                                            <button type="submit" class="btn btn-primary w-25" ng-class="{disabled:swfForm.loading}">
                                                {{swfForm.loading ? '' : 'Save Shipping Instructions'}}
                                                <i class="fa fa-refresh fa-spin fa-fw" ng-show="swfForm.loading"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                                <div>
                			        <button ng-click="swfNavigation.showTab('payment')" class="btn btn-primary w-25 nav-item" ng-disabled="swfNavigation.paymentTabDisabled">Continue to Payment</button>
            			        </div>
                			</div>
                			
                            <!--- SHIPPING END--->


                            <!-- Payment Tab 3 -->
                            <div class="tab-pane fade" id="pills-payment" role="tabpanel" aria-labelledby="pill-payment-tab">
								<form 
                                	ng-model="::slatwall.selectedBillingAccountAddress" 
									swf-form 
									data-method="addEditAccountAddress,addBillingAddressUsingAccountAddress"
									ng-show="slatwall.selectedBillingAccountAddress"
                                >
									<input id="billing_addressAccountID" type="hidden" name="accountAddressID"  class="form-control"
            							ng-model="slatwall.selectedBillingAccountAddress.accountAddressID" 
            						>
	                                <!-- Create Billing Address form - opens by default if none exist -->
	                                <h5>Create/Edit Billing Address</h5>
	
	                                <div class="alert alert-success"  ng-show="swfForm.successfulActions.length">Billing Address saved.</div>
	                                <div class="alert alert-danger"  ng-show="swfForm.failureActions.length">Error saving billing address. See below for errors.</div>
	
	                                <div class="row">
	                					<div class="form-group col-md-6">
	                						<label for="billing_firstname" class="form-label">First Name</label>
	                						<input id="billing_firstname" type="text" name="firstName" placeholder="First Name" class="form-control"
	                							ng-model="slatwall.selectedBillingAccountAddress.address.firstName" swvalidationrequired="true"
	                						>
	                                        <sw:SwfErrorDisplay propertyIdentifier="firstName"/>
	                					</div>
	                					<div class="form-group col-md-6">
	                						<label for="billing_lastname" class="form-label">Last Name</label>
	                						<input id="billing_lastname" type="text" name="lastName" placeholder="Last Name" class="form-control"
	                							ng-model="slatwall.selectedBillingAccountAddress.address.lastName" swvalidationrequired="true"
	                						>
	                                        <sw:SwfErrorDisplay propertyIdentifier="lastName"/>
	                                    </div>
	                					<div class="form-group col-md-6">
	                						<label for="billing_street" class="form-label">Street</label>
	                						<input id="billing_street" type="text" name="streetAddress" placeholder="Street Address" class="form-control"
	                							ng-model="slatwall.selectedBillingAccountAddress.address.streetAddress" swvalidationrequired="true"
	                						>
	                                        <sw:SwfErrorDisplay propertyIdentifier="streetAddress"/>
	                                    </div>
	                                    <div class="form-group col-md-6">
	                						<label for="billing_street2" class="form-label">Street Address 2</label>
	                						<input id="billing_street2" type="text" name="street2Address" placeholder="Street Address" class="form-control"
	                							ng-model="slatwall.selectedBillingAccountAddress.address.street2Address" 
	                						>
	                						<sw:SwfErrorDisplay propertyIdentifier="street2Address"/>
	                                    </div>
	                					<div class="form-group col-md-3">
	                						<label for="billing_city" class="form-label">City</label>
	                						<input id="billing_city" type="text" name="city" placeholder="City" class="form-control"
	                							ng-model="slatwall.selectedBillingAccountAddress.address.city" swvalidationrequired="true"
	                						>
	                                        <sw:SwfErrorDisplay propertyIdentifier="city"/>
	                                    </div>
	                					<div class="form-group col-md-3">
	                						<label for="billing_zip" class="form-label">Zip Code</label>
	                						<input id="billing_zip" type="text" name="postalCode" placeholder="Zip code" class="form-control"
	                							ng-model="slatwall.selectedBillingAccountAddress.address.postalCode" swvalidationrequired="true"
	                						>
	                                        <sw:SwfErrorDisplay propertyIdentifier="postalCode"/>
	                                    </div>
	                					<div class="form-group col-md-3">
	                						<label for="billing_state" class="form-label">State</label>
	                                        <select id="billing_state" type="text" name="stateCode" placeholder="State" class="form-control"
	                							ng-model="slatwall.selectedBillingAccountAddress.address.stateCode" swvalidationrequired="true"
	                						>
	                							<option value="">State list...</option>
	                                            <option ng-repeat="state in slatwall.states.stateCodeOptions track by state.value" ng-value="state.value" ng-bind="state.name"
	                                            	ng-selected="state.value==slatwall.selectedBillingAccountAddress.address.stateCode"
	                                            ></option>
	                                        </select>
	                                        <sw:SwfErrorDisplay propertyIdentifier="stateCode"/>
	                                    </div>
	                					<div class="form-group col-md-3">
	                						<label for="billing_country" class="form-label">Country</label>
	                						<select id="billing_country" type="text" name="countryCode" placeholder="Country" class="form-control"
	                							ng-model="slatwall.selectedBillingAccountAddress.address.countryCode" swvalidationrequired="true"
	                						>
	                                            <option value="">Country list...</option>
	                                            <option ng-repeat="country in slatwall.countries.countryCodeOptions track by country.value" ng-value="country.value" ng-bind="country.name"
	                                            	ng-selected="country.value==slatwall.selectedBillingAccountAddress.address.countryCode"
	                                            ></option>
	                                        </select>
	                                        <sw:SwfErrorDisplay propertyIdentifier="countryCode"/>
	                                    </div>
	                					<div class="form-group col-md-6">
	                						<label for="billing_phone-number" class="form-label">Phone Number</label>
	                						<input id="billing_phone-number" type="tel" name="phoneNumber" placeholder="Phone number" class="form-control"
	                							ng-model="slatwall.selectedBillingAccountAddress.address.phoneNumber" swvalidationrequired="true"
	                						>
	                                        <sw:SwfErrorDisplay propertyIdentifier="phoneNumber"/>
	                					</div>
	                                    <div class="form-group col-md-6">
	                						<label for="billing_email" class="form-label">Email Address</label>
	                						<input id="billingemail" name="emailAddress" placeholder="Email Address" class="form-control"
	                							ng-model="slatwall.selectedBillingAccountAddress.address.emailAddress" swvalidationrequired="true" swvalidationdatatype="email"
	                						>
	                                        <sw:SwfErrorDisplay propertyIdentifier="emailAddress"/>
	                                    </div>
	                                    <div class="form-group col-md-6">
	                						<label for="billing_company" class="form-label">Company</label>
	                						<input id="billing_company" type="text" name="company" placeholder="Company" class="form-control"
	                							ng-model="slatwall.selectedBillingAccountAddress.address.company" 
	                						>
	                						<sw:SwfErrorDisplay propertyIdentifier="company"/>
	                					</div>
	                                    <div class="form-group col-md-6">
	                						<label for="billing_addressNickname" class="form-label">Address Nickname</label>
	                						<input id="billing_addressNickname" type="text" name="addressAccountName" placeholder="Address Nickname" class="form-control"
	                							ng-model="slatwall.selectedBillingAccountAddress.addressAccountname"
	                						>
	                						<sw:SwfErrorDisplay propertyIdentifier="addressAccountName"/>
	                					</div>
	                				</div>
	                				<div class="form-group">
	                                	<button ng-click="swfForm.submitForm()" 
	                                    	ng-class="{disabled:swfForm.loading}" 
	                                    	class="btn btn-primary btn-block"
	                                    >{{(swfForm.loading ? '' : 'Save Billing Address')}}
	                                    	<i ng-show="swfForm.loading" class='fa fa-refresh fa-spin fa-fw'></i>
	                                    </button>
	                                    <!-- Close button to close create/edit shipping address & display  -->
	                                    <button ng-show="slatwall.selectedBillingAccountAddress.accountAddressID.trim().length" 
	                                    	class="btn btn-danger btn-sm mt-2"
	                                    	ng-click="slatwall.deleteAccountAddress(slatwall.selectedBillingAccountAddress.accountAddressID)"
	                                    	ng-disabled="slatwall.getRequestByAction('deleteAccountAddress').loading"
	                                    >
	                                    	{{slatwall.getRequestByAction('deleteAccountAddress').loading ? '':'Delete Address'}}
                                            <i ng-show="slatwall.getRequestByAction('deleteAccountAddress').loading" class="fa fa-refresh fa-spin fa-fw my-1 float-right"></i>
	                                    </button>
	
	                                    <!-- Close button for create/edit address - only should show if other addresses exists show address listing on close -->
	                                    <button type="button" name="closeAddress" ng-click="slatwall.selectedBillingAccountAddress=undefined" class="btn btn-link">Close</button>
	                                </div>
	                				
	                			</form>
								
								<button type="button" ng-click="slatwall.selectedBillingAccountAddress=slatwall.accountAddressService.newAccountAddress()" class="btn btn-secondary btn-sm float-right">
                                    <i class="fa fa-plus-circle"></i> Add Billing Address
                                </button>

                                <!-- Select Existing Billing address -->
                                <h5>Select Billing Address</h5>
                                <!-- Billing Dropdown Select -->
                                
                                <select class="form-control my-3" name="billingAddress" required 
                                	ng-model="slatwall.cart.billingAccountAddress.accountAddressID"
                                	ng-change="slatwall.selectBillingAccountAddress(slatwall.cart.billingAccountAddress.accountAddressID)"
                                	ng-disabled="slatwall.getRequestByAction('addBillingAddressUsingAccountAddress').loading"
                                >
                                	<option  value="">Select Account Address</option>
                                    <option ng-repeat="accountAddress in slatwall.account.accountAddresses track by accountAddress.accountAddressID" 
                                    	ng-selected="accountAddress.accountAddressID == slatwall.cart.billingAccountAddress.accountAddressID"
                                    	ng-value="accountAddress.accountAddressID" 
                                    	ng-bind="accountAddress.getSimpleRepresentation()"
                                    >
                                    </option>
                                </select>
                                <form>
                                    <div class="card-deck mb-3" ng-repeat="accountAddress in slatwall.account.accountAddresses track by accountAddress.accountAddressID">
                                        <!-- Shipping Address block selector -->
                                        <address class="card border-secondary" >
                                            <div class="card-header">
                                                <div class="form-check">
                                                    
                                                    <input class="form-check-input" type="radio" name="address" 
                                                    	ng-value="accountAddress.accountAddressID" 
                                                    	ng-model="slatwall.cart.billingAccountAddress.accountAddressID" ng-click="slatwall.selectBillingAccountAddress(accountAddress.accountAddressID)" 
                                                    >
                                                    
                                                    <label class="form-check-label" for="address1">Selected</label>
                                                    <!-- Select Address Loader -->
                                                    <i ng-show="slatwall.getRequestByAction('addBillingAddressUsingAccountAddress').loading" class="fa fa-refresh fa-spin fa-fw my-1 float-right"></i>
                                                </div>
                                            </div>
                                            <div class="card-body">
                                                <strong ng-bind="accountAddress.address.name"></strong><br>
                                                {{accountAddress.address.streetAddress}}<br>
                                                {{accountAddress.address.street2Address}}<br ng-if="accountAddress.address.street2Address">
                                                {{accountAddress.address.city}}, {{accountAddress.address.stateCode}} {{accountAddress.address.postalCode}}<br>
                                                {{accountAddress.address.phoneNumber}}
                                                <hr>
                                                <a href="##" ng-click="slatwall.selectedBillingAccountAddress=accountAddress;" class="card-link float-left">Edit</a>
                                                <a href="##" ng-disabled="slatwall.getRequestByAction('removeAccountAddress').loading" 
                                                	ng-click="slatwall.deleteAccountAddress(accountAddress.accountAddressID)" class="card-link float-right"
                                                >
                                                	{{slatwall.getRequestByAction('deleteAccountAddress').loading ? '':'Delete'}}
                                                	<i ng-show="slatwall.getRequestByAction('deleteAccountAddress').loading" class="fa fa-refresh fa-spin fa-fw my-1 float-right"></i>
                                                </a>
                                            </div>
                                        </address>
    
                                        <!-- Address block -->
                                        
                                    </div>
                                </form>

                                <!-- Select Payment Method -->
                                <h5 class="pb-2">Select Payment Method</h5>
                                <!-- Credit Card Info -->
                                <div role="tablist" aria-multiselectable="true" class="mb-3">
                                	<div class="card mb-3">
                                        <a aria-expanded="true" >
                                    		<div id="headingOne" role="tab" class="card-header">Credit Card</div>
                                        </a>
                                		<div  role="tabpanel" aria-labelledby="headingOne">
                                			<div class="card-body">
                                                <!-- Add Payment Success/Fail -->
                                				<form 
                                					ng-model="OrderPayment_addOrderPayment" 
													swf-form 
													data-method="addOrderPayment"
													
												>
                                					<div class="alert alert-success" ng-show="swfForm.successfulActions.length">Credit Card Payment added.</div>
                                                	<div class="alert alert-danger" ng-show="swfForm.failureActions.length">Error adding credit card payment. See below for errors.</div>
													
                                					<div class="row">
                                						<input type="hidden" name="accountAddressID" id="billingAccountAddress-addressID" class="form-control"
	                        								ng-model="slatwall.cart.orderPayments[slatwall.cart.orderPayments.length-1].billingAccountAddress.accountAddressID"
	                        							>
                                						<div class="form-group col-md-6">
                                							<label for="card-name" class="form-label">Name on Card</label>
                                							<input type="text" name="newOrderPayment.nameOnCreditCard" placeholder="Name on card" id="card-name" class="form-control"
                                								ng-model="OrderPayment_addOrderPayment.nameOnCreditCard" swvalidationrequired="true"
                                							>
                                                            <sw:SwfErrorDisplay propertyIdentifier="newOrderPayment.nameOnCreditCard"/>
                                						</div>
                                						<div class="form-group col-md-6">
                                							<label for="card-number" class="form-label">Card Number</label>
                                							<input type="text" name="newOrderPayment.creditCardNumber" placeholder="Card Number" id="card-number" class="form-control" 
                                								ng-model="OrderPayment_addOrderPayment.creditCardNumber" swvalidationrequired="true"
                                							>
                                                            <sw:SwfErrorDisplay propertyIdentifier="newOrderPayment.creditCardNumber"/>
                                						</div>
                                						<div class="form-group col-md-4">
                                							<label for="expiry-date-month" class="form-label">Expiration Month</label>
                                							<input type="text" name="newOrderPayment.expirationMonth" placeholder="MM" id="expiry-date-month" class="form-control"
                                								ng-model="OrderPayment_addOrderPayment.expirationMonth" swvalidationrequired="true"
                                							>
                                                            <sw:SwfErrorDisplay propertyIdentifier="newOrderPayment.expirationMonth"/>
                                						</div>
                                						<div class="form-group col-md-4">
                                							<label for="expiry-date-year" class="form-label">Expiration Year</label>
                                							<input type="text" name="newOrderPayment.expirationYear" placeholder="YYYY" id="expiry-date-year" class="form-control" 
                                								ng-model="OrderPayment_addOrderPayment.expirationYear" swvalidationrequired="true"
                                							>
                                                            <sw:SwfErrorDisplay propertyIdentifier="newOrderPayment.expirationYear"/>
                                						</div>
                                						<div class="form-group col-md-4">
                                							<label for="cvv" class="form-label">CVC/CVV</label>
                                							<input type="text" name="newOrderPayment.securityCode" placeholder="123" id="cvv" class="form-control" 
                                								ng-model="OrderPayment_addOrderPayment.securityCode" swvalidationrequired="true"
                                							>
                                                            <sw:SwfErrorDisplay propertyIdentifier="newOrderPayment.securityCode"/>
                                						</div>
                                					</div>

                                                    <div class="form-group custom-control custom-checkbox">
                                                        <input type="checkbox" class="custom-control-input" id="payment_save">
                                                        <label class="custom-control-label" for="payment_save">Set as default payment?</label>
                                                    </div>

                                                    <!-- Credit Card Payment Submit & Close buttons -->
                                                    <button ng-click="swfForm.submitForm()" 
				                                    	ng-class="{disabled:swfForm.loading}" 
				                                    	class="btn btn-primary btn-block"
				                                    >{{(swfForm.loading ? '' : 'Add Payment')}}
				                                    	<span  ng-show="swfForm.loading"><i class='fa fa-refresh fa-spin fa-fw'></i></span>
				                                    </button>
                                                    <!---<button type="button" name="close" class="btn btn-link">Cancel</button>--->
                                				</form>
                                			</div>
                                		</div>
                                	</div>

                                    <!-- Purchase Order -->
                                	<div class="card mb-3">
                                        <a aria-expanded="false" aria-controls="collapseTwo" class="collapsed">
                                    		<div id="headingTwo" role="tab" class="card-header">Purchase Order</div>
                                        </a>
                                		<div role="tabpanel" aria-labelledby="headingTwo" class="collapse" id="poTab">
                                			<div class="card-body">
                                               <form 
                                					ng-model="OrderPayment_addOrderPayment_PO" 
													swf-form 
													data-method="addOrderPayment"
													
												>
                                                <!-- Add Payment Success/Fail -->
                                                <div class="alert alert-success" ng-show="swfForm.successfulActions.length">Purchase order added.</div>
                                                <div class="alert alert-danger" ng-show="swfForm.failureActions.length">Error adding purchase order payment. See below for errors.</div>
                                                
                                                <div class="row">
                                                    <div class="form-group col-md-7">
                                                        <label for="card-name" class="form-label">Purchase Order Number</label>
                                                        <input 
                                                            type="text"
                                                            name="newOrderPayment.purchaseOrderNumber" 
                                                            placeholder="Purchase Order Number" 
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
                                							ng-init="OrderPayment_addOrderPayment_PO.paymentMethod.paymentMethodID = '2c92808363985abf0163ac4ef66f003c'"
                                						>
                                                        <sw:SwfErrorDisplay propertyIdentifier="newOrderPayment.purchaseOrderNumber"/>
                                                    </div>
                                                </div>
                                                <!-- Purchase Order Submit & Close buttons -->
                                                <button 
                                                    ng-click="swfForm.submitForm()" 
			                                    	ng-class="{disabled:swfForm.loading}" 
			                                    	class="btn btn-primary btn-block"
			                                    >
                                                    {{(swfForm.loading ? '' : 'Add Payment')}}
			                                    	<i 
			                                    	    ng-show="swfForm.loading" 
			                                    	    class='fa fa-refresh fa-spin fa-fw'>
			                                    	</i>
			                                    </button>
			                                    <button type="button" name="close" data-toggle="collapse" href="##poTab" class="btn btn-link">Cancel</button>
                                                </form>
                                		    </div>
                                		</div>
                                	</div>

                                    <!-- Gift Card -->
                                    <div class="card">
                                        <a  aria-expanded="false" aria-controls="collapseThree" class="collapsed">
                                            <div id="headingThree" role="tab" class="card-header">Gift Card</div>
                                        </a>
                                        <div  role="tabpanel" aria-labelledby="headingThree" class="collapse" id="giftCardTab">
                                            <div class="card-body">
                                                <form
                                                    ng-model="OrderPayment_addOrderPayment_GC" 
													swf-form 
													data-method="addOrderPayment"
                                                >
                                                    <!-- Add Payment Success/Fail -->
                                                    <div class="alert alert-success" ng-show="swfForm.successfulActions.length">Gift card added.</div>
                                                    <div class="alert alert-danger" ng-show="swfForm.failureActions.length">Error adding gift card. See below for errors.</div>
                                                
                                                    <div class="row">
                                                    <div class="form-group col-md-7">
                                                        <label for="card-name" class="form-label">Gift Card Number</label>
                                                        <input
                                                            type="text"
                                                            name="newOrderPayment.giftCardNumber" 
                                                            placeholder="Gift Card Number" 
                                                            id="gc-number" 
                                                            class="form-control" 
                                							ng-model="OrderPayment_addOrderPayment_GC.giftCard" 
                                							swvalidationrequired="true"
                                						> 
                                						<input 
                                                            type="hidden"
                                                            name="newOrderPayment.paymentMethod.paymentMethodID" 
                                                            id="gc-paymentMethodName" 
                                                            class="form-control" 
                                							ng-model="OrderPayment_addOrderPayment_GC.paymentMethod.paymentMethodID"
                                							ng-init="OrderPayment_addOrderPayment_GC.paymentMethod.paymentMethodID = '50d8cd61009931554764385482347f3a'"
                                						>
                                                        <sw:SwfErrorDisplay propertyIdentifier="newOrderPayment.giftCardNumber"/>
                                                    </div>
                                                </div>
    
                                                <!-- Gift Card Submit & Close buttons -->
                                                <button 
                                                    ng-click="swfForm.submitForm()" 
			                                    	ng-class="{disabled:swfForm.loading}" 
			                                    	class="btn btn-primary btn-block"
			                                    >
                                                    {{(swfForm.loading ? '' : 'Add Payment')}}
			                                    	<i 
			                                    	    ng-show="swfForm.loading" 
			                                    	    class='fa fa-refresh fa-spin fa-fw'>
			                                    	</i>
			                                    </button>
			                                    <button type="button" name="close" data-toggle="collapse" href="##giftCardTab" class="btn btn-link">Cancel</button>
                                                
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                </div>

                                <!-- Place Orders & Review Order buttons -->
                                <!-- Add disabled class until all criteria is met -->
                                <button type="button" name="review" class="btn btn-secondary w-25" ng-disabled="swfNavigation.reviewTabDisabled" ng-click="swfNavigation.showTab('review')">Review Order</button>
                                <button type="submit" name="submit" class="btn btn-primary w-25" ng-disabled="swfNavigation.reviewTabDisabled" >Place Order</button>
                            </div>
                            <!-- //Payment-tab 3  -->

                            <!-- Order Review tab 4 -->
                            <div class="tab-pane fade" id="pills-review" role="tabpanel" aria-labelledby="pill-review-tab">
                                <h5>Review Order</h5>

                                <!-- Place Order alert fail -->
                                <div class="alert alert-danger" ng-show="slatwall.requests['placeOrder'].failureActions.length">Order could not be placed.</div>

                                <!-- Shipping  -->
                                <h6>Shipping</h6>

                                <div class="card-deck mb-3">
                                    <!-- Shipping Address -->
                                    <address class="card">
                                        <div class="card-header">
                                            <span class="float-left"><i class="fa fa-check-circle"></i> Shipping Address</span>
                                            <!---<a href="##" class="float-right">Edit</a>--->
                                        </div>
                                        <div class="card-body">
                                            <strong ng-bind="slatwall.cart.orderFulfillments[0].shippingAddress.name"></strong><br>
                                            {{slatwall.cart.orderFulfillments[0].shippingAddress.streetAddress}}<br>
                                            {{slatwall.cart.orderFulfillments[0].shippingAddress.street2Address}}<br ng-if="slatwall.cart.orderFulfillments[0].shippingAddress.street2Address"/>
                                            {{slatwall.cart.orderFulfillments[0].shippingAddress.city}}, {{slatwall.cart.orderFulfillments[0].shippingAddress.stateCode}} {{slatwall.cart.orderFulfillments[0].shippingAddress.postalCode}}<br>
                                            {{slatwall.cart.orderFulfillments[0].shippingAddress.phoneNumber}}
                                        </div>
                                    </address>

                                    <!-- Shipping Method  -->
                                    <div class="card">
                                        <div class="card-header">
                                            <span class="float-left"><i class="fa fa-check-circle"></i> Shipping Method</span>
                                            <!---<a href="##" class="float-right">Edit</a>--->
                                        </div>
                                        <div class="card-body">
                                        	<strong ng-bind="slatwall.cart.orderFulfillments[0].shippingMethod.shippingMethodName"></strong><br>
                                        </div>
                                    </div>
                                </div>
								
								<!--- TODO:STORE PICKUP TO BE CONTINUED
								
	                                <!-- Store Pickup  -->
	                                <h6>Store Pickup</h6>
	
	                                <div class="card-deck mb-3">
	                                    <!-- Pickup Date -->
	                                    <address class="card">
	                                        <div class="card-header">
	                                            <span class="float-left"><i class="fa fa-check-circle"></i> Store Pickup Date</span>
	                                            <a href="##" class="float-right">Edit</a>
	                                        </div>
	                                        <div class="card-body">
	                                            <i class="fa fa-calendar"></i> <strong>January 25, 2018</strong>
	                                        </div>
	                                    </address>
	
	                                    <!-- Store Pickup Location  -->
	                                    <div class="card">
	                                        <div class="card-header">
	                                            <span class="float-left"><i class="fa fa-check-circle"></i> Store Pickup Location</span>
	                                            <a href="##" class="float-right">Edit</a>
	                                        </div>
	                                        <div class="card-body">
	                                            <i class="fa fa-map-marker"></i> <strong>Pickup Location Address</strong>
	                                        </div>
	                                    </div>
	                                </div>
	                            --->

                                <!-- Billing -->
                                <h6>Billing</h6>

                                <div class="card-deck mb-3">
                                    <!-- Billing Address -->
                                    <address class="card">
                                        <div class="card-header">
                                            <span class="float-left"><i class="fa fa-check-circle"></i> Billing Address</span>
                                            <!---<a href="##" class="float-right">Edit</a>--->
                                        </div>
                                        <div class="card-body">
                                            <strong ng-bind="slatwall.cart.orderPayments[slatwall.cart.orderPayments.length-1].billingAddress.name"></strong><br>
                                            {{slatwall.cart.orderPayments[slatwall.cart.orderPayments.length-1].billingAddress.streetAddress}}<br>
                                            {{slatwall.cart.orderPayments[slatwall.cart.orderPayments.length-1].billingAddress.street2Address}}<br ng-if="slatwall.cart.orderPayments[slatwall.cart.orderPayments.length-1].billingAddress.street2Address"/>
                                            {{slatwall.cart.orderPayments[slatwall.cart.orderPayments.length-1].billingAddress.city}}, {{slatwall.cart.orderPayments[slatwall.cart.orderPayments.length-1].billingAddress.stateCode}} {{slatwall.cart.orderPayments[slatwall.cart.orderPayments.length-1].billingAddress.postalCode}}<br>
                                            {{slatwall.cart.orderPayments[slatwall.cart.orderPayments.length-1].billingAddress.phoneNumber}}
                                        </div>
                                    </address>

                                    <!-- Payment Method -->
                                    <div class="card">
                                        <div class="card-header">
                                            <span class="float-left"><i class="fa fa-check-circle"></i> Payment Method</span>
                                            <!---<a href="##" class="float-right">Edit</a>--->
                                        </div>
                                        <div class="card-body" ng-switch="slatwall.cart.orderPayments[slatwall.cart.orderPayments.length-1].creditCardType.toLowerCase()">
                                            <h6>Credit Card</h6>
                                            <i class="fa fa-cc-visa fa-2x" ng-switch-when="visa"></i>
                                            <i class="fa fa-cc-mastercard fa-2x" ng-switch-when="mastercard"></i>
                                            <i class="fa fa-cc-discover fa-2x" ng-switch-when="discover"></i>
                                            <i class="fa fa-cc-amex fa-2x" ng-switch-when="amex"></i>

                                            ****{{slatwall.cart.orderPayments[slatwall.cart.orderPayments.length-1].creditCardLastFour}}

                                            <small class="d-block">Amount: {{slatwall.cart.orderPayments[slatwall.cart.orderPayments.length-1].amount|currency}}</small>
											<!---TODO:gift card and purchase order
                                            <h6 class="mt-3">Gift Card</h6>

                                            <small class="d-block">##12345678</small>
                                            <small class="d-block">Amount: $200</small>

                                            <h6 class="mt-3">Purchase Order</h6>
                                            <small class="d-block">##12345678</small>
                                            --->
                                        </div>
                                    </div>
                                </div>

                                <!-- Place Order Button  -->
                                <button ng-click="slatwall.doAction('placeOrder')" class="btn btn-primary btn-block" ng-class="{disabled:slatwall.getRequestByAction('placeOrder').loading}">{{slatwall.getRequestByAction('placeOrder').loading ? '' : 'Place Order'}}
                                	<i ng-show="slatwall.getRequestByAction('placeOrder').loading" class="fa fa-refresh fa-spin fa-fw"></i>
                                </button>

                            </div>
                            <!-- //Review-tab 4  -->

                        </div>
                    </div>
                </div>
                <!-- //close main card body -->
            </div>

            <!-- Checkout sidebar Order Summary -->
            <div class="col-12 col-md-4">

                <!-- Order Summary -->
                <cfinclude template="./inc/orderSummary.cfm" />

                <!-- Order Items Summary -->
                <div class="card mb-5">
                    <div class="card-header">
                        <h5 class="mb-0">Order Items</h5>
                    </div>
                    <div class="card-body">
                        <div class="row" ng-repeat="orderItem in slatwall.cart.orderItems track by orderItem.orderItemID">
                            <div class="col-3">
                                <img class="img-fluid" src="http://placehold.it/50x50" alt="preview">
                            </div>
                            <div class="col-9 pl-0">
                                <small class="text-secondary" ng-bind="orderItem.sku.product.productType.productTypeName">Product Type</small>
                                <h6><a href="##" ng-bind="orderItem.sku.product.productName">Product Name</a></h6>

                                <div class="row">
                                    <div class="col-4">
                                        <input type="number" class="form-control form-control-sm" min="1" required
                                        	ng-model="orderItem.quantity"
                                        	ng-disabled="slatwall.getRequestByAction('updateOrderItemQuantity').loading" 
                                			ng-change="slatwall.updateOrderItemQuantity(orderItem.orderItemID,orderItem.quantity)"
                                        />
                                        <i ng-show="slatwall.getRequestByAction('updateOrderItemQuantity').loading" class="fa fa-refresh fa-spin fa-fw"></i>
                                    </div>
                                    <div class="col-8 pl-0">
                                        <small >{{orderItem.extendedUnitPriceAfterDiscount|currency}} <span class="text-muted"><s ng-bind="orderItem.extendedUnitPrice|currency"></s></span></small>
                                        <strong ng-bind="orderItem.extendedPriceAfterDiscount|currency"></strong>
                                    </div>
                                </div>

                                <small><strong>SKU Code:</strong> {{orderItem.sku.skuCode}}</small>
                                <p class="mb-3"><small><strong>SKU Defintion Label: </strong>{{orderItem.sku.skuDefinition}}</small></p>

                                <button type="button" class="btn btn-danger btn-sm rounded" 
                                	ng-disabled="slatwall.getRequestByAction('updateOrderItemQuantity').loading" 
                                	ng-click="slatwall.updateOrderItemQuantity(orderItem.orderItemID,0)">
                                	<span ng-show="!slatwall.getRequestByAction('updateOrderItemQuantity').loading">&times;</span>
                                	<i ng-show="slatwall.getRequestByAction('updateOrderItemQuantity').loading" class="fa fa-refresh fa-spin fa-fw"></i>
                                		
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Promotion -->
                <cfinclude template="./inc/promoBox.cfm" />

            </div>
        </div>

        <!-- Cart Empty Message -->
        <div class="alert alert-danger my-2" ng-show="slatwall.cart.orderItems.length === 0">There are no items in your cart.</div>
    </div>
</cfoutput>
<cfinclude template="_slatwall-footer.cfm" />