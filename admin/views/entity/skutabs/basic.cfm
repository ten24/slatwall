<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.sku" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="skuName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="skuCode" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="publishedFlag" edit="#rc.edit#">
			<cfif rc.product.getBaseProductType() EQ "event">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="eventStartDateTime" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="eventEndDateTime" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="startReservationDateTime" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="endReservationDateTime" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="purchaseStartDateTime" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="purchaseEndDateTime" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="eventCapacity" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="attendedquantity" edit="#rc.edit#">
			</cfif>
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="userDefinedPriceFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="price" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="listPrice" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.sku#" property="inventoryTrackBy" edit="#rc.edit#">

			<cfset measurementUnitList = $.slatwall.getService('measurementService').getMeasurementUnitCollectionList() />
			<cfset measurementUnitList.setDisplayProperties('unitCode,unitName') />
			<cfset measurementUnits = measurementUnitList.getRecords() />
			<span ng-init="weightMeasurementUnits = measurementUnits."

			<hb:HibachiDisplayToggle selector="select[name=inventoryTrackBy]" showValues="Measurement" loadVisable="#rc.sku.getValueByPropertyIdentifier('inventoryTrackBy') neq 'Quantity'#">
				<select name="inventoryMeasurementUnit">
					<optgroup label="Weight">
						<option ng-repeat="unit in weightMeasurementUnits" value="unit.unitCode">{{unit.unitName}}</option>
					<optgroup label="Volume">
						<option ng-repeat="unit in volumeMeasurementUnits" value="unit.unitCode">{{unit.unitName}}</option>
					<optgroup label="Length">
						<option ng-repeat="unit in lengthMeasurementUnits" value="unit.unitCode">{{unit.unitName}}</option>
			</hb:HibachiDisplayToggle>

			<cfif rc.product.getBaseProductType() EQ 'gift-card'>
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="giftCardExpirationTerm" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="redemptionAmountType" edit="#rc.edit#" fieldAttributes="ng-model='redemptionAmountType' ng-init='redemptionAmountType=""#rc.sku.getRedemptionAmountType()#""'">
				<cfif !rc.edit>
					<hb:HibachiPropertyDisplay object="#rc.sku#" property="formattedRedemptionAmount">
				<cfelse>
					<div ng-hide="redemptionAmountType == 'sameAsPrice' || redemptionAmountType == ''">
						<hb:HibachiPropertyDisplay object="#rc.sku#" property="redemptionAmount" edit="#rc.edit#">
					</div>
				</cfif>
			</cfif>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
