<cfparam name="email" type="any" />	
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="emailTemplate" type="any" />
<cfparam name="emailTemplateObject" type="any" />

<cfscript>
    
    var accountPropertyIdentifier = emailTemplate.setting('emailAccountPropertyIdentifier')
    if( Len(Trim(accountPropertyIdentifier)) ){
        var account =  emailTemplateObject.getValueByPropertyIdentifier(accountPropertyIdentifier); 
    } else if(emailTemplateObject.getClassName() == "Account" ) {
        var account = emailTemplateObject;
    } 
    if(isNull(account)){
        throw("you need to set proper value in EmailTemplateSettings for *accountPropertyIdentifier*");
    }
    
</cfscript> 

<cfinclude template="./inc/base.cfm" />