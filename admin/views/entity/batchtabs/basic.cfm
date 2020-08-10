<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.batch" type="any" />
<cfparam name="rc.baseID" type="any" default="#rc.batch.getBaseID()#" />
<cfparam name="rc.baseObject" type="any" default="#rc.batch.getBaseObject()#" />
<cfparam name="rc.edit" type="boolean" default="false" />
<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.baseID#" property="baseID" >
			<hb:HibachiPropertyDisplay object="#rc.baseObject#" property="baseObject" >
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
