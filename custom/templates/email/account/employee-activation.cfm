<cfif FindNoCase('ten24dev', CGI.SERVER_NAME )>
	<cfset local.siteLink = "http://monat.ten24dev.com/" />
<cfelse>
	<cfset local.siteLink = "https://monatglobal.com/" />
</cfif>
<cfoutput>
    <cfset local.activationCode = getHibachiScope().getService('MonatUtilityService').getAccountActivationCode(account) />
    <cfset local.accountActivationLink = '#local.siteLink#?slatAction=monat:entity.activateAccount&code=#local.activationCode#'>
    <a href="#local.accountActivationLink#">#local.accountActivationLink#</a>
</cfoutput>