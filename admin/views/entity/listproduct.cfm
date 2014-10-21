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
<cfparam name="rc.productSmartList" type="any" />
<cfset contentDisabled = "" />
<cfset subscriptionDisabled = "" />

<cfoutput>

	<cf_HibachiListingDisplay title="#rc.pageTitle#" smartList="#rc.productSmartList#"
			recordEditAction="admin:entity.editproduct"
			recorddetailaction="admin:entity.detailproduct"
			showCreate="false">
			
		<!--- Create ---> 
		<cf_HibachiListingDisplayButtonGroup>
			<cf_HibachiActionCallerDropdown title="#$.slatwall.rbKey('define.create')#" icon="plus" dropdownClass="pull-right">
				<cf_HibachiProcessCaller action="admin:entity.preprocessproduct" entity="product" processContext="create" text="#rc.$.slatwall.rbKey('define.contentAccess')# #rc.$.slatwall.rbKey('entity.product')#" querystring="baseProductType=contentAccess" disabled="#!$.slatwall.getSmartList("Content").getRecordsCount()#" disabledText="#$.slatwall.rbKey('admin.entity.listproduct.createNoContent')#" type="list" />
				<cf_HibachiProcessCaller action="admin:entity.preprocessproduct" entity="product" processContext="create" text="#rc.$.slatwall.rbKey('define.event')# #rc.$.slatwall.rbKey('entity.product')#" querystring="baseProductType=event" type="list" />
				<cf_HibachiProcessCaller action="admin:entity.preprocessproduct" entity="product" processContext="create" text="#rc.$.slatwall.rbKey('define.merchandise')# #rc.$.slatwall.rbKey('entity.product')#" querystring="baseProductType=merchandise" type="list" />
				<cf_HibachiProcessCaller action="admin:entity.preprocessproduct" entity="product" processContext="create" text="#rc.$.slatwall.rbKey('define.subscription')# #rc.$.slatwall.rbKey('entity.product')#" querystring="baseProductType=subscription" type="list" disabled="#!$.slatwall.getSmartList("SubscriptionTerm").getRecordsCount() or !$.slatwall.getSmartList("SubscriptionBenefit").getRecordsCount()#"  disabledText="#$.slatwall.rbKey('admin.entity.listproduct.createNoSubscriptionBenefitOrTerm')#" />
			</cf_HibachiActionCallerDropdown>
		</cf_HibachiListingDisplayButtonGroup>
			
		<cf_HibachiListingColumn propertyIdentifier="productType.productTypeName" />
		<cf_HibachiListingColumn propertyIdentifier="brand.brandName" />
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="productName"  />
		<cf_HibachiListingColumn propertyIdentifier="productCode" />
		<cf_HibachiListingColumn propertyIdentifier="defaultSku.price" />
		<cf_HibachiListingColumn propertyIdentifier="activeFlag" />
		<cf_HibachiListingColumn propertyIdentifier="publishedFlag" />
		<cf_HibachiListingColumn propertyIdentifier="calculatedQATS" />
	</cf_HibachiListingDisplay>
	
	<button type="button" class="btn btn-default j-test-button" style="margin-top:40px;width:100%;" ng-click="openPageDialog( 'productbundle/createproductbundle' )">Create Product Bundle</button>
</cfoutput>
