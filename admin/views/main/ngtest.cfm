<span ng-controller="ngtest">
	<br><br>
	<span ng-if="sku">
		<sw-form name="form.createSku" 
		     		data-object="sku"	
					data-context="save"
			><sw-property-display
				data-object="sku"
				data-property="skuName"
				data-editing="true"
			></sw-property-display>
			<sw-property-display
				data-object="sku"
				data-property="skuCode"
				data-editing="true"
			></sw-property-display>
			<sw-property-display
				data-object="sku"
				data-property="activeFlag"
				data-editing="true"
			></sw-property-display>
			<sw-property-display
				data-object="sku"
				data-property="renewalPrice"
				data-editing="true"
			></sw-property-display>
		</sw-form>
		<button type="button" class="btn btn-sm s-btn-ten24 s-save-btn" ng-click="saveSku()">Save Sku</button>
	</span>
</span>