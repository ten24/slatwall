<cfparam name="orderTemplate" />
<cfoutput>		
	<ul>
		<cfloop array="#orderTemplate.getOrderTemplateItems()#" index="local.orderTemplateItem">
			<li>#orderTemplateItem.getSku().getSkuCode()# - #orderTemplateItem.getSku().getSkuDefinition()# Price: #getService('HibachiUtilityService').formatValue_currency(orderTemplateItem.getSkuPriceByCurrencyCode(), {currencyCode:orderTemplate.getCurrencyCode()})#  Quantity: #orderTemplateItem.getQuantity()#</li>
		</cfloop> 
	</ul>
</cfoutput>	
