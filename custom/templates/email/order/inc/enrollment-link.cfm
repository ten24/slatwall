<cfsilent>
    <cfscript>
    var enrollmentType = local.order.getMonatOrderType();
    var redirectUrl = 'enrollment/';
    if( !isNull(enrollmentType) ){
        enrollmentType = enrollmentType.getTypeCode();
        if(enrollmentType == 'motMpEnrollment'){
            redirectUrl &= 'market-partner/enroll/';
        }else{
            redirectUrl &= 'vip/enroll/';
        }
    }else{
        redirectUrl == 'shopping-cart/';
    }
    
    redirectURL &= '?enrollmentCode=#local.order.getOrderID()#';
    </cfscript>
</cfsilent><cfoutput>#trim(redirectURL)#</cfoutput>