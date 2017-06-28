<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.app" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiEntityProcessForm entity="#rc.app#" edit="#rc.edit#">
		
		<hb:HibachiEntityActionBar type="preprocess" object="#rc.app#">
		</hb:HibachiEntityActionBar>
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<!--- General Details --->
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="appName" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="appCode" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="createAppTemplatesFlag" edit="#rc.edit#">
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		
	</hb:HibachiEntityProcessForm>
</cfoutput>

