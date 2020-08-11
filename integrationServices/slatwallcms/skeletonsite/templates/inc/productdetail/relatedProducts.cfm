<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
<!--- Start: Related Products Example --->
	<div class="row">
		<div class="span12">

			<h5>Related Products Example</h5>

			<!--- Get the related products smart list --->
			<cfset relatedProductsSmartList = local.product.getRelatedProductsSmartList() />

			<!--- Setting this to only show 4 --->
			<cfset relatedProductsSmartList.setPageRecordsShow(4) />

			<!--- Adding fliter to only show active / published products --->
			<cfset relatedProductsSmartList.addFilter('activeFlag', 1) />
			<cfset relatedProductsSmartList.addFilter('publishedFlag', 1) />

			<!--- Verify that there are records --->
			<cfif relatedProductsSmartList.getRecordsCount()>
				<ul class="thumbnails">

					<!--- Promary loop for each related product --->
					<cfloop array="#relatedProductsSmartList.getPageRecords()#" index="product">

						<!--- Individual Product --->
						<li class="span3">

							<div class="thumbnail">

								<!--- Product Image --->
								<img src="#product.getResizedImagePath(size='m')#" alt="#product.getCalculatedTitle()#" />

								<!--- The Calculated Title allows you to setup a title string as a dynamic setting.  When you call getTitle() it generates the title based on that title string setting. To be more perfomant this value is cached as getCalculatedTitle() --->
								<h5>#product.getCalculatedTitle()#</h5>

								<!--- Check to see if the products price is > the sale price.  If so, then display the original price with a line through it --->
								<cfif product.getPrice() gt product.getCalculatedSalePrice()>
									<p><span style="text-decoration:line-through;">#product.getPrice()#</span> <span class="text-error">#product.getFormattedValue('calculatedSalePrice')#</span></p>
								<cfelse>
									<p>#product.getFormattedValue('calculatedSalePrice')#</p>
								</cfif>

								<!--- This is the link to the product detail page.  sense we aren't on a listing page you should always just use the standard getProductURL() --->
								<a href="#product.getProductURL()#">Details / Buy</a>

							</div>
						</li>
					</cfloop>
				</ul>
			<cfelse>
				<p>There are no related products.</p>
			</cfif>

		</div>
	</div>
	<!--- End: Related Products Example --->
</cfoutput>