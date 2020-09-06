<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.minMaxSetup" type="any" />
<cfoutput>
	<cfset skuCollectionList = getHibachiScope().getService('skuService').getSkuCollectionList()/>
	<cfif !isNull(rc.minmaxSetup.getSkuCollectionConfig())>
		<cfset skuCollectionList.setCollectionConfig(rc.minmaxSetup.getSkuCollectionConfig())/>
	</cfif>
	
	<cfset skuCollectionList.setDisplayProperties('skuName,skuCode,skuDescription,skuDefinition,calculatedQATS',{
		isVisible=true,
		isSearchable=true,
		isDeletable=true
	})/>
	<cfset skuCollectionList.addDisplayProperty('activeFlag',$.slatwall.rbKey('entity.sku.activeFlag'),{
		isVisible=true,
		isSearchable=true,
		isDeletable=true
	})/>
	<cfset skuCollectionList.addDisplayProperty('product.activeFlag',$.slatwall.rbKey('entity.product.activeFlag'),{
		isVisible=true,
		isSearchable=true,
		isDeletable=true
	})/>
	<cfset skuCollectionList.addDisplayProperty(displayProperty='skuID',columnConfig={
		isVisible=false,
		isSearchable=false,
		isDeletable=false
	})/>
	<hb:HibachiListingDisplay 
		collectionList="#skuCollectionList#"
		collectionConfigFieldName="skuCollectionConfig"
		showSimpleListingControls="false"
		showExport="false"
		showSearch="false"
		recordEditAction="admin:entity.edit#lcase(skuCollectionList.getCollectionObject())#"
		recordDetailAction="admin:entity.detail#lcase(skuCollectionList.getCollectionObject())#"
	>
	</hb:HibachiListingDisplay>
</cfoutput>
