<cfimport prefix="swa" taglib="../../../../../tags" />
<cfimport prefix="hb" taglib="../../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderTemplate" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset rc.skuColumnConfigs = [
		{
			'isVisible': true,
			'isSearchable':false,
			'isDeletable':false,
			'isEditable':false,
			'persistent':false,
			'arguments': {
				'currencyCode':rc.orderTemplate.getCurrencyCode(), 
				'accountID': rc.orderTemplate.getAccount().getAccountID()
			}
		}	
	]
/>

<cfoutput>
	<sw-order-template-items data-edit="#rc.edit#"
							 data-order-template="#rc.orderTemplate.getEncodedJsonRepresentation()#"
							 data-sku-properties-to-display="personalVolumeByCurrencyCode"
							 data-sku-property-column-configs="#getHibachiScope().hibachiHtmlEditFormat(serializeJson(rc.skuColumnConfigs))#"
	></sw-order-template-items>
</cfoutput>	

