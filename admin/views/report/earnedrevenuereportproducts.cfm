<cfoutput>
    
    <!--start productReport-->
    
    <cfset subscriptionOrderItemList = $.slatwall.getService('HibachiService').getSubscriptionOrderItemCollectionList()/>
    <cfset subscriptionOrderItemList.setDisplayProperties('orderItem.sku.product.productName')/>
    
    <cfset subscriptionOrderItemList.addFilter('subscriptionOrderDeliveryItems.quantity',1,">=",'AND','SUM')/>
    <cfset subscriptionOrderItemList.addFilter('subscriptionOrderDeliveryItems.createdDateTime', CreateDateTime(Year(rc.minDate),Month(rc.minDate),Day(rc.minDate),0,0,0),'>=')/>
    <cfset subscriptionOrderItemList.addFilter('subscriptionOrderDeliveryItems.createdDateTime', CreateDateTime(Year(rc.maxDate),Month(rc.maxDate),Day(rc.maxDate),23,59,59),'<=')/>
    <cfset subscriptionOrderItemList.addGroupBy('orderItem.sku.product.productName')/>
    <cfset productsWithDeliveries = subscriptionOrderItemList.getPageRecords()/>
    
    <cfset earnedRevenueCollectionList.addDisplayProperty('subscriptionOrderItem.orderItem.sku.product.productName',javacast('null',''),{isVisible=true})/>
    <cfset earnedRevenueCollectionList.setOrderBy('subscriptionOrderItem.orderItem.sku.product.productName')/>
    
    <cfset refundedRevenueCollectionList.addDisplayProperty('subscriptionOrderItem.orderItem.sku.product.productName',javacast('null',''),{isVisible=true})/>
    <cfset refundedRevenueCollectionList.setOrderBy('subscriptionOrderItem.orderItem.sku.product.productName')/>
    
    <cfset earnedDataRecordsForProducts = earnedRevenueCollectionList.getRecords(true)/>
    <cfset refundedDataRecordsForProducts = refundedRevenueCollectionList.getRecords(true)/>
    
    
    
    <cfset productsWithDeliveriesMap = {}/>
    <cfloop array="#productsWithDeliveries#" index="productWithDelivery">
        <cfset productName = productWithDelivery['orderitem_sku_product_productName']/>
        <cfset productsWithDeliveriesMap[productName] = {
            subscriptionsEarning = [],
            earned = [],
            taxAmount = [],
            refunded = [],
            refundedTaxAmount = []
        }/>
        <cfloop from="1" to="#to-currentMonth+1#" index="i">
            <cfset productsWithDeliveriesMap[productName].subscriptionsEarning[i] = 0/>
            <cfset productsWithDeliveriesMap[productName].earned[i] = 0/>
            <cfset productsWithDeliveriesMap[productName].taxAmount[i] = 0/>
            <cfset productsWithDeliveriesMap[productName].refunded[i] = 0/>
            <cfset productsWithDeliveriesMap[productName].refundedTaxAmount[i] = 0/>
        </cfloop>
        
    </cfloop>
    <cfloop array="#earnedDataRecordsForProducts#" index="dataRecord">
        <cfset productName = dataRecord['subscriptionOrderItem_orderItem_sku_product_productName']/>
        <cfset index = DateDiff('m',rc.minDate,dataRecord['createdDateTime'])+1/>
        <cfif structKeyExists(productsWithDeliveriesMap,productName)>
            <cfset productsWithDeliveriesMap[productName].subscriptionsEarning[index] = dataRecord['subscriptionUsageCount']/>
            <cfset productsWithDeliveriesMap[productName].earned[index] = dataRecord['earnedSUM']/>
            <cfset productsWithDeliveriesMap[productName].taxAmount[index] = dataRecord['taxAmountSUM']/>
        </cfif>
    </cfloop>
    
    <cfloop array="#refundedDataRecordsForProducts#" index="dataRecord">
        <cfif structKeyExists(productsWithDeliveriesMap,productName)>
            <cfset productName = dataRecord['subscriptionOrderItem_orderItem_sku_product_productName']/>
            <cfset index = DateDiff('m',rc.minDate,dataRecord['createdDateTime'])+1/>
            <cfset productsWithDeliveriesMap[productName].refunded[index] = dataRecord['earnedSUM']/>
            <cfset productsWithDeliveriesMap[productName].refundedTaxAmount[index] = dataRecord['taxAmountSUM']/>
        </cfif>
    </cfloop>
    
    
    <table class="table table-bordered s-detail-content-table">
        <thead>
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
	            <cfset currentYear = Year(rc.minDate)/>
                <th></th>
                <cfloop from="#currentMonth-1#" to="#to-1#" index="w">
                    <cfif w % 12 eq 0 and w neq 0>
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
            
            <cfloop collection="#productsWithDeliveriesMap#" item="productName">
                <tr>
                    
                    <td>#productName#</td>
                    <cfset productTotal = 0/>
                    <cfloop from="1" to="#arrayLen(productsWithDeliveriesMap[productName].earned)#" index="i">
                        <cfset productEarned = (productsWithDeliveriesMap[productName].earned[i] - productsWithDeliveriesMap[productName].refunded[i])/>
                        <td>#$.slatwall.getService('hibachiUtilityService').formatValue(productEarned,'currency')#</td>
                        <cfset productTotal += productEarned/>
                        <cfset possibleYearTotal[i]+=(productsWithDeliveriesMap[productName].earned[i] - productsWithDeliveriesMap[productName].refunded[i])/>
                    </cfloop>
                    <td>#$.slatwall.getService('hibachiUtilityService').formatValue(productTotal,'currency')#</td>
                </tr>
            </cfloop>
            <tr>
                <cfset overallTotal=0/>
                <td>Total</td>
                <cfloop array="#possibleYearTotal#" index="possibleYearTotalRecord">
                    <td>#$.slatwall.getService('hibachiUtilityService').formatValue(possibleYearTotalRecord,'currency')#</td>
                    <cfset overallTotal +=possibleYearTotalRecord/>
                </cfloop>
                <td>#$.slatwall.getService('hibachiUtilityService').formatValue(overallTotal,'currency')#</td>
            </tr>
        </tbody>
    </table>
</cfoutput>