<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="/tags" />
<cfinclude template="account_order_collection.cfm" />

<cfoutput>
	<article>
		<div class="pt-1 pb-5">
			<cfif $.slatwall.content().getUrlTitle() EQ "order-history">
				<h4 class="float-left">Total Orders: #local.ordersCollection.getRecordsCount()#</h4>
				<a href="javascript:window.print();" class="btn btn-primary float-right"><i class="fa fa-print"></i> Print Orders List</a>
			<cfelse>
			    <h4 class="float-left">Total Quotes: #local.ordersCollection.getRecordsCount()#</h4>
			    <a href="javascript:window.print();" class="btn btn-primary float-right"><i class="fa fa-print"></i> Print Quotes List</a>
			</cfif>		
		</div>
		<cfif arraylen(local.orders)>
			<!--- Order History --->
			<table class="table table-condensed table-bordered table-striped table-responsive-sm">
				<thead>
					<cfif $.slatwall.content().getUrlTitle() EQ "order-history">
				    	<th>
				        	<strong>Order ##</strong>
						</th>
						<th>
							<strong>Date</strong>
						</th>
					<cfelse>
					    <th>
							<strong>Date Last Updated</strong>
						</th>
					</cfif>
					<th>
						<strong>Status</strong>
					</th>
					<th>
						<strong>Item Count</strong>
					</th>
					<th>
						<strong>Total</strong>
					</th>
					<th></th>				
				</thead>
				<tbody>
					<cfloop array="#local.orders#" index="order">
						<tr>
							<cfif $.slatwall.content().getUrlTitle() EQ "order-history">
			                	<td>
			                		#order['orderNumber']#
			                	</td>
			                    <td>
			                    	#dateformat(order['orderOpenDateTime'],'mm/dd/yyyy')#
				                </td>
				            <cfelse>
				            	<td>
				            		#dateformat(order['DESC'],'mm/dd/yyyy')#
				                </td>
			                </cfif>
			                <td>
			                   #order['orderStatusType_typeName']#
			                </td>
			                
			                <td>
			                    #order['calculatedTotalQuantity']#
			                </td>
			                <td>
			                    #dollarformat(order['calculatedTotal'])#
			                    <!---#order.getFormattedValue('calculatedTotal')#--->
			                </td>
			                <td>
			                	<cfif $.slatwall.content().getUrlTitle() EQ "order-history">
			                		<a href="/my-account/order-history/order?orderID=#order['orderId']#">View</a>
			                	<cfelse>
		                			<a href="/my-account/quotes/quote?orderID=#order['orderId']#" class="plus-btn">View</a>
		                		</cfif>
			                </td>
		            	</tr>
					</cfloop>				
				</tbody>
			</table>
			<div class="float-right">
            	<!--- Pagination --->
	            <sw:SlatwallCollectionPagination
	            	collection="#local.ordersCollection#"
	            	slatwallScope="#$.slatwall#"
	            	showFirstAndLast="true">
	            </sw:SlatwallCollectionPagination>
            </div>
		<cfelse>
			<cfif $.slatwall.content().getUrlTitle() EQ "order-history">
		    	<p>You have no orders.</p>
			<cfelse>
			    <p>You have no quotes.</p>
			</cfif>
		</cfif>
	</article>
</cfoutput>