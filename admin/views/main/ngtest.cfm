<span ng-controller="ngtest">
	
	<span ng-if="sku">
		<sw-form name="form.createSku" 
		     		data-object="sku"	
					data-context="save"
		     	>
			<sw-property-display
				data-object="sku"
				data-property="skuName"
				data-editing="true"
			></sw-property-display>
		</sw-form>
	</span>
</span>