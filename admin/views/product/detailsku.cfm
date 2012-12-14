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
<cfparam name="rc.sku" type="any">
<cfparam name="rc.product" type="any" default="#rc.sku.getProduct()#">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.sku#" edit="#rc.edit#" enctype="multipart/form-data">
		<cf_SlatwallActionBar type="detail" object="#rc.sku#" edit="#rc.edit#" backAction="admin:product.detailproduct" backQueryString="productID=#rc.product.getProductID()#" cancelAction="admin:product.detailsku" />
		<input type="hidden" name="returnAction" value="admin:product.detailproduct&productID=#rc.product.getProductID()#" />
		
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList divclass="span6">
				<cf_SlatwallPropertyDisplay object="#rc.sku#" property="activeFlag" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.sku#" property="userDefinedPriceFlag" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.sku#" property="price" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.sku#" property="listPrice" edit="#rc.edit#">
				<cfif rc.product.getBaseProductType() EQ "subscription">
					<cf_SlatwallPropertyDisplay object="#rc.sku#" property="renewalPrice" edit="#rc.edit#">
				</cfif>
				<cf_SlatwallPropertyDisplay object="#rc.sku#" property="skuCode" edit="#rc.edit#">
			</cf_SlatwallPropertyList>
			
			<cf_SlatwallPropertyList divclass="span6">
				<cfif rc.edit>
					<div class="image pull-right">
						<img src="#rc.sku.getResizedImagePath(width="150", height="150")#" border="0" width="150px" height="150px" /><br />
						<cfif rc.sku.getImageExistsFlag()>
							<cf_SlatwallFieldDisplay fieldType="yesno" title="Delete Current Image" fieldname="deleteImage" edit="true" />
						</cfif>
						<cf_SlatwallFieldDisplay fieldType="file" title="Upload New Image" fieldname="imageFileUpload" edit="true" />
						<cf_SlatwallFieldDisplay fieldType="radiogroup" title="Image Name" fieldname="imageExclusive" edit="true" valueOptions="#[{name=" Default Naming Convention<br />", value=0},{name=" Make Image Unique to Sku", value=1}]#" />
					</div>
				<cfelse>
					<div class="image pull-right">
						<img src="#rc.sku.getResizedImagePath(width="150", height="150")#" border="0" width="150px" height="150px" /><br />
					</div>
				</cfif>
			</cf_SlatwallPropertyList>
			
		</cf_SlatwallDetailHeader>

		<cf_SlatwallTabGroup object="#rc.sku#" allowCustomAttributes="true">
			<cfif rc.product.getBaseProductType() EQ "subscription">
				<cf_SlatwallTab view="admin:product/skutabs/subscription" />
			<cfelseif rc.product.getBaseProductType() EQ "contentaccess">
				<cf_SlatwallTab view="admin:product/skutabs/accesscontents" />
			<cfelse>
				<cf_SlatwallTab view="admin:product/skutabs/inventory" />
				<cf_SlatwallTab view="admin:product/skutabs/options" />
			</cfif>
			<cf_SlatwallTab view="admin:product/skutabs/currencies" />
			<cf_SlatwallTab view="admin:product/skutabs/alternateskucodes" />
			<cf_SlatwallTab view="admin:product/skutabs/skusettings" />
		</cf_SlatwallTabGroup>

	</cf_SlatwallDetailForm>
</cfoutput>