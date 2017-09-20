<cfoutput>
	<!--- look over appliedFilters and make sure to add them as option with a count of 0 if they are applied but filtered out --->
	
	<cfif arraylen(arguments.optionData)>
		<li class="filterObj">
            <div class="header-wrapper">
				<span class="arrow arrowToggle"><i class="fa fa-angle-up"></i></span>
				<span>#arguments.title#</span>
            </div>
			<ul class="children active">
				<cfloop array="#arguments.optionData#" index="option">
					<cfif structKeyExists(option,'name') && structKeyExists(option,'value')>
						<cfif filterType eq "f">
							<cfset comparisonOperator = 'in'/>
						<cfelse>
							<cfset comparisonOperator = ''/>
						</cfif>
						<cfset isFilterApplied = attributes.collectionList.isFilterApplied(filterIdentifier,option['value'],filterType,comparisonOperator)/>
						<cfif (option['count'] gt 0 AND len(trim(option['name']))) OR isFilterApplied>
							<cfset fullbuildUrl = "#filterType#:#filterIdentifier#"/>
							<cfif len(comparisonOperator)>
								<cfset fullbuildUrl &= ":#comparisonOperator#"/>
							</cfif>
							<cfset fullbuildUrl &= "=#option['value']#"/>
							<li>
								
								<a 
									href="#attributes.hibachiScope.getService('hibachiCollectionService').buildURL('#fullbuildUrl#')#" 
									<cfif isFilterApplied>
										class="remove" 
										data-toggle="tooltip" 
										data-placement="right" 
										title="Remove"
									</cfif>>
									<cfif isFilterApplied><i class="fa fa-times"></i></cfif>
									<cfif !isSimpleValue(arguments.formatter)>
										<cfset optionName = arguments.formatter(option['name'])/>
									<cfelseif len(arguments.formatter)>
										<cfset optionName = attributes.hibachiScope.getService('hibachiUtilityService').invokeMethod(arguments.formatter,{1=option['name']})/>
									<cfelse>
										<cfset optionName = option['name']/>
									</cfif>
									<span class="filterTitle">#optionName#</span>
									<span class="count">( #option['count']# )</span>
								</a>
							</li> 
						</cfif>
					</cfif>
				</cfloop>
			</ul>
		</li>
	</cfif>
</cfoutput>