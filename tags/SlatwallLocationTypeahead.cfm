<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<!--- Implicit --->
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />	
		
	<!--- These are required Attributes --->
	<cfparam name="attributes.object" type="any" />											<!--- hint: This is a required attribute that defines the object that contains the property to display --->
	<cfparam name="attributes.property" type="string" /> 									<!--- hint: This is a required attribute as the property that you want to display" --->
	
	<!--- These are optional Attributes --->
	<cfparam name="attributes.edit" type="boolean" default="false" />	
	
	<cfparam name="attributes.title" type="string" default="" />							<!--- hint: This can be used to override the displayName of a property" --->
	<cfparam name="attributes.hint" type="string" default="" />								<!--- hint: If specified, then this will produce a tooltip around the title --->
	
	<cfparam name="attributes.fieldName" type="string" default="" />						<!--- hint: This can be used to override the default field name" --->

	<cfparam name="attributes.selectedFormatString" type="string" default="Store Locations >> ${locationName}"/><!--- Store Locations >> ${locationName} --->
	<cfparam name="attributes.rbKey" type="string" default="entity.location" />		<!--- entity.location --->
	<cfparam name="attributes.showActiveLocationsFlag" type="boolean" default="false" />
	<cfparam name="attributes.ignoreParentLocationsFlag" type="boolean" default="false" />
	<cfparam name="attributes.topLevelLocationID" type="string" default="" />
	<cfparam name="attributes.selectedLocationID" type="string" default="" />
	<cfparam name="attributes.maxrecords" type="string" default="25" />
	
	<cfif !attributes.object.isPersistent() || attributes.hibachiScope.authenticateEntityProperty('read', attributes.object.getClassName(), attributes.property)>
		<cfsilent>
			<!--- If this was originally set to edit... make sure that they have edit ability for this property --->
			<cfif attributes.edit and attributes.object.isPersistent() and not attributes.hibachiScope.authenticateEntityProperty('update', attributes.object.getClassName(), attributes.property)>
				<cfset attributes.edit = false />
			</cfif>
			
			<cfif attributes.fieldName eq "">
				<cfset attributes.fieldName = attributes.object.getPropertyFieldName( attributes.property ) />
			</cfif>
			
			<!--- Set up the property title --->
			<cfif attributes.title eq "">
				<cfset attributes.title = attributes.object.getPropertyTitle( attributes.property ) />
			</cfif>
			
			<cfif attributes.hint eq "">
				<cfset attributes.hint = attributes.object.getPropertyHint( attributes.property ) />
			</cfif>
			
			<cfset attributes.location = attributes.object.getValueByPropertyIdentifier( attributes.property ) />
			
			<cfif attributes.selectedLocationID eq "">
				<cfset attributes.selectedLocationID = attributes.location.getLocationID()>
			</cfif>
			
		</cfsilent>
	
		<cfoutput>
			<!--- Generic Location Typeahead --->
			<div class="form-group">
				<label for="#attributes.fieldName#" class="control-label col-sm-4">
					<span class="s-title">#attributes.title#</span>
					<cfif len(attributes.hint)>
						<span sw-tooltip class="j-tool-tip-item" data-text="#attributes.hint#" data-position="right">
							<i class="fa fa-question-circle"></i>
						</span>
					</cfif>
				</label>
				<div class="col-sm-8">
					<cfif attributes.edit EQ false >
						
						<p class="form-control-static value">#attributes.location.getLocationName()#</p>
						<input type="hidden" name="#attributes.property#" value="#attributes.location.getLocationID()#" />
						
					<cfelse>
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
							data-field-name="#attributes.property#.locationID"
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
					
					</cfif>
				</div>
			</div>
		</cfoutput>
	</cfif>
</cfif>