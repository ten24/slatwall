<cfparam name="attributes.brandPropertyName" type="string" />				<!---IE billTobrand.brandID --->
<cfparam name="attributes.brandLabelText" type="string" />					<!---IE Bill To brand --->
<cfparam name="attributes.labelClass" type="string" default="control-label col-sm-4"/>
<cfparam name="attributes.edit" type="boolean" default="false"/>				<!---IE rc.edit value --->
<cfparam name="attributes.rbKey" type="string" default="entity.brand" />		<!--- entity.brand --->
<cfparam name="attributes.selectedFormatString" type="string" default="brands >> ${brandName}"/><!--- Store brands >> ${brandName} --->
<cfparam name="attributes.showActiveBrandsFlag" type="boolean" default="false" />
<cfparam name="attributes.maxrecords" type="string" default="25" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<!--- Generic brand Typeahead --->
			<cfif !isNull(attributes.property)><!--- Only show if we have a default --->
				<div class="form-group" ng-show="'#attributes.edit#' == 'false'" ng-cloak >
					<label for="#attributes.brandPropertyName#" class="control-label col-sm-4" >
						<span class="s-title">#attributes.brandLabelText#</span>
					</label>
					<div class="col-sm-8">
						<p class="form-control-static value">#attributes.property.getbrandName()#</p>
					</div>
					<cfif attributes.edit EQ 'false'>
	   					<input type="hidden" name="#attributes.brandPropertyName#" value="#attributes.property.getbrandID()#" />
	   				</cfif>
				</div>
				</cfif>
				<div ng-show="'#attributes.edit#' == 'true'" ng-cloak class="form-group">
					<label for="#attributes.brandPropertyName#" class="control-label col-sm-4">
						<span class="s-title">#attributes.brandLabelText#</span>
					</label>
					<div class="col-sm-8" style="padding-left:10px;padding-right:0px">
						<!--- Generic Configured brand --->
						<cfif !isNull(attributes.property) && !isNull(attributes.property.getBrandID())>
							<cfset initialEntityID = "#attributes.property.getBrandID()#">
						</cfif>
						<cfif isNull(initialEntityID)>
							<cfset initialEntityID = "">
						</cfif>
						<sw-typeahead-input-field
								data-entity-name="Brand"
						        data-property-to-save="brandID"
						        data-property-to-show="brandName"
						        data-properties-to-load="brandID,brandName,activeFlag"
						        data-show-add-button="true"
						        data-show-view-button="true"
						        data-placeholder-rb-key="#attributes.rbKey#"
						        data-placeholder-text="Search brands"
						        data-multiselect-mode="false"
						        data-filter-flag="true"
						        data-selected-format-string="#attributes.selectedFormatString#"
						        data-field-name="#attributes.brandPropertyName#"
						        data-initial-entity-id="#initialEntityID#"
						        data-max-records="#attributes.maxrecords#"
						        data-order-by-list="brandName|ASC">
	
						    <sw-collection-config
						            data-entity-name="Brand"
						            data-collection-config-property="typeaheadCollectionConfig"
						            data-parent-directive-controller-as-name="swTypeaheadInputField"
						            data-all-records="true">
						    	
						    								<!--- Columns --->
	 							<sw-collection-columns>
	 								<sw-collection-column data-property-identifier="brandName" is-searchable="true"></sw-collection-column>
	 								<sw-collection-column data-property-identifier="brandID" is-searchable="false"></sw-collection-column>
	 							</sw-collection-columns>
	 							
	 							<!--- Order By --->
	 					    	<sw-collection-order-bys>
	 					        	<sw-collection-order-by data-order-by="brandName|ASC"></sw-collection-order-by>
	 					    	</sw-collection-order-bys>
	
						    	<!--- Filters --->
						    	<cfif attributes.showActivebrandsFlag EQ true>
							    	<sw-collection-filters>
			                            <cfif attributes.showActivebrandsFlag EQ true>	
			                            	<sw-collection-filter data-property-identifier="activeFlag" data-comparison-operator="=" data-comparison-value="1"></sw-collection-filter>
			                        	</cfif>
			                        </sw-collection-filters>
						    	</cfif>
						    </sw-collection-config>
	
							<span sw-typeahead-search-line-item data-property-identifier="brandName" dropdownOpen="false" is-searchable="true"></span><br>
	
						</sw-typeahead-input-field>
					</div>
				</div>
	</cfoutput>
</cfif>