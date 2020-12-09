<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.collectionlist"/>
	
	<cfset scopeVariableID = '#attributes.collectionlist.getCollectionObject()##rereplace(createUUID(),'-','','all')#'/>
	<cfset JSON = serializeJson(attributes.collectionList.getCollectionConfigStruct())/>
	
	<!---escape apostraphe boi--->
	<cfset JSON = rereplace(JSON,"'","\'",'all')/>
	<!---convert double quotes to single--->
	<cfset JSON = rereplace(JSON,'"',"'",'all')/>
	
	<cfparam name="attributes.entityName" type="string" default="#attributes.collectionlist.getCollectionObject()#"/>
	<cfparam name="attributes.labelText" type="string" default="#attributes.hibachiScope.rbkey('entity.#attributes.entityName#_plural')#"/>					
	<cfparam name="attributes.propertyName" type="string" default="#attributes.hibachiScope.getService('hibachiService').getPrimaryIDPropertyNameByEntityName(attributes.entityName)#"/>
	<cfparam name="attributes.labelClass" type="string" default="control-label col-sm-4"/>
	<cfparam name="attributes.placeHolder" type="string" default="Search #attributes.labelText#"/>
	<cfparam name="attributes.edit" type="boolean" default="false"/>				
	<cfparam name="attributes.rbKey" type="string" default="entity.#attributes.entityName#" />		
	<cfparam name="attributes.selectedFormatString" type="string" default="#attributes.entityName# >> ${#attributes.propertyName#}"/><!--- example: products >> ${productName} --->
	<cfparam name="attributes.maxrecords" type="string" default="25" />
	<cfparam name="attributes.propertyToSave" default="#attributes.hibachiScope.getService('hibachiService').getPrimaryIDPropertyNameByEntityName(attributes.entityName)#"/>
	<cfparam name="attributes.propertyToShow" default="#attributes.hibachiScope.getService('hibachiService').getSimpleRepresentationPropertyNameByEntityName(attributes.entityName)#"/>
	<cfparam name="attributes.orderbylist" default="#attributes.propertyToShow#|ASC"/>
	<cfparam name="attributes.propertyToLoad" type="string" default="#attributes.propertyToSave#,#attributes.propertyToShow#"/>
	<cfparam name="attributes.fieldName" type="string" default="#attributes.propertyName#"/>
	<cfparam name="attributes.initialEntityID" type="string" default=""/>
	
	<cfoutput>
	<!--- Generic  Typeahead --->
		<!---<cfif !isNull(attributes.property)><!--- Only show if we have a default --->
			<div class="form-group" ng-show="'#attributes.edit#' == 'false'" ng-cloak >
				<label for="#attributes.propertyName#" class="control-label col-sm-4" >
					<span class="s-title">#attributes.labelText#</span>
				</label>
				<div class="col-sm-8">
					<p class="form-control-static value">#attributes.property.getProduct()#</p>
				</div>
				<cfif attributes.edit EQ 'false'>
   					<input type="hidden" name="#attributes.propertyName#" value="#attributes.property.getProductID()#" />
   				</cfif>
			</div>
		</cfif>--->
		<span ng-init="
			#scopeVariableID#=$root.hibachiScope.$injector.get('collectionConfigService').newCollectionConfig().loadJson(#JSON#);
		"></span>
			<!--- Generic Configured product --->
			<sw-typeahead-input-field
					data-entity-name="#attributes.entityName#"
			        data-property-to-save="#attributes.propertyToSave#"
			        data-property-to-show="#attributes.propertyToShow#"
			        data-properties-to-load="#attributes.propertyToLoad#"
			        data-show-add-button="true"
			        data-show-view-button="true"
			        data-placeholder-rb-key="#attributes.rbKey#"
			        data-placeholder-text="Search #attributes.placeholder#"
			        data-multiselect-mode="false"
			        data-filter-flag="true"
			        data-selected-format-string="#attributes.selectedFormatString#"
			        data-field-name="#attributes.fieldName#"
		        	data-initial-entity-id="#attributes.initialEntityID#"
			        data-max-records="#attributes.maxrecords#"
			        data-order-by-list="#attributes.orderbylist#"
					data-typeahead-collection-config="#scopeVariableID#"       
			 >

				<span sw-typeahead-search-line-item data-property-identifier="#attributes.propertyToShow#" dropdownOpen="false" is-searchable="true"></span><br>

			</sw-typeahead-input-field>
	</cfoutput>
</cfif>