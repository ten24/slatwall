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
<cfparam name="rc.baseProductType" type="string" />
<cfparam name="rc.edit" type="boolean" default="true" />

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.product#" edit="true">
		<hb:HibachiEntityActionBar type="detail" object="#rc.product#" edit="true"></hb:HibachiEntityActionBar>
		
		<cfif rc.product.isNew() and rc.edit>
			<!--- Submit the baseProductType as well in case of a validation error --->
			<input type="hidden" name="baseProductType" value="#rc.baseProductType#" />
		</cfif>
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<hb:HibachiPropertyDisplay object="#rc.product#" property="productType" edit="true" valueOptions="#rc.product.getProductTypeOptions(rc.baseProductType)#">
				<cfif rc.baseProductType eq "merchandise">
					<hb:HibachiPropertyDisplay object="#rc.product#" property="brand" edit="true">
				</cfif>
				<hb:HibachiPropertyDisplay object="#rc.product#" property="productName" edit="true">
				<hb:HibachiPropertyDisplay object="#rc.product#" property="productCode" edit="true">
				<hb:HibachiPropertyDisplay object="#rc.product#" property="price" edit="true">
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		<hr />
		<cfif rc.baseProductType eq "merchandise">
			<div class="row">
				<cfset optionsSmartList = $.slatwall.getService("optionService").getOptionSmartList() />
				<cfset optionsSmartList.addOrder("optionGroup.sortOrder|ASC") />
				<cfif optionsSmartList.getRecordsCount()>
					<hb:HibachiListingDisplay smartList="#optionsSmartList#" multiselectfieldname="options" edit="true">
						<hb:HibachiListingColumn propertyIdentifier="optionGroup.optionGroupName" />
						<hb:HibachiListingColumn propertyIdentifier="optionName" tdclass="primary" />
					</hb:HibachiListingDisplay>
				</cfif>
			</div>
		<cfelseif rc.baseProductType eq "subscription">
			<div class="row">
				<div class="col-md-6">
					<h5>#$.slatwall.rbKey('admin.entity.createproduct.selectsubscriptionbenefits')#</h5>
					<br />
					<swa:SlatwallErrorDisplay object="#rc.product#" errorName="subscriptionBenefits" />
					<hb:HibachiListingDisplay smartList="SubscriptionBenefit" multiselectFieldName="subscriptionBenefits" edit="true">
						<hb:HibachiListingColumn propertyIdentifier="subscriptionBenefitName" tdclass="primary" />
					</hb:HibachiListingDisplay>
					<h5>#$.slatwall.rbKey('admin.entity.createproduct.selectrenewalsubscriptionbenifits')#</h5>
					<br />
					<swa:SlatwallErrorDisplay object="#rc.product#" errorName="renewalsubscriptionBenefits" />
					<hb:HibachiListingDisplay smartList="SubscriptionBenefit" multiselectFieldName="renewalSubscriptionBenefits" edit="true">
						<hb:HibachiListingColumn propertyIdentifier="subscriptionBenefitName" tdclass="primary" />
					</hb:HibachiListingDisplay>
				</div>
				<div class="col-md-6">
					<h5>#$.slatwall.rbKey('admin.entity.createproduct.selectsubscriptionterms')#</h5>
					<br />
					<swa:SlatwallErrorDisplay object="#rc.product#" errorName="subscriptionTerms" />
					<hb:HibachiListingDisplay smartList="SubscriptionTerm" multiselectFieldName="subscriptionTerms" edit="true">
						<hb:HibachiListingColumn propertyIdentifier="subscriptionTermName" tdclass="primary" />
					</hb:HibachiListingDisplay>
				</div>
			</div>
		<cfelseif rc.baseProductType eq "contentAccess">
			<cfset contentAccessList = $.slatwall.getService("contentService").getContentSmartList() />
			<!---<cfset contentAccessList.addFilter("allowPurchaseFlag", 1) />--->
			<swa:SlatwallErrorDisplay object="#rc.product#" errorName="accessContents" />
			<hb:HibachiFieldDisplay fieldType="yesno" fieldName="bundleContentAccess" value="0" title="#$.slatwall.rbKey('admin.entity.createproduct.bundleContentAccess')#" hint="#$.slatwall.rbKey('admin.entity.createproduct.bundleContentAccess_hint')#" edit="true" />
			<hb:HibachiListingDisplay smartList="#contentAccessList#" multiselectFieldName="accessContents" edit="true">
				<hb:HibachiListingColumn propertyIdentifier="title" tdclass="primary" />
			</hb:HibachiListingDisplay>
		</cfif>
	</hb:HibachiEntityDetailForm>
</cfoutput>
