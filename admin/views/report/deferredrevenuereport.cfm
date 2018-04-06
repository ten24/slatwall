<cfoutput>
    <!--gets earned revenue for the year-->
    <cfset earnedRevenueCollectionList = $.slatwall.getService('HibachiService').getSubscriptionOrderDeliveryItemCollectionList()/>
    <cfset earnedRevenueCollectionList.setDisplayProperties('earned,taxAmount')/>
    
    <!--gets deferred revenue-->
    <cfset deferredRevenueCollectionList = $.slatwall.getService('HibachiService').getSubscriptionOrderDeliveryItemCollectionList()/>
    <cfset deferredRevenueCollectionList.setDisplayProperties('subscriptionOrderItem.orderItem.order.orderCloseDateTime',{isPeriod=true})/>
    <cfset deferredRevenueCollectionList.addDisplayAggregate('earned','SUM','earnedSUM',false,{isMetric=true})/>
    <cfset deferredRevenueCollectionList.addDisplayAggregate('taxAmount','SUM','taxAmountSUM',false,{isMetric=true})/>
    <cfset deferredRevenueCollectionList.setReportFlag(1)/>
    <cfset deferredRevenueCollectionList.setPeriodInterval('Month')/>
    
    <cfset possibleYearsRecordsCollectionList = $.slatwall.getService('HibachiService').getSubscriptionOrderDeliveryItemCollectionList()/>
    <cfset possibleYearsRecordsCollectionList.setDisplayProperties('subscriptionOrderItem.orderItem.order.orderCloseDateTime',{isPeriod=true})/>
    <cfset possibleYearsRecordsCollectionList.setReportFlag(1)/>
    <cfset possibleYearsRecordsCollectionList.setPeriodInterval('Year')/>
    <cfset possibleYearsRecords = possibleYearsRecordsCollectionList.getRecords()/>
    
    <cfif arraylen(possibleYearsRecords) and !structKeyExists(rc,'reportYear')>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(possibleYearsRecords[1]['subscriptionOrderItem_orderItem_order_orderCloseDateTime'],1,1,0,0,0),'>=')/>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(possibleYearsRecords[1]['subscriptionOrderItem_orderItem_order_orderCloseDateTime'],12,31,23,59,59),'<=')/>
    <cfelseif structKeyExists(rc,'reportYear')>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(INT(rc.reportYear),1,1,0,0,0),'>=')/>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(INT(rc.reportYear),12,31,23,59,59),'<=')/>
    </cfif>
    
    <cfset earnedRevenueData = earnedRevenueCollectionList.getRecordsCountData()/>
    
    <cfinclude template="./revenuereportcontrols.cfm"/>
    
    <cfset dataRecords = deferredRevenueCollectionList.getRecords()/>
     
    <div id="u119_state0" class="panel_state" data-label="State1" style="">
        <div id="u119_state0_content" class="panel_state_content">
            <!-- Unnamed (Droplist) -->
            <!---<div id="u122" class="ax_default droplist">
                <select id="u122_input" style="-webkit-appearance: menulist-button;">
                    <cfloop array="#possibleYearsRecords#" index="possibleYearsRecord">
                        <option value="#possibleYearsRecord['subscriptionOrderItem_orderItem_order_orderCloseDateTime']#">#possibleYearsRecord['subscriptionOrderItem_orderItem_order_orderCloseDateTime']#</option>
                    </cfloop>
                </select>
            </div>--->
            <div id="u122" class="ax_default droplist">
                <select id="u122_input" style="-webkit-appearance: menulist-button;">
                    <cfloop array="#possibleYearsRecords#" index="possibleYearsRecord">
                        <option value="#possibleYearsRecord['subscriptionOrderItem_orderItem_order_orderCloseDateTime']#">#possibleYearsRecord['subscriptionOrderItem_orderItem_order_orderCloseDateTime']#</option>
                    </cfloop>
                </select>
            </div>
    
            <!-- Button (Rectangle) -->
            <div id="u123" class="ax_default shape" data-label="Button" style="cursor: pointer;">
                <div id="u123_div" class="" tabindex="0"></div>
                <div id="u123_text" class="text ">
                    <p id="cache0" style=""><span id="cache1" style="">Apply</span></p>
                </div>
            </div>
        </div>
    </div>
    
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
                <td>Tax</td>
                <cfloop array="#taxAmount#" index="taxAmountRecord">
                    <td>#taxAmountRecord#</td>
                </cfloop>
            </tr>
        </tbody>
    </table>
</cfoutput>