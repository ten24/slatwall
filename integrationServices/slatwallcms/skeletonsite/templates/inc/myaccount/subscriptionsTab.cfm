<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	<div class="tab-pane" id="subscriptions">
		<h5>Subscription Management</h5>
		
		<div class="accordion" id="subscription-acc">
			
			<!--- Loop over all of the subscription usages for this account --->
			<cfloop array="#$.slatwall.getAccount().getSubscriptionUsages()#" index="subscriptionUsage">
				
				<!--- Setup an orderID for the accordion --->
				<cfset subscriptionDOMID = "suid#subscriptionUsage.getSubscriptionUsageID()#" />
				
				<div class="accordion-group">
					
					<!--- Main Button to expand order --->
					<div class="accordion-heading">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="##subscription-acc" href="###subscriptionDOMID#">#subscriptionUsage.getSubscriptionOrderItemName()#<span class="pull-right">Status: #subscriptionUsage.getCurrentStatusType()#</span></a>
					</div>
					
					<!--- Saved order content --->
					<div id="#subscriptionDOMID#" class="accordion-body collapse">
						
						<div class="accordion-inner">
							
							<div class="row">
								
								<div class="span7">
									<h5>Status</h5>
									
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
								
								<div class="span4 pull-right">
									
									<h5>Renew</h5>
									
									<div class="well">
									
										<form action="?s=1" method="post">
												
											<!--- Hidden slatAction to update the account --->
											<input type="hidden" name="slatAction" value="public:account.renewSubscriptionUsage" />
											<input type="hidden" name="subscriptionUsageID" value="#subscriptionUsage.getSubscriptionUsageID()#" />
											
											<strong>Price</strong><br />#subscriptionUsage.getFormattedValue('renewalPrice')#<br /><br />
											<strong>New Expiration Date</strong><br />#subscriptionUsage.getProcessObject('renew').getFormattedValue('extendExpirationDate')#<br /><br />
																													
											<!--- Update --->
											<div class="control-group">
						    					<div class="controls">
						      						<button class="btn btn-primary">Renew Now</button>
						    					</div>
						  					</div>
											
										</form>
										
									</div>
									
									<cfif subscriptionUsage.getAutoRenewFlag() and subscriptionUsage.getAutoPayFlag()>
										<h5>Auto-Pay Settings</h5>
												
										<div class="well">

											<form action="?s=1" method="post">
												
												<!--- Hidden slatAction to update the account --->
												<input type="hidden" name="slatAction" value="public:account.updateSubscriptionUsage" />
												<input type="hidden" name="subscriptionUsageID" value="#subscriptionUsage.getSubscriptionUsageID()#" />
												
												<!--- Auto Pay Account Payment Method --->
												<div class="control-group">
													<label class="control-label" for="accountPaymentMethod.accountPaymentMethodID">Payment Method</label>
							    					<div class="controls">
							    						
					    								<sw:FormField type="select" name="accountPaymentMethod.accountPaymentMethodID" value="#subscriptionUsage.getAccountPaymentMethodID()#" valueOptions="#subscriptionUsage.getAccountPaymentMethodOptions()#" />
														<sw:ErrorDisplay object="#subscriptionUsage#" errorName="accountPaymentMethod" />
														
							    					</div>
							  					</div>
												
												<!--- Update --->
												<div class="control-group">
							    					<div class="controls">
							      						<button class="btn btn-primary">Update Payment Method</button>
							    					</div>
							  					</div>
											</form>

										</div>
									</cfif>
								</div>
								
							</div>
									
						</div> <!--- END: accordion-inner --->
						
					</div> <!--- END: accordion-body --->
						
				</div> <!--- END: accordion-group --->
					
			</cfloop>
			
 		</div>
			
	</div>
	
</cfoutput>