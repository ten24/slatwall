<cfoutput>
	<!--- let's keep track of all the applied filters so we can clear all later --->
  <cfset allFiltersAndValues = '' />
  <!--- for every property in the url struct...--->
  <cfloop collection="#url#" item="queryParam">
  	
  	<!--- We don't want property names that start with p:, for pagination, among other stuff. Let's
  	define only the ones we want --->
  	<cfif findNoCase("r:",queryParam) OR findNoCase("f:",queryParam) OR findNoCase("keywords",queryParam)>
  		
  		<!--- some values will be comma separated such as r:defaultSku.price:10^20,100^ --->
	  	<cfset queryValuesSeparatedWithCommas = url[queryParam] />
	  	<cfset allFiltersAndValues = allFiltersAndValues & queryParam & '=' & queryValuesSeparatedWithCommas />
		<!--- let's split them, since we want one badge for each value ---->
		<cfset values = listToArray(queryValuesSeparatedWithCommas) />
		<cfloop array="#values#" index="value">
			<!---- save unformatted value so we can use it to remove the filter from the url later ----> 
			<cfset unformattedValue = value />
			
			<!--- if we have a '^' in the value, it's a range. Right now we are treating every range as
			currency. We might want to add findNoCase('price',value) later to this if statement to make sure ---->
			<cfif findNoCase("^",value)>
				<!--- regex captures numbers and makes an array of them, so 0^300 becomes [0,300] --->
				<cfset groupOfNumbers = reMatch('([0-9])+',value) />
				<cfif arrayLen(groupOfNumbers) EQ 1>
					<!--- single number in range, let's add '+' to end of value --->
					<cfset value = dollarFormat(groupOfNumbers[1]) & ' +' />
				<cfelse>
					<!--- not single number, let's just assume we have two --->
					<cfset groupOfNumbers[1] = dollarFormat(groupOfNumbers[1]) />
					<cfset groupOfNumbers[2] = dollarFormat(groupOfNumbers[2]) />
					<cfset value = arrayToList(groupOfNumbers,' to ') />
				</cfif>
			</cfif>
			<!--- function removes existing query param if you pass it in --->
			<a href="#$.slatwall.getService('hibachiCollectionService').buildURL( '#queryParam#=#unformattedValue#' )#" class="badge badge-secondary"> #$.slatwall.getService('hibachiUtilityService').hibachiHTMLEditFormat(value)# &times;</a>
		</cfloop>
	  	</cfif>
</cfloop>
<!--- remove all saved query params --->
<cfif len(allFiltersAndValues)>
	<a href="#$.slatwall.getService('hibachiCollectionService').buildURL('#htmlEditFormat(allFiltersAndValues)#')#" class="badge badge-danger">Clear All &times;</a>  
</cfif>
</cfoutput>