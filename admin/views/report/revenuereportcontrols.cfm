<script>
	jQuery(document).ready(function() {
		var apply = function(){
			$('#reverecognition').submit(function(){
			    return false;
			});
		}
	});
	
</script>
<cfoutput>
	
	<form id="revrecognition" action="?s=1" method="post">
		<input type="hidden" name="slatAction" value="#slatAction#"/>
		<div id="u119_state0" class="panel_state" data-label="State1" style="">
		    <div id="u119_state0_content" class="panel_state_content">
		        <!--get avaiable order item subscripiont type-->
		        <cfset subscriptionOrderItemTypeCollectionList = $.slatwall.getService('hibachiService').getTypeCollectionList()/>
		        <cfset subscriptionOrderItemTypeCollectionList.setDisplayProperties('systemCode,typeName')/>
		        <cfset subscriptionOrderItemTypeCollectionList.addFilter('typeIDPath','444df3100babdbe1086cf951809a60ca,%','like')/>
		        <div id="u122" class="ax_default droplist">
		            Subscription Type:
		            <cfloop array="#subscriptionOrderItemTypeCollectionList.getRecords()#" index="subscriptionOrderItemTypeRecord">
		                <div>
		                    #subscriptionOrderItemTypeRecord['typeName']#
		                    <input name="subscriptionType" type="checkbox" value="#subscriptionOrderItemTypeRecord['systemCode']#" <cfif structKeyExists(rc,'subscriptionType') && listFind(rc.subscriptionType,subscriptionOrderItemTypeRecord['systemCode'])>checked=checked</cfif>/>
		                </div>
		            </cfloop>
		        </div>
		        <br/>
		        <!-- get available subscription product types -->
		        <cfset productTypeCollectionList = $.slatwall.getService('hibachiService').getProductTypeCollectionList()/>
		        <cfset productTypeCollectionList.setDisplayProperties('productTypeID,productTypeName')/>
		        <cfset productTypeCollectionList.addFilter('productTypeIDPath','444df2f9c7deaa1582e021e894c0e299,%','like')/>
		        <div id="u122" class="ax_default droplist">
		            Product Type:
		            <cfloop array="#productTypeCollectionList.getRecords()#" index="productTypeRecord">
		                <div>
		                    #productTypeRecord['productTypeName']#
		                    <input name="productType" type="checkbox" value="#productTypeRecord['productTypeID']#" <cfif structKeyExists(rc,'productType') && listFind(rc.productType,productTypeRecord['productTypeID'])>checked=checked</cfif>/>
		                </div>
		            </cfloop>
		        </div>
		        <br/>
		        
		        <div class="col-sm-4">
		            <sw-typeahead-input-field
		            		data-entity-name="Product"
		                    data-property-to-save="productID"
		                    data-property-to-show="productName"
		                    data-properties-to-load="productName"
		                    data-placeholder-text="Product"
		                    data-multiselect-mode="false"
		                    data-filter-flag="true"
		                    data-max-records="250"
		                    data-field-name="productID"
		                    data-order-by-list="productName|ASC"
		                    <cfif structKeyExists(rc,'productID') and len(rc.productID)>
		            			data-initial-entity-id="#HTMLEditFormat(rc.productID)#"
		            		</cfif>
		                    >
		            
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
		                	<sw-collection-filters>
		                    	<sw-collection-filter data-property-identifier="productType.productTypeIDPath" data-comparison-operator="like" data-comparison-value="444df2f9c7deaa1582e021e894c0e299,%"></sw-collection-filter>
		                    </sw-collection-filters>
		                </sw-collection-config>
		            
		            	<span sw-typeahead-search-line-item data-property-identifier="productName" is-searchable="true"></span><br>
		            
		            </sw-typeahead-input-field>
		        </div>
		        <br/><br/>
		        <!-- Unnamed (Droplist) -->
		        <div id="u122" class="ax_default droplist">
		            <select name="reportYear" id="u122_input" style="-webkit-appearance: menulist-button;" >
		                <cfloop array="#possibleYearsRecords#" index="possibleYearsRecord">
		                	
		                    <option 
		                    	value="#possibleYearsRecord#"
		                    	<cfif structKeyExists(rc,'reportYear') && rc.reportYear eq possibleYearsRecord>selected</cfif>
		                    >#possibleYearsRecord#
		                    </option>
		                </cfloop>
		            </select>
		        </div>
				<br/>
		        <!-- Button (Rectangle) -->
		        <div id="u123" class="ax_default shape" data-label="Button" style="cursor: pointer;">
		            <div id="u123_div" class="" tabindex="0"></div>
		            <div id="u123_text" class="text ">
		                <button >Apply</button>
		            </div>
		        </div>
		    </div>
		</div>
	</form>
</cfoutput>