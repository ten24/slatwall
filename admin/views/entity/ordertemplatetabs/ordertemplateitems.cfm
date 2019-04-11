<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderTemplate" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset rc.skuCollectionList = getHibachiScope().getService('SkuService').getSkuCollectionList() />
<cfset rc.skuCollectionList.setDisplayProperties('skuName,skuCode,skuDescription',{isVisible=true,isSearchable=true,isDeletable=true,isEditable=false}) /> 
<cfset rc.skuCollectionList.addDisplayProperty('skuID','',{isVisible=false,isSearchable=false,isDeletable=false,isEditable=false}) /> 
<cfset rc.skuCollectionList.addDisplayProperty('price',getHibachiScope().rbKey('entity.sku.price'),{isVisible=true,isSearchable=true,isDeletable=true,isEditable=true}) /> 

<cfset rc.orderTemplateItemCollectionList = getHibachiScope().getService('OrderService').getOrderTemplateItemCollectionList() />

<cfset rc.columns = rc.skuCollectionList.getCollectionConfigStruct().columns />

<cfset arrayAppend(rc.columns, {
	'title': getHibachiScope().rbKey('define.quantity'),
	'propertyIdentifier':'quantity',
	'defaultValue':1, 
	'isCollectionColumn':false, 
	'isEditable':true,
	'isVisible':true
}) />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>

				<hb:HibachiListingDisplay 
					recordProcessEvent="addOrderTemplateItem"
					collectionList="#rc.skuCollectionlist#"
					listingColumns="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(rc.columns))#"
					usingPersonalCollection="false"
				>
				</hb:HibachiListingDisplay>	
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>	

