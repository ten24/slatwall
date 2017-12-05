<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.ledgeraccount" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<!--- ledger account inventory listing --->
	
	
	<cfif ListFindNoCase('latAsset,latExpense,latRevenue,latCogs',rc.ledgerAccount.getLedgerAccountType().getSystemCode())>
		<cfset laSmartList = rc.ledgerAccount.getInventorySmartList()/>
		<cfset laSmartList.addOrder('createdDateTime|DESC')/>
		<hb:HibachiListingDisplay smartList="#laSmartList#"
		>
			<cfswitch expression="#rc.ledgerAccount.getLedgerAccountType().getSystemCode()#" >
				
		        <!---<hb:HibachiListingColumn propertyIdentifier="orderDeliveryItem.orderItem.order.orderNumber" />--->
				<cfcase value="latCogs">
			        <hb:HibachiListingColumn propertyIdentifier="vendorOrderDeliveryItem.vendorOrderItem.vendorOrder.vendorOrderNumber" />
			        <hb:HibachiListingColumn propertyIdentifier="stockReceiverItem.vendorOrderItem.vendorAlternateSkuCode.alternateSkuCode" />
					<hb:HibachiListingColumn propertyIdentifier="cost" />
					<hb:HibachiListingColumn propertyIdentifier="landedAmount" />
					<hb:HibachiListingColumn propertyIdentifier="landedCost" />
				</cfcase> 
				<cfcase value="latAsset">
			        <hb:HibachiListingColumn propertyIdentifier="vendorOrderDeliveryItem.vendorOrderItem.vendorOrder.vendorOrderNumber" />
			        <hb:HibachiListingColumn propertyIdentifier="stockReceiverItem.vendorOrderItem.vendorAlternateSkuCode.alternateSkuCode" />
					<hb:HibachiListingColumn propertyIdentifier="cost" />
					<hb:HibachiListingColumn propertyIdentifier="orderDeliveryItem.orderItem.calculatedExtendedPrice" />
				</cfcase> 
				<cfcase value="latRevenue">
					<hb:HibachiListingColumn propertyIdentifier="orderDeliveryItem.orderItem.order.orderNumber" />
			        <hb:HibachiListingColumn propertyIdentifier="orderDeliveryItem.orderItem.calculatedExtendedPrice" />
				</cfcase>
				<cfcase value="latExpense">
				</cfcase>
			</cfswitch>
	        <hb:HibachiListingColumn propertyIdentifier="quantityIN" />
	        <hb:HibachiListingColumn propertyIdentifier="quantityOUT" />
			<hb:HibachiListingColumn propertyIdentifier="createdDateTime" />
		</hb:HibachiListingDisplay>
    </cfif>
</cfoutput>