<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
    <div class="span4">
        <!--- START: ADD TO CART EXAMPLE 2 --->
        <h5>Add To Cart Form 2 (Split Option Groups, Default Sku Selected, No Inventory Check)</h5>
        
        <!--- Start of form, note that the action can be set to whatever URL you would like the user to end up on. --->
        <form action="?productID=#local.product.getProductID()#&s=1" method="post">
        	<input type="hidden" name="slatAction" value="public:cart.addOrderItem" />
        	<input type="hidden" name="productID" value="#local.product.getProductID()#" />
        
        	<!--- First we get all the option groups this product uses --->
        	<cfset optionGroupsArr = local.product.getOptionGroups() />
        	<cfset defaultSelectedOptions = local.product.getDefaultSku().getOptionsIDList() />
        
        	<!--- Loop over all options groups --->
        	<cfloop array="#optionGroupsArr#" index="optionGroup">
        
        		<!--- Then we get the options for used by each option group for this product --->
        		<cfset optionsArr = local.product.getOptionsByOptionGroup( optionGroup.getOptionGroupID() ) />
        
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
</cfoutput>