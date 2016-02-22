<cfimport prefix="swa" taglib="../../../tags" />
<cfoutput>
<form name="formResponse" action="?slatAction=api:public.post&process=" enctype='application/json' method="POST">
<input type="hidden" name="formResponse.formID" value="#requestedForm.getFormID()#" />
<input type="hidden" name="processContext" value="create" />
<input type="hidden" name="sRedirectURL" value="#sRedirectUrl#" />
<swa:SlatwallAdminAttributeSetDisplay attributeSet="#requestedForm#" hibachiScope="#getHibachiScope()#" edit="true" />
<input type="submit" value="Submit">
</form>
</cfoutput>