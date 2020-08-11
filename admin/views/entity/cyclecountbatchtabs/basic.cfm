<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.cyclecountbatch" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.cyclecountbatch#" property="cycleCountBatchName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.cyclecountbatch#" property="location" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.cyclecountbatch#" property="cycleCountBatchStatusType" title="Status" edit="false">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
