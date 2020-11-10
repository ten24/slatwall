<cfoutput>
    <div id="orderItems#orderFulfillment.getOrderFulfillmentID()#-#local.batchPageCount#">
        <table class="invoice-list" cellspacing="5">
            <thead>
                <tr>
                    <th>Quantity</th>
                    <th>Size</th>
                    <th>Description</th>
        			<th>SKU</th>
                </tr>
            </thead>
        	<cfset local.totalQuantity=0>
        
        	<cfset local.count = 1 />
        	<cfloop array="#orderFulfillment.getOrderFulfillmentItems()#" index="local.orderFulfillmentItem">
        		<cfif local.orderFulfillmentItem.getQuantityDelivered() GT 0 >
            		
            		<cfset local.totalQuantity+=local.orderFulfillmentItem.getQuantityDelivered()>
            
            		<tr>
                        <td style="text-align:right; padding-right:30px;">#NumberFormat(local.orderFulfillmentItem.getQuantityDelivered())#</td>
                        <td>
            				<cfif local.orderFulfillmentItem.getSku().getCalculatedSkuDefinition() contains 'Size: '>
            					#replace(local.orderFulfillmentItem.getSku().getCalculatedSkuDefinition(),"Size: ","")#
            				</cfif>
            			</td>
            			<td>
            			  
            			          #local.orderFulfillmentItem.getSku().getProduct().getProductName()#
            			
            		    </td>
                        <td>
            				<cfif not isNull(local.orderFulfillmentItem.getSku().getProduct())>
            					#local.orderFulfillmentItem.getSku().getProduct().getProductName()#
            				<cfelseif local.orderFulfillmentItem.getSku().getProduct().getProductType().getProductTypeName() EQ 'Wine' >
            					NV
            				</cfif>
            			</td>
            			<td>#local.orderFulfillmentItem.getSku().getSkuCode()#</td>
            		</tr>
        		</cfif>
        	</cfloop>
            <tr>
                <cfif totalQuantity EQ 0>
                    <td colspan="5" style="border:none; font-weight:bold; text-align:center; padding-top:15px; padding-right:30px;">No Items have been delivered</div>
                <cfelse>   
                    <td style="border:none; font-weight:bold; text-align:right; padding-right:30px;">#totalQuantity#</td>
                </cfif>
            </tr>
        </table>
    </div>
</cfoutput>