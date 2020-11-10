<cfparam name="print" type="any" />	
<cfparam name="printData" type="struct" default="#structNew()#" />
<cfparam name="stockAdjustment" type="any" />

<cfoutput>
	<script src="#request.slatwallScope.getBaseURL()#/custom/js/JsBarcode.all.min.js"></script>
	<style> 
		body { 
			width: 2in;
			margin: 0 .2in;  
		}
		.label{ 
			height: .4in;
			padding: .1in 0 0; 
			page-break-after:always; 
		} 
	</style>  
	<div>
		<cfset local.stockAdjustmentItemCollection = stockAdjustment.getStockAdjustmentItemsCollectionList()>
		<cfset local.stockAdjustmentItemCollection.addDisplayProperty('sku.skuCode')>
		<cfset local.stockAdjustmentItemCollection.addDisplayProperty('sku.product.productName')>
		 
		<cfloop index="local.stockAdjustmentItem" array=#local.stockAdjustmentItemCollection.getRecords(false, false)#>
				<cfloop from="1" to="#stockAdjustmentItem['quantity']#" index="i">
					<div class="label"> 
						<canvas class="barcode"
								jsbarcode-format="CODE128"
								jsbarcode-value="#stockAdjustmentItem['sku_skuCode']#"
								jsbarcode-width="1"	
								jsbarcode-height="25"
								jsbarcode-margin="1"
								jsbarcode-displayvalue="false"
								>
						</canvas>
						<p style="margin: 0; font-size: 10px; font-style: sans-serif; text-transform:uppercase">#stockAdjustmentItem['sku_skuCode']# - #stockAdjustmentItem['sku_product_productName']#</p>			
					</div> 
				</cfloop>
		</cfloop> 	
	</div> 
	<script type="text/javascript">
		JsBarcode(".barcode").init();
	</script> 
</cfoutput> 