<cfoutput>
    <!---<div class="col-sm-4">
        <sw-typeahead-input-field
        		data-entity-name="Type"
                data-property-to-save="typeID"
                data-property-to-show="typeName"
                data-properties-to-load="typeName"
                data-placeholder-text="Subscription Type"
                data-multiselect-mode="true"
                data-filter-flag="true"
                data-max-records="250"
                data-order-by-list="typeName|ASC">
        
            <sw-collection-config
                    data-entity-name="Type"
                    data-collection-config-property="typeaheadCollectionConfig"
                    data-parent-directive-controller-as-name="swTypeaheadInputField"
                    data-all-records="true">
            	
            								<!--- Columns --->
         		<sw-collection-columns>
         			<sw-collection-column data-property-identifier="typeName" is-searchable="true"></sw-collection-column>
         			<sw-collection-column data-property-identifier="typeID" is-searchable="false"></sw-collection-column>
         		</sw-collection-columns>
         		
         		<!--- Order By --->
             	<sw-collection-order-bys>
                 	<sw-collection-order-by data-order-by="typeName|ASC"></sw-collection-order-by>
             	</sw-collection-order-bys>
        
            	<!--- Filters --->
            	<sw-collection-filters>
                	<sw-collection-filter data-property-identifier="typeIDPath" data-comparison-operator="like" data-comparison-value="444df3100babdbe1086cf951809a60ca,%"></sw-collection-filter>
                </sw-collection-filters>
            </sw-collection-config>
        
        	<span sw-typeahead-search-line-item data-property-identifier="typeName" is-searchable="true"></span><br>
        
        </sw-typeahead-input-field>
    </div>
    
    
    
    <div class="col-sm-4">
        <sw-typeahead-input-field
        		data-entity-name="ProductType"
                data-property-to-save="productTypeID"
                data-property-to-show="productTypeName"
                data-properties-to-load="productTypeName"
                data-placeholder-text="Product Type"
                data-multiselect-mode="true"
                data-filter-flag="true"
                data-max-records="250"
                data-order-by-list="productTypeName|ASC">
        
            <sw-collection-config
                    data-entity-name="ProductType"
                    data-collection-config-property="typeaheadCollectionConfig"
                    data-parent-directive-controller-as-name="swTypeaheadInputField"
                    data-all-records="true">
            	
            								<!--- Columns --->
         		<sw-collection-columns>
         			<sw-collection-column data-property-identifier="productTypeName" is-searchable="true"></sw-collection-column>
         			<sw-collection-column data-property-identifier="productTypeID" is-searchable="false"></sw-collection-column>
         		</sw-collection-columns>
         		
         		<!--- Order By --->
             	<sw-collection-order-bys>
                 	<sw-collection-order-by data-order-by="productTypeName|ASC"></sw-collection-order-by>
             	</sw-collection-order-bys>
        
            	<!--- Filters --->
            	<sw-collection-filters>
                	<sw-collection-filter data-property-identifier="productTypeIDPath" data-comparison-operator="like" data-comparison-value="444df2f9c7deaa1582e021e894c0e299,%"></sw-collection-filter>
                </sw-collection-filters>
            </sw-collection-config>
        
        	<span sw-typeahead-search-line-item data-property-identifier="productTypeName" is-searchable="true"></span><br>
        
        </sw-typeahead-input-field>
    </div>
    
    
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
    </div>--->
    
    <cfset deferredRevenueCollectionList = $.slatwall.getService('HibachiService').getSubscriptionOrderDeliveryItemCollectionList()/>
    <cfset deferredRevenueCollectionList.setDisplayProperties('subscriptionOrderItem.orderItem.order.orderCloseDateTime',{isPeriod=true})/>
    <cfset deferredRevenueCollectionList.addDisplayAggregate('earned','SUM','earnedSUM',false,{isMetric=true})/>
    <cfset deferredRevenueCollectionList.addDisplayAggregate('taxAmount','SUM','taxAmountSUM',false,{isMetric=true})/>
    <cfset deferredRevenueCollectionList.setReportFlag(1)/>
    <cfset deferredRevenueCollectionList.setPeriodInterval('Month')/>
    
    
    <cfset possibleYearsRecordsCollectionList = $.slatwall.getService('HibachiService').getSubscriptionOrderDeliveryItemCollectionList()/>
    <cfset possibleYearsRecordsCollectionList.setDisplayProperties('subscriptionOrderItem.orderItem.order.orderCloseDateTime',{isPeriod=true})/>
    <cfset possibleYearsRecordsCollectionList.setReportFlag(1)/>
    <cfset possibleYearsRecordsCollectionList.setPeriodInterval('Year')/>
    <cfset possibleYearsRecords = possibleYearsRecordsCollectionList.getRecords()/>
    
    <cfif arraylen(possibleYearsRecords) and !structKeyExists(url,'reportYear')>
        <cfset deferredRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(possibleYearsRecords[1]['subscriptionOrderItem_orderItem_order_orderCloseDateTime'],1,1,0,0,0),'>=')/>
        <cfset deferredRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(possibleYearsRecords[1]['subscriptionOrderItem_orderItem_order_orderCloseDateTime'],12,31,23,59,59),'<=')/>
    <cfelseif structKeyExists(url,'reportYear')>
        <cfset deferredRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(INT(url.reportYear),1,1,0,0,0),'>=')/>
        <cfset deferredRevenueCollectionList.addFilter('subscriptionOrderItem.orderItem.order.orderCloseDateTime', CreateDateTime(INT(url.reportYear),12,31,23,59,59),'<=')/>
    </cfif>
    
    <cfset dataRecords = deferredRevenueCollectionList.getRecords()/>
    
    <div id="u119_state0" class="panel_state" data-label="State1" style="">
        <div id="u119_state0_content" class="panel_state_content">
            
            
            
            <!-- Unnamed (Droplist) -->
            <div id="u122" class="ax_default droplist">
                <select id="u122_input" style="-webkit-appearance: menulist-button;">
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
    
    <cfset possibleMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']/>
    <cfset earned = []/>
    <cfset taxAmount = []/>
    <cfloop from="1" to="12" index="i">
        <cfset earned[i] = $.slatwall.getService('hibachiUtilityService').formatValue(0,'currency')/>
        <cfset taxAmount[i] = $.slatwall.getService('hibachiUtilityService').formatValue(0,'currency')/>
    </cfloop>
    <cfloop array="#dataRecords#" index="dataRecord">
        <cfset index = INT(right(dataRecord['subscriptionOrderItem_orderItem_order_orderCloseDateTime'],2))/>
        <cfset earned[index] = $.slatwall.getService('hibachiUtilityService').formatValue(dataRecord['earnedSUM'],'currency')/>
        <cfset taxAmount[index] = $.slatwall.getService('hibachiUtilityService').formatValue(dataRecord['taxAmountSUM'],'currency')/>
    </cfloop>
    
    <table class="table table-bordered s-detail-content-table">
        <thead>
            <tr>
                <th></th>
                <cfloop array="#possibleMonths#" index="possibleMonth">
                    <th>
                        #possibleMonth#
                    </th>
                </cfloop>
            </tr>
        </thead>
        <tbody>
            
            <tr>
                <td>Earned Revenue</td>
                <cfloop array="#earned#" index="earnRecord">
                    <td>#earnRecord#</td>
                </cfloop>
            </tr>
            <tr>
                <td>Tax</td>
                <cfloop array="#taxAmount#" index="taxAmountRecord">
                    <td>#taxAmountRecord#</td>
                </cfloop>
            </tr>
        </tbody>
    </table>
</cfoutput>