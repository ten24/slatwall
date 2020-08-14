<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.entityqueue" type="any" />
<cfparam name="rc.edit" type="boolean" default="false" />
<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="baseObject" >
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="processMethod" >
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
