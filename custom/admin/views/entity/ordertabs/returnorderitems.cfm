<cfimport prefix="swa" taglib="../../../../../tags" />
<cfimport prefix="hb" taglib="../../../../../org/Hibachi/HibachiTags" />

<cfoutput>
	<hb:HibachiPropertyRow divAttributes="style='overflow-x:auto'">
		<hb:HibachiPropertyList>
			<!--- Items Selector --->
			<sw-return-order-items 
				order-type="#rc.processObject.getOrderTypeCode()#"
				order-id="#rc.order.getOrderID()#" 
				currency-code="#rc.order.getCurrencyCode()#" 
				initial-fulfillment-refund-amount="#rc.processObject.getFulfillmentRefundAmount(true)#"
				order-payments="#$.slatwall.getService('HibachiService').hibachiHTMLEditFormat(serializeJSON(rc.processObject.getRefundOrderPaymentIDOptions()))#"
				fulfillment-tax-amount="#rc.processObject.getFulfillmentTaxAmountNotRefunded()#"
				<cfif rc.processObject.getOrderTypeCode() EQ "otRefundOrder">
					refund-order-items="#$.slatwall.getService('HibachiService').hibachiHTMLEditFormat(serialize(rc.processObject.getRefundOrderItemList()))#"
					order-total="#rc.order.getRefundableAmount()#"
				<cfelse>
					order-total="#rc.order.getRefundableAmountMinusRemainingTaxesAndFulfillmentCharge()#"
				</cfif>
				original-order-subtotal="#rc.order.getSubTotal()#"
				order-discount-amount="#rc.order.getOrderDiscountAmountTotal()#"
			></sw-return-order-items>
			
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>