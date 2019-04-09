<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	
<!--- Get the related products collection list --->
<cfset relatedProductsCollectionList = $.slatwall.getService('productService').getProductCollectionList()>
<cfset relatedProductsCollectionList.addFilter("productID",$.slatwall.product().getProductID())/>
<!--- Adding fliter to only show active / published products --->
<cfset relatedProductsCollectionList.addFilter("relatedProducts.relatedProduct.activeFlag",1)>
<cfset relatedProductsCollectionList.addFilter("relatedProducts.relatedProduct.publishedFlag",1)>
<!--- Set related product properties to display --->
<cfset relatedProductsCollectionList.setDisplayProperties("relatedProducts.relatedProduct.activeFlag,relatedProducts.relatedProduct.publishedFlag,relatedProducts.relatedProduct.productType.productTypeName,relatedProducts.relatedProduct.calculatedSalePrice,relatedProducts.relatedProduct.productID,relatedProducts.relatedProduct.urlTitle,relatedProducts.relatedProduct.defaultSku.skuID|defaultSku_skuID,relatedProducts.relatedProduct.defaultSku.imageFile|defaultSku_imageFile,relatedProducts.relatedProduct.defaultSku.skuCode|defaultSku_skuCode,relatedProducts.relatedProduct.defaultSku.bundleFlag|defaultSku_bundleFlag,relatedProducts.relatedProduct.defaultSku.price|defaultSku_price,relatedProducts.relatedProduct.productName")>
<cfset relatedProductsCollectionList.addDisplayAggregate('relatedProducts.relatedProduct.defaultSku.bundledSkus','count','bundledSkusCount') />
<cfset relatedProductsCollectionList.setPageRecordsShow(6)>
<cfset relatedProducts = relatedProductsCollectionList.getPageRecords()>
<!--- Verify that there are records --->
<cfif ArrayLen(relatedProducts)>

	<h2>Related Products</h2>
	
	<div class="row">
		<!--- Promary loop for each related product --->
		<cfloop array="#relatedProducts#" index="local.product">
			<div class="col-md-3">
		    	<div class="card">
					<cfset local.smallimages = $.slatwall.getService("ImageService").getResizedImageByProfileName("#local.product['relatedProducts_relatedProduct_defaultSku_skuID']#","medium") />
					<a href="/#$.slatwall.setting('globalURLKeyProduct')#/#local.product['relatedProducts_relatedProduct_urlTitle']#">
						<cfif arrayLen(local.smallImages)>
							<img src="#local.smallimages[1]#" class="card-img-top" alt="#local.product['productName']#">
						</cfif>
					</a>
					<div class="card-body">
						<h5 class="card-title">
							<a href="/store/#$.slatwall.setting('globalURLKeyProduct')#/#local.product['relatedProducts_relatedProduct_urlTitle']#">#local.product['relatedProducts_relatedProduct_productName']#</a>
						</h5>
					
						<a href="#local.product['relatedProducts_relatedProduct_urlTitle']#" class="btn btn-light btn-sm btn-block">View Product</a>
					</div>
				</div>
			</div>
	    </cfloop>
	</div>
</cfif>
</cfoutput>