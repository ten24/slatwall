<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwWorkflow">
	<Columns>
		<column name="workflowID" fieldtype="id" />
		<column name="activeFlag" datatype="bit" update="false" />
		<column name="workflowName"  update="false"/>
		<column name="workflowObject"  update="false"/>
	</Columns>
	<Records>
		<Record workflowID="4028289a5507d1dc01557e0718b30808" activeFlag="1" workflowName="New Form Response" workflowObject="FormResponse" />
		<Record workflowID="c74704ef385a4ad1949b554086fcd80b" activeFlag="1" workflowName="Event Trigger - Send Order Confirmation When Placed" workflowObject="Order" />
		<Record workflowID="46d8e458b7dd4aa9876ce62b33e9e43f" activeFlag="1" workflowName="Event Trigger - Send Delivery Confirmation When Fulfilled" workflowObject="OrderDelivery" />
		<Record workflowID="a6c7740cb58189c914c2b2528aec7c1d" activeFlag="0" workflowName="Create Subscritpion Order Deliveries" workflowObject="Product" />
	</Records>
</Table>
