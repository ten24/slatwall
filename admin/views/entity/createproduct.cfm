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
<cfparam name="rc.baseProductType" type="string" />
<cfparam name="rc.edit" type="boolean" default="true" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.product#" edit="true">
		<cf_HibachiEntityActionBar type="detail" object="#rc.product#" edit="true"></cf_HibachiEntityActionBar>
		
		<cfif rc.product.isNew() and rc.edit>
			<!--- Submit the baseProductType as well in case of a validation error --->
			<input type="hidden" name="baseProductType" value="#rc.baseProductType#" />
		</cfif>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.product#" property="productType" edit="true" valueOptions="#rc.product.getProductTypeOptions(rc.baseProductType)#">
				<cfif rc.baseProductType eq "merchandise">
					<cf_HibachiPropertyDisplay object="#rc.product#" property="brand" edit="true">
				</cfif>
				<cfif rc.baseProductType eq "event">
					<!---<cf_HibachiPropertyDisplay object="#rc.product.getdefaultSku()#" property="eventStartDateTime" edit="true">
					<cf_HibachiPropertyDisplay object="#rc.product.getdefaultSku()#" property="eventStartDateTime" edit="true">--->
					<input type="text" name="eventStartDateTime" value=""  />
					<input type="text" name="eventEndDateTime" value="" />
				</cfif>
				<cf_HibachiPropertyDisplay object="#rc.product#" property="productName" edit="true">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="productCode" edit="true">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="price" edit="true">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		<hr />
		<cfif rc.baseProductType eq "merchandise">
			<div class="row-fluid">
				<cfset optionsSmartList = $.slatwall.getService("optionService").getOptionSmartList() />
				<cfset optionsSmartList.addOrder("optionGroup.sortOrder|ASC") />
				<cfif optionsSmartList.getRecordsCount()>
					<cf_HibachiListingDisplay smartList="#optionsSmartList#" multiselectfieldname="options" edit="true">
						<cf_HibachiListingColumn propertyIdentifier="optionGroup.optionGroupName" />
						<cf_HibachiListingColumn propertyIdentifier="optionName" tdclass="primary" />
					</cf_HibachiListingDisplay>
				</cfif>
			</div>
		<cfelseif rc.baseProductType eq "subscription">
			<div class="row-fluid">
				<div class="span6">
					<h5>#$.slatwall.rbKey('admin.entity.createproduct.selectsubscriptionbenefits')#</h5>
					<br />
					<cf_SlatwallErrorDisplay object="#rc.product#" errorName="subscriptionBenefits" />
					<cf_HibachiListingDisplay smartList="SubscriptionBenefit" multiselectFieldName="subscriptionBenefits" edit="true">
						<cf_HibachiListingColumn propertyIdentifier="subscriptionBenefitName" tdclass="primary" />
					</cf_HibachiListingDisplay>
					<h5>#$.slatwall.rbKey('admin.entity.createproduct.selectrenewalsubscriptionbenifits')#</h5>
					<br />
					<cf_SlatwallErrorDisplay object="#rc.product#" errorName="renewalsubscriptionBenefits" />
					<cf_HibachiListingDisplay smartList="SubscriptionBenefit" multiselectFieldName="renewalSubscriptionBenefits" edit="true">
						<cf_HibachiListingColumn propertyIdentifier="subscriptionBenefitName" tdclass="primary" />
					</cf_HibachiListingDisplay>
				</div>
				<div class="span6">
					<h5>#$.slatwall.rbKey('admin.entity.createproduct.selectsubscriptionterms')#</h5>
					<br />
					<cf_SlatwallErrorDisplay object="#rc.product#" errorName="subscriptionTerms" />
					<cf_HibachiListingDisplay smartList="SubscriptionTerm" multiselectFieldName="subscriptionTerms" edit="true">
						<cf_HibachiListingColumn propertyIdentifier="subscriptionTermName" tdclass="primary" />
					</cf_HibachiListingDisplay>
				</div>
			</div>
		<cfelseif rc.baseProductType eq "contentAccess">
			<cfset contentAccessList = $.slatwall.getService("contentService").getContentSmartList() />
			<!---<cfset contentAccessList.addFilter("allowPurchaseFlag", 1) />--->
			<cf_SlatwallErrorDisplay object="#rc.product#" errorName="accessContents" />
			<cf_HibachiFieldDisplay fieldType="yesno" fieldName="bundleContentAccess" value="0" title="#$.slatwall.rbKey('admin.entity.createproduct.bundleContentAccess')#" hint="#$.slatwall.rbKey('admin.entity.createproduct.bundleContentAccess_hint')#" edit="true" />
			<cf_HibachiListingDisplay smartList="#contentAccessList#" multiselectFieldName="accessContents" edit="true">
				<cf_HibachiListingColumn propertyIdentifier="title" tdclass="primary" />
			</cf_HibachiListingDisplay>
		<cfelseif rc.baseProductType eq "event">
			<cfset skuList = $.slatwall.getService("SkuService").getSkuSmartList() />
			<cf_SlatwallErrorDisplay object="#rc.product#" errorName="eventsku" />
			<!---<cf_HibachiPropertyDisplay object="#skuList#" fieldName="eventStartDateTime" property="eventStartDateTime" edit="#rc.edit#">--->
				<!---<cfdump var="#skuList#" top="3"/>--->
			<!---<cf_HibachiListingDisplay smartList="Sku" selectFieldName="skuCode" edit="true">
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="skuCode" />
				<cf_HibachiListingColumn propertyIdentifier="product.productName" />
				<cf_HibachiListingColumn propertyIdentifier="eventStartDateTime"  />
				<cf_HibachiListingColumn propertyIdentifier="eventEndDateTime"  />
			</cf_HibachiListingDisplay>--->
			<!---<cfdump var="#rc.product#" top="3">--->
			<!--- TODO [glenn]: Want to select Event Date Start/End & LocationConfiguration --->
			<!--- You may need to add eventStartDateTime & eventEndDateTime to the sku entity, check the spec --->
		</cfif>
	</cf_HibachiEntityDetailForm>
</cfoutput>
