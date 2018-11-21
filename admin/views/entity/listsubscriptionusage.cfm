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
	    <cfset rc.subscriptionUsageCollectionList.addDisplayProperty(
    		displayProperty='deferredRevenue',
    		columnConfig={
    			isVisible=true,
    			isSearchable=true,
    			isDeletable=true,
    			persistent=false
    		}
    	)/>
	    
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
			INT(daysInMonth(createDateTime(rc.reportYear,rc.reportMonth,1,1,1,1))),
			23,59,59
		)/>
		<cfset filterDate = CreateDateTime(INT(rc.reportYear),rc.reportMonth,1,0,0,0)/>
		
		<cfset totalEarningsCollectionList = $.slatwall.getService('subscriptionService').getSubscriptionOrderItemCollectionList()/>
		<cfset totalEarningsCollectionList.setDisplayProperties('')/>
		<cfset totalEarningsCollectionList.addDisplayAggregate('subscriptionOrderDeliveryItems.earned','SUM','earnedTotal')/>
		<cfset totalEarningsCollectionList.addDisplayAggregate('orderItem.calculatedItemTotal','SUM','valueTotal')/>
		
		<cfset totalEarningsCollectionList.addFilter('subscriptionUsage.expirationDate',filterDate,'>=')/>
		<cfset totalEarningsCollectionList.addFilter('subscriptionUsage.calculatedCurrentStatus.subscriptionStatusType.systemCode','sstActive')/>
		
		<cfset rc.subscriptionUsageCollectionList.addFilter('expirationDate',filterDateMax,'>=')/>
		<cfset rc.subscriptionUsageCollectionList.addFilter('calculatedCurrentStatus.effectiveDateTime',filterDateMax,'<=')/>
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
		
		<!---total earnings collectionlist--->
		
		<cfif structKeyExists(rc,'subscriptionType') && len(rc.subscriptionType)>
            <cfset rc.subscriptionUsageCollectionList.addFilter('subscriptionOrderItems.subscriptionOrderItemType.systemCode',rc.subscriptionType,'IN')/>
            <cfset totalEarningsCollectionList.addFilter('subscriptionOrderItemType.systemCode',rc.subscriptionType,'IN')/>
    	<cfelse>
    		<cfset rc.subscriptionType = ""/>
        </cfif> 
        <cfif structKeyExists(rc,'productType') && len(rc.productType)>
            <cfset rc.subscriptionUsageCollectionList.addFilter('subscriptionOrderItems.orderItem.sku.product.productType.productTypeID',rc.productType,'IN')/>
            <cfset totalEarningsCollectionList.addFilter('orderItem.sku.product.productType.productTypeID',rc.productType,'IN')/>
        <cfelse>
            <cfset rc.productType = ""/>
        </cfif> 
        <cfif structKeyExists(rc,'productID') && len(rc.productID)>
            <cfset rc.subscriptionUsageCollectionList.addFilter('subscriptionOrderItems.orderItem.sku.product.productID',rc.productID,'IN')/>
            <cfset totalEarningsCollectionList.addFilter('orderItem.sku.product.productID',rc.productID,'IN')/>
        <cfelse>
            <cfset rc.productID = ""/>
        </cfif> 
        <!---as an aggregate will always be one record--->
        <cfif arraylen(totalEarningsCollectionList.getRecords())>
            <cfset totalEarned = totalEarningsCollectionList.getRecords()[1]['earnedTotal']/>
            <cfset totalValue = totalEarningsCollectionList.getRecords()[1]['valueTotal']/>
        <cfelse>
            <cfset totalEarned = 0/>
            <cfset totalValue = 0/>
        </cfif>
        
        
        <cfset deferredRevenueData = $.slatwall.getService('subscriptionService').getDeferredRevenueData(rc.subscriptionType,rc.productType,rc.productID,filterDate,filterDateMax)/>    
        <cfset yearMonthKey = "#rc.reportYear#-#months[reportMonth]#"/>
        <cfset deferredRevenueDataForPeriod = deferredRevenueData[yearMonthKey]/>
        
        
	</cfif>
	
	<hb:HibachiEntityActionBar type="listing" object="#rc.subscriptionUsageSmartList#" showCreate="false"  />
	<cfif structKeyExists(rc,'reportYear') AND structKeyExists(rc,'reportMonth')>
		<div class="container-fluid">
            <div class="col-12">
                <div class="dashboard_sec">
                    <div class="row top_bar">
                        <div class="col-xl-3 col-md-6">
                            <div class="inner orange-bg">
                                <span class="icon"><i class="fa fa-shopping-cart"></i></span>
                                <div class="right_side">
                                    <div class="heading">
                                        <h2>Active Subscriptions</h2>
                                        <span class="value">This Month</span>
                                    </div>
                                    <div class="detail">
                                        <span class="order">#deferredRevenueDataForPeriod['activeSubscriptions']#</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-xl-3 col-md-6">
                            <div class="inner blue-bg">
                                <span class="icon"><i class="fa fa-dollar"></i></span>
                                <div class="right_side">
                                    <div class="heading">
                                        <h2>Earned Revenue</h2>
                                        <span class="value">Up to this Month</span>
                                    </div>
                                    <div class="detail">
                                        <span class="amount">$<strong>#totalEarned#</strong></span>
                                        
                                    </div>
                                </div>
                            </div>
                        </div>
    
                        <div class="col-xl-3 col-md-6">
                            <div class="inner blue-bg">
                                <span class="icon"><i class="fa fa-dollar"></i></span>
                                <div class="right_side">
                                    <div class="heading">
                                        <h2>Deferred Revenue</h2>
                                        <span class="value">Month</span>
                                    </div>
                                    <div class="detail">
                                        <span class="amount">$<strong>#deferredRevenueDataForPeriod['deferredTotal']#</strong></span>
                                        
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-xl-3 col-md-6">
                            <div class="inner blue-bg">
                                <span class="icon"><i class="fa fa-dollar"></i></span>
                                <div class="right_side">
                                    <div class="heading">
                                        <h2>Total Value</h2>
                                        <span class="value"></span>
                                    </div>
                                    <div class="detail">
                                        <span class="amount">$<strong>#totalValue#</strong></span>
                                        
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        
    
                        <!---<div class="col-xl-3 col-md-6">
                            <div class="inner red-bg">
                                <span class="icon"><i class="fa fa-shopping-cart"></i></span>
                                <div class="right_side">
                                    <div class="heading">
                                        <h2>Expiring Subscriptions</h2>
                                        <span class="value">This Month</span>
                                    </div>
                                    <div class="detail">
                                        <span class="order">#deferredRevenueDataForPeriod['expiringSubscriptions']#</span>
                                    </div>
                                </div>
                            </div>
                        </div>--->
                    </div><!-- end of .top_bar -->
                    
                </div><!-- end of .dashboard_sec -->
            </div><!-- end of .col-12 -->
        </div>
    </cfif>
	
	<hb:HibachiListingDisplay 
		collectionList="#rc.subscriptionUsageCollectionList#"
		usingPersonalCollection="true"
		recordEditAction="admin:entity.edit#lcase(rc.subscriptionUsageCollectionList.getCollectionObject())#"
		recordDetailAction="admin:entity.detail#lcase(rc.subscriptionUsageCollectionList.getCollectionObject())#"
	>
	</hb:HibachiListingDisplay>

</cfoutput>
