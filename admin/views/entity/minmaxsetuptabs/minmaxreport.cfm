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
		>
		</hb:HibachiListingDisplay>
	</cfif>

</cfoutput>
