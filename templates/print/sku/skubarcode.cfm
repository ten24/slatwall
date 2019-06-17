<cfparam name="print" type="any" />	
<cfparam name="printData" type="struct" default="#structNew()#" />
<cfparam name="sku" type="any" />

<cfoutput>
	<script src="#request.slatwallScope.getBaseURL()#/assets/js/JsBarcode.all.min.js"></script>
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
		<cfif sku.getClassName() EQ 'Collection'>
				<cfset sku.addDisplayProperty('skuCode')>
				<cfset sku.addDisplayProperty('product.productName')>
				<cfset sku.setPageRecordsShow(10) />
	
				<cfloop index="local.sku" array=#sku.getPageRecords(true, false)#>
					<cfif structKeyExists(sku, 'skuCode')>  
						<div class="label"> 
							<canvas    class="barcode"
									jsbarcode-format="CODE128"
									jsbarcode-value="#sku['skuCode']#"
									jsbarcode-width="1"	
									jsbarcode-height="25"
									jsbarcode-margin="1"
									jsbarcode-displayvalue="false"
									>
							</canvas>
							<p style="margin: 0; font-size: 10px; font-style: sans-serif; text-transform:uppercase">#sku['skuCode']# - #sku['product_productName']#</p>			
						</div> 
					</cfif> 
				</cfloop> 	
		<cfelse> 
			<div class="label"> 
				<canvas    class="barcode"
						jsbarcode-format="CODE128"
						jsbarcode-value="#sku.getSkuCode()#"
						jsbarcode-width="1"	
						jsbarcode-height="25"	
						jsbarcode-margin="1"
						jsbarcode-displayvalue="false"
						>
				</canvas>
				<p style="margin: 0; font-size: 10px; font-style: sans-serif; text-transform:uppercase">#sku.getSkuCode()# - #sku.getProduct().getProductName()#</p>			
			</div> 
		</cfif> 
	</div> 
	<script type="text/javascript">
		JsBarcode(".barcode").init();
	</script> 
</cfoutput> 