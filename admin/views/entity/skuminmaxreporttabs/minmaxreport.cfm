<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.skuMinMaxReport" type="any" />
<cfoutput>
	<table class="table">
		<cfloop array="#rc.skuMinMaxReport.getSkuCollection().getRecords()#" index="thisSku">
			<cfset sku = rc.$.Slatwall.getEntity('Sku',thisSku.skuID)>
			<cfset stock = rc.$.Slatwall.getService('StockService').getStockBySkuANDLocation(sku,rc.skuMinMaxReport.getLocation())>
			<tr>
				<td>#sku.getSkuCode()#</td>
				<td>#sku.getSkuDescription()#</td>
				<td>#sku.getSkuDefinition()#</td>
				<td>#stock.getLocation().getLocationName()#</td>
				<td>#thisSku.sumQATS#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>
