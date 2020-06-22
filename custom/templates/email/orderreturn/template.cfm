<cfparam name="email" type="any" />	
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="order" type="any" />
<script src="#request.slatwallScope.getBaseURL()#/custom/assets/js/JsBarcode.all.min.js"></script>

<cfset accountType = order.getAccount().getAccountType() ?: 'customer' />

<cfinclude template="../inc/base.cfm" />
