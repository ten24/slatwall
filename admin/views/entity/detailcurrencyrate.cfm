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


<cfparam name="rc.currencyRate" type="any" />
<cfparam name="rc.currencyCode" type="any" default="" />
<cfparam name="rc.edit" type="boolean" />

<cfsilent>
	<cfif !len(rc.currencyCode) and not isNull(rc.currencyRate.getCurrency())>
		<cfset rc.currencyCode = rc.currencyRate.getCurrency().getCurrencyCode() />
	</cfif>
	
	<cfset local.conversionCurrencyOptionsSmartList = $.slatwall.getSmartList('currency') />
	
	<cfset local.conversionCurrencyOptionsSmartList.addSelect('currencyName', 'name') />
	<cfset local.conversionCurrencyOptionsSmartList.addSelect('currencyCode', 'value') />
	
	<cfset local.conversionCurrencyOptionsSmartList.addFilter('activeFlag', 1) />
	<cfset local.conversionCurrencyOptionsSmartList.addWhereCondition("aslatwallcurrency.currencyCode <> '#rc.currencyCode#'") />
	
	<cfset local.conversionCurrencyOptions = local.conversionCurrencyOptionsSmartList.getRecords() />
	<cfset arrayPrepend(local.conversionCurrencyOptions, {name=$.slatwall.rbKey('define.select'), value=""}) />
</cfsilent>

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.currencyRate#" edit="#rc.edit#" sRedirectAction="admin:entity.detailcurrency" saveActionQueryString="currencyCode=#rc.currencyCode#">
		<hb:HibachiEntityActionBar type="detail" object="#rc.currencyRate#" edit="#rc.edit#"></hb:HibachiEntityActionBar>
		
		<input type="hidden" name="currency.currencyCode" value="#rc.currencyCode#" />
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<hb:HibachiPropertyDisplay object="#rc.currencyRate#" property="conversionCurrency" edit="#rc.edit#" valueOptions="#local.conversionCurrencyOptions#">
				<hb:HibachiPropertyDisplay object="#rc.currencyRate#" property="conversionRate" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.currencyRate#" property="effectiveStartDateTime" edit="#rc.edit#">
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		
	</hb:HibachiEntityDetailForm>
</cfoutput>
