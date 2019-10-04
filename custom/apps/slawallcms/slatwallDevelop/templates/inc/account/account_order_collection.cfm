<!--- Order History Collection --->
<cfset local.ordersCollection = $.slatwall.getService("OrderService").getOrderCollectionList() />
<cfset local.ordersCollection.addFilter("account.accountID", "#$.slatwall.account().getAccountID()#", "=") /> 

<cfif $.slatwall.content().getUrlTitle() EQ "order-history" OR $.slatwall.content().getUrlTitle() EQ "order">
    <!--- Placed Orders --->
    <cfset local.ordersCollection.addFilter("orderStatusType.systemCode", "ostNotPlaced", "!=") />
<cfelse>
    <!--- Quotes --->
    <cfset local.ordersCollection.addFilter("orderStatusType.systemCode", "ostNotPlaced", "=") />
    <!--- <cfset local.ordersCollection.addFilter("quoteFlag","1","=") /> 
    <cfset local.ordersCollection.addFilter("quotePriceExpiration",NOW(),">") /> --->
</cfif>

<cfset local.ordersCollection.addFilter("orderType.systemCode", "otSalesOrder","=") />
<cfset local.ordersCollection.addDisplayProperty('orderStatusType.typeName') />
<cfset local.ordersCollection.addDisplayProperty('calculatedTotal') />
<cfset local.ordersCollection.addDisplayProperty('createdDateTime|DESC') />
<cfset local.ordersCollection.applyData()>

<cfset local.ordersCollection.setPageRecordsShow(10)>

<cfset local.orders = local.ordersCollection.getPageRecords() />
