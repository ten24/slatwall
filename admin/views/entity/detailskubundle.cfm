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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.skuBundle" type="any" />
<cfparam name="rc.sku" type="any" default="#rc.skuBundle.getSku()#" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.skuBundle#" edit="#rc.edit#" 
								saveActionQueryString="skuID=#rc.sku.getSkuID()#"
								saveActionHash="tabbundledskus">
								
		<hb:HibachiEntityActionBar type="detail" object="#rc.skuBundle#" edit="#rc.edit#"
					backAction="admin:entity.detailSku" 
					backQueryString="skuID=#rc.sku.getSkuID()#"
					cancelAction="admin:entity.detailSku"
					cancelQueryString="skuID=#rc.sku.getSkuID()#"  />
		
		<input type="hidden" name="sku.SkuID" value="#rc.sku.getSkuID()#" />
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
                		<hb:HibachiPropertyDisplay object="#rc.skuBundle#" property="bundledSku" autocompleteNameProperty="skuName" autocompletePropertyIdentifiers="skuID,skuName,activeFlag,skuCode" fieldType="typeahead" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.skuBundle#" property="bundledQuantity" edit="#rc.edit#">
				<cfif !isNull(rc.skuBundle.getBundledSku()) AND rc.skuBundle.getBundledSku().getInventoryTrackBy() neq "Quantity">
				    <hb:HibachiPropertyDisplay object="#rc.skuBundle#" property="measurementUnit" edit="#rc.edit#">
				</cfif>
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		
	</hb:HibachiEntityDetailForm>
</cfoutput>
