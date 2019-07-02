
<cfparam name="rc.subscriptionType" default=""/>
<cfparam name="rc.productType" default=""/>
<cfparam name="rc.productID" default=""/>
<cfparam name="rc.minDate" default="#CreateDate(Year(now()),Month(now()),Day(now()))#"/>
<cfparam name="rc.maxDate" default="#CreateDate(Year(now()),12,31)#"/>
<cfoutput> 
    <cfset slatAction = 'report.deferredRevenueReport'/>
    
    <cfset newOrderCollectionList = $.slatwall.getService('HibachiService').getSubscriptionUsageCollectionList()/>
    <cfset newOrderCollectionList.setDisplayProperties('subscriptionOrderItems.orderItem.order.orderOpenDateTime',{isPeriod=true})/>
    <cfset newOrderCollectionList.addDisplayAggregate('subscriptionOrderItems.orderItem.calculatedExtendedPrice','SUM','newOrdersTotal',false,{isMetric=true})/>
    <cfset newOrderCollectionList.setReportFlag(1)/>
    <cfset newOrderCollectionList.setPeriodInterval('Month')/>
    <cfset newOrderCollectionList.addFilter('subscriptionOrderItems.orderItem.order.orderOpenDateTime', CreateDateTime(Year(rc.minDate),Month(rc.minDate),Day(rc.minDate),0,0,0),'>=')/>
    <cfset newOrderCollectionList.addFilter('subscriptionOrderItems.orderItem.order.orderOpenDateTime', CreateDateTime(Year(rc.maxDate),Month(rc.maxDate),Day(rc.maxDate),23,59,59),'<=')/>
    
    
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
        <cfset newOrderCollectionList.addFilter('subscriptionOrderItems.orderItem.sku.product.productType.productTypeID', rc.productType,'IN')/>
        <cfset cancelledOrdersCollectionList.addFilter('subscriptionOrderItems.orderItem.sku.product.productType.productTypeID', rc.productType,'IN')/>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.sku.product.productType.productTypeID', rc.productType,'IN')/>
    </cfif>
    
    <cfif structKeyExists(rc,'productID') and len(rc.productID)>
        <cfset newOrderCollectionList.addFilter('subscriptionOrderItems.orderItem.sku.product.productID', rc.productID,'=')/>
        <cfset cancelledOrdersCollectionList.addFilter('subscriptionOrderItems.orderItem.sku.product.productID', rc.productID,'=')/>
        <cfset earnedRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.sku.product.productID', rc.productID,'=')/>
    </cfif>
    
    <cfif structKeyExists(rc,'subscriptionType') and len(rc.subscriptionType)>
        <cfset newOrderCollectionList.addFilter('subscriptionOrderItems.orderItem.sku.product.productID', rc.productID,'=')/>
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
        <cfset earnedRevenue[index]= dataRecord['earnedSUM']/>
    </cfloop>
	
	<!-- prepare neworder data -->
	<cfset newOrders = []/>
    <cfloop from="1" to="#to-currentMonth+1#" index="i">
        <cfset newOrders[i] = 0/>
    </cfloop>
    
    <cfloop array="#newOrderCollectionList.getRecords()#" index="dataRecord">
        <cfset index = DateDiff('m',rc.minDate,dataRecord['subscriptionOrderItems_orderItem_order_orderOpenDateTime'])+1/>
        <cfset newOrders[index] = dataRecord['newOrdersTotal']/>
    </cfloop>
    
    <cfset cancelledOrders = []/>
    <cfloop from="1" to="#to-currentMonth+1#" index="i">
        <cfset cancelledOrders[i] = 0/>
    </cfloop>
    
    <cfloop array="#cancelledOrdersCollectionList.getRecords()#" index="dataRecord">
        <cfset index = DateDiff('m',rc.minDate,dataRecord['modifiedDateTime'])+1/>
        <cfset cancelledOrders[index] = dataRecord['orderItemTotal']/>
    </cfloop>
	
    <cfinclude template="./revenuereportcontrols.cfm"/>
    <!---creating data--->
    <cfset reportData = {
        headers=[],
        openingDeferredRevenue=[],
        newOrders=[],
        cancelledOrders=[],
        earnedRevenue=[],        
        closingDeferredRevenue=[]
    }/>
    
    <cfset currentMonth = Month(rc.minDate)/>
    <cfset currentYear = Year(rc.minDate)/>
    <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
        
        <cfset possibleMonth = possibleMonths[i%12+1]/>
        <cfif  i%12 eq 0 and i neq 0 >
            <cfset currentYear++/>
        </cfif>
        
        <cfset arrayAppend(reportData.headers,"#possibleMonth# - #currentYear#")/>
    </cfloop>
    
    <cfset currentMonth = Month(rc.minDate)/>
	<cfset currentYear = Year(rc.minDate)/>
    <cfset earnedRevenueIndex = 1/>
    <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
        <cfset currentIndex=i%12+1/>
        <cfset possibleMonth = possibleMonths[currentIndex]/>
        <cfif i%12 eq 0 and i neq 0>
            <cfset currentYear++/>
        </cfif>
        <cfset key = '#currentYear#-#possibleMonth#'/>
        <cfset arrayAppend(reportData.openingDeferredRevenue,'-#$.slatwall.getService('HibachiUtilityService').formatValue(deferredRevenueData[key].deferredTotalLeftToBeRecognized+earnedRevenue[earnedRevenueIndex]+cancelledOrders[earnedRevenueIndex]-newOrders[earnedRevenueIndex],'currency')#')/>
        <cfset earnedRevenueIndex++/>
    </cfloop>
    
    
    <cfset currentMonth = Month(rc.minDate)/>
	<cfset currentYear = Year(rc.minDate)/>
    <cfloop array="#newOrders#" index="newOrder">
        <cfset possibleMonth = possibleMonths[i%12+1]/>
        <cfif i%12 eq 0 and i neq 0>
            <cfset currentYear++/>
        </cfif>
        <cfset key = '#currentYear#-#possibleMonth#'/>
        <cfset arrayAppend(reportData.newOrders,'-#$.slatwall.getService('HibachiUtilityService').formatValue(newOrder,'currency')#')/>
    </cfloop>
    
    <cfset currentMonth = Month(rc.minDate)/>
	<cfset currentYear = Year(rc.minDate)/>
    <cfloop array="#cancelledOrders#" index="cancelledOrder">
        <cfset possibleMonth = possibleMonths[i%12+1]/>
        <cfif i%12 eq 0 and i neq 0>
            <cfset currentYear++/>
        </cfif>
        <cfset key = '#currentYear#-#possibleMonth#'/>
        <cfset arrayAppend(reportData.cancelledOrders,'#$.slatwall.getService('HibachiUtilityService').formatValue(cancelledOrder,'currency')#') />
    </cfloop>
    
    <cfset currentMonth = Month(rc.minDate)/>
	<cfset currentYear = Year(rc.minDate)/>
    <cfset totalEarnedRevenue=0/>
    <cfloop array="#earnedRevenue#" index="earnedRevenueRecord">
        <cfset arrayAppend(reportData.earnedRevenue,$.slatwall.getService('hibachiUtilityService').formatValue(earnedRevenueRecord,'currency'))/>
        <cfset totalEarnedRevenue+=earnedRevenueRecord/>
    </cfloop>
    
    <cfset currentMonth = Month(rc.minDate)/>
	<cfset currentYear = Year(rc.minDate)/>
    <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
        <cfset currentIndex=i%12+1/>
        <cfset possibleMonth = possibleMonths[currentIndex]/>
        <cfif i%12 eq 0 and i neq 0>
            <cfset currentYear++/>
        </cfif>
        <cfset key = '#currentYear#-#possibleMonth#'/>
        <cfset arrayAppend(reportData.closingDeferredRevenue,'-#$.slatwall.getService('HibachiUtilityService').formatValue(deferredRevenueData[key].deferredTotalLeftToBeRecognized,'currency')#')/>
    </cfloop>
    
    <table class="table table-bordered s-detail-content-table">
        <thead>
            <tr>
                <th></th>
                <cfloop array="#reportData.headers#" index="header">
                    <th>
                        #header#
                    </th>
                </cfloop>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Opening Deferred Revenue Balance 
                    <cfset tooltip = "Deferred revenue still to be earned at the beginning of the month.
                    Formula: For each Order Item Price Per Delivery*Scheduled Deliveries Per Month. 
                    Scheduled Deliveries are based on the Product Schedule where the delivery date is less than the expiration. 
                    Price per Delivery is based on (Order item cost / subscription term ## of items to deliver). "/>
                    <span sw-tooltip class="j-tool-tip-item" data-text="#tooltip#" data-position="right"><i class="fa fa-question-circle"></i></span>
                </td>
                <cfset earnedRevenueIndex = 1/>
                <cfloop array="#reportData.openingDeferredRevenue#" index="openingDeferredRevenueItem">
                    <td>#openingDeferredRevenueItem#</td>
                </cfloop>
            </tr>
            <tr>
                <td >New Orders <span sw-tooltip class="j-tool-tip-item" data-text="#tooltip#" data-position="right"><i class="fa fa-question-circle"></i></span></td>
                <cfloop array="#reportData.newOrders#" index="newOrder">
                    <td>
                        #newOrder#
                    </td>
                </cfloop>
            </tr>
            <tr>
                <td>Cancellations <span sw-tooltip class="j-tool-tip-item" data-text="#tooltip#" data-position="right"><i class="fa fa-question-circle"></i></span></td>
                <cfloop array="#reportData.cancelledOrders#" index="cancelledOrder">
                    <td>
                        #cancelledOrder#
                    </td>
                </cfloop>
            </tr>
            <tr>
                <td>Earned Revenue Balance <span sw-tooltip class="j-tool-tip-item" data-text="#tooltip#" data-position="right"><i class="fa fa-question-circle"></i></span></td>
                
                <cfloop array="#reportData.earnedRevenue#" index="earnedRevenueRecord">
                    <td>#earnedRevenueRecord#</td>
                </cfloop>
            </tr>
            <tr>
            	<cfset tooltip = "Deferred revenue still to be earned at the end of the month.
                    Formula: For each Order Item (Price Per Delivery)*Scheduled Deliveries Per Month. 
                    Scheduled Deliveries are based on the Product Schedule where the delivery date is less than the expiration. 
                    Price per Delivery is based on (Order item cost / subscription term ## of items to deliver). "/>
                <td>Closing Deferred Revenue Balance <span sw-tooltip class="j-tool-tip-item" data-text="#tooltip#" data-position="right"><i class="fa fa-question-circle"></i></span></td>
                <cfloop array="#reportData.closingDeferredRevenue#" index="closingDeferredRevenueItem">
                    <td>
                        #closingDeferredRevenueItem#
                    </td>
                </cfloop>
            </tr>
        </tbody>
        <!--- earned revenue --->
        <cfif structKeyExists(rc,'productID') and len(rc.productID)>
            <cfset deliveryScheduleDateCollectionlist = getHibachiScope().getService('hibachiService').getDeliveryScheduleDateCollectionList()/>
            <cfset deliveryScheduleDateCollectionlist.setDisplayProperties('deliveryScheduleDateName,deliveryScheduleDateValue,deliveryScheduleDateID')/>
            <cfset deliveryScheduleDateCollectionlist.addFilter('product.productID',rc.productID)/>
            <cfset deliveryScheduleDateCollectionlist.addFilter('deliveryScheduleDateValue',rc.minDate,'>=')/>
            <cfset deliveryScheduleDateCollectionlist.addFilter('deliveryScheduleDateValue',rc.maxDate,'<=')/>
            <cfset deliveryScheduleDateCollectionlist.setOrderBy('deliveryScheduleDateValue')/>
            <cfset deliveryScheduleDateRecords = deliveryScheduleDateCollectionlist.getRecords()/>
            
                
            <cfset reportData.earnedRevenueByIssue={}/>
            <cfset reportData.earnedRevenueByIssueNames=[]/>
            
            <cfloop array="#deliveryScheduleDateRecords#" index="deliveryScheduleDateRecord">
                <cfset earnedRevenueByIssueName = "#deliveryScheduleDateRecord['deliveryScheduleDateName']#"/>
                <cfset arrayAppend(reportData.earnedRevenueByIssueNames,earnedRevenueByIssueName)/>
                <cfset reportData.earnedRevenueByIssue[earnedRevenueByIssueName]=[]/>
                <cfset currentYear = Year(rc.minDate)/>
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                   
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif  i%12 eq 0 and i neq 0 >
                        <cfset currentYear++/>
                    </cfif>
                    <cfset earnedRevenueByIssueCollectionlist = earnedRevenueCollectionList.duplicateCollection()/>
                    <cfset earnedRevenueByIssueCollectionlist.addFilter('createdDateTime',createDateTime(currentYear,i%12+1,1,0,0,0),'>=')/>
                    <cfset earnedRevenueByIssueCollectionlist.addFilter('createdDateTime',createDateTime(currentYear,i%12+1,DaysInMonth(createDateTime(currentYear,i%12+1,1,0,0,0)),23,59,59),'<=')/>
                    <cfset earnedRevenueByIssueCollectionlist.addFilter('deliveryScheduleDate.deliveryScheduleDateID',deliveryScheduleDateRecord['deliveryScheduleDateID'])/>
                   
                    <cfset earnedRevenueByIssueCollectionRecords = earnedRevenueByIssueCollectionlist.getRecords()/>
                    
                    <cfif arraylen(earnedRevenueByIssueCollectionRecords)>
                        <cfset earnedRevenueByIssueCollectionRecord = earnedRevenueByIssueCollectionRecords[1]/>
                        <cfset arrayAppend(reportData.earnedRevenueByIssue[earnedRevenueByIssueName],"#$.slatwall.getService('HibachiUtilityService').formatValue(earnedRevenueByIssueCollectionRecord['earnedSUM'],'currency')#")/>
                    <cfelse>
                        <cfset arrayAppend(reportData.earnedRevenueByIssue[earnedRevenueByIssueName],"#$.slatwall.getService('HibachiUtilityService').formatValue(0,'currency')#")/>
                    </cfif>
                </cfloop>
            </cfloop>
            <tbody>
                <tr>
                    <td><b>Earned Revenue By Issue</b></td>
                </tr>
                <cfloop array="#reportData.earnedRevenueByIssueNames#" index="earnedRevenueByIssueName">
                    
                    <tr>
                        <td>
                            #earnedRevenueByIssueName#
                        </td>
                        <cfloop array="#reportData.earnedRevenueByIssue[earnedRevenueByIssueName]#" index="earnedRevenueByIssueItem">
                           
                             <td>
                               #earnedRevenueByIssueItem#
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