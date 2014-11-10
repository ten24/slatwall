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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfparam name="rc.sku" type="any">
<cfparam name="rc.product" type="any" default="#rc.sku.getProduct()#">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.sku#" edit="#rc.edit#" saveActionQueryString="skuID=#rc.sku.getSkuID()#">
		<hb:HibachiEntityActionBar type="detail" object="#rc.sku#" edit="#rc.edit#"
					backAction="admin:entity.detailproduct"
					backQueryString="productID=#rc.product.getProductID()#">
			<hb:HibachiActionCaller action="admin:entity.createalternateskucode" querystring="skuID=#rc.sku.getSkuID()#&redirectAction=#request.context.slatAction#" type="list" modal="true" />
		</hb:HibachiEntityActionBar>
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="activeFlag" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="skuName" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="skuCode" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="userDefinedPriceFlag" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="price" edit="#rc.edit#">
				<cfif rc.product.getBaseProductType() EQ "subscription">
					<hb:HibachiPropertyDisplay object="#rc.sku#" property="renewalPrice" edit="#rc.edit#">
				</cfif>
				<hb:HibachiPropertyDisplay object="#rc.sku#" property="listPrice" edit="#rc.edit#">
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		
		<hb:HibachiTabGroup object="#rc.sku#">
			<cfif rc.product.getBaseProductType() EQ "subscription">
				<hb:HibachiTab view="admin:entity/skutabs/subscription" />
			<cfelseif rc.product.getBaseProductType() EQ "contentaccess">
				<hb:HibachiTab property="accessContents" />
			<cfelse>
				<hb:HibachiTab view="admin:entity/skutabs/inventory" />
				<hb:HibachiTab view="admin:entity/skutabs/options" />
			</cfif>
			<hb:HibachiTab property="skuDescription" />
			<hb:HibachiTab view="admin:entity/skutabs/currencies" />
			<hb:HibachiTab view="admin:entity/skutabs/alternateskucodes" />
			<hb:HibachiTab view="admin:entity/skutabs/skusettings" />
			<!---<hb:HibachiTab view="admin:entity/skutabs/pricegroups" />--->

			<!--- Custom Attributes --->
			<cfloop array="#rc.sku.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
				<cf_SlatwallAdminTabCustomAttributes object="#rc.sku#" attributeSet="#attributeSet#" />
			</cfloop>
		</hb:HibachiTabGroup>

	</hb:HibachiEntityDetailForm>
</cfoutput>
