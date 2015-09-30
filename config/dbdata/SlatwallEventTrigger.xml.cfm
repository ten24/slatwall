<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwEventTrigger">
	<Columns>
		<column name="eventTriggerID" fieldtype="id" />
		<column name="eventTriggerName" update="false" />
		<column name="eventTriggerType" update="false" />
		<column name="eventTriggerObject" update="false" />
		<column name="eventName" update="false" />
		<column name="printTemplateID" update="false" />
		<column name="emailTemplateID" update="false" />
	</Columns>
	<Records>
		<Record eventTriggerID="7d4a464cb2e95da8421c15da9bd6f5e8" eventTriggerName="Send Order Confirmation When Placed" eventTriggerType="email" eventTriggerObject="Order" eventName="afterOrderProcess_placeOrderSuccess" emailTemplateID="dbb327e506090fde08cc4855fa14448d" />
		<Record eventTriggerID="7d4a464dcd702f7fb37ef7d4b3356c3e" eventTriggerName="Send Delivery Confirmation When Fulfilled" eventTriggerType="email" eventTriggerObject="OrderDelivery" eventName="afterOrderDeliveryProcess_createSuccess" emailTemplateID="dbb327e694534908c60ea354766bf0a8" />
		<Record eventTriggerID="4028288b4ed11133014ee47b9b7404d5" eventTriggerName="Send Gift Card to Recipient When Credited" eventTriggerType="email" eventTriggerObject="GiftCard" eventName="afterGiftCardProcess_CreateSuccess" emailTemplateID="4028288b4ed11133014ee4950c6a04db" />
		<Record eventTriggerID="402828d1501506f901501f527b010177" eventTriggerName="Send Failure Notification When Gift Recipient Email Bounces" eventTriggerType="email" eventTriggerObject="GiftCard" eventName="afterGiftCardProcess_FailedRecipientSuccess" emailTemplateID="402828d1501506f901501f4eec180174">
	</Records>
</Table>