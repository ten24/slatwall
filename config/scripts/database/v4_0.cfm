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

<cfset local.scriptHasErrors = false />

<!--- Update SwAttribute to move attributeTypeID to attributeType --->
<cftry>

	<cfdbinfo type="Columns" name="local.typeColumns" table="SwType" datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" />

	<cfquery name="local.hasColumn" dbtype="query">
		SELECT
			*
		FROM
			typeColumns
		WHERE
			LOWER(COLUMN_NAME) = 'type'
	</cfquery>

	<cfif local.hasColumn.recordCount>
		<cfquery name="local.updateData">
			<cfif getApplicationValue('databaseType') eq "Oracle10g">
				UPDATE SwType SET SwType.typeName = SwType."type" WHERE SwType.typeName is null and SwType."type" is not null
			<cfelse>
				UPDATE SwType SET SwType.typeName = SwType.type WHERE SwType.typeName is null and SwType.type is not null
			</cfif>
		</cfquery>
	</cfif>

	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update type to move the 'type' column to 'typeName'">
		<cfset local.scriptHasErrors = true />
	</cfcatch>

</cftry>

<!--- Update SwOrder to set referencedOrder Type to "Return" --->
<cftry>
	<cfquery name="local.updateData">
		UPDATE
			SwOrder
		SET
			referencedOrderType = 'return'
		WHERE
			referencedOrderType IS NULL
		AND
			referencedOrderID IS NOT NULL
	</cfquery>

	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update order to set referencedOrderType to Return">
		<cfset local.scriptHasErrors = true />
	</cfcatch>

</cftry>

<!--- Update SwSku to set bundleFlag to 0 --->
<cftry>
	<cfquery name="local.updateData">
		UPDATE
			SwSku
		SET
			bundleFlag = 0
		WHERE
			bundleFlag IS NULL
	</cfquery>

	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update sku to set bundleFlag to 0">
		<cfset local.scriptHasErrors = true />
	</cfcatch>

</cftry>

<!--- Update SwSku to set eventCapacity to 1 --->
<cftry>
	<cfquery name="local.updateData">
		UPDATE
			SwSku
		SET
			eventCapacity = 1
		WHERE
			eventCapacity IS NULL
	</cfquery>

	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update sku to set eventCapacity to 1">
		<cfset local.scriptHasErrors = true />
	</cfcatch>

</cftry>

<!--- Set SwOrderFulfillment orderFulfillmentStatusTypeID --->
<cftry>
	<cfquery name="local.updateData">
		UPDATE
			SwOrderFulfillment
		SET
			orderFulfillmentStatusTypeID = (
				SELECT CASE
					WHEN min(oi.quantity) - sum(odi.quantity) = 0 THEN '159118d67de3418d9951fc629688e194'
					WHEN min(oi.quantity) - sum(odi.quantity) > 0 THEN 'fefc92c1d8184017aa65cdc882bdf636'
					ELSE 'b718b6fadf084bdaa01e47f5cc1a8265'
				END
				FROM SwOrderItem oi
					LEFT JOIN SwOrderDeliveryItem odi ON odi.orderItemID = oi.orderItemID
				WHERE oi.orderFulfillmentID = SwOrderFulfillment.orderFulfillmentID
       		)
	</cfquery>

	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Set orderFulfillment orderFulfillmentStatusType">
		<cfset local.scriptHasErrors = true />
	</cfcatch>

</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v4_0 had errors when running">
	<cfthrow detail="Part of Script v4_0 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v4_0 has run with no errors">
</cfif>
