<cfoutput>
<table style="font-family: arial, sans-serif; border-collapse: collapse; font-size:13px; margin:0 auto; width: 98%">
    <cfloop array="#order.getOrderItems()#" index="local.orderItem">
        <tr>
    		<td style="border-bottom: 1px solid #dddddd; text-align: left; padding: 10px; color:#5b5b5f; text-align: center;">
    			#local.orderItem.getSku().getSkuCode()#
    		</td>
    		<td style="border-bottom: 1px solid #dddddd; text-align: left; padding: 10px; color:#5b5b5f; text-align: center;">
    			#local.orderItem.getSku().getProduct().getTitle()#
    		</td>
    		<td style="border-bottom: 1px solid #dddddd; text-align: left; padding: 10px; color:#5b5b5f; text-align: center;">
    			#NumberFormat(local.orderItem.getQuantity())#
    		</td>
    		<td style="border-bottom: 1px solid #dddddd; text-align: left; padding: 10px; color:#5b5b5f; text-align: center;">
    		    #NumberFormat(local.orderItem.getQuantityReceived())#
    		</td>
    	</tr>
    </cfloop>
</table>
</cfoutput>