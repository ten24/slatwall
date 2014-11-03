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
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addSku" type="list" modal="true" />
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addSubscriptionSku" type="list" modal="true" />
			<cf_HibachiActionCaller action="admin:entity.createImage" querystring="productID=#rc.product.getProductID()#&objectName=product&redirectAction=#request.context.slatAction#" modal="true" type="list" />
			<cf_HibachiActionCaller action="admin:entity.createfile" querystring="baseObject=#rc.product.getClassName()#&baseID=#rc.product.getProductID()#&redirectAction=#request.context.slatAction#" modal="true" type="list" />
			<cf_HibachiActionCaller action="admin:entity.createcomment" querystring="productID=#rc.product.getProductID()#&redirectAction=#request.context.slatAction#" modal="true" type="list" />
		</cf_HibachiEntityActionBar>

		<cfif rc.product.getEventConflictExistsFlag()>
			<div class="alert alert-error">
				#$.slatwall.rbKey('entity.product.eventConflict')#
			</div>
		</cfif>

		<cf_HibachiEntityDetailGroup object="#rc.product#">

			<!--- Basic --->
			<cf_HibachiEntityDetailItem view="admin:entity/producttabs/basic" open="true" text="#$.slatwall.rbKey('admin.entity.producttabs.basic')#" />

			<!--- TODO: We need to show "Bundle Groups" if this is a bundle product, and "Skus" if this is any other type of product --->
			
			<cfif rc.product.getBaseProductType() eq "productBundle">
				<!--- Bundle Groups --->
				<cf_HibachiEntityDetailItem view="admin:entity/producttabs/bundlegroups" text="#$.slatwall.rbKey('entity.productBundleGroup_plural')#" />
			<cfelse>
				<!--- Skus --->
				<cf_HibachiEntityDetailItem property="skus" />
			</cfif>
			<!--- TODO: END --->

			<!--- Event Registrations --->
			<cfif rc.product.getBaseProductType() EQ "event">
				<cf_HibachiEntityDetailItem property="productSchedules" />
				<cf_HibachiEntityDetailItem property="eventregistrations" />
			</cfif>
			<cf_HibachiEntityDetailItem view="admin:entity/producttabs/saleshistory" />

			<!--- Images --->
			<cf_HibachiEntityDetailItem view="admin:entity/producttabs/images" />

			<!--- Files --->
			<cf_SlatwallAdminTabFiles object="#rc.product#" />

			<!--- Description --->
			<cf_HibachiEntityDetailItem property="productDescription" />

			<!--- Relating --->
			<cf_HibachiEntityDetailItem property="listingPages" />
			<cf_HibachiEntityDetailItem property="categories" />
			<cf_HibachiEntityDetailItem property="relatedProducts" />

			<!--- Reference --->
			<cf_HibachiEntityDetailItem property="productReviews" />
			<cf_HibachiEntityDetailItem property="vendors" />

			<!--- Settings --->
			<cf_HibachiEntityDetailItem view="admin:entity/producttabs/productsettings" />
			<cf_HibachiEntityDetailItem view="admin:entity/producttabs/skusettings" />

			<!--- Custom Attributes --->
			<cfloop array="#rc.product.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
				<cf_HibachiEntityDetailItem object="#rc.product#" attributeSet="#attributeSet#" />
			</cfloop>

			<!--- Comments --->
			<cf_SlatwallAdminTabComments object="#rc.product#" />
		</cf_HibachiEntityDetailGroup>

	</cf_HibachiEntityDetailForm>

</cfoutput>
