<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.skuminmaxreport" type="any" />
<cfoutput>
<cftry>

	<cfif not rc.edit>
		<cfset skuCollectionList = rc.skuminmaxreport.getSkuMinMaxReportCollection() />
		<hr>
		<cfdump var="#skuCollectionList#" top="1">
		<hr>
		<cfdump var="#skuCollectionList.getHQL()#">
		<hr>
		<cfdump var="#skuCollectionList.getHQLParams()#">
		<hr>
		<cfdump var="#skuCollectionList.getRecords()#">
		<hr>
		<cfdump var="#skuCollectionList.getCollectionConfigStruct()#">
		<hr>
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
