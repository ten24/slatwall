<cfimport prefix="sw" taglib="/Slatwall/tags" />
<cfimport prefix="sw" taglib="../tags" />
<cfoutput>
<cfinclude template="_slatwall-header.cfm" />

<div class="container">

    <h1 class="my-4">#$.slatwall.content('title')#</h4>
    
    <!--- Add to cart success/fail messages --->
    <div class="alert alert-success">Item added to cart</div>
    
    <div class="alert alert-danger">Item could not be added to cart</div>
    
    <!--- No Product search results found message --->
    <div class="alert alert-warning">No products found</div>
    
    <!--- If this item was just added show the success message --->
	<cfif $.slatwall.hasSuccessfulAction( "public:cart.addOrderItem" )>
		<div class="alert alert-success alert-dismissible fade show" role="alert">
			Item added to cart. <a href="/checkout/" class="alert-link">Continue to Checkout</a>. You might want to change the action="" of the add to cart form so that it points directly to shopping cart page that way the user ends up there.
			Or you can add a 'sRedirectURL' hidden field value to specify where you would like the user to be redirected after a succesful addToCart.
			<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		</div>
	<!--- If this item was just tried to be added, but failed then show the failure message --->
	<cfelseif $.slatwall.hasFailureAction( "public:cart.addOrderItem" )>
		<div class="alert alert-error alert-dismissible fade show" role="alert">
			<!--- Display whatever errors might have been associated with the specific options --->
			<sw:ErrorDisplay object="#$.slatwall.cart().getProcessObject('addOrderItem')#" />

			<!--- Display any errors with saving the order after the item was atempted to be added --->
			<sw:ErrorDisplay object="#$.slatwall.cart()#" errorName="addOrderItem" />
		</div>
	</cfif>
	
	<!--- Base Product Collection List --->
	<cfset productCollectionList = $.slatwall.getService('productService').getProductCollectionList()>
    <cfset productCollectionList.addFilter("activeFlag",1)>
    <cfset productCollectionList.addFilter("publishedFlag",1)>
    <cfset productCollectionList.addFilter("listingPages.content.contentID",$.slatwall.content('contentID')) />
    <cfset productCollectionList.setDisplayProperties("urlTitle,productType.productTypeName,defaultSku.price,defaultSku.listPrice,defaultSku.skuID")>
    <!--- This allows filters applied to collection list --->
    <cfset productCollectionList.applyData()>
    <cfset productCollection = productCollectionList.getPageRecords()>

    <div class="row mb-4">
        <div class="col-sm-3">
            <h6><strong>215</strong> Available Products</h6>
        </div>
        <div class="col-sm-6">
            <a href="##" class="badge badge-secondary">Category &times;</a>
            <a href="##" class="badge badge-secondary">Price &times;</a>
            <a href="##" class="badge badge-secondary">Type &times;</a>
            <a href="##" class="badge badge-danger">Clear All &times;</a>
        </div>
        
        <div class="col-sm-2 offset-md-1">
        	<div class="dropdown">
				<button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					Sort By...
				</button>
				<div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
			    	<a class="dropdown-item <cfif !isNull(url.orderby) AND url.orderBy EQ 'productName|ASC'>active</cfif>" href="#productCollectionList.buildURL( 'orderBy=productName|ASC',false )#">Name - A to Z</a>
			    	<a class="dropdown-item <cfif !isNull(url.orderby) AND url.orderBy EQ 'productName|DESC'>active</cfif>" href="#productCollectionList.buildURL( 'orderBy=productName|DESC',false )#">Name - Z to A</a>
			    	<a class="dropdown-item <cfif !isNull(url.orderby) AND url.orderBy EQ 'calculatedSalePrice|asc'>active</cfif>" href="#productCollectionList.buildURL( 'orderBy=calculatedSalePrice|ASC',false )#">Price - Low to High</a>
			    	<a class="dropdown-item <cfif !isNull(url.orderby) AND url.orderBy EQ 'calculatedSalePrice|asc'>active</cfif>" href="#productCollectionList.buildURL( 'orderBy=calculatedSalePrice|DESC',false )#">Price - High to High</a>
			    	<a class="dropdown-item <cfif !isNull(url.orderby) AND url.orderBy EQ 'brandName|asc'>active</cfif>" href="#productCollectionList.buildURL( 'orderBy=brandName|ASC',false )#">Brand - A to Z</a>
			    	<a class="dropdown-item <cfif !isNull(url.orderby) AND url.orderBy EQ 'brandName|desc'>active</cfif>" href="#productCollectionList.buildURL( 'orderBy=brandName|ASC',false )#">Brand - Z to A</a>
			    	<a class="dropdown-item <cfif !isNull(url.orderby) AND url.orderBy EQ 'brandName|desc'>active</cfif>" href="#productCollectionList.buildURL( 'orderBy=brandName|ASC',false )#">Brand - Z to A</a>
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
		    					<cfset local.mediumimages = $.slatwall.getService("ImageService").getResizedImageByProfileName("#local.product['defaultSku_skuID']#","medium") />                                    <a href="/product/#local.product['urlTitle']#">
								<cfif arrayLen(local.mediumimages)>
								    <a href="/sp/#local.product['urlTitle']#">
								        <img src="#local.mediumimages[1]#" class="img-fluid" alt="#local.product['productName']#" />
								    </a>
								</cfif>
		    					<div class="card-body">
		                            <small><a href="##" class="text-secondary">#local.product['productType_productTypeName']#</a></small>
		                            <h4><a href="/sp/#local.product['urlTitle']#">#local.product['productName']#Item One</a></h4>
		                            <s class="float-right">#local.product['defaultSku_listPrice']#</s>
		    						<h5>#local.product['defaultSku_price']#</h5>
		    						#local.product['productDescription']#
		    					</div>
		    					<div class="card-footer">
		    						<form action="?s=1" method="post">
		    							<button type="submit" class="btn btn-primary float-left">Buy Now</button>
		    							<input type="hidden" name="skuID" value="#local.product['defaultSku_skuID']#" />
		    							<input type="hidden" name="slatAction" value="public:cart.addOrderItem">
		    						</form>
		                            <a href="/sp/#local.product['urlTitle']#" class="btn btn-default float-right">Learn More</a>
		    					</div>
		    				</div>
    					</div>
		        	</cfloop>
	        	</div>
	        <cfelse>
	        	<div class="alert alert-secondary" role="alert"> No products found. Please try again.</div>
	        </cfif>

            <!--- Pagination --->
            <sw:SlatwallCollectionPagination collection="#productCollectionList#" slatwallScope="#$.slatwall#"></sw:SlatwallCollectionPagination>
            
            <!--- Example Pagination Markup --->
        	<nav class="mt-5">
				<ul class="pagination">
					<li class="page-item disabled"><a class="page-link" href="##">Previous</a></li>
			    	<li class="page-item active"><a class="page-link" href="##">1</a></li>
			    	<li class="page-item"><a class="page-link" href="##">2</a></li>
			    	<li class="page-item"><a class="page-link" href="##">3</a></li>
			    	<li class="page-item"><a class="page-link" href="##">Next</a></li>
				</ul>
			</nav>
    	</div>
    </div>
</div>
<cfinclude template="_slatwall-footer.cfm" />
</cfoutput>


