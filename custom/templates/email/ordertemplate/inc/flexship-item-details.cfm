<cfparam name="orderTemplate" />
<cfoutput>
	<table style="margin: 0 auto; font-family: arial, sans-serif; border-collapse: collapse;width: 100%; font-size:13px; width:80%; shashi:ranjan;" >
		<tbody>
		   <tr>
		       <th style="background-color: ##2F294B; color:##fff; border-bottom: 1px solid ##dddddd; text-align: left; padding: 10px;">IMAGE</th>
		      <th style="background-color: ##2F294B; color:##fff; border-bottom: 1px solid ##dddddd; text-align: left; padding: 10px;">ITEM CODE</th>
		      
		      <th style="background-color: ##2F294B; color:##fff; border-bottom: 1px solid ##dddddd; text-align: left; padding: 10px;">DESCRIPTION</th>
		      <th style="background-color: ##2F294B; color:##fff; border-bottom: 1px solid ##dddddd; text-align: left; padding: 10px;">PRICE</th>
		      <th style="background-color: ##2F294B; color:##fff; border-bottom: 1px solid ##dddddd; text-align: left; padding: 10px;">QUANTITY</th>
		   </tr>
		   <cfloop array="#orderTemplate.getOrderTemplateItems()#" index="local.orderTemplateItem">
			   <tr>
			      <td style="border-bottom: 1px solid ##dddddd; text-align: left; padding: 10px;">
			          <img src="#orderTemplateItem.getSku().getImagepath()#" width="100" height="100">
			      </td>
			      <td style="border-bottom: 1px solid ##dddddd; text-align: left; padding: 10px;">#orderTemplateItem.getSku().getSkuCode()#</td>
			      <td style="border-bottom: 1px solid ##dddddd; text-align: left; padding: 10px;">#orderTemplateItem.getSku().getSkuDefinition()#</td>
			      <td style="border-bottom: 1px solid ##dddddd; text-align: left; padding: 10px;">#getService('HibachiUtilityService').formatValue_currency(orderTemplateItem.getSkuPriceByCurrencyCode(), {currencyCode:orderTemplate.getCurrencyCode()})#</td>
			      <td style="border-bottom: 1px solid ##dddddd; text-align: left; padding: 10px;">#orderTemplateItem.getQuantity()#</td>
			   </tr>
		   </cfloop>
		</tbody>
	</table>
</cfoutput>	
