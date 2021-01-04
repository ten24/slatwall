<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.importermapping" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<div class="col-md-6">
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<hb:HibachiPropertyDisplay object="#rc.importermapping#" property="name" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.importermapping#" property="description" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.importermapping#" property="baseObject" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.importermapping#" property="mapping" edit="#rc.edit#">
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
	</div>
</cfoutput>
