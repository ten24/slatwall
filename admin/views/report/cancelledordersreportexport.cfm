<cfparam name="rc.subscriptionType" default=""/>
<cfparam name="rc.productType" default=""/>
<cfparam name="rc.productID" default=""/>
<cfparam name="rc.minDate" default="#CreateDate(Year(now()),1,1)#"/>
<cfparam name="rc.maxDate" default="#CreateDate(Year(now()),Month(now()),Day(now()))#"/>

<cfparam name="showProducts" default="true"/>
<!---axe the output--->
<cfsilent>
    <cfinclude template="./cancelledordersreport.cfm"/>
</cfsilent>
<cfset currentMonth = Month(rc.minDate)/>
<cfset currentYear = Year(rc.minDate)/>
                

<cfset colNamesList = 'Headers'/>
<cfset data = [5]/>
<!---explicitly written for control of the ordering--->
<cfset headerRowItems = [
	'Cancelled Subscriptions',
	''
]/>
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
<cfloop from="#currentMonth-1#" to="#to-1#" index="i">
    <cfset possibleMonth = possibleMonths[i%12+1]/>
    <cfset colName = "#possibleMonth##currentYear#"/>
    <cfset colNamesList = listAppend(colNamesList,colName)/>
    
</cfloop>
<cfset colNamesArray = listToArray(listRest(colNamesList))/>
<cfloop from=1 to="#arraylen(colNamesArray)#" index="j">
    <cfset data[1][colNamesArray[j]] = subscriptionUsageIDCount[j]/>
</cfloop>

<cfset $.slatwall.getService('hibachiService').export( 
    columns=colNamesList,
    columnNames=colNamesList 
    ,data=data
)/>
