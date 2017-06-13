<cfparam name="attributes.locationPropertyName" type="string" />				<!---IE billToLocation.locationID --->
<cfparam name="attributes.locationLabelText" type="string" />					<!---IE Bill To Location --->
<cfparam name="attributes.labelClass" type="string" default="control-label col-sm-4"/>
<cfparam name="attributes.edit" type="boolean" default="false"/>				<!---IE rc.edit value --->
<cfparam name="attributes.rbKey" type="string" default="entity.location" />		<!--- entity.location --->
<cfparam name="attributes.selectedFormatString" type="string" default="Store Locations >> ${locationName}"/><!--- Store Locations >> ${locationName} --->
<cfparam name="attributes.showActiveLocationsFlag" type="boolean" default="false" />
<cfif thisTag.executionMode is "start">
	<cfoutput>
		<!--- Generic Location Typeahead --->
			<cfif !isNull(attributes.property)><!--- Only show if we have a default --->
			<div ng-show="'#attributes.edit#' == 'false'" ng-cloak>
				<label for="#attributes.locationPropertyName#" class="control-label col-sm-4" style="padding-left: 0px;">
					<span class="s-title">#attributes.locationLabelText#</span>
				</label>
				<div class="col-sm-8" style="padding-left:10px;padding-right:0px">
					#attributes.property.getLocationName()#
				</div>
				<cfif attributes.edit EQ 'false'>
 					<input type="hidden" name="#attributes.locationPropertyName#" value="#attributes.property.getLocationID()#" />
 				</cfif>
			</div>
			</cfif>
			<div ng-show="'#attributes.edit#' == 'true'" ng-cloak>
				<label for="#attributes.locationPropertyName#" class="control-label col-sm-4" style="padding-left: 0px;">
					<span class="s-title">#attributes.locationLabelText#</span>
				</label>
				<div class="col-sm-8" style="padding-left:10px;padding-right:0px">
					<!--- Generic Configured Location --->
					<sw-typeahead-input-field
							data-entity-name="Location"
					        data-property-to-save="locationID"
					        data-property-to-show="locationName"
					        data-properties-to-load="locationID,locationName,primaryAddress.address.city,primaryAddress.address.stateCode,primaryAddress.address.postalCode"
					        data-show-add-button="true"
					        data-show-view-button="true"
					        data-placeholder-rb-key="#attributes.rbKey#"
					        data-multiselect-mode="false"
					        data-filter-flag="true"
					        data-selected-format-string="#attributes.selectedFormatString#"
					        data-field-name="#attributes.locationPropertyName#" 
 					        <cfif !isNull(attributes.property)> data-initial-entity-id="#attributes.property.getLocationID()#"</cfif>>
 						
					
					    <sw-collection-config
					            data-entity-name="Location"
					            data-collection-config-property="typeaheadCollectionConfig"
					            data-parent-directive-controller-as-name="swTypeaheadInputField"
					            data-all-records="true">
					
							<sw-collection-columns>
						        <sw-collection-column data-property-identifier="primaryAddress.address.addressID"></sw-collection-column>
						        <sw-collection-column data-property-identifier="primaryAddress.address.city" data-is-searchable="true"></sw-collection-column>
						        <sw-collection-column data-property-identifier="primaryAddress.address.stateCode" data-is-searchable="true"></sw-collection-column>
						        <sw-collection-column data-property-identifier="primaryAddress.address.postalCode" data-is-searchable="true"></sw-collection-column>
						        <sw-collection-column data-property-identifier="locationName" data-is-searchable="true"></sw-collection-column>
						        <sw-collection-column data-property-identifier="locationID"></sw-collection-column>
						    </sw-collection-columns>
							
							<!--- Order By --->
					    	<sw-collection-order-bys>
					        	<sw-collection-order-by data-order-by="locationName|ASC"></sw-collection-order-by>
					    	</sw-collection-order-bys>
					    	
					    	<!--- Filters --->
					    	<cfif attributes.showActiveLocationsFlag EQ true>
						    	<sw-collection-filters>
		                            <sw-collection-filter data-property-identifier="activeFlag" data-comparison-operator="=" data-comparison-value="1"></sw-collection-filter>
		                        </sw-collection-filters>
					    	</cfif>
					    </sw-collection-config>
						
						<i class="fa fa-map-marker icon-left fa-2x"></i>&nbsp;
						<span sw-typeahead-search-line-item data-property-identifier="locationName"></span><br>
						    	
					</sw-typeahead-input-field>
				</div>
			</div>
	</cfoutput>
</cfif>