<cfparam name="email" type="any" />	
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="account" type="any" />

<cfset accountType = account.getAccountType() ?: 'customer' />

<cfinclude template="../inc/base.cfm" />