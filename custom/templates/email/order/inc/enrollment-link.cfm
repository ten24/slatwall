<cfsilent>
    <cfscript>
    var redirectUrl = 'enrollment/resume';
    redirectURL &= '?enrollmentCode=#local.order.getOrderID()#';
    </cfscript>
</cfsilent><cfoutput>#trim(redirectURL)#</cfoutput>