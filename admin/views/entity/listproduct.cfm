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


<cfparam name="rc.productSmartList" type="any" />
<cfset contentDisabled = "" />
<cfset subscriptionDisabled = "" />

<cfoutput>
	<hb:HibachiEntityActionBar type="listing" object="#rc.productSmartList#" showCreate="false">
	
		<!--- Create ---> 
		<hb:HibachiEntityActionBarButtonGroup>
			<hb:HibachiActionCallerDropdown title="#$.slatwall.rbKey('define.create')#" icon="plus" dropdownClass="pull-right">
				<li><a ng-click="openPageDialog( 'admin/client/src/productbundle/components/createproductbundle' )">#rc.$.slatwall.rbKey('define.bundleProduct')#</a></li>
				<hb:HibachiProcessCaller action="admin:entity.preprocessproduct" entity="product" processContext="create" text="#rc.$.slatwall.rbKey('define.contentAccess')# #rc.$.slatwall.rbKey('entity.product')#" querystring="baseProductType=contentAccess" disabled="#!$.slatwall.getSmartList("Content").getRecordsCount()#" disabledText="#$.slatwall.rbKey('admin.entity.listproduct.createNoContent')#" type="list" />
				<hb:HibachiProcessCaller action="admin:entity.preprocessproduct" entity="product" processContext="create" text="#rc.$.slatwall.rbKey('define.event')# #rc.$.slatwall.rbKey('entity.product')#" querystring="baseProductType=event" disabled="#!$.slatwall.getSmartList("LocationConfiguration").getRecordsCount()#" disabledText="#$.slatwall.rbKey('admin.entity.listproduct.createNoEvent')#" type="list" />
				<hb:HibachiProcessCaller action="admin:entity.preprocessproduct" entity="product" processContext="create" text="#rc.$.slatwall.rbKey('define.gift-card')# #rc.$.slatwall.rbKey('entity.product')#" querystring="baseProductType=gift-card" type="list" />
				<hb:HibachiProcessCaller action="admin:entity.preprocessproduct" entity="product" processContext="create" text="#rc.$.slatwall.rbKey('define.merchandise')# #rc.$.slatwall.rbKey('entity.product')#" querystring="baseProductType=merchandise" type="list" />
				<hb:HibachiProcessCaller action="admin:entity.preprocessproduct" entity="product" processContext="create" text="#rc.$.slatwall.rbKey('define.subscription')# #rc.$.slatwall.rbKey('entity.product')#" querystring="baseProductType=subscription" type="list" disabled="#!$.slatwall.getSmartList("SubscriptionTerm").getRecordsCount() or !$.slatwall.getSmartList("SubscriptionBenefit").getRecordsCount()#"  disabledText="#$.slatwall.rbKey('admin.entity.listproduct.createNoSubscriptionBenefitOrTerm')#" />
			</hb:HibachiActionCallerDropdown>
		</hb:HibachiEntityActionBarButtonGroup>
	</hb:HibachiEntityActionBar>
	
	<hb:HibachiListingDisplay smartList="#rc.productSmartList#"
			recordEditAction="admin:entity.editproduct"
			recorddetailaction="admin:entity.detailproduct"
			showCreate="false">
			
		<hb:HibachiListingColumn propertyIdentifier="productType.productTypeName" />
		<hb:HibachiListingColumn propertyIdentifier="brand.brandName" />
		<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="productName"  />
		<hb:HibachiListingColumn propertyIdentifier="productCode" />
		<hb:HibachiListingColumn propertyIdentifier="defaultSku.price" />
		<hb:HibachiListingColumn propertyIdentifier="activeFlag" />
		<hb:HibachiListingColumn propertyIdentifier="publishedFlag" />
		<hb:HibachiListingColumn propertyIdentifier="calculatedQATS" />
	</hb:HibachiListingDisplay>
	
</cfoutput>
