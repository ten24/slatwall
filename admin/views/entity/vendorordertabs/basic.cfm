<cfparam name="rc.vendorOrder" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.vendorOrder#" edit="#rc.edit#">
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cfif rc.vendorOrder.isNew()>
					<cf_HibachiPropertyDisplay object="#rc.vendorOrder#" property="currencyCode" edit="true">
				</cfif>
				<cf_HibachiPropertyDisplay object="#rc.vendorOrder#" property="vendor" autocompletePropertyIdentifiers="vendorName,vendorWebsite,accountNumber,primaryEmailAddress.emailAddress" fieldtype="textautocomplete" edit="#rc.vendorOrder.isNew()#">
				<cf_HibachiPropertyDisplay object="#rc.vendorOrder#" property="vendorOrderNumber" edit="#rc.vendorOrder.isNew()#">
				<cf_HibachiPropertyDisplay object="#rc.vendorOrder#" property="estimatedReceivalDateTime" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.vendorOrder#" property="billToLocation" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
	</cf_HibachiEntityDetailForm>
</cfoutput>