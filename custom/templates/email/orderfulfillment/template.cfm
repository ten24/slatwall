<cfparam name="email" type="any" />	
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="orderFulfillment" type="any" />

<cfset accountType = orderFulfillment.order.getAccount().getAccountType() ?: 'customer' />

<<<<<<< HEAD
<cfinclude template="../inc/base.cfm" />
=======
<cfinclude template="../inc/base.cfm" /> 
>>>>>>> origin/develop-team
