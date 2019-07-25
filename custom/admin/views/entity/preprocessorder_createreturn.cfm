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
<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.order" type="any" />
<cfparam name="rc.processObject" type="any" />

<cfoutput>
	<hb:HibachiEntityProcessForm entity="#rc.order#" edit="#rc.edit#">
		
		<hb:HibachiEntityActionBar type="preprocess" object="#rc.order#">
		</hb:HibachiEntityActionBar>
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList divclass="col-md-6">
				<!--- Order Type --->
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="orderTypeCode"  edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="location" edit="true" />
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="returnReasonType" edit="true" />
				<cfif rc.processObject.getOrderTypeCode() eq 'otReturnOrder'>
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="secondaryReturnReasonType" edit="true" />
				</cfif>
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="fulfillmentRefundAmount" edit="true" />
				
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="refundOrderPaymentID" edit="true" />
				
				<hb:HibachiDisplayToggle selector="select[name='refundOrderPaymentID']" showValues="" loadVisable="#!len(rc.processObject.getRefundOrderPaymentID())#">
					<cfset rc.addOrderPaymentProcessObject = rc.order.getProcessObject("addOrderPayment") />
					<cfset rc.addOrderPaymentProcessObject.setOrderTypeCode('otReturnOrder') />
					<cfinclude template="../../../../admin/views/entity/preprocessorder_include/addorderpayment.cfm" />
				</hb:HibachiDisplayToggle>

				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="receiveItemsFlag" edit="true" />
				<hb:HibachiDisplayToggle selector="input[name='receiveItemsFlag']" showValues="1" loadVisable="#rc.processObject.getReceiveItemsFlag()#">
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="stockLossFlag" edit="true" />
				</hb:HibachiDisplayToggle>
			</hb:HibachiPropertyList>

			<hb:HibachiPropertyList divclass="col-md-6">
				<h4 class="panel-title">Original Order Overview</h4>
				<hb:HibachiPropertyRow>
					<hb:HibachiPropertyList divclass="col-md-6">
						<hb:HibachiPropertyDisplay object="#rc.order#" property="subTotal" edit="true" fieldAttributes="disabled">
						<hb:HibachiPropertyDisplay object="#rc.order#" property="taxTotal" edit="true" fieldAttributes="disabled">
						<hb:HibachiPropertyDisplay object="#rc.order#" property="discountTotal" edit="true" fieldAttributes="disabled">
						<hb:HibachiPropertyDisplay object="#rc.order#" property="commissionableVolumeTotal" edit="true" fieldAttributes="disabled">
					</hb:HibachiPropertyList>

					<hb:HibachiPropertyList divclass="col-md-6">
						<hb:HibachiPropertyDisplay object="#rc.order#" property="orderNumber" edit="false" valuelink="#getHibachiScope().buildURL(action=rc.entityActionDetails.detailAction, queryString='orderID=#rc.order.getOrderID()#')#" title="#$.slatwall.rbKey('entity.order')#">
						<hb:HibachiPropertyDisplay object="#rc.order#" property="fulfillmentTotal" edit="true" fieldAttributes="disabled">
						<hb:HibachiPropertyDisplay object="#rc.order#" property="total" edit="true" fieldAttributes="disabled">
						<hb:HibachiPropertyDisplay object="#rc.order#" property="commissionPeriodStartDateTime" edit="true" fieldAttributes="disabled">
						<hb:HibachiPropertyDisplay object="#rc.order#" property="commissionPeriodEndDateTime" edit="true" fieldAttributes="disabled">
					</hb:HibachiPropertyList>
				</hb:HibachiPropertyRow>

				<hr/>

				<h4 class="panel-title">Customer Information</h4>
				<hb:HibachiPropertyRow>
					<hb:HibachiPropertyList divclass="col-md-6">
						<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="fullName" edit="false" valuelink="#getHibachiScope().buildURL(action='entity.detailAccount', queryString='accountID=#rc.order.getAccount().getAccountID()#')#" title="#$.slatwall.rbKey('entity.account')#">
						<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="company" edit="true" fieldAttributes="disabled">
					</hb:HibachiPropertyList>
					<hb:HibachiPropertyList divclass="col-md-6">
						<!---<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="distributorID" edit="true" fieldAttributes="disabled">--->
					</hb:HibachiPropertyList>
				</hb:HibachiPropertyRow>
			</hb:HibachiPropertyList>
			
			<!---
			<hb:HibachiPropertyList divclass="col-md-6">
				<hb:HibachiPropertyRow>
					<hb:HibachiPropertyList divclass="col-md-6">
						<hb:HibachiPropertyDisplay object="#rc.order#" property="subTotal" edit="false" displayType="table">
						<hb:HibachiPropertyDisplay object="#rc.order#" property="taxTotal" edit="false" displayType="table">
						<hb:HibachiPropertyDisplay object="#rc.order#" property="discountTotal" edit="false" displayType="table">
					</hb:HibachiPropertyList>
					<hb:HibachiPropertyList divclass="col-md-6" edit="false">
						<hb:HibachiPropertyDisplay object="#rc.order#" property="orderNumber" edit="false" displayType="table" valuelink="#getHibachiScope().buildURL(action=rc.entityActionDetails.detailAction, queryString='orderID=#rc.order.getOrderID()#')#" title="#$.slatwall.rbKey('entity.order')#">
						<hb:HibachiPropertyDisplay object="#rc.order#" property="fulfillmentTotal" edit="false" displayType="table">
						<hb:HibachiPropertyDisplay object="#rc.order#" property="total" edit="false" displayType="table" titleClass="table-total" valueClass="table-total">
					</hb:HibachiPropertyList>
				</hb:HibachiPropertyRow>

				<hb:HibachiPropertyRow>
					<hb:HibachiPropertyList divclass="col-md-6">
						<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="fullName" edit="false" displayType="table" valuelink="#getHibachiScope().buildURL(action='entity.detailAccount', queryString='accountID=#rc.order.getAccount().getAccountID()#')#" title="#$.slatwall.rbKey('entity.account')#">
						<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="company" edit="false" displayType="table">
					</hb:HibachiPropertyList>

					<hb:HibachiPropertyList divclass="col-md-6" edit="false">
						<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="distributorID" edit="false" displayType="table">
					</hb:HibachiPropertyList>
				</hb:HibachiPropertyRow>
			</hb:HibachiPropertyList>	
			--->

				<!--- <hb:HibachiPropertyTable>
					<hb:HibachiPropertyTableBreak header="#getHibachiScope().rbKey('admin.entity.detailorder.overview')#" />
					<hb:HibachiPropertyTableBreak header="Customer Information" />
				</hb:HibachiPropertyTable> --->

		</hb:HibachiPropertyRow>

		<hb:HibachiPropertyRow>

			<hb:HibachiPropertyList>
				<hr />
				
				<!--- Items Selector --->
				<table class="table table-bordered table-hover">
					<tr>
						<th>#$.slatwall.rbKey('entity.sku.skuCode')#</th>
						<th>#$.slatwall.rbKey('entity.product.title')#</th>
						<th>#$.slatwall.rbKey('entity.sku.skuDefinition')#</th>
						<th>#$.slatwall.rbKey('entity.orderItem.quantity')# Ordered</th>
						<th>#$.slatwall.rbKey('entity.orderItem.quantityDelivered')#</th>
						<th>Return #$.slatwall.rbKey('entity.orderItem.quantity')#</th>
						
						<th>#$.slatwall.rbKey('entity.orderItem.discountAmount')#</th>
						<th>#$.slatwall.rbKey('entity.orderitem.extendedPriceAfterDiscount')#</th>
						<th>#$.slatwall.rbKey('entity.orderItem.extendedPersonalVolumeAfterDiscount')#</th>
						<th>#$.slatwall.rbKey('entity.orderItem.extendedCommissionableVolumeAfterDiscount')#</th>
						
						<th>Unit Price</th>
						<th>Refund Unit Price</th>
						<th>Refund #$.slatwall.rbKey('entity.orderitem.extendedPriceAfterDiscount')#</th>
					</tr>
					<cfset orderItemIndex = 0 />
					<cfloop array="#rc.order.getOrderItems()#" index="orderItem">
						<tr class="orderItem">
							<cfset orderItemIndex++ />
							
							<input type="hidden" name="orderItems[#orderItemIndex#].orderItemID" value="" />
							<input type="hidden" name="orderItems[#orderItemIndex#].referencedOrderItem.orderItemID" value="#orderItem.getOrderItemID()#" />
							
							<td>#orderItem.getSku().getSkuCode()#</td>
							<td>#orderItem.getSku().getProduct().getTitle()#</td>
							<td>#orderItem.getSku().getSkuDefinition()#</td>
							<td>#orderItem.getQuantity()#</td>
							<td class="returnQuantityMaximum">#orderItem.getQuantityDelivered()#</td>
							<td><input type="text" name="orderItems[#orderItemIndex#].quantity" value="" class="span1 number returnQuantity" /></td>
							
							<td>#orderItem.getDiscountAmount()#</td>
							<td>#orderItem.getFormattedValue('extendedPriceAfterDiscount')#</td>
							<td>#orderItem.getExtendedPersonalVolumeAfterDiscount()#</td>
							<td>#orderItem.getExtendedCommissionableVolumeAfterDiscount()#</td>
							
							<td>#getHibachiScope().getService("hibachiUtilityService").formatValue(value=orderItem.getExtendedPriceAfterDiscount() / orderItem.getQuantity(), formatType='currency', formatDetails={currency=rc.order.getCurrencyCode()})#</td>
							<td><input type="text" name="orderItems[#orderItemIndex#].price" value="#numberFormat(getHibachiScope().getService('HibachiUtilityService').precisionCalculate(orderItem.getExtendedPriceAfterDiscount() / orderItem.getQuantity()), '0.00')#" class="span1 number refundUnitPrice" /></td>
							<td class="refundTotal">$#numberFormat(0, '0.00')#</td>
							<!--- IF THIS IS AN EVENT ORDER ITEM
								ADD CHECKBOX THAT SAYS CANCEL REGISTRATION
								
								// if getAllocatedPVAmount
								// discount PV
								// discount CV
								// refund unit PV
								// refund unit CV
								// total PV
								// total CV
								// total return amount
								// payment methods and amount allocation
							--->
						</tr>
					</cfloop>
					
					<tr>
					<cfloop array="#arraySlice(rc.processObject.getRefundOrderPaymentIDOptions(), 1, arrayLen(rc.processObject.getRefundOrderPaymentIDOptions())-1)#" index="op">
						<td colspan="11"></td>
						<td>#op.name#</td>
						<td class="total">$0.00</td>
					</cfloop>
					</tr>
				</table>
				
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		
	</hb:HibachiEntityProcessForm>
</cfoutput>

<script src="/Slatwall/custom/assets/js/rma.js"></script>
