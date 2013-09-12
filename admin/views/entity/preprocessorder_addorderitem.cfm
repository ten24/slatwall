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
<cfparam name="rc.order" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityProcessForm entity="#rc.order#" edit="#rc.edit#" sRedirectAction="admin:entity.editorder" disableProcess="#not listFindNoCase(rc.processObject.getSku().setting('skuEligibleCurrencies'), rc.order.getCurrencyCode())#">
		
		<cf_HibachiEntityActionBar type="preprocess" object="#rc.order#">
		</cf_HibachiEntityActionBar>
		
		<cfif listFindNoCase(rc.processObject.getSku().setting('skuEligibleCurrencies'), rc.order.getCurrencyCode())>
			<cf_HibachiPropertyRow>
				<cf_HibachiPropertyList>
					<!--- Add the SkuID & orderItemTypeSystemCode --->
					<cfif not isNull(rc.processObject.getStockID())>
						<input type="hidden" name="stockID" value="#rc.processObject.getStockID()#" />
					</cfif>
					<cfif not isNull(rc.processObject.getSkuID())>
						<input type="hidden" name="skuID" value="#rc.processObject.getSkuID()#" />
					</cfif>
					<input type="hidden" name="orderItemTypeSystemCode" value="#rc.processObject.getOrderItemTypeSystemCode()#" />
					
					<h5>#$.slatwall.rbKey('admin.entity.preprocessorder_addorderitem.itemDetails')#</h5>
					<!--- Sku Properties --->
					<cf_HibachiPropertyDisplay object="#rc.processObject.getSku()#" property="skuCode" edit="false">
					<cf_HibachiPropertyDisplay object="#rc.processObject.getSku().getProduct()#" property="productName" edit="false">
					<cf_HibachiPropertyDisplay object="#rc.processObject.getSku()#" property="skuDefinition" edit="false">
					
					<!--- Order Item Details --->
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="quantity" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="price" edit="#rc.edit#">
					
					<!--- Order Item Custom Attributes --->
					<cfloop array="#rc.processObject.getAssignedOrderItemAttributeSets()#" index="attributeSet">
						<hr />
						<h5>#attributeSet.getAttributeSetName()#</h5>
						<cf_SlatwallAdminAttributeSetDisplay attributeSet="#attributeSet#" edit="#rc.edit#" />
					</cfloop>
					
					<!--- Order Fulfillment --->
					<cfif rc.processObject.getOrderItemTypeSystemCode() eq "oitSale">
						<hr />
						<h5>#$.slatwall.rbKey('admin.entity.preprocessorder_addorderitem.fulfillmentDetails')#</h5>
						<cf_HibachiPropertyDisplay object="#rc.processObject#" property="orderFulfillmentID" edit="#rc.edit#">
						
						<!--- New Order Fulfillment --->
						<cf_HibachiDisplayToggle selector="select[name='orderFulfillmentID']" showValues="new" loadVisable="#(!isNull(rc.processObject.getOrderFulfillmentID()) && rc.processObject.getOrderFulfillmentID() eq 'new')#">
							
							<!--- Fulfillment Method --->
							<cf_HibachiPropertyDisplay object="#rc.processObject#" property="fulfillmentMethodID" edit="#rc.edit#">
							
							<cfset loadFulfillmentMethodType = rc.processObject.getFulfillmentMethodIDOptions()[1]['fulfillmentMethodType'] />
							<cfloop array="#rc.processObject.getFulfillmentMethodIDOptions()#" index="option">
								<cfif option['value'] eq rc.processObject.getOrderFulfillmentID()>
									<cfset loadFulfillmentMethodType = option['fulfillmentMethodType'] />
								</cfif> 	
							</cfloop>
							
							<!--- Email Fulfillment Details --->
							<cf_HibachiDisplayToggle selector="select[name='fulfillmentMethodID']" valueAttribute="fulfillmentmethodtype" showValues="email" loadVisable="#loadFulfillmentMethodType eq 'email'#">
								
								<!--- Email Address --->
								<cf_HibachiPropertyDisplay object="#rc.processObject#" property="emailAddress" edit="#rc.edit#" />
							</cf_HibachiDisplayToggle>
							
							<!--- Pickup Fulfillment Details --->
							<cf_HibachiDisplayToggle selector="select[name='fulfillmentMethodID']" valueAttribute="fulfillmentmethodtype" showValues="pickup" loadVisable="#loadFulfillmentMethodType eq 'pickup'#">
								
								<!--- Pickup Location --->
								<cf_HibachiPropertyDisplay object="#rc.processObject#" property="pickupLocationID" edit="#rc.edit#" />
							</cf_HibachiDisplayToggle>
							
							<!--- Shipping Fulfillment Details --->
							<cf_HibachiDisplayToggle selector="select[name='fulfillmentMethodID']" valueAttribute="fulfillmentmethodtype" showValues="shipping" loadVisable="#loadFulfillmentMethodType eq 'shipping'#">
								
								<!--- Setup the primary address as the default account address --->
								<cfset defaultValue = "" />
								<cfif isNull(rc.processObject.getShippingAccountAddressID()) && !rc.order.getAccount().getPrimaryAddress().isNew()>
									<cfset defaultValue = rc.order.getAccount().getPrimaryAddress().getAccountAddressID() />
								<cfelseif !isNull(rc.processObject.getShippingAccountAddressID())>
									<cfset defaultValue = rc.processObject.getShippingAccountAddressID() />
								</cfif>
								
								<!--- Account Address --->
								<cf_HibachiPropertyDisplay object="#rc.processObject#" property="shippingAccountAddressID" edit="#rc.edit#" value="#defaultValue#" />
								
								<!--- New Address --->
								<cf_HibachiDisplayToggle selector="select[name='shippingAccountAddressID']" showValues="" loadVisable="#!len(defaultValue)#">
									
									<!--- Address Display --->
									<cf_SlatwallAdminAddressDisplay address="#rc.processObject.getShippingAddress()#" fieldNamePrefix="shippingAddress." />
									
									<!--- Save New Address --->
									<cf_HibachiPropertyDisplay object="#rc.processObject#" property="saveShippingAccountAddressFlag" edit="#rc.edit#" />
									
									<!--- Save New Address Name --->
									<cf_HibachiDisplayToggle selector="input[name='saveShippingAccountAddressFlag']" loadVisable="#rc.processObject.getSaveShippingAccountAddressFlag()#">
										<cf_HibachiPropertyDisplay object="#rc.processObject#" property="saveShippingAccountAddressName" edit="#rc.edit#" />
									</cf_HibachiDisplayToggle>
									
								</cf_HibachiDisplayToggle>
								
							</cf_HibachiDisplayToggle>
							
							
							
						</cf_HibachiDisplayToggle>
					<cfelse>
						<!--- Order Return --->
						<hr />
						<h5>#$.slatwall.rbKey('admin.entity.preprocessorder_addorderitem.returnDetails')#</h5>
						<cf_HibachiPropertyDisplay object="#rc.processObject#" property="orderReturnID" edit="#rc.edit#">
						
						<!--- New Order Return --->
						<cf_HibachiDisplayToggle selector="select[name='orderReturnID']" showValues="new" loadVisable="#(!isNull(rc.processObject.getOrderReturnID()) && rc.processObject.getOrderReturnID() eq 'new')#">
							
							<!--- Return Location --->
							<cf_HibachiPropertyDisplay object="#rc.processObject#" property="returnLocationID" edit="#rc.edit#">
							
							<!--- Fulfillment Refund Amount --->
							<cf_HibachiPropertyDisplay object="#rc.processObject#" property="fulfillmentRefundAmount" edit="#rc.edit#">
							
						</cf_HibachiDisplayToggle>
					</cfif>
				</cf_HibachiPropertyList>
				
			</cf_HibachiPropertyRow>
		<cfelse>
			<p class="text-error">#$.slatwall.rbKey('admin.entity.preprocessorder_addorderitem.wrongCurrency_info')#</p>
		</cfif>
	</cf_HibachiEntityProcessForm>
	
</cfoutput>
