<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.currency" type="any">
<cfparam name="rc.edit" type="boolean">
<cfset local.currencyExists = isNull( $.slatwall.getService('HibachiService').getCurrencyByCurrencyCode(rc.currency.getCurrencyCode()) )/>
<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.currency#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.currency#" property="currencyCode" edit="#local.currencyExists#">
			<hb:HibachiPropertyDisplay object="#rc.currency#" property="currencyName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.currency#" property="currencySymbol" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.currency#" property="formatMask" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.currency#" property="formattedExample">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>