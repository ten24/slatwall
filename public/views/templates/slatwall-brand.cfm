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
	<div class="container">
		
		<div class="row">
			<div class="span12">
				<h2>#$.slatwall.getBrand().getBrandName()#</h2>
			</div>
		</div>
		<div class="row">
			<div class="span12">
				
				<ul class="thumbnails">
					
					<!--- Primary Loop that displays all of the products for this brand in the grid format --->
					<cfloop array="#$.slatwall.getBrand().getProductsSmartList().getPageRecords()#" index="product">
						
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
			</div>
		</div>
	</div>
</cfoutput>

<cfinclude template="_slatwall-footer.cfm" />