<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />

<cfoutput>
    <article>
		<div class="col-12" id="subscription-acc">
			<!--- Loop over all of the subscription usages for this account --->
			<cfloop array="#$.slatwall.getAccount().getSubscriptionUsages()#" index="subscriptionUsage">
				<!--- Setup an orderID for the accordion --->
				<cfset subscriptionDOMID = "suid#subscriptionUsage.getSubscriptionUsageID()#" />
				<!---<cfdump var="#subscriptionUsage#" top=3>--->
				<div class="row mb-2">
					<!--- Main Button to expand order --->
					<h3>#subscriptionUsage.getSubscriptionOrderItemName()#</h3>
					<!--- Saved order content --->
					<div id="#subscriptionDOMID#" class="col-12">
						<div class="row mt-2">
							<div class="col-lg-6 col-md-12">
								<h5></h5>
								<table class="table table-condensed table-bordered table-striped table-responsive-sm">
									<tr>
										<td>Status</td>
										<td>#subscriptionUsage.getCurrentStatusType()#</td>
									</tr>
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
							<div class="col-lg-6 col-md-12">
								<div>
									<h5>Renew</h5>
									<form action="?s=1" method="post">
										<!--- Hidden slatAction to update the account --->
										<input type="hidden" name="slatAction" value="public:account.renewSubscriptionUsage" />
										<input type="hidden" name="subscriptionUsageID" value="#subscriptionUsage.getSubscriptionUsageID()#" />
										
										Price: <span class="pull-right">#subscriptionUsage.getFormattedValue('renewalPrice')#</span>
										<br><br>
										New Expiration Date: <span class="pull-right">#subscriptionUsage.getProcessObject('renew').getFormattedValue('extendExpirationDate')#</span>
																												
										<!--- Update --->
										<button class="btn btn-primary col-12 mt-1">Renew Now</button>
					    				
									</form>
								</div>
								<div class="mt-2">
									<cfif subscriptionUsage.getAutoRenewFlag() and subscriptionUsage.getAutoPayFlag()>
										<h5>Auto-Pay Settings</h5>
										<div>
											<form action="?s=1" method="post">
												<!--- Hidden slatAction to update the account --->
												<input type="hidden" name="slatAction" value="public:account.updateSubscriptionUsage" />
												<input type="hidden" name="subscriptionUsageID" value="#subscriptionUsage.getSubscriptionUsageID()#" />
												<!--- Auto Pay Account Payment Method --->
												<div>
													<label for="accountPaymentMethod.accountPaymentMethodID">Payment Method:</label>
							    					<sw:FormField class="pull-right" type="select" name="accountPaymentMethod.accountPaymentMethodID" value="#subscriptionUsage.getAccountPaymentMethodID()#" valueOptions="#subscriptionUsage.getAccountPaymentMethodOptions()#" />
													<sw:ErrorDisplay object="#subscriptionUsage#" errorName="accountPaymentMethod" />
												</div>
												<button class="btn btn-primary col-12 mt-1">Update Payment Method</button>
							    			</form>
							    		</div>
									</cfif>
								</div>
							</div>
						</div>
					</div>
				</div>
			</cfloop>
		</div>
	</article>
</cfoutput>