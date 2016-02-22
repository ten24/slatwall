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


<cfparam name="rc.sku" type="any">
<cfparam name="rc.product" type="any" default="#rc.sku.getProduct()#">
<cfparam name="rc.edit" type="boolean">
<cfset skuHasEventConflict=rc.sku.geteventConflictExistsFlag()>

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.sku#" edit="#rc.edit#" saveActionQueryString="skuID=#rc.sku.getSkuID()#">
		<hb:HibachiEntityActionBar type="detail" object="#rc.sku#" edit="#rc.edit#"
					backAction="admin:entity.detailproduct"
					backQueryString="productID=#rc.product.getProductID()#"
					deleteQueryString="redirectAction=admin:entity.detailproduct&productID=#rc.product.getProductID()#">
			<cfif rc.sku.getBundleFlag() eq true>
				<hb:HibachiProcessCaller entity="#rc.sku#" action="admin:entity.preprocesssku" processContext="makeupBundledSkus" type="list" modal="true" />
				<hb:HibachiProcessCaller entity="#rc.sku#" action="admin:entity.preprocesssku" processContext="breakupBundledSkus" type="list" modal="true" />
				<li class="divider"></li>
			</cfif>
			<hb:HibachiActionCaller action="admin:entity.createalternateskucode" querystring="skuID=#rc.sku.getSkuID()#&redirectAction=#request.context.slatAction#" type="list" modal="true" />
			<cfif rc.product.getBaseProductType() EQ "event">
				<hb:HibachiProcessCaller entity="#rc.sku#" action="admin:entity.preprocesssku" processContext="changeeventdates" type="list" modal="true" />
				<hb:HibachiProcessCaller entity="#rc.sku#" action="admin:entity.preprocesssku" processContext="addlocation" type="list" modal="true" />
				<hb:HibachiProcessCaller entity="#rc.sku#" action="admin:entity.preprocesssku" processContext="removelocation" type="list" modal="true" />
				<hb:HibachiProcessCaller entity="#rc.sku#" action="admin:entity.preprocesssku" processContext="editcapacity" type="list" modal="true" />
				<cfif dateCompare(now(),rc.sku.getEventStartDateTime(),"s") EQ 1>
					<hb:HibachiProcessCaller entity="#rc.sku#" action="admin:entity.preprocesssku" processContext="logattendance" type="list" modal="true" />
				</cfif>
			</cfif>
		</hb:HibachiEntityActionBar>

		<cfif skuHasEventConflict>
			<div class="alert alert-error">
				This event time and location conflicts with another event. Click the Event Conflicts tab to view conflicts.
			</div>
		</cfif>

		<hb:HibachiEntityDetailGroup object="#rc.sku#">
			<hb:HibachiEntityDetailItem view="admin:entity/skutabs/basic" open="true" text="#$.slatwall.rbKey('admin.define.basic')#" />
			<cfif rc.product.getBaseProductType() EQ "subscription">
				<hb:HibachiEntityDetailItem view="admin:entity/skutabs/subscription" />
			<cfelseif rc.product.getBaseProductType() eq "event">
				<hb:HibachiEntityDetailItem view="admin:entity/skutabs/inventory" />
				<hb:HibachiEntityDetailItem view="admin:entity/skutabs/locationconfigurations" />
				<cfset conflictLabel = $.slatwall.rbKey('admin.entity.skutabs.eventconflicts') />
				<cfif skuHasEventConflict>
					<cfset conflictLabel = conflictLabel & '*'>
				</cfif>
				<hb:HibachiEntityDetailItem view="admin:entity/skutabs/eventconflicts" text="#conflictLabel#" />
				<hb:HibachiEntityDetailItem view="admin:entity/skutabs/eventregistrations" />
			<cfelseif rc.product.getBaseProductType() EQ "contentaccess">
				<hb:HibachiEntityDetailItem property="accessContents" />
			<cfelseif rc.product.getBaseProductType() eq "merchandise">
				<hb:HibachiEntityDetailItem view="admin:entity/skutabs/inventory" />
				<cfif rc.sku.getBundleFlag() eq true>
					<hb:HibachiEntityDetailItem view="admin:entity/skutabs/bundledskus" />
				<cfelse>
					<hb:HibachiEntityDetailItem view="admin:entity/skutabs/options" />
				</cfif>
			</cfif>
			<hb:HibachiEntityDetailItem property="skuDescription" />
			<hb:HibachiEntityDetailItem view="admin:entity/skutabs/saleshistory" />
			<hb:HibachiEntityDetailItem view="admin:entity/skutabs/currencies" />
			<hb:HibachiEntityDetailItem view="admin:entity/skutabs/alternateskucodes" />
			<hb:HibachiEntityDetailItem view="admin:entity/skutabs/skusettings" />
			<!---<hb:HibachiTab view="admin:entity/skutabs/pricegroups" />--->

			<!--- Custom Attributes --->
			<cfloop array="#rc.sku.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
				<swa:SlatwallAdminTabCustomAttributes object="#rc.sku#" attributeSet="#attributeSet#" />
			</cfloop>
		</hb:HibachiEntityDetailGroup>

	</hb:HibachiEntityDetailForm>
</cfoutput>