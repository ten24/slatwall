<cfimport prefix="sw" taglib="/Slatwall/public/tags" />
<cfoutput>
<form name="formResponse" action="?slatAction=public:form.addFormResponse" enctype='application/json' method="POST">
<input type="hidden" name="formResponse.formID" value="#requestedForm.getFormID()#" />
<input type="hidden" name="sRedirectURL" value="#arguments.sRedirectUrl#" />
<input type="hidden" name="context" value="addFormResponse" />
<sw:AttributeSetDisplay attributeSet="#requestedForm#" entity="#newFormResponse#" edit="true" />
<input type="submit" value="Submit">
</form>
</cfoutput>