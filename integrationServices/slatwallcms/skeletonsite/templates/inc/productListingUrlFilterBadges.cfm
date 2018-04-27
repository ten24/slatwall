<cfoutput>
	<!--- let's keep track of all the applied filters so we can clear all later --->
  <cfset local.allFiltersAndValues = '' />
  <!--- for every property in the url struct...--->
  <cfset local.counter = 0 />
  <cfloop collection="#url#" item="local.queryParam">

  	<!--- We don't want property names that start with p:, for pagination, among other stuff. Let's
  	define only the ones we want --->
  	<cfif findNoCase("r:",local.queryParam) OR findNoCase("f:",local.queryParam) OR findNoCase("keywords",local.queryParam)>
  		<cfset local.counter++ />
  		<!--- some values will be comma separated such as r:defaultSku.price:10^20,100^ --->
	  	<cfset local.queryValuesSeparatedWithCommas = url[local.queryParam] />
	  	<!--- If this is not the first filter, let's add & between them ---->
	  	<cfif local.counter GT 1>
	  		<cfset local.allFiltersAndValues = local.allFiltersAndValues & '&' />
	  	</cfif>
	  	<cfset local.allFiltersAndValues = local.allFiltersAndValues & local.queryParam & '=' & local.queryValuesSeparatedWithCommas />
		<!--- let's split them, since we want one badge for each value ---->
		<cfset local.values = listToArray(local.queryValuesSeparatedWithCommas) />
		<cfloop array="#local.values#" index="local.value">
			<!---- save unformatted value so we can use it to remove the filter from the url later ----> 
			<cfset local.unformattedValue = local.value />
			
			<!--- if we have a '^' in the value, it's a range. Right now we are treating every range as
			currency. We might want to add findNoCase('price',value) later to this if statement to make sure ---->
			<cfif findNoCase("^",local.value)>
				<!--- regex captures numbers and makes an array of them, so 0^300 becomes [0,300] --->
				<cfset local.groupOfNumbers = reMatch('([0-9])+',local.value) />
				<cfif arrayLen(local.groupOfNumbers) EQ 1>
					<!--- single number in range, let's add '+' to end of value --->
					<cfset local.value = dollarFormat(local.groupOfNumbers[1]) & ' +' />
				<cfelse>
					<!--- not single number, let's just assume we have two --->
					<cfset local.groupOfNumbers[1] = dollarFormat(local.groupOfNumbers[1]) />
					<cfset local.groupOfNumbers[2] = dollarFormat(local.groupOfNumbers[2]) />
					<cfset local.value = arrayToList(local.groupOfNumbers,' to ') />
				</cfif>
			<!---- in the case of a many-to-many, value will be an ID. Let's find the entity 
			and get its simple representation instead ---->
			<cfelseif isValid("regex", local.value, "^[a-f0-9]{32}$")>
				  	<cfset local.propertyIdentifierList = listGetAt(local.queryParam,2,':') />
					<cfset local.propertyIdentifier = listLast(local.propertyIdentifierList,'.') />
					<cfset local.entityName = replace(local.propertyIdentifier,'ID','') />
					<cfset local.currentEntity = $.slatwall.getEntity(local.entityName,value) />
					<cfif NOT isNull(local.currentEntity)>
						<cfset local.value = local.currentEntity.getSimpleRepresentation() />
					<cfelse>
					<!----- Undesired value, let's just quit here ---->
					<cfcontinue>
					</cfif>
			</cfif>
			<!--- function removes existing query param if you pass it in --->
			<a href="#$.slatwall.getService('hibachiCollectionService').buildURL( '#local.queryParam#=#local.unformattedValue#' )#" class="badge badge-secondary"> #$.slatwall.getService('hibachiUtilityService').hibachiHTMLEditFormat(local.value)# &times;</a>
		</cfloop>
	  	</cfif>
</cfloop>
<!--- remove all saved query params --->
<cfif len(local.allFiltersAndValues)>
	<a href="#$.slatwall.getService('hibachiCollectionService').buildURL('#local.allFiltersAndValues#')#" class="badge badge-danger">Clear All &times;</a>  
</cfif>
</cfoutput>