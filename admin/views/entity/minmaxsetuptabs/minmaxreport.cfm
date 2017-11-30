<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.minMaxSetup" type="any" />
<cfoutput>

	<cfif not rc.edit>
		<cfset skuCollectionList = rc.minMaxSetup.getminMaxSetupCollection() />
		<hb:HibachiListingDisplay 
			collectionList="#skuCollectionList#"
			collectionConfigFieldName="collectionConfig"
			showSimpleListingControls="false"
			recordEditAction="admin:entity.edit#lcase(skuCollectionList.getCollectionObject())#"
			recordDetailAction="admin:entity.detail#lcase(skuCollectionList.getCollectionObject())#"
		>
		</hb:HibachiListingDisplay>
	</cfif>

</cfoutput>
