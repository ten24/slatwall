<cfimport prefix="swa" taglib="../../../../../tags" />
<cfimport prefix="hb" taglib="../../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.volumeRebuildBatch" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divclass="col-md-6">
 			<hb:HibachiPropertyDisplay object="#rc.volumeRebuildBatch#" property="volumeRebuildBatchStatusType" edit="false">
 	    </hb:HibachiPropertyList>	
	</hb:HibachiPropertyRow>
</cfoutput>
