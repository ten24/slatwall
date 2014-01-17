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

<cfoutput>
	<cf_HibachiEntityProcessForm entity="#rc.order#" edit="#rc.edit#">
		
		<cf_HibachiEntityActionBar type="preprocess" object="#rc.order#">
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<!--- Order Type --->
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="orderTypeCode"  edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="location" edit="true" />
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="fulfillmentRefundAmount" edit="true" />
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="receiveItemsFlag" edit="true" />
				
				<hr />
				
				<!--- Items Selector --->
				<table class="table table-striped table-bordered table-condensed">
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
							<td><input type="text" name="orderItems[#orderItemIndex#].price" value="#precisionEvaluate('orderItem.getExtendedPriceAfterDiscount() / orderItem.getQuantity()')#" class="span1 number" /></td>
							<td><input type="text" name="orderItems[#orderItemIndex#].quantity" value="" class="span1 number" /></td>
						</tr>
					</cfloop>
				</table>
				
				<hr />
				
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="refundOrderPaymentID" edit="true" />
				
				<cf_HibachiDisplayToggle selector="select[name='refundOrderPaymentID']" showValues="" loadVisable="#!len(rc.processObject.getRefundOrderPaymentID())#">
					<cfset rc.addOrderPaymentProcessObject = rc.order.getProcessObject("addOrderPayment") />
					<cfinclude template="preprocessorder_include/addorderpayment.cfm" />
				</cf_HibachiDisplayToggle>
				
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
	</cf_HibachiEntityProcessForm>
</cfoutput>
