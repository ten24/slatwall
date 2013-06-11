<!---

    Slatwall - An e-commerce plugin for Mura CMS
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
<cfparam name="rc.skuCurrency" type="any" />
<cfparam name="rc.edit" type="boolean" />
<cfparam name="rc.currencyCode" type="string" />
<cfparam name="rc.sku" type="any" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.skuCurrency#" edit="#rc.edit#" 
								saveActionQueryString="skuID=#rc.skuID#"
								saveActionHash="tabcurrencies">
								
		<cf_HibachiEntityActionBar type="detail" object="#rc.skuCurrency#" edit="#rc.edit#"
								   backAction="admin:entity.detailsku"
								   backQueryString="skuID=#rc.sku.getSkuID()#"
								   cancelAction="admin:entity.detailsku"
								   cancelQueryString="skuID=#rc.sku.getSkuID()#" />
								   
		<input type="hidden" name="sku.skuID" value="#rc.sku.getSkuID()#" />
		<input type="hidden" name="currency.currencyCode" value="#rc.currencyCode#" />
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.skuCurrency#" property="price" edit="#rc.edit#" value="#rc.sku.getPriceByCurrencyCode( rc.currencyCode )#">
				<cfif rc.sku.getProduct().getBaseProductType() eq "subscription">
					<cf_HibachiPropertyDisplay object="#rc.skuCurrency#" property="renewalPrice" edit="#rc.edit#" value="#rc.sku.getRenewalPriceByCurrencyCode( rc.currencyCode )#">
				</cfif>
				<cf_HibachiPropertyDisplay object="#rc.skuCurrency#" property="listPrice" edit="#rc.edit#" value="#rc.sku.getListPriceByCurrencyCode( rc.currencyCode )#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<cfif !rc.skuCurrency.isNew()>
			<cf_HibachiActionCaller action="admin:entity.deleteskucurrency" queryString="skuCurrencyID=#rc.skuCurrency.getSkuCurrencyID()#&redirectAction=admin:entity.detailsku&skuID=#rc.sku.getSkuID()#" class="btn btn-danger" />
		</cfif>
		
	</cf_HibachiEntityDetailForm>
</cfoutput>