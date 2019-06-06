
<cfparam name="rc.subscriptionType" default=""/>
<cfparam name="rc.productType" default=""/>
<cfparam name="rc.productID" default=""/>
<cfparam name="rc.minDate" default="#CreateDate(Year(now()),Month(now()),Day(now()))#"/>
<cfparam name="rc.maxDate" default="#CreateDate(Year(now()),12,31)#"/>
<cfoutput> 
    <cfset slatAction = 'report.deferredRevenueReport'/>
    
    <cfset newOrderCollectionList = $.slatwall.getService('HibachiService').getOrderCollectionList()/>
    <cfset newOrderCollectionList.setDisplayProperties('orderOpenDateTime',{isPeriod=true})/>
    <cfset newOrderCollectionList.addDisplayAggregate('calculatedTotal','SUM','newOrdersTotal',false,{isMetric=true})/>
    <cfset newOrderCollectionList.setReportFlag(1)/>
    <cfset newOrderCollectionList.setPeriodInterval('Month')/>
    <cfset newOrderCollectionList.addFilter('orderOpenDateTime', CreateDateTime(Year(rc.minDate),Month(rc.minDate),Day(rc.minDate),0,0,0),'>=')/>
    <cfset newOrderCollectionList.addFilter('orderOpenDateTime', CreateDateTime(Year(rc.maxDate),Month(rc.maxDate),Day(rc.maxDate),23,59,59),'<=')/>
    
    
    <cfset cancelledOrdersCollectionList = $.slatwall.getService('HibachiService').getSubscriptionUsageCollectionList()/>
    <cfset cancelledOrdersCollectionList.setDisplayProperties('modifiedDateTime',{isPeriod=true})/>
    <cfset cancelledOrdersCollectionList.addDisplayAggregate('subscriptionOrderItems.subscriptionOrderDeliveryItems.earned','SUM','earnedTotal',false,{isMetric=true})/>
    <cfset cancelledOrdersCollectionList.addDisplayAggregate('subscriptionOrderItems.subscriptionOrderDeliveryItems.taxAmount','SUM','taxTotal',false,{isMetric=true})/>
    <cfset cancelledOrdersCollectionList.addDisplayAggregate('subscriptionOrderItems.orderItem.calculatedItemTotal','SUM','orderItemTotal',false,{isMetric=true})/>
    <cfset cancelledOrdersCollectionList.setReportFlag(1)/>
    <cfset cancelledOrdersCollectionList.setPeriodInterval('Month')/>
    <cfset cancelledOrdersCollectionList.addFilter('modifiedDateTime', CreateDateTime(Year(rc.minDate),Month(rc.minDate),Day(rc.minDate),0,0,0),'>=')/>
    <cfset cancelledOrdersCollectionList.addFilter('modifiedDateTime', CreateDateTime(Year(rc.maxDate),Month(rc.maxDate),Day(rc.maxDate),23,59,59),'<=')/>
    <cfset cancelledOrdersCollectionList.addFilter('calculatedCurrentStatus.subscriptionStatusType.systemCode','sstCancelled')/>
    
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
    
    
    <cfif structKeyExists(rc,'productType') and len(rc.productType)>
        <cfset newOrderCollectionList.addFilter('orderItems.sku.product.productType.productTypeID', rc.productType,'IN')/>
        <cfset cancelledOrdersCollectionList.addFilter('subscriptionOrderItems.orderItem.sku.product.productType.productTypeID', rc.productType,'IN')/>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.sku.product.productType.productTypeID', rc.productType,'IN')/>
    </cfif>
    
    <cfif structKeyExists(rc,'productID') and len(rc.productID)>
        <cfset newOrderCollectionList.addFilter('orderItems.sku.product.productID', rc.productID,'IN')/>
        <cfset cancelledOrdersCollectionList.addFilter('subscriptionOrderItems.orderItem.sku.product.productID', rc.productID,'IN')/>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.sku.product.productID', rc.productID,'IN')/>
    </cfif>
    
    <cfif structKeyExists(rc,'subscriptionType') and len(rc.subscriptionType)>
        <cfset cancelledOrdersCollectionList.addFilter('subscriptionOrderItems.subscriptionOrderItemType.systemCode', rc.subscriptionType,'IN')/>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.subscriptionOrderItemType.systemCode', rc.subscriptionType,'IN')/>
    </cfif>
    
    
    <cfset earnedDataRecords = earnedRevenueCollectionList.getRecords()/>
    
    <!--gets deferred revenue-->
    
    <cfset deferredRevenueData = $.slatwall.getService('subscriptionService').getDeferredRevenueData(rc.subscriptionType,rc.productType,rc.productID,rc.minDate,rc.maxDate)/>   
    
    <cfset possibleMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']/>
    <cfset currentMonth = Month(rc.minDate)/>
	<cfset diff = DateDiff('m',createDateTime(Year(rc.minDate),Month(rc.minDate),1,0,0,0),createDateTime(Year(rc.maxDate),Month(rc.maxDate),DaysInMonth(rc.maxDate),0,0,0))/>
	<cfset to = currentMonth + diff/>
	<cfset currentYear = Year(rc.minDate)/>
	<!---prepare earned data--->
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
        <cfset earnedRevenue[i]=0/>
    </cfloop>
    
    <cfloop array="#earnedDataRecords#" index="dataRecord">
        <cfset index = DateDiff('m',rc.minDate,dataRecord['createdDateTime'])+1/>
        <cfset subscriptionsEarning[index] = dataRecord['subscriptionUsageCount']/>
        <cfset earned[index] = dataRecord['earnedSUM']/>
        <cfset taxAmount[index] = dataRecord['taxAmountSUM']/>
        <cfset earnedRevenue[index]= dataRecord['earnedSUM']+dataRecord['taxAmountSUM']/>
    </cfloop>
	
	<!-- prepare neworder data -->
	<cfset newOrders = []/>
    <cfloop from="1" to="#to-currentMonth+1#" index="i">
        <cfset newOrders[i] = 0/>
    </cfloop>
    
    <cfloop array="#newOrderCollectionList.getRecords()#" index="dataRecord">
        <cfset index = DateDiff('m',rc.minDate,dataRecord['orderOpenDateTime'])+1/>
        <cfset newOrders[index] = dataRecord['newOrdersTotal']/>
    </cfloop>
    
    <cfset cancelledOrders = []/>
    <cfloop from="1" to="#to-currentMonth+1#" index="i">
        <cfset cancelledOrders[i] = 0/>
    </cfloop>
    
    <cfloop array="#cancelledOrdersCollectionList.getRecords()#" index="dataRecord">
        <cfset index = DateDiff('m',rc.minDate,dataRecord['modifiedDateTime'])+1/>
        <cfset cancelledOrders[index] = dataRecord['orderItemTotal'] - (dataRecord['earnedTotal']+dataRecord['taxTotal'])/>
    </cfloop>
	
    <cfinclude template="./revenuereportcontrols.cfm"/>
    
    <table class="table table-bordered s-detail-content-table">
        <thead>
            <tr>
                <th></th>
                
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                    
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif  i%12 eq 0 and i neq 0 >
                        <cfset currentYear++/>
                    </cfif>
                    
                    <th>
                        #possibleMonth# - #currentYear#
                    </th>
                </cfloop>
            </tr>
        </thead>
        <tbody>
            
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
                <td>Opening Deferred Revenue Balance 
                    <cfset tooltip = "Deferred revenue still to be earned at the beginning of the month.
                    Formula: For each Order Item (Price Per Delivery + Tax Per Delivery)*Scheduled Deliveries Per Month. 
                    Scheduled Deliveries are based on the Product Schedule where the delivery date is less than the expiration. 
                    Price per Delivery is based on (Order item cost / subscription benefit items to deliver). "/>
                    <span sw-tooltip class="j-tool-tip-item" data-text="#tooltip#" data-position="right"><i class="fa fa-question-circle"></i></span>
                </td>
                <cfset earnedRevenueIndex = 1/>
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                    <cfset currentIndex=i%12+1/>
                    <cfset possibleMonth = possibleMonths[currentIndex]/>
                    <cfif i%12 eq 0 and i neq 0>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <td>-#$.slatwall.getService('HibachiUtilityService').formatValue(deferredRevenueData[key].deferredTotalLeftToBeRecognized+earnedRevenue[earnedRevenueIndex],'currency')#</td>
                    <cfset earnedRevenueIndex++/>
                </cfloop>
            </tr>
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
            	<cfset tooltip = "total revenue (net of taxes) for new orders processed this month, all of which is credited to deferred revenue. Total value of orders for the month"/>
                <td >New Orders <span sw-tooltip class="j-tool-tip-item" data-text="test" data-position="right"><i class="fa fa-question-circle"></i></span></td>
                <cfloop array="#newOrders#" index="newOrder">
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif i%12 eq 0 and i neq 0>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <td>
                        -#$.slatwall.getService('HibachiUtilityService').formatValue(newOrder,'currency')#
                    </td>
                </cfloop>
            </tr>
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
            	<cfset tooltip = "how much revenue was removed from earnings due to pro-rate. Formula: (OrderItems Expected Revenue - EarnedRevenue)"/>
                <td>Cancellations <span sw-tooltip class="j-tool-tip-item" data-text="#tooltip#" data-position="right"><i class="fa fa-question-circle"></i></span></td>
                <cfloop array="#cancelledOrders#" index="cancelledOrder">
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif i%12 eq 0 and i neq 0>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <td>
                        #$.slatwall.getService('HibachiUtilityService').formatValue(cancelledOrder,'currency')#
                    </td>
                </cfloop>
            </tr>
            
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
            	<cfset tooltip = "How much money was earned on the deferred revenue. Formula: (SUM of Subscription Order Delivery Items * (Price Per Delivery + Tax Per Delivery)). Price per Delivery is based on (Order item cost / subscription benefit items to deliver)."/>
                <td>Earned Revenue Balance <span sw-tooltip class="j-tool-tip-item" data-text="test" data-position="right"><i class="fa fa-question-circle"></i></span></td>
                <cfset totalEarnedRevenue=0/>
                
                <cfloop array="#earnedRevenue#" index="earnedRevenueRecord">
                    <td>#$.slatwall.getService('hibachiUtilityService').formatValue(earnedRevenueRecord,'currency')#</td>
                    <cfset totalEarnedRevenue+=earnedRevenueRecord/>
                </cfloop>
            </tr>
            
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
            	<cfset tooltip = "Deferred revenue still to be earned at the end of the month.
                    Formula: For each Order Item (Price Per Delivery + Tax Per Delivery)*Scheduled Deliveries Per Month. 
                    Scheduled Deliveries are based on the Product Schedule where the delivery date is less than the expiration. 
                    Price per Delivery is based on (Order item cost / subscription benefit items to deliver). "/>
                <td>Closing Deferred Revenue Balance <span sw-tooltip class="j-tool-tip-item" data-text="#tooltip#" data-position="right"><i class="fa fa-question-circle"></i></span></td>
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                    <cfset currentIndex=i%12+1/>
                    <cfset possibleMonth = possibleMonths[currentIndex]/>
                    <cfif i%12 eq 0 and i neq 0>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <td>
                        -#$.slatwall.getService('HibachiUtilityService').formatValue(deferredRevenueData[key].deferredTotalLeftToBeRecognized,'currency')#
                    </td>
                </cfloop>
            </tr>
        </tbody>
    <!--- earned revenue --->
    <cfif structKeyExists(rc,'productID')>
        <cfset deliveryScheduleDateCollectionlist = getHibachiScope().getService('hibachiService').getDeliveryScheduleDateCollectionList()/>
        <cfset deliveryScheduleDateCollectionlist.setDisplayProperties('deliveryScheduleDateName,deliveryScheduleDateValue,deliveryScheduleDateID')/>
        <cfset deliveryScheduleDateCollectionlist.addFilter('product.productID',rc.productID)/>
        <cfset deliveryScheduleDateCollectionlist.addFilter('deliveryScheduleDateValue',rc.minDate,'>=')/>
        <cfset deliveryScheduleDateCollectionlist.addFilter('deliveryScheduleDateValue',rc.maxDate,'<=')/>
        <cfset deliveryScheduleDateCollectionlist.setOrderBy('deliveryScheduleDateValue')/>
        <cfset deliveryScheduleDateRecords = deliveryScheduleDateCollectionlist.getRecords()/>
        
            
            <tbody>
                <tr>
                    <td><b>Earned Revenue By Issue</b></td>
                </tr>
                <cfloop array="#deliveryScheduleDateRecords#" index="deliveryScheduleDateRecord">
                    
                    <tr>
                        <td>
                            #deliveryScheduleDateRecord['deliveryScheduleDateName']#
                        </td>
                        <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                            
                            <cfset possibleMonth = possibleMonths[i%12+1]/>
                            <cfif  i%12 eq 0 and i neq 0 >
                                <cfset currentYear++/>
                            </cfif>
                            <cfset earnedRevenueByIssueCollectionlist = earnedRevenueCollectionList.duplicateCollection()/>
                            <cfset earnedRevenueByIssueCollectionlist.addFilter('createdDateTime',createDateTime(currentYear,i%12+1,firstDayOfMonth(i%12+1),0,0,0),'>=')/>
                            <cfset earnedRevenueByIssueCollectionlist.addFilter('createdDateTime',createDateTime(currentYear,i%12+1,DaysInMonth(createDateTime(currentYear,i%12+1,1,0,0,0)),23,59,59),'<=')/>
                            <cfset earnedRevenueByIssueCollectionlist.addFilter('deliveryScheduleDate.deliveryScheduleDateID',deliveryScheduleDateRecord['deliveryScheduleDateID'])/>
                            <td>
                                <cfset earnedRevenueByIssueCollectionRecords = earnedRevenueByIssueCollectionlist.getRecords()/>
                                <cfif arraylen(earnedRevenueByIssueCollectionRecords)>
                                    <cfset earnedRevenueByIssueCollectionRecord = earnedRevenueByIssueCollectionRecords[1]/>
                                    #$.slatwall.getService('HibachiUtilityService').formatValue(earnedRevenueByIssueCollectionRecord['earnedSum']+earnedRevenueByIssueCollectionRecord['taxAmountSum'],'currency')#
                                <cfelse>
                                    #$.slatwall.getService('HibachiUtilityService').formatValue(0,'currency')#
                                </cfif>
                            </td>
                        </cfloop>
                        
                    </tr>    
                </cfloop>
                <tr>
                </tr>
            </tbody>
    </cfif>
    </table>
</cfoutput>