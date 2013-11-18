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
<cfparam name="rc.product" type="any" />
<cfparam name="rc.edit" type="boolean" default="false" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.product#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.product#" edit="#rc.edit#">
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="updateSkus" type="list" modal="true" />
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.processproduct" processContext="updateDefaultImageFileNames" type="list" confirm="true" confirmtext="#$.slatwall.rbKey('entity.Product.process.updateDefaultImageFileNames_confirm')#" />
			<li class="divider"></li>
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addOptionGroup" type="list" modal="true" />
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addOption" type="list" modal="true" />
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addSubscriptionSku" type="list" modal="true" />
			<cf_HibachiActionCaller action="admin:entity.createImage" querystring="productID=#rc.product.getProductID()#&objectName=product&redirectAction=#request.context.slatAction#" modal="true" type="list" />
			<cf_HibachiActionCaller action="admin:entity.createcomment" querystring="productID=#rc.product.getProductID()#&redirectAction=#request.context.slatAction#" modal="true" type="list" />
		</cf_HibachiEntityActionBar>
		
		<cfif rc.product.getEventConflictExistsFlag()>
			<div class="alert alert-error">
				There are event time and location conflicts with one of this product's events. Review the Skus tab for details.
			</div>
		</cfif>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList divClass="span6">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="activeFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="publishedFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="productName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="productCode" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="urlTitle" edit="#rc.edit#" valueLink="#rc.product.getProductURL()#">
			</cf_HibachiPropertyList>
			<cf_HibachiPropertyList divClass="span6">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="brand" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="productType" edit="#rc.edit#">
				<cf_HibachiFieldDisplay title="#$.slatwall.rbKey('define.qats.full')#" value="#rc.product.getQuantity('QATS')#">
				<cf_HibachiFieldDisplay title="#$.slatwall.rbKey('define.qiats.full')#" value="#rc.product.getQuantity('QIATS')#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<cf_HibachiTabGroup object="#rc.product#">
			<!--- Skus --->
			<cf_HibachiTab property="skus" />
			
			<!--- Event Registrations --->
			<cfif rc.product.getBaseProductType() EQ "event">
				<cf_HibachiTab property="eventregistrations" />
			</cfif>
			<cf_HibachiTab view="admin:entity/producttabs/saleshistory" />
			
			<!--- Images --->
			<cf_HibachiTab view="admin:entity/producttabs/images" />
			
			<!--- Description --->
			<cf_HibachiTab property="productDescription" />
			
			<!--- Relating --->
			<cf_HibachiTab property="listingPages" />
			<cf_HibachiTab property="categories" />
			<cf_HibachiTab property="relatedProducts" />
			
			<!--- Reference --->
			<cf_HibachiTab property="productReviews" />
			<cf_HibachiTab property="vendors" />
			
			<!--- Settings --->
			<cf_HibachiTab view="admin:entity/producttabs/productsettings" />
			<cf_HibachiTab view="admin:entity/producttabs/skusettings" />
			
			<!--- Custom Attributes --->
			<cfloop array="#rc.product.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
				<cf_SlatwallAdminTabCustomAttributes object="#rc.product#" attributeSet="#attributeSet#" />
			</cfloop>
			
			<!--- Comments --->
			<cf_SlatwallAdminTabComments object="#rc.product#" />
		</cf_HibachiTabGroup>
		
	</cf_HibachiEntityDetailForm>

</cfoutput>
