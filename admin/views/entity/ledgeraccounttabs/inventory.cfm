<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.ledgeraccount" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<!--- ledger account inventory listing --->
	<cfif ListFindNoCase('latAsset,latExpense,latRevenue,latCogs',rc.ledgerAccount.getLedgerAccountType().getSystemCode())>
		<hb:HibachiListingDisplay smartList="#rc.ledgerAccount.getInventorySmartList()#"
		>
			<hb:HibachiListingColumn propertyIdentifier="createdDateTime" />
	        <hb:HibachiListingColumn propertyIdentifier="quantityIN" />
	        <hb:HibachiListingColumn propertyIdentifier="quantityOUT" />
	        <hb:HibachiListingColumn propertyIdentifier="stockReceiverItem.vendorOrderItem.vendorAlternateSkuCode.alternateSkuCode" />
	        <hb:HibachiListingColumn propertyIdentifier="orderDeliveryItem.orderItem.order.orderNumber" />
	        <!---<hb:HibachiListingColumn propertyIdentifier="stockAdjustmentDeliveryItem.stockAdjustmentItem.stockAdjustment.stockAdjustmentID" />--->
			
		</hb:HibachiListingDisplay>
    </cfif>
</cfoutput>