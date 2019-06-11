<cfoutput>
<h2>Recent Orders</h2>

<!--- Account Order Collection --->
<cfinclude template="account_order_collection.cfm" />

<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfinclude template="account_order_collection.cfm" />

<cfoutput>
<cfif arraylen(local.orders)>
	<table class="table table-condensed table-bordered table-striped">
		<thead>
	    	<th>
	        	<strong>Order ##</strong>
			</th>
			<th>
				<strong>Date</strong>
			</th>
			<th>
				<strong>Quantity</strong>
			</th>
			<th>
				<strong>Total</strong>
			</th>
			<th>
				<strong>Status</strong>
			</th>
			<th>
				<strong>View</strong>
			</th>				
		</thead>
		<tbody>
			<cfloop array="#local.orders#" index="order">
				<tr>
                	<td>
                		#order['orderNumber']#
                	</td>
                    <td>
                    	#dateformat(order['orderOpenDateTime'],'mm/dd/yyyy')#
	                </td>
	                <td>
	                    #order['calculatedTotalItems']#
	                </td>
	                <td>
	                   #order['orderStatusType_typeName']#
	                </td>
	                <td>
	                    #dollarformat(order['calculatedTotal'])#
	                </td>
	                <td>
	                	<a href="my-account/order-history/order?orderID=#order['orderId']#"><i class="fa fa-eye"></i></a>	
	                </td>
            	</tr>
			</cfloop>				
		</tbody>
	</table>
<cfelse>
	<p>You have no orders.</p>
</cfif>
</cfoutput>
</cfoutput>