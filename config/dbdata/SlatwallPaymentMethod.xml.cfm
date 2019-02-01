<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwPaymentMethod" >
	<Columns>
		<column name="paymentMethodID" fieldtype="id" />
		<column name="paymentMethodName" update="false" />
		<column name="paymentMethodType" />
		<column name="activeFlag" update="false" datatype="bit" />
		<column name="sortOrder" update="false" />
		<column name="allowSaveFlag" update="false" datatype="bit" />
	</Columns>
	<Records>
		<Record paymentMethodID="444df303dedc6dab69dd7ebcc9b8036a" paymentMethodName="Credit Card" paymentMethodType="creditCard" activeFlag="1" sortOrder="1" allowSaveFlag="0" />
		<Record paymentMethodID="50d8cd61009931554764385482347f3a" paymentMethodName="Gift Card" paymentMethodType="giftCard" activeFlag="1" sortOrder="1" allowSaveFlag="0" />
	</Records>
</Table>