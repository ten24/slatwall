<cfparam name="email" type="any" />	
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="orderTemplate" type="any" />

<cfset accountType = orderReturn.getAccount().getAccountType() ?: 'customer' />

<cfinclude template="../inc/base.cfm" />