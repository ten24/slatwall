<cfparam name="rc.vendor" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.vendor#" property="vendorName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.vendor#" property="accountNumber" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.vendor#" property="vendorWebsite" edit="#rc.edit#">
			
			<input type="hidden" name="primaryEmailAddress.vendorEmailAddressID" value="#rc.Vendor.getPrimaryEmailAddress().getVendorEmailAddressID()#" />
			<cf_HibachiPropertyDisplay object="#rc.Vendor.getPrimaryEmailAddress()#" property="emailAddress" fieldName="primaryEmailAddress.emailAddress" edit="#rc.edit#" valueLink="mailto:#rc.Vendor.getEmailAddress()#">
			
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>