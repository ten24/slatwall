<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />
<span ng-controller="create-bundle-controller">
	  <section class="col-xs-12" ng-if="product">
	    <div class="row s-bundle-header" >
	     	
			<span ng-if="product">
				<sw-form name="form.createProduct" 
		     		data-object="product"	
					data-context="save"
		     	>
			        <div class="col-xs-6">
				        <sw-property-display
								data-object="product"
								data-property="productName"
								data-editing="true"
								data-editable="true"
						></sw-property-display>	
				        <sw-property-display
								data-object="product"
								data-property="productCode"
								data-editing="true"
								data-editable="true"
								data-on-change="product.data.skus[0].data.skuCode = product.data.productCode + '-1'"
						></sw-property-display>
				        <sw-property-display
				        		ng-if="product.data.skus[0]"
								data-object="product.data.skus[0]"
								data-property="price"
								data-editing="true"
								data-editable="true"
						></sw-property-display> 
			        </div>
				</sw-form>
				
		        <div class="col-xs-6">
		        	<sw-form name="form.createProductType" 
			     		data-object="product.data.productType"	
						data-context="save"
			     	>
				        <sw-property-display
								data-object="product"
								data-property="productType"
								data-editing="true"
								data-editable="true"
								data-options-arguments="{property:'productType',argument1:'productBundle'}"
						></sw-property-display> 
					</sw-form>
					<sw-form name="form.createBrand" 
			     		data-object="product.data.brand"	
						data-context="save"
			     	>
				        <sw-property-display
								data-object="product"
								data-property="brand"
								data-editing="true"
								data-editable="true"
								data-options-arguments="{property:'brand'}"
						></sw-property-display> 
					</sw-form>
				</div>
			</span>
			
	    </div><!-- //bundle head -->
		<sw-form name="form.createSku" 
	     		data-object="product.data.skus[0]"	
				data-context="save"
				ng-if="product.data.skus[0]"
	     >
			<sw-property-display
								style="display:none"
								data-object="product.data.skus[0]"
								data-property="skuID"
								data-editing="true"
								data-editable="true"

			></sw-property-display>	
			<sw-property-display
								style="display:none"
								data-object="product.data.skus[0]"
								data-property="skuCode"
								data-editing="true"
								data-editable="true"
								data-is-dirty="true"
			></sw-property-display>		
	     </sw-form>
	    <span 	sw-product-bundle-groups
	    		ng-if="product.data.skus[0].data.productBundleGroups"
	    		data-sku="product.data.skus[0]"
	    		data-product-bundle-groups="product.data.skus[0].data.productBundleGroups"
	    		data-add-product-bundle-group="addProductBundleGroup()"
	    >
	    </span>
	  </section>

</span>
