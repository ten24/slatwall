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
<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.product" type="any" />

<swa:SlatwallSettingTable>
	<swa:SlatwallSetting settingName="skuAllowBackorderFlag" settingObject="#rc.product#" />
	<swa:SlatwallSetting settingName="skuAllowPreorderFlag" settingObject="#rc.product#" />
	<swa:SlatwallSetting settingName="skuAllowWaitlistingFlag" settingObject="#rc.product#" />
	<swa:SlatwallSetting settingName="skuCurrency" settingObject="#rc.product#" />
	<swa:SlatwallSetting settingName="skuEligibleCurrencies" settingObject="#rc.product#" />
	<swa:SlatwallSetting settingName="skuEligibleFulfillmentMethods" settingObject="#rc.product#" />
	<cfif rc.product.getProductType().getBaseProductType() eq "gift-card">
		<swa:SlatwallSetting settingName="skuGiftCardEmailFulfillmentTemplate" settingObject="#rc.product#" />
	<cfelse>
		<swa:SlatwallSetting settingName="skuEmailFulfillmentTemplate" settingObject="#rc.product#" />
	</cfif>
	<swa:SlatwallSetting settingName="skuEligibleOrderOrigins" settingObject="#rc.product#" />
	<swa:SlatwallSetting settingName="skuEligiblePaymentMethods" settingObject="#rc.product#" />
	<swa:SlatwallSetting settingName="skuHoldBackQuantity" settingObject="#rc.product#" />
	<swa:SlatwallSetting settingName="skuOrderMinimumQuantity" settingObject="#rc.product#" />
	<swa:SlatwallSetting settingName="skuOrderMaximumQuantity" settingObject="#rc.product#" />
	<swa:SlatwallSetting settingName="skuShippingWeight" settingObject="#rc.product#" />
	<swa:SlatwallSetting settingName="skuShippingWeightUnitCode" settingObject="#rc.product#" />
	<swa:SlatwallSetting settingName="skuTrackInventoryFlag" settingObject="#rc.product#" />
	<swa:SlatwallSetting settingName="skuQATSIncludesQNROROFlag" settingObject="#rc.product#" />
	<swa:SlatwallSetting settingName="skuQATSIncludesQNROVOFlag" settingObject="#rc.product#" />
	<swa:SlatwallSetting settingName="skuQATSIncludesQNROSAFlag" settingObject="#rc.product#" />
	<swa:SlatwallSetting settingName="skuTaxCategory" settingObject="#rc.product#" />
	
	<cfif rc.product.getProductType().getBaseProductType() eq "merchandise">
		<!--- Wrap this arround settings if you want to disable them for certain product types --->
	<cfelseif rc.product.getProductType().getBaseProductType() eq "event">
		<swa:SlatwallSetting settingName="skuEventEnforceConflicts" settingObject="#rc.product#" />
	</cfif>
</swa:SlatwallSettingTable>
