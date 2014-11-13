<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.workflow" type="any">
<cfparam name="rc.edit" type="boolean">

<cf_HibachiEntityActionBar type="detail" object="#rc.workflow#" edit="#rc.edit#" />
<form name="form.workflowForm">
	<cf_HibachiEntityDetailGroup object="#rc.workflow#">
			<cf_HibachiEntityDetailItem view="admin:entity/workflowtabs/basic" open="true" text="#$.slatwall.rbKey('admin.define.basic')#" showOnCreateFlag=true />
			<cf_HibachiEntityDetailItem view="admin:entity/workflowtabs/triggers" text="#$.slatwall.rbKey('entity.workflowTrigger_plural')#" showOnCreateFlag=true />
			<cf_HibachiEntityDetailItem view="admin:entity/workflowtabs/tasks" text="#$.slatwall.rbKey('entity.workflowTask_plural')#" showOnCreateFlag=true />
	</cf_HibachiEntityDetailGroup>	
</form>