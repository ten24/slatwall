<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderTemplate" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset rc.skuCollectionList = getHibachiScope().getService('SkuService').getSkuCollectionList() />
<cfset rc.skuCollectionList.setDisplayProperties('skuName,skuCode,skuDescription',{isVisible=true,isSearchable=true,isDeletable=true,isEditable=false}) /> 
<cfset rc.skuCollectionList.addDisplayProperty('skuID','',{isVisible=false,isSearchable=false,isDeletable=false,isEditable=false}) /> 
<cfset rc.skuCollectionList.addDisplayProperty('price',getHibachiScope().rbKey('entity.sku.price'),{isVisible=true,isSearchable=true,isDeletable=false}) /> 
<cfset rc.skuCollectionList.addDisplayProperty('imageFile',getHibachiScope().rbKey('entity.sku.imageFile'),{isVisible=false,isSearchable=true,isDeletable=false}) /> 

<cfset rc.orderTemplateItemCollectionList = getHibachiScope().getService('OrderService').getOrderTemplateItemCollectionList() />
<cfset rc.orderTemplateItemCollectionList.addFilter('orderTemplate.orderTemplateID', rc.orderTemplate.getOrderTemplateID()) />

<cfset rc.columns = rc.skuCollectionList.getCollectionConfigStruct().columns />

<cfset arrayAppend(rc.columns, {
	'title': getHibachiScope().rbKey('define.quantity'),
	'propertyIdentifier':'quantity',
	'type':'number',
	'defaultValue':1, 
	'isCollectionColumn':false, 
	'isEditable':true,
	'isVisible':true
}) />

<cfset arrayPrepend(rc.columns, {
	'title': getHibachiScope().rbKey('entity.sku.imageFile'),
	'propertyIdentifier':'imageFile',
	'isVisible':true,
	'cellView':'swSkuImage'
}) />

<cfoutput>

		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>

				<hb:HibachiListingDisplay 
					listingID='OrderTemplateDetailOrderItems'
					collectionList="#rc.orderTemplateItemCollectionlist#"
					usingPersonalCollection="false"
				>
				</hb:HibachiListingDisplay>				
			
				<cfif rc.edit >
					<hb:HibachiListingDisplay 
						recordProcessEvent="addOrderTemplateItem"
						collectionList="#rc.skuCollectionlist#"
						listingColumns="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(rc.columns))#"
						usingPersonalCollection="false"
					>
					</hb:HibachiListingDisplay>	
				</cfif> 
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
</cfoutput>	

