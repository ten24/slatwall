<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwEmailTemplate">
	<Columns>
		<column name="emailTemplateID" fieldtype="id" />
		<column name="emailTemplateName" update="false" />
		<column name="emailTemplateObject" update="false" />
		<column name="emailTemplateFile" update="false" />
		<column name="emailBodyHTML" update="false" />
		<column name="emailBodyText" update="false" />
		<column name="logEmailFlag" datatype="bit" update="false" />
	</Columns>
	<Records>
		<Record emailTemplateID="dbb327e506090fde08cc4855fa14448d" emailTemplateName="Order Confirmation" emailTemplateObject="Order" emailTemplateFile="confirmation.cfm" />
		<Record emailTemplateID="4028289a5507d1dc0155521cc93c03d1" emailTemplateName="New Form Response" emailTemplateObject="FormResponse" emailTemplateFile="newformresponse.cfm" />
		<Record emailTemplateID="dbb327e694534908c60ea354766bf0a8" emailTemplateName="Order Delivery Confirmation" emailTemplateObject="OrderDelivery" emailTemplateFile="confirmation.cfm" />
		<Record emailTemplateID="dbb327e796334dee73fb9d8fd801df91" emailTemplateName="Forgot Password" emailTemplateObject="Account" emailTemplateFile="forgotpassword.cfm" />
		<Record emailTemplateID="61d29dd9f6ca76d9e352caf55500b458" emailTemplateName="Verify Account Email Address" emailTemplateObject="AccountEmailAddress" emailBodyHTML="IMPORTANT NOTE: THIS LINK NEEDS TO BE POINTED TO A PAGE ON YOUR SITE WHERE YOU WANT USERS TO BE SENT WHEN THEY VERIFY THEIR EMAIL AND THIS TEXT NEEDS TO BE REMOVED - Please verify your account email address by clicking on the following link: http://www.mySlatwallSite.com/?slatAction=public:account.verifyAccountEmailAddress&accountEmailAddressID=${accountEmailAddressID}&verificationCode=${verificationCode}" />
		<Record emailTemplateID="645fce4ea1c24a3a9dce5ca66c7c9ff6" emailTemplateName="Verify Account Primary Email Address" emailTemplateObject="Account" emailBodyHTML="IMPORTANT NOTE: THIS LINK NEEDS TO BE POINTED TO A PAGE ON YOUR SITE WHERE YOU WANT USERS TO BE SENT WHEN THEY VERIFY THEIR EMAIL AND THIS TEXT NEEDS TO BE REMOVED - Thank you for creating an account, in order to complete the processes we need you to verify your email address by clicking on the following link: http://www.mySlatwallSite.com/?slatAction=public:account.verifyAccountEmailAddress&accountEmailAddressID=${primaryEmailAddress.accountEmailAddressID}&verificationCode=${primaryEmailAddress.verificationCode}" />
		<Record emailTemplateID="dbb327eae59c2605eba6ac9a735007b5" emailTemplateName="Subscription Renewal Reminder" emailTemplateObject="SubscriptionUsage" emailBodyHTML="Your subscription needs to be renewed for: ${simpleRepresentation}" />
		<Record emailTemplateID="dbb327e9ac9051b06c902de4bf83eaa8" emailTemplateName="Task Failure Notification" emailTemplateObject="Task" emailBodyHTML="The task '${taskName}' failed to complete successfully.  Please login to your Slatwall administrator to view the task history details." />
		<Record emailTemplateID="dbb327e89546f9916ed8316f4fcc70e1" emailTemplateName="Task Success Notification" emailTemplateObject="Task" emailBodyHTML="The task '${taskName}' completed successfully." />
		<Record emailTemplateID="4028288b4ed11133014ee4950c6a04db" emailTemplateName="Gift Card Credited" emailTemplateObject="GiftCard" emailBodyHTML="Your Gift Card has been credited!${orderItemGiftRecipient.giftMessage} Code: ${giftCardCode} Balance: ${balanceAmount}" emailBodyText="Your Gift Card has been credited! ${orderItemGiftRecipient.giftMessage} Code: ${giftCardCode}Balance: ${balanceAmount}" logEmailFlag="1" />
		<Record emailTemplateID="402828d1501506f901501f4eec180174" emailTemplateName="Failed Gift Card Recipient" emailTemplateObject="GiftCard" emailBodyHTML="A Gift Card Sent To ${orderItemGiftRecipient.EmailAddress} Has Failed. Below are the details of the gift card that failed to send. Code: ${giftCardCode} Balance: ${balanceAmount}" emailBodyText="${orderItemGiftRecipient.EmailAddress} Has Failed Below are the details of the gift card that failed to send. Code: ${giftCardCode} Balance: ${balanceAmount}" logEmailFlag="1" />
	</Records>
</Table>
