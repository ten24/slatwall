<cfparam name="rc.accountLoyalty" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.accountLoyalty#" edit="#rc.edit#">		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.accountLoyalty#" property="loyalty" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.accountLoyalty#" property="lifetimeBalance" edit="false">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
	</cf_HibachiEntityDetailForm>
</cfoutput>