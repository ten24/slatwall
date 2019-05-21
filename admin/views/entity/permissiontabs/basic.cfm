<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.permission" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.permission#" property="entityClassName" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.permission#" property="allowCreateFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.permission#" property="allowReadFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.permission#" property="allowUpdateFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.permission#" property="allowDeleteFlag" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>