<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.batch" type="any" />
<cfparam name="rc.edit" type="boolean" default="false" />
<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.batch#" property="baseObject" >
			<hb:HibachiPropertyDisplay object="#rc.batch#" property="batchDescription" >
			<hb:HibachiPropertyDisplay object="#rc.batch#" property="initialEntityQueueItemsCount" >
			<hb:HibachiPropertyDisplay object="#rc.batch#" property="entityQueueItemsCount" >
			<hb:HibachiPropertyDisplay object="#rc.batch#" property="entityQueueFailureItemsCount" >
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
