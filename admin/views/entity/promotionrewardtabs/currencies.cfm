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

<cfparam name="rc.promotionReward" type="any" />
<cfset local.promoRewardCurrencyStruct=structNew()>
<cfloop collection="#rc.promotionReward.getPromotionRewardCurrenciesStruct()#" item="local.promoRewardCurrency">
	<cfset local.currentPromoRewardCurrency=rc.promotionReward.getPromotionRewardCurrenciesStruct()[local.promoRewardCurrency]>
	<cfset local.promoRewardCurrencyStruct[local.currentPromoRewardCurrency.getCurrencyCode()]=local.currentPromoRewardCurrency>
</cfloop>

<cfoutput>
	<table class="table table-striped table-bordered table-condensed">
		<tr>
			<th>#$.slatwall.rbKey('entity.currency')#</th>
			<th>#$.slatwall.rbKey("define."&rc.promotionReward.getAmountType())#</th>
			<th>#$.slatwall.rbKey('entity.currency.currencyCode')#</th>
			<th class="admin admin1"></th>
		</tr>
		<cfloop list="#$.slatwall.setting('skuEligibleCurrencies')#" index="local.currencyCode">
			<cfset local.currency = $.slatwall.getService("currencyService").getCurrency( local.currencyCode ) />
			<cfif local.currency.getCurrencyCode() eq rc.promotionReward.getCurrencyCode()>
				<tr class="highlight-yellow">
			<cfelse>
				<tr>
			</cfif>
				<td class="primary">#local.currency.getCurrencyName()#</td>
				<cfif structKeyExists( local.promoRewardCurrencyStruct, local.currency.getCurrencyCode())>
					<td>
						#$.slatwall.formatValue(local.promoRewardCurrencyStruct[ local.currency.getCurrencyCode() ].getAmount(), 'currency', {currencyCode=local.currency.getCurrencyCode()} )#
						
					</td>
				<cfelseif local.currency.getCurrencyCode() eq rc.promotionReward.getCurrencyCode()>
					<td>
						#$.slatwall.formatValue(rc.promotionReward.getAmount(), 'currency', {currencyCode=local.currency.getCurrencyCode()} )#
					</td>
				<cfelse>
					<td>
						#$.slatwall.formatValue($.slatwall.getService("currencyService").convertCurrency(rc.promotionReward.getAmount(), rc.promotionReward.getCurrencyCode(),local.currency.getCurrencyCode()), 'currency', {currencyCode=local.currency.getCurrencyCode()} )# ( #$.slatwall.rbKey('admin.entity.skutabs.currencies.converted')# )
					</td>
				</cfif>
				
				<td>#local.currencyCode#</td>
				<td>
					<cfif local.currency.getCurrencyCode() eq rc.promotionReward.getCurrencyCode()>
						<hb:HibachiActionCaller action="entity.editpromotionrewardcurrency" class="btn btn-default btn-xs" icon="pencil" icononly="true" modal="true" disabled="true" />
					<cfelseif !structKeyExists( local.promoRewardCurrencyStruct, local.currency.getCurrencyCode())>
						<hb:HibachiActionCaller action="admin:entity.createpromotionrewardcurrency" querystring="currencyCode=#local.currencyCode#&promotionRewardID=#rc.promotionReward.getPromotionRewardID()#&redirectAction=admin:entity.detailpromotionreward" class="btn btn-default btn-xs" icon="pencil" icononly="true" modal="true" />
					<cfelse>
						<hb:HibachiActionCaller action="admin:entity.editpromotionrewardcurrency" querystring="promotionRewardCurrencyID=#local.promoRewardCurrencyStruct[ local.currency.getCurrencyCode() ].getPromotionRewardCurrencyID()#&promotionrewardID=#rc.promotionReward.getPromotionRewardID()#&redirectAction=admin:entity.detailpromotionreward" class="btn btn-default btn-xs" icon="pencil" icononly="true" modal="true" />
					</cfif>
				</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>

