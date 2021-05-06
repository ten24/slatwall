<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
    <div class="span4">
    	<!--- START: ADD TO CART EXAMPLE 1 --->
    	<h5>Add To Cart Form 1 (Simple Sku Dropdown, No Inventory)</h5>
    
    	<!--- Start of form, note that the action can be set to whatever URL you would like the user to end up on. --->
    	<form action="?productID=#local.product.getProductID()#&s=1" method="post">
    		<input type="hidden" name="slatAction" value="public:cart.addOrderItem" />
    
    		<!---[ DEVELOPER NOTES ]
    
    			local.product.getSkus() returns all of the skus for a product
    
    		 	sorted = true | allows for the list to be sorted based on the optionGroup and option sort order
    			fetchOptions = true | optimizes the query to pull down the option details to be displayed
    
    		--->
    		<cfset skus = local.product.getSkus(sorted=true, fetchOptions=true) />
    
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
    					<sw:ErrorDisplay object="#$.slatwall.cart().getProcessObject('addOrderItem')#" displayType="label" for="skuID" errorName="sku" />
    
    				</div>
      			</div>
    
    		<!--- If there are only 1 skus, then add a hidden field --->
    		<cfelse>
    			<input type="hidden" name="skuID" value="#local.product.getDefaultSku().getSkuID()#" />
    		</cfif>
    
    		<!--- Quantity --->
    		<div class="control-group">
    			<label class="control-label" for="quantity">Quantity</label>
    			<div class="controls">
    
    				<sw:FormField type="text" valueObject="#$.slatwall.cart().getProcessObject('addOrderItem')#" valueObjectProperty="quantity" class="span1" />
    				<sw:ErrorDisplay object="#$.slatwall.cart().getProcessObject('addOrderItem')#"  displayType="label" errorName="quantity" />
    
    			</div>
      		</div>
    
    		<!--- Add to Cart Button --->
    		<button type="submit" class="btn">Add To Cart</button>
    	</form>
    	<!--- END: ADD TO CART EXAMPLE 1 --->
    </div>
</cfoutput>