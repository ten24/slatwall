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


<cfparam name="rc.order" type="any" />
<cfparam name="rc.processObject" type="any" />

<cfoutput>
	<hb:HibachiEntityProcessForm entity="#rc.order#" edit="#rc.edit#">
		
		<hb:HibachiEntityActionBar type="preprocess" object="#rc.order#">
		</hb:HibachiEntityActionBar>
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<!--- Order Type --->
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="orderTypeCode"  edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="location" edit="true" />
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="fulfillmentRefundAmount" edit="true" />
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="receiveItemsFlag" edit="true" />
				<hb:HibachiDisplayToggle selector="input[name='receiveItemsFlag']" showValues="1" loadVisable="#rc.processObject.getReceiveItemsFlag()#">
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="stockLossFlag" edit="true" />
				</hb:HibachiDisplayToggle>
				<hr />
				
				<!--- Items Selector --->
				<table class="table table-bordered table-hover">
					<tr>
						<th>#$.slatwall.rbKey('entity.sku.skuCode')#</th>
						<th>#$.slatwall.rbKey('entity.product.title')#</th>
						<th>#$.slatwall.rbKey('entity.sku.skuDefinition')#</th>
						<th>#$.slatwall.rbKey('entity.orderItem.quantity')#</th>
						<th>#$.slatwall.rbKey('entity.orderItem.quantityDelivered')#</th>
						<th>#$.slatwall.rbKey('entity.orderItem.price')#</th>
						<th>#$.slatwall.rbKey('entity.orderItem.quantity')#</th>
					</tr>
					<cfset orderItemIndex = 0 />
					<cfloop array="#rc.order.getOrderItems()#" index="orderItem">
						<tr>
							<cfset orderItemIndex++ />
							
							<input type="hidden" name="orderItems[#orderItemIndex#].orderItemID" value="" />
							<input type="hidden" name="orderItems[#orderItemIndex#].referencedOrderItem.orderItemID" value="#orderItem.getOrderItemID()#" />
							
							<td>#orderItem.getSku().getSkuCode()#</td>
							<td>#orderItem.getSku().getProduct().getTitle()#</td>
							<td>#orderItem.getSku().getSkuDefinition()#</td>
							<td>#orderItem.getQuantity()#</td>
							<td>#orderItem.getQuantityDelivered()#</td>
							<td><input type="text" name="orderItems[#orderItemIndex#].price" value="#getHibachiScope().getService('HibachiUtilityService').precisionCalculate(orderItem.getExtendedPriceAfterDiscount() / orderItem.getQuantity())#" class="span1 number" /></td>
							<td><input type="text" name="orderItems[#orderItemIndex#].quantity" value="" class="span1 number" /></td>
							<!--- IF THIS IS AN EVENT ORDER ITEM
								ADD CHECKBOX THAT SAYS CANCEL REGISTRATION
							--->
						</tr>
					</cfloop>
				</table>
				
				<hr />
				
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="refundOrderPaymentID" edit="true" />
				
				<hb:HibachiDisplayToggle selector="select[name='refundOrderPaymentID']" showValues="" loadVisable="#!len(rc.processObject.getRefundOrderPaymentID())#">
					<cfset rc.addOrderPaymentProcessObject = rc.order.getProcessObject("addOrderPayment") />
					<cfinclude template="preprocessorder_include/addorderpayment.cfm" />
				</hb:HibachiDisplayToggle>
				
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		
	</hb:HibachiEntityProcessForm>
</cfoutput>
