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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfoutput>
	<div class="svoproductdetail">
		<div class="image">
			<a href="#$.slatwall.Product().getImagePath()#" target="_blank">#$.slatwall.Product().getImage(size="m")#</a>
		</div>
		<dl>
			<swa:SlatwallPropertyDisplay object="#$.slatwall.Product()#" property="productCode">
			<swa:SlatwallPropertyDisplay object="#$.slatwall.Product()#" property="livePrice">
			<swa:SlatwallPropertyDisplay object="#$.slatwall.Product()#" property="productDescription">
		</dl>
		<form action="#$.createHREF(filename=$.slatwall.setting('globalPageShoppingCart'),queryString='nocache=1')#" method="post">
			<input type="hidden" name="productID" value="#$.slatwall.Product().getProductID()#" />
			<input type="hidden" name="slatAction" value="frontend:cart.addItem" />
			<cfset local.fulfillmentMethodSkus = {} />
			<!--- Product Options --->
			<cfif arrayLen($.slatwall.product().getSkus(true)) eq 1>
				<input type="hidden" name="skuID" value="#$.slatwall.Product().getSkus()[1].getSkuID()#" />
			<cfelse>
				<dl>
					<dt>Select Option</dt>
					<dd>
						<select name="skuID">
							<cfset local.skus = $.slatwall.product().getSkus(sorted=true, fetchOptions=true) />
							<cfloop array="#local.skus#" index="local.sku">
								<option value="#local.sku.getSkuID()#">#local.sku.displayOptions()#</option>
								<cfloop list="#local.sku.setting('skuEligibleFulfillmentMethods')#" index="local.fulfillmentMethodID">
									<cfif structKeyExists(fulfillmentMethodSkus,local.fulfillmentMethodID)>
										<cfset fulfillmentMethodSkus[local.fulfillmentMethodID] = listAppend(fulfillmentMethodSkus[local.fulfillmentMethodID],local.sku.getSkuID()) />
									<cfelse>
										<cfset fulfillmentMethodSkus[local.fulfillmentMethodID] = local.sku.getSkuID() />
									</cfif>
								</cfloop>
							</cfloop>
						</select>
					</dd>
				</dl>
			</cfif>
			<!--- END: Product Options --->
			
			<!--- START: Sku Price --->
			<cfif !isNull($.slatwall.product('defaultSku').getUserDefinedPriceFlag()) AND $.slatwall.product('defaultSku').getUserDefinedPriceFlag()>
				<input type="text" name="price" value="" />
			</cfif>
			
			<!--- Fulfillment Options --->
			<cfif listLen(structKeyList(local.fulfillmentMethodSkus)) GT 1>
				<cfset local.fulfillmentMethodSmartList = $.slatwall.getService("fulfillmentService").getFulfillmentMethodSmartList() />
				<cfset local.fulfillmentMethodSmartList.addInFilter('fulfillmentMethodID', structKeyList(local.fulfillmentMethodSkus)) />
				<cfset local.fulfillmentMethodSmartList.addOrder('sortOrder|ASC') />
				<cfset local.fulfillmentMethods = local.fulfillmentMethodSmartList.getRecords() />
				<dl>
					<dt>Select Fulfillment Option</dt>
					<dd>
						<select name="fulfillmentMethodID">
							<cfloop array="#local.fulfillmentMethods#" index="local.fulfillmentMethod">
								<option value="#local.fulfillmentMethod.getFulfillmentMethodID()#" skuIDs="#local.fulfillmentMethodSkus[local.fulfillmentMethod.getFulfillmentMethodID()]#">#local.fulfillmentMethod.getFulfillmentMethodName()#</option>
							</cfloop>
						</select>
					</dd>
				</dl>
			</cfif>	
			
			<!--- END: Fulfillment Options --->
			
			<!--- Product Customizations --->
			<cfset customAttributeSetTypeArray = ['astProductCustomization','astOrderItem'] />
			<cfloop array="#$.slatwall.product().getAttributeSets(customAttributeSetTypeArray)#" index="local.customizationAttributeSet">
				<div class="productCustomizationSet #lcase(replace(local.customizationAttributeSet.getAttributeSetName(), ' ', '', 'all'))#">
					<h5>#local.customizationAttributeSet.getAttributeSetName()#</h5>
					<dl>
						<swa:SlatwallAttributeSetDisplay attributeSet="#local.customizationAttributeSet#" entity="#$.slatwall.product()#" edit="true" />
					</dl>
				</div>
			</cfloop>
			<!--- END: Product Customizations --->
				
			<label for="productQuantity">Quantity: </label><input type="text" name="quantity" value="1" size="2" id="productQuantity" />
			<button type="submit">Add To Cart</button>
		</form>
		<div class="reviews">
			<cfloop array="#$.slatwall.product().getProductReviews()#" index="review">
				<dl>
					<dt class="title">#review.getReviewTitle()#</dt>
					<dt class="name">#review.getReviewerName()#</dt>
					<dd class="rating">#review.getRating()#</dd>
					<dd class="review">#review.getReview()#</dd>
				</dl>
			</cfloop>
			<form action="?nocache=1" method="post">
				<input type="hidden" name="slatAction" value="frontend:product.addReview" />
				<input type="hidden" name="product.productID" value="#$.slatwall.product('productID')#" />
				<dl>
					<dt>Name</dt>
					<dd><input type="text" name="reviewerName" value="#$.slatwall.account('fullname')#" /></dd>
					<dt>Rating</dt>
					<dd>
						<select name="rating">
							<option value="5" selected="selected">5</option>
							<option value="4">4</option>
							<option value="3">3</option>
							<option value="2">2</option>
							<option value="1">1</option>
						</select>
					</dd>
					<dt>Title</dt>
					<dd><input type="text" name="reviewTitle" value="" /></dd>
					<dt>Review</dt>
					<dd><textarea name="review"></textarea></dd>
				</dl>
				<button type="submit">Add Review</button>
			</form>
		</div>
	</div>
</cfoutput>

