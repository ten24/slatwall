<cfparam name="rc.subscriptionType" default=""/>
<cfparam name="rc.productType" default=""/>
<cfparam name="rc.productID" default=""/>
<cfparam name="rc.reportYear" default="#Year(now())#"/>
<cfoutput>
    
    <cfset slatAction = 'report.earnedRevenueReport'/>
    <!---<cfset earningSubscriptionsCollectionList = $.slatwall.getService('HibachiService').getSubscriptionUsageCollectionList()/>
    <cfset earningSubscriptionsCollectionList.setReportFlag(1)/>
    <cfset earningSubscriptionsCollectionList.setPeriodInterval('Month')/>
    <cfset earningSubscriptionsCollectionList.setDisplayProperties()--->
    
    <!---collection list for delivered items--->
    <cfset earnedRevenueCollectionList = $.slatwall.getService('HibachiService').getSubscriptionOrderDeliveryItemCollectionList()/>
    <cfset earnedRevenueCollectionList.setDisplayProperties('createdDateTime',{isPeriod=true})/>
    <cfset earnedRevenueCollectionList.addDisplayProperty('subscriptionOrderDeliveryItemType.systemCode')/>
    <cfset earnedRevenueCollectionList.addDisplayAggregate('earned','SUM','earnedSUM',false,{isMetric=true})/>
    <cfset earnedRevenueCollectionList.addDisplayAggregate('taxAmount','SUM','taxAmountSUM',false,{isMetric=true})/>
    <cfset earnedRevenueCollectionList.addDisplayAggregate('subscriptionOrderItem.subscriptionUsage.subscriptionUsageID','COUNT','subscriptionUsageCount',true,{isMetric=true})/>
    <cfset earnedRevenueCollectionList.setReportFlag(1)/>
    <cfset earnedRevenueCollectionList.setPeriodInterval('Month')/>
    <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderDeliveryItemType.systemCode','soidtDelivered')/>
    
    <!---Collection list for refunded items--->
    <cfset refundedRevenueCollectionList = $.slatwall.getService('HibachiService').getSubscriptionOrderDeliveryItemCollectionList()/>
    <cfset refundedRevenueCollectionList.setDisplayProperties('createdDateTime',{isPeriod=true})/>
    <cfset refundedRevenueCollectionList.addDisplayProperty('subscriptionOrderDeliveryItemType.systemCode')/>
    <cfset refundedRevenueCollectionList.addDisplayAggregate('earned','SUM','earnedSUM',false,{isMetric=true})/>
    <cfset refundedRevenueCollectionList.addDisplayAggregate('taxAmount','SUM','taxAmountSUM',false,{isMetric=true})/>
    <cfset refundedRevenueCollectionList.addDisplayAggregate('subscriptionOrderItem.subscriptionUsage.subscriptionUsageID','COUNT','subscriptionUsageCount',true,{isMetric=true})/>
    <cfset refundedRevenueCollectionList.setReportFlag(1)/>
    <cfset refundedRevenueCollectionList.setPeriodInterval('Month')/>
    <cfset refundedRevenueCollectionList.addFilter('subscriptionOrderDeliveryItemType.systemCode','soidtRefunded')/>
    
    <cfset possibleYearsRecordsCollectionList = $.slatwall.getService('HibachiService').getSubscriptionOrderDeliveryItemCollectionList()/>
    <cfset possibleYearsRecordsCollectionList.setDisplayProperties('createdDateTime',{isPeriod=true})/>
    <cfset possibleYearsRecordsCollectionList.setReportFlag(1)/>
    <cfset possibleYearsRecordsCollectionList.setPeriodInterval('Year')/>
    <cfset possibleYearsData = possibleYearsRecordsCollectionList.getRecords()/>
    
    <cfset possibleYearsRecords = []/>
    <cfloop array="#possibleYearsData#" index="possibleYearDataRecord">
        <cfset arrayAppend(possibleYearsRecords,possibleYearDataRecord['createdDateTime'])/>
    </cfloop>
    <!---used to determine when to end the loop--->
    <cfset currentMonth = 12/>
    <cfif Year(now()) eq rc.reportYear>
        <cfset currentMonth = Month(now())/>
    </cfif>
    
    <!--apply filters-->
    <cfif arraylen(possibleYearsRecords) and !structKeyExists(rc,'reportYear')>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(possibleYearsRecords[1],1,1,0,0,0),'>=')/>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(possibleYearsRecords[1],12,31,23,59,59),'<=')/>
        
        <cfset refundedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(possibleYearsRecords[1],1,1,0,0,0),'>=')/>
        <cfset refundedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(possibleYearsRecords[1],12,31,23,59,59),'<=')/>
    <cfelseif structKeyExists(rc,'reportYear')>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(INT(rc.reportYear),1,1,0,0,0),'>=')/>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(INT(rc.reportYear),12,31,23,59,59),'<=')/>
        
        <cfset refundedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(INT(rc.reportYear),1,1,0,0,0),'>=')/>
        <cfset refundedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(INT(rc.reportYear),12,31,23,59,59),'<=')/>
    </cfif>
    
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
    
    <cfset subscriptionsEarning = []/>
    <cfset earned = []/>
    <cfset taxAmount = []/>
    <cfset possibleYearTotal = []/>
    <cfloop from="1" to="#currentMonth#" index="i">
        <cfset subscriptionsEarning[i] = 0/>
        <cfset earned[i] = 0/>
        <cfset taxAmount[i] = 0/>
        <cfset possibleYearTotal[i] = 0/>
    </cfloop>
    <cfloop array="#earnedDataRecords#" index="dataRecord">
        <cfset index = INT(right(dataRecord['createdDateTime'],2))/>
        <cfset subscriptionsEarning[index] = dataRecord['subscriptionUsageCount']/>
        <cfset earned[index] = dataRecord['earnedSUM']/>
        <cfset taxAmount[index] = dataRecord['taxAmountSUM']/>
    </cfloop>
    <!---subtract refunds--->
    <cfloop array="#refundedDataRecords#" index="dataRecord">
        <cfset index = INT(right(dataRecord['createdDateTime'],2))/>
        <cfset earned[index] -= dataRecord['earnedSUM']/>
        <cfset taxAmount[index] -= dataRecord['taxAmountSUM']/>
    </cfloop>
    
    <table class="table table-bordered s-detail-content-table">
        <thead>
            <tr>
                <th>Created Date Time</th>
                <cfloop from="1" to="#currentMonth#" index="w">
                    <th>
                        #possibleMonths[w]#
                    </th>
                </cfloop>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Subscriptions Earning</td>
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
        <cfset subscriptionOrderItemList.addFilter('orderItem.order.orderCloseDateTime', CreateDateTime(possibleYearsRecords[1],1,1,0,0,0),'>=')/>
        <cfset subscriptionOrderItemList.addFilter('orderItem.order.orderCloseDateTime', CreateDateTime(possibleYearsRecords[1],12,31,23,59,59),'<=')/>
    <cfelseif structKeyExists(url,'reportYear')>
        <cfset subscriptionOrderItemList.addFilter('orderItem.order.orderCloseDateTime', CreateDateTime(INT(url.reportYear),1,1,0,0,0),'>=')/>
        <cfset subscriptionOrderItemList.addFilter('orderItem.order.orderCloseDateTime', CreateDateTime(INT(url.reportYear),12,31,23,59,59),'<=')/>
    </cfif>
    <cfset subscriptionOrderItemList.addGroupBy('orderItem.sku.product.productName')/>
    <cfset productsWithDeliveries = subscriptionOrderItemList.getPageRecords()/>
    
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
        <cfloop from="1" to="#currentMonth#" index="i">
            <cfset productsWithDeliveriesMap[productName].subscriptionsEarning[i] = 0/>
            <cfset productsWithDeliveriesMap[productName].earned[i] = 0/>
            <cfset productsWithDeliveriesMap[productName].taxAmount[i] = 0/>
        </cfloop>
        
    </cfloop>
    
    <cfloop array="#dataRecords#" index="dataRecord">
        <cfset productName = dataRecord['subscriptionOrderItem_orderItem_sku_product_productName']/>
        <cfset index = INT(right(dataRecord['createdDateTime'],2))/>
        <cfset productsWithDeliveriesMap[productName].subscriptionsEarning[index] = dataRecord['subscriptionUsageCount']/>
        <cfset productsWithDeliveriesMap[productName].earned[index] = dataRecord['earnedSUM']/>
        <cfset productsWithDeliveriesMap[productName].taxAmount[index] = dataRecord['taxAmountSUM']/>
    </cfloop>
    
    
    
    <table class="table table-bordered s-detail-content-table">
        <thead>
            <tr>
                <th>Created Date Time</th>
                <cfloop from="1" to="#currentMonth#" index="w">
                    <th>
                        #possibleMonths[w]#
                    </th>
                </cfloop>
            </tr>
        </thead>
        <tbody>
            
            <cfloop collection="#productsWithDeliveriesMap#" item="productName">
                <tr>
                    <td>#productName#</td>
                    <cfloop from="1" to="#arrayLen(productsWithDeliveriesMap[productName].earned)#" index="i">
                        
                        <td>#$.slatwall.getService('hibachiUtilityService').formatValue(productsWithDeliveriesMap[productName].earned[i],'currency')#</td>
                        <cfset possibleYearTotal[i]+=productsWithDeliveriesMap[productName].earned[i]/>
                    </cfloop>
                </tr>
            </cfloop>
            <tr>
                <td>Total</td>
                <cfloop array="#possibleYearTotal#" index="possibleYearTotalRecord">
                    <td>#$.slatwall.getService('hibachiUtilityService').formatValue(possibleYearTotalRecord,'currency')#</td>
                </cfloop>
            </tr>
        </tbody>
    </table>
    
</cfoutput>