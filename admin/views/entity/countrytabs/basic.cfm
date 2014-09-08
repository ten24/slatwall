<cfparam name="rc.country" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.country#" edit="#rc.edit#">		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList divClass="col-md-6">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="countryCode" edit="#rc.country.getNewFlag()#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="countryCode3Digit" edit="#rc.country.getNewFlag()#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="countryISONumber" edit="#rc.country.getNewFlag()#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="activeFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="countryName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="streetAddressLabel" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="street2AddressLabel" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="localityLabel" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="cityLabel" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="stateCodeLabel" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="postalCodeLabel" edit="#rc.edit#">
			</cf_HibachiPropertyList>
			<cf_HibachiPropertyList divClass="col-md-3">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="streetAddressShowFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="street2AddressShowFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="localityShowFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="cityShowFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="stateCodeShowFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="postalCodeShowFlag" edit="#rc.edit#">
			</cf_HibachiPropertyList>
			<cf_HibachiPropertyList divClass="col-md-3">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="streetAddressRequiredFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="street2AddressRequiredFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="localityRequiredFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="cityRequiredFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="stateCodeRequiredFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="postalCodeRequiredFlag" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
	</cf_HibachiEntityDetailForm>
</cfoutput>