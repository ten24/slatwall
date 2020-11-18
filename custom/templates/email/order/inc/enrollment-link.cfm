<cfscript>
var accountType = local.order.getAccountType();
if(accountType == 'marketPartner'){
    accountType = 'market-partner';
}

if(listFindNoCase('market-partner,VIP',accountType)){
    var redirectURL = 'enrollment/' & accountType & '/enroll/';
}else{
    var redirectURL = 'shopping-cart/';
}

redirectURL &= '?enrollmentCode=#local.order.getOrderID()#';
</cfscript>
<cfoutput>#redirectURL#</cfoutput>