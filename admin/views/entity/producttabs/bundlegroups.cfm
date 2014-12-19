<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />
<span ng-controller="create-bundle-controller">
	  <section class="col-xs-12" ng-if="product">
	    
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
	    		data-sku="product.data.skus[0]"
	    		data-product-bundle-groups="product.data.skus[0].data.productBundleGroups"
	    		data-add-product-bundle-group="addProductBundleGroup()"
	    >
	    </span>
	  </section>

</span>
