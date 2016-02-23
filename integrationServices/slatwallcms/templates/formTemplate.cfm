<cfimport prefix="swa" taglib="../../../tags" />
<cfoutput>
<form name="formResponse" action="?slatAction=api:public.post&processContext=create" enctype='application/json' method="POST">
<input type="hidden" name="formResponse.formID" value="#requestedForm.getFormID()#" />
<input type="hidden" name="slatAction" value="processFormResponse_Create" />
<input type="hidden" name="sRedirectURL" value="#sRedirectUrl#" />
<swa:SlatwallAdminAttributeSetDisplay attributeSet="#requestedForm#" hibachiScope="#getHibachiScope()#" edit="true" />
<input type="submit" value="Submit">
</form>
</cfoutput>