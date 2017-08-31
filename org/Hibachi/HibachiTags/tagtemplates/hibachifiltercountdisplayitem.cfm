<cfoutput>
	<cfif arraylen(arguments.optionData)>
		<li class="filterObj">
            <div class="header-wrapper">
				<span class="arrow arrowToggle"><i class="fa fa-angle-up"></i></span>
				<span>#arguments.title#</span>
            </div>
			<ul class="children active">
				<cfloop array="#arguments.optionData#" index="option">
					<cfif structKeyExists(option,'name') && structKeyExists(option,'value')>
						<cfif option['count'] gt 0 AND len(trim(option['name']))>
							<cfset fullbuildUrl = "#filterType#:#filterIdentifier#=#option['value']#"/>
							<li>
								<cfset isFilterApplied = attributes.collectionList.isFilterApplied(filterIdentifier,option['value'],filterType)/>
								<a 
									href="#attributes.hibachiScope.getService('hibachiCollectionService').buildURL('#fullbuildUrl#')#" 
									<cfif isFilterApplied>
										class="remove" 
										data-toggle="tooltip" 
										data-placement="right" 
										title="Remove"
									</cfif>>
									<cfif isFilterApplied><i class="fa fa-times"></i></cfif>
									<span class="filterTitle">#option['name']#</span>
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