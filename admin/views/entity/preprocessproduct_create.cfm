<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

--->
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.product" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<span id="productCreate" ng-controller="preprocessproduct_create as preprocessproduct_createCtrl">
		<hb:HibachiEntityProcessForm entity="#rc.processObject.getProduct()#"  edit="#rc.edit#">

			<hb:HibachiEntityActionBar type="preprocess" object="#rc.processObject.getProduct()#"></hb:HibachiEntityActionBar>

			<!--- Submit the baseProductType as well in case of a validation error --->
			<input type="hidden" name="baseProductType" value="#rc.processObject.getBaseProductType()#" />
			<!--- inject angular here --->
			<cfset fieldAttributes = 'ng-model="preprocessproduct_createCtrl.selectedOption.value" ng-change="preprocessproduct_createCtrl.productTypeChanged(preprocessproduct_createCtrl.selectedOption)"'/>
			<hb:HibachiPropertyRow>
				<hb:HibachiPropertyList divClass="col-md-6">
					<!--- Select Product Type --->
					<hb:HibachiPropertyDisplay
						object="#rc.processObject.getProduct()#"
						property="productType"
						fieldName="product.productType.productTypeID"
						edit="true"
						valueOptions="#rc.product.getProductTypeOptions(rc.processObject.getBaseProductType())#"
						fieldAttributes="#fieldAttributes#"
					>

					<!--- MERCHANDISE --->
					<cfif rc.processObject.getBaseProductType() eq "merchandise">
						<hb:HibachiPropertyDisplay object="#rc.processObject.getProduct()#" property="brand" fieldName="product.brand.brandID" edit="true">
					</cfif>

					<hb:HibachiPropertyDisplay object="#rc.processObject.getProduct()#" property="productName" fieldName="product.productName" edit="true" title="#$.slatwall.rbKey('entity.product.#rc.processObject.getBaseProductType()#.productName')#">
					<hb:HibachiPropertyDisplay object="#rc.processObject.getProduct()#" property="productCode" fieldName="product.productCode" edit="true" title="#$.slatwall.rbKey('entity.product.#rc.processObject.getBaseProductType()#.productCode')#">

					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="price" edit="true">
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="listPrice" edit="true">

				</hb:HibachiPropertyList>

				<hb:HibachiPropertyList divClass="col-md-6">

					<!--- EVENT --->
					<cfif rc.processObject.getBaseProductType() eq "event">

						<cfset rc.addEventScheduleProcessObject = rc.product.getProcessObject('addEventSchedule') />
						<cfinclude template="preprocessproduct_include/addeventschedule.cfm" />

						<!---
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="eventStartDateTime" edit="true">
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="eventEndDateTime" edit="true">

						<hb:HibachiPropertyDisplay object="#rc.processObject#" fieldname="schedulingType" property="schedulingType" valueOptions="#rc.processObject.getSchedulingTypeOptions()#" edit="#rc.edit#">

						<!--- Schedule - Recurring --->
						<hb:HibachiDisplayToggle selector="select[name='schedulingType']" loadVisable="#rc.processObject.getSchedulingType() eq 'recurring'#" showValues="recurring">

							<hb:HibachiPropertyDisplay object="#rc.processObject#" property="recurringTimeUnit" valueOptions="#rc.processObject.getRecurringTimeUnitOptions()#" edit="#rc.edit#">

							<!--- Weekly schedule --->
							<hb:HibachiDisplayToggle selector="select[name='recurringTimeUnit']" loadVisable="no" showValues="#rc.processObject.getService('typeService').getTypeBySystemCode('rtuWeekly').getTypeID()#">

								<hb:HibachiPropertyDisplay object="#rc.processObject#" property="weeklyDaysOfOccurrence" edit="#rc.edit#" valueOptions="#rc.processObject.getDaysOfWeekOptions()#">

							</hb:HibachiDisplayToggle>
							<!--- /Weekly schedule --->

							<!--- Monthly schedule --->
							<hb:HibachiDisplayToggle selector="select[name='recurringTimeUnit']" loadVisable="#rc.processObject.getRecurringTimeUnit() EQ rc.processObject.getService('typeService').getTypeBySystemCode('rtuMonthly').getTypeID()#" showValues="#rc.processObject.getService('SettingService').getTypeBySystemCode('rtuMonthly').getTypeID()#">

								<hb:HibachiPropertyDisplay object="#rc.processObject#" property="monthlyRepeatByType" edit="#rc.edit#" valueOptions="#rc.processObject.getMonthlyRepeatByOptions()#">

								<hb:HibachiDisplayToggle selector="input[name='monthlyRepeatBy']" loadVisable="yes" showValues="dayOfWeek">
									<div id="monthlyRepeatByWeekdaySummary"  class="alert alert-block">Select a start date</div>
								</hb:HibachiDisplayToggle>
								<hb:HibachiDisplayToggle selector="input[name='monthlyRepeatBy']" loadVisable="no" showValues="dayOfMonth">
									<div id="monthlyRepeatByMonthdaySummary" class="alert alert-block">Select a start date</div>
								</hb:HibachiDisplayToggle>

							</hb:HibachiDisplayToggle>
							<!--- /Monthly schedule --->

							<hb:HibachiPropertyDisplay object="#rc.processObject#" property="scheduleEndDate" edit="#rc.edit#">

							<input type="hidden" name="scheduleEndType" value="#rc.processObject.getService('typeService').getTypeBySystemCode('setDate').getTypeID()#" />

						</hb:HibachiDisplayToggle>
						--->

					<cfelseif rc.baseProductType eq "subscription">

							<swa:SlatwallErrorDisplay object="#rc.product#" errorName="subscriptionTerms" />
							<hb:HibachiListingDisplay smartList="SubscriptionTerm" multiselectFieldName="subscriptionTerms" title="#$.slatwall.rbKey('admin.entity.createproduct.selectsubscriptionterms')#" edit="true">
								<hb:HibachiListingColumn propertyIdentifier="subscriptionTermName" tdclass="primary" />
							</hb:HibachiListingDisplay>

						<swa:SlatwallErrorDisplay object="#rc.product#" errorName="subscriptionBenefits" />
						<hb:HibachiListingDisplay smartList="SubscriptionBenefit" multiselectFieldName="subscriptionBenefits" title="#$.slatwall.rbKey('admin.entity.createproduct.selectsubscriptionbenefits')#" edit="true">
							<hb:HibachiListingColumn propertyIdentifier="subscriptionBenefitName" tdclass="primary" />
						</hb:HibachiListingDisplay>

					</cfif>


				</hb:HibachiPropertyList>

			</hb:HibachiPropertyRow>

			<hr style="border-top: 1px solid ##CCC;" />

			<!--- CONTENT ACCESS --->
			<cfif rc.processObject.getBaseProductType() eq "contentAccess">

				<hb:HibachiPropertyRow>
					<hb:HibachiPropertyList>

						<cfset contentSmartList = $.slatwall.getSmartList("Content") />
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="bundleContentAccessFlag" edit="true" />

						<swa:SlatwallErrorDisplay object="#rc.processObject#" errorName="contents" />
						<hb:HibachiListingDisplay smartList="#contentSmartList#" multiselectFieldName="contents" edit="true">
							<hb:HibachiListingColumn propertyIdentifier="title"  tdClass="primary" />
							<hb:HibachiListingColumn propertyIdentifier="site.siteName"  />
						</hb:HibachiListingDisplay>

					</hb:HibachiPropertyList>
				</hb:HibachiPropertyRow>

			<!--- Event --->
			<cfelseif rc.processObject.getBaseProductType() eq "event">

				<hb:HibachiPropertyRow>
					<hb:HibachiPropertyList>

						<!---
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="bundleLocationConfigurationFlag" edit="true" />
						<br />
						<swa:SlatwallErrorDisplay object="#rc.processObject#" errorName="locationConfigurations" />
						<hb:HibachiListingDisplay smartList="#$.slatwall.getSmartList("LocationConfiguration")#" multiselectFieldName="locationConfigurations" multiselectValues="#rc.processObject.getLocationConfigurations()#" edit="true">
							<hb:HibachiListingColumn propertyIdentifier="locationConfigurationName" />
							<hb:HibachiListingColumn propertyIdentifier="locationConfigurationCapacity" />
							<hb:HibachiListingColumn propertyIdentifier="location.locationName" />
						</hb:HibachiListingDisplay>
						--->

						<cfinclude template="preprocessproduct_include/addeventschedulelocations.cfm" />

					</hb:HibachiPropertyList>
				</hb:HibachiPropertyRow>

			<!--- Merchandise --->
			<cfelseif rc.processObject.getBaseProductType() eq "merchandise">

				<cfset optionsSmartList = $.slatwall.getSmartList("Option") />
				<cfset optionsSmartList.addOrder("optionGroup.sortOrder|ASC") />

				<cfif optionsSmartList.getRecordsCount()>

					<hb:HibachiPropertyRow>
						<hb:HibachiPropertyList>

							<sw-listing-display
								ng-if="preprocessproduct_createCtrl.collectionListingPromise && preprocessproduct_createCtrl.collection"
								data-collection-promise="preprocessproduct_createCtrl.collectionListingPromise"
								data-collection="preprocessproduct_createCtrl.collection"
								data-collection-config="preprocessproduct_createCtrl.collection.collectionConfig"
								data-multiselect-field-name="options"
								data-edit="true"
							    data-show-search="true"
							    data-has-action-bar="false"
							>
							</sw-listing-display>

						</hb:HibachiPropertyList>
					</hb:HibachiPropertyRow>

				</cfif>

			<!--- Subscription --->

			<cfelseif rc.baseProductType eq "subscription">

			<hb:HibachiPropertyList divClass="col-md-6">
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="renewalMethod" edit="true" fieldAttributes="ng-model=""preprocessproduct_createCtrl.renewalSkuChoice"" ng-options=""option.label for option in preprocessproduct_createCtrl.renewalMethodOptions track by option.value""">
			</hb:HibachiPropertyList>

			<hb:HibachiPropertyList divClass="col-md-12">

				<div ng-if="preprocessproduct_createCtrl.renewalSkuChoice.value == 'custom'">
						<hb:HibachiPropertyList divClass="col-md-6">
							<hb:HibachiPropertyDisplay object="#rc.processObject#" property="renewalPrice" fieldName="renewalPrice" edit="true" />
						</hb:HibachiPropertyList>
						<swa:SlatwallErrorDisplay object="#rc.product#" errorName="renewalsubscriptionBenefits" />
						<hb:HibachiListingDisplay smartList="SubscriptionBenefit" multiselectFieldName="renewalSubscriptionBenefits" title="#$.slatwall.rbKey('admin.entity.createProduct.selectRenewalSubscriptionBenefits')#" edit="true">
							<hb:HibachiListingColumn propertyIdentifier="subscriptionBenefitName" tdclass="primary" />
						</hb:HibachiListingDisplay>
				</div>

				<div ng-if="preprocessproduct_createCtrl.renewalSkuChoice.value == 'renewalsku'">
						<swa:SlatwallErrorDisplay object="#rc.product#" errorName="renewalSku" />
						<hb:HibachiListingDisplay smartList="#rc.product.getSubscriptionSkuSmartList()#" selectFieldName="renewalSku" title="#$.slatwall.rbKey('define.renewalSku')#" edit="true">
							<hb:HibachiListingColumn propertyIdentifier="skuCode" />
							<hb:HibachiListingColumn propertyIdentifier="skuName" />
							<hb:HibachiListingColumn propertyIdentifier="subscriptionTerm.subscriptionTermName" />
							<hb:HibachiListingColumn propertyIdentifier="renewalPrice" />
						</hb:HibachiListingDisplay>
				</div>

			</hb:HibachiPropertyList>

			<!--- Gift Card --->
			<cfelseif rc.baseProductType eq 'gift-card'>
				<hb:HibachiPropertyRow>
					<hb:HibachiPropertyList divClass="col-md-6">

						<!--- Select Product Type --->
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="giftCardExpirationTermID" edit="true">
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="redemptionAmountType" edit="true" fieldAttributes="ng-model='redemptionAmountType' ng-init='redemptionAmountType=""""'">
						<div ng-hide="redemptionAmountType == 'sameAsPrice' || redemptionAmountType == ''">
							<hb:HibachiPropertyDisplay object="#rc.processObject#" property="redemptionAmount" edit="true" value="0">
						</div>

					</hb:HibachiPropertyList>
				</hb:HibachiPropertyRow>
			</cfif>
		</hb:HibachiEntityProcessForm>
	</span>
</cfoutput>


