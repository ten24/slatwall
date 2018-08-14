<cfimport prefix="sw" taglib="/Slatwall/tags" />
<cfimport prefix="sw" taglib="../tags" />
<cfoutput>
<cfinclude template="_slatwall-header.cfm" />
<div class="container" ng-cloak>

    <h1 class="my-4">#$.slatwall.content('title')#</h4>
    
    <!---- SERVER SIDE ACTIONS' ALERTS ----->
    
    <!--- If this item was just added show the success message --->
	<cfif $.slatwall.hasSuccessfulAction( "public:cart.addOrderItem" )>
		<div class="alert alert-success alert-dismissible fade show" role="alert">
			Item added to cart. <a href="/checkout/" class="alert-link">Continue to Checkout</a>. You might want to change the action="" of the add to cart form so that it points directly to shopping cart page that way the user ends up there.
			Or you can add a 'sRedirectURL' hidden field value to specify where you would like the user to be redirected after a succesful addToCart.
			<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		</div>
	<!--- If this item was just tried to be added, but failed then show the failure message --->
	<cfelseif $.slatwall.hasFailureAction( "public:cart.addOrderItem" )>
		<div class="alert alert-danger alert-dismissible fade show" role="alert">
			<!--- Display whatever errors might have been associated with the specific options --->
			<sw:ErrorDisplay object="#$.slatwall.cart().getProcessObject('addOrderItem')#" />

			<!--- Display any errors with saving the order after the item was atempted to be added --->
			<sw:ErrorDisplay object="#$.slatwall.cart()#" errorName="addOrderItem" />
		</div>
	</cfif>
	
	
	 <!---- CLIENT SIDE (AJAX) ACTIONS' ALERTS ----->
	 
	<div ng-show="slatwall.hasSuccessfulAction('addOrderItem')" class="alert alert-success">Item Added to Cart</div>
    <div ng-show="slatwall.hasFailureAction('addOrderItem')" class="alert alert-danger">There was an error adding item to cart</div>
	
	<!--- Base Product Collection List --->
	<cfset productCollectionList = $.slatwall.getService('productService').getProductCollectionList()>
	<cfset productCollectionList.setPageRecordsShow(9)/>
	<cfif structKeyExists(url,'keywords')>
		<cfset productCollectionList.setKeywords(url.keywords) />
	</cfif>
    <cfset productCollectionList.addFilter("activeFlag",1)>
	<cfset productCollectionList.addFilter("publishedFlag",1)>
    <cfset productCollectionList.addFilter("listingPages.content.contentID",$.slatwall.content('contentID')) />
    <cfset productCollectionList.setDisplayProperties("brand.brandName,productDescription,urlTitle,productType.productTypeName,productType.urlTitle,defaultSku.price,defaultSku.listPrice,defaultSku.skuID")>
    <!----- Add additional fields here to enhance search scope ---->
    <cfset productCollectionList.addDisplayProperty(displayProperty="productName",columnConfig={isVisible=true, isSearchable=true, isDeletable=true}) />
    <!--- This allows filters applied to collection list --->
    <cfset productCollectionList.applyData()>
    <cfset productCollection = productCollectionList.getPageRecords()>
    
    <div class="row mb-4">
        <div class="col-sm-3">
        	<!--- ternary operator displays char 's' if there's more than one product --->
            <h6><strong>#arrayLen(productCollection)#</strong> Available Product#arrayLen(productCollection) GT 1 ? 's' : '' #</h6>
        </div>
        <div class="col-sm-6">
    		<cfinclude template="inc/productListingUrlFilterBadges.cfm">
        </div>
        
        <div class="col-sm-2 offset-md-1">
        	<div class="dropdown">
				<button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					Sort By...
				</button>
				<div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
			    	<a class="dropdown-item <cfif !isNull(url.orderby) AND url.orderBy EQ 'productName|ASC'>active</cfif>" href="#productCollectionList.buildURL( 'orderBy=productName|ASC',false )#">Name - A to Z</a>
			    	<a class="dropdown-item <cfif !isNull(url.orderby) AND url.orderBy EQ 'productName|DESC'>active</cfif>" href="#productCollectionList.buildURL( 'orderBy=productName|DESC',false )#">Name - Z to A</a>
			    	<a class="dropdown-item <cfif !isNull(url.orderby) AND url.orderBy EQ 'calculatedSalePrice|ASC'>active</cfif>" href="#productCollectionList.buildURL( 'orderBy=calculatedSalePrice|ASC',false )#">Price - Low to High</a>
			    	<a class="dropdown-item <cfif !isNull(url.orderby) AND url.orderBy EQ 'calculatedSalePrice|DESC'>active</cfif>" href="#productCollectionList.buildURL( 'orderBy=calculatedSalePrice|DESC',false )#">Price - High to Low</a>
			    	<a class="dropdown-item <cfif !isNull(url.orderby) AND url.orderBy EQ 'createdDateTime|DESC'>active</cfif>" href="#productCollectionList.buildURL( 'orderBy=createdDateTime|DESC',false )#">Date Created - Newest to Oldest</a>
			    	<a class="dropdown-item <cfif !isNull(url.orderby) AND url.orderBy EQ 'createdDateTime|ASC'>active</cfif>" href="#productCollectionList.buildURL( 'orderBy=createdDateTime|ASC',false )#">Date Created - Oldest to Newest</a>
			    	<a class="dropdown-item <cfif !isNull(url.orderby) AND url.orderBy EQ 'brand.brandName|ASC'>active</cfif>" href="#productCollectionList.buildURL( 'orderBy=brand.brandName|ASC',false )#">Brand - A to Z</a>
			    	<a class="dropdown-item <cfif !isNull(url.orderby) AND url.orderBy EQ 'brand.brandName|DESC'>active</cfif>" href="#productCollectionList.buildURL( 'orderBy=brand.brandName|DESC',false )#">Brand - Z to A</a>
				</div>
			</div>
        </div>
        
    </div>

    <div class="row">
    	<div class="col-lg-3">
            <cfinclude template="inc/productListingSidebar.cfm">
    	</div>
    	
    	<!--- Content Body --->
    	<div class="col-lg-9">

	        <!--- Product Listing Body --->
	        <cfif arrayLen(productCollection)>
	        	<div class="row">
		        	<cfloop array = "#productCollection#" index="local.product">
		        		<div class="col-lg-4 col-md-6 mb-4">
		    				<div class="card h-100">
		    					<!--- Get resized image profile --->
		    					<cfset local.mediumimages = $.slatwall.getService("ImageService").getResizedImageByProfileName("#local.product['defaultSku_skuID']#","medium") />
		    					<a href="/product/#local.product['urlTitle']#">
								<cfif arrayLen(local.mediumimages)>
								    <a href="/#$.slatwall.setting('globalURLKeyProduct')#/#local.product['urlTitle']#">
								        <img src="#local.mediumimages[1]#" class="img-fluid" alt="#local.product['productName']#" />
								    </a>
								</cfif>
		    					<div class="card-body">
		                            <small><a href="/#$.slatwall.setting('globalURLKeyProductType')#/#local.product['productType_urlTitle']#" class="text-secondary">#local.product['productType_productTypeName']#</a></small>
		                            <h4><a href="/#$.slatwall.setting('globalURLKeyProduct')#/#local.product['urlTitle']#">#local.product['productName']#</a></h4>
		                            <!--- Only displays crossed out list price if it's greater than actual price --->
		                            <cfif local.product['defaultSku_listPrice'] GT local.product['defaultSku_price']>
		                            	<s class="float-right">#local.product['defaultSku_listPrice']#</s>
		                            </cfif>
		    						<h5>#local.product['defaultSku_price']#</h5>
		    						#local.product['productDescription']#
		    					</div>
		    					<div class="card-footer">
		    						
		    						<!----- Server Side Add to Cart Button -------->
		    						
		    						<form action="?s=1" method="post">
		    							<button type="submit" class="btn btn-primary float-left">Buy Now (server side)</button>
		    							<input type="hidden" name="skuID" value="#local.product['defaultSku_skuID']#" />
		    							<input type="hidden" name="slatAction" value="public:cart.addOrderItem">
		    						</form>
		    						
		    						<!----- AJAX Add to Cart Button -------->
		    						
		    						<!---- since we are inside a loop, we need a unique id for each ngModel variable to avoid conflicts ------>
		    						<cfset local.formUniqueID = getHibachiScope().createHibachiUUID() />
		    						
		    						<!----- use ng-init for hidden inputs ----->

		    						<span ng-init="OrderItem_Add_#local.formUniqueID# = {skuID:'#local.product['defaultSku_skuID']#'}"></span>
		    						<form  
										ng-model="OrderItem_Add_#local.formUniqueID#"
										ng-submit="swfForm.submitForm()"
										swf-form 
										data-method="addOrderItem"
										<!--- use s-redirect-url or f-redirect-url as attributes here if needed ---->
									>
		    							<input type="hidden" ng-model="OrderItem_Add_#local.formUniqueID#.skuID" name="skuID" />
									    <button class="btn btn-primary float-left" >{{(swfForm.loading ? 'Loading...' : 'Buy Now (client side)')}}</button>

									</form>
									
									<!------ End of add to cart buttons -------->
									
									<a href="/#$.slatwall.setting('globalURLKeyProduct')#/#local.product['urlTitle']#" class="btn btn-default float-right">Learn More</a>
									
		    					</div>
		    				</div>
    					</div>
		        	</cfloop>
	        	</div>
	        <cfelse>
	        	<div class="alert alert-secondary" role="alert"> No products found. Please try again.</div>
	        </cfif>

            <!--- Pagination --->
            <sw:SlatwallCollectionPagination
            	collection="#productCollectionList#"
            	template="../custom/apps/#$.slatwall.getApp().getAppCode()#/#$.slatwall.getSite().getSiteCode()#/tags/tagtemplates/CollectionPagination.cfm"
            	slatwallScope="#$.slatwall#"
            	showFirstAndLast="true">
            </sw:SlatwallCollectionPagination>
            
    	</div>
    </div>
</div>
<cfinclude template="_slatwall-footer.cfm" />
</cfoutput>

