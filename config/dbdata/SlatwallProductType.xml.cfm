<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwProductType">
	<Columns>
		<column name="productTypeID" fieldtype="id" />
		<column name="parentProductTypeID" />
		<column name="productTypeIDPath" />
		<column name="productTypeName" update="false" />
		<column name="systemCode" />
		<column name="urlTitle" update="false" />
		<column name="activeFlag" datatype="bit" update="false" />
	</Columns>
	<Records>
		<!---<Record productTypeID="29c3530609f4b2ce33c0e8de2d8746e3" productTypeIDPath="29c3530609f4b2ce33c0e8de2d8746e3" parentProductTypeID="NULL" productTypeName="Bundle" systemCode="bundle" urlTitle="bundle" activeFlag="1" />--->
		<Record productTypeID="444df313ec53a08c32d8ae434af5819a" productTypeIDPath="444df313ec53a08c32d8ae434af5819a" parentProductTypeID="NULL" productTypeName="Content Access" systemCode="contentAccess" urlTitle="content-access" activeFlag="1" />
		<Record productTypeID="444df315a963bea00867567110d47728" productTypeIDPath="444df315a963bea00867567110d47728" parentProductTypeID="NULL" productTypeName="Event" systemCode="event" urlTitle="event" activeFlag="1" />
		<Record productTypeID="444df2f7ea9c87e60051f3cd87b435a1" productTypeIDPath="444df2f7ea9c87e60051f3cd87b435a1" parentProductTypeID="NULL" productTypeName="Merchandise" systemCode="merchandise" urlTitle="merchandise" activeFlag="1" />
		<Record productTypeID="444df2f9c7deaa1582e021e894c0e299" productTypeIDPath="444df2f9c7deaa1582e021e894c0e299" parentProductTypeID="NULL" productTypeName="Subscription" systemCode="subscription" urlTitle="subscription" activeFlag="1" />
	</Records>
</Table>