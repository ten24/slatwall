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
				
				<cfif structKeyExists(skuOptionDetails,optionGroup.getOptionGroupCode()) AND NOT isNull(skuOptionDetails[ optionGroup.getOptionGroupCode() ])>

					<!--- Option Selector --->
					<div class="control-group">
    					<label class="control-label">#optionGroup.getOptionGroupName()#</label>
    					<div class="controls">

							<!--- We can pull this optionGroup's Option out of the skuOptionDetails --->
								<cfset optionGroupOptions = skuOptionDetails[ optionGroup.getOptionGroupCode() ].options />
	
								<!--- Option Select Dropdown --->
								<div data-optiongroupcode="#optionGroup.getOptionGroupCode()#" class="ajax-option-selector form-group">
	
									<!--- First we include the unselected option --->
									<h6>Select #optionGroup.getOptionGroupName()#</h6>
	
									<!--- New we loop over all options for this optionGroup --->
									<cfloop array="#optionGroupOptions#" index="optionDetails">
	
										<!--- Make sure that this option has a totalQATS > 0 --->
										<cfif optionDetails.totalQATS gte 1>
										<div class="card">
											<input class="splitOption-#local.product.getProductID()#" name="#optionGroup.getOptionGroupCode()#" id="#optionDetails.optionID#" type="radio" value="#optionDetails.optionID#">
											<label for="#optionDetails.optionID#">#optionDetails.optionName#</label>
										</div>
										</cfif>
	
									</cfloop>
	
								</div>
    					</div>
  					</div>
				</cfif>
				</cfloop>

				<!--- jQuery that allows for dynamic updating of options --->
				<script type="text/javascript">
					(function($){
						$(document).ready(function(e){
							//If one of our options gets clicked
							$('body').on('click', '.splitOption-#local.product.getProductID()#', function(){
								
								//if the one I clicked was unavailable (marked here by the text-danger class) 
								if($(this).next().hasClass("text-danger")){
									$(this).next().removeClass('text-danger'); //let's make it available by removing the class
									selectedOptionIDList = $(this).val(); //and we'll request from the server only the available options that match this one selected option
								} else { // if the option selected was not unavailable
									//let's loop through all selected radio inputs and make a list of their ids
									var selectedOptionIDList = $.map($(this).closest('.ajax-product-options').find('input[type="radio"]:checked'), function(n, i){
										if(n.value.length) {
											return n.value;
										}
									}).join(','); //and request from the server the options that match the list	
								}
								
								//preparing ajax call
								var data = {
									'slatAction': 'public:ajax.productAvailableSkuOptions',
									'productID': '#local.product.getProductID()#',
									'selectedOptionIDList': selectedOptionIDList
								};

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
									success: function(r) { // if call is successful
										//for each option in this form
										$('.splitOption-#local.product.getProductID()#').each(function(index){
											//make it enabled for now
											$(this).next().removeClass('text-danger');
											if(
												r.availableSkuOptions.indexOf($(this).val()) === -1 // if value is not in the list of available options
											){
												$(this).next().addClass('text-danger'); //disable the option
												if($(this).is(':checked')){ //if this was previously checked
													$(this).prop('checked',false); //uncheck
												}
											}
										});
										//let's make the add to cart button disabled unless all option groups have been selected
										$('##ajax-submit-#local.product.getProductID()#').prop('disabled',true);
										//if number of selected inputs equals the number of option groups
										if($('.ajax-option-selector').length === $('.ajax-option-selector').find('input[type="radio"]:checked').length){
											$('##ajax-submit-#local.product.getProductID()#').prop('disabled',false); //make button enabled
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
			<button type="submit" id="ajax-submit-#local.product.getProductID()#" class="btn" disabled>Add To Cart</button>
		</form>
		<!--- END: ADD TO CART EXAMPLE 3 --->
	</div>
</cfoutput>