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

<!--- Move checkout setting --->
<cftry>
	<cfquery name="local.oldmurasettings">
		SELECT
			settingValue,
			paymentMethodID
		FROM
			SwSetting
		WHERE
			settingName = 'paymentMethodCheckoutTransactionType'
	</cfquery>
	
	<cfloop query="local.oldmurasettings">
		<cfif len(local.oldmurasettings.paymentMethodID)>
			<cfquery name="local.updatepaymentmethod">
				UPDATE
					SwPaymentMethod
				SET
					placeOrderChargeTransactionType = '#local.oldmurasettings.settingValue#'
				WHERE
					placeOrderChargeTransactionType is null
				  AND
				  	paymentMethodID = '#local.oldmurasettings.paymentMethodID#'
			</cfquery>
		<cfelse>
			<cfquery name="local.updatepaymentmethod">
				UPDATE
					SwPaymentMethod
				SET
					placeOrderChargeTransactionType = '#local.oldmurasettings.settingValue#'
				WHERE
					placeOrderChargeTransactionType is null
				  AND
				  	paymentMethodType = 'creditCard'
			</cfquery>
		</cfif>
	</cfloop>
	
	<cfquery name="local.removeoldmurasetting">
		DELETE FROM SwSetting WHERE settingName = 'paymentMethodCheckoutTransactionType'	
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Changeing the paymentMethodCheckoutTransactionType setting">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>


<!--- Move store CC w/Order setting --->
<cftry>
	<cfquery name="local.oldmurasettings">
		SELECT
			settingValue,
			paymentMethodID
		FROM
			SwSetting
		WHERE
			settingName = 'paymentMethodStoreCreditCardNumberWithOrder'
	</cfquery>
	
	<cfloop query="local.oldmurasettings">
		<cfif len(local.oldmurasettings.paymentMethodID)>
			<cfquery name="local.updatepaymentmethod">
				UPDATE
					SwPaymentMethod
				SET
					saveOrderPaymentEncryptFlag = '#local.oldmurasettings.settingValue#'
				WHERE
					saveOrderPaymentEncryptFlag is null
				  AND
				  	paymentMethodID = '#local.oldmurasettings.paymentMethodID#'
			</cfquery>
		<cfelse>
			<cfquery name="local.updatepaymentmethod">
				UPDATE
					SwPaymentMethod
				SET
					saveOrderPaymentEncryptFlag = '#local.oldmurasettings.settingValue#'
				WHERE
					saveOrderPaymentEncryptFlag is null
				  AND
				  	paymentMethodType = 'creditCard'
			</cfquery>
		</cfif>
	</cfloop>
	
	<cfquery name="local.removeoldmurasetting">
		DELETE FROM SwSetting WHERE settingName = 'paymentMethodStoreCreditCardNumberWithOrder'	
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Changeing the paymentMethodStoreCreditCardNumberWithOrder setting">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>


<!--- Move store CC w/Order setting --->
<cftry>
	<cfquery name="local.oldmurasettings">
		SELECT
			settingValue,
			paymentMethodID
		FROM
			SwSetting
		WHERE
			settingName = 'paymentMethodStoreCreditCardNumberWithAccount'
	</cfquery>
	
	<cfloop query="local.oldmurasettings">
		<cfif len(local.oldmurasettings.paymentMethodID)>
			<cfquery name="local.updatepaymentmethod">
				UPDATE
					SwPaymentMethod
				SET
					saveAccountPaymentMethodEncryptFlag = '#local.oldmurasettings.settingValue#'
				WHERE
					saveAccountPaymentMethodEncryptFlag is null
				  AND
				  	paymentMethodID = '#local.oldmurasettings.paymentMethodID#'
			</cfquery>
		<cfelse>
			<cfquery name="local.updatepaymentmethod">
				UPDATE
					SwPaymentMethod
				SET
					saveAccountPaymentMethodEncryptFlag = '#local.oldmurasettings.settingValue#'
				WHERE
					saveAccountPaymentMethodEncryptFlag is null
				  AND
				  	paymentMethodType = 'creditCard'
			</cfquery>
		</cfif>
	</cfloop>
	
	<cfquery name="local.removeoldmurasetting">
		DELETE FROM SwSetting WHERE settingName = 'paymentMethodStoreCreditCardNumberWithAccount'	
	</cfquery>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Changeing the paymentMethodStoreCreditCardNumberWithOrder setting">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v3_1 had errors when running">
	<cfthrow detail="Part of Script v3_1 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v3_1 has run with no errors">
</cfif>
