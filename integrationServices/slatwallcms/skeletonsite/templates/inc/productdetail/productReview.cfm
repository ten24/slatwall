<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
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
					<cfset productReviewsSmartList = local.product.getProductReviewsSmartList() />

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
						<p class="success">Your product review was successfully added. <cfif not local.product.setting('productAutoApproveReviewsFlag')>Please note that products reviews are reviewed by our staff before being published to the site.</cfif></p>

					<cfelse>

						<!--- Error Display: This will show all of the errors of the addProductReview if it was submitted and has some --->
						<sw:ErrorDisplay object="#local.product.getProcessObject('addProductReview').getNewProductReview()#" />

						<!--- Add Product Review Form --->
						<form action="?productID=#local.product.getProductID()#&s=1" method="post">

							<!--- This hidden input is what tells slatwall to add the contents submitted --->
							<input type="hidden" name="slatAction" value="public:product.addProductReview" />

							<!--- This hidden field is what attaches the review to the actual product and it is required for this form to work --->
							<input type="hidden" name="newProductReview.product.productID" value="#local.product.getProductID()#" />

							<!--- This is just required so that it will populate correctly --->
							<input type="hidden" name="newProductReview.productReviewID" value="" />

							<!--- Rating --->
							<div class="control-group">
		    					<label class="control-label" for="rating">Rating</label>
		    					<div class="controls">

									<!--- This select box allows you to add ratings along with your review, but it is not required.  If you would just like to do ratings that is fine too --->
									<sw:FormField type="select" name="newProductReview.rating" valueObject="#local.product.getProcessObject('addProductReview').getNewProductReview()#" valueOptions="#local.product.getProcessObject('addProductReview').getNewProductReview().getRatingOptions()#" valueObjectProperty="rating" class="span6" />
									<sw:ErrorDisplay object="#local.product.getProcessObject('addProductReview').getNewProductReview()#" errorName="rating" />

		    					</div>
		  					</div>

							<!--- Reviewer Name --->
							<div class="control-group">
		    					<label class="control-label" for="reviewerName">Reviewer Name</label>
		    					<div class="controls">

									<!--- Little bit of logic to set the default reviewers name to the current account if they are logged in.  This is totally optional --->
									<cfif isNull(local.product.getProcessObject('addProductReview').getNewProductReview().getReviewerName()) and $.slatwall.getLoggedInFlag()>
										<cfset local.product.getProcessObject('addProductReview').getNewProductReview().setReviewerName( $.slatwall.getAccount().getFullName() ) />
		    						</cfif>

		    						<!--- This form field allows you to let users add titles to reviews, but it is not required --->
									<sw:FormField type="text" name="newProductReview.reviewerName" valueObject="#local.product.getProcessObject('addProductReview').getNewProductReview()#" valueObjectProperty="reviewerName" class="span6" />
									<sw:ErrorDisplay object="#local.product.getProcessObject('addProductReview').getNewProductReview()#" errorName="reviewerName" />

		    					</div>
		  					</div>

							<!--- Review Title --->
							<div class="control-group">
		    					<label class="control-label" for="reviewTitle">Review Title</label>
		    					<div class="controls">

		    						<!--- This form field allows you to let users add titles to reviews, but it is not required --->
									<sw:FormField type="text" name="newProductReview.reviewTitle" valueObject="#local.product.getProcessObject('addProductReview').getNewProductReview()#" valueObjectProperty="reviewTitle" class="span6" />
									<sw:ErrorDisplay object="#local.product.getProcessObject('addProductReview').getNewProductReview()#" errorName="reviewTitle" />

		    					</div>
		  					</div>

							<!--- Review --->
							<div class="control-group">
		    					<label class="control-label" for="review">Review</label>
		    					<div class="controls">

		    						<!--- This input is the primary review section, but it is also not required by default --->
									<sw:FormField type="textarea" name="newProductReview.review" valueObject="#local.product.getProcessObject('addProductReview').getNewProductReview()#" valueObjectProperty="review" class="span6" />
									<sw:ErrorDisplay object="#local.product.getProcessObject('addProductReview').getNewProductReview()#" errorName="review" />


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
</cfoutput>