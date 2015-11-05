<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.email" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.email#" property="emailSubject" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.email#" property="emailTo" edit="#rc.edit#">
		</hb:HibachiPropertyList>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.email#" property="relatedObject" edit="false">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>