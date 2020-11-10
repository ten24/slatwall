<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.vendor" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.vendor#" property="vendorName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.vendor#" property="accountNumber" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.vendor#" property="vendorWebsite" edit="#rc.edit#">
			
			<input type="hidden" name="primaryEmailAddress.vendorEmailAddressID" value="#rc.Vendor.getPrimaryEmailAddress().getVendorEmailAddressID()#" />
			<hb:HibachiPropertyDisplay object="#rc.Vendor.getPrimaryEmailAddress()#" property="emailAddress" fieldName="primaryEmailAddress.emailAddress" edit="#rc.edit#" valueLink="mailto:#rc.Vendor.getEmailAddress()#">
			
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>