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
		
		<!--- START SHOPPING CART EXAMPLE 1 --->
		<div class="row">
			<div class="span12">
				<h3>Shopping Cart Example 1</h3>
			</div>
		</div>
		
		<!--- Verify that there are items in the cart --->
		<cfif arrayLen($.slatwall.cart().getOrderItems())>
			<div class="row">
				<!--- START: CART DETAIL --->
				<div class="span8">
					<h5>Shopping Cart Details</h5>
					
					<!--- Update Cart Form --->
					<form action="?s=1" method="post">
						<!--- This slatAction is what tells the form submit to process an update to the cart --->
						<input type="hidden" name="slatAction" value="public:cart.update" />
						
						<!--- Cart Data --->
						<table class="table">
							
							<!--- Header --->
							<tr>
								<th>Product</td>
								<th>Details</th>
								<th>Price</th>
								<th>QTY</th>
								<th>Ext. Price</th>
								<th>Discount</th>
								<th>Total</th>
								<th>&nbsp;</th>
							</tr>
							
							<!--- Order Items --->
							<cfset loopIndex=0 />
							<cfloop array="#$.slatwall.cart().getOrderItems()#" index="orderItem">
								<cfset loopIndex++ />
								<!--- This hidden field ties any other form elements below to this orderItem by defining the orderItemID allong with this loopIndex that is included on all other form elements --->
								<input type="hidden" class="span1" name="orderItems[#loopIndex#].orderItemID" value="#orderItem.getOrderItemID()#" />
								
								<tr>
									<!--- Display Product Name --->
									<td><a href="#orderItem.getSku().getProduct().getProductURL()#">#orderItem.getSku().getProduct().getTitle()#</a></td>
									
									<!--- This is a list of whatever options are there for this product --->
									<td>#orderItem.getSku().displayOptions()#</td>
									
									<!--- This displays the price of the item in the cart --->
									<td>#orderItem.getFormattedValue('price')#</td>
									
									<!--- Allows for quantity to be updated.  Note if this gets set to 0 the quantity will automatically be removed --->
									<td>
										<input type="text" class="span1" name="orderItems[#loopIndex#].quantity" value="#htmlEditFormat( orderItem.getQuantity() )#" />
										<sw:ErrorDisplay object="#orderItem#" errorName="quantity" />
									</td>
									
									<!--- Display the Price X Quantity --->
									<td>#orderItem.getFormattedValue('extendedPrice')#</td>
									
									<!--- Show any discounts that have been applied --->
									<td>#orderItem.getFormattedValue('discountAmount')#</td>
									
									<!--- Show the Price X Quantity - Discounts, basically this is what the end user is going to be charged for this item --->
									<td>#orderItem.getFormattedValue('extendedPriceAfterDiscount')#</td>
									
									<!--- Remove action to clear this line item from the cart --->
									<td><a href="?slatAction=public:cart.removeOrderItem&orderItemID=#orderItem.getOrderItemID()#" class="btn" title="Remove Item"><i class="icon-remove" /></a></td>
								</tr>
							</cfloop>
							
						</table>
						
						<!--- START: Custom "Order" Attribute Sets --->
						<cfset orderAttributeSets = $.slatwall.cart().getAssignedAttributeSetSmartList().getRecords() />
						
						<!--- Only display if there are attribute sets assigned --->
						<cfif arrayLen(orderAttributeSets)>
							
							<hr />
							
							<!--- Loop over all of the attribute sets --->
							<cfloop array="#orderAttributeSets#" index="attributeSet">
								
								<!--- display the attribute set name --->
								<h5>#attributeSet.getAttributeSetName()#</h5>
								
								<!--- Loop over all of the attributes --->
								<cfloop array="#attributeSet.getAttributes()#" index="attribute">
									
									<!--- Pull this attribute value object out of the order entity ---> 
									<cfset thisAttributeValueObject = $.slatwall.cart().getAttributeValue(attribute.getAttributeCode(), true) />
									
									<cfif isObject(thisAttributeValueObject)>
										<!--- Display the attribute value --->
										<div class="control-group">
											
					    					<label class="control-label" for="rating">#attribute.getAttributeName()#</label>
					    					<div class="controls">
					    						
												<sw:FormField type="#attribute.getFormFieldType()#" name="#attribute.getAttributeCode()#" valueObject="#thisAttributeValueObject#" valueObjectProperty="attributeValue" valueOptions="#thisAttributeValueObject.getAttributeValueOptions()#" class="span4" />
												<sw:ErrorDisplay object="#thisAttributeValueObject#" errorName="password" />
												
					    					</div>
					  					</div>
					  				<cfelse>
					  					<!--- Display the custom property --->
					  					<div class="control-group">
											
					    					<label class="control-label" for="rating">#attribute.getAttributeName()#</label>
					    					<div class="controls">
					    						
						  						<sw:FormField type="#attribute.getFormFieldType()#" valueObject="#$.slatwall.cart()#" valueObjectProperty="#attribute.getAttributeCode()#" valueOptions="#attribute.getAttributeOptionsOptions()#" class="span4" />
												<sw:ErrorDisplay object="#$.slatwall.cart()#" errorName="#attribute.getAttributeCode()#" />
												
					    					</div>
					  					</div>
					  				</cfif>
									
								</cfloop>
								
								<hr />
								
							</cfloop>
						</cfif>	
						<!--- END: Custom "Order" Attribute Sets --->
						
						<!--- Action Buttons --->
						<div class="control-group pull-right">
							<div class="controls">
								<!--- Update Cart Button, just submits the form --->
								<button type="submit" class="btn">Update Cart</button>
								
								<!--- Clear Cart Button, links to a slatAction that clears the cart --->
								<a href="?slatAction=public:cart.clear" class="btn">Clear Cart</a>
								
								<!--- Checkout, is just a simple link to the checkout page --->
								<a href="checkout.cfm" class="btn">Checkout</a>
							</div>
						</div>
						
					</form>
					<!--- End: Update Cart Form --->
						
				</div>
				<!--- END: CART DETAIL --->
				
				<!--- START: ORDER SUMMARY --->
				<div class="span4">
					<h5>Order Summary</h5>
					
					<table class="table table-condensed">
						<!--- The Subtotal is all of the orderItems before any discounts are applied --->
						<tr>
							<td>Subtotal</td>
							<td>#$.slatwall.cart().getFormattedValue('subtotal')#</td>
						</tr>
						
						<!--- Item Discounts --->
						<cfif $.slatwall.cart().getItemDiscountAmountTotal() gt 0>
							<tr>
								<td>Item Discounts</td>
								<td>#$.slatwall.cart().getFormattedValue('itemDiscountAmountTotal')#</td>
							</tr>
							<!--- Subtotal After Discounts --->
							<tr>
								<td>Subtotal After Discounts</td>
								<td>#$.slatwall.cart().getFormattedValue('subTotalAfterItemDiscounts')#</td>
							</tr>
						</cfif>
						
						<!--- This displays a delivery cost, some times it might make sense to do a conditional here and check if the amount is > 0, then display otherwise show something like TBD --->
						<tr>
							<td>Delivery Costs</td>
							<td>#$.slatwall.cart().getFormattedValue('fulfillmentTotal')#</td>
						</tr>
						
						<!--- Delivery Discounts --->
						<cfif $.slatwall.cart().getFulfillmentDiscountAmountTotal() gt 0>
							
							<tr>
								<td>Delivery Discounts</td>
								<td>#$.slatwall.cart().getFormattedValue('fulfillmentDiscountAmountTotal')#</td>
							</tr>
							<!--- Delivery after Discounts --->
							<tr>
								<td>Delivery After Discounts</td>
								<td>#$.slatwall.cart().getFormattedValue('fulfillmentChargeAfterDiscountTotal')#</td>
							</tr>
						</cfif>
						
						<!--- Displays the total tax that was calculated for this order --->
						<tr>
							<td>Tax</td>
							<td>#$.slatwall.cart().getFormattedValue('taxTotal')#</td>
						</tr>
						
						<!--- Displays any order discounts --->
						<cfif $.slatwall.cart().getOrderDiscountAmountTotal() gt 0>
							<tr>
								<td>Additional Order Discounts</td>
								<td>#$.slatwall.cart().getFormattedValue('orderDiscountAmountTotal')#</td>
							</tr>
						</cfif>
						
						<!--- If there were discounts they would be displayed here --->
						<cfif $.slatwall.cart().getDiscountTotal() gt 0>
							<tr>
								<td>Total Discounts</td>
								<td>#$.slatwall.cart().getFormattedValue('discountTotal')#</td>
							</tr>
						</cfif>
						<!--- The total is the finished amount that the customer can expect to pay --->
						<tr>
							<td><strong>Total</strong></td>
							<td><strong>#$.slatwall.cart().getFormattedValue('total')#</strong></td>
						</tr>
					</table>
				</div>
				<!--- END: ORDER SUMMARY --->
					
			</div>
			
			<div class="row">
				<!--- START: PROMO CODES --->
				<div class="span4">
					<div class="well">
						<h5>Promo Codes</h5>
						
						<!--- Start: Existing promo codes --->
						
						<cfif arrayLen($.slatwall.cart().getPromotionCodes())><!--- Check to see if there are any existing promotion codes, before we display anything --->
							
							<table class="table">
								
								<!--- Loop over the existing promotion codes. --->
								<cfloop array="#$.slatwall.cart().getPromotionCodes()#" index="promotionCode">
									<!---[ DEVELOPER NOTES ]														
										 																			
										The 'promotionCode' index of this loop is the full entity with ID, ect...	
										Not to be confused with the string value of the promotion code iteself,		
										for that call promotionCode.getPromotionCode() as seen below				
																													
									--->
									<tr>
										<td>#promotionCode.getPromotionCode()#</td>
										<td><a href="?slatAction=public:cart.removePromotionCode&promotionCodeID=#promotionCode.getPromotionCodeID()#" class="btn" title="Remove Promotion Code"><i class="icon-remove" /></a></td>
									</tr>
								</cfloop>
								
							</table>
							
						</cfif>
						<!--- End: Existing promo codes --->
								
						<!--- Start: Add Promo Code Form --->
						<form action="?s=1" method="post">
							<!--- This hidden field tells Slatwall to add the promotionCode entered to the cart --->
							<input type="hidden" name="slatAction" value="public:cart.addPromotionCode" />
							
							<cfset addPromotionCodeObj = $.slatwall.getCart().getProcessObject('addPromotionCode') />
							
							<!--- Promotion Code Input Field --->
							<div class="control-group">
								<div class="controls">
									
									<sw:FormField type="text" name="promotionCode" valueObject="#addPromotionCodeObj#" valueObjectProperty="promotionCode" fieldAttributes=' placeholder="Enter Promo Code Here."' />
									<sw:ErrorDisplay object="#addPromotionCodeObj#" errorName="promotionCode" />
									
								</div>
							</div>
							
							<!--- Add Promo Code Button --->
							<div class="control-group">
								<div class="controls">
									<button type="submit" class="btn">Add Promo Code</button>
								</div>
							</div>
						</form>
						<!--- End: Add Promo Code Form --->
					</div>
				</div>
				<!--- END: PROMO CODES --->
			</div>
		<!--- No Items In Cart --->
		<cfelse>
			<div class="row">
				<div class="span12">
					<p>There are no items in your cart.</p>
				</div>
			</div>
		</cfif>
			
		
		<!--- END SHOPPING CART EXAMPLE 1 --->
		
		<hr />
		
	</div>
</cfoutput>
<cfinclude template="_slatwall-footer.cfm" />
