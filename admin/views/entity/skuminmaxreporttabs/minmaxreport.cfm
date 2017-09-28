<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.skuMinMaxReport" type="any" />
<cfoutput>
	<table class="table">
		<cfloop array="#rc.skuMinMaxReport.getSkuCollection().getRecords()#" index="thisSku">
			<cfset sku = rc.$.Slatwall.getEntity('Sku',thisSku.skuID)>
			<cfset stock = rc.$.Slatwall.getService('StockService').getStockBySkuANDLocation(sku,rc.skuMinMaxReport.getLocation())>
			<!--- <cfdump var="#stock#" top="1"> --->
			<cfset stock1 = rc.$.Slatwall.getService('StockService').getStockByLocationANDSku([rc.skuMinMaxReport.getLocation(),sku])>
			<!--- <cfdump var="#stock1#" top="1"> --->
			<tr>
				<td>#sku.getSkuCode()#</td>
				<td>#sku.getSkuDescription()#</td>
				<td>#sku.getSkuDefinition()#</td>
				<td>#stock.getLocation().getLocationName()# #stock.getCalculatedQATS()#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>


<!--- <cfdump var="#rc.skuMinMaxReport#" top="1" expand="false"> --->
<!--- <cfdump var="#rc.skuMinMaxReport.getSkuCollection()#" top="1" expand="false"> --->
<!--- <cfdump var="#arrayLen(rc.skuMinMaxReport.getSkuCollection().getRecords())#" top="1"> --->
<!--- <cfdump var="#rc.skuMinMaxReport.getSkuCollection().getRecords()#"> --->
<!--- <cfdump var="#rc.skuMinMaxReport.getSkuCollection().getCollectionConfigExportDataByCollection()#" top="1"> --->
