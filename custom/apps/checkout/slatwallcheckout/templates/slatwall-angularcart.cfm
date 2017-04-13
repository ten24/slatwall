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

	<div class="container">
		
		<!--- START SHOPPING CART EXAMPLE 1 --->
		<div class="row">
			<div class="col-xs-12">
				<h3>Shopping Cart</h3>
			</div>
		</div>
		<div class="panel panel-default panel-body" ng-if="!slatwall.hasAccount() && !slatwall.loadingThisRequest('getAccount')" ng-cloak>
            <h3 ng-show="slatwall.isCreatingAccount()">Create An Account</h3>
            <h3 ng-show="slatwall.isSigningIn()">Sign in to your Account</h3>
            <div class="details" ng-show="slatwall.isCreatingAccount()">
                <p>Already have an account?  <a href="##" class="loginCreateToggle" ng-click="slatwall.showCreateAccount = !slatwall.showCreateAccount">Sign in</a></p>
				<swf-directive partial-name="createaccount"></swf-directive>
			</div>

            <div class="details" ng-show="slatwall.isSigningIn()">
				<swf-directive partial-name="login"></swf-directive>
                <p>Need an account? <a href="##" class="loginCreateToggle" ng-click="slatwall.showCreateAccount = !slatwall.showCreateAccount; slatwall.showForgotPassword = false">Create Account</a></p>
			</div>
        </div>
		<!--- Verify that there are items in the cart --->
		<div ng-if="slatwall.hasAccount() && slatwall.cartHasNoItems()" ng-cloak>
			<div class="alert alert-warning">There are no items in your cart.</div>
		</div>
		<div ng-if="slatwall.hasAccountAndCartItems()" ng-cloak>
			<div class="row">
				<!--- START: CART DETAIL --->
				<div class="col-sm-12">
					<h5>Shopping Cart Details</h5>
					
					<!--- Update Cart Form --->
					
					<!--- Cart Data --->
					<table class="table">
						
						<!--- Header --->
						<tr>
							<th></th>
							<th>Product</th>
							<th>Details</th>
							<th>Price</th>
							<th>QTY</th>
							<th>Ext. Price</th>
							<th>Discount</th>
							<th>Total</th>
							<th>&nbsp;</th>
						</tr>
						
						<!--- Order Items --->
						<tr ng-repeat="orderItem in slatwall.cart.orderItems track by $index">
							<!--- Product Image --->
							<td>
								<div ng-init="slatwall.getResizedImageByProfileName('large', orderItem.sku.skuID)">
									<img ng-src="{{slatwall.imagePath[orderItem.sku.skuID]}}" class="img-responsive center-block" ng-if="!slatwall.loadingThisRequest('getResizedImageByProfileName',{skuIds:orderItem.sku.skuID})">
									<span ng-if="slatwall.loadingThisRequest('getResizedImageByProfileName',{skuIds:orderItem.sku.skuID})">
										<i class="fa fa-refresh fa-spin fa-lg fa-fw"></i>
									</span>
								</div>
							</td>
							<!--- Display Product Name --->
							<td><a href="{{orderItem.sku.product.urlTitle}}">{{orderItem.sku.product.productName}}</a></td>
							
							<!--- This is a list of whatever options are there for this product --->
							<td>{{orderItem.sku.displayOptions}}</td>
							
							<!--- This displays the price of the item in the cart --->
							<td>{{orderItem.price | currency}}</td>
							
							<!--- Allows for quantity to be updated.  Note if this gets set to 0 the quantity will automatically be removed --->
							<td class="row">
							    <!--- <div class="col-sm-3">
							    	<button class="pull-right" ng-click="slatwall.incrementItemQuantity(orderItem, -1)">
						    			<i class="fa fa-chevron-left"></i>
						    		</button>
							    </div>
							    <div class="col-sm-6">
									<input type="text" ng-model="orderItem.quantity" ng-model-options="{debounce:500}" ng-change="slatwall.updateOrderItemQuantity(orderItem)" ng-show="!slatwall.loadingThisRequest('updateOrderItemQuantity', {'orderItem.orderItemID':orderItem.orderItemID})">
									<span ng-show="slatwall.loadingThisRequest('updateOrderItemQuantity', {'orderItem.orderItemID':orderItem.orderItemID})">
										<i class="fa fa-spinner fa-pulse fa-fw"></i>
									</span>

						        </div>
						        <div class="col-sm-3">
						        	<button class="pull-left" ng-click="slatwall.incrementItemQuantity(orderItem)">
						    			<i class="fa fa-chevron-right"></i>
						    		</button>
						        </div> --->
						        <sw-form
						        	data-object="orderItem"
						        	data-name="orderItemQuantity"
						        	data-event-announcers="keyup"
						        	data-action="updateOrderItemQuantity">
						        	<swf-property-display
						        		data-name="quantity"
						        		data-property-identifier="quantity"
						        		data-label-text=""
						        		data-field-type="text"
						        		data-event-listeners="{orderItemQuantitykeyup:slatwall.binder($parent.swForm, $parent.swForm.submit, null)}"
						        	></swf-property-display>
						        	<swf-property-display
						        		data-name="quantity"
						        		data-property-identifier="orderItemID"
						        		data-label-text=""
						        		data-field-type="text"
						        		data-class="hidden"
						        	></swf-property-display>
					        	</sw-form>

							</td>
							
							<!--- Display the Price X Quantity --->
							<td>{{orderItem.extendedPrice | currency}}</td>
							
							<!--- Show any discounts that have been applied --->
							<td>{{orderItem.discountAmount | currency}}</td>
							
							<!--- Show the Price X Quantity - Discounts, basically this is what the end user is going to be charged for this item --->
							<td>{{orderItem.extendedPriceAfterDiscount | currency}}</td>
							
							<!--- Remove action to clear this line item from the cart ---> <!--- Change this to swActionCaller --->
							<td><a role="button" ng-click="slatwall.doAction('removeOrderItem',{orderItemID:orderItem.orderItemID})" class="btn" title="Remove Item">
								<span class="fa-lg" ng-show="!slatwall.loadingThisRequest('removeOrderItem', {orderItemID:orderItem.orderItemID})">
									<i class="fa fa-trash-o fa-fw"></i>
								</span>
								<span class="fa-lg" ng-show="slatwall.loadingThisRequest('removeOrderItem', {orderItemID:orderItem.orderItemID})">
									<i class="fa fa-spinner fa-pulse fa-fw""></i>
								</span>
							</a></td>
						</tr>
						
					</table>
					
					<!--- START: Custom "Order" Attribute Sets --->
					<!--- <cfset orderAttributeSets = slatwall.cart.getAssignedAttributeSetSmartList().getRecords() />
					
					<!--- Only display if there are attribute sets assigned --->
					<cfif arrayLen(orderAttributeSets)>
						
						<hr />
						
						<!--- Loop over all of the attribute sets --->
						<cfloop array="#orderAttributeSets#" index="attributeSet">
							
							<!--- display the attribute set name --->
							<h5>#attributeSet.getAttributeSetName()}}</h5>
							
							<!--- Loop over all of the attributes --->
							<cfloop array="#attributeSet.getAttributes()}}" index="attribute">
								
								<!--- Pull this attribute value object out of the order entity ---> 
								<cfset thisAttributeValueObject = slatwall.cart.getAttributeValue(attribute.getAttributeCode(), true) />
								
								<cfif isObject(thisAttributeValueObject)>
									<!--- Display the attribute value --->
									<div class="control-group">
										
				    					<label class="control-label" for="rating">#attribute.getAttributeName()}}</label>
				    					<div class="controls">
				    						
											<sw:FormField type="#attribute.getFormFieldType()}}" name="#attribute.getAttributeCode()}}" valueObject="#thisAttributeValueObject#" valueObjectProperty="attributeValue" valueOptions="#thisAttributeValueObject.getAttributeValueOptions()}}" class="span4" />
											<sw:ErrorDisplay object="#thisAttributeValueObject#" errorName="password" />
											
				    					</div>
				  					</div>
				  				<cfelse>
				  					<!--- Display the custom property --->
				  					<div class="control-group">
										
				    					<label class="control-label" for="rating">#attribute.getAttributeName()}}</label>
				    					<div class="controls">
				    						
					  						<sw:FormField type="#attribute.getFormFieldType()}}" valueObject="{{slatwall.cart#" valueObjectProperty="#attribute.getAttributeCode()}}" valueOptions="#attribute.getAttributeOptionsOptions()}}" class="span4" />
											<sw:ErrorDisplay object="{{slatwall.cart#" errorName="#attribute.getAttributeCode()}}" />
											
				    					</div>
				  					</div>
				  				</cfif>
								
							</cfloop>
							
							<hr />
							
						</cfloop>
					</cfif>	 --->
					<!--- END: Custom "Order" Attribute Sets --->
					
					<!--- Action Buttons --->
					<div class="control-group pull-right">
						<div class="controls">
							
							<!--- Clear Cart Button, links to a slatAction that clears the cart --->
							<a role="button" ng-click="slatwall.doAction('clearOrder',{})" class="btn btn-default">Clear Cart</a>
							
							<!--- Checkout, is just a simple link to the checkout page --->
							<!--- fix somehow --->
							<a href="/checkout" class="btn btn-default">Checkout</a>
						</div>
					</div>
					<!--- End: Update Cart Form --->
						
				</div>
				<!--- END: CART DETAIL --->
				
				<!--- START: ORDER SUMMARY --->
				<div class="col-sm-6">
					<div class="well">
						<h4>Promotion Code</h4>
						<swf-directive partial-name="promopartial"></swf-directive>
					</div>
				</div>
				<div class="col-sm-6">
					<h4>Order Summary</h4>
					
					<table class="table table-condensed">
						<!--- The Subtotal is all of the orderItems before any discounts are applied --->
						<tr>
							<td>Subtotal</td>
							<td>{{slatwall.cart.subtotal | currency}}</td>
						</tr>
						
						<!--- Item Discounts --->
						<tr ng-if="slatwall.cart.itemDiscountAmountTotal">
							<td>Item Discounts</td>
							<td>{{slatwall.cart.itemDiscountAmountTotal | currency}}</td>
						</tr>
						<!--- Subtotal After Discounts --->
						<tr ng-if="slatwall.cart.itemDiscountAmountTotal">
							<td>Subtotal After Discounts</td>
							<td>{{slatwall.cart.subTotalAfterItemDiscounts | currency}}</td>
						</tr>
						
						<!--- This displays a delivery cost, some times it might make sense to do a conditional here and check if the amount is > 0, then display otherwise show something like TBD --->
						<tr>
							<td>Delivery Costs</td>
							<td>{{slatwall.cart.fulfillmentTotal | currency}}</td>
						</tr>
						
						<!--- Delivery Discounts --->
						<tr ng-if="slatwall.cart.fulfillmentDiscountAmountTotal">
							<td>Delivery Discounts</td>
							<td>{{slatwall.cart.fulfillmentDiscountAmountTotal | currency}}</td>
						</tr>
						<!--- Delivery after Discounts --->
						<tr ng-if="slatwall.cart.fulfillmentDiscountAmountTotal">
							<td>Delivery After Discounts</td>
							<td>{{slatwall.cart.fulfillmentChargeAfterDiscountTotal | currency}}</td>
						</tr>
						
						<!--- Displays the total tax that was calculated for this order --->
						<tr>
							<td>Tax</td>
							<td>{{slatwall.cart.taxTotal | currency}}</td>
						</tr>
						
						<!--- Displays any order discounts --->
						<tr ng-if="slatwall.cart.orderDiscountAmountTotal">
							<td>Additional Order Discounts</td>
							<td>{{slatwall.cart.orderDiscountAmountTotal | currency}}</td>
						</tr>
						
						<!--- If there were discounts they would be displayed here --->
						<tr ng-if="slatwall.cart.discountTotal">
							<td>Total Discounts</td>
							<td>{{slatwall.cart.discountTotal | currency}}</td>
						</tr>

						<!--- The total is the finished amount that the customer can expect to pay --->
						<tr>
							<td><strong>Total</strong></td>
							<td><strong>{{slatwall.cart.calculatedTotal | currency}}</strong></td>
						</tr>
					</table>
				</div>
				<!--- END: ORDER SUMMARY --->
					
			</div>
			
			<div class="row">
				<!--- START: PROMO CODES --->
				
				<!--- END: PROMO CODES --->
			</div>
		<!--- END SHOPPING CART EXAMPLE 1 --->
		
		<hr />
		
	</div>

<cfinclude template="_slatwall-footer.cfm" />
