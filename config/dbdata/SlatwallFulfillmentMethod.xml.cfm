<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwFulfillmentMethod">
	<Columns>
		<column name="fulfillmentMethodID" fieldtype="id" />
		<column name="fulfillmentMethodName" update="false" />
		<column name="fulfillmentMethodType" />
		<column name="activeFlag" update="false" datatype="bit" />
		<column name="autoFulfillFlag" update="false" datatype="bit" />
	</Columns>
	<Records>
		<Record fulfillmentMethodID="444df2fb93d5fa960ba2966ba2017953" fulfillmentMethodName="Shipping" fulfillmentMethodType="shipping" activeFlag="1" autoFulfillFlag="0" />
		<Record fulfillmentMethodID="444df2ffeca081dc22f69c807d2bd8fe" fulfillmentMethodName="Auto" fulfillmentMethodType="auto" activeFlag="1" autoFulfillFlag="1" />
		<Record fulfillmentMethodID="444df300bf377327cd0e44f4b16be38e" fulfillmentMethodName="Attend Event" fulfillmentMethodType="attend" activeFlag="1" autoFulfillFlag="0" />
		<Record fulfillmentMethodID="4028288b4f8438a1014f8477188f0095" fulfillmentMethodName="Email" fulfillmentMethodType="email" activeFlag="1" autoFulfillFlag="1" />
	</Records>
</Table>