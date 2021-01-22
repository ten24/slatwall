<cfparam name="rc.subscriptionType" default=""/>
<cfparam name="rc.productType" default=""/>
<cfparam name="rc.productID" default=""/>
<cfparam name="rc.minDate" default="#CreateDate(Year(now()),1,1)#"/>
<cfparam name="rc.maxDate" default="#CreateDate(Year(now()),Month(now()),Day(now()))#"/>
<cfparam name="showProducts" default="true"/>
<cfoutput>
    
    <cfset slatAction = 'report.earnedRevenueReport'/>
    <!---<cfset earningSubscriptionsCollectionList = $.slatwall.getService('HibachiService').getSubscriptionUsageCollectionList()/>
    <cfset earningSubscriptionsCollectionList.setReportFlag(1)/>
    <cfset earningSubscriptionsCollectionList.setPeriodInterval('Month')/>
    <cfset earningSubscriptionsCollectionList.setDisplayProperties()--->
    
    <!---collection list for delivered items--->
    <cfset newOrdersCollectionList = $.slatwall.getService('HibachiService').getSubscriptionOrderItemCollectionList()/>
    <cfset newOrdersCollectionList.setDisplayProperties('createdDateTime',{isPeriod=true})/>
    <cfset newOrdersCollectionList.addDisplayAggregate('subscriptionOrderItemID','COUNT','subscriptionOrderItemCount',false,{isMetric=true})/>
    <cfset newOrdersCollectionList.setReportFlag(1)/>
    <cfset newOrdersCollectionList.setPeriodInterval('Month')/>
    <cfset newOrdersCollectionList.addFilter('createdDateTime', CreateDateTime(Year(rc.minDate),Month(rc.minDate),Day(rc.minDate),0,0,0),'>=')/>
    <cfset newOrdersCollectionList.addFilter('createdDateTime', CreateDateTime(Year(rc.maxDate),Month(rc.maxDate),Day(rc.maxDate),23,59,59),'<=')/>
    <!---used to determine when to end the loop--->
    <cfset currentMonth = Month(rc.maxDate)/>
    
    <!--apply filters-->
    
    
    <cfif structKeyExists(rc,'productType') and len(rc.productType)>
        <cfset newOrdersCollectionList.addFilter('orderItem.sku.product.productType.productTypeID', rc.productType,'IN')/>
    </cfif>
    
    <cfif structKeyExists(rc,'productID') and len(rc.productID)>
        <cfset newOrdersCollectionList.addFilter('orderItem.sku.product.productID', rc.productID,'IN')/>
    </cfif>
    
    <cfif structKeyExists(rc,'subscriptionType') and len(rc.subscriptionType)>
        <cfset newOrdersCollectionList.addFilter('subscriptionOrderItemType.systemCode', rc.subscriptionType,'IN')/>
    </cfif>
    
    <cfset newOrdersDataRecords = newOrdersCollectionList.getRecords()/>
    <cfset possibleMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']/>
    
    <cfinclude template="./revenuereportcontrols.cfm"/>
    
    <cfset currentMonth = Month(rc.minDate)/>
    
	<cfset currentYear = Year(rc.minDate)/>
	
	<cfset monthbegin = createDateTime(Year(rc.minDate),Month(rc.minDate),DaysInMonth(rc.minDate),0,0,0)/>
    <cfset monthend = createDateTime(Year(rc.maxDate),Month(rc.maxDate),DaysInMonth(rc.maxDate),23,59,59)/>
	<cfset diff = DateDiff('m',monthbegin,monthend)/>
	<cfset to = currentMonth + diff/>
	
    <cfset subscriptionOrderItemCount = []/>
    <cfloop from="1" to="#to-currentMonth+1#" index="i">
        <cfset subscriptionOrderItemCount[i] = 0/>
    </cfloop>
    
    <cfloop array="#newOrdersDataRecords#" index="dataRecord">
        <cfset index = DateDiff('m',rc.minDate,dataRecord['createdDateTime'])+1/>
        <cfset subscriptionOrderItemCount[index] = dataRecord['subscriptionOrderItemCount']/>
    </cfloop>
    <table class="table table-bordered s-detail-content-table">
        <thead>
            <tr>
                <th></th>
                <cfloop from="#currentMonth-1#" to="#to-1#" index="w">
                    <cfif w % 12 eq 0 and w neq 0 >
                        <cfset currentYear++/>
                    </cfif>
                    <th>
                        #possibleMonths[w%12+1]# - #currentYear#
                    </th>
                </cfloop>
                <th>
                    Total
                </th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>New Subscriptions</td>
                <cfset totalSubscriptionOrderItemCount=0/>
                <cfloop array="#subscriptionOrderItemCount#" index="subscriptionOrderItemCountRecord">
                    <td>#subscriptionOrderItemCountRecord#</td>
                    <cfset totalSubscriptionOrderItemCount += subscriptionOrderItemCountRecord/>
                </cfloop>
                <td>#totalSubscriptionOrderItemCount#</td>
            </tr>
            
        </tbody>
    </table>
</cfoutput>