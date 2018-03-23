<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.stockAdjustment" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyList>
		<cfif rc.edit>
			<input type="hidden" name="stockAdjustmentType.typeID" value="#rc.stockadjustment.getStockAdjustmentType().getTypeID()#" />
		</cfif>

		<cfif len(rc.stockAdjustment.getReferenceNumber())>
			<hb:HibachiPropertyDisplay object="#rc.stockAdjustment#" property="referenceNumber" edit="false">
		</cfif>
		<hb:HibachiPropertyDisplay object="#rc.stockAdjustment#" property="stockAdjustmentType" edit="false">
		<hb:HibachiPropertyDisplay object="#rc.stockAdjustment#" property="stockAdjustmentStatusType" edit="false">
		<cfif listFindNoCase("satLocationTransfer,satManualOut", rc.stockAdjustment.getStockAdjustmentType().getSystemCode())>
			<cfif rc.stockAdjustment.isNew()>
				<swa:SlatwallLocationTypeahead locationPropertyName="fromLocation.locationID" locationLabelText="#rc.$.slatwall.rbKey('admin.entity.detailstockadjustment.fromlocationname')#" edit="true" showActiveLocationsFlag="true"></swa:SlatwallLocationTypeahead>
			<cfelse>
				<swa:SlatwallLocationTypeahead property="#rc.stockAdjustment.getFromLocation()#" locationPropertyName="fromLocation.locationID" locationLabelText="#rc.$.slatwall.rbKey('admin.entity.detailstockadjustment.fromlocationname')#" edit="false" showActiveLocationsFlag="true"></swa:SlatwallLocationTypeahead>
			</cfif>				 				
		</cfif>
		<cfif listFindNoCase("satLocationTransfer,satManualIn", rc.stockAdjustment.getStockAdjustmentType().getSystemCode())>
			<cfif rc.stockAdjustment.isNew()>
				<swa:SlatwallLocationTypeahead locationPropertyName="toLocation.locationID" locationLabelText="#rc.$.slatwall.rbKey('admin.entity.detailstockadjustment.tolocationname')#" edit="true" showActiveLocationsFlag="true"></swa:SlatwallLocationTypeahead>
			<cfelse>
				<swa:SlatwallLocationTypeahead property="#rc.stockAdjustment.getToLocation()#" locationPropertyName="toLocation.locationID" locationLabelText="#rc.$.slatwall.rbKey('admin.entity.detailstockadjustment.tolocationname')#" edit="false" showActiveLocationsFlag="true"></swa:SlatwallLocationTypeahead>
			</cfif>							
		</cfif>
	</hb:HibachiPropertyList>
</cfoutput>