<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwIntegrati">
	<Columns>
		<column name="integrationID" fieldtype="id" />
		<column name="activeFlag" datatype="bit" update="false" />
		<column name="integrationPackage"  update="false"/>
		<column name="integrationName"  update="false"/>
		<column name="integrationTypeList"  update="false"/>
	</Columns>
	<Records>
		<Record integrationID="2c9180877706eff2017706f04bb30006" activeFlag="1" integrationPackage="slatwallimporter" integrationName="Slatwall Importer" integrationTypeList="fw1,Importer" />
		<Record integrationID="2c918086754df90601754df93fd60005" activeFlag="1" integrationPackage="slatwallmockpayment" integrationName="Slatwall Mock Payment" integrationTypeList="payment" />
		<Record integrationID="2c9280847812cd58017812cd9b2e0001" activeFlag="1" integrationPackage="slatwallProductSearch" integrationName="Slatwall Product Search" integrationTypeList="fw1,search" />
	</Records>
</Table>
