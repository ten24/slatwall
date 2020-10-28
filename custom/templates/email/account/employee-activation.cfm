<cfif LEFT(cgi['request_url'],5) == 'https'>
    <cfset local.siteLink = 'https://' />
<cfelse>
    <cfset local.siteLink = 'http://' />
</cfif>
<cfset local.siteLink &= cgi['http_host'] />
<cfset local.activationCode = getHibachiScope().getService('MonatUtilityService').getAccountActivationCode(account) />
<cfset local.accountActivationLink = '#local.siteLink#?slatAction=monat:entity.activateAccount&code=#local.activationCode#'>
<cfoutput>
    #local.accountActivationLink#
</cfoutput>