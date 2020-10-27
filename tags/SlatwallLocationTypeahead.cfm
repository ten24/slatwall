<cfparam name="attributes.locationPropertyName" type="string" />				<!---IE billToLocation.locationID --->
<cfparam name="attributes.locationLabelText" type="string" />					<!---IE Bill To Location --->
<cfparam name="attributes.labelClass" type="string" default="control-label col-sm-4"/>
<cfparam name="attributes.edit" type="boolean" default="false"/>				<!---IE rc.edit value --->
<cfparam name="attributes.rbKey" type="string" default="entity.location" />		<!--- entity.location --->
<cfparam name="attributes.selectedFormatString" type="string" default="Store Locations >> ${locationName}"/><!--- Store Locations >> ${locationName} --->
<cfparam name="attributes.showActiveLocationsFlag" type="boolean" default="false" />
<cfparam name="attributes.ignoreParentLocationsFlag" type="boolean" default="false" />
<cfparam name="attributes.topLevelLocationID" type="string" default="" />
<cfparam name="attributes.selectedLocationID" type="string" default="" />
<cfparam name="attributes.maxrecords" type="string" default="25" />
<cfif thisTag.executionMode is "start">
	<cfoutput>
		<!--- Generic Location Typeahead --->
			<cfif !isNull(attributes.property)><!--- Only show if we have a default --->
			<div ng-show="'#attributes.edit#' == 'false'" ng-cloak  class="form-group">
				<label for="#attributes.locationPropertyName#" class="control-label col-sm-4" >
					<span class="s-title">#attributes.locationLabelText#</span>
				</label>
				<div class="col-sm-8">
					<p class="form-control-static value">#attributes.property.getLocationName()#</p>
				</div>
				<cfif attributes.edit EQ 'false'>
   					<input type="hidden" name="#attributes.locationPropertyName#" value="#attributes.property.getLocationID()#" />
   				</cfif>
			</div>
			</cfif>
			<div class="form-group" ng-show="'#attributes.edit#' == 'true'" ng-cloak>
				<label for="#attributes.locationPropertyName#" class="control-label col-sm-4">
					<span class="s-title">#attributes.locationLabelText#</span>
				</label>
				<div class="col-sm-8">
					<!--- Generic Configured Location --->
					<cfif not len(attributes.selectedLocationID)>
						<cfif !isNull(attributes.property) && !isNull(attributes.property.getLocationID())>
							<cfset attributes.selectedLocationID = attributes.property.getLocationID()>
						</cfif>
					</cfif>
					<sw-typeahead-input-field
							data-entity-name="Location"
					        data-property-to-save="locationID"
					        data-property-to-show="locationName"
					        data-properties-to-load="locationID,locationName,activeFlag"
					        data-show-add-button="true"
					        data-show-view-button="true"
					        data-placeholder-rb-key="#attributes.rbKey#"
					        data-placeholder-text="Search Locations"
					        data-multiselect-mode="false"
					        data-filter-flag="true"
					        data-selected-format-string="#attributes.selectedFormatString#"
					        data-field-name="#attributes.locationPropertyName#"
					        data-initial-entity-id="#attributes.selectedLocationID#"
					        data-max-records="#attributes.maxrecords#"
					        data-order-by-list="locationName|ASC">

					    <sw-collection-config
					            data-entity-name="Location"
					            data-collection-config-property="typeaheadCollectionConfig"
					            data-parent-directive-controller-as-name="swTypeaheadInputField"
					            data-all-records="true">
					    	
					    								<!--- Columns --->
 							<sw-collection-columns>
 								<sw-collection-column data-property-identifier="locationName" is-searchable="true"></sw-collection-column>
 								<sw-collection-column data-property-identifier="locationID" is-searchable="false"></sw-collection-column>
 							</sw-collection-columns>
 							
 							<!--- Order By --->
 					    	<sw-collection-order-bys>
 					        	<sw-collection-order-by data-order-by="locationName|ASC"></sw-collection-order-by>
 					    	</sw-collection-order-bys>

					    	<!--- Filters --->
					    	<cfif attributes.showActiveLocationsFlag EQ true OR attributes.ignoreParentLocationsFlag EQ true>
						    	<sw-collection-filters>
		                            <cfif attributes.showActiveLocationsFlag EQ true>	
		                            	<sw-collection-filter data-property-identifier="activeFlag" data-comparison-operator="=" data-comparison-value="1"></sw-collection-filter>
		                        	</cfif>
		                        	<cfif attributes.ignoreParentLocationsFlag EQ true>
		                        		<sw-collection-filter data-property-identifier="parentLocation" data-comparison-operator="is not" data-comparison-value="null"></sw-collection-filter>
									</cfif>
									<cfif len(attributes.topLevelLocationID)>
										<sw-collection-filter data-property-identifier="locationIDPath" data-comparison-operator="like" data-comparison-value="%#attributes.topLevelLocationID#%"></sw-collection-filter>
		                        	</cfif>
		                        </sw-collection-filters>
					    	</cfif>
					    </sw-collection-config>

						<span sw-typeahead-search-line-item data-property-identifier="locationName" is-searchable="true"></span><br>

					</sw-typeahead-input-field>
				</div>
			</div>
	</cfoutput>
</cfif>