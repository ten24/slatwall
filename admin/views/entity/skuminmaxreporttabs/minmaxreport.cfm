<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.skuminmaxreport" type="any" />
<cfoutput>

	<cfif not rc.edit>
		<cfset skuCollectionList = rc.skuminmaxreport.getSkuMinMaxReportCollection() />
		<hb:HibachiListingDisplay 
			collectionList="#skuCollectionList#"
			collectionConfigFieldName="collectionConfig"
			showSimpleListingControls="false"
		>
		</hb:HibachiListingDisplay>
	</cfif>

</cfoutput>
