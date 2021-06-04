<cfoutput>
	<!--- look over appliedFilters and make sure to add them as option with a count of 0 if they are applied but filtered out --->
	
	<!--<div class="card mb-4">-->
 <!--   		<div class="card-header" id="headingOne">-->
 <!--   			<h5 class="mb-0">-->
 <!--   				<button class="btn btn-link p-0" data-toggle="collapse" data-target="##collapseOne" aria-expanded="true" aria-controls="collapseOne">-->
 <!--   				Product Type-->
 <!--   				</button>-->
 <!--   			</h5>-->
 <!--   		</div>-->
 <!--   		<div id="collapseOne" class="collapse" aria-labelledby="headingOne" data-parent="##accordion">-->
 <!--   			<div class="card-body">-->
 <!--                   <div class="form-check">-->
 <!--                     <input class="form-check-input" type="checkbox" value="" id="productType">-->
 <!--                     <label class="form-check-label" for="category">Product Type 1</label>-->
 <!--                     <span class="badge badge-secondary float-right mt-1">24</span>-->
 <!--                   </div>-->
 <!--               </div>-->
 <!--   		</div>-->
 <!--   	</div>-->
	<cfif arraylen(arguments.optionData)>
		<cfset uuid = createUUID()/>
		<div class="card mb-4">
			<div class="card-header" id="#uuid#FilterCountDisplayItem">
				<h5 class="mb-0">
					<button class="btn btn-link p-0" data-toggle="collapse" data-target="##collapse#uuid#" aria-expanded="true" aria-controls="collapse#uuid#">
					#arguments.title#
					</button>
				</h5>
			</div>
		   	<div id="collapse#uuid#" class="collapse" aria-labelledby="#uuid#FilterCountDisplayItem" data-parent="##accordion">
				<div class="card-body">
            		<cfloop array="#arguments.optionData#" index="option">
            			<cfset isFilterApplied = attributes.collectionList.isFilterApplied(filterIdentifier,option['value'],attributes.filterType,attributes.comparisonOperator)/>
						<div class="form-check">
						<cfif structKeyExists(option,'name') && structKeyExists(option,'value')>
							<cfset isFilterApplied = attributes.collectionList.isFilterApplied(filterIdentifier,option['value'],attributes.filterType,attributes.comparisonOperator)/>
							<cfif len(trim(option['name'])) OR isFilterApplied>
								<cfset buildURLValue = option['value']/>
								<cfset optionBuildUrl = attributes.baseBuildUrl & "#buildURLValue#"/>
			                	<input 
			                		class="form-check-input"
			                		onclick="window.location='#attributes.hibachiScope.getService('hibachiCollectionService').buildURL( queryAddition='#optionBuildURl#',valueDelimiter='||')#'" 
			                		type="checkbox" 
			                		value="#optionBuildUrl#" 
			                		data-identifier="#buildURLValue#"
			                		data-option-name="#option['name']#"
            		                <cfif isFilterApplied>
										checked
									</cfif>
			                		>
			                	<label class="form-check-label" for="#arguments.title##option['name']#">#option['name']#</label>
							</cfif>
						</cfif>
						</div>
					</cfloop>
			<cfset seeAllMax = 5/>
			<cfif attributes.propertyIdentifier eq 'appellation'>
				<cfset seeAllMax = 100/>	
			</cfif>
			<cfif arraylen(arguments.optionData) gt seeAllMax>
				<a href="##" id="#uuid#SeeAll">See All</a>
			</cfif>
			
			<cfif structKeyExists(url,listFirst(attributes.baseBuildUrl,'='))>
				<a href="#attributes.hibachiScope.getService('hibachiCollectionService').buildURL('#attributes.baseBuildUrl##url[listFirst(attributes.baseBuildUrl,'=')]#')#" id="#uuid#ClearFilters">Clear #arguments.title# Filters</a>
			</cfif>
			<cfif isArray(attributes.rangeData)>
				<cfset minValue = ""/>
				<cfset maxValue = ""/>
				<cfset rangeKey = 'r:#attributes.propertyIdentifier#'/>
				<cfif structKeyExists(url,rangeKey)>
					<cfset minValue = listFirst(url[rangeKey],'^')>
					<cfset maxValue = listLast(url[rangeKey],'^')>
				</cfif>
				<cfset rangeSearchID = rereplace(createUUID(),'-','','all')/>
			    <form>
                    <div class="form-row">
                        <div class="col">
                            <input type="text" id="min#rangeSearchID#" class="form-control" placeholder="Min" value="#minValue#">
                        </div>
                        <div class="col">
                            <input type="text" id="max#rangeSearchID#" class="form-control" placeholder="Max" value="#maxValue#">
                        </div>
                    </div>
                    <a id="apply#rangeSearchID#" href="##" class="btn btn-sm btn-block btn-secondary mt-1">Apply</a>
                </form>
			</cfif>
	        <!--- script drives applying ranges. id specific functions here. generic script in HibachiFilterCountDisplayItem--->
	        <cfif isArray(attributes.rangeData)>
		        <script>
				    (function(){
				        //Submit search
				        console.log($('##min#rangeSearchID#'));
				        $('##min#rangeSearchID#').on('change',function (e) {
				        	console.log('#rangeSearchID#','#replace(replace(attributes.baseBuildUrl,':in',''),'f:','r:')#');
					        	updateApplyHref('#rangeSearchID#','#replace(replace(attributes.baseBuildUrl,':in',''),'f:','r:')#');
				        });

				        $('##max#rangeSearchID#').on('change',function (e) {
					        	updateApplyHref('#rangeSearchID#','#replace(replace(attributes.baseBuildUrl,':in',''),'f:','r:')#');
				        });

				    })();
				</script>
			</cfif>
		</div>
	</div>
				</div>
	</cfif>
</cfoutput>
