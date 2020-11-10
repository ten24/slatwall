<!---[ DEVELOPER NOTES ]
    local.product.getSkus() returns all of the skus for a product
    
     sorted = true | allows for the list to be sorted based on the optionGroup and option sort order
    fetchOptions = true | optimizes the query to pull down the option details to be displayed
    
    List Price | This price is really just a place-holder type of price that can display the MSRP.  It is typically used to show the highest price
    List Price: local.product.getFormattedValue('listPrice')
    
    Current Account Price | This price is used for accounts that have Price Groups associated with their account.  Typically Price Groups are used for Wholesale pricing, or special employee / account pricing
    Current Account Price: local.product.getFormattedValue('currentAccountPrice')
    
    Sale Price | This value will be pulled from any current active promotions that don't require any promotion qualifiers or promotion codes
    Sale Price: local.product.getFormattedValue('salePrice')
    
    Live Price | The live price looks at both the salePrice and currentAccountPrice to figure out which is better and display that.  This is what the customer will see in their cart once the item has been added so it should be used as the primary price to display
    local.product.getFormattedValue('livePrice')
--->

<!---Add To Cart Example 1 (Simple Sku Dropdown, No Inventory)--->
<cfimport prefix="sw" taglib="../../../tags" />
<cfset local.product = $.slatwall.getProduct() />
<cfoutput>
<div class="card">
	<div class="card-body">
    	
    	<!--- Price --->
        <cfif local.product.getListPrice() GT local.product.getLivePrice()>
		    <s class="float-right small">#local.product.getFormattedValue('listPrice')#</s>
		</cfif>

		<h3>#local.product.getFormattedValue('livePrice')#</h3>
    
    	<!--- Start of form, note that the action can be set to whatever URL you would like the user to end up on. --->
    	<form action="?productID=#local.product.getProductID()#&s=1" method="post">
    		<input type="hidden" name="slatAction" value="public:cart.addOrderItem" />
    
    		<cfset skus = local.product.getSkus(sorted=true, fetchOptions=true) />
    
    		<!--- Check to see if there are more than 1 skus, if so then display the options dropdown --->
    		<cfif arrayLen(skus) gt 1>
    
    			<!--- Sku Selector --->
    			<div class="form-group">
    				<label for="options">Select Options</label>

					<!--- Sku Select Dropdown --->
					<select name="skuID" class="form-control" required>

						<!--- Blank option to force user to select (this is optional) --->
						<option value="" selected>Select Option</option>

						<!--- Loop over the skus to display options --->
						<cfloop array="#skus#" index="sku">
							<!--- This provides an option for each sku, with the 'displayOptions' method to show the optionGroup / option names --->
							<option value="#sku.getSkuID()#">#sku.displayOptions()#</option>
						</cfloop>

					</select>
					<sw:ErrorDisplay object="#$.slatwall.cart().getProcessObject('addOrderItem')#" displayType="label" for="skuID" errorName="sku" />

      			</div>
    
    		<!--- If there are only 1 skus, then add a hidden field --->
    		<cfelse>
    			<input type="hidden" name="skuID" value="#local.product.getDefaultSku().getSkuID()#" />
    		</cfif>
    
    		<div class="form-group">
    		    <div class="row">
    		        <div class="col-md-6">
    		            <!--- Quantity --->
    		            <div class="row">
    		                <div class="col-md-6">
    		                    <label for="quantity">Quantity</label>
    		                </div>
    		                <div class="col-md-5">
    		                    <sw:FormField type="text" valueObject="#$.slatwall.cart().getProcessObject('addOrderItem')#" valueObjectProperty="quantity" class="form-control" />
    		                </div>
    		            </div>
    			    </div>
    			    <div class="col-md-6">
    			        <!--- Add to Cart Button --->
    		            <button type="submit" class="btn btn-primary btn-block">Add to Cart</button>
    			    </div>
    			</div>
    			<sw:ErrorDisplay object="#$.slatwall.cart().getProcessObject('addOrderItem')#"  displayType="label" errorName="quantity" />
      		</div>
    
    		
    	</form>
    	
    	<!--- Product Code --->
		<small class="text-muted float-sm-right">Product Code #local.product.getProductCode()#</small>
    </div>
</div>
</cfoutput>