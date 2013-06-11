<!---
	
    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.
	
Notes:
																								
	This template is designed to display a list of products.  In order to do that Slatwall uses	
	a utility called a "SmartList".  The SmartList allows for you to easily add do common		
	listing tasks: Search, Filter, Range Filter, Paging, ect.									
																								
	Anywhere on your site you can use the following to get the current productList:				
																								
	$.slatwall.getProductSmartList()															
																								
	The product list will always have these filters set by default:								
																								
	activeFlag = 1																				
	publishedFlag = 1																			
	(calculatedQATS > 0 or calculatedAllowBackorderFlag = 1)									
																								
	Whenever you are on a content page that has been flaged as a 'Slatwall Listing Page'		
	the $.slatwall.productList() will also include the filter to only show products that have	
	been explicitly assigned to that page in the admin.  In addition this view will be			
	automatically included on content flaged as such.											
																								
	The "SmartList" has the following API methods that you can use to get details about the		
	records being returned.  This productList has access to all of those methods:				
																								
	$.slatwall.productList().getRecordsCount()													
	$.slatwall.productList().getPageRecordsStart()												
	$.slatwall.productList().getPageRecordsEnd()												
	$.slatwall.productList().getPageRecordsShow()												
	$.slatwall.productList().getCurrentPage()													
	$.slatwall.productList().getTotalPages()													
																								
																								
																								
	Inside of the main loop of a productList() you can use any of the following properties		
	that will be be avaliable as part of the primary query.  If you ask for any additional		
	properties, you will run the Risk of N+1 SQL Statements where each record will make			
	1 or more additional database calls	and directly impact performance.  This is why we make	
	use of the 'calculated' fields so that processing necessary is done ahead of time. All of	
	the following values are safe to use in this listing without concern of lazy loading		
																								
	local.product.getProductID()																
	local.product.getActiveFlag()																
	local.product.getURLTitle()																	
	local.product.getProductName()																
	local.product.getProductCode()																
	local.product.getProductDescription()														
	local.product.getPublishedFlag()															
	local.product.getSortOrder()																
	local.product.getCalculatedSalePrice()														
	local.product.getCalculatedQATS()															
	local.product.getCalculatedAllowBackorderFlag()												
	local.product.getCalculatedTitle()															
	local.product.getCreatedDateTime()															
	local.product.getModifiedDateTime()															
	local.product.getRemoteID()																	
																								
	local.product.getDefaultSku().getSkuID()													
	local.product.getDefaultSku().getActiveFlag()												
	local.product.getDefaultSku().getSkuCode()													
	local.product.getDefaultSku().getListPrice()												
	local.product.getDefaultSku().getPrice()													
	local.product.getDefaultSku().getRenewalPrice()												
	local.product.getDefaultSku().getImageFile()												
	local.product.getDefaultSku().getUserDefinedPriceFlag()										
	local.product.getDefaultSku().getCreatedDateTime()											
	local.product.getDefaultSku().getModifiedDateTime()											
	local.product.getDefaultSku().getRemoteID()													
																								
	local.product.getBrand().getBrandID()														
	local.product.getBrand().getActiveFlag()													
	local.product.getBrand().getPublishedFlag()													
	local.product.getBrand().getURLTitle()														
	local.product.getBrand().getBrandName()														
	local.product.getBrand().getBrandWebsite()													
	local.product.getBrnad().getCreatedDateTime()												
	local.product.getBrnad().getModifiedDateTime()												
	local.product.getBrnad().getRemoteID()														
																								
	local.product.getProductType().getProductTypeID()											
	local.product.getProductType().getProductTypeIDPath()										
	local.product.getProductType().getActiveFlag()												
	local.product.getProductType().getPublishedFlag()											
	local.product.getProductType().getURLTitle()												
	local.product.getProductType().getProductTypeName()											
	local.product.getProductType().getProductTypeDescription()									
	local.product.getProductType().getSystemCode()												
	local.product.getProductType().getCreatedDateTime()											
	local.product.getProductType().getModifiedDateTime()										
	local.product.getProductType().getRemoteID()												
																								
	You can find detailed information on SmartList and all of the additional API methods at:	
	http://docs.getslatwall.com/#developers-reference-smart-list								
																								
--->

<!--- This header include should be changed to the header of your site.  Make sure that you review the header to include necessary JS elements for slatwall templates to work --->
<cfinclude template="_slatwall-header.cfm" />

<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="/Slatwall/public/tags" />

<!---[DEVELOPER NOTES]															
																				
	If you would like to customize any of the public tags used by this			
	template, the recommended method is to uncomment the below import,			
	copy the tag you'd like to customize into the directory defined by			
	this import, and then reference with swc:tagname instead of sw:tagname.		
	Technically you can define the prefix as whatever you would like and use	
	whatever directory you would like but we recommend using this for			
	the sake of convention.														
																				
	<cfimport prefix="swc" taglib="/Slatwall/custom/public/tags" />				
																				
--->

<cfoutput>
	

<!--- Product Listing Example 1 --->
<div class="container">
	
	<!--- Header Row --->
	<div class="row">
		<div class="span12">
			<h2>Product Listing Example 1</h2>
		</div>
	</div>
	
	<!--- Main Content --->
	<div class="row">
		
		<!--- Filters & Sorting on Left Side --->
		<div class="span3">
			
			<!--- Filter Brand --->
			<cfset brandFilterOptions = $.slatwall.getProductSmartList().getFilterOptions('brand.brandID', 'brand.brandName') />
			<h4>Filter By Brand</h4>
			<ul class="nav">
				<cfloop array="#brandFilterOptions#" index="brandOption">
					<li><a href="#$.slatwall.getProductSmartList().buildURL( 'f:brand.brandID=#brandOption["value"]#' )#">#brandOption["name"]#</a></li>
				</cfloop>
			</ul>
			
			<!--- Price Range Filter --->
			<h4>Price Range Filter</h4>
			<ul class="nav">
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'r:calculatedSalePrice=^20' )#">less than $20.00</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'r:calculatedSalePrice=20^50' )#">$20.00 - $50.00</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'r:calculatedSalePrice=50^100' )#">$50.00 - $100.00</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'r:calculatedSalePrice=100^250' )#">$100.00 - $250.00</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'r:calculatedSalePrice=250^' )#">over $250.00</a></li>
			</ul>
			
			<!--- Sorting --->
			<h4>Sorting</h4>
			<ul class="nav">
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'orderBy=calculatedSalePrice|ASC' )#">Price Low To High</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'orderBy=calculatedSalePrice|DESC' )#">Price High To Low</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'orderBy=calculatedTitle|ASC' )#">Product Title A-Z</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'orderBy=calculatedTitle|DESC' )#">Product Title Z-A</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'orderBy=productName|ASC' )#">Product Name A-Z</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'orderBy=productName|DESC' )#">Product Name Z-A</a></li>
			</ul>
		</div>
		
		<!--- Primary Grid on Right side --->
		<div class="span9">
			
			<!--- Make sure there are products in the list --->
			<cfif $.slatwall.productList().getRecordsCount()>
				<ul class="thumbnails">
					
					<!--- Primary Loop that displays all of the products in the grid format --->
					<cfloop array="#$.slatwall.getProductSmartList().getPageRecords()#" index="product">
						
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
								
								<!--- This is the link to the product detail page.  By using the getListingProductURL() instead of getProductURL() it will append to the end of the URL string so that the breadcrumbs on the detail page can know what listing page you came from.  This is also good for SEO purposes as long as you remember to add a canonical url meta information to the detail page --->
								<a href="#product.getListingProductURL()#">Details / Buy</a>
								
							</div>
							
						</li>
						
					</cfloop> 
					<!--- END: Primary loop --->
						
				</ul>

				<sw:smartListPager smartList="#$.slatwall.getProductSmartList()#">

			<!--- If there are no products for this current listing page, then tell the customer --->
			<cfelse>
				<p>There are currently no products to display.</p>
			</cfif>
		</div>
		
	</div>
	
</div>


</cfoutput>
<cfinclude template="_slatwall-footer.cfm" />