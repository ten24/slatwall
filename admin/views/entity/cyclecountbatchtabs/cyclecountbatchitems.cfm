<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.cyclecountbatch" type="any">
<cfparam name="rc.edit" type="boolean">

<cfset rc.cyclecountbatch.getCycleCountBatchItemsSmartList().addOrder('stock.sku.skuCode')>
<cfset rc.cyclecountbatch.getCycleCountBatchItemsSmartList().addOrder('stock.location.locationName')>

<cfoutput>
	<hb:HibachiListingDisplay smartList="#rc.cyclecountbatch.getCycleCountBatchItemsSmartList()#" 
								recordDetailAction="admin:entity.detailcyclecountbatchitem"
							  	recordEditAction="admin:entity.editcyclecountbatchitem">
		<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="stock.sku.skuCode" />
		<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="stock.location.locationName" />
		<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="quantity" editable="true" edit="#rc.edit#" />
	</hb:HibachiListingDisplay>
</cfoutput>
