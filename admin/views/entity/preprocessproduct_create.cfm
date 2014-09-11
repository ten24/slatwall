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
<cfparam name="rc.product" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityProcessForm entity="#rc.processObject.getProduct()#" edit="#rc.edit#">
		
		<cf_HibachiEntityActionBar type="preprocess" object="#rc.processObject.getProduct()#"></cf_HibachiEntityActionBar>
		
		<!--- Submit the baseProductType as well in case of a validation error --->
		<input type="hidden" name="baseProductType" value="#rc.processObject.getBaseProductType()#" />
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList divClass="span6">
				
				<!--- Select Product Type --->
				<cf_HibachiPropertyDisplay object="#rc.processObject.getProduct()#" property="productType" fieldName="product.productType.productTypeID" edit="true" valueOptions="#rc.product.getProductTypeOptions(rc.processObject.getBaseProductType())#">
				
				<!--- MERCHANDISE --->
				<cfif rc.processObject.getBaseProductType() eq "merchandise">
					<cf_HibachiPropertyDisplay object="#rc.processObject.getProduct()#" property="brand" fieldName="product.brand.brandID" edit="true">
				</cfif>
				
				<cf_HibachiPropertyDisplay object="#rc.processObject.getProduct()#" property="productName" fieldName="product.productName" edit="true" title="#$.slatwall.rbKey('entity.product.#rc.processObject.getBaseProductType()#.productName')#">
				<cf_HibachiPropertyDisplay object="#rc.processObject.getProduct()#" property="productCode" fieldName="product.productCode" edit="true" title="#$.slatwall.rbKey('entity.product.#rc.processObject.getBaseProductType()#.productCode')#">
				
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="price" edit="true">
				
			</cf_HibachiPropertyList>
		
			<cf_HibachiPropertyList divClass="span6">
				
				<!--- EVENT --->
				<cfif rc.processObject.getBaseProductType() eq "event">
					
					<cfset rc.addEventScheduleProcessObject = rc.product.getProcessObject('addEventSchedule') />
					<cfinclude template="preprocessproduct_include/addeventschedule.cfm" />
					
					<!---
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="eventStartDateTime" edit="true">
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="eventEndDateTime" edit="true">
					
					<cf_HibachiPropertyDisplay object="#rc.processObject#" fieldname="schedulingType" property="schedulingType" valueOptions="#rc.processObject.getSchedulingTypeOptions()#" edit="#rc.edit#">
					
					<!--- Schedule - Recurring --->
					<cf_HibachiDisplayToggle selector="select[name='schedulingType']" loadVisable="#rc.processObject.getSchedulingType() eq 'recurring'#" showValues="recurring">
						
						<cf_HibachiPropertyDisplay object="#rc.processObject#" property="recurringTimeUnit" valueOptions="#rc.processObject.getRecurringTimeUnitOptions()#" edit="#rc.edit#">
						
						<!--- Weekly schedule --->
						<cf_HibachiDisplayToggle selector="select[name='recurringTimeUnit']" loadVisable="no" showValues="#rc.processObject.getService('SettingService').getTypeBySystemCode('rtuWeekly').getTypeID()#">
							
							<cf_HibachiPropertyDisplay object="#rc.processObject#" property="weeklyDaysOfOccurrence" edit="#rc.edit#" valueOptions="#rc.processObject.getDaysOfWeekOptions()#">
							
						</cf_HibachiDisplayToggle>
						<!--- /Weekly schedule --->
						
						<!--- Monthly schedule --->
						<cf_HibachiDisplayToggle selector="select[name='recurringTimeUnit']" loadVisable="#rc.processObject.getRecurringTimeUnit() EQ rc.processObject.getService('SettingService').getTypeBySystemCode('rtuMonthly').getTypeID()#" showValues="#rc.processObject.getService('SettingService').getTypeBySystemCode('rtuMonthly').getTypeID()#">
						
							<cf_HibachiPropertyDisplay object="#rc.processObject#" property="monthlyRepeatByType" edit="#rc.edit#" valueOptions="#rc.processObject.getMonthlyRepeatByOptions()#">
							
							<cf_HibachiDisplayToggle selector="input[name='monthlyRepeatBy']" loadVisable="yes" showValues="dayOfWeek">
								<div id="monthlyRepeatByWeekdaySummary"  class="alert alert-block">Select a start date</div>
							</cf_HibachiDisplayToggle>
							<cf_HibachiDisplayToggle selector="input[name='monthlyRepeatBy']" loadVisable="no" showValues="dayOfMonth">
								<div id="monthlyRepeatByMonthdaySummary" class="alert alert-block">Select a start date</div>
							</cf_HibachiDisplayToggle>
							
						</cf_HibachiDisplayToggle>
						<!--- /Monthly schedule --->
						
						<cf_HibachiPropertyDisplay object="#rc.processObject#" property="scheduleEndDate" edit="#rc.edit#">
						
						<input type="hidden" name="scheduleEndType" value="#rc.processObject.getService('SettingService').getTypeBySystemCode('setDate').getTypeID()#" />
					
					</cf_HibachiDisplayToggle>
					--->
					
				<!--- SUBSCRIPTION --->
				<cfelseif rc.processObject.getBaseProductType() eq "subscription">
				
					<cf_SlatwallErrorDisplay object="#rc.processObject#" errorName="subscriptionTerms" />
					<cf_HibachiListingDisplay smartList="SubscriptionTerm" multiselectFieldName="subscriptionTerms" edit="true">
						<cf_HibachiListingColumn propertyIdentifier="subscriptionTermName" />
					</cf_HibachiListingDisplay>
					
				</cfif>
					
			</cf_HibachiPropertyList>
			
		</cf_HibachiPropertyRow>
		
		<hr />
		
		<!--- CONTENT ACCESS --->
		<cfif rc.processObject.getBaseProductType() eq "contentAccess">
			
			<cf_HibachiPropertyRow>
				<cf_HibachiPropertyList>
				
					<cfset contentSmartList = $.slatwall.getSmartList("Content") />
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="bundleContentAccessFlag" />
					
					<cf_SlatwallErrorDisplay object="#rc.processObject#" errorName="contents" />
					<cf_HibachiListingDisplay smartList="#contentSmartList#" multiselectFieldName="contents" edit="true">
						<cf_HibachiListingColumn propertyIdentifier="title" />
					</cf_HibachiListingDisplay>
					
				</cf_HibachiPropertyList>
			</cf_HibachiPropertyRow>
					
		<!--- Event --->
		<cfelseif rc.processObject.getBaseProductType() eq "event">
			
			<cf_HibachiPropertyRow>
				<cf_HibachiPropertyList>
					
					<!---
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="bundleLocationConfigurationFlag" edit="true" />
					<br />
					<cf_SlatwallErrorDisplay object="#rc.processObject#" errorName="locationConfigurations" />
					<cf_HibachiListingDisplay smartList="#$.slatwall.getSmartList("LocationConfiguration")#" multiselectFieldName="locationConfigurations" multiselectValues="#rc.processObject.getLocationConfigurations()#" edit="true">
						<cf_HibachiListingColumn propertyIdentifier="locationConfigurationName" />
						<cf_HibachiListingColumn propertyIdentifier="locationConfigurationCapacity" />
						<cf_HibachiListingColumn propertyIdentifier="location.locationName" />
					</cf_HibachiListingDisplay>
					--->
					
					<cfinclude template="preprocessproduct_include/addeventschedulelocations.cfm" />
					
				</cf_HibachiPropertyList>
			</cf_HibachiPropertyRow>
			
		<!--- Merchandise --->
		<cfelseif rc.processObject.getBaseProductType() eq "merchandise">
			
			<cfset optionsSmartList = $.slatwall.getSmartList("Option") />
			<cfset optionsSmartList.addOrder("optionGroup.sortOrder|ASC") />
			
			<cfif optionsSmartList.getRecordsCount()>
			
				<cf_HibachiPropertyRow>
					<cf_HibachiPropertyList>
						
						<cf_HibachiListingDisplay smartList="#optionsSmartList#" multiselectfieldname="options" edit="true">
							<cf_HibachiListingColumn propertyIdentifier="optionGroup.optionGroupName" />
							<cf_HibachiListingColumn propertyIdentifier="optionName" />
						</cf_HibachiListingDisplay>
						
					</cf_HibachiPropertyList>
				</cf_HibachiPropertyRow>
				
			</cfif>
			
		<!--- Subscription --->
		<cfelseif rc.processObject.getBaseProductType() eq "subscription">
			
			<cf_HibachiPropertyRow>
				
				<cf_HibachiPropertyList divClass="span6">
				
					<h5>#$.slatwall.rbKey('admin.entity.createproduct.selectsubscriptionbenefits')#</h5>
					<br />
					<cf_SlatwallErrorDisplay object="#rc.processObject#" errorName="subscriptionBenefits" />
					<cf_HibachiListingDisplay smartList="SubscriptionBenefit" multiselectFieldName="subscriptionBenefits" edit="true">
						<cf_HibachiListingColumn propertyIdentifier="subscriptionBenefitName" />
					</cf_HibachiListingDisplay>
					
					
				</cf_HibachiPropertyList>
				
				<cf_HibachiPropertyList divClass="span6">
					
					<h5>#$.slatwall.rbKey('admin.entity.createProduct.selectRenewalSubscriptionBenefits')#</h5>
					<br />
					<cf_SlatwallErrorDisplay object="#rc.processObject#" errorName="renewalsubscriptionBenefits" />
					<cf_HibachiListingDisplay smartList="SubscriptionBenefit" multiselectFieldName="renewalSubscriptionBenefits" edit="true">
						<cf_HibachiListingColumn propertyIdentifier="subscriptionBenefitName" />
					</cf_HibachiListingDisplay>
					
				</cf_HibachiPropertyList>
				
			</cf_HibachiPropertyRow>
			
		</cfif>
		
	</cf_HibachiEntityProcessForm>
</cfoutput>
