<cfparam name="email" type="any" />	
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="orderDelivery" type="any" />

<cfset accountType = orderDelivery.getAccount().getAccountType() ?: 'customer' />

<cfinclude template="../inc/base.cfm" />