<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	<!--- START: PAYMENT METHODS --->
	<h5>Payment Methods</h5>
	
	<hr style="margin-top:10px;border-top-color:##ddd;" />
	
	<ul class="thumbnails">
		
		<cfset accountPaymentMethodIndex = 0 />
		
		<!--- Loop over each of the addresses that are saved against the account --->
		<cfloop array="#$.slatwall.getAccount().getAccountPaymentMethodsSmartList().getRecords()#" index="accountPaymentMethod">
			
			<cfset accountPaymentMethodIndex++ />
			
			<li class="span4">
				
				<!--- Display payment method block --->	
				<div class="thumbnail">

					<!--- Display Payment Method --->
					<div class="apm#accountPaymentMethodIndex#<cfif accountPaymentMethod.hasErrors()> hide</cfif>">
						
						<!--- Administration options --->
						<div class="pull-right">
						
							<span class="pull-right">
								
								<a href="##" onClick="$('.apm#accountPaymentMethodIndex#').toggle()" title="Edit Payment Method"><i class="icon-pencil"></i></a>
								<a href="?slatAction=public:account.deleteAccountPaymentMethod&accountPaymentMethodID=#accountPaymentMethod.getAccountPaymentMethodID()#" title="Delete Address"><i class="icon-trash"></i></a>
								<!--- If this is the primary address, then just show the astricks --->
								<cfif accountPaymentMethod.getAccountPaymentMethodID() eq $.slatwall.getAccount().getPrimaryPaymentMethod().getAccountPaymentMethodID()>
									<i class="icon-asterisk" title="This is the primary address for your account"></i>
								<!--- Otherwise add buttons to be able to delete the address, or make it the primary --->
								<cfelse>
									<a href="?slatAction=public:account.update&primaryPaymentMethod.accountPaymentMethodID=#accountPaymentMethod.getAccountPaymentMethodID()#" title="Set this as your primary phone address"><i class="icon-asterisk"></i></a>
								</cfif>
								
							</span>
						</div>
						
						<strong>#accountPaymentMethod.getPaymentMethod().getPaymentMethodName()# <cfif not isNull(accountPaymentMethod.getAccountPaymentMethodName()) and len(accountPaymentMethod.getAccountPaymentMethodName())>- #accountPaymentMethod.getAccountPaymentMethodName()#</cfif></strong><br />
						
						<!--- Credit Card Display --->
						<cfif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "creditCard">
							#accountPaymentMethod.getCreditCardType()# - #accountPaymentMethod.getCreditCardLastFour()#<br />
							#htmlEditFormat( accountPaymentMethod.getNameOnCreditCard() )#<br />
							#htmlEditFormat( accountPaymentMethod.getExpirationMonth() )# / #htmlEditFormat( accountPaymentMethod.getExpirationYear() )#<br />
							#accountPaymentMethod.getBillingAddress().getSimpleRepresentation()#
						
						<!--- External Display --->
						<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "external">
							
						<!--- Gift Card Display --->
						<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "giftCard">
						
						<!--- Term Payment Display --->
						<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "termPayment">
							
						</cfif>
						
					</div>
					
					<!--- Edit Payment Method --->
					<div class="apm#accountPaymentMethodIndex#<cfif not accountPaymentMethod.hasErrors()> hide</cfif>">
						
						<!--- Start: Edit Payment Method Form --->
						<form action="#paymentFormAction#" method="post">
							
							<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
							<input type="hidden" name="slatAction" value="public:account.update" />
							
							<!--- Set the accountAddressID to blank so tha it creates a new one --->
							<input type="hidden" name="accountPaymentMethods[1].accountPaymentMethodID" value="#accountPaymentMethod.getAccountPaymentMethodID()#" />
							
							<!--- Nickname --->
							<div class="control-group">
		    					<label class="control-label" for="firstName">Nickname</label>
		    					<div class="controls">
		    						
									<sw:FormField type="text" name="accountPaymentMethods[1].accountPaymentMethodName" valueObject="#accountPaymentMethod#" valueObjectProperty="accountPaymentMethodName" class="span3" />
									<sw:ErrorDisplay object="#accountPaymentMethod#" errorName="accountPaymentMethodName" />
									
		    					</div>
		  					</div>
							
							<!--- Credit Card --->
							<cfif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "creditCard">
								
								<!--- Credit Card Number --->
								<div class="control-group">
			    					<label class="control-label" for="firstName">Credit Card Number</label>
			    					<div class="controls">
			    						
										<sw:FormField type="text" name="accountPaymentMethods[1].creditCardNumber" valueObject="#accountPaymentMethod#" valueObjectProperty="creditCardNumber" class="span3" />
										<sw:ErrorDisplay object="#accountPaymentMethod#" errorName="creditCardNumber" />
										
			    					</div>
			  					</div>
								
								<!--- Name on Credit Card --->
								<div class="control-group">
			    					<label class="control-label" for="firstName">Name on Credit Card</label>
			    					<div class="controls">
			    						
										<sw:FormField type="text" name="accountPaymentMethods[1].nameOnCreditCard" valueObject="#accountPaymentMethod#" valueObjectProperty="nameOnCreditCard" class="span3" />
										<sw:ErrorDisplay object="#accountPaymentMethod#" errorName="nameOnCreditCard" />
										
			    					</div>
			  					</div>
								
								
								<!--- Security & Expiration Row --->
								<div class="row">
									
									<div class="span1">
										
										<!--- Security Code --->
										<div class="control-group">
					    					<label class="control-label" for="rating">CVV</label>
					    					<div class="controls">
					    						
												<sw:FormField type="text" name="accountPaymentMethods[1].securityCode" valueObject="#accountPaymentMethod#" valueObjectProperty="securityCode" class="span1" />
												<sw:ErrorDisplay object="#accountPaymentMethod#" errorName="securityCode" />
												
					    					</div>
					  					</div>
										
									</div>
									
									
									<div class="span2">
										
										<!--- Expiration --->	
										<div class="control-group">
					    					<label class="control-label pull-right" for="rating">Exp. (MM/YYYY)</label>
					    					<div class="controls pull-right">
					    						
												<sw:FormField type="select" name="accountPaymentMethods[1].expirationMonth" valueObject="#accountPaymentMethod#" valueObjectProperty="expirationMonth" valueOptions="#accountPaymentMethod.getExpirationMonthOptions()#" class="span1" />
												<sw:FormField type="select" name="accountPaymentMethods[1].expirationYear" valueObject="#accountPaymentMethod#" valueObjectProperty="expirationYear" valueOptions="#accountPaymentMethod.getExpirationYearOptions()#" class="span1" />
												<sw:ErrorDisplay object="#accountPaymentMethod#" errorName="expirationMonth" />
												<sw:ErrorDisplay object="#accountPaymentMethod#" errorName="expirationYear" />
												
					    					</div>
					  					</div>
										
									</div>
								</div>
								
								<hr />
								<h5>Address on Card</h5>
								
								<!--- Billing Address --->
								<sw:AddressForm id="newBillingAddress" address="#accountPaymentMethod.getBillingAddress()#" fieldNamePrefix="accountPaymentMethods[1].billingAddress." fieldClass="span3" />
							<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "external">
								
							<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "giftCard">
								
								<!--- Gift Card Number --->
								<div class="control-group">
			    					<label class="control-label" for="firstName">Gift Card Number</label>
			    					<div class="controls">
			    						
										<sw:FormField type="text" name="accountPaymentMethods[1].giftCardNumber" valueObject="#accountPaymentMethod#" valueObjectProperty="giftCardNumber" class="span3" />
										<sw:ErrorDisplay object="#accountPaymentMethod#" errorName="giftCardNumber" />
										
			    					</div>
			  					</div>
								
							<cfelseif accountPaymentMethod.getPaymentMethod().getPaymentMethodType() eq "termPayment">
								<hr />
								<h5>Billing Address</h5>
								
								<!--- Billing Address --->
								<sw:AddressForm id="newBillingAddress" address="#accountPaymentMethod.getBillingAddress()#" fieldNamePrefix="accountPaymentMethods[1].billingAddress." fieldClass="span3" />
							</cfif>
							
							
							<!--- Update Button --->
							<div class="control-group">
		    					<div class="controls">
		      						<button type="submit" class="btn btn-primary">Save</button>
									<button type="button" class="btn" onClick="$('.apm#accountPaymentMethodIndex#').toggle()">Cancel</button>
		    					</div>
		  					</div>
							
						</form>
						<!--- End: Edit Payment Method Form --->
							
					</div>
					
				</div>
				
			</li>
			
		</cfloop>
		
		<!--- Start: New Payment Method --->
			
		<!--- get the newPropertyEntity for accountPaymentMethod --->
		<cfset newAccountPaymentMethod = $.slatwall.getAccount().getNewPropertyEntity( 'accountPaymentMethods' ) />
		
		<!--- verify that there are payment methods that can be saved --->
		<cfif arrayLen($.slatwall.getAccount().getSaveablePaymentMethodsSmartList().getRecords())>
			<li class="span4">
				
				<div class="accordion" id="add-account-payment-method">
					
					<!--- Loop over all of the potential payment methods that can be saved --->
					<cfloop array="#$.slatwall.getAccount().getSaveablePaymentMethodsSmartList().getRecords()#" index="paymentMethod">
						
						<cfset pmID = "pm#lcase(createUUID())#" /> 
						
						<div class="accordion-group">
						
							<!--- This is the top accordian header row --->
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="##add-account-payment-method" href="###pmID#"><i class="icon-plus"></i>Add #paymentMethod.getPaymentMethodName()#</a>
							</div>
						
							<!--- This is the accordian details when expanded --->
							<div id="#pmID#" class="accordion-body collapse<cfif newAccountPaymentMethod.hasErrors() and not isNull(newAccountPaymentMethod.getPaymentMethod()) and newAccountPaymentMethod.getPaymentMethod().getPaymentMethodID() eq paymentMethod.getPaymentMethodID()> in</cfif>">
							
								<div class="accordion-inner">
									
									<!--- Start: New Payment Method Form --->
									<form action="?s=1" method="post">
										
										<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
										<input type="hidden" name="slatAction" value="public:account.addaccountpaymentmethod" />
										
										<!--- Set the accountAddressID to blank so tha it creates a new one --->
										<input type="hidden" name="accountPaymentMethodID" value="" />
										
										<input type="hidden" name="paymentMethod.paymentMethodID" value="#paymentMethod.getPaymentMethodID()#" />
										
										<!--- Nickname --->
										<div class="control-group">
					    					<label class="control-label" for="firstName">Nickname</label>
					    					<div class="controls">
					    						
												<sw:FormField type="text" name="accountPaymentMethodName" valueObject="#newAccountPaymentMethod#" valueObjectProperty="accountPaymentMethodName" class="span3" />
												<sw:ErrorDisplay object="#newAccountPaymentMethod#" errorName="accountPaymentMethodName" />
												
					    					</div>
					  					</div>
										
										<!--- Credit Card --->
										<cfif paymentMethod.getPaymentMethodType() eq "creditCard">
											
											<!--- Credit Card Number --->
											<div class="control-group">
						    					<label class="control-label" for="firstName">Credit Card Number</label>
						    					<div class="controls">
						    						
													<sw:FormField type="text" name="creditCardNumber" valueObject="#newAccountPaymentMethod#" valueObjectProperty="creditCardNumber" class="span3" />
													<sw:ErrorDisplay object="#newAccountPaymentMethod#" errorName="creditCardNumber" />
													
						    					</div>
						  					</div>
											
											<!--- Name on Credit Card --->
											<div class="control-group">
						    					<label class="control-label" for="firstName">Name on Credit Card</label>
						    					<div class="controls">
						    						
													<sw:FormField type="text" name="nameOnCreditCard" valueObject="#newAccountPaymentMethod#" valueObjectProperty="nameOnCreditCard" class="span3" />
													<sw:ErrorDisplay object="#newAccountPaymentMethod#" errorName="nameOnCreditCard" />
													
						    					</div>
						  					</div>
											
											
											<!--- Security & Expiration Row --->
											<div class="row">
												
												<div class="span1">
													
													<!--- Security Code --->
													<div class="control-group">
								    					<label class="control-label" for="rating">CVV</label>
								    					<div class="controls">
								    						
															<sw:FormField type="text" name="securityCode" valueObject="#newAccountPaymentMethod#" valueObjectProperty="securityCode" class="span1" />
															<sw:ErrorDisplay object="#newAccountPaymentMethod#" errorName="securityCode" />
															
								    					</div>
								  					</div>
													
												</div>
												
												
												<div class="span2">
													
													<!--- Expiration --->	
													<div class="control-group">
								    					<label class="control-label pull-right" for="rating">Exp. (MM/YYYY)</label>
								    					<div class="controls pull-right">
								    						
															<sw:FormField type="select" name="expirationMonth" valueObject="#newAccountPaymentMethod#" valueObjectProperty="expirationMonth" valueOptions="#newAccountPaymentMethod.getExpirationMonthOptions()#" class="span1" />
															<sw:FormField type="select" name="expirationYear" valueObject="#newAccountPaymentMethod#" valueObjectProperty="expirationYear" valueOptions="#newAccountPaymentMethod.getExpirationYearOptions()#" class="span1" />
															<sw:ErrorDisplay object="#newAccountPaymentMethod#" errorName="expirationMonth" />
															<sw:ErrorDisplay object="#newAccountPaymentMethod#" errorName="expirationYear" />
															
								    					</div>
								  					</div>
													
												</div>
											</div>
											
											<hr />
											<h5>Address on Card</h5>
											
											<!--- Billing Address --->
											<sw:AddressForm id="newBillingAddress" address="#newAccountPaymentMethod.getBillingAddress()#" fieldNamePrefix="billingAddress." fieldClass="span3" />
										<cfelseif paymentMethod.getPaymentMethodType() eq "external">
											
 										<cfelseif paymentMethod.getPaymentMethodType() eq "giftCard">
											
											<!--- Gift Card Number --->
											<div class="control-group">
						    					<label class="control-label" for="firstName">Gift Card Number</label>
						    					<div class="controls">
						    						
													<sw:FormField type="text" name="giftCardNumber" valueObject="#newAccountPaymentMethod#" valueObjectProperty="giftCardNumber" class="span3" />
													<sw:ErrorDisplay object="#newAccountPaymentMethod#" errorName="giftCardNumber" />
													
						    					</div>
						  					</div>
											
										<cfelseif paymentMethod.getPaymentMethodType() eq "termPayment">
											<hr />
											<h5>Billing Address</h5>
											
											<!--- Billing Address --->
											<sw:AddressForm id="newBillingAddress" address="#newAccountPaymentMethod.getBillingAddress()#" fieldNamePrefix="billingAddress." fieldClass="span3" />
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
</cfoutput>