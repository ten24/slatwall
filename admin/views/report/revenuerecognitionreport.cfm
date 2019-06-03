
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
    
    <cfif structKeyExists(rc,'productType') and len(rc.productType)>
        <cfset newOrderCollectionList.addFilter('orderItems.sku.product.productType.productTypeID', rc.productType,'IN')/>
        <cfset cancelledOrdersCollectionList.addFilter('subscriptionOrderItems.orderItem.sku.product.productType.productTypeID', rc.productType,'IN')/>
    </cfif>
    
    <cfif structKeyExists(rc,'productID') and len(rc.productID)>
        <cfset newOrderCollectionList.addFilter('orderItems.sku.product.productID', rc.productID,'IN')/>
        <cfset cancelledOrdersCollectionList.addFilter('subscriptionOrderItems.orderItem.sku.product.productID', rc.productID,'IN')/>
    </cfif>
    
    <cfif structKeyExists(rc,'subscriptionType') and len(rc.subscriptionType)>
        <cfset cancelledOrdersCollectionList.addFilter('subscriptionOrderItems.subscriptionOrderItemType.systemCode', rc.subscriptionType,'IN')/>
    </cfif>
    
    <!--gets deferred revenue-->
    
    <cfset deferredRevenueData = $.slatwall.getService('subscriptionService').getDeferredRevenueData(rc.subscriptionType,rc.productType,rc.productID,rc.minDate,rc.maxDate)/>   
    
    <cfset possibleMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']/>
    <cfset currentMonth = Month(rc.minDate)/>
	<cfset diff = DateDiff('m',createDateTime(Year(rc.minDate),Month(rc.minDate),1,0,0,0),createDateTime(Year(rc.maxDate),Month(rc.maxDate),DaysInMonth(rc.maxDate),0,0,0))/>
	<cfset to = currentMonth + diff/>
	<cfset currentYear = Year(rc.minDate)/>
	
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
                <td>Opening Deferred Revenue Balance</td>
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                    <cfset currentIndex=i%12+1/>
                    <cfset possibleMonth = possibleMonths[currentIndex]/>
                    <cfif i%12 eq 0 and i neq 0>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <td>#currentIndex##$.slatwall.getService('HibachiUtilityService').formatValue(deferredRevenueData[key].deferredTotalLeftToBeRecognized,'currency')#</td>
                </cfloop>
            </tr>
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
                <td>New Orders</td>
                <cfloop array="#newOrders#" index="newOrder">
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif i%12 eq 0 and i neq 0>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <td>
                        #$.slatwall.getService('HibachiUtilityService').formatValue(newOrder,'currency')#
                    </td>
                </cfloop>
            </tr>
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
                <td>Cancellations</td>
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
                <td>Earned Revenue Balance</td>
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif i%12 eq 0 and i neq 0>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <td>
                        <cfif
                            
                            createDateTime(Year(now()),Month(now()),daysInMonth(now()),23,59,59) lte createDateTime(currentYear,i%12+1,daysInMonth(createDateTime(currentYear,i%12+1,1,0,0,0)),23,59,59)
                        >
                            #$.slatwall.getService('HibachiUtilityService').formatValue(deferredRevenueData[key].deferredRevenue,'currency')#
                        <cfelse>
                            - 
                        </cfif>
                    </td>
                </cfloop>
            </tr>
            
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
                <td>Closing Deferred Revenue Balance</td>
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif i%12 eq 0 and i neq 0>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <td>#$.slatwall.getService('HibachiUtilityService').formatValue(deferredRevenueData[key].deferredTotalLeftToBeRecognized,'currency')#</td>
                </cfloop>
            </tr>
            
            <!---<tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
                <cfset totalDeferredTax=0/>
                <td>Deferred Tax</td>
                
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif i%12 eq 0 and i neq 0>
                        <cfset currentYear++/>
                    </cfif>
                    
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <cfset totalDeferredTax+=deferredRevenueData[key].deferredTax/>
                    <td>
                        <cfif
                            
                            createDateTime(Year(now()),Month(now()),daysInMonth(now()),23,59,59) lte createDateTime(currentYear,i%12+1,daysInMonth(createDateTime(currentYear,i%12+1,1,0,0,0)),23,59,59)
                        >
                            #$.slatwall.getService('HibachiUtilityService').formatValue(deferredRevenueData[key].deferredTax,'currency')#</td>
                        <cfelse>
                            -
                        </cfif>
                </cfloop>
                <td>#$.slatwall.getService('HibachiUtilityService').formatValue(totalDeferredTax,'currency')#</td>
            </tr>
            
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
                <cfset totalDeferredTotal = 0/>
                <td>Deferred Total</td>
                
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif i%12 eq 0 and i neq 0>
                        <cfset currentYear++/>
                    </cfif>
                    
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <cfset totalDeferredTotal +=deferredRevenueData[key].deferredTotal/>
                    <td>
                        <cfif
                            
                            createDateTime(Year(now()),Month(now()),daysInMonth(now()),23,59,59) lte createDateTime(currentYear,i%12+1,daysInMonth(createDateTime(currentYear,i%12+1,1,0,0,0)),23,59,59)
                        >
                            #$.slatwall.getService('HibachiUtilityService').formatValue(deferredRevenueData[key].deferredTotal,'currency')#</td>
                        <cfelse>
                            -
                        </cfif>
                </cfloop>
                <td>#$.slatwall.getService('HibachiUtilityService').formatValue(totalDeferredTotal,'currency')#</td>
            </tr>
            
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
                <cfset totalDeferredRevenueLeftToBeRecognized = 0/>
                <td>Deferred Revenue Left to be Recognized</td>
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif i%12 eq 0 and i neq 0>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <td>#$.slatwall.getService('HibachiUtilityService').formatValue(deferredRevenueData[key].deferredRevenueLeftToBeRecognized,'currency')#</td>
                    <cfset totalDeferredRevenueLeftToBeRecognized+=deferredRevenueData[key].deferredRevenueLeftToBeRecognized/>
                </cfloop>
                <td>#$.slatwall.getService('HibachiUtilityService').formatValue(totalDeferredRevenueLeftToBeRecognized,'currency')#</td>
            </tr>
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
                <cfset totalDeferredTaxLeftToBeRecognized = 0/>
                <td>Deferred Tax Left to be Recognized</td>
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif i%12 eq 0 and i neq 0>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <td>#$.slatwall.getService('HibachiUtilityService').formatValue(deferredRevenueData[key].deferredTaxLeftToBeRecognized,'currency')#</td>
                    <cfset totalDeferredTaxLeftToBeRecognized+=deferredRevenueData[key].deferredTaxLeftToBeRecognized/>
                </cfloop>
                <td>#$.slatwall.getService('HibachiUtilityService').formatValue(totalDeferredTaxLeftToBeRecognized,'currency')#</td>
            </tr>
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
                <cfset totalDeferredTotalLeftToBeRecognized = 0/>
                <td>Deferred Total Left to be Recognized</td>
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif i%12 eq 0 and i neq 0>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <td>#$.slatwall.getService('HibachiUtilityService').formatValue(deferredRevenueData[key].deferredTotalLeftToBeRecognized,'currency')#</td>
                    <cfset totalDeferredTotalLeftToBeRecognized+=deferredRevenueData[key].deferredTotalLeftToBeRecognized/>
                </cfloop>
                <td>#$.slatwall.getService('HibachiUtilityService').formatValue(totalDeferredTotalLeftToBeRecognized,'currency')#</td>
            </tr>--->
        </tbody>
    </table>
</cfoutput>