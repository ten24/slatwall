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
																				
	This "My Account" example template is designed to give you an idea			
	of what is possible through the frontend subsystem in the way of pulling	
	information as well as updating account info.								
																				
	IMPORTANT: any of the individual components or different aspects	of this	
	page can be copied into a seperate template and referenced as a seperate	
	URL either in your CMS or custom application.  We have done this all in one	
	place only for example purposes.  You may find that because this page is so	
	data intesive that you may need to break it up into smaller pages.			
																				
--->

<!--- This header include should be changed to the header of your site.  Make sure that you review the header to include necessary JS elements for slatwall templates to work --->
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

<cfoutput>
	<div class="container">
		
		
		<!--- USER MY-ACCOUNT SECTION IF LOGGED IN --->
		<cfif $.slatwall.getLoggedInFlag()>
			<div class="row">
				<div class="span12">
					
					<h2>#$.slatwall.getAccount().getFullName()# - My Account <span class="pull-right" style="font-size:14px;"><a href="?slatAction=public:account.logout">logout</a></span></h2>
					
					<!--- PRIMARY TAB NAV --->
					<div class="tabable">
						<ul class="nav nav-tabs" id="myTab">
							<li class="active"><a href="##profile" data-toggle="tab">Profile</a></li>
							<li><a href="##orders" data-toggle="tab">Orders</a></li>
							<li><a href="##carts-and-quotes" data-toggle="tab">Carts & Quotes</a></li>
							<li><a href="##subscriptions" data-toggle="tab">Subscriptions</a></li>
							<li><a href="##purchased-content" data-toggle="tab">Purchased Content</a></li>
						</ul>
						
						<!--- PRIMARY TAB CONTENT --->
						<div class="tab-content">
							
							<!--- ================== PROFILE TAB ======================== --->
							<div class="tab-pane active" id="profile">
								
								<div class="row">
									
									<!--- Left Side General Details --->
									<div class="span4">
										
										<h4>Profile Details</h4>
										<hr style="margin-top:10px;border-top-color:##ddd;" />
										
										<!--- Start: Update Account Form --->
										<form action="?s=1" method="post">
											
											<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
											<input type="hidden" name="slatAction" value="public:account.update" />
												
											<!--- First Name --->
											<div class="control-group">
						    					<label class="control-label" for="firstName">First Name</label>
						    					<div class="controls">
						    						
													<sw:formField type="text" valueObject="#$.slatwall.getAccount()#" valueObjectProperty="firstName" class="span4" />
													<sw:errorDisplay object="#$.slatwall.getAccount()#" errorName="firstName" />
													
						    					</div>
						  					</div>
											
											<!--- Last Name --->
											<div class="control-group">
						    					<label class="control-label" for="lastName">Last Name</label>
						    					<div class="controls">
						    						
													<sw:formField type="text" valueObject="#$.slatwall.getAccount()#" valueObjectProperty="lastName" class="span4" />
													<sw:errorDisplay object="#$.slatwall.getAccount()#" errorName="lastName" />
													
						    					</div>
						  					</div>
											
											<!--- Start: Custom "Account" Attribute Sets --->
											<cfset accountAttributeSets = $.slatwall.getAccount().getAssignedAttributeSetSmartList().getRecords() />
											
											<!--- Only display if there are attribute sets assigned --->
											<cfif arrayLen(accountAttributeSets)>
												
												<!--- Loop over all of the attribute sets --->
												<cfloop array="#accountAttributeSets#" index="attributeSet">
													
													<!--- display the attribute set name --->
													<h5>#attributeSet.getAttributeSetName()#</h5>
													
													<!--- Loop over all of the attributes --->
													<cfloop array="#attributeSet.getAttributes()#" index="attribute">
														
														<!--- Pull this attribute value object out of the order entity ---> 
														<cfset attributeValueObject = $.slatwall.getAccount().getAttributeValue(attribute.getAttributeCode(), true) />
														
														<!--- Display the attribute value --->
														<div class="control-group">
															
									    					<label class="control-label" for="rating">#attribute.getAttributeName()#</label>
									    					<div class="controls">
									    						
																<sw:formField type="#attribute.getFormFieldType()#" name="#attribute.getAttributeCode()#" valueObject="#attributeValueObject#" valueObjectProperty="attributeValue" valueOptions="#attributeValueObject.getAttributeValueOptions()#" class="span4" />
																<sw:errorDisplay object="#attributeValueObject#" errorName="password" />
																
									    					</div>
									  					</div>
														
													</cfloop>
													
												</cfloop>
											</cfif>
											<!--- End: Custom Attribute Sets --->
											
											<!--- Update Button --->
											<div class="control-group">
						    					<div class="controls">
						      						<button type="submit" class="btn btn-primary">Update Account</button>
						    					</div>
						  					</div>
											
										</form>
										<!--- End: Update Account Form --->
										
										<br />
										
										<h4>Change Password</h4>
										<hr style="margin-top:10px;border-top-color:##ddd;" />
										
										<!--- Start: Change Password Form --->
										<form action="?s=1" method="post">
											
											<!--- Get the change password process object --->
											<cfset changePasswordObj = $.slatwall.getAccount().getProcessObject('changePassword') />
											
											<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
											<input type="hidden" name="slatAction" value="public:account.changePassword" />
												
											<!--- New Password --->
											<div class="control-group">
						    					<label class="control-label" for="lastName">New Password</label>
						    					<div class="controls">
						    						
													<sw:formField type="password" valueObject="#changePasswordObj#" valueObjectProperty="password" class="span4" />
													<sw:errorDisplay object="#changePasswordObj#" errorName="password" />
													
						    					</div>
						  					</div>
											
											<!--- Confirm New Password --->
											<div class="control-group">
						    					<label class="control-label" for="lastName">Confirm New Password</label>
						    					<div class="controls">
						    						
													<sw:formField type="password" valueObject="#changePasswordObj#" valueObjectProperty="passwordConfirm" class="span4" />
													<sw:errorDisplay object="#changePasswordObj#" errorName="passwordConfirm" />
													
						    					</div>
						  					</div>
											
											<!--- Change Button --->
											<div class="control-group">
						    					<div class="controls">
						      						<button type="submit" class="btn btn-primary">Change Password</button>
						    					</div>
						  					</div>
											
										</form>
										<!--- End: Change Password Form --->
										
										<br />
										
									</div>
									
									<!--- Start: Right Side Contact & Payment Methods --->
									<div class="span8">
										
										<!--- Start: Email & Phone --->
										<div class="row">
											
											<!--- START: PHONE NUMBERS --->
											<div class="span4">
												<h4>Phone Numbers</h4>
												
												<!--- Start: Existing Phone Numbers --->
												<table class="table table-condensed">
													<cfloop array="#$.slatwall.getAccount().getAccountPhoneNumbersSmartList().getRecords()#" index="accountPhoneNumber">
														<tr>
															<td>
																<span>#accountPhoneNumber.getPhoneNumber()#</span>
																
																<cfif accountPhoneNumber.getAccountPhoneNumberID() eq $.slatwall.getAccount().getPrimaryPhoneNumber().getAccountPhoneNumberID()>
																	- <i class="icon-asterisk" title="#accountPhoneNumber.getPhoneNumber()# is the primary phone number for this account"></i>
																<cfelse>
																	<span class="pull-right">
																		<a href="?slatAction=public:account.update&primaryPhoneNumber.accountPhoneNumberID=#accountPhoneNumber.getAccountPhoneNumberID()#" title="Set #accountPhoneNumber.getPhoneNumber()# as your primary phone number"><i class="icon-asterisk"></i></a>&nbsp;
																		<a href="?slatAction=public:account.deleteAccountPhoneNumber&accountPhoneNumberID=#accountPhoneNumber.getAccountPhoneNumberID()#" title="Delete Phone Number - #accountPhoneNumber.getPhoneNumber()#"><i class="icon-trash"></i></a>
																	</span>
																</cfif>
															</td>
														</tr>
													</cfloop>
												</table>
												<!--- End: Existing Phone Numbers --->
												
												<!--- Start: Add Phone Number Form --->
												<form action="?s=1" method="post">
													<input type="hidden" name="slatAction" value="public:account.update" />
													<input type="hidden" name="accountPhoneNumbers[1].accountPhoneNumberID" value="" />
													<div class="control-group">
								    					<div class="controls">
								    						
								    						<cfset newAccountPhoneNumber = $.slatwall.getAccount().getNewPropertyEntity( 'accountPhoneNumbers' ) />
															
							    							<div class="input-append">
							    								<sw:formField type="text" name="accountPhoneNumbers[1].phoneNumber" valueObject="#newAccountPhoneNumber#" valueObjectProperty="phoneNumber" fieldAttributes='placeholder="Add Phone Number"' class="span3" />
																<button type="submit" class="btn btn-primary"><i class="icon-plus icon-white"></i></button>
															</div>
															
															<sw:errorDisplay object="#newAccountPhoneNumber#" errorName="phoneNumber" />
															
								    					</div>
								  					</div>
												</form>
												<!--- End: Add Phone Number Form --->
												
												<br />		
											</div>
											<!--- END: PHONE NUMBERS --->
											
											<!--- START: EMAIL ADDRESSES --->
											<div class="span4">
												<h4>Email Addresses</h4>
												
												<!--- Existing Email Addresses --->
												<table class="table table-condensed">
													
													<!--- Loop over all of the existing email addresses --->
													<cfloop array="#$.slatwall.getAccount().getAccountEmailAddressesSmartList().getRecords()#" index="accountEmailAddress">
														
														<tr>
															<td>
																
																<!--- Email Address --->
																<span>#accountEmailAddress.getEmailAddress()#</span>
																
																<!--- Admin buttons --->
																<cfif accountEmailAddress.getAccountEmailAddressID() eq $.slatwall.getAccount().getPrimaryEmailAddress().getAccountEmailAddressID()>
																	- <i class="icon-asterisk" title="#accountEmailAddress.getEmailAddress()# is the primary email address for this account"></i>
																<cfelse>
																	<span class="pull-right">
																		<a href="?slatAction=public:account.update&primaryEmailAddress.accountEmailAddressID=#accountEmailAddress.getAccountEmailAddressID()#" title="Set #accountEmailAddress.getEmailAddress()# as your primary email address"><i class="icon-asterisk"></i></a>&nbsp;
																		<a href="?slatAction=public:account.deleteAccountEmailAddress&accountEmailAddressID=#accountEmailAddress.getAccountEmailAddressID()#" title="Delete Email Address - #accountEmailAddress.getEmailAddress()#"><i class="icon-trash"></i></a>
																	</span>
																</cfif>
																
															</td>
														</tr>
														
													</cfloop>
												</table>
												
												<!--- Start: Add Email Address Form --->
												<form action="?s=1" method="post">
													
													<!--- Hidden slatAction to update the account --->
													<input type="hidden" name="slatAction" value="public:account.update" />
													
													<!--- Because we want to have a new accountEmailAddress, we set the ID as blank for the account update ---> 
													<input type="hidden" name="accountEmailAddresses[1].accountEmailAddressID" value="" />
													
													<!--- Email Address --->
													<div class="control-group">
								    					<div class="controls">
							    							<div class="input-append">
							    								<cfset newAccountEmailAddress = $.slatwall.getAccount().getNewPropertyEntity( 'accountEmailAddresses' ) />
															
								    							<div class="input-append">
								    								<sw:formField type="text" name="accountEmailAddresses[1].emailAddress" valueObject="#newAccountEmailAddress#" valueObjectProperty="emailAddress" fieldAttributes='placeholder="Add Email Address"' class="span3" />
																	<button type="submit" class="btn btn-primary"><i class="icon-plus icon-white"></i></button>
																</div>
																
																<sw:errorDisplay object="#newAccountEmailAddress#" errorName="emailAddress" />
															</div>
								    					</div>
								  					</div>
													
												</form>
												<!--- End: Add Email Address Form --->
												
												<br />
																								
											</div>
											<!--- END: EMAIL ADDRESSES --->
											
										</div>
										<!--- End: Email & Phone --->
										
										
										<!--- START: ADDRESS BOOK --->
										<h4>Address Book</h4>
										<hr style="margin-top:10px;border-top-color:##ddd;" />
											
										<ul class="thumbnails">
											
											<!--- Loop over each of the addresses that are saved against the account --->
											<cfloop array="#$.slatwall.getAccount().getAccountAddressesSmartList().getRecords()#" index="accountAddress">
												
												<li class="span4">
													
													<!--- Display an address block --->	
													<div class="thumbnail">
														
														<!--- Administration options --->
														<div class="pull-right">
															<span class="pull-right">
																<!--- If this is the primary address, then just show the astricks --->
																<cfif accountAddress.getAccountAddressID() eq $.slatwall.getAccount().getPrimaryAddress().getAccountAddressID()>
																	<i class="icon-asterisk" title="This is the primary address for your account"></i>
																<!--- Otherwise add buttons to be able to delete the address, or make it the primary --->
																<cfelse>
																	<a href="?slatAction=public:account.update&primaryAddress.accountAddressID=#accountAddress.getAccountAddressID()#" title="Set this as your primary phone address"><i class="icon-asterisk"></i></a>
																	<a href="?slatAction=public:account.deleteAccountAddress&accountAddressID=#accountAddress.getAccountAddressID()#" title="Delete Address"><i class="icon-trash"></i></a>
																</cfif>
															</span>
														</div>
														
														<!--- Address Nickname if it exists --->
														<cfif not isNull(accountAddress.getAccountAddressName())>
															<strong>#accountAddress.getAccountAddressName()#</strong>
														</cfif>
														
														<!--- Actual Address Details --->
														<sw:addressDisplay address="#accountAddress.getAddress()#" />
														
														
													</div>
												</li>
												
											</cfloop>
											
											<!--- Start: New Address --->
											<li class="span4">
												
												<div class="accordion" id="add-account-address">
												
													<div class="accordion-group">
													
														<!--- This is the top accordian header row --->
														<div class="accordion-heading">
															<a class="accordion-toggle" data-toggle="collapse" data-parent="##add-account-address" href="##new-account-address-form"><i class="icon-plus"></i>Add Account Address</a>
														</div>
													
														<!--- This is the accordian details when expanded --->
														<div id="new-account-address-form" class="accordion-body collapse">
														
															<div class="accordion-inner">
																
																<!--- get the newPropertyEntity for accountAddress --->
																<cfset newAccountAddress = $.slatwall.getAccount().getNewPropertyEntity( 'accountAddresses' ) />
																
																<!--- Start: New Address Form --->
																<form action="?s=1" method="post">
																	
																	<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
																	<input type="hidden" name="slatAction" value="public:account.update" />
																	
																	<!--- Set the accountAddressID to blank so tha it creates a new one --->
																	<input type="hidden" name="accountAddresses[1].accountAddressID" value="" />
																	
																	<!--- Nickname --->
																	<div class="control-group">
												    					<label class="control-label" for="firstName">Nickname</label>
												    					<div class="controls">
												    						
																			<sw:formField type="text" name="accountAddresses[1].accountAddressName" valueObject="#newAccountAddress#" valueObjectProperty="accountAddressName" class="span3" />
																			<sw:errorDisplay object="#newAccountAddress#" errorName="accountAddressName" />
																			
												    					</div>
												  					</div>
																	
																	<!--- New Address --->
																	<sw:addressForm id="newAccountAddress" address="#newAccountAddress.getAddress()#" fieldNamePrefix="accountAddresses[1].address." fieldClass="span3" />
																	
																	<!--- Update Button --->
																	<div class="control-group">
												    					<div class="controls">
												      						<button type="submit" class="btn btn-primary"><i class="icon-plus icon-white"></i> Add Address</button>
												    					</div>
												  					</div>
																	
																</form>
																<!--- End: New Address Form --->
																
															</div>
														</div>
													</div>
												</div>
											</li>
											<!--- End: New Address --->
												
										</ul>
										<!--- END: ADDRESS BOOK --->
											
										<br />
										
										<!--- START: PAYMENT METHODS --->
										<h4>Payment Methods</h4>
										<hr style="margin-top:10px;border-top-color:##ddd;" />
										
										<ul class="thumbnails">
											
											<!--- Loop over each of the addresses that are saved against the account --->
											<cfloop array="#$.slatwall.getAccount().getAccountPaymentMethodsSmartList().getRecords()#" index="accountPaymentMethod">
												
												<li class="span4">
													
													<!--- Display an address block --->	
													<div class="thumbnail">
														
														<!--- Administration options --->
														<div class="pull-right">
														
															<span class="pull-right">
																
																<!--- If this is the primary payment method, then just show the astricks --->
																<cfif accountPaymentMethod.getAccountPaymentMethodID() eq $.slatwall.getAccount().getPrimaryPaymentMethod().getAccountPaymentMethodID()>
																	<i class="icon-asterisk" title="This is the primary payment method for your account"></i>
																<!--- Otherwise add buttons to be able to delete the address, or make it the primary --->
																<cfelse>
																	<a href="?slatAction=public:account.update&primaryPaymentMethod.accountPaymentMethodID=#accountPaymentMethod.getAccountPaymentMethodID()#" title="Set this as your primary phone address"><i class="icon-asterisk"></i></a>
																	<a href="?slatAction=public:account.deleteAccountPaymentMethod&accountPaymentMethodID=#accountPaymentMethod.getAccountPaymentMethodID()#" title="Delete Address"><i class="icon-trash"></i></a>
																</cfif>
																
															</span>
														</div>
														
														<strong>#accountPaymentMethod.getPaymentMethod().getPaymentMethodName()# <cfif not isNull(accountPaymentMethod.getAccountPaymentMethodName()) and len(accountPaymentMethod.getAccountPaymentMethodName())>- #accountPaymentMethod.getAccountPaymentMethodName()#</cfif></strong><br />
														
														<!--- Credit Card Display --->
														<cfif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "creditCard">
															#accountPaymentMethod.getCreditCardType()# - #accountPaymentMethod.getCreditCardLastFour()#<br />
															#accountPaymentMethod.getNameOnCreditCard()#<br />
															#accountPaymentMethod.getExpirationMonth()# / #accountPaymentMethod.getExpirationYear()#<br />
															#accountPaymentMethod.getBillingAddress().getSimpleRepresentation()#
														
														<!--- External Display --->
														<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "external">
															
														<!--- Gift Card Display --->
														<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "giftCard">
														
														<!--- Term Payment Display --->
														<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "termPayment">
															
														</cfif>
														
													</div>
													
												</li>
												
											</cfloop>
											
											<!--- Start: New Payment Method --->
												
											<!--- get the newPropertyEntity for accountPaymentMethod --->
											<cfset newAccountPaymentMethod = $.slatwall.getAccount().getNewPropertyEntity( 'accountPaymentMethods' ) />
											
											<!--- verify that there are payment methods that can be saved --->
											<cfif arrayLen(newAccountPaymentMethod.getPaymentMethodOptionsSmartList().getRecords())>
												<li class="span4">
													
													<div class="accordion" id="add-account-payment-method">
														
														<!--- Loop over all of the potential payment methods that can be saved --->
														<cfloop array="#newAccountPaymentMethod.getPaymentMethodOptionsSmartList().getRecords()#" index="paymentMethod">
															
															<cfset pmID = "pm#lcase(createUUID())#" /> 
															
															<div class="accordion-group">
															
																<!--- This is the top accordian header row --->
																<div class="accordion-heading">
																	<a class="accordion-toggle" data-toggle="collapse" data-parent="##add-account-payment-method" href="###pmID#"><i class="icon-plus"></i>Add #paymentMethod.getPaymentMethodName()#</a>
																</div>
															
																<!--- This is the accordian details when expanded --->
																<div id="#pmID#" class="accordion-body collapse">
																
																	<div class="accordion-inner">
																		
																		<!--- Start: New Payment Method Form --->
																		<form action="?s=1" method="post">
																			
																			<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
																			<input type="hidden" name="slatAction" value="public:account.update" />
																			
																			<!--- Set the accountAddressID to blank so tha it creates a new one --->
																			<input type="hidden" name="accountPaymentMethods[1].accountPaymentMethodID" value="" />
																			
																			<input type="hidden" name="accountPaymentMethods[1].paymentMethod.paymentMethodID" value="#paymentMethod.getPaymentMethodID()#" />
																			
																			<!--- Nickname --->
																			<div class="control-group">
														    					<label class="control-label" for="firstName">Nickname</label>
														    					<div class="controls">
														    						
																					<sw:formField type="text" name="accountPaymentMethods[1].accountPaymentMethodName" valueObject="#newAccountPaymentMethod#" valueObjectProperty="accountAddressName" class="span3" />
																					<sw:errorDisplay object="#newAccountPaymentMethod#" errorName="accountPaymentMethodName" />
																					
														    					</div>
														  					</div>
																			
																			<!--- Credit Card --->
																			<cfif paymentMethod.getPaymentMethodType() eq "creditCard">
																				
																				<!--- Credit Card Number --->
																				<div class="control-group">
															    					<label class="control-label" for="firstName">Credit Card Number</label>
															    					<div class="controls">
															    						
																						<sw:formField type="text" name="accountPaymentMethods[1].creditCardNumber" valueObject="#newAccountPaymentMethod#" valueObjectProperty="creditCardNumber" class="span3" />
																						<sw:errorDisplay object="#newAccountPaymentMethod#" errorName="creditCardNumber" />
																						
															    					</div>
															  					</div>
																				
																				<!--- Name on Credit Card --->
																				<div class="control-group">
															    					<label class="control-label" for="firstName">Name on Credit Card</label>
															    					<div class="controls">
															    						
																						<sw:formField type="text" name="accountPaymentMethods[1].nameOnCreditCard" valueObject="#newAccountPaymentMethod#" valueObjectProperty="nameOnCreditCard" class="span3" />
																						<sw:errorDisplay object="#newAccountPaymentMethod#" errorName="nameOnCreditCard" />
																						
															    					</div>
															  					</div>
																				
																				
																				<!--- Security & Expiration Row --->
																				<div class="row">
																					
																					<div class="span1">
																						
																						<!--- Security Code --->
																						<div class="control-group">
																	    					<label class="control-label" for="rating">CVV</label>
																	    					<div class="controls">
																	    						
																								<sw:formField type="text" name="accountPaymentMethods[1].securityCode" valueObject="#newAccountPaymentMethod#" valueObjectProperty="securityCode" class="span1" />
																								<sw:errorDisplay object="#newAccountPaymentMethod#" errorName="securityCode" />
																								
																	    					</div>
																	  					</div>
																						
																					</div>
																					
																					
																					<div class="span2">
																						
																						<!--- Expiration --->	
																						<div class="control-group">
																	    					<label class="control-label pull-right" for="rating">Exp. (MM/YYYY)</label>
																	    					<div class="controls pull-right">
																	    						
																								<sw:formField type="select" name="accountPaymentMethods[1].expirationMonth" valueObject="#newAccountPaymentMethod#" valueObjectProperty="expirationMonth" valueOptions="#newAccountPaymentMethod.getExpirationMonthOptions()#" class="span1" />
																								<sw:formField type="select" name="accountPaymentMethods[1].expirationYear" valueObject="#newAccountPaymentMethod#" valueObjectProperty="expirationYear" valueOptions="#newAccountPaymentMethod.getExpirationYearOptions()#" class="span1" />
																								<sw:errorDisplay object="#newAccountPaymentMethod#" errorName="expirationMonth" />
																								<sw:errorDisplay object="#newAccountPaymentMethod#" errorName="expirationYear" />
																								
																	    					</div>
																	  					</div>
																						
																					</div>
																				</div>
																				
																				<hr />
																				<h5>Address on Card</h5>
																				
																				<!--- Billing Address --->
																				<sw:addressForm id="newBillingAddress" address="#newAccountPaymentMethod.getBillingAddress()#" fieldNamePrefix="accountPaymentMethods[1].billingAddress." fieldClass="span3" />
																			<cfelseif paymentMethod.getPaymentMethodType() eq "external">
																				
																			<cfelseif paymentMethod.getPaymentMethodType() eq "giftCard">
																				
																				<!--- Gift Card Number --->
																				<div class="control-group">
															    					<label class="control-label" for="firstName">Gift Card Number</label>
															    					<div class="controls">
															    						
																						<sw:formField type="text" name="accountPaymentMethods[1].giftCardNumber" valueObject="#newAccountPaymentMethod#" valueObjectProperty="giftCardNumber" class="span3" />
																						<sw:errorDisplay object="#newAccountPaymentMethod#" errorName="giftCardNumber" />
																						
															    					</div>
															  					</div>
																				
																			<cfelseif paymentMethod.getPaymentMethodType() eq "termPayment">
																				<hr />
																				<h5>Billing Address</h5>
																				
																				<!--- Billing Address --->
																				<sw:addressForm id="newBillingAddress" address="#newAccountPaymentMethod.getBillingAddress()#" fieldNamePrefix="accountPaymentMethods[1].billingAddress." fieldClass="span3" />
																			</cfif>
																			
																			
																			<!--- Update Button --->
																			<div class="control-group">
														    					<div class="controls">
														      						<button type="submit" class="btn btn-primary"><i class="icon-plus"></i> Add Payment Method</button>
														    					</div>
														  					</div>
																			
																		</form>
																		<!--- End: New Payment Method Form --->
																		
																	</div>
																</div>
															</div>
														</cfloop>
													</div>
												</li>
											</cfif>
											<!--- End: New Payment Method --->
												
										</ul>
										<!--- END: PAYMENT METHODS --->
										
									</div>
									<!--- End: Right Side Contact & Payment Methods --->
									
								</div>
								
							</div>
							
							<!--- ================== ORDER HISTORY TAB ================== --->
							<div class="tab-pane" id="orders">
								<h4>Order History</h4>
								
								<!--- Setup an accordian view for existing orders --->
								<div class="accordion" id="order-history-acc">
									
									<!--- Loop over all of the orders that this account has placed --->
									<cfloop array="#$.slatwall.account().getOrdersPlacedSmartList().getRecords()#" index="order">
								  	
									  	<!--- create a DOM ID to be used for open and closing --->
									  	<cfset orderDOMID = "oid#order.getOrderID()#" />
										
										<div class="accordion-group">
											
											<!--- This is the top accordian header row --->
											<div class="accordion-heading">
												<a class="accordion-toggle" data-toggle="collapse" data-parent="##order-history-acc" href="###orderDOMID#">Order ## #order.getOrderNumber()# &nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;&nbsp; #order.getFormattedValue('orderOpenDateTime', 'date' )# &nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;&nbsp; #order.getFormattedValue('total')# <span class="pull-right">Status: #order.getOrderStatusType().getType()#</span></a>
											</div>
											
											<!--- This is the accordian details when expanded --->
											<div id="#orderDOMID#" class="accordion-body collapse">
												
												<div class="accordion-inner">
														
													<!--- Overview & Status --->
													<h5>Overview & Status</h5>
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
														
													<!--- Start: Order Deliveries --->
													<cfif arrayLen(order.getOrderDeliveries())>
														<hr style="border-top-style:dashed !important; border-top-width:5px !important;" />
														<h5>Order Deliveries</h5>
														
														<cfloop array="#order.getOrderDeliveries()#" index="orderDelivery">
															<table class="table table-bordered table-condensed">
																<tr>
																	<!--- Delivery Details --->
																	<td class="well span3" rowspan="#arrayLen(orderDelivery.getOrderDeliveryItems()) + 1#">
																		
																		<!--- Fulfillment Name --->
																		<strong>Date:</strong> #orderDelivery.getFormattedValue('createdDateTime')#<br />
																		
																		<!--- Fulfillment Details: Email --->
																		<cfif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() eq "email">
																			<strong>Emailed To:</strong> #orderFulfillment.getEmailAddress()#<br />
																			
																		<!--- Fulfillment Details: Pickup --->
																		<cfelseif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup">
																			<strong>Picked Up At:</strong> #orderDelivery.getPickupLocation().getLocationName()#<br />
																			
																		<!--- Fulfillment Details: Shipping --->
																		<cfelseif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
																			<strong>Shipped To:</strong><br />
																			<sw:addressDisplay address="#orderDelivery.getShippingAddress()#" />
																			<cfif not isNull(orderDelivery.getTrackingNumber())>
																				<br />
																				<strong>Tracking Number: <a href="##">#orderDelivery.getTrackingNumber()#</a></strong>
																			</cfif>
																		</cfif>
																		
																		<!--- Amount Captured --->
																		<cfif not isNull(orderDelivery.getPaymentTransaction())>
																			<br />
																			<strong>Charged:</strong> #orderDelivery.getPaymentTransaction().getFormattedValue('amountReceived')#
																		</cfif>
																		
																	</td>
																	
																	<!--- Additional Header Rows --->
																	<th>Sku Code</th>
																	<th>Product Title</th>
																	<th>Qty.</th>
																</tr>
																<cfloop array="#orderDelivery.getOrderDeliveryItems()#" index="orderDeliveryItem">
																	<tr>
																		<td>#orderDeliveryItem.getOrderItem().getSku().getSkuCode()#</td>
																		<td>#orderDeliveryItem.getOrderItem().getSku().getProduct().getTitle()#</td>
																		<td>#orderDeliveryItem.getQuantity()#</td>
																	</tr>
																</cfloop>
															</table>
														</cfloop>
														
													</cfif>
													<!--- End: Order Deliveries --->
														
												</div> <!--- END: accordion-inner --->
												
											</div> <!--- END: accordion-body --->
											
										</div> <!--- END: accordion-group --->
											
									</cfloop>
									
								</div>
								
							</div>
							
							<!--- =================== CARTS & QUOTES ===================== --->
							<div class="tab-pane" id="carts-and-quotes">
								<h4>Shopping Carts & Quotes</h4>
								
								<div class="accordion" id="cart-and-quotes-acc">
									
									<cfset $.slatwall.account().getOrdersNotPlacedSmartList().addOrder('createdDateTime|DESC') />
									
									<!--- Loop over all of the 'notPlaced' orders --->
									<cfloop array="#$.slatwall.account().getOrdersNotPlacedSmartList().getRecords()#" index="order">
										
										<!--- Setup an orderID for the accordion --->
										<cfset orderDOMID = "oid#order.getOrderID()#" />
										
										<div class="accordion-group">
											
											<!--- Main Button to expand order --->
											<div class="accordion-heading">
												<a class="accordion-toggle" data-toggle="collapse" data-parent="##cart-and-quotes-acc" href="###orderDOMID#">#order.getFormattedValue('createdDateTime', 'date')# <cfif order.getOrderID() eq $.slatwall.cart().getOrderID()><span class="pull-right"><i class="icon-shopping-cart"></i></span></cfif></a>
				    						</div>
											
											<!--- Saved order content --->
											<div id="#orderDOMID#" class="accordion-body collapse">
												
												<div class="accordion-inner">
													
													<!--- Overview & Status --->
													<h5>Overview & Status</h5>
													<div class="row">
														
														<div class="span4">
															<table class="table table-bordered table-condensed">
																<tr>
																	<td>Cart Created</td>
																	<td>#order.getFormattedValue('createdDateTime')#</td>
																</tr>
																<tr>
																	<td>Last Updated</td>
																	<td>#order.getFormattedValue('modifiedDateTime')#</td>
																</tr>
															</table>
														</div>
														<div class="span4 pull-right">
															<table class="table table-bordered table-condensed">
																<tr>
																	<td>Current Subtotal</td>
																	<td>#order.getFormattedValue('subTotalAfterItemDiscounts')#</td>
																</tr>
																<tr>
																	<td>Est. Delivery Charges</td>
																	<td>#order.getFormattedValue('fulfillmentChargeAfterDiscountTotal')#</td>
																</tr>
																<tr>
																	<td>Est. Taxes</td>
																	<td>#order.getFormattedValue('taxTotal')#</td>
																</tr>
																<tr>
																	<td><strong>Est. Total</strong></td>
																	<td><strong>#order.getFormattedValue('total')#</strong></td>
																</tr>
																<cfif order.getDiscountTotal() gt 0>
																	<tr>
																		<td colspan="2" class="text-error">This cart includes #order.getFormattedValue('discountTotal')# of savings.</td>
																	</tr>
																</cfif>
															</table>
														</div>
													</div>
													
													<!--- Start: Order Details --->
													<hr />
													<h5>Cart Items</h5>
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
																	<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup">
																		<strong>Pickup Location:</strong> #orderFulfillment.getPickupLocation().getLocationName()#<br />
																		<sw:addressDisplay address="#orderFulfillment.getPickupLocation().getPrimaryAddress().getAddress()#" />
																		
																	<!--- Fulfillment Details: Shipping --->
																	<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
																		<cfif not orderFulfillment.getAddress().getNewFlag()>
																			<sw:addressDisplay address="#orderFulfillment.getAddress()#" />
																		</cfif>
																		<cfif not isNull(orderFulfillment.getShippingMethod())>
																		<strong>Shipping Method:</strong> #orderFulfillment.getShippingMethod().getShippingMethodName()#<br />
																		</cfif>
																		
																	</cfif>
																	
																	<!--- Delivery Fee --->
																	<cfif orderFulfillment.getChargeAfterDiscount() gt 0>
																		<br />
																		<strong>Est. Delivery Fee:</strong> #orderFulfillment.getFormattedValue('chargeAfterDiscount')#
																	</cfif>
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
														
													<!--- Action Buttons --->
													<cfif order.getOrderID() neq $.slatwall.cart().getOrderID()>
														<div class="row">
															<div class="span3 pull-right">
																<div class="btn-group pull-right">
																	<a class="btn" href="?slatAction=public:cart.change&orderID=#order.getOrderID()#"><i class="icon-shopping-cart"></i> Swap to this Cart</a>
																	<a class="btn" href="?slatAction=public:cart.delete&orderID=#order.getOrderID()#"><i class="icon-trash"></i> Delete</a>
																</div>
															</div>
														</div>
													</cfif>
															
												</div> <!--- END: accordion-inner --->
												
											</div> <!--- END: accordion-body --->
												
										</div> <!--- END: accordion-group --->
											
									</cfloop>
									
			 					</div>
							</div>
							
							<!--- ==================== SUBSCRIPTIONS ==================== --->
							<div class="tab-pane" id="subscriptions">
								<h4>Subscription Management</h4>
								Show Subscriptions Here
							</div>
							
							<!--- ==================== PURCHASED CONTENT ==================== --->
							<div class="tab-pane" id="purchased-content">
								<h4>Purchased Content Access</h4>
								
								<table class="table">
									<tr>
										<th>Content Title</th>
										<th>Order Number</th>
										<th>Date Purchased</th>
									</tr>
									
									<cfloop array="#$.slatwall.getAccount().getAccountContentAccessesSmartList().getRecords()#" index="accountContentAccess">
										<cfloop array="#accountContentAccess.getContents()#" index="content">
											<tr>
												<td>#content.getTitle()#</td>
												<td>#accountContentAccess.getOrderItem().getOrder().getOrderNumber()#</td>
												<td>#accountContentAccess.getOrderItem().getOrder().getFormattedValue('orderOpenDateTime')#</td>
											</tr>
										</cfloop>
									</cfloop>
								</table>
								
							</div>
							
						</div> <!--- END OF TABABLE --->
						
					</div>
				</div>
			</div>
			
		<!--- CREATE / LOGIN FORMS --->
		<cfelse>
			<div class="row">
				<div class="span12">
					<h2>My Account</h2>
				</div>
			</div>
			<div class="row">
				<!--- LOGIN --->
				<div class="span6">
					
					<h4>Login with Existing Account</h4>
					
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
	    						
								<sw:formField type="text" valueObject="#accountLoginObj#" valueObjectProperty="emailAddress" class="span6" />
								<sw:errorDisplay object="#accountLoginObj#" errorName="emailAddress" />
								
	    					</div>
	  					</div>
						
						<!--- Password --->
						<div class="control-group">
	    					<label class="control-label" for="rating">Password</label>
	    					<div class="controls">
	    						
								<sw:formField type="password" valueObject="#accountLoginObj#" valueObjectProperty="password" class="span6" />
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
	    						
								<sw:formField type="text" valueObject="#accountLoginObj#" valueObjectProperty="emailAddress" class="span6" />
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
				<div class="span6">
					<h4>Create New Account</h4>
					
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
							<div class="span3">
								<div class="control-group">
			    					<label class="control-label" for="rating">First Name</label>
			    					<div class="controls">
			    						
										<sw:formField type="text" valueObject="#createAccountObj#" valueObjectProperty="firstName" class="span3" />
										<sw:errorDisplay object="#createAccountObj#" errorName="firstName" />
										
			    					</div>
			  					</div>
							</div>
							
							<!--- Last Name --->
							<div class="span3">
								<div class="control-group">
			    					<label class="control-label" for="rating">Last Name</label>
			    					<div class="controls">
			    						
										<sw:formField type="text" valueObject="#createAccountObj#" valueObjectProperty="lastName" class="span3" />
										<sw:errorDisplay object="#createAccountObj#" errorName="lastName" />
										
			    					</div>
			  					</div>
							</div>
							
						</div>
						
						<!--- Phone Number --->
						<div class="control-group">
	    					<label class="control-label" for="rating">Phone Number</label>
	    					<div class="controls">
	    						
								<sw:formField type="text" valueObject="#createAccountObj#" valueObjectProperty="phoneNumber" class="span6" />
								<sw:errorDisplay object="#createAccountObj#" errorName="phoneNumber" />
								
	    					</div>
	  					</div>
						
						<!--- Email Address --->
						<div class="control-group">
	    					<label class="control-label" for="rating">Email Address</label>
	    					<div class="controls">
	    						
								<sw:formField type="text" valueObject="#createAccountObj#" valueObjectProperty="emailAddress" class="span6" />
								<sw:errorDisplay object="#createAccountObj#" errorName="emailAddress" />
								
	    					</div>
	  					</div>
						
						<!--- Email Address Confirm --->
						<div class="control-group">
	    					<label class="control-label" for="rating">Confirm Email Address</label>
	    					<div class="controls">
	    						
								<sw:formField type="text" valueObject="#createAccountObj#" valueObjectProperty="emailAddressConfirm" class="span6" />
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
		    						
									<sw:formField type="password" valueObject="#createAccountObj#" valueObjectProperty="password" class="span6" />
									<sw:errorDisplay object="#createAccountObj#" errorName="password" />
									
		    					</div>
		  					</div>
							
							<!--- Password Confirm --->
							<div class="control-group">
		    					<label class="control-label" for="rating">Confirm Password</label>
		    					<div class="controls">
		    						
									<sw:formField type="password" valueObject="#createAccountObj#" valueObjectProperty="passwordConfirm" class="span6" />
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
		</cfif>
	</div>
</cfoutput>
<cfinclude template="_slatwall-footer.cfm" />