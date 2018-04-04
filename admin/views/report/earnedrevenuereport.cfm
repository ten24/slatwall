<cfoutput>
    
    <cfset earnedRevenueCollectionList = $.slatwall.getService('HibachiService').getSubscriptionOrderDeliveryItemCollectionList()/>
    <cfset earnedRevenueCollectionList.setDisplayProperties('subscriptionOrderItem.orderItem.order.orderCloseDateTime',{isPeriod=true})/>
    <cfset earnedRevenueCollectionList.addDisplayAggregate('earned','SUM','earnedSUM',false,{isMetric=true})/>
    <cfset earnedRevenueCollectionList.addDisplayAggregate('taxAmount','SUM','taxAmountSUM',false,{isMetric=true})/>
    <cfset earnedRevenueCollectionList.setReportFlag(1)/>
    <cfset earnedRevenueCollectionList.setPeriodInterval('Month')/>
    
    <cfset possibleYearsRecordsCollectionList = $.slatwall.getService('HibachiService').getSubscriptionOrderDeliveryItemCollectionList()/>
    <cfset possibleYearsRecordsCollectionList.setDisplayProperties('subscriptionOrderItem.orderItem.order.orderCloseDateTime',{isPeriod=true})/>
    <cfset possibleYearsRecordsCollectionList.setReportFlag(1)/>
    <cfset possibleYearsRecordsCollectionList.setPeriodInterval('Year')/>
    <cfset possibleYearsRecords = possibleYearsRecordsCollectionList.getRecords()/>
    
    <cfif arraylen(possibleYearsRecords) and !structKeyExists(url,'reportYear')>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(possibleYearsRecords[1]['subscriptionOrderItem_orderItem_order_orderCloseDateTime'],1,1,0,0,0),'>=')/>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(possibleYearsRecords[1]['subscriptionOrderItem_orderItem_order_orderCloseDateTime'],12,31,23,59,59),'<=')/>
    <cfelseif structKeyExists(url,'reportYear')>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(INT(url.reportYear),1,1,0,0,0),'>=')/>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(INT(url.reportYear),12,31,23,59,59),'<=')/>
    </cfif>
    
    <cfset dataRecords = earnedRevenueCollectionList.getRecords()/>
     
    <cfinclude template="./revenuereportcontrols.cfm"/>
    
    <cfset possibleMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']/>
    <cfset earned = []/>
    <cfset taxAmount = []/>
    <cfloop from="1" to="12" index="i">
        <cfset earned[i] = $.slatwall.getService('hibachiUtilityService').formatValue(0,'currency')/>
        <cfset taxAmount[i] = $.slatwall.getService('hibachiUtilityService').formatValue(0,'currency')/>
    </cfloop>
    <cfloop array="#dataRecords#" index="dataRecord">
        <cfset index = INT(right(dataRecord['subscriptionOrderItem_orderItem_order_orderCloseDateTime'],2))/>
        <cfset earned[index] = $.slatwall.getService('hibachiUtilityService').formatValue(dataRecord['earnedSUM'],'currency')/>
        <cfset taxAmount[index] = $.slatwall.getService('hibachiUtilityService').formatValue(dataRecord['taxAmountSUM'],'currency')/>
    </cfloop>
    
    <table class="table table-bordered s-detail-content-table">
        <thead>
            <tr>
                <th></th>
                <cfloop array="#possibleMonths#" index="possibleMonth">
                    <th>
                        #possibleMonth#
                    </th>
                </cfloop>
            </tr>
        </thead>
        <tbody>
            
            <tr>
                <td>Earned Revenue</td>
                <cfloop array="#earned#" index="earnRecord">
                    <td>#earnRecord#</td>
                </cfloop>
            </tr>
            <tr>
                <td>Tax</td>
                <cfloop array="#taxAmount#" index="taxAmountRecord">
                    <td>#taxAmountRecord#</td>
                </cfloop>
            </tr>
        </tbody>
    </table>
</cfoutput>