<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwEmailTemplate">
	<Columns>
		<column name="emailTemplateID" fieldtype="id" />
		<column name="emailTemplateName" update="false" />
		<column name="emailTemplateObject" update="false" />
		<column name="emailTemplateFile" update="false" />
		<column name="emailBodyHTML" update="false" />
		<column name="emailBodyText" update="false" />
	</Columns>
	<Records>
		<Record emailTemplateID="dbb327e506090fde08cc4855fa14448d" emailTemplateName="Order Confirmation Template" emailTemplateObject="Order" emailTemplateFile="confirmation.cfm" />
		<Record emailTemplateID="dbb327e694534908c60ea354766bf0a8" emailTemplateName="Order Delivery Confirmation Template" emailTemplateObject="OrderDelivery" emailTemplateFile="confirmation.cfm" />
		<Record emailTemplateID="dbb327e796334dee73fb9d8fd801df91" emailTemplateName="Forgot Password Template" emailTemplateObject="Account" emailTemplateFile="forgotpassword.cfm" />
		<Record emailTemplateID="dbb327eae59c2605eba6ac9a735007b5" emailTemplateName="Subscription Renewal Reminder" emailTemplateObject="SubscriptionUsage" emailBodyHTML="Your subscription needs to be renewed for: ${simpleRepresentation}" />
		<Record emailTemplateID="dbb327e9ac9051b06c902de4bf83eaa8" emailTemplateName="Task Failure Notification" emailTemplateObject="Task" emailBodyHTML="The task '${taskName}' failed to complete successfully.  Please login to your Slatwall administrator to view the task history details." />
		<Record emailTemplateID="dbb327e89546f9916ed8316f4fcc70e1" emailTemplateName="Task Success Notification" emailTemplateObject="Task" emailBodyHTML="The task '${taskName}' completed successfully." />
	</Records>
</Table>
