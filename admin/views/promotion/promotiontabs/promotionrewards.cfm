<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfoutput>
	<cfif arrayLen(rc.promotion.getPromotionRewards()) gt 0>
	<table id="promotionRewardTable" class="listing-grid">
		<thead>
			<tr>
				<th>#rc.$.Slatwall.rbKey("entity.promotionReward.rewardType")#</th>
				<th class="varWidth">#rc.$.Slatwall.rbKey("admin.promotion.promotionReward.item")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.promotionRewardProduct.itemRewardQuantity")#</th>
				<th>#rc.$.Slatwall.rbKey("admin.promotion.edit.discount")#</th>
				<cfif rc.edit>
				  <th class="administration">&nbsp;</th>
				</cfif>
			</tr>
		</thead>
		<tbody>
		<cfloop from="1" to="#arrayLen(rc.promotion.getPromotionRewards())#" index="local.promotionRewardCount">
			<cfset local.thisPromotionReward = rc.promotion.getPromotionRewards()[local.promotionRewardCount] />
			<tr id="PromotionReward#local.promotionRewardCount#" class="promotionRewardRow<cfif local.promotionRewardCount mod 2 eq 1> alt</cfif>">
				<input type="hidden" name="promotionRewards[#local.promotionRewardCount#].promotionRewardID" value="#local.thisPromotionReward.getPromotionRewardID()#" />
				<td class="alignLeft">
					#$.Slatwall.rbKey('entity.promotionReward.promotionRewardType.' & local.thisPromotionReward.getRewardType())#
				</td>
				<td class="varWidth">
					<cfset local.itemName = "" />
					<cfif local.thisPromotionReward.getRewardType() eq "product">
						<cfif arrayLen(local.thisPromotionReward.getSkus())>
							<cfset local.itemName = arrayLen(local.thisPromotionReward.getSkus()) gt 1 ? "Skus: " : "Sku: " />
							<cfset local.itemName &= local.thisPromotionReward.displaySkuCodes() />		
						<cfelseif arrayLen(local.thisPromotionReward.getProducts())>
							<cfset local.itemName = local.thisPromotionReward.displayProductNames() />
						<cfelseif arrayLen(local.thisPromotionReward.getProductTypes())>
							<cfset local.itemName = arrayLen(local.thisPromotionReward.getProductTypes()) gt 1 ? "#$.Slatwall.rbKey('admin.product.product.productTypes')#: " : "#$.Slatwall.rbKey('entity.product.productType')#: " />
							<cfset local.itemName &= local.thisPromotionReward.displayProductTypeNames() />
						<cfelse>
							<cfset local.itemName = $.Slatwall.rbKey("define.all") />
						</cfif>
					<cfelseif local.thisPromotionReward.getRewardType() eq "shipping">
						<cfif arrayLen(thisPromotionReward.getShippingMethods())>
							<cfset local.itemName = thisPromotionReward.displayShippingMethodNames() />
						<cfelse>
							<cfset local.itemName = $.Slatwall.rbKey("define.all") />
						</cfif>
					</cfif>
					#local.itemName#
				</td>
				<td>
					<cfif local.thisPromotionReward.getRewardType() eq "product">
						#local.thisPromotionReward.getItemRewardQuantity()#
					</cfif>
				</td>
				<td>
					<cfif local.thisPromotionReward.getRewardType() eq "product">
						<cfif !isNull(local.thisPromotionReward.getItemPercentageOff()) && isNumeric(local.thisPromotionReward.getItemPercentageOff())>
							#local.thisPromotionReward.getItemPercentageOff()#&##37; #$.Slatwall.rbKey("admin.promotion.discount.off")#
						<cfelseif !isNull(local.thisPromotionReward.getItemAmountOff()) && isNumeric(local.thisPromotionReward.getItemAmountOff())>
							#local.thisPromotionReward.getFormattedValue('itemAmountOff', 'currency')# #$.Slatwall.rbKey("admin.promotion.discount.off")#
						<cfelseif !isNull(local.thisPromotionReward.getItemAmount()) && isNumeric(local.thisPromotionReward.getItemAmount())>
							#local.thisPromotionReward.getFormattedValue('itemAmount', 'currency')# #$.Slatwall.rbKey("admin.promotion.discount.price")#
						</cfif>
					<cfelseif local.thisPromotionReward.getRewardType() eq "shipping">
						<cfif !isNull(local.thisPromotionReward.getShippingPercentageOff()) && isNumeric(local.thisPromotionReward.getShippingPercentageOff())>
							#local.thisPromotionReward.getShippingPercentageOff()#&##37; #$.Slatwall.rbKey("admin.promotion.discount.off")#
						<cfelseif !isNull(local.thisPromotionReward.getShippingAmountOff()) && isNumeric(local.thisPromotionReward.getShippingAmountOff())>
							#local.thisPromotionReward.getFormattedValue('shippingAmountOff', 'currency')# #$.Slatwall.rbKey("admin.promotion.discount.off")#
						<cfelseif !isNull(local.thisPromotionReward.getShippingAmount()) && isNumeric(local.thisPromotionReward.getShippingAmount())>
							#local.thisPromotionReward.getFormattedValue('shippingAmount', 'currency')# #$.Slatwall.rbKey("admin.promotion.discount.price")#
						</cfif>
					</cfif>		
				</td>
				<cfif rc.edit>
					<td class="administration">
						<cfif !rc.promotion.isNew() && !local.thisPromotionReward.isNew()>
							<cfset local.disabledText = "" />
							<ul class="two">
								<li class="adminpromotioneditPromotionReward edit">
									<a href="##" class="editPromotionReward" id="edit#local.thisPromotionReward.getPromotionRewardID()#">#$.Slatwall.rbKey('admin.promotion.editPromotionReward')#</a>
								</li>
								<cf_SlatwallActionCaller action="admin:promotion.deletePromotionReward" querystring="promotionRewardID=#local.thisPromotionReward.getPromotionRewardID()#" class="delete" type="list" confirmrequired="true">
							</ul>
						</cfif>
					</td>
				</cfif>
			</tr>
			<cf_SlatwallErrorDisplay object="#local.thisPromotionReward#" errorName="reward" />
			
			<cfif rc.edit>
			<!--- Row to edit the current reward --->
				<tr id="promotionRewardEdit#local.thisPromotionReward.getPromotionRewardID()#" class="alt<cfif !local.thisPromotionReward.hasErrors()> hideElement</cfif>">
					<td class="alignLeft" colspan="5">
					<input type="hidden" name="promotionRewards[#local.promotionRewardCount#].rewardType" value="#local.thisPromotionReward.getRewardType()#" />
					<div class = "promotionRewardForm">
						<cfif local.thisPromotionReward.getRewardType() eq "product">
							<dl class="oneColumn">
								<dt>
									<label for="productTypeID#local.promotionRewardCount#">#rc.$.Slatwall.rbKey("entity.promotionReward.productType")#</label>
								</dt>
								<select name="promotionRewards[#local.promotionRewardCount#].productType" id="productTypeID#local.promotionRewardCount#">
						            <option value="0">#$.Slatwall.rbKey("define.all")#</option>
							        <cfloop query="rc.productTypeTree">
										<cfset local.productTypeIDs = local.thisPromotionReward.getProductTypeIDs() />
							            <cfset local.thisDepth = rc.productTypeTree.TreeDepth />
							            <cfif local.thisDepth><cfset local.bullet="-"><cfelse><cfset local.bullet=""></cfif>
							            <option value="#rc.productTypeTree.productTypeID#"<cfif listFindNoCase(local.thisPromotionReward.getProductTypeIDs(), rc.productTypeTree.productTypeID)> selected="selected"</cfif>>
							                #RepeatString("&nbsp;&nbsp;&nbsp;",ThisDepth)##local.bullet##rc.productTypeTree.productTypeName#
							            </option>
							        </cfloop>
						        </select>	
								</dd>
								<dt>
									<label for="productName#local.promotionRewardCount#">#rc.$.Slatwall.rbKey("entity.promotionReward.product")#</label>
								</dt>
								<dd>
									<cfset local.productName = local.thisPromotionReward.displayProductNames() />
									<cfset local.productID = local.thisPromotionReward.getProductIDs() />
									<input type="text" id="productName#local.promotionRewardCount#" class="rewardProduct" name="promotionRewards[#local.promotionRewardCount#].productName" value="#local.productName#" />
									<input type="hidden" id=product#local.promotionRewardCount# name="promotionRewards[#local.promotionRewardCount#].product" value="#local.productID#" />
								</dd>
								<dt>
									<label for="skuCode#local.promotionRewardCount#">#rc.$.Slatwall.rbKey("entity.promotionReward.sku")#</label>
								</dt>
								<dd>
									<cfset local.skuCode = local.thisPromotionReward.displaySkuCodes() />
									<cfset local.skuID = local.thisPromotionReward.getSkuIDs() />
									<input type="text" id="skuCode#local.promotionRewardCount#" class="rewardSku" name="promotionRewards[#local.promotionRewardCount#].skuCode" value="#local.skuCode#" />
									<input type="hidden" id=sku#local.promotionRewardCount# name="promotionRewards[#local.promotionRewardCount#].sku" value="#local.skuID#" />
								</dd>
								<dt>
									<label for="itemRewardQuantity#local.promotionRewardCount#">#rc.$.Slatwall.rbKey("entity.promotionReward.itemRewardQuantity")#</label>
								</dt>
								<dd>
									<input type="text" id="itemRewardQuantity#local.promotionRewardCount#" name="promotionRewards[#local.promotionRewardCount#].itemRewardQuantity" value="#local.thisPromotionReward.getItemRewardQuantity()#" />
								</dd>
								<dt>
									<label for="discountType#local.promotionRewardCount#">#rc.$.Slatwall.rbKey("admin.promotion.edit.discount")#</label>
								</dt>
								<dd>
									<select name="promotionRewards[#local.promotionRewardCount#].productDiscountType" id="discountType#local.promotionRewardCount#">
										<option value="itemAmountOff"<cfif !isNull(local.thisPromotionReward.getitemAmountOff()) and isNumeric(local.thisPromotionReward.getItemAmountOff())> selected="selected"</cfif>>#$.Slatwall.rbKey("admin.promotion.promotionRewardType.amountOff")#</option>
										<option value="itemPercentageOff"<cfif !isNull(local.thisPromotionReward.getitemPercentageOff()) and isNumeric(local.thisPromotionReward.getItemPercentageOff())> selected="selected"</cfif>>#$.Slatwall.rbKey("admin.promotion.promotionRewardType.percentageOff")#</option>
										<option value="itemAmount"<cfif !isNull(local.thisPromotionReward.getitemAmount()) and isNumeric(local.thisPromotionReward.getItemAmount())> selected="selected"</cfif>>#$.Slatwall.rbKey("admin.promotion.promotionRewardType.fixedAmount")#</option>
									</select>
									<cfset local.discountValue = !isNull(local.thisPromotionReward.getitemAmountOff()) and isNumeric(local.thisPromotionReward.getItemAmountOff()) ? local.thisPromotionReward.getItemAmountOff() :
																 !isNull(local.thisPromotionReward.getitemPercentageOff()) and isNumeric(local.thisPromotionReward.getItemPercentageOff()) ? local.thisPromotionReward.getItemPercentageOff() :
																 local.thisPromotionReward.getItemAmount() />
									<input type="text" id="discountValue#local.promotionRewardCount#" name="promotionRewards[#local.promotionRewardCount#].discountValue" value="#local.discountValue#" />
								</dd>
						    </dl>
						<cfelseif local.thisPromotionReward.getRewardType() eq "shipping">
							<dl class="oneColumn">
								<dt>
									<label for="shippingMethod#local.promotionRewardCount#">#rc.$.Slatwall.rbKey("admin.promotion.edit.shippingMethod")#</label>
								</dt>
								<dd>
									<cfset local.shippingMethodIDs = local.thisPromotionReward.getShippingMethodIDs() />
									<cfif arrayLen(rc.shippingMethods) gt 0>
									<select name="promotionRewards[#local.promotionRewardCount#].shippingMethod" id="shippingMethod#local.promotionRewardCount#">
										<option value="">#$.Slatwall.rbKey("define.select")#</option>
										<cfloop array="#rc.shippingMethods#" index="local.shippingMethod">
											<option value="#local.shippingMethod.getShippingMethodID()#"<cfif listFindNoCase(local.shippingMethodIDs,local.shippingMethod.getShippingMethodID())> selected="selected"</cfif>>#local.shippingMethod.getShippingMethodName()#</option>
										</cfloop>
									</select>
									<cfelse>
										<strong>#$.Slatwall.rbKey("admin.promotion.noShippingMethodsConfigured")#</strong>  <cf_SlatwallActionCaller action="admin:setting.editFulfillmentMethod" querystring="fulfillmentmethodID=shipping" type="link" text="#$.slatwall.rbKey('admin.promotion.addShippingMethod')#">
									</cfif>
								</dd>
								<dt>
									<label for="discountType#local.promotionRewardCount#">#rc.$.Slatwall.rbKey("admin.promotion.edit.discount")#</label>
								</dt>
								<dd>
									<select name="promotionRewards[#local.promotionRewardCount#].shippingDiscountType" id="discountType#local.promotionRewardCount#">
										<option value="shippingAmountOff"<cfif !isNull(local.thisPromotionReward.getShippingAmountOff()) and isNumeric(local.thisPromotionReward.getShippingAmountOff())> selected="selected"</cfif>>#$.Slatwall.rbKey("admin.promotion.promotionRewardType.amountOff")#</option>
										<option value="shippingPercentageOff"<cfif !isNull(local.thisPromotionReward.getShippingPercentageOff()) and isNumeric(local.thisPromotionReward.getShippingPercentageOff())> selected="selected"</cfif>>#$.Slatwall.rbKey("admin.promotion.promotionRewardType.percentageOff")#</option>
										<option value="shippingAmount"<cfif !isNull(local.thisPromotionReward.getShippingAmount()) and isNumeric(local.thisPromotionReward.getShippingAmount())> selected="selected"</cfif>>#$.Slatwall.rbKey("admin.promotion.promotionRewardType.fixedAmount")#</option>
									</select>
									<cfset local.discountValue = !isNull(local.thisPromotionReward.getShippingAmountOff()) and isNumeric(local.thisPromotionReward.getShippingAmountOff()) ? local.thisPromotionReward.getShippingAmountOff() :
																 !isNull(local.thisPromotionReward.getShippingPercentageOff()) and isNumeric(local.thisPromotionReward.getShippingPercentageOff()) ? local.thisPromotionReward.getShippingPercentageOff() :
																 local.thisPromotionReward.getShippingAmount() />
									<input type="text" id="discountValue#local.promotionRewardCount#" name="promotionRewards[#local.promotionRewardCount#].discountValue" value="#local.discountValue#" />
								</dd>
						    </dl>
						</cfif>	
					</div>
					</td>				
				</tr>
			<!--- // Row to edit the current reward --->
			</cfif>			
		</cfloop>
		</tbody>
	</table>
	<cfelse>
		<p><em>#$.Slatwall.rbKey('admin.promotion.detail.noPromotionRewardsDefined')#</em></p>
	</cfif>
<cfif rc.edit>
<div class="buttons" id="rewardButtons">
	<a class="button" id="addPromotionReward">#rc.$.Slatwall.rbKey("admin.promotion.edit.addPromotionReward")#</a>
	<a class="button" id="remPromotionReward" style="display:none;">#rc.$.Slatwall.rbKey("admin.promotion.edit.removePromotionReward")#</a>
</div>

<!--- Form for new reward --->
<div id="promotionRewardFormTemplate" class="hideElement">
	<dl class="oneColumn" id="typeSelector">
		<dt>
			<label for="rewardType">#$.Slatwall.rbKey("admin.promotion.edit.rewardType")#</label>
		</dt>
		<dd>
			<select name="rewardType" class="rewardTypeSelector" id="rewardType">
				<option value="product">#$.Slatwall.rbKey('entity.promotionReward.promotionRewardType.product')#</option>
				<option value="shipping">#$.Slatwall.rbKey('entity.promotionReward.promotionRewardType.shipping')#</option>
			</select>
			<input type="hidden" name="promotionRewardID" value="" />
		</dd>
	</dl>
	<dl class="oneColumn" id="productReward">
		<dt>
			<label for="productTypeID">#rc.$.Slatwall.rbKey("entity.promotionReward.productType")#</label>
		</dt>
		<dd>
			<select name="productType" id="productTypeID">
	            <option value="0">#$.Slatwall.rbKey("define.all")#</option>
		        <cfloop query="rc.productTypeTree">
		            <cfset local.thisDepth = rc.productTypeTree.TreeDepth />
		            <cfif local.thisDepth><cfset local.bullet="-"><cfelse><cfset local.bullet=""></cfif>
		            <option value="#rc.productTypeTree.productTypeID#">
		                #RepeatString("&nbsp;&nbsp;&nbsp;",ThisDepth)##local.bullet##rc.productTypeTree.productTypeName#
		            </option>
		        </cfloop>
	        </select>	
		</dd>
		<dt>
			<label for="productName">#rc.$.Slatwall.rbKey("entity.promotionReward.product")#</label>
		</dt>
		<dd>
			<input id="productName" name="productName" class="rewardProduct" />
			<input type="hidden" name="product" value="" id="product" />
		</dd>
		<dt>
			<label for="skuCode">#rc.$.Slatwall.rbKey("entity.promotionReward.sku")#</label>
		</dt>
		<dd>
			<input type="text" id="skuCode" class="rewardSku" name="skuCode" value="" />
			<input type="hidden" name="sku" value="" id="sku" />
		</dd>
		<dt>
			<label for="itemRewardQuantity">#rc.$.Slatwall.rbKey("entity.promotionReward.itemRewardQuantity")#</label>
		</dt>
		<dd>
			<input type="text" id="itemRewardQuantity" name="itemRewardQuantity" value="" />
		</dd>
		<dt>
			<label for="discountType">#rc.$.Slatwall.rbKey("admin.promotion.edit.discount")#</label>
		</dt>
		<dd>
			<select name="productDiscountType" id="discountType">
				<option value="itemAmountOff">#$.Slatwall.rbKey("admin.promotion.promotionRewardType.amountOff")#</option>
				<option value="itemPercentageOff">#$.Slatwall.rbKey("admin.promotion.promotionRewardType.percentageOff")#</option>
				<option value="itemAmount">#$.Slatwall.rbKey("admin.promotion.promotionRewardType.fixedAmount")#</option>
			</select>
			<input type="text" id="discountValue" name="discountValue" value="" />
		</dd>
    </dl>
	<dl class="oneColumn hideElement" id="shippingReward">
		<dt>
			<label for="shippingMethod">#rc.$.Slatwall.rbKey("admin.promotion.edit.shippingMethod")#</label>
		</dt>
		<dd>
			<cfif arrayLen(rc.shippingMethods) gt 0>
			<select name="shippingMethod" id="shippingMethod">
				<option value="">#$.Slatwall.rbKey("define.select")#</option>
				<cfloop array="#rc.shippingMethods#" index="local.shippingMethod">
					<option value="#local.shippingMethod.getShippingMethodID()#">#local.shippingMethod.getShippingMethodName()#</option>
				</cfloop>
			</select>
			<cfelse>
				<strong>#$.Slatwall.rbKey("admin.promotion.noShippingMethodsConfigured")#</strong>  <cf_SlatwallActionCaller action="admin:setting.editFulfillmentMethod" querystring="fulfillmentmethodID=shipping" type="link" text="#$.slatwall.rbKey('admin.promotion.addShippingMethod')#">
			</cfif>
		</dd>
		<dt>
			<label for="discountType">#rc.$.Slatwall.rbKey("admin.promotion.edit.discount")#</label>
		</dt>
		<dd>
			<select name="shippingDiscountType" id="discountType">
				<option value="shippingAmountOff">#$.Slatwall.rbKey("admin.promotion.promotionRewardType.amountOff")#</option>
				<option value="shippingPercentageOff">#$.Slatwall.rbKey("admin.promotion.promotionRewardType.percentageOff")#</option>
				<option value="shippingAmount">#$.Slatwall.rbKey("admin.promotion.promotionRewardType.fixedAmount")#</option>
			</select>
			<input type="text" id="discountValue" name="discountValue" value="" />
		</dd>
    </dl>	
</div>
<!--- // Form for new reward --->

</cfif>
</cfoutput>