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

<cfoutput>
	<div class="container">

		<div class="row">
			<div class="span12">
				<!--- We use the getTitle() method which uses the title template setting to pull in brand name or whatever else you might want in your titles --->
				<h2>#$.slatwall.product().getTitle()#</h2>
			</div>
		</div>

		<!--- Start: General Info Display Example --->
		<div class="row">
			<div class="span4">
				<div class="well">
					<!--- Display primary product image if it exists or the product image placeholder  --->
					<cfif $.slatwall.product().getImageExistsFlag()>
						<!--- If the image exists, display image with link to full version --->
						<a href="#$.slatwall.product().getImagePath()#" target="_blank">#$.slatwall.product().getImage(size="m")#</a>
					<cfelse>
						<!--- If the image doesn't exists, display image with link to full version --->
						#$.slatwall.product().getImage(size="m")#
					</cfif>
				</div>
			</div>

			<div class="span8">
				<div class="row">
					<div class="span5">
						<!--- START: PRODUCT DETAILS EXAMPLE --->
						<h5>Product Details Example</h5>
						<dl class="dl-horizontal">
							<!--- Product Code --->
							<dt>Product Code</dt>
							<dd>#$.slatwall.product().getProductCode()#</dd>

							<!--- Product Type --->
							<dt>Product Type</dt>
							<dd>#$.slatwall.product().getProductType().getProductTypeName()#</dd>

							<!--- Brand --->
							<cfif !isNull($.slatwall.product().getBrand())>
								<dt>Brand</dt>
								<dd>#$.slatwall.product().getBrand().getBrandName()#</dd>
							</cfif>

							<!--- List Price | This price is really just a place-holder type of price that can display the MSRP.  It is typically used to show the highest price --->
							<dt>List Price</dt>
							<dd>#$.slatwall.product().getFormattedValue('listPrice')#</dd>

							<!--- Current Account Price | This price is used for accounts that have Price Groups associated with their account.  Typically Price Groups are used for Wholesale pricing, or special employee / account pricing --->
							<dt>Current Account Price</dt>
							<dd>#$.slatwall.product().getFormattedValue('currentAccountPrice')#</dd>

							<!--- Sale Price | This value will be pulled from any current active promotions that don't require any promotion qualifiers or promotion codes --->
							<dt>Sale Price</dt>
							<dd>#$.slatwall.product().getFormattedValue('salePrice')# </dd>

							<!--- Live Price | The live price looks at both the salePrice and currentAccountPrice to figure out which is better and display that.  This is what the customer will see in their cart once the item has been added so it should be used as the primary price to display --->
							<dt>Live Price</dt>
							<dd>#$.slatwall.product().getFormattedValue('livePrice')# </dd>

							<!--- Product Description --->
							<dt>Product Description</dt>
							<dd>#$.slatwall.product().getProductDescription()# &nbsp;</dd>
						</dl>
						<!--- END: PRODUCT DETAILS EXAMPLE --->
					</div>
					<div class="span3">
						<!--- Start: PRICE DISPLAY EXAMPLE --->
						<h5>Price Display Example</h5>
						<br />
						<cfif $.slatwall.product('price') gt $.slatwall.product('livePrice')>
							<span style="text-decoration:line-through;color:##cc0000;">#$.slatwall.product().getFormattedValue('price')#</span><br />
							<span style="font-size:24px;color:##333333;">#$.slatwall.product().getFormattedValue('livePrice')#</span>
						<cfelse>
							<span style="font-size:24px;color:##333333;">#$.slatwall.product().getFormattedValue('livePrice')#</span>
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
				<div class="alert alert-error">
					<!--- Display whatever errors might have been associated with the specific options --->
					<sw:ErrorDisplay object="#$.slatwall.cart().getProcessObject('addOrderItem')#" />

					<!--- Display any errors with saving the order after the item was atempted to be added --->
					<sw:ErrorDisplay object="#$.slatwall.cart()#" errorName="addOrderItem" />
				</div>
			</cfif>

			<cfif #$.slatwall.product().getAvailableForPurchaseFlag()#>

				<div class="span4">
					<!--- START: ADD TO CART EXAMPLE 1 --->
					<h5>Add To Cart Form 1 (Simple Sku Dropdown, No Inventory)</h5>

					<!--- Start of form, note that the action can be set to whatever URL you would like the user to end up on. --->
					<form action="?productID=#$.slatwall.product().getProductID()#&s=1" method="post">
						<input type="hidden" name="slatAction" value="public:cart.addOrderItem" />

						<!---[ DEVELOPER NOTES ]

							$.slatwall.product().getSkus() returns all of the skus for a product

						 	sorted = true | allows for the list to be sorted based on the optionGroup and option sort order
							fetchOptions = true | optimizes the query to pull down the option details to be displayed

						--->
						<cfset skus = $.slatwall.product().getSkus(sorted=true, fetchOptions=true) />

						<!--- Check to see if there are more than 1 skus, if so then display the options dropdown --->
						<cfif arrayLen(skus) gt 1>

							<!--- Sku Selector --->
							<div class="control-group">
		    					<label class="control-label">Select Options</label>
		    					<div class="controls">

									<!--- Sku Select Dropdown --->
									<select name="skuID" class="required">

										<!--- Blank option to force user to select (this is optional) --->
										<option value="">Select Option</option>

										<!--- Loop over the skus to display options --->
										<cfloop array="#skus#" index="sku">
											<!--- This provides an option for each sku, with the 'displayOptions' method to show the optionGroup / option names --->
											<option value="#sku.getSkuID()#">#sku.displayOptions()#</option>
										</cfloop>

									</select>
									<sw:ErrorDisplay object="#$.slatwall.cart().getProcessObject('addOrderItem')#" errorName="sku" />

		    					</div>
		  					</div>

						<!--- If there are only 1 skus, then add a hidden field --->
						<cfelse>
							<input type="hidden" name="skuID" value="#$.slatwall.product().getDefaultSku().getSkuID()#" />
						</cfif>

						<!--- Quantity --->
						<div class="control-group">
	    					<label class="control-label" for="quantity">Quantity</label>
	    					<div class="controls">

								<sw:FormField type="text" valueObject="#$.slatwall.cart().getProcessObject('addOrderItem')#" valueObjectProperty="quantity" class="span1" />
								<sw:ErrorDisplay object="#$.slatwall.cart().getProcessObject('addOrderItem')#" errorName="quantity" />

	    					</div>
	  					</div>

						<!--- Add to Cart Button --->
						<button type="submit" class="btn">Add To Cart</button>
					</form>
					<!--- END: ADD TO CART EXAMPLE 1 --->
				</div>

				<div class="span4">
					<!--- START: ADD TO CART EXAMPLE 2 --->
					<h5>Add To Cart Form 2 (Split Option Groups, Default Sku Selected, No Inventory Check)</h5>

					<!--- Start of form, note that the action can be set to whatever URL you would like the user to end up on. --->
					<form action="?productID=#$.slatwall.product().getProductID()#&s=1" method="post">
						<input type="hidden" name="slatAction" value="public:cart.addOrderItem" />
						<input type="hidden" name="productID" value="#$.slatwall.product().getProductID()#" />

						<!--- First we get all the option groups this product uses --->
						<cfset optionGroupsArr = $.slatwall.product().getOptionGroups() />
						<cfset defaultSelectedOptions = $.slatwall.product().getDefaultSku().getOptionsIDList() />

						<!--- Loop over all options groups --->
						<cfloop array="#optionGroupsArr#" index="optionGroup">

							<!--- Then we get the options for used by each option group for this product --->
							<cfset optionsArr = $.slatwall.product().getOptionsByOptionGroup( optionGroup.getOptionGroupID() ) />

							<!--- Option Selector --->
							<div class="control-group">
		    					<label class="control-label">#optionGroup.getOptionGroupName()#</label>
		    					<div class="controls">

									<!--- Option Select Dropdown --->
									<select name="selectedOptionIDList">

										<cfloop array="#optionsArr#" index="option">
											<option value="#option.getOptionID()#" <cfif listFindNoCase(defaultSelectedOptions, option.getOptionID())> selected="selected"</cfif>>#option.getOptionName()#</option>
										</cfloop>

									</select>


		    					</div>
		  					</div>
						</cfloop>

						<sw:ErrorDisplay object="#$.slatwall.cart().getProcessObject('addOrderItem')#" errorName="selectedOptionIDList" />

						<!--- Quantity --->
						<div class="control-group">
	    					<label class="control-label" for="quantity">Quantity</label>
	    					<div class="controls">

								<sw:FormField type="text" valueObject="#$.slatwall.cart().getProcessObject('addOrderItem')#" valueObjectProperty="quantity" class="span1" />
								<sw:ErrorDisplay object="#$.slatwall.cart().getProcessObject('addOrderItem')#" errorName="quantity" />

	    					</div>
	  					</div>

						<!--- Add to Cart Button --->
						<button type="submit" class="btn">Add To Cart</button>
					</form>
					<!--- END: ADD TO CART EXAMPLE 2 --->
				</div>

				<div class="span4">
					<!--- START: ADD TO CART EXAMPLE 3 --->
					<h5>Add To Cart Form Example 3 (Split Option Groups, Ajax Inventory Update)</h5>

					<!--- Start of form, note that the action can be set to whatever URL you would like the user to end up on. --->
					<form action="?productID=#$.slatwall.product().getProductID()#&s=1" method="post">
						<input type="hidden" name="slatAction" value="public:cart.addOrderItem" />
						<input type="hidden" name="productID" value="#$.slatwall.product().getProductID()#" />

						<!--- First we get all the option groups this product uses --->
						<cfset optionGroupsArr = $.slatwall.product().getOptionGroups() />

						<!--- We also get the options associeated with each of those option groups along with some additional details --->
						<cfset skuOptionDetails = $.slatwall.product().getSkuOptionDetails() />


						<!--- Create a container to compartmentalize this UI element, the class of this is used by the javascript --->
						<div class="ajax-product-options">
							<!--- Loop over all options groups --->
							<cfloop array="#optionGroupsArr#" index="optionGroup">

								<!--- Option Selector --->
								<div class="control-group">
			    					<label class="control-label">#optionGroup.getOptionGroupName()#</label>
			    					<div class="controls">

										<!--- We can pull this optionGroup's Option out of the skuOptionDetails --->
										<cfset optionGroupOptions = skuOptionDetails[ optionGroup.getOptionGroupCode() ].options />

										<!--- Option Select Dropdown --->
										<select name="selectedOptionIDList" data-optiongroupcode="#optionGroup.getOptionGroupCode()#" class="ajax-option-selector">

											<!--- First we include the unselected option --->
											<option value="" selected="selected">Select #optionGroup.getOptionGroupName()#...</option>

											<!--- New we loop over all options for this optionGroup --->
											<cfloop array="#optionGroupOptions#" index="optionDetails">

												<!--- Make sure that this option has a totalQATS > 0 --->
												<cfif optionDetails.totalQATS gte 1>
													<option value="#optionDetails.optionID#">#optionDetails.optionName#</option>
												</cfif>

											</cfloop>

										</select>


			    					</div>
			  					</div>

							</cfloop>

							<!--- jQuery that allows for dynamic updating of options --->
							<script type="text/javascript">
								(function($){
									$(document).ready(function(e){
										$('body').on('change', '.ajax-option-selector', function(){

											var selectedOptionIDList = $.map($(this).closest('.ajax-product-options').find('select[name=selectedOptionIDList]'), function(n, i){
												if(n.value.length) {
													return n.value;
												}
											}).join(',');

											var data = {
												'slatAction': 'public:ajax.productSkuOptionDetails',
												'productID': '#$.slatwall.product().getProductID()#',
												'selectedOptionIDList': selectedOptionIDList
											};

											var thisOptionSelector = this;

											jQuery.ajax({
												type: 'get',
												url: '#$.slatwall.getApplicationValue("baseURL")#/',
												data: data,
												dataType: "json",
												context: document.body,
												headers: { 'X-Hibachi-AJAX': true },
												error: function( err ) {
													alert('There was an error processing request: ' + err);
												},
												success: function(r) {
													for(var optionGroup in r.skuOptionDetails) {
														if( $(thisOptionSelector).data('optiongroupcode') != optionGroup ) {
															for(var index in r.skuOptionDetails[ optionGroup ].options) {
																var optionDetails = r.skuOptionDetails[ optionGroup ].options[ index ];

																// This default dersion will just add the 'disabled' attribute to ones with no inventory
																if(optionDetails.selectedQATS <= 0) {
																	$(thisOptionSelector).closest('.ajax-product-options').find('option[value=' + optionDetails.optionID + ']').attr('disabled', 'disabled');
																} else {
																	$(thisOptionSelector).closest('.ajax-product-options').find('option[value=' + optionDetails.optionID + ']').removeAttr('disabled');
																}

															}
														}
													}
												}
											});

										});

									});

								})( jQuery );
							</script>
						</div>

						<sw:ErrorDisplay object="#$.slatwall.cart().getProcessObject('addOrderItem')#" errorName="selectedOptionIDList" />

						<!--- Quantity --->
						<div class="control-group">
	    					<label class="control-label" for="quantity">Quantity</label>
	    					<div class="controls">

								<sw:FormField type="text" valueObject="#$.slatwall.cart().getProcessObject('addOrderItem')#" valueObjectProperty="quantity" class="span1" />
								<sw:ErrorDisplay object="#$.slatwall.cart().getProcessObject('addOrderItem')#" errorName="quantity" />

	    					</div>
	  					</div>

						<!--- Add to Cart Button --->
						<button type="submit" class="btn">Add To Cart</button>
					</form>
					<!--- END: ADD TO CART EXAMPLE 2 --->

				</div>
			<cfelse>
				<div class="span12"><p>Available for purchase #dateFormat($.slatwall.product().getPurchaseStartDateTime(),"long")#</p></div>
			</cfif>
		</div>
		<!--- End: Add to Cart Examples --->

		<hr />

		<!--- Start: Add Product Review Example --->
		<div class="row">

			<div class="span12">

				<h4>Product Review Example</h4>

				<div class="row">

					<div class="span6">

						<h5>Product Reviews</h5>
						<!---[DEVELOPER NOTES]

							We recommend setting up an email for "Product Reviews" that will go to someone
							in the organization whenever a new product review is created.  You can add an
							Event trigger for "Product" and create an event trigger on:
							"Product - After Add Product Review Success"

						--->

						<!--- Get the existing product reviews smart list --->
						<cfset productReviewsSmartList = $.slatwall.product().getProductReviewsSmartList() />

						<!--- Make sure that only 'active' product reviews are shown --->
						<cfset productReviewsSmartList.addFilter('activeFlag', true) />

						<!--- Set it up to be able to show 100 product reviews --->
						<cfset productReviewsSmartList.setPageRecordsShow(100) />

						<!--- Check to see if there are any product reviews --->
						<cfif productReviewsSmartList.getRecordsCount()>

							<!--- Loop Over All Existing product reviews --->
							<cfloop array="#productReviewsSmartList.getPageRecords()#" index="productReview">

								<!--- Each Review --->
								<article>

									<!--- Show Title and Rating Stars --->
									<h5>#productReview.getReviewTitle()#
										<cfif not isNull(productReview.getRating()) and productReview.getRating() gt 0>
											<i class="icon-star"></i>
											<cfif productReview.getRating() gte 2>
												<i class="icon-star"></i>
											</cfif>
											<cfif productReview.getRating() gte 3>
												<i class="icon-star"></i>
											</cfif>
											<cfif productReview.getRating() gte 4>
												<i class="icon-star"></i>
											</cfif>
											<cfif productReview.getRating() gte 5>
												<i class="icon-star"></i>
											</cfif>
										</cfif>
									</h5>

									<!--- Show the reviewer info --->
									<h6>
										<cfif not isNull(productReview.getReviewerName()) and len(productReview.getReviewerName())>
											<em>#productReview.getReviewerName()#</em>
										<cfelse>
											<em>Anonymous</em>
										</cfif>
									</h6>

									<!--- Show the actual Review --->
									<p>#productReview.getFormattedValue('review')#</p>

								</article>

								<hr style="border-top-style:dashed;" />
							</cfloop>

						<cfelse>

							<p>The are currently no reviews for this product, be the first!</p>

						</cfif>

					</div>

					<div class="span6">

						<!--- Start: Add Product Review Form --->
						<h5>Add Product Review</h5>

						<!--- Check to see if this was just submitted successfully --->
						<cfif $.slatwall.hasSuccessfulAction( "public:product.addProductReview" )>

							<!--- Show success Message --->
							<p class="success">Your product review was successfully added. <cfif not $.slatwall.product().setting('productAutoApproveReviewsFlag')>Please note that products reviews are reviewed by our staff before being published to the site.</cfif></p>

						<cfelse>

							<!--- Error Display: This will show all of the errors of the addProductReview if it was submitted and has some --->
							<sw:ErrorDisplay object="#$.slatwall.product().getProcessObject('addProductReview').getNewProductReview()#" />

							<!--- Add Product Review Form --->
							<form action="?productID=#$.slatwall.product().getProductID()#&s=1" method="post">

								<!--- This hidden input is what tells slatwall to add the contents submitted --->
								<input type="hidden" name="slatAction" value="public:product.addProductReview" />

								<!--- This hidden field is what attaches the review to the actual product and it is required for this form to work --->
								<input type="hidden" name="newProductReview.product.productID" value="#$.slatwall.product().getProductID()#" />

								<!--- This is just required so that it will populate correctly --->
								<input type="hidden" name="newProductReview.productReviewID" value="" />

								<!--- Rating --->
								<div class="control-group">
			    					<label class="control-label" for="rating">Rating</label>
			    					<div class="controls">

										<!--- This select box allows you to add ratings along with your review, but it is not required.  If you would just like to do ratings that is fine too --->
										<sw:FormField type="select" name="newProductReview.rating" valueObject="#$.slatwall.product().getProcessObject('addProductReview').getNewProductReview()#" valueOptions="#$.slatwall.product().getProcessObject('addProductReview').getNewProductReview().getRatingOptions()#" valueObjectProperty="rating" class="span6" />
										<sw:ErrorDisplay object="#$.slatwall.product().getProcessObject('addProductReview').getNewProductReview()#" errorName="rating" />

			    					</div>
			  					</div>

								<!--- Reviewer Name --->
								<div class="control-group">
			    					<label class="control-label" for="reviewerName">Reviewer Name</label>
			    					<div class="controls">

										<!--- Little bit of logic to set the default reviewers name to the current account if they are logged in.  This is totally optional --->
										<cfif isNull($.slatwall.product().getProcessObject('addProductReview').getNewProductReview().getReviewerName()) and $.slatwall.getLoggedInFlag()>
											<cfset $.slatwall.product().getProcessObject('addProductReview').getNewProductReview().setReviewerName( $.slatwall.getAccount().getFullName() ) />
			    						</cfif>

			    						<!--- This form field allows you to let users add titles to reviews, but it is not required --->
										<sw:FormField type="text" name="newProductReview.reviewerName" valueObject="#$.slatwall.product().getProcessObject('addProductReview').getNewProductReview()#" valueObjectProperty="reviewerName" class="span6" />
										<sw:ErrorDisplay object="#$.slatwall.product().getProcessObject('addProductReview').getNewProductReview()#" errorName="reviewerName" />

			    					</div>
			  					</div>

								<!--- Review Title --->
								<div class="control-group">
			    					<label class="control-label" for="reviewTitle">Review Title</label>
			    					<div class="controls">

			    						<!--- This form field allows you to let users add titles to reviews, but it is not required --->
										<sw:FormField type="text" name="newProductReview.reviewTitle" valueObject="#$.slatwall.product().getProcessObject('addProductReview').getNewProductReview()#" valueObjectProperty="reviewTitle" class="span6" />
										<sw:ErrorDisplay object="#$.slatwall.product().getProcessObject('addProductReview').getNewProductReview()#" errorName="reviewTitle" />

			    					</div>
			  					</div>

								<!--- Review --->
								<div class="control-group">
			    					<label class="control-label" for="review">Review</label>
			    					<div class="controls">

			    						<!--- This input is the primary review section, but it is also not required by default --->
										<sw:FormField type="textarea" name="newProductReview.review" valueObject="#$.slatwall.product().getProcessObject('addProductReview').getNewProductReview()#" valueObjectProperty="review" class="span6" />
										<sw:ErrorDisplay object="#$.slatwall.product().getProcessObject('addProductReview').getNewProductReview()#" errorName="review" />


			    					</div>
			  					</div>

								<!--- Submit Button --->
								<div class="control-group">
			    					<div class="controls">
			      						<button type="submit" class="btn">Add Review</button>
			    					</div>
			  					</div>

							</form>
							<!--- End: Add Product Review Form --->

						</cfif>

					</div>
				</div>
			</div>
		</div>
		<!--- End: Add Product Review Example --->

		<hr />

		<!--- Start: Related Products Example --->
		<div class="row">
			<div class="span12">

				<h5>Related Products Example</h5>

				<!--- Get the related products smart list --->
				<cfset relatedProductsSmartList = $.slatwall.product().getRelatedProductsSmartList() />

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

		<hr />

		<!--- Start: Image Gallery Example --->
		<div class="row">
			<div class="span12">
				<h5>Image Gallery Example</h5>

				<cfset galleryDetails = $.slatwall.product().getImageGalleryArray() />

				<!---[ DEVELOPER NOTES ]

					The primary method that makes images galleries possible is:

					$.slatwall.getImageGalleryArray( array resizedSizes )

					This is a very unique method to give you all the data you need to create an image gallery
					with whatever sizes.  The ImageGalleryArray will take whatever sizes you pass in, and pass
					back the details and resized image paths for all of the skus default images as well as any
					alternative images that were assigned to the product.

					For example, if you wanted to get 2 sizes back 100x100 and 500x500 so that you could
					display thumbnails ect.  You would just do:

					$.slatwall.getImageGalleryArray( [ {width=100, height=100}, {width=500, height=500} ] )


					By default if you don't pass in your own resizing array, it will just ask for the 3 sizes
					of Small, Medium, and Large which will get the actually sizes from the product settings.
					The logic it runs by default is the same as if you did this:

					$.slatwall.getImageGalleryArray( [ {size='small'},{size='medium'},{size='large'} ] )


					Basically every structure in the array, will just call the getResizedImagePath() method
					so you can pass in whatever resizing and cropping arguments you like based on the specs
					that you read more about here:

					http://docs.getslatwall.com/reference/product-images-and-cropping/

				--->

				<!--- If the product has more than the default image assigned, let's display all images --->
				<cfif arraylen(galleryDetails) GT "1">
					<ul class="thumbnails">
						<cfloop array="#galleryDetails#" index="image">
							<!---[ DEVELOPER NOTES ]
								Now that we are inside of the loop of images being returned, you have access to the
								following detials insilde of the image struct that came back in the array
							--->
							<li class="span3">
								<a href="#image.resizedimagepaths[2]#" target="_blank" class="thumbnail" title="zoom">
									<img src="#image.resizedimagepaths[1]#" alt="#image.name#">
									<i class="icon-zoom-in"></i>
									<span class="pull-right">
										#image.name#
									</span>
								</a>
							</li>
						</cfloop>
					</ul>
				<cfelse>
					<p>There are no additional images.</p>
				</cfif>

			</div>
		</div>
		<!--- End: Image Gallery Example --->
	</div>
</cfoutput>

<!--- This footer should be replaced with the footer of your site --->
<cfinclude template="_slatwall-footer.cfm" />
