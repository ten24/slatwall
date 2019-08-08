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
				<input type="hidden" name="orderTypeCode" value="#rc.processObject.getOrderTypeCode()#">
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="orderTypeName"  edit="false">
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="location" edit="true" />
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="returnReasonType" edit="true" />
				<cfif rc.processObject.getOrderTypeCode() eq 'otReturnOrder'>
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="secondaryReturnReasonType" edit="true" />
				</cfif>

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
				<table class="table table-bordered table-hover" sw-return-order-items>
					<tr>
						<th>#$.slatwall.rbKey('entity.sku.skuCode')#</th>
						<th>#$.slatwall.rbKey('entity.product.title')#</th>
						<th>#$.slatwall.rbKey('entity.sku.skuDefinition')#</th>
						<th>#$.slatwall.rbKey('entity.orderItem.quantity')# Ordered</th>
						<th>#$.slatwall.rbKey('entity.orderItem.quantityDeliveredMinusReturns')#</th>
						<th>Return #$.slatwall.rbKey('entity.orderItem.quantity')#</th>
						
						<th>#$.slatwall.rbKey('entity.orderItem.discountAmount')#</th>
						<th>#$.slatwall.rbKey('entity.orderitem.extendedPriceAfterDiscount')#</th>
						<th>#$.slatwall.rbKey('entity.orderItem.extendedPersonalVolumeAfterDiscount')#</th>
						<th>#$.slatwall.rbKey('entity.orderItem.extendedCommissionableVolumeAfterDiscount')#</th>
						
						<th>Unit Price</th>
						<th>Unit Price after Order Discounts</th>
						<th>Refund Unit Price</th>
						<th>Refund #$.slatwall.rbKey('entity.orderitem.extendedPriceAfterDiscount')#</th>
						<th>Refund #$.slatwall.rbKey('entity.orderitem.extendedPersonalVolumeAfterDiscount')#</th>
						<th>Refund #$.slatwall.rbKey('entity.orderitem.extendedCommissionableVolumeAfterDiscount')#</th>
					</tr>
					<cfset orderItemIndex = 0 />
					<cfloop array="#rc.order.getOrderItems()#" index="orderItem">
						<tr class="orderItem" ng-init="swReturnOrderItems.orderItems[#orderItemIndex#] = {refundTotal:0,refundPVTotal:0,refundCVTotal:0};orderItem#orderItemIndex# = swReturnOrderItems.orderItems[#orderItemIndex#]">
							
							<input type="hidden" name="orderItems[#orderItemIndex + 1#].orderItemID" value="" />
							<input type="hidden" name="orderItems[#orderItemIndex + 1#].referencedOrderItem.orderItemID" value="#orderItem.getOrderItemID()#" />
							
							<td>#orderItem.getSku().getSkuCode()#</td>
							<td>#orderItem.getSku().getProduct().getTitle()#</td>
							<td>#orderItem.getSku().getSkuDefinition()#</td>
							<td ng-init="orderItem.quantity = #orderItem.getQuantity()#">#orderItem.getQuantity()#</td>
							<td class="returnQuantityMaximum" ng-init="orderItem#orderItemIndex#.returnQuantityMaximum = #orderItem.getQuantityDeliveredMinusReturns()#">#orderItem.getQuantityDeliveredMinusReturns()#</td>
							<td><input type="number" ng-change="swReturnOrderItems.updateOrderItem(orderItem#orderItemIndex#)" ng-model="orderItem#orderItemIndex#.returnQuantity" name="orderItems[#orderItemIndex + 1#].quantity" value="" class="span1 number returnQuantity" /></td>
							
							<td>#orderItem.getDiscountAmount() + orderItem.getAllocatedOrderDiscountAmount()#</td>
							<td ng-init="orderItem#orderItemIndex#.total = #orderItem.getExtendedPriceAfterAllDiscounts()#">#orderItem.getFormattedValue('extendedPriceAfterAllDiscounts')#</td>
							<td ng-init="orderItem#orderItemIndex#.personalVolumeTotal = #orderItem.getExtendedPersonalVolumeAfterAllDiscounts()#">#orderItem.getExtendedPersonalVolumeAfterAllDiscounts()#</td>
							<td ng-init="orderItem#orderItemIndex#.commissionableVolumeTotal = #orderItem.getExtendedCommissionableVolumeAfterAllDiscounts()#">#orderItem.getExtendedCommissionableVolumeAfterAllDiscounts()#</td>
							
							<td>#orderItem.getFormattedValue('extendedUnitPriceAfterDiscount')#</td>
							<td>#orderItem.getFormattedValue('extendedUnitPriceAfterAllDiscounts')#</td>
							<td><input type="number" ng-change="swReturnOrderItems.updateOrderItem(orderItem#orderItemIndex#)" name="orderItems[#orderItemIndex + 1#].price" ng-model="orderItem#orderItemIndex#.refundUnitPrice" ng-init="orderItem#orderItemIndex#.refundUnitPrice = #numberFormat(orderItem.getExtendedUnitPriceAfterAllDiscounts(), '0.00')#" class="span1 number refundUnitPrice" /></td>
							<td class="refundTotal">#getHibachiScope().getService('CurrencyService').getCurrencyByCurrencyCode(orderItem.getCurrencyCode()).getCurrencySymbol()#
								<span ng-bind="orderItem#orderItemIndex#.refundTotal.toFixed(2)"></span>
							</td>
							<td class="refundTotal">
								<span ng-bind="orderItem#orderItemIndex#.refundPVTotal.toFixed(2)"></span>
							</td>
							<td class="refundTotal">
								<span ng-bind="orderItem#orderItemIndex#.refundCVTotal.toFixed(2)"></span>
							</td>
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
						<cfset orderItemIndex++ />
					</cfloop>
					
					<tr>
						<td colspan="10"></td>
						<td colspan="3"><strong>Fulfillment Refund:</strong> #getHibachiScope().getService('CurrencyService').getCurrencyByCurrencyCode(orderItem.getCurrencyCode()).getCurrencySymbol()#
							<input name="fulfillmentRefundAmount" type="number" ng-model="swReturnOrderItems.fulfillmentRefundAmount" ng-change="swReturnOrderItems.validateFulfillmentRefundAmount()" ng-init="swReturnOrderItems.fulfillmentRefundAmount = #rc.processObject.getFulfillmentRefundAmount()#;swReturnOrderItems.maxFulfillmentRefundAmount = swReturnOrderItems.fulfillmentRefundAmount">
						</td>
						<td class="refundTotal">#getHibachiScope().getService('CurrencyService').getCurrencyByCurrencyCode(orderItem.getCurrencyCode()).getCurrencySymbol()#
							<span ng-bind="swReturnOrderItems.refundTotal.toFixed(2)" ng-init="swReturnOrderItems.updateRefundTotals()"></span>
						</td>
						<td class="refundTotal">
								<span ng-bind="swReturnOrderItems.refundPVTotal.toFixed(2)"></span>
						</td>
						<td class="refundTotal">
							<span ng-bind="swReturnOrderItems.refundCVTotal.toFixed(2)"></span>
						</td>
					</tr>
					<cfset paymentIndex = 0 />
					<cfloop array="#arraySlice(rc.processObject.getRefundOrderPaymentIDOptions(), 1, arrayLen(rc.processObject.getRefundOrderPaymentIDOptions())-1)#" index="op">
						<tr ng-init="swReturnOrderItems.orderPayments[#paymentIndex#] = {amount:0};orderPayment#paymentIndex#=swReturnOrderItems.orderPayments[#paymentIndex#]">
							<td colspan="11" ng-init="orderPayment#paymentIndex#.amountReceived = #op.amountReceived#"></td>
							<td>#op.name#</td>
							<td class="total">
								<input type="hidden" name="orderPayments[#paymentIndex + 1#].orderPaymentID" value="">
								<input type="hidden" name="orderPayments[#paymentIndex + 1#].originalOrderPaymentID" value="#op.value#">
								<input type="number" ng-change="swReturnOrderItems.validateAmount(orderPayment#paymentIndex#)" name="orderPayments[#paymentIndex + 1#].amount" ng-model="orderPayment#paymentIndex#.amount" class="span1 number" />
							</td>
						</tr>
						<cfset paymentIndex++ />
					</cfloop>
				</table>
				
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		
	</hb:HibachiEntityProcessForm>
</cfoutput>
