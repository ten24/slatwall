<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderImportBatch" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>

	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divclass="col-md-6">
 			<hb:HibachiPropertyDisplay object="#rc.orderImportBatch#" property="orderImportBatchName" edit="false">
 		    <hb:HibachiPropertyDisplay object="#rc.orderImportBatch#" property="orderImportBatchStatusType" edit="false">
 	    </hb:HibachiPropertyList>	
	</hb:HibachiPropertyRow>
</cfoutput>