<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderTemplate" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset rc.orderCollectionList = getHibachiScope().getService('OrderService').getOrderCollectionList() />
<cfset rc.orderCollectionList.addFilter('orderTemplate.orderTemplateID', rc.orderTemplate.getOrderTemplateID()) />
<cfset rc.orderCollectionList.setDisplayProperties('orderNumber,orderOpenDateTime,orderCloseDateTime,calculatedSubTotal,calculatedTaxTotal,calculatedFulfillmentTotal,calculatedTotal',{isVisible=true,isSearchable=true,isDeletable=false,isEditable=false}) />
<cfset rc.orderCollectionList.addDisplayProperty('orderID','',{isVisible=false,isSearchable=false,isDeletable=false,isEditable=false}) /> 
<cfset rc.orderCollectionList.addDisplayProperty('currencyCode','',{isVisible=false,isSearchable=false,isDeletable=false,isEditable=false}) /> 


<cfoutput>
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<hb:HibachiListingDisplay
					recordDetailAction='admin:entity.detailorder'
					collectionList="#rc.orderCollectionlist#"
					usingPersonalCollection="false"
				>
				</hb:HibachiListingDisplay>
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
</cfoutput>
