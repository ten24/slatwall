<cfparam name="email" type="any" />	
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="emailTemplate" type="any" />
<cfparam name="emailTemplateObject" type="any" />

<cfscript>
    
    var accountType = emailTemplateObject.getValueByPropertyIdentifier(
            emailTemplate.setting('emailAccountTypePropertyIdentifier')
        ) ?: 'customer';    
</cfscript> 

<cfinclude template="./inc/base.cfm" />