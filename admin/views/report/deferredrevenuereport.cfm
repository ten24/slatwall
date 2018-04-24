<cfparam name="rc.subscriptionType" default=""/>
<cfparam name="rc.productType" default=""/>
<cfparam name="rc.productID" default=""/>
<cfparam name="rc.reportYear" default=""/>
<cfoutput>
    <cfset slatAction = 'report.deferredRevenueReport'/>
    <!--gets deferred revenue-->
    <cfset deferredRevenueData = $.slatwall.getService('subscriptionService').getDeferredRevenueData(rc.subscriptionType,rc.productType,rc.productID,rc.reportYear)/>    
    
    
    <cfset possibleYearsRecords = []/>
    <cfset currentYear = Year(now())/>
    <cfloop from="#currentYear#" to="#currentYear+10#" index="i">
        <cfset arrayAppend(possibleYearsRecords,i)/>
    </cfloop>
    
    <!---<cfif arraylen(possibleYearsRecords) and !structKeyExists(rc,'reportYear')>
        <cfset deferredRevenueCollectionList.addFilter('orderItem.order.orderCloseDateTime', CreateDateTime(possibleYearsRecords[1],1,1,0,0,0),'>=')/>
        <cfset deferredRevenueCollectionList.addFilter('orderItem.order.orderCloseDateTime', CreateDateTime(possibleYearsRecords[1],12,31,23,59,59),'<=')/>
    <cfelseif structKeyExists(rc,'reportYear')>
        <cfset deferredRevenueCollectionList.addFilter('orderItem.order.orderCloseDateTime', CreateDateTime(INT(rc.reportYear),1,1,0,0,0),'>=')/>
        <cfset deferredRevenueCollectionList.addFilter('orderItem.order.orderCloseDateTime', CreateDateTime(INT(rc.reportYear),12,31,23,59,59),'<=')/>
    </cfif>--->
    
    <cfset possibleMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']/>
    
    <cfinclude template="./revenuereportcontrols.cfm"/>
    
    <cfset dataRecords = []/>
     
    <cfset deferredRevenue = []/>
    <cfset deferredTaxAmount = []/>
    <cfloop from="1" to="12" index="i">
        <cfset deferredRevenue[i] = $.slatwall.getService('hibachiUtilityService').formatValue(0,'currency')/>
        <cfset deferredTaxAmount[i] = $.slatwall.getService('hibachiUtilityService').formatValue(0,'currency')/>
    </cfloop>
    <cfloop array="#dataRecords#" index="dataRecord">
        <cfset index = INT(right(dataRecord['orderItem_order_orderCloseDateTime'],2))/>
        <cfset deferredTaxAmount[index] = $.slatwall.getService('hibachiUtilityService').formatValue(dataRecord['deferredTaxAmountSUM'],'currency')/>
        <cfset deferredRevenue[index] = $.slatwall.getService('hibachiUtilityService').formatValue(dataRecord['deferredRevenueSUM'],'currency')/>
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
                <td>Deferred Revenue</td>
                <cfloop array="#deferredRevenue#" index="deferredRevenueRecord">
                    <td>#deferredRevenueRecord#</td>
                </cfloop>
            </tr>
            <tr>
                <td>Deferred Tax</td>
                <cfloop array="#deferredTaxAmount#" index="deferredTaxAmountRecord">
                    <td>#deferredTaxAmountRecord#</td>
                </cfloop>
            </tr>
        </tbody>
    </table>
</cfoutput>