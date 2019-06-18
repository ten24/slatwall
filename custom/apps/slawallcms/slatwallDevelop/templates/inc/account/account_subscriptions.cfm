<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	<article>
		<div class="pt-1 pb-5">
			<h4 class="float-left">Total Subscriptions: #arraylen($.slatwall.getAccount().getSubscriptionUsages())#</h4>
			<a href="javascript:window.print();" class="btn btn-primary float-right"><i class="fa fa-print"></i> Print Subscription List</a>
		</div>
		<cfif arraylen($.slatwall.getAccount().getSubscriptionUsages())>
			<table class="table table-condensed table-bordered table-striped table-responsive-sm">
				<thead>
					<th>
						<strong>Subscription Name</strong>
					</th>
					<th>
						<strong>Status</strong>
					</th>
					<th>
						<strong>Subscribed Date</strong>
					</th>
					<th>
						<strong>Expiration Date</strong>
					</th>
					<th></th>				
				</thead>
				<tbody>
					<cfloop array="#$.slatwall.getAccount().getSubscriptionUsages()#" index="subscriptionUsage">
						<!--- Setup an orderID for the accordion --->
						<cfset subscriptionDOMID = "suid#subscriptionUsage.getSubscriptionUsageID()#" />
						<tr>
							<td>#subscriptionUsage.getSubscriptionOrderItemName()#</td>
							<td>#subscriptionUsage.getCurrentStatusType()#</td>
							<td>#dateformat(subscriptionUsage.getCreatedDateTime(),'mm/dd/yyyy')#</td>
							<td>#dateformat(subscriptionUsage.getExpirationDate(),'mm/dd/yyyy')#</td>
							<td><a href="/my-account/subscriptions/subscription?subscriptionID=#subscriptionDOMID#" class="plus-btn">View</a></td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			<!---<div class="float-right">
            	<!--- Pagination --->
	            <sw:SlatwallCollectionPagination
	            	collection="#local.ordersCollection#"
	            	slatwallScope="#$.slatwall#"
	            	showFirstAndLast="true">
	            </sw:SlatwallCollectionPagination>
            </div>--->
		<cfelse>
			<p>You have no subscriptions.</p>
		</cfif>
	</article>
</cfoutput>