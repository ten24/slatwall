<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

--->
<cfcomponent accessors="true" persistent="false" output="false" extends="HibachiReport">

	<cffunction name="getReportDateTimeDefinitions">
		<cfreturn [
			{alias='transactionDateTime', dataColumn='SwPaymentTransaction.transactionDateTime', title=rbKey('entity.paymentTransaction.transactionDateTime')},
			{alias='orderOpenDateTime', dataColumn='SwOrder.orderOpenDateTime', title=rbKey('entity.order.orderOpenDateTime')},
			{alias='orderCloseDateTime', dataColumn='SwOrder.orderCloseDateTime', title=rbKey('entity.order.orderCloseDateTime')}
		] />
	</cffunction>

	<cffunction name="getMetricDefinitions">
		<cfreturn [
			{alias='amountReceived', function='sum', formatType="currency", title=rbKey('entity.paymentTransaction.amountReceived')},
			{alias='amountCredited', function='sum', formatType="currency", title=rbKey('entity.paymentTransaction.amountCredited')},
			{alias='amountAuthorized', function='sum', formatType="currency", title=rbKey('entity.paymentTransaction.amountAuthorized')}
		] />
	</cffunction>

	<cffunction name="getDimensionDefinitions">
		<cfreturn [
			{alias='transactionDateTime', title=rbKey('entity.paymentTransaction.transactionDateTime')},
			{alias='createdDateTime', title=rbKey('entity.paymentTransaction.createdDateTime')},
			{alias='paymentTransactionID', title=rbKey('entity.paymentTransaction.paymentTransactionID')},
			{alias='providerTransactionID', title=rbKey('entity.paymentTransaction.providerTransactionID')},
			{alias='authorizationCode', title=rbKey('entity.paymentTransaction.authorizationCode')},
			{alias='authorizationCodeUsed', title=rbKey('entity.paymentTransaction.authorizationCodeUsed')},
			{alias='transactionSuccessFlag', title=rbKey('entity.paymentTransaction.transactionSuccessFlag')},
			{alias='transactionType', title=rbKey('entity.paymentTransaction.transactionType')},
			{alias='currencyCode', title=rbKey('entity.paymentTransaction.currencyCode')},
			{alias='avsCode', title=rbKey('entity.paymentTransaction.avsCode')},
			{alias='relatedObjectType', title="Object Type"},
			{alias='creditCardLastFour', title=rbKey('entity.define.creditCardLastFour')},
			{alias='creditCardType', title=rbKey('entity.define.creditCardType')},
			{alias='expirationMonth', title=rbKey('entity.define.expirationMonth')},
			{alias='expirationYear', title=rbKey('entity.define.expirationYear')},
			{alias='billingStreetAddress', title=rbKey('entity.address.streetAddress')},
			{alias='billingStreet2Address', title=rbKey('entity.address.street2Address')},
			{alias='billingCity', title=rbKey('entity.address.city')},
			{alias='billingStateCode', title=rbKey('entity.address.stateCode')},
			{alias='billingPostalCode', title=rbKey('entity.address.postalCode')},
			{alias='billingCountryCode', title=rbKey('entity.address.countryCode')}
		] />
	</cffunction>

	<cffunction name="getData" returnType="Query">
		<cfif not structKeyExists(variables, "data")>
			<cfquery name="variables.data">
				SELECT
					SwPaymentTransaction.paymentTransactionID,
					SwPaymentTransaction.transactionType,
					SwPaymentTransaction.authorizationCode,
					SwPaymentTransaction.authorizationCodeUsed,
					SwPaymentTransaction.providerTransactionID,
					SwPaymentTransaction.amountAuthorized,
					SwPaymentTransaction.amountReceived,
					SwPaymentTransaction.amountCredited,
					SwPaymentTransaction.createdDateTime,
					SwPaymentTransaction.transactionSuccessFlag,
					SwPaymentTransaction.currencyCode,
					SwPaymentTransaction.avsCode,
					SwPaymentTransaction.transactionDateTime,
					ost.systemCode,
					opst.systemCode,
					CASE
    					WHEN SwPaymentTransaction.orderPaymentID IS NOT NULL THEN 'orderPayment'
						WHEN SwPaymentTransaction.accountPaymentID IS NOT NULL THEN 'accountPayment'
						WHEN SwPaymentTransaction.accountPaymentMethodID IS NOT NULL THEN 'accountPaymentMethod'
						ELSE ''
					END as relatedObjectType,
					COALESCE(SwOrderPayment.creditCardLastFour, SwAccountPayment.creditCardLastFour, SwAccountPaymentMethod.creditCardLastFour, '') as creditCardLastFour,
					COALESCE(SwOrderPayment.creditCardType, SwAccountPayment.creditCardType, SwAccountPaymentMethod.creditCardType, '') as creditCardType,
					COALESCE(SwOrderPayment.expirationMonth, SwAccountPayment.expirationMonth, SwAccountPaymentMethod.expirationMonth, '') as expirationMonth,
					COALESCE(SwOrderPayment.expirationYear, SwAccountPayment.expirationYear, SwAccountPaymentMethod.expirationYear, '') as expirationYear,
					COALESCE(opba.streetAddress, apba.streetAddress, apmba.streetAddress, '') as billingStreetAddress,
					COALESCE(opba.street2Address, apba.street2Address, apmba.street2Address, '') as billingStreet2Address,
					COALESCE(opba.city, apba.city, apmba.city, '') as billingCity,
					COALESCE(opba.stateCode, apba.stateCode, apmba.stateCode, '') as billingStateCode,
					COALESCE(opba.postalCode, apba.postalCode, apmba.postalCode, '') as billingPostalCode,
					COALESCE(opba.countryCode, apba.countryCode, apmba.countryCode, '') as billingCountryCode,
					#getReportDateTimeSelect()#
				FROM
					SwPaymentTransaction
				  LEFT JOIN
				  	SwOrderPayment on SwPaymentTransaction.orderPaymentID = SwOrderPayment.orderPaymentID
				  LEFT JOIN
				  	SwType opst on opst.typeID = SwOrderPayment.orderPaymentStatusTypeID
				  LEFT JOIN
				  	SwOrder on SwOrderPayment.orderID = SwOrder.orderID
				  LEFT JOIN
				  	SwType ost on ost.typeID = SwOrder.orderStatusTypeID
				  LEFT JOIN
				  	SwAddress opba on opba.addressID = SwOrderPayment.billingAddressID
				  LEFT JOIN
				  	SwAccountPayment on SwPaymentTransaction.accountPaymentID = SwAccountPayment.accountPaymentID
				  LEFT JOIN
				  	SwAddress apba on apba.addressID = SwAccountPayment.billingAddressID
                  LEFT JOIN
				  	SwAccountPaymentMethod on SwPaymentTransaction.accountPaymentMethodID = SwAccountPaymentMethod.accountPaymentMethodID
				  LEFT JOIN
				  	SwAddress apmba on apmba.addressID = SwAccountPaymentMethod.billingAddressID
				WHERE
					#getReportDateTimeWhere()#
				AND
					opst.systemCode = 'opstActive'
				AND
					ost.systemCode != 'ostNotPlaced'
			</cfquery>
		</cfif>

		<cfreturn variables.data />
	</cffunction>

</cfcomponent>
