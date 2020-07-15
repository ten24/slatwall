<cfoutput>
<table style="font-family:arial,sans-serif; font-size:13px; margin:0 auto; width:98%; table-layout: fixed; border-spacing: 5px;">
    <cfloop array="#order.getOrderItems()#" index="local.orderItem">
        <tr>
    		<td style="width: 20%; text-align: left; padding: 10px;">
    			#local.orderItem.getSku().getSkuCode()#
    		</td>
    		<td style="width: 20%; text-align: left; padding: 10px;">
    			#local.orderItem.getSku().getProduct().getTitle()#
    		</td>
    		<td style="width: 30%; text-align: center; padding: 10px;">
    			#NumberFormat(local.orderItem.getQuantity())#
    		</td>
    		<td style="width: 30%; text-align: center; padding: 10px;">
    		    #NumberFormat(local.orderItem.getQuantityReceived())#
    		</td>
    	</tr>
    </cfloop>
</table>
</cfoutput>