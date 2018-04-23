<cfoutput>
	<!--- look over appliedFilters and make sure to add them as option with a count of 0 if they are applied but filtered out --->
	
	<cfif arraylen(arguments.optionData)>
		<cfset uuid = createUUID()/>
		<div class="block" id="#uuid#FilterCountDisplayItem">
			<a href="##" class="trigger headline <cfif arguments.openTab>active</cfif>">#arguments.title#</a>
			<div id="#uuid#triggerable" class="triggable" <cfif !arguments.openTab>style="display:none;"</cfif>>
                <ul>
					<cfloop array="#arguments.optionData#" index="option">
						
						<cfif structKeyExists(option,'name') && structKeyExists(option,'value')>
							<cfset isFilterApplied = attributes.collectionList.isFilterApplied(filterIdentifier,option['value'],attributes.filterType,attributes.comparisonOperator)/>
							<cfset restOfTheWorldOptionValue = '2c9180825e86bd9b015e969c314600db,2c928084607629f1016076d020d012ed|2c9180825e86bd9b015e969c314600db,2c928084607629f1016076d039ad1313|2c9180825e86bd9b015e969c314600db,2c928084607629f1016076d03aa61315|2c9180825e86bd9b015e969c314600db,2c928084607629f1016076d046d9132c'/>
							<cfif attributes.propertyIdentifier eq 'appellation'>
								<!---custom logic for restofworld--->
								
								
								<cfif option['value'] eq restOfTheWorldOptionValue and structKeyExists(url,'f:appellation.categoryIDPath:like') and findnocase(restOfTheWorldOptionValue,url['f:appellation.categoryIDPath:like']) > 
									<cfset isFilterApplied=true/>
								</cfif>
								
							</cfif>
							<cfif len(trim(option['name'])) OR isFilterApplied>
								<cfset buildURLValue = option['value']/>
								<cfset optionBuildUrl = attributes.baseBuildUrl & "#buildURLValue#"/>
								<li <cfif !arguments.openTab || (!isFilterApplied && !listFindnocase(arguments.optionPriorityList,option['name'])) >style="display:none;"</cfif>>
									<div class="checkbox">
										<label for="#option['name']#">
                                        <input
	                                        	
	                                        	onclick="window.location='#attributes.hibachiScope.getService('hibachiCollectionService').buildURL('#optionBuildUrl#')#'"
	                                        	type="checkbox" id="#option['name']#"
	                                        	<cfif isFilterApplied>
													checked
												</cfif>
												value="#option['value']#"
                                        >
                                        <cfif !isSimpleValue(arguments.formatter)>
											<cfset optionName = arguments.formatter(option['name'])/>
										<cfelseif len(arguments.formatter)>
											<cfset optionName = attributes.hibachiScope.getService('hibachiUtilityService').invokeMethod(arguments.formatter,{1=option['name']})/>
										<cfelse>
											<cfset optionName = option['name']/>
										</cfif>
                                        #optionName# </label>
                                    </div>
								</li>
							</cfif>
						</cfif>
					</cfloop>
				</ul>
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
				<script>
					(function(){
				        //show all li
				        $('###uuid#SeeAll').on('click',function (e) {
				        	$('###uuid#FilterCountDisplayItem ul li').show();
				        	$('###uuid#SeeAll').hide();
				        });
				        
				        //check how many items are showing and if under the 5 then show other li up til 5 showing
				        var showTop5 = function(){
				        	var priorityOptionArray = '#lcase(arguments.optionPriorityList)#'.split(',');
			        	
			        		$('###uuid#FilterCountDisplayItem ul li:hidden').each(function(index,value){
			        			if(
			        				$(this).find('input')[0].checked
			        			){
			        				
			        				$(this).show();
			        				$('###uuid#FilterCountDisplayItem').slideDown();
			        			}
			        		});
			        		
				        	$('###uuid#FilterCountDisplayItem ul li:hidden').each(function(index,value){
				        		if($('###uuid#FilterCountDisplayItem ul li:visible').length < #seeAllMax# 
				        		&& priorityOptionArray.indexOf($(this).find('input')[0].value.toLowerCase()) >= 0){
					        		$(this).show();
				        		}
				        	});
				        	
				        	$('###uuid#FilterCountDisplayItem ul li:hidden').each(function(index,value){
				        		if($('###uuid#FilterCountDisplayItem ul li:visible').length < #seeAllMax#){
				        			$(this).show();
				        		}
				        	});
					    
				        }
				        
				        $('###uuid#FilterCountDisplayItem ul li:hidden').each(function(index,value){
		        			if(
		        				$(this).find('input')[0].checked
		        			){
		        				$('###uuid#triggerable').slideDown();
		        				return;
		        			}
		        			
		        		});
				        
				        $('###uuid#FilterCountDisplayItem').on('click',function(e){
				        	showTop5();
				        });
				        
				        if($('###uuid#triggerable').is(':visible')){
				        	showTop5();
				        }
				        
				       
				        	
				        
				    })();
				</script>
				<cfif isArray(attributes.rangeData)>
					<cfset minValue = ""/>
					<cfset maxValue = ""/>
					<cfset rangeKey = 'r:#attributes.propertyIdentifier#'/>
					<cfif structKeyExists(url,rangeKey)>
						<cfset minValue = listFirst(url[rangeKey],'^')>
						<cfset maxValue = listLast(url[rangeKey],'^')>
					</cfif>
					<hr class="dashed">
					<div class="apply row">
						<cfset rangeSearchID = rereplace(createUUID(),'-','','all')/>
						<div class="col-3 form-group">
			            	<input id="min#rangeSearchID#" class="form-control" type="text" value="#minValue#"/>
			            </div>
			            <div class="col-2 form-group">
	                        <span class="sep">to</span>
	                    </div>
	                    <div class="col-3 form-group">
				        	<input id="max#rangeSearchID#" class="form-control" type="text"   value="#maxValue#"/>
				        </div>
			            <div class="col-4 form-group">
			            	<a id="apply#rangeSearchID#" href="##" class="btn">APPLY</a>
			            </div>
			        </div>
				</cfif>

		        <!--- script drives applying ranges. id specific functions here. generic script in HibachiFilterCountDisplayItem--->
		        <cfif isArray(attributes.rangeData)>
			        <script>
	
					    (function(){
					        //Submit search
					        $('##min#rangeSearchID#').on('change',function (e) {
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

	</cfif>
</cfoutput>
