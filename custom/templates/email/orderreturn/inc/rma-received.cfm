<cfoutput>
<table style="font-family:arial,sans-serif; font-size:13px; margin:0 auto; width:98%; table-layout: fixed; border-spacing: 5px;">
    <cfloop array="#order.getOrderReturns()[1].getOrderReturnItems()#" index="local.orderItem">
        <tr>
    		<td style="width: 25%; text-align: left;">
    			#local.orderItem.getSku().getSkuCode()#
    		</td>
    		<td style="width: 30%; text-align: left;">
    			#local.orderItem.getSku().getProduct().getTitle()#
    		</td>
    		<td style="width: 15%; text-align: center;">
    			#NumberFormat(local.orderItem.getQuantityReceived())#
    		</td>
    		<td style="width: 15%; text-align: center;">
    		    #DollarFormat(local.orderItem.getReferencedOrderItem().getCalculatedExtendedPriceAfterDiscount())#
    		</td>
    		<td style="width: 15%; text-align: center;">
    		    #DollarFormat(local.orderItem.getCalculatedExtendedPriceAfterDiscount())#
    		</td>
    	</tr>
    </cfloop>
</table>
</cfoutput>