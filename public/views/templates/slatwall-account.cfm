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

	This "My Account" example template is designed to give you an idea
	of what is possible through the frontend subsystem in the way of pulling
	information as well as updating account info.

	IMPORTANT: any of the individual components or different aspects	of this
	page can be copied into a seperate template and referenced as a seperate
	URL either in your CMS or custom application.  We have done this all in one
	place only for example purposes.  You may find that because this page is so
	data intesive that you may need to break it up into smaller pages.

--->

<!--- IMPORTANT: This is here so that the account layout is never cached by the browser --->
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate" />
<cfheader name="cache-control" value="post-check=0, pre-check=0" />
<cfheader name="last-modified" value="#now()#" />
<cfheader name="pragma"  value="no-cache" />

<!--- This header include should be changed to the header of your site.  Make sure that you review the header to include necessary JS elements for slatwall templates to work --->
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

<cfset paymentFormAction="?s=1">

<!--- If using HTTP, override the form to send over http if the setting Force Credit Card Over SSL is true --->
<cfif $.slatwall.setting('globalForceCreditCardOverSSL') EQ true AND (findNoCase("off", CGI.HTTPS) OR NOT CGI.SERVER_PORT_SECURE)>
	<cfset paymentFormAction = replace($.slatwall.getURL(), 'http://', 'https://') />
</cfif>

<cfoutput>
	<div class="container">

		<!--- USER MY-ACCOUNT SECTION IF LOGGED IN --->
		<cfif $.slatwall.getLoggedInFlag()>
			<div class="row">
				<div class="col-md-12">

					<h2>#htmlEditFormat( $.slatwall.getAccount().getFullName() )# - My Account <span class="pull-right" style="font-size:14px;"><a href="?slatAction=public:account.logout">logout</a></span></h2>

					<!--- PRIMARY TAB NAV --->
					<div class="tabable">
						<ul class="nav nav-tabs" role="tablist">
							<li role="presentation" class="active"><a href="##profile" aria-controls="profile" role="tab" data-toggle="tab">Profile</a></li>
							<li role="presentation"><a href="##orders" aria-controls="orders" role="tab" data-toggle="tab">Orders</a></li>
							<li role="presentation"><a href="##carts-and-quotes" aria-controls="carts-and-quotes" role="tab" data-toggle="tab">Carts & Quotes</a></li>
							<li role="presentation"><a href="##subscriptions" aria-controls="subscriptions" role="tab" data-toggle="tab">Subscriptions</a></li>
							<li role="presentation"><a href="##purchased-content" aria-controls="purchased-content" role="tab" data-toggle="tab">Purchased Content</a></li>
						</ul>

						<!--- PRIMARY TAB CONTENT --->
						<div class="tab-content">

							<!--- ================== PROFILE TAB ======================== --->
							<div role="tabpanel" class="tab-pane active" id="profile">
								<div class="row">
									<!--- Left Side General Details --->
									<div class="col-md-4">
										<h4>Profile Details</h4>
										<hr style="margin-top:10px;border-top-color:##ddd;" />

										<!--- Start: Update Account Form --->
										<form action="?s=1" method="post">
											<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
											<input type="hidden" name="slatAction" value="public:account.update" />

											<!--- First Name --->
											<div class="form-group">
						    					<label for="firstName">First Name</label>
												<sw:FormField type="text" valueObject="#$.slatwall.getAccount()#" valueObjectProperty="firstName" class="form-control" />
												<sw:ErrorDisplay object="#$.slatwall.getAccount()#" errorName="firstName" />
						  					</div>

											<!--- Last Name --->
											<div class="form-group">
						    					<label for="lastName">Last Name</label>
												<sw:FormField type="text" valueObject="#$.slatwall.getAccount()#" valueObjectProperty="lastName" class="form-control" />
												<sw:ErrorDisplay object="#$.slatwall.getAccount()#" errorName="lastName" />
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
														<cfset thisAttributeValueObject = $.slatwall.getAccount().getAttributeValue(attribute.getAttributeCode(), true) />

														<cfif isObject(thisAttributeValueObject)>
															<!--- Display the attribute value --->
															<div class="form-group">
										    					<label for="attributeValue">#attribute.getAttributeName()#</label>
																<sw:FormField type="#attribute.getFormFieldType()#" name="#attribute.getAttributeCode()#" valueObject="#thisAttributeValueObject#" valueObjectProperty="attributeValue" valueOptions="#thisattributeValueObject.getAttributeValueOptions()#" class="form-control" />
																<sw:ErrorDisplay object="#thisAttributeValueObject#" errorName="password" />
										  					</div>

										  				<cfelse>

										  					<div class="form-group">
										    					<label for="#attribute.getAttributeCode()#">#attribute.getAttributeName()#</label>
										  						<sw:FormField type="#attribute.getFormFieldType()#" name="#attribute.getAttributeCode()#" valueObject="#$.slatwall.getAccount()#" valueObjectProperty="#attribute.getAttributeCode()#" valueOptions="#attribute.getAttributeOptionsOptions()#"class="form-control" />
																<sw:ErrorDisplay object="#$.slatwall.getAccount()#" errorName="#attribute.getAttributeCode()#" />
										  					</div>
										  				</cfif>
													</cfloop>
												</cfloop>
											</cfif>
											<!--- End: Custom Attribute Sets --->

											<!--- Update Button --->
											<div class="form-group">
						      					<button type="submit" class="btn btn-primary">Update Account</button>
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
											<div class="form-group">
						    					<label for="password">New Password</label>
												<sw:FormField type="password" valueObject="#changePasswordObj#" valueObjectProperty="password" class="form-control" />
												<sw:ErrorDisplay object="#changePasswordObj#" errorName="password" />
						  					</div>

											<!--- Confirm New Password --->
											<div class="form-group">
						    					<label for="passwordConfirm">Confirm New Password</label>
												<sw:FormField type="password" valueObject="#changePasswordObj#" valueObjectProperty="passwordConfirm" class="form-control" />
												<sw:ErrorDisplay object="#changePasswordObj#" errorName="passwordConfirm" />
						  					</div>

											<!--- Change Button --->
											<div class="form-group">
						      					<button type="submit" class="btn btn-primary">Change Password</button>
						  					</div>
										</form>
										<!--- End: Change Password Form --->

										<br />
									</div>

									<!--- Start: Right Side Contact & Payment Methods --->
									<div class="col-md-8">
										<!--- Start: Email & Phone --->
										<div class="row">
											<!--- START: PHONE NUMBERS --->
											<div class="col-md-6">
												<h4>Phone Numbers</h4>

												<!--- Start: Existing Phone Numbers --->
												<table class="table table-condensed">
													<cfset accountPhoneNumberIndex=0 />

													<!--- Loop over the phone numbers to display them --->
													<cfloop array="#$.slatwall.getAccount().getAccountPhoneNumbersSmartList().getRecords()#" index="accountPhoneNumber">
														<cfset accountPhoneNumberIndex++ />

														<tr>
															<td>
																<!--- Display Number --->
																<div class="apn#accountPhoneNumberIndex#<cfif accountPhoneNumber.hasErrors()> hide</cfif>">
																	<span>#accountPhoneNumber.getPhoneNumber()#</span>
																	<span class="pull-right">
																		<a href="##" onClick="editToggle('.apn#accountPhoneNumberIndex#'); return false;" title="Edit Phone Number"><span class="glyphicon glyphicon-pencil"></span></a>
																		<a href="?slatAction=public:account.deleteAccountPhoneNumber&accountPhoneNumberID=#accountPhoneNumber.getAccountPhoneNumberID()#" title="Delete Phone Number - #accountPhoneNumber.getPhoneNumber()#"><span class="glyphicon glyphicon-trash"></span></a>
																		<cfif accountPhoneNumber.getAccountPhoneNumberID() eq $.slatwall.getAccount().getPrimaryPhoneNumber().getAccountPhoneNumberID()>
																			<span class="glyphicon glyphicon-asterisk" title="#accountPhoneNumber.getPhoneNumber()# is the primary phone number for this account" style="margin-right:5px;"></span>
																		<cfelse>
																			<a href="?slatAction=public:account.update&primaryPhoneNumber.accountPhoneNumberID=#accountPhoneNumber.getAccountPhoneNumberID()#" title="Set #accountPhoneNumber.getPhoneNumber()# as your primary phone number"><span class="glyphicon glyphicon-asterisk"></span></a>&nbsp;
																		</cfif>
																	</span>
																</div>

																<!--- Edit Number --->
																<div class="apn#accountPhoneNumberIndex#<cfif not accountPhoneNumber.hasErrors()> hide</cfif>">
																	<!--- Start: Edit Phone Number --->
																	<form action="?s=1" method="post">
																		<input type="hidden" name="slatAction" value="public:account.update" />
																		<input type="hidden" name="accountPhoneNumbers[1].accountPhoneNumberID" value="#accountPhoneNumber.getAccountPhoneNumberID()#" />

																		<!--- Phone Number --->
																		<div class="form-group">
																			<div class="input-group">
																				<sw:FormField type="text" name="accountPhoneNumbers[1].phoneNumber" valueObject="#accountPhoneNumber#" valueObjectProperty="phoneNumber" class="form-control" />
																				<span class="input-group-btn">
																					<button type="button" class="btn" onClick="editToggle('.apn#accountPhoneNumberIndex#'); return false;"><span class="glyphicon glyphicon-remove"></span></button>
																					<button type="submit" class="btn btn-primary">Save</button>
																				</span>
																			</div>
																			<sw:ErrorDisplay object="#accountPhoneNumber#" errorName="phoneNumber" />
													  					</div>
																	</form>
																	<!--- End: Edit Phone Number --->
																</div>
															</td>
														</tr>
													</cfloop>
												</table>
												<!--- End: Existing Phone Numbers --->

												<!--- Start: Add Phone Number Form --->
												<form action="?s=1" method="post">
													<input type="hidden" name="slatAction" value="public:account.update" />
													<input type="hidden" name="accountPhoneNumbers[1].accountPhoneNumberID" value="" />
													<div class="form-group">
							    						<cfset newAccountPhoneNumber = $.slatwall.getAccount().getNewPropertyEntity( 'accountPhoneNumbers' ) />

						    							<div class="input-group">
						    								<sw:FormField type="text" name="accountPhoneNumbers[1].phoneNumber" valueObject="#newAccountPhoneNumber#" valueObjectProperty="phoneNumber" fieldAttributes='placeholder="Add Phone Number"' class="form-control" />
						    								<span class="input-group-btn">
																<button type="submit" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span></button>
															</span>
														</div>

														<sw:ErrorDisplay object="#newAccountPhoneNumber#" errorName="phoneNumber" />
								  					</div>
												</form>
												<!--- End: Add Phone Number Form --->

												<br />
											</div>
											<!--- END: PHONE NUMBERS --->

											<!--- START: EMAIL ADDRESSES --->
											<div class="col-md-6">
												<h4>Email Addresses</h4>

												<!--- Existing Email Addresses --->
												<table class="table table-condensed">
													<cfset accountEmailAddressIndex = 0 />

													<!--- Loop over all of the existing email addresses --->
													<cfloop array="#$.slatwall.getAccount().getAccountEmailAddressesSmartList().getRecords()#" index="accountEmailAddress">
														<cfset accountEmailAddressIndex++ />

														<tr>
															<td>
																<!--- Display Email Address --->
																<div class="aea#accountEmailAddressIndex#<cfif accountEmailAddress.hasErrors()> hidden</cfif>">
																	<!--- Email Address --->
																	<span>#accountEmailAddress.getEmailAddress()# ( <cfif accountEmailAddress.getVerifiedFlag()>verified<cfelse><a href="?slatAction=public:account.sendAccountEmailAddressVerificationEmail&accountEmailAddressID=#accountEmailAddress.getAccountEmailAddressID()#">Verify Now</a></cfif> )</span>
																	<!---[DEVELOPER NOTES]
																		We are displaying a 'verified' value next to the email address, however you do not need to have email addresses get verified
																		for slatwall to function properly.  If you choose not to use verifications then you can just remove the links and let
																		email addresses stay unverified.
																	--->

																	<!--- Admin buttons --->
																	<span class="pull-right">
																		<a href="##" onClick="editToggle('.aea#accountEmailAddressIndex#'); return false;" title="Edit Email Address"><span class="glyphicon glyphicon-pencil"></span></a>
																		<cfif accountEmailAddress.getAccountEmailAddressID() neq $.slatwall.getAccount().getPrimaryEmailAddress().getAccountEmailAddressID()>
																			<a href="?slatAction=public:account.deleteAccountEmailAddress&accountEmailAddressID=#accountEmailAddress.getAccountEmailAddressID()#" title="Delete Email Address - #accountEmailAddress.getEmailAddress()#"><span class="glyphicon glyphicon-trash"></span></a>
																		</cfif>
																		<cfif accountEmailAddress.getAccountEmailAddressID() eq $.slatwall.getAccount().getPrimaryEmailAddress().getAccountEmailAddressID()>
																			<span class="glyphicon glyphicon-asterisk" title="#accountEmailAddress.getEmailAddress()# is the primary email address for this account" style="margin-right:5px;"></span>

																		<cfelse>

																			<a href="?slatAction=public:account.update&primaryEmailAddress.accountEmailAddressID=#accountEmailAddress.getAccountEmailAddressID()#" title="Set #accountEmailAddress.getEmailAddress()# as your primary email address"><span class="glyphicon glyphicon-asterisk"></span></a>&nbsp;
																		</cfif>
																	</span>
																</div>

																<!--- Edit Email Address --->
																<div class="aea#accountEmailAddressIndex#<cfif not accountEmailAddress.hasErrors()> hidden</cfif>">
																	<!--- Start: Edit Email Address --->
																	<form action="?s=1" method="post">
																		<input type="hidden" name="slatAction" value="public:account.update" />
																		<input type="hidden" name="accountEmailAddresses[1].accountEmailAddressID" value="#accountEmailAddress.getAccountEmailAddressID()#" />

																		<!--- Email Address --->
																		<div class="form-group">
																			<div class="input-group">
																				<sw:FormField type="text" name="accountEmailAddresses[1].emailAddress" valueObject="#accountEmailAddress#" valueObjectProperty="emailAddress" class="form-control" />
																				<span class="input-group-btn">
																					<button type="button" class="btn btn-default" onClick="editToggle('.aea#accountEmailAddressIndex#'); return false;"><span class="glyphicon glyphicon-remove"></span></button>
																					<button type="submit" class="btn btn-primary">Save</button>
																				</span>
																			</div>

																			<sw:ErrorDisplay object="#accountEmailAddress#" errorName="emailAddress" />
													  					</div>
																	</form>
																	<!--- End: Edit Email Address --->
																</div>
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
													<div class="form-group">
							    						<cfset newAccountEmailAddress = $.slatwall.getAccount().getNewPropertyEntity( 'accountEmailAddresses' ) />

					    								<div class="input-group">
						    								<sw:FormField type="text" name="accountEmailAddresses[1].emailAddress" valueObject="#newAccountEmailAddress#" valueObjectProperty="emailAddress" fieldAttributes='placeholder="Add Email Address"' class="form-control" />
						    								<span class="input-group-btn">
																<button type="submit" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span></button>
															</span>
														</div>

														<sw:ErrorDisplay object="#newAccountEmailAddress#" errorName="emailAddress" />
								  					</div>
												</form>
												<!--- End: Add Email Address Form --->
												<br>
											</div>
											<!--- END: EMAIL ADDRESSES --->
										</div>
										<!--- End: Email & Phone --->


										<!--- START: ADDRESS BOOK --->
										<h4>Address Book</h4>
										<hr style="margin-top:10px;border-top-color:##ddd;" />

										<cfset accountAddressIndex = 0 />

										<!--- Loop over each of the addresses that are saved against the account --->
										<cfloop array="#$.slatwall.getAccount().getAccountAddressesSmartList().getRecords()#" index="accountAddress">
											<cfset accountAddressIndex++ />

											<div class="col-md-4">
												<!--- Display an address block --->
												<div class="thumbnail">
													<!--- Display Address --->
													<div class="aa#accountAddressIndex#<cfif accountAddress.hasErrors()> hide</cfif>">
														<!--- Administration options --->
														<div class="pull-right">
															<a href="##" onClick="editToggle('.aa#accountAddressIndex#'); return false;" title="Edit Address"><span class="glyphicon glyphicon-pencil"></span></a>
															<a href="?slatAction=public:account.deleteAccountAddress&accountAddressID=#accountAddress.getAccountAddressID()#" title="Delete Address"><span class="glyphicon glyphicon-trash"></span></a>
															<!--- If this is the primary address, then just show the astricks --->
															<cfif accountAddress.getAccountAddressID() eq $.slatwall.getAccount().getPrimaryAddress().getAccountAddressID()>
																<span class="glyphicon glyphicon-asterisk" title="This is the primary address for your account"></span>
															<!--- Otherwise add buttons to be able to delete the address, or make it the primary --->
															<cfelse>
																<a href="?slatAction=public:account.update&primaryAddress.accountAddressID=#accountAddress.getAccountAddressID()#" title="Set this as your primary phone address"><span class="glyphicon glyphicon-asterisk"></span></a>
															</cfif>
														</div>

														<!--- Address Nickname if it exists --->
														<cfif not isNull(accountAddress.getAccountAddressName())>
															<strong>#htmlEditFormat( accountAddress.getAccountAddressName() )#</strong>
														</cfif>

														<!--- Actual Address Details --->
														<sw:AddressDisplay address="#accountAddress.getAddress()#" />
													</div>

													<!--- Edit Address --->
													<div class="aa#accountAddressIndex#<cfif not accountAddress.hasErrors()> hide</cfif>">
														<!--- Start: Edit Address Form --->
														<form action="?s=1" method="post">
															<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
															<input type="hidden" name="slatAction" value="public:account.update" />
															<input type="hidden" name="accountAddresses[1].accountAddressID" value="#accountAddress.getAccountAddressID()#" />

															<!--- Nickname --->
															<div class="form-group">
										    					<label for="accountAddressName">Nickname</label>
																<sw:FormField type="text" name="accountAddresses[1].accountAddressName" valueObject="#accountAddress#" valueObjectProperty="accountAddressName" class="form-control" />
																<sw:ErrorDisplay object="#accountAddress#" errorName="accountAddressName" />
										  					</div>

															<!--- Address --->
															<sw:AddressForm address="#accountAddress.getAddress()#" fieldNamePrefix="accountAddresses[1].address." fieldClass="form-control" />

															<!--- Update Button --->
															<div class="form-group">
									      						<button type="submit" class="btn btn-primary">Save</button>
																<button type="button" class="btn btn-default" onClick="editToggle('.aa#accountAddressIndex#'); return false;">Cancel</button>
										  					</div>
														</form>
														<!--- End: Edit Address Form --->
													</div>
												</div>
											</div>
										</cfloop>

										<!--- Start: New Address --->
										<div class="col-md-4">
											<!--- get the newPropertyEntity for accountAddress --->
											<cfset newAccountAddress = $.slatwall.getAccount().getNewPropertyEntity( 'accountAddresses' ) />

											<a class="btn btn-primary" role="button" data-toggle="collapse" href="##add-account-address" aria-expanded="false" aria-controls="add-account-address">
												<span class="glyphicon glyphicon-plus"></span> Add Account Address
											</a>
										</div>

										<div class="clearfix"></div>
										<div class="col-md-12">
											<!--- This is the accordian details when expanded --->
											<div class="collapse<cfif newAccountAddress.hasErrors()> in</cfif>" id="add-account-address">
												<div class="well">
													<!--- Start: New Address Form --->
													<form action="?s=1" method="post">
														<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
														<input type="hidden" name="slatAction" value="public:account.update" />

														<!--- Set the accountAddressID to blank so tha it creates a new one --->
														<input type="hidden" name="accountAddresses[1].accountAddressID" value="" />

														<!--- Nickname --->
														<div class="form-group">
									    					<label for="accountAddresses[1].accountAddressName">Nickname</label>
															<sw:FormField type="text" name="accountAddresses[1].accountAddressName" valueObject="#newAccountAddress#" valueObjectProperty="accountAddressName" class="form-control" />
															<sw:ErrorDisplay object="#newAccountAddress#" errorName="accountAddressName" />
									  					</div>

														<!--- New Address --->
														<sw:AddressForm id="newAccountAddress" address="#newAccountAddress.getAddress()#" fieldNamePrefix="accountAddresses[1].address." fieldClass="form-control" />

														<!--- Add Button --->
														<div class="form-group">
									      					<button type="submit" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> Add Address</button>
									  					</div>
													</form>
													<!--- End: New Address Form --->
												</div>
											</div>
										</div>
										<!--- End: New Address --->
										<!--- END: ADDRESS BOOK --->

										<br />

										<!--- START: PAYMENT METHODS --->
										<h4>Payment Methods</h4>

										<!--- Start: Redeem Gift Card Form --->
										<form action="?s=1" method="post">
											<input type="hidden" name="slatAction" value="public:giftCard.redeemToAccount" />
											<div class="form-group">
												<cfset newGiftCardAcountPaymentMethod = $.slatwall.getAccount().getNewPropertyEntity( 'accountPaymentMethods' ) />

				    							<div class="input-group">
				    								<sw:FormField type="text" name="giftCardCode" valueObject="#newGiftCardAcountPaymentMethod#" valueObjectProperty="giftCardCode" fieldAttributes='placeholder="Redeem a Gift Card"' class="form-control" />
				    								<span class="input-group-btn">
														<button type="submit" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span></button>
				    								</span>
												</div>

												<sw:ErrorDisplay object="#newGiftCardAcountPaymentMethod#" errorName="giftCardCode" />
						  					</div>
										</form>

										<hr style="margin-top:10px;border-top-color:##ddd;" />

										<cfset accountPaymentMethodIndex = 0 />

										<!--- Loop over each of the addresses that are saved against the account --->
										<cfloop array="#$.slatwall.getAccount().getAccountPaymentMethodsSmartList().getRecords()#" index="accountPaymentMethod">
											<cfset accountPaymentMethodIndex++ />

											<div class="col-md-4">
												<!--- Display payment method block --->
												<div class="thumbnail">
													<!--- Display Payment Method --->
													<div class="apm#accountPaymentMethodIndex#<cfif accountPaymentMethod.hasErrors()> hide</cfif>">
														<!--- Administration options --->
														<div class="pull-right">
															<a href="##" onClick="editToggle('.apm#accountPaymentMethodIndex#'); return false;" title="Edit Payment Method"><span class="glyphicon glyphicon-pencil"></span></a>
															<a href="?slatAction=public:account.deleteAccountPaymentMethod&accountPaymentMethodID=#accountPaymentMethod.getAccountPaymentMethodID()#" title="Delete Payment Method"><span class="glyphicon glyphicon-trash"></span></a>
															<!--- If this is the primary address, then just show the astricks --->
															<cfif accountPaymentMethod.getAccountPaymentMethodID() eq $.slatwall.getAccount().getPrimaryPaymentMethod().getAccountPaymentMethodID()>
																<span class="glyphicon glyphicon-asterisk" title="This is the primary address for your account"></span>

															<cfelse>

																<!--- Otherwise add buttons to be able to delete the address, or make it the primary --->
																<a href="?slatAction=public:account.update&primaryPaymentMethod.accountPaymentMethodID=#accountPaymentMethod.getAccountPaymentMethodID()#" title="Set this as your primary phone address"><span class="glyphicon glyphicon-asterisk"></span></a>
															</cfif>
														</div>

														<strong>#accountPaymentMethod.getPaymentMethod().getPaymentMethodName()# <cfif not isNull(accountPaymentMethod.getAccountPaymentMethodName()) and len(accountPaymentMethod.getAccountPaymentMethodName())>- #accountPaymentMethod.getAccountPaymentMethodName()#</cfif></strong><br />

														<!--- Credit Card Display --->
														<cfif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "creditCard">
															#accountPaymentMethod.getCreditCardType()# - #accountPaymentMethod.getCreditCardLastFour()#<br>
															#htmlEditFormat( accountPaymentMethod.getNameOnCreditCard() )#<br>
															#htmlEditFormat( accountPaymentMethod.getExpirationMonth() )# / #htmlEditFormat( accountPaymentMethod.getExpirationYear() )#<br>
															#accountPaymentMethod.getBillingAddress().getSimpleRepresentation()#

														<!--- External Display --->
														<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "external">

														<!--- Gift Card Display --->
														<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "giftCard">

															#accountPaymentMethod.getGiftCardBalanceAmountFormatted()#

														<!--- Term Payment Display --->
														<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "termPayment">

														</cfif>
													</div>

													<!--- Edit Payment Method --->
													<div class="apm#accountPaymentMethodIndex#<cfif not accountPaymentMethod.hasErrors()> hide</cfif>">
														<!--- Start: Edit Payment Method Form --->
														<form action="?s=1" method="post">
															<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
															<input type="hidden" name="slatAction" value="public:account.update" />

															<!--- Set the accountAddressID to blank so tha it creates a new one --->
															<input type="hidden" name="accountPaymentMethods[1].accountPaymentMethodID" value="#accountPaymentMethod.getAccountPaymentMethodID()#" />

															<!--- Nickname --->
															<div class="form-group">
										    					<label for="accountPaymentMethodName">Nickname</label>
																<sw:FormField type="text" name="accountPaymentMethods[1].accountPaymentMethodName" valueObject="#accountPaymentMethod#" valueObjectProperty="accountPaymentMethodName" class="form-control" />
																<sw:ErrorDisplay object="#accountPaymentMethod#" errorName="accountPaymentMethodName" />
										  					</div>

															<!--- Credit Card --->
															<cfif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "creditCard">
																<!--- Credit Card Number --->
																<div class="form-group">
											    					<label for="accountPaymentMethods[1].creditCardNumber">Credit Card Number</label>
																	<sw:FormField type="text" name="accountPaymentMethods[1].creditCardNumber" valueObject="#accountPaymentMethod#" valueObjectProperty="creditCardNumber" class="form-control" />
																	<sw:ErrorDisplay object="#accountPaymentMethod#" errorName="creditCardNumber" />
											  					</div>

																<!--- Name on Credit Card --->
																<div class="form-group">
											    					<label for="accountPaymentMethods[1].nameOnCreditCard">Name on Credit Card</label>
																	<sw:FormField type="text" name="accountPaymentMethods[1].nameOnCreditCard" valueObject="#accountPaymentMethod#" valueObjectProperty="nameOnCreditCard" class="form-control" />
																	<sw:ErrorDisplay object="#accountPaymentMethod#" errorName="nameOnCreditCard" />
											  					</div>

																<!--- Security & Expiration Row --->
																<div class="row">
																	<div class="col-md-4">
																		<!--- Security Code --->
																		<div class="form-group">
													    					<label for="accountPaymentMethods[1].securityCode">CVV</label>
																			<sw:FormField type="text" name="accountPaymentMethods[1].securityCode" valueObject="#accountPaymentMethod#" valueObjectProperty="securityCode" class="form-control" />
																			<sw:ErrorDisplay object="#accountPaymentMethod#" errorName="securityCode" />
													  					</div>
																	</div>

																	<div class="col-md-8">
																		<!--- Expiration --->
																		<div class="form-group">
													    					<div class="col-md-12"><label class="pull-right" for="accountPaymentMethods[1].expirationMonth">Exp. (MM/YYYY)</label></div>
													    					<div class="col-md-6">
																				<sw:FormField type="select" name="accountPaymentMethods[1].expirationMonth" valueObject="#accountPaymentMethod#" valueObjectProperty="expirationMonth" valueOptions="#accountPaymentMethod.getExpirationMonthOptions()#" class="form-control" />
													    					</div>
													    					<div class="col-md-6">
																				<sw:FormField type="select" name="accountPaymentMethods[1].expirationYear" valueObject="#accountPaymentMethod#" valueObjectProperty="expirationYear" valueOptions="#accountPaymentMethod.getExpirationYearOptions()#" class="form-control" />
																				<sw:ErrorDisplay object="#accountPaymentMethod#" errorName="expirationMonth" />
																				<sw:ErrorDisplay object="#accountPaymentMethod#" errorName="expirationYear" />
													    					</div>
													  					</div>
																	</div>
																</div>

																<hr />
																<h4>Address on Card</h4>

																<!--- Billing Address --->
																<sw:AddressForm id="newBillingAddress" address="#accountPaymentMethod.getBillingAddress()#" fieldNamePrefix="accountPaymentMethods[1].billingAddress." fieldClass="form-control" />
															<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "external">

															<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "giftCard">

																<!--- Gift Card Number --->
																<div class="form-group">
											    					<label for="accountPaymentMethods[1].giftCardNumber">Gift Card Number</label>
																	<sw:FormField type="text" name="accountPaymentMethods[1].giftCardNumber" valueObject="#accountPaymentMethod#" valueObjectProperty="giftCardNumber" class="form-control" />
																	<sw:ErrorDisplay object="#accountPaymentMethod#" errorName="giftCardNumber" />
											  					</div>

															<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "termPayment">
																<hr />
																<h4>Billing Address</h4>

																<!--- Billing Address --->
																<sw:AddressForm id="newBillingAddress" address="#accountPaymentMethod.getBillingAddress()#" fieldNamePrefix="accountPaymentMethods[1].billingAddress." fieldClass="form-control" />
															</cfif>

															<!--- Update Button --->
															<div class="form-group">
																<button type="button" class="btn btn-default" onClick="editToggle('.apm#accountPaymentMethodIndex#'); return false;">Cancel</button>
									      						<button type="submit" class="btn btn-primary">Save</button>
										  					</div>
														</form>
														<!--- End: Edit Payment Method Form --->
													</div>
												</div>
											</div>
										</cfloop>

										<!--- Start: New Payment Method --->
										<!--- get the newPropertyEntity for accountPaymentMethod --->
										<cfset newAccountPaymentMethod = $.slatwall.getAccount().getNewPropertyEntity('accountPaymentMethods') />

										<!--- verify that there are payment methods that can be saved --->
										<cfif arrayLen($.slatwall.getAccount().getSaveablePaymentMethodsSmartList().getRecords())>
											<!--- Loop over all of the potential payment methods that can be saved --->
											<cfloop array="#$.slatwall.getAccount().getSaveablePaymentMethodsSmartList().getRecords()#" index="paymentMethod">
												<cfset pmID = "pm#lcase(createUUID())#" />

												<div class="col-md-4">
													<a class="btn btn-primary" role="button" data-toggle="collapse" href="###pmID#" aria-expanded="false" aria-controls="#pmID#">
														<span class="glyphicon glyphicon-plus"></span> Add #paymentMethod.getPaymentMethodName()#
													</a>
												</div>

												<div class="clearfix"></div>
												<div class="col-md-12">
													<!--- This is the accordian details when expanded --->
													<div class="collapse<cfif newAccountPaymentMethod.hasErrors() and not isNull(newAccountPaymentMethod.getPaymentMethod()) and newAccountPaymentMethod.getPaymentMethod().getPaymentMethodID() eq paymentMethod.getPaymentMethodID()> in</cfif>" id="#pmID#">
														<div class="well">
															<!--- Start: New Payment Method Form --->
															<form action="?s=1" method="post">
																<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
																<input type="hidden" name="slatAction" value="public:account.addaccountpaymentmethod" />
																<!--- Set the accountAddressID to blank so tha it creates a new one --->
																<input type="hidden" name="accountPaymentMethodID" value="" />
																<input type="hidden" name="paymentMethod.paymentMethodID" value="#paymentMethod.getPaymentMethodID()#" />

																<!--- Nickname --->
																<div class="form-group">
											    					<label for="accountPaymentMethodName">Nickname</label>
																	<sw:FormField type="text" name="accountPaymentMethodName" valueObject="#newAccountPaymentMethod#" valueObjectProperty="accountPaymentMethodName" class="form-control" />
																	<sw:ErrorDisplay object="#newAccountPaymentMethod#" errorName="accountPaymentMethodName" />
											  					</div>

																<!--- Credit Card --->
																<cfif paymentMethod.getPaymentMethodType() eq "creditCard">
																	<!--- Credit Card Number --->
																	<div class="form-group">
												    					<label for="creditCardNumber">Credit Card Number</label>
																		<sw:FormField type="text" name="creditCardNumber" valueObject="#newAccountPaymentMethod#" valueObjectProperty="creditCardNumber" class="form-control" />
																		<sw:ErrorDisplay object="#newAccountPaymentMethod#" errorName="creditCardNumber" />
												  					</div>

																	<!--- Name on Credit Card --->
																	<div class="form-group">
												    					<label for="nameOnCreditCard">Name on Credit Card</label>
																		<sw:FormField type="text" name="nameOnCreditCard" valueObject="#newAccountPaymentMethod#" valueObjectProperty="nameOnCreditCard" class="form-control" />
																		<sw:ErrorDisplay object="#newAccountPaymentMethod#" errorName="nameOnCreditCard" />
												  					</div>

																	<!--- Security & Expiration Row --->
																	<div class="row">
																		<div class="col-md-4">
																			<!--- Security Code --->
																			<div class="form-group">
														    					<label for="securityCode">CVV</label>
																				<sw:FormField type="text" name="securityCode" valueObject="#newAccountPaymentMethod#" valueObjectProperty="securityCode" class="form-control" />
																				<sw:ErrorDisplay object="#newAccountPaymentMethod#" errorName="securityCode" />
														  					</div>
																		</div>

																		<div class="col-md-8">
																			<!--- Expiration --->
																			<div class="form-group">
														    					<div class="col-md-12"><label class="pull-right" for="expirationMonth">Exp. (MM/YYYY)</label></div>
														    					<div class="col-md-6">
																					<sw:FormField type="select" name="expirationMonth" valueObject="#newAccountPaymentMethod#" valueObjectProperty="expirationMonth" valueOptions="#newAccountPaymentMethod.getExpirationMonthOptions()#" class="form-control" />
														    					</div>
														    					<div class="col-md-6">
																					<sw:FormField type="select" name="expirationYear" valueObject="#newAccountPaymentMethod#" valueObjectProperty="expirationYear" valueOptions="#newAccountPaymentMethod.getExpirationYearOptions()#" class="form-control" />
																					<sw:ErrorDisplay object="#newAccountPaymentMethod#" errorName="expirationMonth" />
																					<sw:ErrorDisplay object="#newAccountPaymentMethod#" errorName="expirationYear" />
														    					</div>
														  					</div>
																		</div>
																	</div>

																	<hr />
																	<h4>Address on Card</h4>

																	<!--- Billing Address --->
																	<sw:AddressForm id="newBillingAddress" address="#newAccountPaymentMethod.getBillingAddress()#" fieldNamePrefix="billingAddress." fieldClass="form-control" />
																<cfelseif paymentMethod.getPaymentMethodType() eq "external">

	 															<cfelseif paymentMethod.getPaymentMethodType() eq "giftCard">

																	<!--- Gift Card Number --->
																	<div class="form-group">
												    					<label for="giftCardNumber">Gift Card Number</label>
																		<sw:FormField type="text" name="giftCardNumber" valueObject="#newAccountPaymentMethod#" valueObjectProperty="giftCardNumber" class="form-control" />
																		<sw:ErrorDisplay object="#newAccountPaymentMethod#" errorName="giftCardNumber" />
												  					</div>

																<cfelseif paymentMethod.getPaymentMethodType() eq "termPayment">
																	<hr />
																	<h4>Billing Address</h4>

																	<!--- Billing Address --->
																	<sw:AddressForm id="newBillingAddress" address="#newAccountPaymentMethod.getBillingAddress()#" fieldNamePrefix="billingAddress." fieldClass="form-control" />
																</cfif>

																<!--- Update Button --->
																<div class="form-group">
											      					<button type="submit" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> Add Payment Method</button>
											  					</div>
															</form>
															<!--- End: New Payment Method Form --->
														</div>
													</div>
												</div>
											</cfloop>
										</cfif>
										<!--- End: New Payment Method --->
										<!--- END: PAYMENT METHODS --->
									</div>
									<!--- End: Right Side Contact & Payment Methods --->
								</div>
							</div>

							<!--- ================== ORDER HISTORY TAB ================== --->
							<div role="tabpanel" class="tab-pane" id="orders">
								<h4>Order History</h4>

								<!--- Setup an accordian view for existing orders --->
								<div class="panel-group" id="order-history-acc" role="tablist" aria-multiselectable="true">

									<!--- Loop over all of the orders that this account has placed --->
									<cfloop array="#$.slatwall.account().getOrdersPlacedSmartList().getRecords()#" index="order">
									  	<!--- create a DOM ID to be used for open and closing --->
									  	<cfset orderDOMID = "oid#order.getOrderID()#" />

										<div class="panel panel-default">
											<div class="panel-heading" role="tab" id="heading#orderDOMID#">
												<h4 class="panel-title">
													<a role="button" data-toggle="collapse" data-parent="##order-history-acc" href="##collapse#orderDOMID#" aria-expanded="true" aria-controls="collapse#orderDOMID#">
														Order ## #order.getOrderNumber()# &nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;&nbsp; #order.getFormattedValue('orderOpenDateTime', 'date' )# &nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;&nbsp; #order.getFormattedValue('total')# <span class="pull-right">Status: #order.getOrderStatusType().getType()#</span>
													</a>
												</h4>
											</div>
											<!--- This is the accordian details when expanded --->
											<div id="collapse#orderDOMID#" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading#orderDOMID#">
												<div class="panel-body">
													<h4>Overview & Status</h4>
													<div class="row">
														<div class="col-md-4">
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
													<h4>Order Payments</h4>
													<table class="table table-bordered table-condensed table-striped">
														<tr>
															<th>Payment Details</td>
															<th>Amount</td>
														</tr>
														<cfloop array="#order.getOrderPayments()#" index="orderPayment">
															<cfif orderPayment.getOrderPaymentStatusType().getSystemCode() EQ "opstActive">
																<tr>
																	<td>#orderPayment.getSimpleRepresentation()#</td>
																	<td>#orderPayment.getFormattedValue('amount')#</td>
																</tr>
															</cfif>
														</cfloop>
													</table>
													<!--- End: Order Payments --->

													<!--- Start: Order Deliveries --->
													<cfif arrayLen(order.getOrderDeliveries())>
														<hr style="border-top-style:dashed !important; border-top-width:5px !important;" />
														<h4>Order Deliveries</h4>

														<cfloop array="#order.getOrderDeliveries()#" index="orderDelivery">
															<table class="table table-bordered table-condensed">
																<tr>
																	<!--- Delivery Details --->
																	<td class="well col-md-3" rowspan="#arrayLen(orderDelivery.getOrderDeliveryItems()) + 1#">
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
																			<sw:AddressDisplay address="#orderDelivery.getShippingAddress()#" />
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
												</div> <!--- END: panel-body --->
											</div> <!--- END: panel-collapse --->
										</div> <!--- END: panel --->
									</cfloop>
								</div>
							</div>

							<!--- =================== CARTS & QUOTES ===================== --->
							<div role="tabpanel" class="tab-pane" id="carts-and-quotes">
								<h4>Shopping Carts & Quotes</h4>

								<div class="panel-group" id="cart-and-quotes-acc" role="tablist" aria-multiselectable="true">

									<cfset $.slatwall.account().getOrdersNotPlacedSmartList().addOrder('createdDateTime|DESC') />

									<!--- Loop over all of the 'notPlaced' orders --->
									<cfloop array="#$.slatwall.account().getOrdersNotPlacedSmartList().getRecords()#" index="order">
										<!--- Setup an orderID for the accordion --->
										<cfset orderDOMID = "oid#order.getOrderID()#" />

										<div class="panel panel-default">
											<div class="panel-heading" role="tab" id="heading#orderDOMID#">
												<h4 class="panel-title">
													<a role="button" data-toggle="collapse" data-parent="##cart-and-quotes-acc" href="##collapse#orderDOMID#" aria-expanded="true" aria-controls="collapse#orderDOMID#">
														#order.getFormattedValue('createdDateTime', 'date')# <cfif order.getOrderID() eq $.slatwall.cart().getOrderID()><span class="glyphicon glyphicon-shopping-cart pull-right"></span></cfif>
													</a>
												</h4>
											</div>
											<!--- This is the accordian details when expanded --->
											<div id="collapse#orderDOMID#" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading#orderDOMID#">
												<div class="panel-body">
													<h4>Overview & Status</h4>
													<div class="row">
														<div class="col-md-4">
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
														<div class="col-md-4 pull-right">
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
													<h4>Cart Items</h4>
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
																	<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup">
																		<strong>Pickup Location:</strong> #orderFulfillment.getPickupLocation().getLocationName()#<br />
																		<sw:AddressDisplay address="#orderFulfillment.getPickupLocation().getPrimaryAddress().getAddress()#" />

																	<!--- Fulfillment Details: Shipping --->
																	<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
																		<cfif not orderFulfillment.getAddress().getNewFlag()>
																			<sw:AddressDisplay address="#orderFulfillment.getAddress()#" />
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
															<div class="col-md-3 pull-right">
																<div class="btn-group pull-right">
																	<a class="btn" href="?slatAction=public:cart.change&orderID=#order.getOrderID()#"><span class="glyphicon glyphicon-shopping-cart"></span> Swap to this Cart</a>
																	<a class="btn" href="?slatAction=public:cart.delete&orderID=#order.getOrderID()#"><span class="glyphicon glyphicon-trash"></span> Delete</a>
																</div>
															</div>
														</div>
													</cfif>
												</div> <!--- END: panel-body --->
											</div> <!--- END: panel-collapse --->
										</div> <!--- END: panel --->
									</cfloop>
			 					</div>
							</div>

							<!--- ==================== SUBSCRIPTIONS ==================== --->
							<div role="tabpanel" class="tab-pane" id="subscriptions">
								<h4>Subscription Management</h4>

								<div class="panel-group" id="subscription-acc" role="tablist" aria-multiselectable="true">

									<!--- Loop over all of the subscription usages for this account --->
									<cfloop array="#$.slatwall.getAccount().getSubscriptionUsages()#" index="subscriptionUsage">
										<!--- Setup an orderID for the accordion --->
										<cfset subscriptionDOMID = "suid#subscriptionUsage.getSubscriptionUsageID()#" />

										<div class="panel panel-default">
											<div class="panel-heading" role="tab" id="heading#subscriptionDOMID#">
												<h4 class="panel-title">
													<a role="button" data-toggle="collapse" data-parent="##subscription-acc" href="##collapse#subscriptionDOMID#" aria-expanded="true" aria-controls="collapse#subscriptionDOMID#">
														#subscriptionUsage.getSubscriptionOrderItemName()#<span class="pull-right">Status: #subscriptionUsage.getCurrentStatusType()#</span></a>
													</a>
												</h4>
											</div>
											<!--- This is the accordian details when expanded --->
											<div id="collapse#subscriptionDOMID#" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading#subscriptionDOMID#">
												<div class="panel-body">
													<div class="row">
														<div class="col-md-7">
															<h4>Status</h4>

															<table class="table table-bordered table-condensed">
																<tr>
																	<td>Auto Renew</td>
																	<td>#subscriptionUsage.getFormattedValue('autoRenewFlag')#</td>
																</tr>
																<cfif subscriptionUsage.getAutoRenewFlag()>
																	<tr>
																		<td>Auto Pay</td>
																		<td>#subscriptionUsage.getFormattedValue('autoPayFlag')#</td>
																	</tr>
																	<tr>
																		<td>Next Bill Date</td>
																		<td>#subscriptionUsage.getFormattedValue('nextBillDate')#</td>
																	</tr>
																</cfif>
																<tr>
																	<td>Expiration Date</td>
																	<td>#subscriptionUsage.getFormattedValue('expirationDate')#</td>
																</tr>
															</table>
														</div>

														<div class="col-md-4 pull-right">
															<h4>Renew</h4>

															<div class="well">
																<form action="?s=1" method="post">
																	<!--- Hidden slatAction to update the account --->
																	<input type="hidden" name="slatAction" value="public:account.renewSubscriptionUsage" />
																	<input type="hidden" name="subscriptionUsageID" value="#subscriptionUsage.getSubscriptionUsageID()#" />

																	<strong>Price</strong><br />#subscriptionUsage.getFormattedValue('renewalPrice')#<br /><br />
																	<strong>New Expiration Date</strong><br />#subscriptionUsage.getProcessObject('renew').getFormattedValue('extendExpirationDate')#<br /><br />

																	<!--- Update --->
																	<div class="form-group">
												      					<button class="btn btn-primary">Renew Now</button>
												  					</div>
																</form>
															</div>

															<cfif subscriptionUsage.getAutoRenewFlag() and subscriptionUsage.getAutoPayFlag()>
																<h4>Auto-Pay Settings</h4>

																<div class="well">
																	<form action="?s=1" method="post">
																		<!--- Hidden slatAction to update the account --->
																		<input type="hidden" name="slatAction" value="public:account.updateSubscriptionUsage" />
																		<input type="hidden" name="subscriptionUsageID" value="#subscriptionUsage.getSubscriptionUsageID()#" />

																		<!--- Auto Pay Account Payment Method --->
																		<div class="form-group">
																			<label for="accountPaymentMethod.accountPaymentMethodID">Payment Method</label>
											    								<sw:FormField type="select" name="accountPaymentMethod.accountPaymentMethodID" value="#subscriptionUsage.getAccountPaymentMethodID()#" valueOptions="#subscriptionUsage.getAccountPaymentMethodOptions()#" />
																				<sw:ErrorDisplay object="#subscriptionUsage#" errorName="accountPaymentMethod" />
													  					</div>

																		<!--- Update --->
																		<div class="form-group">
													      					<button class="btn btn-primary">Update Payment Method</button>
													  					</div>
																	</form>
																</div>
															</cfif>
														</div>
													</div>
												</div> <!--- END: panel-body --->
											</div> <!--- END: panel-collapse --->
										</div> <!--- END: panel --->
									</cfloop>
			 					</div>
							</div>

							<!--- ==================== PURCHASED CONTENT ==================== --->
							<div role="tabpanel" class="tab-pane" id="purchased-content">
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

		<!--- RESET PASSWORD --->
		<cfelseif structKeyExists(url, "swprid") and len(url.swprid) eq 64>
			<div class="row">
				<div class="col-md-12">
					<h2>My Account</h2>
				</div>
			</div>

			<div class="row">
				<!--- Reset Password --->
				<div class="col-md-6">
					<h5>Reset Password</h5>

					<!--- If this item was just added show the success message --->
					<cfif $.slatwall.hasSuccessfulAction( "public:account.resetPassword" )>
						<div class="alert alert-success">
							Your account's password has been reset.
						</div>
					<!--- If this item was just tried to be added, but failed then show the failure message --->
					<cfelseif $.slatwall.hasFailureAction( "public:account.resetPassword" )>
						<div class="alert alert-error">
							There was an error trying to reset your password.
						</div>
					</cfif>

					<cfset resetPasswordObj = $.slatwall.getAccount().getProcessObject('resetPassword') />

					<form action="?s=1&swprid=#url.swprid#" method="post">
						<input type="hidden" name="slatAction" value="public:account.resetPassword,public:account.login" />
						<input type="hidden" name="accountID" value="#left(url.swprid, 32)#" />

						<!--- New Password --->
						<div class="form-group">
	    					<label for="password">New Password</label>
							<sw:FormField type="password" valueObject="#resetPasswordObj#" valueObjectProperty="password" class="form-control" />
							<sw:ErrorDisplay object="#resetPasswordObj#" errorName="password" />
	  					</div>

						<!--- Confirm Password --->
						<div class="form-group">
	    					<label for="passwordConfirm">Confirm Password</label>
							<sw:FormField type="password" valueObject="#resetPasswordObj#" valueObjectProperty="passwordConfirm" class="form-control" />
							<sw:ErrorDisplay object="#resetPasswordObj#" errorName="passwordConfirm" />
	  					</div>

						<!--- Reset Button --->
						<div class="form-group">
	      					<button type="submit" class="btn btn-primary">Reset Password</button>
	  					</div>
					</form>
				</div>
			</div>

		<cfelse>

			<!--- CREATE / LOGIN FORMS --->
			<div class="row">
				<div class="col-md-12">
					<h2>My Account</h2>
				</div>
			</div>

			<div class="row">
				<!--- LOGIN --->
				<div class="col-md-6">
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

					<cfif $.slatwall.hasSuccessfulAction( "public:account.forgotPassword" )>
						<div class="alert alert-success">
							An email has been sent to the address you provided with a link to reset your password.
						</div>
					</cfif>

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
				<div class="col-md-6">
					<h4>Create New Account</h4>

					<!--- Sets up the create account processObject --->
					<cfset createAccountObj = $.slatwall.account().getProcessObject('create') />

					<!--- Create Account Form --->
					<form action="?s=1" method="post">
						<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
						<input type="hidden" name="slatAction" value="public:account.create,public:account.login" />

						<!--- This is passed so that we force the creation of a password and this isn't just a guest checkout --->
						<input type="hidden" name="createAuthenticationFlag" value="1" />

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

						<!--- Password --->
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

						<!--- Create Button --->
						<div class="control-group pull-right">
	      					<button type="submit" class="btn btn-primary">Create Account & Continue</button>
	  					</div>
					</form>
					<!--- End: Create Account Form --->
				</div>
			</div>
		</cfif>
	</div>
</cfoutput>

<cfinclude template="_slatwall-footer.cfm" />