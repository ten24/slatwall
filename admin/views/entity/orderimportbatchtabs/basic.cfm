<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderImportBatch" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>

	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divclass="col-md-6">
 			<hb:HibachiPropertyDisplay object="#rc.orderImportBatch#" property="orderImportBatchName" edit="false">
 			<hb:HibachiPropertyDisplay object="#rc.orderImportBatch#" property="orderType" edit="#rc.edit#">
 			<hb:HibachiPropertyDisplay object="#rc.orderImportBatch#" property="shippingMethod" edit="#rc.edit#">
 		    <hb:HibachiPropertyDisplay object="#rc.orderImportBatch#" property="orderImportBatchStatusType" edit="false">
 	    	<hb:HibachiPropertyDisplay object="#rc.orderImportBatch#" property="comment" edit="#rc.edit#">
     		<hb:HibachiPropertyDisplay object="#rc.orderImportBatch#" property="itemCount" edit="false">
 			<hb:HibachiPropertyDisplay object="#rc.orderImportBatch#" property="placedOrdersCount" edit="false">
 			<hb:HibachiPropertyDisplay object="#rc.orderImportBatch#" property="sendEmailNotificationsFlag" edit="#rc.edit#">
 	    </hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>