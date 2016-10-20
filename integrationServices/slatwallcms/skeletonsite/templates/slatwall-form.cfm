<cfimport prefix="sw" taglib="/Slatwall/public/tags" />
<cfoutput>
	<cfif !isNull(request.context.requestedForm.getFormName())>
		<h1>#request.context.requestedForm.getFormName()#</h1>
	</cfif>
	<form name="#request.context.requestedForm.getFormCode()#" action="?slatAction=public:form.addFormResponse" enctype='application/json' method="POST">
		<input type="hidden" name="formResponse.formID" value="#request.context.requestedForm.getFormID()#" />
		<input type="hidden" name="sRedirectURL" value="#arguments.sRedirectUrl#" />
		<input type="hidden" name="context" value="addFormResponse" />
		<sw:AttributeSetDisplay entity="#request.context.newFormResponse#" attributeSet="#request.context.requestedForm#" edit="true" />
		<!--- 
		getting recaptcha to work:
		1. go to settings and site settings
		2. enter the following
			siteRecaptchaSiteKey - aquired from google RECAPTCHA 
			siteRecaptchaSecretKey - aquired from google RECAPTCHA
			siteRecaptchaProtectedEvents - this is a list of events that recaptcha will be enforced against
		3. in the form you are enforcing against drop the <sw:Recaptcha /> tag inside like below
		
		
		NOTE: if recaptcha fails then the entity will have an error of 'recaptchaFailed'
		--->
		<!---
		<sw:Recaptcha />
		 --->
		<input type="submit" value="Submit">
	</form>
</cfoutput>

