<cfoutput>
    
    <!---<cfset earningSubscriptionsCollectionList = $.slatwall.getService('HibachiService').getSubscriptionUsageCollectionList()/>
    <cfset earningSubscriptionsCollectionList.setReportFlag(1)/>
    <cfset earningSubscriptionsCollectionList.setPeriodInterval('Month')/>
    <cfset earningSubscriptionsCollectionList.setDisplayProperties()--->
    
    <cfset earnedRevenueCollectionList = $.slatwall.getService('HibachiService').getSubscriptionOrderDeliveryItemCollectionList()/>
    <cfset earnedRevenueCollectionList.setDisplayProperties('subscriptionOrderItem.orderItem.order.orderCloseDateTime',{isPeriod=true})/>
    <cfset earnedRevenueCollectionList.addDisplayAggregate('earned','SUM','earnedSUM',false,{isMetric=true})/>
    <cfset earnedRevenueCollectionList.addDisplayAggregate('taxAmount','SUM','taxAmountSUM',false,{isMetric=true})/>
    <cfset earnedRevenueCollectionList.addDisplayAggregate('subscriptionOrderItem.subscriptionUsage.subscriptionUsageID','COUNT','subscriptionUsageCount',true,{isMetric=true})/>
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
    <cfset subscriptionsEarning = []/>
    <cfset earned = []/>
    <cfset taxAmount = []/>
    <cfloop from="1" to="12" index="i">
        <cfset subscriptionsEarning[i] = 0/>
        <cfset earned[i] = 0/>
        <cfset taxAmount[i] = 0/>
    </cfloop>
    <cfloop array="#dataRecords#" index="dataRecord">
        <cfset index = INT(right(dataRecord['subscriptionOrderItem_orderItem_order_orderCloseDateTime'],2))/>
        <cfset subscriptionsEarning[index] = dataRecord['subscriptionUsageCount']/>
        <cfset earned[index] = dataRecord['earnedSUM']/>
        <cfset taxAmount[index] = dataRecord['taxAmountSUM']/>
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
                <td>Subscription Earnings</td>
                <cfloop array="#subscriptionsEarning#" index="subscriptionsEarningRecord">
                    <td>#subscriptionsEarningRecord#</td>
                </cfloop>
            </tr>
            <tr>
                <td>Earned Revenue</td>
                <cfloop array="#earned#" index="earnRecord">
                    <td>#$.slatwall.getService('hibachiUtilityService').formatValue(earnRecord,'currency')#</td>
                </cfloop>
            </tr>
            <tr>
                <td>Tax</td>
                <cfloop array="#taxAmount#" index="taxAmountRecord">
                    <td>#$.slatwall.getService('hibachiUtilityService').formatValue(taxAmountRecord,'currency')#</td>
                </cfloop>
            </tr>
            <tr>
                <td>Total</td>
                <cfloop from="1" to="#arraylen(taxAmount)#" index="i">
                    <td>#$.slatwall.getService('HibachiUtilityService').formatValue(earned[i]+taxAmount[i],'currency')#</td>
                </cfloop>
            </tr>
        </tbody>
    </table>
    
    <!--start productReport-->
    
    <cfset subscriptionOrderItemList = $.slatwall.getService('HibachiService').getSubscriptionOrderItemCollectionList()/>
    <cfset subscriptionOrderItemList.setDisplayProperties('orderItem.sku.product.productName')/>
    
    <cfset subscriptionOrderItemList.addFilter('subscriptionOrderDeliveryItems.quantity',1,">=",'AND','SUM')/>
    <cfif arraylen(possibleYearsRecords) and !structKeyExists(url,'reportYear')>
        <cfset subscriptionOrderItemList.addFilter('orderItem.order.orderCloseDateTime', CreateDateTime(possibleYearsRecords[1]['subscriptionOrderItem_orderItem_order_orderCloseDateTime'],1,1,0,0,0),'>=')/>
        <cfset subscriptionOrderItemList.addFilter('orderItem.order.orderCloseDateTime', CreateDateTime(possibleYearsRecords[1]['subscriptionOrderItem_orderItem_order_orderCloseDateTime'],12,31,23,59,59),'<=')/>
    <cfelseif structKeyExists(url,'reportYear')>
        <cfset subscriptionOrderItemList.addFilter('orderItem.order.orderCloseDateTime', CreateDateTime(INT(url.reportYear),1,1,0,0,0),'>=')/>
        <cfset subscriptionOrderItemList.addFilter('orderItem.order.orderCloseDateTime', CreateDateTime(INT(url.reportYear),12,31,23,59,59),'<=')/>
    </cfif>
    <cfset subscriptionOrderItemList.addGroupBy('orderItem.sku.product.productName')/>
    <cfset productsWithDeliveries = subscriptionOrderItemList.getRecords()/>
    
    
    <cfset earnedRevenueCollectionList.addDisplayProperty('subscriptionOrderItem.orderItem.sku.product.productName',javacast('null',''),{isVisible=true})/>
    <cfset earnedRevenueCollectionList.setOrderBy('subscriptionOrderItem.orderItem.sku.product.productName')/>
    <cfset dataRecords = earnedRevenueCollectionList.getRecords(true)/>
    
    <cfset productsWithDeliveriesMap = {}/>
    
    <cfloop array="#productsWithDeliveries#" index="productWithDelivery">
        <cfset productName = productWithDelivery['orderitem_sku_product_productName']/>
        <cfset productsWithDeliveriesMap[productName] = {
            subscriptionsEarning = [],
            earned = [],
            taxAmount = []
        }/>
        <cfloop from="1" to="12" index="i">
            <cfset productsWithDeliveriesMap[productName].subscriptionsEarning[i] = 0/>
            <cfset productsWithDeliveriesMap[productName].earned[i] = 0/>
            <cfset productsWithDeliveriesMap[productName].taxAmount[i] = 0/>
        </cfloop>
        
    </cfloop>
    
    <cfloop array="#dataRecords#" index="dataRecord">
        <cfset productName = dataRecord['subscriptionOrderItem_orderItem_sku_product_productName']/>
        <cfset index = INT(right(dataRecord['subscriptionOrderItem_orderItem_order_orderCloseDateTime'],2))/>
        <cfset productsWithDeliveriesMap[productName].subscriptionsEarning[index] = dataRecord['subscriptionUsageCount']/>
        <cfset productsWithDeliveriesMap[productName].earned[index] = dataRecord['earnedSUM']/>
        <cfset productsWithDeliveriesMap[productName].taxAmount[index] = dataRecord['taxAmountSUM']/>
    </cfloop>
    
    <cfset possibleYearTotal []/>
    
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
            <cfloop collection="#productsWithDeliveriesMap#" item="productName">
                <tr>
                    <td>#productName#</td>
                    <cfloop array="#productsWithDeliveriesMap[productName].earned#" index="earnRecord">
                        <td>#$.slatwall.getService('hibachiUtilityService').formatValue(earnRecord,'currency')#</td>
                    </cfloop>
                </tr>
            </cfloop>
            <tr>
                <td>Total</td>
                <cfloop array="#possibleYearTotal#" index="possibleYearTotalRecord">
                    <td>#possibleYearTotalRecord#</td>
                </cfloop>
            </tr>
        </tbody>
    </table>
    
</cfoutput>