<cfscript>
var accountType = local.order.getAccountType();
if(accountType == 'marketPartner'){
    accountType = 'market-partner';
}

var redirectURL = 'enrollment/' & accountType & '/enroll/?enrollmentCode=#local.order.getOrderID()#';

</cfscript>
<cfoutput>#redirectURL#</cfoutput>