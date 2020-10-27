<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

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

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

--->

<!--- This header include should be changed to the header of your site.  Make sure that you review the header to include necessary JS elements for slatwall templates to work --->
<cfinclude template="_slatwall-header.cfm" />

<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../tags" />

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
<cfset local.product = $.slatwall.getProduct() />
<cfoutput>
	<div class="container">

		<div class="row">
			<div class="span12">
				<!--- We use the getTitle() method which uses the title template setting to pull in brand name or whatever else you might want in your titles --->
				<h2>#local.product.getProductName()# / #local.product.getTitle()#</h2>
			</div>
		</div>

		<!--- Start: General Info Display Example --->
		<div class="row">
			
			<cfinclude template="./inc/productdetail/productTitleAndImage.cfm" /> 
			
			<div class="span8">
				<div class="row">
					<div class="span5">
						<!--- START: PRODUCT DETAILS EXAMPLE --->
						<h5>Product Details Example</h5>
						<dl class="dl-horizontal">
							<!--- Product Code --->
							<dt>Product Code</dt>
							<dd>#local.product.getProductCode()#</dd>

							<!--- Product Type --->
							<dt>Product Type</dt>
							<dd><a href="#$.slatwall.setting('globalURLKeyProductType')#/#local.product.getProductType().getUrlTitle()#" class="text-secondary">#local.product.getProductType().getProductTypeName()#</a></dd>
							<!--- Brand --->
							<cfif !isNull(local.product.getBrand())>
								<dt>Brand</dt>
								<dd><a href="#$.slatwall.setting('globalURLKeyBrand')#/#local.product.getBrand().getUrlTitle()#" class="text-secondary">#local.product.getBrand().getBrandName()#</a></dd>
							</cfif>

							<!--- List Price | This price is really just a place-holder type of price that can display the MSRP.  It is typically used to show the highest price --->
							<dt>List Price</dt>
							<dd>#local.product.getFormattedValue('listPrice')#</dd>

							<!--- Current Account Price | This price is used for accounts that have Price Groups associated with their account.  Typically Price Groups are used for Wholesale pricing, or special employee / account pricing --->
							<dt>Current Account Price</dt>
							<dd>#local.product.getFormattedValue('currentAccountPrice')#</dd>

							<!--- Sale Price | This value will be pulled from any current active promotions that don't require any promotion qualifiers or promotion codes --->
							<dt>Sale Price</dt>
							<dd>#local.product.getFormattedValue('salePrice')# </dd>

							<!--- Live Price | The live price looks at both the salePrice and currentAccountPrice to figure out which is better and display that.  This is what the customer will see in their cart once the item has been added so it should be used as the primary price to display --->
							<dt>Live Price</dt>
							<dd>#local.product.getFormattedValue('livePrice')# </dd>

							<!--- Product Description --->
							<dt>Product Description</dt>
							<dd>#local.product.getProductDescription()# &nbsp;</dd>
							
							<!----Categories---->
							<cfset local.categories = local.product.getCategories() />
							<dt>Categories</dt>
							<cfloop array="#local.categories#" index="local.category">
								<dd><a href="#$.slatwall.setting('globalURLKeyCategory')#/#local.category.getUrlTitle()#" class="text-secondary">#local.category.getCategoryName()# &nbsp;</a></dd>
							</cfloop>
						</dl>
						<!--- END: PRODUCT DETAILS EXAMPLE --->
					</div>
					<div class="span3">
						<!--- Start: PRICE DISPLAY EXAMPLE --->
						<h5>Price Display Example</h5>
						<br />
						<cfif $.slatwall.product('price') gt $.slatwall.product('livePrice')>
							<span style="text-decoration:line-through;color:##cc0000;">#local.product.getFormattedValue('price')#</span><br />
							<span style="font-size:24px;color:##333333;">#local.product.getFormattedValue('livePrice')#</span>
						<cfelse>
							<span style="font-size:24px;color:##333333;">#local.product.getFormattedValue('livePrice')#</span>
						</cfif>
						<!---[ DEVELOPER NOTES ]

								When asking for a price from a product, it automatically pulls
								that price from whichever has been defined as the 'Default Sku'
								in the admin.  If your skus have different prices, you will either
								want to update the price based on the sku selected in an addToCart
								form, or you might want to put the price in the dropdowns themselves.
								Another option would be to use the type of AddToCart form that lists
								out all of the skus.

						--->
						<!--- END: PRICE DISPLAY EXAMPLE --->
					</div>
				</div>
			</div>
		</div>
		<!--- End: General Info Display Example --->

		<hr />

		<!--- Start: Add to Cart Examples --->
		<div class="row">

			<!--- If this item was just added show the success message --->
			<cfif $.slatwall.hasSuccessfulAction( "public:cart.addOrderItem" )>
				<div class="alert alert-success">
					The item was successfully added to your cart.  You might want to change the action="" of the add to cart form so that it points directly to shopping cart page that way the user ends up there.  Or you can add a 'sRedirectURL' hidden field value to specify where you would like the user to be redirected after a succesful addToCart
				</div>
			<!--- If this item was just tried to be added, but failed then show the failure message --->
			<cfelseif $.slatwall.hasFailureAction( "public:cart.addOrderItem" )>
				<div class="alert alert-danger">
					<!--- Display whatever errors might have been associated with the specific options --->
					<sw:ErrorDisplay object="#$.slatwall.cart().getProcessObject('addOrderItem')#" />

					<!--- Display any errors with saving the order after the item was atempted to be added --->
					<sw:ErrorDisplay object="#$.slatwall.cart()#" errorName="addOrderItem" />
				</div>
			</cfif>

			<cfif #local.product.getAvailableForPurchaseFlag()# AND (local.product.getQATS() GTE 1) >

				<cfinclude template="./inc/productdetail/addToCartSingleSku.cfm" />
				<cfinclude template="./inc/productdetail/addToCartSplitOptions.cfm" />
				<cfinclude template="./inc/productdetail/addToCartSplitOptionsAjaxUpdate.cfm" />
			
			<cfelseif local.product.getQATS() GTE 1>
				<div class="span12"><p>Available for purchase #dateFormat(local.product.getPurchaseStartDateTime(),"long")#</p></div>
			</cfif>
				<div class="span12"><p>Out of Stock</p></div>
		</div>
		<!--- End: Add to Cart Examples --->

		<hr />
		
		<cfinclude template="./inc/productdetail/productReview.cfm" />

		<hr />

		<cfinclude template="./inc/productdetail/relatedProducts.cfm" />

		<hr />

		<cfinclude template="./inc/productdetail/productImageGallery.cfm" />
		
	</div>
	
	<!--- Adds zoom modal for img tags with class "clickToOpenModal"---->
	<div class="modal fade" id="imagemodal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">              
          <div class="modal-body">
          	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
            <img src="" class="imagepreview" style="width: 100%;" >
          </div>
        </div>
      </div>
    </div>
    <script>
      $(function() {
      		$('.clickToOpenModal').on('click', function() {
      			$('.imagepreview').attr('src', $(this).attr('src'));
      			$('##imagemodal').modal('show');   
      		});		
      });
    </script>
	
</cfoutput>

<!--- This footer should be replaced with the footer of your site --->
<cfinclude template="_slatwall-footer.cfm" />
