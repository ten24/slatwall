<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderTemplate" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset rc.orderTemplateItemCollectionList = getHibachiScope().getService('OrderService').getOrderTemplateItemCollectionList() />

<cfset rc.orderTemplateItemCollectionList.setDisplayProperties('sku.skuName,sku.skuCode,sku.skuDefinition,sku.product.productName,sku.price,quantity',{isVisible=true,isSearchable=true,isDeletable=true,isEditable=false}) />
<cfset rc.orderTemplateItemCollectionList.addDisplayProperty('orderTemplateItemID','',{isVisible=false,isSearchable=false,isDeletable=false,isEditable=false}) /> 
<cfset rc.orderTemplateItemCollectionList.addFilter('orderTemplate.orderTemplateID', rc.orderTemplate.getOrderTemplateID()) />

<cfset rc.skuCollectionList = getHibachiScope().getService('SkuService').getSkuCollectionList() />
<cfset rc.skuCollectionList.setDisplayProperties('skuName,skuCode,skuDefinition,product.productName',{isVisible=true,isSearchable=true,isDeletable=true,isEditable=false}) /> 
<cfset rc.skuCollectionList.addDisplayProperty('skuID','',{isVisible=false,isSearchable=false,isDeletable=false,isEditable=false}) /> 
<cfset rc.skuCollectionList.addDisplayProperty('price',getHibachiScope().rbKey('entity.sku.price'),{isVisible=true,isSearchable=true,isDeletable=false}) /> 
<cfset rc.skuCollectionList.addDisplayProperty('imageFile',getHibachiScope().rbKey('entity.sku.imageFile'),{isVisible=false,isSearchable=true,isDeletable=false}) /> 
<cfset rc.skuCollectionList.addFilter('publishedFlag', true) />
<cfset rc.skuCollectionList.addFilter('activeFlag', true) />
<cfset rc.skuCollectionList.addFilter('product.publishedFlag', true) />
<cfset rc.skuCollectionList.addFilter('product.activeFlag', true) />

<cfset rc.skuColumns = duplicate(rc.skuCollectionList.getCollectionConfigStruct().columns) />

<cfset arrayAppend(rc.skuColumns, {
	'title': getHibachiScope().rbKey('define.quantity'),
	'propertyIdentifier':'quantity',
	'type':'number',
	'defaultValue':1, 
	'isCollectionColumn':false, 
	'isEditable':true,
	'isVisible':true
}) />

<cfset rc.editEvent = 'editOrderTemplateItem' />

<cfoutput>

		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>

				<div sw-entity-view-mode>
					<hb:HibachiListingDisplay
						recordDeleteEvent="deleteOrderTemplateItem"
						listingID='OrderTemplateDetailOrderItems'
						collectionList="#rc.orderTemplateItemCollectionlist#"
						usingPersonalCollection="false"
					>
					</hb:HibachiListingDisplay>		
				</div>	
				
				<cfset rc.orderTemplateItemCollectionList.addDisplayProperty('quantity',getHibachiScope().rbKey('entity.orderTemplateItem.quantity'),{isVisible=true,isSearchable=false,isDeletable=false,isEditable=true}) /> 

				<div sw-entity-edit-mode>
					<hb:HibachiListingDisplay
						recordEditEvent="#rc.editEvent#"
						recordEditIcon="floppy-disk"
						recordDeleteEvent="deleteOrderTemplateItem"
						listingID='OrderTemplateDetailOrderItems'
						collectionList="#rc.orderTemplateItemCollectionlist#"
						usingPersonalCollection="false"
					>
					</hb:HibachiListingDisplay>		
					
					<hb:HibachiListingDisplay 
						recordProcessEvent="addOrderTemplateItem"
						collectionList="#rc.skuCollectionList#"
						listingColumns="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(rc.skuColumns))#"
						usingPersonalCollection="false"
					>
					</hb:HibachiListingDisplay>	
				</div> 
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
</cfoutput>	

