<cfparam name="email" type="any" />	
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="order" type="any" />

<cfset accountType = order.getAccount().getAccountType() ?: 'customer' />

<cfinclude template="../inc/base.cfm" />
