<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.skuminmaxreport" type="any" />
<cfoutput>
<cftry>

	<cfif not rc.edit>
		<cfset skuCollectionList = rc.skuminmaxreport.getSkuMinMaxReportCollection() />
		<!--- <cfdump var="#skuCollectionList.getRecords()#" top="10"> --->
		<hb:HibachiListingDisplay 
			collectionList="#skuCollectionList#"
			collectionConfigFieldName="collectionConfig"
			showSimpleListingControls="false"
		>
		</hb:HibachiListingDisplay>
	</cfif>

<cfcatch>
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>
</cfoutput>
