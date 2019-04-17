<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderTemplate" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset rc.orderTemplateItemCollectionList = getHibachiScope().getService('OrderService').getOrderTemplateItemCollectionList() />

<cfset rc.orderTemplateItemCollectionList.setDisplayProperties('sku.skuName,sku.skuCode,sku.skuDescription,sku.price',{isVisible=true,isSearchable=true,isDeletable=true,isEditable=false}) />
<cfset rc.orderTemplateItemCollectionList.addDisplayProperty('orderTemplateItemID','',{isVisible=false,isSearchable=false,isDeletable=false,isEditable=false}) /> 
<cfset rc.orderTemplateItemCollectionList.addDisplayProperty('quantity','',{isVisible=true,isSearchable=false,isDeletable=false,isEditable=rc.edit}) /> 
<cfset rc.orderTemplateItemCollectionList.addFilter('orderTemplate.orderTemplateID', rc.orderTemplate.getOrderTemplateID()) />

<cfset rc.skuCollectionList = getHibachiScope().getService('SkuService').getSkuCollectionList() />
<cfset rc.skuCollectionList.setDisplayProperties('skuName,skuCode,skuDescription',{isVisible=true,isSearchable=true,isDeletable=true,isEditable=false}) /> 
<cfset rc.skuCollectionList.addDisplayProperty('skuID','',{isVisible=false,isSearchable=false,isDeletable=false,isEditable=false}) /> 
<cfset rc.skuCollectionList.addDisplayProperty('price',getHibachiScope().rbKey('entity.sku.price'),{isVisible=true,isSearchable=true,isDeletable=false}) /> 
<cfset rc.skuCollectionList.addDisplayProperty('imageFile',getHibachiScope().rbKey('entity.sku.imageFile'),{isVisible=false,isSearchable=true,isDeletable=false}) /> 

<cfset rc.skuColumns = rc.skuCollectionList.getCollectionConfigStruct().columns />

<cfset arrayAppend(rc.skuColumns, {
	'title': getHibachiScope().rbKey('define.quantity'),
	'propertyIdentifier':'quantity',
	'type':'number',
	'defaultValue':1, 
	'isCollectionColumn':false, 
	'isEditable':true,
	'isVisible':true
}) />

<cfset arrayPrepend(rc.skuColumns, {
	'title': getHibachiScope().rbKey('entity.sku.imageFile'),
	'propertyIdentifier':'imageFile',
	'isVisible':true,
	'cellView':'swSkuImage'
}) />

<cfoutput>

		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>

				<hb:HibachiListingDisplay
					recordEditEvent="editOrderTemplateItem"
					recordDeleteEvent="deleteOrderTemplateItem"
					listingID='OrderTemplateDetailOrderItems'
					collectionList="#rc.orderTemplateItemCollectionlist#"
					usingPersonalCollection="false"
				>
				</hb:HibachiListingDisplay>				
			
				<cfif rc.edit >
					<hb:HibachiListingDisplay 
						recordProcessEvent="addOrderTemplateItem"
						collectionList="#rc.skuCollectionlist#"
						listingColumns="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(rc.skuColumns))#"
						usingPersonalCollection="false"
					>
					</hb:HibachiListingDisplay>	
				</cfif> 
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
</cfoutput>	

