<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwWorkflowTrigger" dependencies="/integrationServices/algolia/config/dbdata/SlatwallWorkflow.xml.cfm">
	<Columns>
		<column name="workflowTriggerID" fieldtype="id" />
		<column name="triggerType" update="false"/>
		<column name="triggerEvent" update="false"/>
		<column name="startDateTime" update="false"/>
		<column name="workflowID" update="false" />
		<column name="scheduleID" update="false"/>
		<column name="runningFlag" update="false" datatype="bit"/>
		<column name="timeout" update="false"/>
		<column name="scheduleCollectionID" update="false"/>
	</Columns>
	<Records>
		<Record workflowTriggerID="09b927f0ba149c9e45cda3ce9867e7a0" triggerType="Schedule" startDateTime="2016-01-01 12:00:00" workflowID="09a47aa5f516c34d63a7fa4e521cfab3" scheduleID="a7379771019d044026ae978809e1fd3d" timeout="90" scheduleCollectionID="37702ab8e559df9e01686cc600a82f5a"/>
	</Records>
</Table>
