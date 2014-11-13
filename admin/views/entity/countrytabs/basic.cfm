<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.country" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divClass="col-md-6">
			<cf_HibachiPropertyDisplay object="#rc.country#" property="countryCode" edit="#rc.country.getNewFlag()#">
			<cf_HibachiPropertyDisplay object="#rc.country#" property="countryCode3Digit" edit="#rc.country.getNewFlag()#">
			<cf_HibachiPropertyDisplay object="#rc.country#" property="countryISONumber" edit="#rc.country.getNewFlag()#">
			<cf_HibachiPropertyDisplay object="#rc.country#" property="activeFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.country#" property="countryName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.country#" property="defaultCurrency" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.country#" property="streetAddressLabel" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.country#" property="street2AddressLabel" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.country#" property="localityLabel" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.country#" property="cityLabel" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.country#" property="stateCodeLabel" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.country#" property="postalCodeLabel" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>