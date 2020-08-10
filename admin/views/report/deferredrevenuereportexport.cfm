<cfparam name="rc.subscriptionType" default=""/>
<cfparam name="rc.productType" default=""/>
<cfparam name="rc.productID" default=""/>
<cfparam name="rc.minDate" default="#CreateDate(Year(now()),Month(now()),Day(now()))#"/>
<cfparam name="rc.maxDate" default="#CreateDate(Year(now()),12,31)#"/>
<cfset deferredRevenueData = $.slatwall.getService('subscriptionService').getDeferredRevenueData(rc.subscriptionType,rc.productType,rc.productID,rc.minDate,rc.maxDate) />

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
	'deferredTotal',
	'deferredRevenueLeftToBeRecognized',
	'deferredTaxLeftToBeRecognized',
	'deferredTotalLeftToBeRecognized'
]/>
<cfloop from=1 to="#arraylen(headerRowItems)#" index="i">
    <cfset data[i] = {}/>
    <cfset data[i]['Headers']=headerRowItems[i]/>
</cfloop>
<!---get headers--->
<!---properly order columns list--->
<cfloop from="#currentMonth-1#" to="#to-1#" index="i">
    <cfset possibleMonth = possibleMonths[i%12+1]/>
    <cfif i%12 eq 0 and i neq 1>
        <cfset currentYear++/>
    </cfif>
    <cfset colName = "#possibleMonth##currentYear#"/>
    <cfset colNamesList = listAppend(colNamesList,colName)/>
    <cfset deferredRevenueDataForMonth = deferredRevenueData["#currentYear#-#possibleMonth#"]/>
    <cfloop from=1 to="#arraylen(headerRowItems)#" index="i">
        <cfset data[i][colName]=deferredRevenueDataForMonth[headerRowItems[i]]/>
    </cfloop>
</cfloop>
<cfset $.slatwall.getService('hibachiService').export( 
    columns=colNamesList,
    columnNames=colNamesList 
    ,data=data
)/>