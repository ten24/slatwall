<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.sku" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<!--- get all actively used currencies--->
	
	<sw-tab-group id="#getHibachiScope().createHibachiUUID()#">
		<cfloop array="#rc.sku.getSkuCosts()#" index="skuCost" >
			<sw-tab-content id="#getHibachiScope().createHibachiUUID()#" name="#skuCost.getCurrency().getCurrencyCode()#">
				<hb:HibachiPropertyDisplay object="#skuCost#" property="calculatedAverageCost"  edit="false">
				<hb:HibachiPropertyDisplay object="#skuCost#" property="calculatedAverageLandedCost"  edit="false">
				<hb:HibachiPropertyDisplay object="#skuCost#" property="calculatedCurrentMarginBeforeDiscount"  edit="false">
				<hb:HibachiPropertyDisplay object="#skuCost#" property="calculatedCurrentMargin"  edit="false">
				<hb:HibachiPropertyDisplay object="#skuCost#" property="calculatedCurrentLandedMargin" edit="false">
				<hb:HibachiPropertyDisplay object="#skuCost#" property="calculatedCurrentAssetValue"  edit="false">
				<hb:HibachiPropertyDisplay object="#skuCost#" property="calculatedAveragePriceSold"   edit="false">
				<hb:HibachiPropertyDisplay object="#skuCost#" property="calculatedAveragePriceSoldAfterDiscount"   edit="false">
				<hb:HibachiPropertyDisplay object="#skuCost#" property="calculatedAverageDiscountAmount"   edit="false">
				<hb:HibachiPropertyDisplay object="#skuCost#" property="calculatedQOH"   edit="false">
			</sw-tab-content>
		</cfloop>
	</sw-tab-group>
			

</cfoutput>
