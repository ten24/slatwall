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
			<cfset measurementUnitList.addOrderBy('conversionRatio') />
			<cfset measurementUnitList.addFilter('measurementType','Weight') />
			<cfset weightMeasurementUnits = measurementUnitList.getRecords() />

			<cfset measurementUnitList.removeFilter('measurementType','Weight') />
			<cfset measurementUnitList.addFilter('measurementType','Volume') />
			<cfset measurementUnitList.getRecords(refresh=true, formatRecords=false) />
			<cfset volumeMeasurementUnits = measurementUnitList.getRecords() />

			<cfset measurementUnitList.removeFilter('measurementType','Weight') />
			<cfset measurementUnitList.addFilter('measurementType','Length') />
			<cfset measurementUnitList.getRecords(refresh=true, formatRecords=false) />
			<cfset lengthMeasurementUnits = measurementUnitList.getRecords() />

			<hb:HibachiDisplayToggle selector="select[name=inventoryTrackBy]" showValues="Measurement" loadVisable="#rc.sku.getValueByPropertyIdentifier('inventoryTrackBy') neq 'Quantity'#">
				<div class="form-group">
					<label for="measurementUnitID" class="control-label col-sm-4"><span class="s-title">#$.slatwall.rbKey('entity.Sku.inventoryMeasurementUnit')#</span></label>
					<div class="col-sm-8">
						<cfif rc.edit>
							<select id="measurementUnitID" class="form-control" name="inventoryMeasurementUnit.unitCode">
								<cfif arrayLen(weightMeasurementUnits)>
									<optgroup label="Weight">
										<cfloop array="#weightMeasurementUnits#" index="unit">
											<option value="#unit.unitCode#" #!isNull(rc.sku.getInventoryMeasurementUnit()) && rc.sku.getInventoryMeasurementUnit().getUnitCode() eq unit.unitCode ? 'selected="true"' : ''#>#unit.unitName#</option>
										</cfloop>
									</optgroup>
								</cfif>
								<cfif arrayLen(volumeMeasurementUnits)>
									<optgroup label="Volume">
										<cfloop array="#volumeMeasurementUnits#" index="unit">
											<option value="#unit.unitCode#" #!isNull(rc.sku.getInventoryMeasurementUnit()) && rc.sku.getInventoryMeasurementUnit().getUnitCode() eq unit.unitCode ? 'selected="true"' : ''#>#unit.unitName#</option>
										</cfloop>
									</optgroup>
								</cfif>
								<cfif arrayLen(lengthMeasurementUnits)>
									<optgroup label="Length">
										<cfloop array="#lengthMeasurementUnits#" index="unit">
											<option value="#unit.unitCode#" #!isNull(rc.sku.getInventoryMeasurementUnit()) && rc.sku.getInventoryMeasurementUnit().getUnitCode() eq unit.unitCode ? 'selected="true"' : ''#">#unit.unitName#</option>
										</cfloop>
									</optgroup>
								</cfif>
							</select>
						<cfelse>
							#isNull(rc.sku.getInventoryMeasurementUnit()) ? '' : '#rc.sku.getInventoryMeasurementUnit().getUnitName()#'#
						</cfif>
					</div>
				</div>
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
