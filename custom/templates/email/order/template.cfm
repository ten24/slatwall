<cfparam name="email" type="any" />	
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="order" type="any" />

<cfset accountType = (NOT isNull(order.getAccount()) AND order.getAccount().getAccountType()) ? order.getAccount().getAccountType() : 'customer' />

<cfinclude template="../inc/base.cfm" />
