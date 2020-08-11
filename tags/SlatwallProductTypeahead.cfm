<cfparam name="attributes.productPropertyName" type="string" />				<!---IE billToproduct.productID --->
<cfparam name="attributes.productLabelText" type="string" />					<!---IE Bill To product --->
<cfparam name="attributes.labelClass" type="string" default="control-label col-sm-4"/>
<cfparam name="attributes.edit" type="boolean" default="false"/>				<!---IE rc.edit value --->
<cfparam name="attributes.rbKey" type="string" default="entity.product" />		<!--- entity.product --->
<cfparam name="attributes.selectedFormatString" type="string" default="product >> ${productName}"/><!--- Store products >> ${productName} --->
<cfparam name="attributes.showActiveProductFlag" type="boolean" default="false" />
<cfparam name="attributes.maxrecords" type="string" default="25" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<!--- Generic product Typeahead --->
			<cfif !isNull(attributes.property) && !isNull(attributes.property.getProduct())><!--- Only show if we have a default --->
				<div class="form-group" ng-show="'#attributes.edit#' == 'false'" ng-cloak >
					<label for="#attributes.productPropertyName#" class="control-label col-sm-4" >
						<span class="s-title">#attributes.productLabelText#</span>
					</label>
					<div class="col-sm-8">
						<p class="form-control-static value">#attributes.property.getProduct().getProductName()#</p>
					</div>
					<cfif attributes.edit EQ 'false'>
	   					<input type="hidden" name="#attributes.productPropertyName#" value="#attributes.property.getProductID()#" />
	   				</cfif>
				</div>
			</cfif>
			<div ng-show="'#attributes.edit#' == 'true'" ng-cloak class="form-group">
				<label for="#attributes.productPropertyName#" class="control-label col-sm-4">
					<span class="s-title">#attributes.productLabelText#</span>
				</label>
				<div class="col-sm-8" style="padding-left:10px;padding-right:0px">
					<!--- Generic Configured product --->
					<cfif !isNull(attributes.property) && !isNull(attributes.property.getProductID())>
						<cfset initialEntityID = "#attributes.property.getProductID()#">
					</cfif>
					<cfif isNull(initialEntityID)>
						<cfset initialEntityID = "">
					</cfif>
					<sw-typeahead-input-field
							data-entity-name="Product"
					        data-property-to-save="productID"
					        data-property-to-show="productName"
					        data-properties-to-load="productID,productName,activeFlag"
					        data-show-add-button="true"
					        data-show-view-button="true"
					        data-placeholder-rb-key="#attributes.rbKey#"
					        data-placeholder-text="Search Products"
					        data-multiselect-mode="false"
					        data-filter-flag="true"
					        data-selected-format-string="#attributes.selectedFormatString#"
					        data-field-name="#attributes.productPropertyName#"
					        data-initial-entity-id="#initialEntityID#"
					        data-max-records="#attributes.maxrecords#"
					        data-order-by-list="productName|ASC">

					    <sw-collection-config
					            data-entity-name="Product"
					            data-collection-config-property="typeaheadCollectionConfig"
					            data-parent-directive-controller-as-name="swTypeaheadInputField"
					            data-all-records="true">
					    	
					    								<!--- Columns --->
 							<sw-collection-columns>
 								<sw-collection-column data-property-identifier="productName" is-searchable="true"></sw-collection-column>
 								<sw-collection-column data-property-identifier="productID" is-searchable="false"></sw-collection-column>
 							</sw-collection-columns>
 							
 							<!--- Order By --->
 					    	<sw-collection-order-bys>
 					        	<sw-collection-order-by data-order-by="productName|ASC"></sw-collection-order-by>
 					    	</sw-collection-order-bys>

					    	<!--- Filters --->
					    	<cfif attributes.showActiveProductFlag EQ true>
						    	<sw-collection-filters>
		                            <cfif attributes.showActiveProductFlag EQ true>	
		                            	<sw-collection-filter data-property-identifier="activeFlag" data-comparison-operator="=" data-comparison-value="1"></sw-collection-filter>
		                        	</cfif>
		                        </sw-collection-filters>
					    	</cfif>
					    </sw-collection-config>

						<span sw-typeahead-search-line-item data-property-identifier="productName" dropdownOpen="false" is-searchable="true"></span><br>

					</sw-typeahead-input-field>
				</div>
			</div>
	</cfoutput>
</cfif>