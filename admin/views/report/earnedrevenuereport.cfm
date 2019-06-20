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
    <cfset earnedRevenueCollectionList = $.slatwall.getService('HibachiService').getSubscriptionOrderDeliveryItemCollectionList()/>
    <cfset earnedRevenueCollectionList.setDisplayProperties('createdDateTime',{isPeriod=true})/>
    <cfset earnedRevenueCollectionList.addDisplayAggregate('earned','SUM','earnedSUM',false,{isMetric=true})/>
    <cfset earnedRevenueCollectionList.addDisplayAggregate('taxAmount','SUM','taxAmountSUM',false,{isMetric=true})/>
    <cfset earnedRevenueCollectionList.addDisplayAggregate('subscriptionOrderItem.subscriptionUsage.subscriptionUsageID','COUNT','subscriptionUsageCount',true,{isMetric=true})/>
    <cfset earnedRevenueCollectionList.setReportFlag(1)/>
    <cfset earnedRevenueCollectionList.setPeriodInterval('Month')/>
    <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderDeliveryItemType.systemCode','soditDelivered')/>
    <cfset earnedRevenueCollectionList.addFilter('quantity',1,">=",'AND','SUM')/>
    <cfset earnedRevenueCollectionList.addFilter('createdDateTime', CreateDateTime(Year(rc.minDate),Month(rc.minDate),Day(rc.minDate),0,0,0),'>=')/>
    <cfset earnedRevenueCollectionList.addFilter('createdDateTime', CreateDateTime(Year(rc.maxDate),Month(rc.maxDate),Day(rc.maxDate),23,59,59),'<=')/>
    
    
    <!---Collection list for refunded items--->
    <cfset refundedRevenueCollectionList = $.slatwall.getService('HibachiService').getSubscriptionOrderDeliveryItemCollectionList()/>
    <cfset refundedRevenueCollectionList.setDisplayProperties('createdDateTime',{isPeriod=true})/>
    <cfset refundedRevenueCollectionList.addDisplayAggregate('earned','SUM','earnedSUM',false,{isMetric=true})/>
    <cfset refundedRevenueCollectionList.addDisplayAggregate('taxAmount','SUM','taxAmountSUM',false,{isMetric=true})/>
    <cfset refundedRevenueCollectionList.addDisplayAggregate('subscriptionOrderItem.subscriptionUsage.subscriptionUsageID','COUNT','subscriptionUsageCount',true,{isMetric=true})/>
    <cfset refundedRevenueCollectionList.setReportFlag(1)/>
    <cfset refundedRevenueCollectionList.setPeriodInterval('Month')/>
    <cfset refundedRevenueCollectionList.addFilter('quantity',1,">=",'AND','SUM')/>
    <cfset refundedRevenueCollectionList.addFilter('subscriptionOrderDeliveryItemType.systemCode','soditRefunded')/>
    <cfset refundedRevenueCollectionList.addFilter('createdDateTime', CreateDateTime(Year(rc.minDate),Month(rc.minDate),Day(rc.minDate),0,0,0),'>=')/>
    <cfset refundedRevenueCollectionList.addFilter('createdDateTime', CreateDateTime(Year(rc.maxDate),Month(rc.maxDate),Day(rc.maxDate),23,59,59),'<=')/>
    
    <!---used to determine when to end the loop--->
    <cfset currentMonth = Month(rc.maxDate)/>
    
    <!--apply filters-->
    
    
    <cfif structKeyExists(rc,'productType') and len(rc.productType)>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.sku.product.productType.productTypeID', rc.productType,'IN')/>
        <cfset refundedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.sku.product.productType.productTypeID', rc.productType,'IN')/>
    </cfif>
    
    <cfif structKeyExists(rc,'productID') and len(rc.productID)>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.sku.product.productID', rc.productID,'IN')/>
        <cfset refundedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.sku.product.productID', rc.productID,'IN')/>
    </cfif>
    
    <cfif structKeyExists(rc,'subscriptionType') and len(rc.subscriptionType)>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.subscriptionOrderItemType.systemCode', rc.subscriptionType,'IN')/>
        <cfset refundedRevenueCollectionList.addFilter('subscriptionOrderItem.subscriptionOrderItemType.systemCode', rc.subscriptionType,'IN')/>
    </cfif>
    
    <cfset earnedDataRecords = earnedRevenueCollectionList.getRecords()/>
    <cfset refundedDataRecords = refundedRevenueCollectionList.getRecords()/>
    <cfset possibleMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']/>
    
    <cfinclude template="./revenuereportcontrols.cfm"/>
    
    <cfset currentMonth = Month(rc.minDate)/>
    
	<cfset currentYear = Year(rc.minDate)/>
	
	<cfset monthbegin = createDateTime(Year(rc.minDate),Month(rc.minDate),DaysInMonth(rc.minDate),0,0,0)/>
    <cfset monthend = createDateTime(Year(rc.maxDate),Month(rc.maxDate),DaysInMonth(rc.maxDate),23,59,59)/>
	<cfset diff = DateDiff('m',monthbegin,monthend)/>
	<cfset to = currentMonth + diff/>
	
    <cfset subscriptionsEarning = []/>
    <cfset earned = []/>
    <cfset taxAmount = []/>
    <cfset refunded = []/>
    <cfset refundedTaxAmount = []/>
    <cfset possibleYearTotal = []/>
    <cfloop from="1" to="#to-currentMonth+1#" index="i">
        <cfset subscriptionsEarning[i] = 0/>
        <cfset earned[i] = 0/>
        <cfset taxAmount[i] = 0/>
        <cfset refunded[i] = 0/>
        <cfset refundedTaxAmount[i] = 0/>
        <cfset possibleYearTotal[i] = 0/>
    </cfloop>
    
    <cfloop array="#earnedDataRecords#" index="dataRecord">
        <cfset index = DateDiff('m',rc.minDate,dataRecord['createdDateTime'])+1/>
        <cfset subscriptionsEarning[index] = dataRecord['subscriptionUsageCount']/>
        <cfset earned[index] = dataRecord['earnedSUM']/>
        <cfset taxAmount[index] = dataRecord['taxAmountSUM']/>
    </cfloop>
    <!---subtract refunds--->
    <cfloop array="#refundedDataRecords#" index="dataRecord">
        <cfset index = DateDiff('m',rc.minDate,dataRecord['createdDateTime'])+1/>
        <cfset refunded[index] = dataRecord['earnedSUM']/>
        <cfset refundedTaxAmount[index] = dataRecord['taxAmountSUM']/>
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
                <td>Subscriptions Earning</td>
                <cfset totalSubscriptionsEarning=0/>
                <cfloop array="#subscriptionsEarning#" index="subscriptionsEarningRecord">
                    <td>#subscriptionsEarningRecord#</td>
                    <cfset totalSubscriptionsEarning += subscriptionsEarningRecord/>
                </cfloop>
                <td>#totalSubscriptionsEarning#</td>
            </tr>
            <tr>
                <td>Earned Revenue</td>
                <cfset totalEarnedRevenue=0/>
                <cfloop array="#earned#" index="earnRecord">
                    <td>#$.slatwall.getService('hibachiUtilityService').formatValue(earnRecord,'currency')#</td>
                    <cfset totalEarnedRevenue+=earnRecord/>
                </cfloop>
                <td>#$.slatwall.getService('HibachiUtilityService').formatValue(totalEarnedRevenue,'currency')#</td>
            </tr>
            <tr>
                <td>Tax</td>
                <cfset totalTax=0/>
                <cfloop array="#taxAmount#" index="taxAmountRecord">
                    <td>#$.slatwall.getService('hibachiUtilityService').formatValue(taxAmountRecord,'currency')#</td>
                    <cfset totalTax+=taxAmountRecord/>
                </cfloop>
                <td>#$.slatwall.getService('HibachiUtilityService').formatValue(totalTax,'currency')#</td>
            </tr>
             <tr>
                <td>Refunded Revenue</td>
                <cfset totalRefunded = 0/>
                <cfloop array="#refunded#" index="refundRecord">
                    <td>#$.slatwall.getService('hibachiUtilityService').formatValue(refundRecord,'currency')#</td>
                    <cfset totalRefunded += refundRecord/>
                </cfloop>
                <td>#$.slatwall.getService('HibachiUtilityService').formatValue(totalRefunded,'currency')#</td>
            </tr>
            <tr>
                <td>Refunded Tax</td>
                <cfset totalRefundedTax = 0/>
                <cfloop array="#refundedTaxAmount#" index="refundedTaxAmountRecord">
                    <td>#$.slatwall.getService('hibachiUtilityService').formatValue(refundedTaxAmountRecord,'currency')#</td>
                    <cfset totalRefundedTax += refundedTaxAmountRecord/>
                </cfloop>
                
                <td>#$.slatwall.getService('HibachiUtilityService').formatValue(totalRefundedTax,'currency')#</td>
            </tr>
            <tr>
                <td>Total</td>
                <cfset TotalEarned = 0/>
                <cfloop from="1" to="#arraylen(taxAmount)#" index="i">
                    <cfset total = earned[i]+taxAmount[i]-refunded[i]-refundedTaxAmount[i]/>
                    <td>#$.slatwall.getService('HibachiUtilityService').formatValue(total,'currency')#</td>
                    <cfset TotalEarned += total/>
                </cfloop>
                <td>#$.slatwall.getService('HibachiUtilityService').formatValue(TotalEarned,'currency')#</td>
            </tr>
            
        </tbody>
    </table>
    <cfif showProducts>
        <cfinclude template="./earnedrevenuereportproducts.cfm"/>
    </cfif>
</cfoutput>