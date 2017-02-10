<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwWorkflowTask">
	<Columns>
		<column name="workflowTaskID" fieldtype="id" />
		<column name="activeFlag" update="false" datatype="bit" />
		<column name="taskName" update="false" />
		<column name="taskConditionsConfig" update="false" />
		<column name="workflowID" update="false" />
	</Columns>
	<Records>
		<Record workflowTaskID="4028289a5507d1dc01557e2619fa0814" activeFlag="1" taskName="New Form Response" taskConditionsConfig='{"filterGroups":[{"filterGroup":[]}],"baseEntityAlias":"FormResponse","baseEntityName":"FormResponse"}' workflowID="4028289a5507d1dc01557e0718b30808" />
		<Record workflowTaskID="6f5520c242e64b0585c3aaf6dd3abe7c" activeFlag="1" taskName="Send Confirmation Email" taskConditionsConfig='{"filterGroups":[{"filterGroup":[]}],"baseEntityAlias":"Order","baseEntityName":"Order"}' workflowID="c74704ef385a4ad1949b554086fcd80b" />
		<Record workflowTaskID="653124a32e9c4acb94867ceb624cf873" activeFlag="1" taskName="Send Delivery Confirmation Email" taskConditionsConfig='{"filterGroups":[{"filterGroup":[]}],"baseEntityAlias":"OrderDelivery","baseEntityName":"OrderDelivery"}' workflowID="46d8e458b7dd4aa9876ce62b33e9e43f" />
	</Records>
</Table>
