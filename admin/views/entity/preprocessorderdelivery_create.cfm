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
	<hb:HibachiEntityProcessForm entity="#rc.orderDelivery#" edit="#rc.edit#" processActionQueryString="orderFulfillmentID=#rc.processObject.getOrderFulfillment().getOrderFulfillmentID()#" sRedirectAction="admin:entity.detailorderfulfillment" fRenderItem="preprocessorderdelivery">

		<hb:HibachiEntityActionBar type="preprocess" object="#rc.orderDelivery#">
		</hb:HibachiEntityActionBar>

		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>

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
					<cfset hasShippingIntegration = rc.processObject.getUseShippingIntegrationForTrackingNumber()>
					<cfif hasShippingIntegration && getHibachiScope().setting('globalUseShippingIntegrationForTrackingNumberOption')>
						<hb:HibachiDisplayToggle selector="input[name='trackingNumber']" showValues="0" loadVisable="#hasShippingIntegration#">
							<hb:HibachiPropertyDisplay 
								object="#rc.processObject#" 
								property="useShippingIntegrationForTrackingNumber" 
								edit="true"
							>
						</hb:HibachiDisplayToggle>
						<hb:HibachiDisplayToggle selector="input[name='useShippingIntegrationForTrackingNumber']" showValues="0" loadVisible="#!hasShippingIntegration#">
							<hb:HibachiPropertyDisplay object="#rc.processObject#" property="trackingNumber" edit="true" />
						</hb:HibachiDisplayToggle>
					<cfelse>
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="trackingNumber" edit="true" />
					</cfif>
				</cfif>

				<!--- Gift Card Codes --->
				<cfif !rc.orderFulfillment.hasGiftCardCodes()>

					<cfloop index="codeCount" from="1" to="#rc.orderFulfillment.getNumberOfNeededGiftCardCodes()#">
						<div class="form-group">
							<label for="giftCardCodes[#codeCount#]">#rc.orderFulfillment.getGiftCardListLabels()[codeCount]# Gift Card Code</label>
							<input type="text" name="giftCardCodes[#codeCount#]" />
						</div>
					</cfloop>

				</cfif>

				<cfif rc.processObject.getCapturableAmount() gt 0 AND rc.processObject.getOrder().hasCreditCardPaymentMethod()>
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="captureAuthorizedPaymentsFlag" edit="true" />
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="capturableAmount" edit="false" />
				</cfif>

				<hr />

				<hb:HibachiErrorDisplay object="#rc.processObject#" errorName="orderDeliveryItems" />

				<table class="table table-bordered table-hover">
					<tr>
						<th>Sku Code</th>
						<th class="primary">Product Title</th>
						<th>Options</th>
						<th>Notes</th>
						<th>Quantity</th>
					</tr>
					<cfset orderItemIndex = 0 />
					<cfloop array="#rc.processObject.getOrderDeliveryItems()#" index="recordData">
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

							<cfif IsNumeric(recordData.quantity) && thisQuantity gt 0>
								<td>#thisQuantity#</td>
							<cfelse>
								<td style="color:##cc0000;">#$.slatwall.rbKey('entity.orderDelivery.process.create.cannotfulfillitem')#</td>
							</cfif>

							<input type="hidden" name="orderDeliveryItems[#orderItemIndex#].orderItem.orderItemID" value="#recordData.orderItem.orderItemID#" />
							<input type="hidden" name="orderDeliveryItems[#orderItemIndex#].quantity" value="#thisQuantity#" />
						</tr>
					</cfloop>
				</table>
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>

	</hb:HibachiEntityProcessForm>
</cfoutput>
