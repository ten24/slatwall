<script>
	apply = function(){
		$('#reverecognition').submit();
	}
	
</script>
<cfoutput>
	
	<form id="revrecognition" action="?s=1" method="post">
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
		                    <input name="subscriptionType" type="checkbox" value="#subscriptionOrderItemTypeRecord['systemCode']#" />
		                </div>
		            </cfloop>
		        </div>
		        <br/>
		        <!-- get available subscription product types -->
		        <cfset productTypeCollectionList = $.slatwall.getService('hibachiService').getProductTypeCollectionList()/>
		        <cfset productTypeCollectionList.setDisplayProperties('systemCode,productTypeName')/>
		        <cfset productTypeCollectionList.addFilter('productTypeIDPath','444df2f9c7deaa1582e021e894c0e299,%','like')/>
		        <div id="u122" class="ax_default droplist">
		            Product Type:
		            <cfloop array="#productTypeCollectionList.getRecords()#" index="productTypeRecord">
		                <div>
		                    #productTypeRecord['productTypeName']#
		                    <input name="productType" type="checkbox" value="#productTypeRecord['systemCode']#" />
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
		                	<sw-collection-filters>
		                    	<sw-collection-filter data-property-identifier="productType.productTypeIDPath" data-comparison-operator="like" data-comparison-value="444df2f9c7deaa1582e021e894c0e299,%"></sw-collection-filter>
		                    </sw-collection-filters>
		                </sw-collection-config>
		            
		            	<span sw-typeahead-search-line-item data-property-identifier="productName" is-searchable="true"></span><br>
		            
		            </sw-typeahead-input-field>
		        </div>
		        
		        <!-- Unnamed (Droplist) -->
		        <div id="u122" class="ax_default droplist">
		            <select id="u122_input" style="-webkit-appearance: menulist-button;" >
		                <cfloop array="#possibleYearsRecords#" index="possibleYearsRecord">
		                    <option value="#possibleYearsRecord['subscriptionOrderItem_orderItem_order_orderCloseDateTime']#">#possibleYearsRecord['subscriptionOrderItem_orderItem_order_orderCloseDateTime']#</option>
		                </cfloop>
		            </select>
		        </div>
		
		        <!-- Button (Rectangle) -->
		        <div id="u123" class="ax_default shape" data-label="Button" style="cursor: pointer;">
		            <div id="u123_div" class="" tabindex="0"></div>
		            <div id="u123_text" class="text ">
		                <p id="cache0" style=""><span id="cache1" style="">Apply</span></p>
		            </div>
		        </div>
		    </div>
		</div>
	</form>
</cfoutput>