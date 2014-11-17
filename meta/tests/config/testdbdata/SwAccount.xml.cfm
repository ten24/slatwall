<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwAccount">
	<Columns>
		<column name="accountID" fieldtype="id" />
		<column name="superUserFlag" datatype="bit" />
		<column name="firstName" />
		<column name="lastName" />
		<column name="company" />
		<column name="cmsAccountID" />
		<column name="remoteID" /> 
		<column name="remoteEmployeeID" />
		<column name="remoteCustomerID" />
		<column name="remoteContactID" />
		<column name="primaryEmailAddressID" circular="true" />
		<column name="primaryPhoneNumberID" circular="true" />
		<column name="primaryAddressID" circular="true" />
		<column name="primaryPaymentMethodID" />
	</Columns>
	<Records>
		<Record accountID="c2ba501df62e4115821cc45ef3ec9502" superUserFlag="true" firstName="TestRunnerAccount" lastName="SuperUser" company="TestRunner" primaryEmailAddressID="74e464c69cd34b5eba514fab89839c7c" primaryAddressID="73e80f7e799b4c29a1af5d0dab4fb110" />
	</Records>
</Table>