<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.importerMappingSmartList" type="any" />

<hb:HibachiEntityActionBar type="listing" object="#rc.importerMappingSmartList#" showCreate="false">

	<!--- Create --->
	<hb:HibachiEntityActionBarButtonGroup>
		<hb:HibachiActionCaller action="admin:entity.createimportermapping" class="btn btn-primary" icon="plus icon-white" />
	</hb:HibachiEntityActionBarButtonGroup>
</hb:HibachiEntityActionBar>

<cfset displayPropertyList = "name,description,baseObject,mapping"/>
<cfset rc.importerMappingCollectionList.setDisplayProperties(
	displayPropertyList,
	{
		isVisible=true,
		isSearchable=true,
		isDeletable=true
	}
)/>

<cfset rc.importerMappingCollectionlist.addDisplayProperty(displayProperty='importerMappingID',columnConfig={
	isVisible=false,
	isSearchable=false,
	isDeletable=false
})/>
<hb:HibachiListingDisplay 
	collectionList="#rc.importerMappingCollectionList#"
	recordEditAction="admin:entity.edit#lcase(rc.importerMappingCollectionlist.getCollectionObject())#"
	recordDetailAction="admin:entity.detail#lcase(rc.importerMappingCollectionlist.getCollectionObject())#"
>
</hb:HibachiListingDisplay>