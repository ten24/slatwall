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
<cfparam name="rc.brand" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiCrudDetailForm object="#rc.brand#" edit="#rc.edit#">
		<cf_HibachiCrudActionBar type="detail" object="#rc.brand#" edit="#rc.edit#" />
		
		<cf_HibachiDetailHeader>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.Brand#" property="activeFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.Brand#" property="brandName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.Brand#" property="brandWebsite" edit="#rc.edit#">
				<cfif not rc.brand.isNew()>
					<cf_HibachiPropertyDisplay object="#rc.Brand#" property="urlTitle" edit="#rc.edit#">
				</cfif>
			</cf_HibachiPropertyList>
		</cf_HibachiDetailHeader>
		
		<cf_HibachiTabGroup object="#rc.brand#" allowCustomAttributes="true">
			<cf_HibachiTab view="admin:entity/brandtabs/products" text="#$.slatwall.rbkey('entity.brand.products')#" />
			<cf_HibachiTab view="admin:entity/brandtabs/vendors" />
			<cf_HibachiTab view="admin:entity/brandtabs/brandsettings" />
		</cf_HibachiTabGroup>
		
	</cf_HibachiCrudDetailForm>
</cfoutput>
