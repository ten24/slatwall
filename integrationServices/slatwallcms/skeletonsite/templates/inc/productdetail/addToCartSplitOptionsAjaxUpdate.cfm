<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	<div class="span4">
		<!--- START: ADD TO CART EXAMPLE 3 --->
		<h5>Add To Cart Form Example 3 (Split Option Groups, Ajax Inventory Update)</h5>

		<!--- Start of form, note that the action can be set to whatever URL you would like the user to end up on. --->
		<form action="?productID=#local.product.getProductID()#&s=1" method="post">
			<input type="hidden" name="slatAction" value="public:cart.addOrderItem" />
			<input type="hidden" name="productID" value="#local.product.getProductID()#" />

			<!--- First we get all the option groups this product uses --->
			<cfset optionGroupsArr = local.product.getOptionGroups() />

			<!--- We also get the options associeated with each of those option groups along with some additional details --->
			<cfset skuOptionDetails = local.product.getSkuOptionDetails() />


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
									'productID': '#local.product.getProductID()#',
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
		<!--- END: ADD TO CART EXAMPLE 3 --->
	</div>
</cfoutput>