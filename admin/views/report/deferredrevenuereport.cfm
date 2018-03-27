<div class="col-sm-4">
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
</div>