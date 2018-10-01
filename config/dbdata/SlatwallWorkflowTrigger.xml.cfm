<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwWorkflowTrigger" dependencies="/config/dbdata/SlatwallWorkflow.xml.cfm">
	<Columns>
		<column name="workflowTriggerID" fieldtype="id" />
		<column name="triggerType" update="false"/>
		<column name="triggerEvent" update="false"/>
		<column name="startDateTime" update="false"/>
		<column name="workflowID" update="false" />
		<column name="scheduleID" update="false"/>
		<column name="runningFlag" update="false" datatype="bit"/>
		<column name="timeout" update="false"/>
	</Columns>
	<Records>
		<Record workflowTriggerID="4028289a5507d1dc01557e0718c30809" triggerType="Event" triggerEvent="afterFormResponseSaveSuccess" startDateTime="2016-01-01 12:00:00" workflowID="4028289a5507d1dc01557e0718b30808" />
		<Record workflowTriggerID="f80aaac73fc84ee7a7d53962c641f653" triggerType="Event" triggerEvent="afterOrderProcess_placeOrderSuccess" startDateTime="2016-01-01 12:00:00" workflowID="c74704ef385a4ad1949b554086fcd80b" />
		<Record workflowTriggerID="3130ad06932948d38bf37e7a5c27a435" triggerType="Event" triggerEvent="afterOrderDeliveryProcess_createSuccess" startDateTime="2016-01-01 12:00:00" workflowID="46d8e458b7dd4aa9876ce62b33e9e43f" />
		<Record workflowTriggerID="a8bcb9a9e2e52981cea92c599170e052" triggerType="Schedule" startDateTime="2016-01-01 12:00:00" workflowID="a6c7740cb58189c914c2b2528aec7c1d" scheduleID="a7379771019d044026ae978809e1fd3d"  timeout="90" />
	</Records>
</Table>
