<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.stockAdjustment" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyList>
		<cfif rc.edit>
			<input type="hidden" name="stockAdjustmentType.typeID" value="#rc.stockadjustment.getStockAdjustmentType().getTypeID()#" />
		</cfif>
		<hb:HibachiPropertyDisplay object="#rc.stockAdjustment#" property="stockAdjustmentType" edit="false">
		<hb:HibachiPropertyDisplay object="#rc.stockAdjustment#" property="stockAdjustmentStatusType" edit="false">
		<cfif listFindNoCase("satLocationTransfer,satManualOut", rc.stockAdjustment.getStockAdjustmentType().getSystemCode())>
			<hb:HibachiPropertyDisplay object="#rc.stockAdjustment#" property="fromLocation" edit="#rc.stockAdjustment.isNew()#" valueOptions="#$.slatwall.getService("locationService").getLocationOptions()#">
		</cfif>
		<cfif listFindNoCase("satLocationTransfer,satManualIn", rc.stockAdjustment.getStockAdjustmentType().getSystemCode())>
			<hb:HibachiPropertyDisplay object="#rc.stockAdjustment#" property="toLocation" edit="#rc.stockAdjustment.isNew()#" valueOptions="#$.slatwall.getService("locationService").getLocationOptions()#">
		</cfif>
	</hb:HibachiPropertyList>
</cfoutput>