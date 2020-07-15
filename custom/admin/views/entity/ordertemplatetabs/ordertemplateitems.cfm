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
				'accountID': !isNull(rc.orderTemplate.getAccount()) ? rc.orderTemplate.getAccount().getAccountID() : ''
			}
		}	
	]
/>

<cfoutput>
	<sw-order-template-items data-edit="#rc.edit#"
							 data-order-template="#rc.orderTemplate.getEncodedJsonRepresentation()#"
							 <!---the ordertemplate should always have a site--->	
							 data-site-id="#rc.orderTemplate.getSite().getSiteID()#" 
							 data-currency-code="#rc.orderTemplate.getCurrencyCode()#"
							 <!---data-sku-properties-to-display="personalVolumeByCurrencyCode"--->
							 data-additional-order-template-item-properties-to-display="calculatedPersonalVolumeTotal"
							 data-sku-property-column-configs="#getHibachiScope().hibachiHtmlEditFormat(serializeJson(rc.skuColumnConfigs))#"
							 data-additional-filters="[{propertyIdentifier:'disableOnFlexshipFlag',value:false,comparisonOperator:'='}]"
	></sw-order-template-items>
</cfoutput>	

