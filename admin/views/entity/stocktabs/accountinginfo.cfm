<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.stock" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<!--- get all actively used currencies--->
	
	<hb:HibachiPropertyDisplay object="#rc.stock#" property="calculatedAverageCost"  edit="false">
	<hb:HibachiPropertyDisplay object="#rc.stock#" property="calculatedAverageLandedCost"  edit="false">
	<hb:HibachiPropertyDisplay object="#rc.stock#" property="calculatedCurrentMargin" edit="false">
	<hb:HibachiPropertyDisplay object="#rc.stock#" property="calculatedCurrentLandedMargin" edit="false">
	<hb:HibachiPropertyDisplay object="#rc.stock#" property="calculatedCurrentAssetValue" edit="false">
	<hb:HibachiPropertyDisplay object="#rc.stock#" property="calculatedAveragePriceSold" edit="false">
	<hb:HibachiPropertyDisplay object="#rc.stock#" property="calculatedAveragePriceSoldBeforeDiscount"   edit="false">
	<hb:HibachiPropertyDisplay object="#rc.stock#" property="calculatedAverageDiscountAmount"   edit="false">

</cfoutput>
