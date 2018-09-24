<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwWorkflowTaskAction" dependencies="/config/dbdata/SlatwallWorkflowTask.xml.cfm,/config/dbdata/SlatwallEmailTemplate.xml.cfm">
	<Columns>
		<column name="workflowTaskActionID" fieldtype="id" />
		<column name="actionType" update="false" />
		<column name="updateData" update="false" />
		<column name="emailTemplateID" update="false"  />
		<column name="workflowTaskID"  update="false" />
		<column name="processMethod" update="false"/>
	</Columns>
	<Records>
		<Record workflowTaskActionID="4028289a5507d1dc01557e261a100815" actionType="email" updateData='{"staticData":{},"dynamicData":{}}' emailTemplateID="4028289a5507d1dc0155521cc93c03d1" workflowTaskID="4028289a5507d1dc01557e2619fa0814" />
		<Record workflowTaskActionID="2f9bfc37806f40149d477661213f84bf" actionType="email" updateData='{"staticData":{},"dynamicData":{}}' emailTemplateID="dbb327e506090fde08cc4855fa14448d" workflowTaskID="6f5520c242e64b0585c3aaf6dd3abe7c" />
		<Record workflowTaskActionID="ca61224520de4a6ca1a0090a35a3184c" actionType="email" updateData='{"staticData":{},"dynamicData":{}}' emailTemplateID="dbb327e694534908c60ea354766bf0a8" workflowTaskID="653124a32e9c4acb94867ceb624cf873" />
		<Record workflowTaskActionID="aa801334ef5a08a789ab150f6a45cd06" actionType="process" updateData='{"staticData":{},"dynamicData":{}}' processMethod="createSubscriptionOrderDeliveries" workflowTaskID="aa74f1619660a5f1018b19452cf24088" />
	</Records>
</Table>
