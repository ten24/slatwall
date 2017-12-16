<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.ledgeraccount" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<!--- ledger account inventory listing --->


	<cfif ListFindNoCase('latAsset,latExpense,latRevenue,latCogs',rc.ledgerAccount.getLedgerAccountType().getSystemCode())>
		<cfset laCollectionList = rc.ledgeraccount.getInventoryCollectionList()/>
		<cfset laCollectionList.setOrderBy('createdDateTime|DESC')/>
		<cfset displayOptions = {isVisible=true}/>
		<cfswitch expression="#rc.ledgerAccount.getLedgerAccountType().getSystemCode()#">
			<cfcase value="latCogs">
				<cfset laCollectionList.setDisplayProperties('vendorOrderDeliveryItem.vendorOrderItem.vendorOrder.vendorOrderNumber,stockReceiverItem.vendorOrderItem.vendorAlternateSkuCode.alternateSkuCode,cost,landedAmount,landedCost',displayOptions)/>
			</cfcase>
			<cfcase value="latAsset">
				<cfset laCollectionList.setDisplayProperties('vendorOrderDeliveryItem.vendorOrderItem.vendorOrder.vendorOrderNumber,stockReceiverItem.vendorOrderItem.vendorAlternateSkuCode.alternateSkuCode,cost,orderDeliveryItem.orderItem.calculatedExtendedPrice',displayOptions)/>
			</cfcase>
			<cfcase value="latRevenue">
				<cfset laCollectionList.setDisplayProperties('orderDeliveryItem.orderItem.order.orderNumber,orderDeliveryItem.orderItem.calculatedExtendedPrice',displayOptions)/>
			</cfcase>
			<cfcase value="latExpense">
			</cfcase>
		</cfswitch>
		<cfset laCollectionList.addDisplayProperty(displayProperty='currencyCode',columnConfig=displayOptions)/>
		<cfset laCollectionList.addDisplayProperty(displayProperty='quantityIn',columnConfig=displayOptions)/>
		<cfset laCollectionList.addDisplayProperty(displayProperty='quantityOut',columnConfig=displayOptions)/>
		<cfset laCollectionList.addDisplayProperty(displayProperty='createdDateTime',columnConfig=displayOptions)/>
		<cfset laCollectionList.addDisplayProperty(displayProperty='inventoryID',columnConfig={isVisible=false})/>


		<hb:HibachiListingDisplay collectionlist="#laCollectionList#"
			recordEditAction="admin:entity.edit#lcase(laCollectionList.getCollectionObject())#"
			recordDetailAction="admin:entity.detail#lcase(laCollectionList.getCollectionObject())#"
		>
		</hb:HibachiListingDisplay>
    </cfif>
</cfoutput>