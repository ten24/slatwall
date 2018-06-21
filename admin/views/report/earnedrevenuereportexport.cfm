<cfparam name="rc.subscriptionType" default=""/>
<cfparam name="rc.productType" default=""/>
<cfparam name="rc.productID" default=""/>
<cfparam name="rc.minDate" default="#CreateDate(Year(now()),1,1)#"/>
<cfparam name="rc.maxDate" default="#CreateDate(Year(now()),Month(now()),Day(now()))#"/>
<!---<cfset deferredRevenueData = $.slatwall.getService('subscriptionService').getDeferredRevenueData(rc.subscriptionType,rc.productType,rc.productID,rc.minDate,rc.maxDate) />

<cfset possibleMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']/>

<cfset currentMonth = Month(rc.minDate)/>
<cfset diff = DateDiff('m',rc.minDate,rc.maxDate)/>
<cfset to = currentMonth + diff/>
<cfset currentYear = Year(rc.minDate)/>

<cfset colNamesList = 'Headers'/>
<cfset data = [5]/>
<!---explicitly written for control of the ordering--->
<cfset headerRowItems = [
	'activeSubscriptions',
	'expiringSubscriptions',
    'deferredRevenue',
	'deferredTax',
	'deferredTotal'
]/>
<cfloop from=1 to="#arraylen(headerRowItems)#" index="i">
    <cfset data[i] = {}/>
    <cfset data[i]['Headers']=headerRowItems[i]/>
</cfloop>
<!---get headers--->
<!---properly order columns list--->
<cfloop from="#currentMonth-1#" to="#to-1#" index="i">
    <cfset possibleMonth = possibleMonths[i%12+1]/>
    <cfif i%12 eq 1>
        <cfset currentYear++/>
    </cfif>
    <cfset colName = "#possibleMonth##currentYear#"/>
    <cfset colNamesList = listAppend(colNamesList,colName)/>
    <cfset deferredRevenueDataForMonth = deferredRevenueData["#currentYear#-#possibleMonth#"]/>
    <cfloop from=1 to="#arraylen(headerRowItems)#" index="i">
        <cfset data[i][colName]=deferredRevenueDataForMonth[headerRowItems[i]]/>
    </cfloop>
</cfloop>--->
<cfparam name="showProducts" default="true"/>
<!---axe the output--->
<cfsilent>
    <cfinclude template="./earnedrevenuereport.cfm"/>
</cfsilent>
<cfset currentMonth = Month(rc.minDate)/>
<cfset currentYear = Year(rc.minDate)/>
                
<cfloop from="#currentMonth-1#" to="#to-1#" index="w">
    <cfif w % 12 eq 1>
        <cfset currentYear++/>
    </cfif>
        #possibleMonths[w%12+1]# - #currentYear#
</cfloop>

<cfset colNamesList = 'Headers'/>
<cfset data = [5]/>
<!---explicitly written for control of the ordering--->
<cfset headerRowItems = [
	'Subscriptions Earning',
	'Earned Revenue',
    'Tax',
	'Refunded Revenue',
	'Refunded Tax',
	'Total',
	''
]/>
<cfloop array="#productsWithDeliveries#" index="productWithDelivery">
    <cfset productName = productWithDelivery['orderitem_sku_product_productName']/>
    <cfset arrayAppend(headerRowItems,productName)/>
</cfloop>
<cfloop from=1 to="#arraylen(headerRowItems)#" index="i">
    <cfset data[i] = {}/>
    <cfset data[i]['Headers']=headerRowItems[i]/>
</cfloop>

<!---get headers--->
<!---properly order columns list--->
<!---<cfset subscriptionsEarning = []/>
    <cfset earned = []/>
    <cfset taxAmount = []/>
    <cfset refunded = []/>
    <cfset refundedTaxAmount = []/>
    <cfset possibleYearTotal = []/>--->
    <cfdump var="#subscriptionsEarning#">
<cfloop from="#currentMonth-1#" to="#to-1#" index="i">
    <cfset possibleMonth = possibleMonths[i%12+1]/>
    <cfif i%12 eq 1>
        <cfset currentYear++/>
    </cfif>
    <cfset colName = "#possibleMonth##currentYear#"/>
    <cfset colNamesList = listAppend(colNamesList,colName)/>
    <cfloop list="colNamesList" index="j">
        
        
    </cfloop>
</cfloop>
<cfdump var="#data#"><cfabort>
<cfset $.slatwall.getService('hibachiService').export( 
    columns=colNamesList,
    columnNames=colNamesList 
    ,data=data
)/>

<!---<cfset $.slatwall.getService('hibachiService').export( 
    columns=colNamesList,
    columnNames=colNamesList 
    ,data=data
)/>--->