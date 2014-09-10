<cfparam name="rc.permissionGroup" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.permissionGroup#" edit="#rc.edit#">
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.permissionGroup#" property="permissionGroupName" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
	</cf_HibachiEntityDetailForm>
</cfoutput>