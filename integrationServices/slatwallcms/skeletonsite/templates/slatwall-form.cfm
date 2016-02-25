<cfimport prefix="swa" taglib="/Slatwall/tags" />
<cfoutput>
<form name="formResponse" action="?slatAction=public:form.addFormResponse" enctype='application/json' method="POST">
<input type="hidden" name="formResponse.formID" value="#requestedForm.getFormID()#" />
<input type="hidden" name="sRedirectURL" value="#arguments.sRedirectUrl#" />
<input type="hidden" name="context" value="addFormResponse" />
<swa:SlatwallAdminAttributeSetDisplay attributeSet="#requestedForm#" entity="#newFormResponse#" hibachiScope="#getHibachiScope()#" edit="true" />
<input type="submit" value="Submit">
</form>
</cfoutput>