<cfparam name="email" type="any" />	
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="orderTemplate" type="any" />

<cfif not isNull(orderTemplate.getAccount()) >	

	<cfset accountType = orderTemplate.getAccount().getAccountType() ?: 'customer' />

	<cfinclude template="../inc/base.cfm" />

</cfif> 
