<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfparam name="rc.productSmartList" type="any" />

<cfset contentDisabled = "" />
<cfset subscriptionDisabled = "" />

<cfoutput>
	<cf_HibachiEntityActionBar type="listing" object="#rc.productSmartList#" showCreate="false">
		
		<!--- Create ---> 
		<cf_HibachiEntityActionBarButtonGroup>
			<cf_HibachiActionCallerDropdown title="#$.slatwall.rbKey('define.create')#" icon="plus" dropdownClass="pull-right">
				<cf_HibachiActionCaller action="admin:entity.createproduct" text="#rc.$.slatwall.rbKey('define.contentAccess')# #rc.$.slatwall.rbKey('entity.product')#" querystring="baseProductType=contentAccess" disabled="#!$.slatwall.getService("contentService").getContentSmartList().getRecordsCount()#" disabledText="#$.slatwall.rbKey('admin.entity.listproduct.createNoContent')#" type="list" />
				<cf_HibachiActionCaller action="admin:entity.createproduct" text="#rc.$.slatwall.rbKey('define.event')# #rc.$.slatwall.rbKey('entity.product')#" querystring="baseProductType=event" type="list" />
				<cf_HibachiActionCaller action="admin:entity.createproduct" text="#rc.$.slatwall.rbKey('define.merchandise')# #rc.$.slatwall.rbKey('entity.product')#" querystring="baseProductType=merchandise" type="list" />
				<cf_HibachiActionCaller action="admin:entity.createproduct" text="#rc.$.slatwall.rbKey('define.subscription')# #rc.$.slatwall.rbKey('entity.product')#" querystring="baseProductType=subscription" disabled="#!$.slatwall.getService("contentService").getSubscriptionTermSmartList().getRecordsCount() or !$.slatwall.getService("contentService").getSubscriptionBenefitSmartList().getRecordsCount()#"  disabledText="#$.slatwall.rbKey('admin.entity.listproduct.createNoSubscriptionBenefitOrTerm')#" type="list" />
			</cf_HibachiActionCallerDropdown>
		</cf_HibachiEntityActionBarButtonGroup>
		
	</cf_HibachiEntityActionBar>
	
	<cf_HibachiListingDisplay smartList="#rc.productSmartList#"
			recordEditAction="admin:entity.editproduct"
			recorddetailaction="admin:entity.detailproduct">
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="productName"  />
		<cf_HibachiListingColumn propertyIdentifier="productCode" />
		<cf_HibachiListingColumn propertyIdentifier="productType.productTypeName" />
		<cf_HibachiListingColumn propertyIdentifier="brand.brandName" />
		<cf_HibachiListingColumn propertyIdentifier="defaultSku.price" />
		<cf_HibachiListingColumn propertyIdentifier="activeFlag" />
		<cf_HibachiListingColumn propertyIdentifier="publishedFlag" />
		<cf_HibachiListingColumn propertyIdentifier="calculatedQATS" />
	</cf_HibachiListingDisplay>
	
</cfoutput>