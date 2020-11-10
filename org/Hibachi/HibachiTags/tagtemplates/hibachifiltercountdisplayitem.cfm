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
						<cfset isFilterApplied = attributes.collectionList.isFilterApplied(filterIdentifier,option['value'],attributes.filterType,attributes.comparisonOperator)/>
						
						<cfif (option['count'] gt 0 AND len(trim(option['name']))) OR isFilterApplied>
							
							<cfset optionBuildUrl = attributes.baseBuildUrl & "#urlEncodedFormat(option['value'])#"/>
							<li>
								
								<a 
									href="#attributes.hibachiScope.getService('hibachiCollectionService').buildURL(queryAddition='#optionBuildUrl#',delimiter='||')#" 
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
		<cfif attributes.filterType eq 'r' and attributes.showApplyRange>
			<hr class="dashed">
			<div class="apply row">
				<cfset rangeSearchID = rereplace(createUUID(),'-','','all')/>
				<div class="col-3 form-group">
	            	<input id="min#rangeSearchID#" class="form-control" type="text" placeholder="0"/>
	            </div>
	            <div class="col-2 form-group">
                    <span class="sep">to</span>
                </div>
                <div class="col-3 form-group">
		        	<input id="max#rangeSearchID#" class="form-control" type="text" placeholder="0"/>
		        </div>
	            <div class="col-4 form-group">
	            	<a id="apply#rangeSearchID#" href="##" class="btn">APPLY</a>
	            </div>
	        </div>
	        <!--- script drives applying ranges. id specific functions here. generic script in HibachiFilterCountDisplayItem--->
	        <script>
			
			    (function(){
			        //Submit search
			        $('##min#rangeSearchID#').on('change',function (e) {
			        	updateApplyHref('#rangeSearchID#','#replace(attributes.baseBuildUrl,':in','')#');
			        });
			        
			        $('##max#rangeSearchID#').on('change',function (e) {
			        	updateApplyHref('#rangeSearchID#','#replace(attributes.baseBuildUrl,':in','')#');
			        });
			        
			    })();
			</script>
		</cfif>
	</cfif>
</cfoutput>