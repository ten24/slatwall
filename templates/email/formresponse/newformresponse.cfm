<cfparam name="email" type="any" />
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="formResponse" type="any" />

<cfsilent>
    <cfif !isNull(formResponse.getForm()) && !isNull(formResponse.getForm().getEmailTo())>
        <cfset email.setEmailTo(formResponse.getForm().getEmailTo()) />
    </cfif>
    <cfset email.setEmailSubject("Form Submission") />
</cfsilent>


<cfsavecontent variable="emailData.emailBodyHTML">
    <cfoutput>

    <h1>You Have a new Form Submission!</h1>
    <ul>
        <cfloop index="local.value" array="#formResponse.getAttributeValues()#">
            <li>#value.getAttribute().getAttributeCode()# : #value.getAttributeValue()#</li> 
        </cfloop>
    </ul>

    </cfoutput>
</cfsavecontent>
<cfsavecontent variable="emailData.emailBodyText"> 
    =============================================
    You have a new Form Submission!
    ============================================
    <cfloop index="local.value" array="#formResponse.getAttributeValues()#">
        #value.getAttribute().getAttributeCode()# : #value.getAttributeValue()#
    </cfloop>
</cfsavecontent> 
