<cfparam name="rc.subscriptionType" default=""/>
<cfparam name="rc.productType" default=""/>
<cfparam name="rc.productID" default=""/>
<cfparam name="rc.minDate" default="#CreateDate(Year(now()),Month(now()),Day(now()))#"/>
<cfparam name="rc.maxDate" default="#CreateDate(Year(now()),12,31)#"/>
<cfoutput> 
    <cfset slatAction = 'report.deferredRevenueReport'/>
    <!--gets deferred revenue-->
    <cfset deferredRevenueData = $.slatwall.getService('subscriptionService').getDeferredRevenueData(rc.subscriptionType,rc.productType,rc.productID,rc.minDate,rc.maxDate)/>    
    <cfset possibleMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']/>
    
    <cfset currentMonth = Month(rc.minDate)/>
	<cfset diff = DateDiff('m',rc.minDate,rc.maxDate)/>
	<cfset to = currentMonth + diff/>
	<cfset currentYear = Year(rc.minDate)/>
	<cfif currentMonth eq 1>
	    <cfset rollover = false/>
	<cfelse>
	    <cfset rollover = true/>
	</cfif>
	
    <cfinclude template="./revenuereportcontrols.cfm"/>
    
    <table class="table table-bordered s-detail-content-table">
        <thead>
            <tr>
                <th></th>
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif  i%12 eq 0 and i neq 1 and rollover>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset rollover = true/>
                    <th>
                        #possibleMonth# - #currentYear#
                    </th>
                </cfloop>
                <th>Total</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
            	<cfset totalActiveSubscriptions=0/>
                <td>Active Subscriptions</td>
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif i%12 eq 1>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <cfset activeSubscriptionQueryString = "?slatAction=entity.listsubscriptionusage&reportYear=#currentYear#&reportMonth=#i+1#"/>
                    <cfif structKeyExists(rc,'subscriptionType') && len(rc.subscriptionType)>
                        <cfset activeSubscriptionQueryString &= "&subscriptionType=#rc.subscriptionType#"/>
                    </cfif> 
                    <cfif structKeyExists(rc,'productType') && len(rc.productType)>
                        <cfset activeSubscriptionQueryString &= "&productType=#rc.productType#"/>
                    </cfif> 
                    <cfif structKeyExists(rc,'productID') && len(rc.productID)>
                        <cfset activeSubscriptionQueryString &= "&productID=#rc.productID#"/>
                    </cfif> 
                    <td><a href="#activeSubscriptionQueryString#">#deferredRevenueData[key].activeSubscriptions#</a></td>
                    <cfset totalActiveSubscriptions+=deferredRevenueData[key].activeSubscriptions/>
                </cfloop>
                <td></td>
            </tr>
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
            	 
                <cfset totalExpiringSubscriptions=0/>
                <td>Expiring Subscriptions</td>
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif i%12 eq 1>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <td>#deferredRevenueData[key].expiringSubscriptions#</td>
                    <cfset totalExpiringSubscriptions+=deferredRevenueData[key].expiringSubscriptions/>
                </cfloop>
                <td></td>
            </tr>
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
                <cfset totalDeferredRevenue = 0/>
                <td>Deferred Revenue</td>
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif i%12 eq 1>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <td>#$.slatwall.getService('HibachiUtilityService').formatValue(deferredRevenueData[key].deferredRevenue,'currency')#</td>
                    <cfset totalDeferredRevenue+=deferredRevenueData[key].deferredRevenue/>
                </cfloop>
                <td>#$.slatwall.getService('HibachiUtilityService').formatValue(totalDeferredRevenue,'currency')#</td>
            </tr>
            <tr>
                <cfset currentMonth = Month(rc.minDate)/>
            	<cfset currentYear = Year(rc.minDate)/>
                <cfset totalDeferredTax=0/>
                <td>Deferred Tax</td>
                <cfloop from="#currentMonth-1#" to="#to-1#" index="i">
                    <cfset possibleMonth = possibleMonths[i%12+1]/>
                    <cfif i%12 eq 1>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <cfset totalDeferredTax+=deferredRevenueData[key].deferredTax/>
                    <td>#$.slatwall.getService('HibachiUtilityService').formatValue(deferredRevenueData[key].deferredTax,'currency')#</td>
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
                    <cfif i%12 eq 1>
                        <cfset currentYear++/>
                    </cfif>
                    <cfset key = '#currentYear#-#possibleMonth#'/>
                    <cfset totalDeferredTotal +=deferredRevenueData[key].deferredTotal/>
                    <td>#$.slatwall.getService('HibachiUtilityService').formatValue(deferredRevenueData[key].deferredTotal,'currency')#</td>
                </cfloop>
                <td>#$.slatwall.getService('HibachiUtilityService').formatValue(totalDeferredTotal,'currency')#</td>
            </tr>
        </tbody>
    </table>
</cfoutput>