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


<cfparam name="rc.orderDelivery" type="any" />
<cfparam name="rc.orderFulfillment" type="any" />
<cfparam name="rc.processObject" type="any" />

<cfset rc.processObject.setOrderFulfillment( rc.orderFulfillment ) />

<cfoutput>
	<cf_HibachiEntityProcessForm entity="#rc.orderDelivery#" edit="#rc.edit#" processActionQueryString="orderFulfillmentID=#rc.processObject.getOrderFulfillment().getOrderFulfillmentID()#" sRedirectAction="admin:entity.detailorderfulfillment" fRenderItem="preprocessorderdelivery">
		
		<cf_HibachiEntityActionBar type="preprocess" object="#rc.orderDelivery#">
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				
				<input type="hidden" name="order.orderID" value="#rc.processObject.getOrder().getOrderID()#" />
				<input type="hidden" name="orderFulfillment.orderFulfillmentID" value="#rc.processObject.getOrderFulfillment().getOrderFulfillmentID()#" />
				<input type="hidden" name="location.locationID" value="#rc.processObject.getLocation().getLocationID()#" />
				
				<!--- Shipping - Hidden Fields --->
				<cfif rc.processObject.getOrderFulfillment().getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
					<input type="hidden" name="shippingMethod.shippingMethodID" value="#rc.processObject.getShippingMethod().getShippingMethodID()#" />
					<input type="hidden" name="shippingAddress.addressID" value="#rc.processObject.getShippingAddress().getAddressID()#" />
				</cfif>
				
				<!--- Shipping - Inputs --->
				<cfif rc.processObject.getOrderFulfillment().getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="trackingNumber" edit="true" />
				</cfif>
				
				<!---Loop through order payments to see if we paid with a credit card--->
				<cfset orderPayments = #rc.processObject.getOrder().getOrderPayments()# />
				<cfset foundCredit = false />
				<cfloop array='#orderPayments#' index="payment">
					<cfif payment.getPaymentMethodType() eq 'creditCard'>
						<cfset foundCredit = true />
						<cfbreak>
					</cfif>
				</cfloop>
				
				<cfif rc.processObject.getCapturableAmount() gt 0 AND foundCredit>
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="captureAuthorizedPaymentsFlag" edit="true" />
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="capturableAmount" edit="false" />
				</cfif>
				
				<hr />
				
				<table class="table table-striped table-bordered table-condensed">
					<tr>
						<th>Sku Code</th>
						<th class="primary">Product Title</th>
						<th>Options</th>
						<th>Notes</th>
						<th>Quantity</th>
					</tr>
					<cfset orderItemIndex = 0 />
					<cfloop array="#rc.processObject.getOrderDeliveryItems()#" index="recordData">
						<cfif IsNumeric(recordData.quantity) AND recordData.quantity gt 0 >
						<tr>
							
							<cfset orderItemIndex++ />
							
							<cfset orderItem = $.slatwall.getService("orderService").getOrderItem( recordData.orderItem.orderItemID ) />
							
							<td>#orderItem.getSku().getSkuCode()#</td>
							<td>#orderItem.getSku().getProduct().getTitle()#</td>
							<td>#orderItem.getSku().displayOptions()#</td>
							<cfset thisQuantity = recordData.quantity />
							<cfif thisQuantity gt orderItem.getQuantityUndelivered()>
								<cfset thisQuantity = orderItem.getQuantityUndelivered() />
								<td style="color:##cc0000;">Updated from #recordData.quantity# to Max: #thisQuantity#</td>	
							<cfelse>
								<td></td>
							</cfif>
							<td>#thisQuantity#</td>
							
							<input type="hidden" name="orderDeliveryItems[#orderItemIndex#].orderItem.orderItemID" value="#recordData.orderItem.orderItemID#" />
							<input type="hidden" name="orderDeliveryItems[#orderItemIndex#].quantity" value="#thisQuantity#" />
						</tr>
						</cfif>
					</cfloop>
				</table>
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
	</cf_HibachiEntityProcessForm>
</cfoutput>
