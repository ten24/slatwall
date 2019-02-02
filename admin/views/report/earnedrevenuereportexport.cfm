<cfparam name="rc.subscriptionType" default=""/>
<cfparam name="rc.productType" default=""/>
<cfparam name="rc.productID" default=""/>
<cfparam name="rc.minDate" default="#CreateDate(Year(now()),1,1)#"/>
<cfparam name="rc.maxDate" default="#CreateDate(Year(now()),Month(now()),Day(now()))#"/>
<
<cfparam name="showProducts" default="true"/>
<!---axe the output--->
<cfsilent>
    <cfinclude template="./earnedrevenuereport.cfm"/>
</cfsilent>
<cfset currentMonth = Month(rc.minDate)/>
<cfset currentYear = Year(rc.minDate)/>
                

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
<cfloop from="#currentMonth-1#" to="#to-1#" index="i">
    <cfset possibleMonth = possibleMonths[i%12+1]/>
    <cfset colName = "#possibleMonth##currentYear#"/>
    <cfset colNamesList = listAppend(colNamesList,colName)/>
    
</cfloop>
<cfset colNamesArray = listToArray(listRest(colNamesList))/>
<cfloop from=1 to="#arraylen(colNamesArray)#" index="j">
    <cfset data[1][colNamesArray[j]] = subscriptionsEarning[j]/>
    <cfset data[2][colNamesArray[j]] = earned[j]/>
    <cfset data[3][colNamesArray[j]] = taxAmount[j]/>
    <cfset data[4][colNamesArray[j]] = refunded[j]/>
    <cfset data[5][colNamesArray[j]] = refundedTaxAmount[j]/>
    <cfset data[6][colNamesArray[j]] = possibleYearTotal[j]/>
</cfloop>

<cfloop from="8" to="#7+arraylen(productsWithDeliveries)#" index="i">
    <cfset productWithDelivery = productsWithDeliveries[i-7]/>
    <cfset productName = productWithDelivery['orderitem_sku_product_productName']/>
    
    <cfloop from=1 to="#arraylen(colNamesArray)#" index="j">
        <cfset data[i][colNamesArray[j]] = productsWithDeliveriesMap[productName].earned[j] - productsWithDeliveriesMap[productName].refunded[j]/>
    </cfloop>
</cfloop>
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