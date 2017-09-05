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
		<Record workflowTaskID="4028289a5507d1dc01557e2619fa0814" activeFlag="1" taskName="New Form Response" taskConditionsConfig='{"filterGroups":[{"filterGroup":[]}],"baseEntityAlias":"_formresponse","baseEntityName":"FormResponse"}' workflowID="4028289a5507d1dc01557e0718b30808" />
		<Record workflowTaskID="6f5520c242e64b0585c3aaf6dd3abe7c" activeFlag="1" taskName="Send Confirmation Email" taskConditionsConfig='{"filterGroups":[{"filterGroup":[]}],"baseEntityAlias":"_order","baseEntityName":"Order"}' workflowID="c74704ef385a4ad1949b554086fcd80b" />
		<Record workflowTaskID="653124a32e9c4acb94867ceb624cf873" activeFlag="1" taskName="Send Delivery Confirmation Email" taskConditionsConfig='{"filterGroups":[{"filterGroup":[]}],"baseEntityAlias":"_orderdelivery","baseEntityName":"OrderDelivery"}' workflowID="46d8e458b7dd4aa9876ce62b33e9e43f" />
		<Record workflowTaskID="f75a8027c5043b6f720ed041570f8bd9" activeFlag="1" taskName="Process QUEUE" taskConditionsConfig='{"filterGroups":[{"filterGroup":[{"displayPropertyIdentifier":"Processing","propertyIdentifier":"_entityqueue.processingFlag","comparisonOperator":"=","breadCrumbs":[{"rbKey":"Entity Queue","entityAlias":"_entityqueue","cfc":"_entityqueue","propertyIdentifier":"_entityqueue"}],"value":"False","displayValue":"False","ormtype":"boolean","conditionDisplay":"False"}]}],"baseEntityAlias":"_entityqueue","baseEntityName":"EntityQueue"}' workflowID="d88c69962515821c6203bbbb8e0c1407" />
	</Records>
</Table>
