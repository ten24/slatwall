<cfparam name="email" type="any" />	
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="order" type="any" />
<cfif NOT isNull(order.getAccount())>
    <cfset accountType = order.getAccount().getAccountType() ?: 'customer' />
</cfif>

<cfinclude template="../inc/base.cfm" />
