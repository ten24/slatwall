<cfparam name="rc.subscriptionType" default=""/>
<cfparam name="rc.productType" default=""/>
<cfparam name="rc.productID" default=""/>
<cfparam name="rc.reportYear" default="#Year(now())#"/>
<cfoutput>
    <cfset slatAction = 'report.deferredRevenueReport'/>
    <!--gets deferred revenue-->
    <cfset deferredRevenueData = $.slatwall.getService('subscriptionService').getDeferredRevenueData(rc.subscriptionType,rc.productType,rc.productID,rc.reportYear)/>    
    
    <cfset possibleYearsRecords = []/>
    <cfset currentYear = Year(now())/>
    <cfloop from="#currentYear#" to="#currentYear+10#" index="i">
        <cfset arrayAppend(possibleYearsRecords,i)/>
    </cfloop>
    <cfset possibleMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']/>
    
    <cfset currentMonth = 1/>
    <cfif Year(now()) eq rc.reportYear>
        <cfset currentMonth = Month(now())/>
    </cfif>
    
    <cfinclude template="./revenuereportcontrols.cfm"/>
    
    <table class="table table-bordered s-detail-content-table">
        <thead>
            <tr>
                <th></th>
                <cfloop from="#currentMonth#" to="12" index="i">
                    <cfset possibleMonth = possibleMonths[i]/>
                    <th>
                        #possibleMonth#
                    </th>
                </cfloop>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Active Subscriptions</td>
                <cfloop from="#currentMonth#" to="12" index="i">
                    <cfset possibleMonth = possibleMonths[i]/>
                    <cfset key = '#rc.reportYear#-#possibleMonth#'/>
                    <cfset activeSubscriptionQueryString = "?slatAction=entity.listsubscriptionusage&reportYear=#rc.reportYear#&reportMonth=#i#"/>
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
                </cfloop>
            </tr>
            <tr>
                <td>Expiring Subscriptions</td>
                <cfloop from="#currentMonth#" to="12" index="i">
                    <cfset possibleMonth = possibleMonths[i]/>
                    <cfset key = '#rc.reportYear#-#possibleMonth#'/>
                    <td>#deferredRevenueData[key].expiringSubscriptions#</td>
                </cfloop>
            </tr>
            <tr>
                <td>Deferred Revenue</td>
                <cfloop from="#currentMonth#" to="12" index="i">
                    <cfset possibleMonth = possibleMonths[i]/>
                    <cfset key = '#rc.reportYear#-#possibleMonth#'/>
                    <td>#deferredRevenueData[key].deferredRevenue#</td>
                </cfloop>
            </tr>
            <tr>
                <td>Deferred Tax</td>
                <cfloop from="#currentMonth#" to="12" index="i">
                    <cfset possibleMonth = possibleMonths[i]/>
                    <cfset key = '#rc.reportYear#-#possibleMonth#'/>
                    <td>#deferredRevenueData[key].deferredTax#</td>
                </cfloop>
            </tr>
            <tr>
                <td>Deferred Total</td>
                <cfloop from="#currentMonth#" to="12" index="i">
                    <cfset possibleMonth = possibleMonths[i]/>
                    <cfset key = '#rc.reportYear#-#possibleMonth#'/>
                    <td>#deferredRevenueData[key].deferredTotal#</td>
                </cfloop>
            </tr>
        </tbody>
    </table>
</cfoutput>