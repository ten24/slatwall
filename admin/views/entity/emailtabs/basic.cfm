<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.email" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.email#" property="emailSubject" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.email#" property="emailTo" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.email#" property="emailFrom" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.email#" property="emailCC" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.email#" property="emailBCC" edit="false">
		</hb:HibachiPropertyList>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.email#" property="relatedObject" edit="false">	
			<hb:HibachiActionCaller action="admin:entity.detail#rc.email.getRelatedObject()#" querystring="#rc.email.getRelatedObjectPrimaryIDPropertyName()#=#rc.email.getRelatedObjectID()#" text="#rc.email.getRelatedObjectID()#">
			<hb:HibachiPropertyDisplay object="#rc.email#" property="createdDateTime" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.email#" property="emailFailTo" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.email#" property="emailReplyTo" edit="false">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
