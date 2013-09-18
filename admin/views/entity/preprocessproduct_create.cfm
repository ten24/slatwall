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
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityProcessForm entity="#rc.processObject.getProduct()#" edit="#rc.edit#">
		
		<cf_HibachiEntityActionBar type="preprocess" object="#rc.processObject.getProduct()#"></cf_HibachiEntityActionBar>
		
		<!--- Submit the baseProductType as well in case of a validation error --->
		<input type="hidden" name="baseProductType" value="#rc.processObject.getBaseProductType()#" />
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				
				<!--- Select Product Type --->
				<cf_HibachiPropertyDisplay object="#rc.processObject.getProduct()#" property="productType" fieldName="product.productType.productTypeID" edit="true" valueOptions="#rc.product.getProductTypeOptions(rc.processObject.getBaseProductType())#">
				
				<cfif rc.processObject.getBaseProductType() eq "merchandise">
					<cf_HibachiPropertyDisplay object="#rc.processObject.getProduct()#" property="brand" fieldName="product.brand.brandID" edit="true">
				</cfif>
				
				<cfif rc.processObject.getBaseProductType() eq "event">
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="eventStartDateTime" edit="true">
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="eventEndDateTime" edit="true">
				</cfif>
				
				<cf_HibachiPropertyDisplay object="#rc.processObject.getProduct()#" property="productName" fieldName="product.productName" edit="true" title="#$.slatwall.rbKey('entity.product.#rc.processObject.getBaseProductType()#.productName')#">
				<cf_HibachiPropertyDisplay object="#rc.processObject.getProduct()#" property="productCode" fieldName="product.productCode" edit="true" title="#$.slatwall.rbKey('entity.product.#rc.processObject.getBaseProductType()#.productCode')#">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="price" edit="true">
			</cf_HibachiPropertyList>
			
			<cfif rc.processObject.getBaseProductType() eq "merchandise">
				<div class="row-fluid">
					<cfset optionsSmartList = $.slatwall.getSmartList("Option") />
					<cfset optionsSmartList.addOrder("optionGroup.sortOrder|ASC") />
					<cfif optionsSmartList.getRecordsCount()>
						<cf_HibachiListingDisplay smartList="#optionsSmartList#" multiselectfieldname="options" edit="true">
							<cf_HibachiListingColumn propertyIdentifier="optionGroup.optionGroupName" />
							<cf_HibachiListingColumn propertyIdentifier="optionName" />
						</cf_HibachiListingDisplay>
					</cfif>
				</div>
			<cfelseif rc.processObject.getBaseProductType() eq "subscription">
				<div class="row-fluid">
					<div class="span6">
						<h5>#$.slatwall.rbKey('admin.entity.createproduct.selectsubscriptionbenefits')#</h5>
						<br />
						<cf_SlatwallErrorDisplay object="#rc.processObject#" errorName="subscriptionBenefits" />
						<cf_HibachiListingDisplay smartList="SubscriptionBenefit" multiselectFieldName="subscriptionBenefits" edit="true">
							<cf_HibachiListingColumn propertyIdentifier="subscriptionBenefitName" />
						</cf_HibachiListingDisplay>
						<h5>#$.slatwall.rbKey('admin.entity.createproduct.selectrenewalsubscriptionbenifits')#</h5>
						<br />
						<cf_SlatwallErrorDisplay object="#rc.processObject#" errorName="renewalsubscriptionBenefits" />
						<cf_HibachiListingDisplay smartList="SubscriptionBenefit" multiselectFieldName="renewalSubscriptionBenefits" edit="true">
							<cf_HibachiListingColumn propertyIdentifier="subscriptionBenefitName" />
						</cf_HibachiListingDisplay>
					</div>
					<div class="span6">
						<h5>#$.slatwall.rbKey('admin.entity.createproduct.selectsubscriptionterms')#</h5>
						<br />
						<cf_SlatwallErrorDisplay object="#rc.processObject#" errorName="subscriptionTerms" />
						<cf_HibachiListingDisplay smartList="SubscriptionTerm" multiselectFieldName="subscriptionTerms" edit="true">
							<cf_HibachiListingColumn propertyIdentifier="subscriptionTermName" />
						</cf_HibachiListingDisplay>
					</div>
				</div>
			<cfelseif rc.processObject.getBaseProductType() eq "contentAccess">
				<cfset contentSmartList = $.slatwall.getSmartList("Content") />
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="bundleContentAccessFlag" />
				
				<cf_SlatwallErrorDisplay object="#rc.processObject#" errorName="contents" />
				<cf_HibachiListingDisplay smartList="#contentSmartList#" multiselectFieldName="contents" edit="true">
					<cf_HibachiListingColumn propertyIdentifier="title" />
				</cf_HibachiListingDisplay>
			
			<cfelseif rc.processObject.getBaseProductType() eq "event">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="bundleLocationConfigurationFlag" edit="true" />
				<cfset locationConfigurationSmartList = $.slatwall.getSmartList("LocationConfiguration") />
				<cf_SlatwallErrorDisplay object="#rc.processObject#" errorName="locationConfigurations" />
				<cf_HibachiListingDisplay smartList="#locationConfigurationSmartList#" multiselectFieldName="locationConfigurations" edit="true">
					<cf_HibachiListingColumn propertyIdentifier="locationConfigurationName" />
					<cf_HibachiListingColumn propertyIdentifier="location.locationName" />
				</cf_HibachiListingDisplay>
	
			</cfif>
		</cf_HibachiPropertyRow>
		
	</cf_HibachiEntityProcessForm>
</cfoutput>