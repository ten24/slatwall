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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.product" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<hb:HibachiEntityProcessForm entity="#rc.product#" edit="#rc.edit#">
	
	<hb:HibachiEntityActionBar type="preprocess" object="#rc.product#">
	</hb:HibachiEntityActionBar>
	
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.processObject#" property="updatePriceFlag" fieldType="yesno" edit="#rc.edit#">
			<hb:HibachiDisplayToggle selector="input[name='updatePriceFlag']">
				<hb:HibachiPropertyDisplay object="#rc.product#" property="currencyCode" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="price" edit="#rc.edit#">

					<cfoutput>
					<table class="table table-striped table-bordered table-condensed">
						<tr>
							<th>#$.slatwall.rbKey('entity.currency')#</th>
							<th>#$.slatwall.rbKey('entity.sku.price')#</th>
						</tr>
					<cfset skuCurrencyIndex = 0 />
					<cfloop list="#rc.product.setting('skuEligibleCurrencies')#" index="local.currencyCode">
					
						<cfset local.currency = $.slatwall.getService("currencyService").getCurrency( local.currencyCode ) />
						<cfif local.currency.getCurrencyCode() neq rc.product.setting('skuCurrency')>
							<cfset skuCurrencyIndex++ />
							<tr>
								<td class="primary">
								<input type="hidden" name="skuCurrencies[#skuCurrencyIndex#].currencyCode" value="#local.currencyCode#" />
									#local.currency.getCurrencyName()#
								</td>
								<td>
									<input type="text" name="skuCurrencies[#skuCurrencyIndex#].price" value="" />
								</td>
							</tr>
						</cfif>
					</cfloop>
				</table>
				</cfoutput>
			</hb:HibachiDisplayToggle>
			<hb:HibachiPropertyDisplay object="#rc.processObject#" property="updateListPriceFlag" fieldType="yesno" edit="#rc.edit#">
			<hb:HibachiDisplayToggle selector="input[name='updateListPriceFlag']">
				<hb:HibachiPropertyDisplay object="#rc.product#" property="currencyCode" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="listPrice" edit="#rc.edit#">
					<cfoutput>
					<table class="table table-striped table-bordered table-condensed">
						<tr>
							<th>#$.slatwall.rbKey('entity.currency')#</th>
							<th>#$.slatwall.rbKey('entity.sku.listprice')#</th>
						</tr>
					<cfset skuCurrencyIndex = 0 />
					<cfloop list="#rc.product.setting('skuEligibleCurrencies')#" index="local.currencyCode">
					
						<cfset local.currency = $.slatwall.getService("currencyService").getCurrency( local.currencyCode ) />
						<cfif local.currency.getCurrencyCode() neq rc.product.setting('skuCurrency')>
							<cfset skuCurrencyIndex++ />
							<tr>
								<td class="primary">
								
									#local.currency.getCurrencyName()#
								</td>
								<td>
									<input type="text" name="skuCurrencies[#skuCurrencyIndex#].listprice" value="" />
								</td>
							</tr>
						</cfif>
					</cfloop>
				</table>
				</cfoutput>
			</hb:HibachiDisplayToggle>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
	
</hb:HibachiEntityProcessForm>

