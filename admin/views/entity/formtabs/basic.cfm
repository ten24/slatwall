<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.form" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
		    <hb:HibachiPropertyDisplay object="#rc.form#" property="formName" edit="#rc.edit#" />
			<hb:HibachiPropertyDisplay object="#rc.form#" property="formCode" edit="#rc.edit#" />
			<hb:HibachiPropertyDisplay object="#rc.form#" property="emailTo" edit="#rc.edit#" />
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
