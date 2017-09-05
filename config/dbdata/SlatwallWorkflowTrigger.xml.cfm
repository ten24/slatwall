<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwWorkflowTrigger">
	<Columns>
		<column name="workflowTriggerID" fieldtype="id" />
		<column name="triggerType" update="false"/>
		<column name="triggerEvent" update="false"/>
		<column name="startDateTime" update="false"/>
		<column name="workflowID" fieldtype="id" />
		<column name="scheduleID" fieldtype="id" />
		<column name="scheduleCollectionID" fieldtype="id" />
	</Columns>
	<Records>
		<Record workflowTriggerID="4028289a5507d1dc01557e0718c30809" triggerType="Event" triggerEvent="afterFormResponseSaveSuccess" startDateTime="2016-01-01 12:00:00" workflowID="4028289a5507d1dc01557e0718b30808" />
		<Record workflowTriggerID="f80aaac73fc84ee7a7d53962c641f653" triggerType="Event" triggerEvent="afterOrderProcess_placeOrderSuccess" startDateTime="2016-01-01 12:00:00" workflowID="c74704ef385a4ad1949b554086fcd80b" />
		<Record workflowTriggerID="3130ad06932948d38bf37e7a5c27a435" triggerType="Event" triggerEvent="afterOrderDeliveryProcess_createSuccess" startDateTime="2016-01-01 12:00:00" workflowID="46d8e458b7dd4aa9876ce62b33e9e43f" />
        <Record workflowTriggerID="0089415672933e4687bbb92af51cbd04" triggerType="Schedule" startDateTime="2016-01-01 12:00:00" workflowID="d88c69962515821c6203bbbb8e0c1407" scheduleID="f92f7288669c5ad9590b5cd44eb3c11d" scheduleCollectionID="db4327e506000fde08cc4855fa14448b" />
	</Records>
</Table>
