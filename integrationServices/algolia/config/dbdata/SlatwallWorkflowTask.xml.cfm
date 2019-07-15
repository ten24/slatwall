<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwWorkflowTask" dependencies="/integrationServices/algolia/config/dbdata/SlatwallWorkflow.xml.cfm">
	<Columns>
		<column name="workflowTaskID" fieldtype="id" />
		<column name="activeFlag" update="false" datatype="bit" />
		<column name="taskName" update="false" />
		<column name="taskConditionsConfig" update="false" />
		<column name="workflowID" update="false"/>
	</Columns>
	<Records>
		<Record workflowTaskID="09b009640ab3e4acb2d33acf2fa25ef9" activeFlag="1" taskName="Re-index Algolia" taskConditionsConfig='{"filterGroups":[{"filterGroup":[]}],"baseEntityAlias":"_dataresource","baseEntityName":"DataResource"}' workflowID="09a47aa5f516c34d63a7fa4e521cfab3" />
	</Records>
</Table>
