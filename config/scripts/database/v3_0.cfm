<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->

<cfset local.scriptHasErrors = false />

<!--- Move old mura settings into integration --->
<cftry>
	<cfquery name="local.oldmurasetting">
		UPDATE
			SlatwallSetting
		SET
			settingName = 'integrationMuraLegacyShoppingCart'
		WHERE
			settingName = 'globalPageShoppingCart'
	</cfquery>
	<cfquery name="local.oldmurasetting">
		UPDATE
			SlatwallSetting
		SET
			settingName = 'integrationMuraLegacyOrderStatus'
		WHERE
			settingName = 'globalPageOrderStatus'
	</cfquery>
	<cfquery name="local.oldmurasetting">
		UPDATE
			SlatwallSetting
		SET
			settingName = 'integrationMuraLegacyOrderConfirmation'
		WHERE
			settingName = 'globalPageOrderConfirmation'
	</cfquery>
	<cfquery name="local.oldmurasetting">
		UPDATE
			SlatwallSetting
		SET
			settingName = 'integrationMuraLegacyMyAccount'
		WHERE
			settingName = 'globalPageMyAccount'
	</cfquery>
	<cfquery name="local.oldmurasetting">
		UPDATE
			SlatwallSetting
		SET
			settingName = 'integrationMuraLegacyCreateAccount'
		WHERE
			settingName = 'globalPageCreateAccount'
	</cfquery>
	<cfquery name="local.oldmurasetting">
		UPDATE
			SlatwallSetting
		SET
			settingName = 'integrationMuraLegacyCheckout'
		WHERE
			settingName = 'globalPageCheckout'
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Moving old Mura Settings Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Add Active Flag Where needed --->
<cftry>
	<cfquery name="local.activeflag">
		UPDATE
			SlatwallAccountPaymentMethod
		SET
			activeFlag = 1
		WHERE
			activeFlag is null
	</cfquery>
	
	<cfquery name="local.activeflag">
		UPDATE
			SlatwallSku
		SET
			activeFlag = 1
		WHERE
			activeFlag is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - setting default activeFlag Has Errors">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Add other default flags --->
<cftry>
	<cfquery name="local.flag">
		UPDATE
			SlatwallOrderFulfillment
		SET
			manualFulfillmentChargeFlag = 0
		WHERE
			manualFulfillmentChargeFlag is null
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - setting default flags Has Errors">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Allow for nulls in order payments --->
<cftry>
	<cfquery name="local.allowNull">
		<cfif getApplicationValue("databaseType") eq "MySQL">
			ALTER TABLE SlatwallOrderPayment MODIFY COLUMN amount decimal(19,2) NULL
		<cfelse>
			ALTER TABLE SlatwallOrderPayment ALTER COLUMN amount decimal(19,2) NULL
		</cfif>
	</cfquery>
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Allowing nulls in Order Payments">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v3_0 had errors when running">
	<cfthrow detail="Part of Script v3_0 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v3_0 has run with no errors">
</cfif>