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


<cfparam name="rc.subscriptionUsageSmartList" type="any" />

<cfoutput>
	<!---TODO:subscriptionOrderItemName--->
	<cfset displayPropertyList = "account.firstName,account.lastName,account.company,calculatedCurrentStatus.subscriptionStatusType.typeName,nextBillDate,expirationDate,gracePeriodTerm.termName,renewalPrice,autoPayFlag"/>
	<cfset rc.subscriptionUsageCollectionList.setDisplayProperties(
		displayPropertyList,
		{
			isVisible=true,
			isSearchable=true,
			isDeletable=true
		}
	)/>
	<cfset rc.subscriptionUsageCollectionList.addDisplayProperty(displayProperty='subscriptionUsageID',columnConfig={
		isVisible=false,
		isSearchable=false,
		isDeletable=false
	})/>
	<!---check for report year and month to filter--->
	<cfif structKeyExists(rc,'reportYear') AND structKeyExists(rc,'reportMonth')>
		<cfset months=[	
				"January",
				"February",
				"March",
				"April",
				"May",
				"June",
				"July",
				"August",
				"September",
				"October",
				"November",
				"December"
			]
		/>
		<cfset currentMonth = months[rc.reportMonth]/>
		
		<cfset filterDateMax = CreateDateTime(
			INT(rc.reportYear),
			INT(rc.reportMonth),
			INT(daysInMonth(createDateTime(2000,rc.reportMonth,1,1,1,1))),
			23,59,59
		)/>
		<cfset filterDate = CreateDateTime(INT(rc.reportYear),rc.reportMonth,1,0,0,0)/>
		<cfset rc.subscriptionUsageCollectionList.addFilter('expirationDate',filterDate,'>=')/>
		<cfset rc.subscriptionUsageCollectionList.addFilter('calculatedCurrentStatus.subscriptionStatusType.systemCode','sstActive')/>
		
		<!---
			required string propertyIdentifier,
		required any value,
		string comparisonOperator="=",
		string logicalOperator="AND",
	    string aggregate="",
	    string filterGroupAlias="",
 		string filterGroupLogicalOperator="AND"
		--->
		<cfset rc.subscriptionUsageCollectionList.addFilter('subscriptionOrderItems.subscriptionOrderItemID',"NULL","IS NOT")/>
		
		<cfset rc.pageTitle = 'Active #rc.pageTitle# for #currentMonth# #rc.reportYear#'/>	
		
		<cfif structKeyExists(rc,'subscriptionType') && len(rc.subscriptionType)>
            <cfset rc.subscriptionUsageCollectionList.addFilter('subscriptionOrderItems.subscriptionOrderItemType.systemCode',rc.subscriptionType,'IN')/>
    	<cfelse>
    		<cfset rc.subscriptionType = ""/>
        </cfif> 
        <cfif structKeyExists(rc,'productType') && len(rc.productType)>
            <cfset rc.subscriptionUsageCollectionList.addFilter('subscriptionOrderItems.orderItem.sku.product.productType.productTypeID',rc.productType,'IN')/>
        <cfelse>
            <cfset rc.productType = ""/>
        </cfif> 
        <cfif structKeyExists(rc,'productID') && len(rc.productID)>
            <cfset rc.subscriptionUsageCollectionList.addFilter('subscriptionOrderItems.orderItem.sku.product.productID',rc.productID,'IN')/>
        <cfelse>
            <cfset rc.productID = ""/>
        </cfif> 
        <cfset deferredRevenueData = $.slatwall.getService('subscriptionService').getDeferredRevenueData(rc.subscriptionType,rc.productType,rc.productID,filterDate,filterDateMax)/>    
        <cfdump var="#deferredRevenueData#"><cfabort>
	</cfif>
	<hb:HibachiEntityActionBar type="listing" object="#rc.subscriptionUsageSmartList#" showCreate="false"  />
	
	<hb:HibachiListingDisplay 
		collectionList="#rc.subscriptionUsageCollectionList#"
		usingPersonalCollection="true"
		recordEditAction="admin:entity.edit#lcase(rc.subscriptionUsageCollectionList.getCollectionObject())#"
		recordDetailAction="admin:entity.detail#lcase(rc.subscriptionUsageCollectionList.getCollectionObject())#"
	>
	</hb:HibachiListingDisplay>

</cfoutput>
