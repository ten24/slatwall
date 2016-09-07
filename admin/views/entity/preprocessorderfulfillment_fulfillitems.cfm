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


<cfparam name="rc.orderFulfillment" type="any" />

<cfoutput>
	<hb:HibachiEntityProcessForm entity="#rc.orderFulfillment#" edit="#rc.edit#" processAction="admin:entity.preprocessorderdelivery" processContext="create">

		<hb:HibachiEntityActionBar type="preprocess" object="#rc.orderFulfillment#">
		</hb:HibachiEntityActionBar>

		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>

				<!--- Pass the info across --->
				<input type="hidden" name="order.orderID" value="#rc.orderFulfillment.getOrder().getOrderID()#" />
				<input type="hidden" name="orderFulfillment.orderFulfillmentID" value="#rc.orderFulfillment.getOrderFulfillmentID()#" />

				<!--- Shipping - Hidden Fields --->
				<cfif rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
					<input type="hidden" name="shippingMethod.shippingMethodID" value="#rc.orderFulfillment.getShippingMethod().getShippingMethodID()#" />
					<input type="hidden" name="shippingAddress.addressID" value="#rc.orderFulfillment.getAddress().getAddressID()#" />
				</cfif>

				<!--- Location --->
				<hb:HibachiFieldDisplay title="#$.slatwall.rbKey('entity.location')#" fieldName="location.locationID" valueOptions="#$.slatwall.getService('locationService').getLocationOptions()#" fieldType="select" edit="true" />

				<hr />

				<!--- Items Selector --->
				<table class="table table-bordered table-hover">
					<tr>
						<th>#$.slatwall.rbKey('entity.sku.skuCode')#</th>
						<th class="primary">#$.slatwall.rbKey('entity.product.title')#</th>
						<th>#$.slatwall.rbKey('entity.sku.options')#</th>
						<th>#$.slatwall.rbKey('entity.orderitem.quantity')#</th>
						<th>#$.slatwall.rbKey('entity.orderItem.quantityUndelivered')#</th>
						<th>#$.slatwall.rbKey('entity.orderitem.quantityDelivered')#</th>
						<th>#$.slatwall.rbKey('define.Quantity')#</th>
					</tr>
					<cfset orderItemIndex = 0 />
					<cfloop array="#rc.orderFulfillment.getOrderFulfillmentItems()#" index="orderItem">
						<tr>
							<cfset orderItemIndex++ />

							<input type="hidden" name="orderDeliveryItems[#orderItemIndex#].orderItem.orderItemID" value="#orderItem.getOrderItemID()#" />

							<td>#orderItem.getSku().getSkuCode()#</td>
							<td>#orderItem.getSku().getProduct().getTitle()#</td>
							<td>#orderItem.getSku().displayOptions()#</td>
							<td>#orderItem.getQuantity()#</td>
							<td>#orderItem.getQuantityUndelivered()#</td>
							<td>#orderItem.getQuantityDelivered()#</td>
							<td><input type="text" name="orderDeliveryItems[#orderItemIndex#].quantity" value="0" class="span1" /></td>
						</tr>
					</cfloop>
				</table>
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>

	</hb:HibachiEntityProcessForm>
</cfoutput>
