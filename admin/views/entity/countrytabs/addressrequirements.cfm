<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.country" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.country#" property="streetAddressShowFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.country#" property="street2AddressShowFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.country#" property="localityShowFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.country#" property="cityShowFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.country#" property="stateCodeShowFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.country#" property="postalCodeShowFlag" edit="#rc.edit#">
		</hb:HibachiPropertyList>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.country#" property="streetAddressRequiredFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.country#" property="street2AddressRequiredFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.country#" property="localityRequiredFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.country#" property="cityRequiredFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.country#" property="stateCodeRequiredFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.country#" property="postalCodeRequiredFlag" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>