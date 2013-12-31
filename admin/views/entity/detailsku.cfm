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
<cfset skuHasEventConflict=rc.sku.geteventConflictExistsFlag()>

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.sku#" edit="#rc.edit#" saveActionQueryString="skuID=#rc.sku.getSkuID()#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.sku#" edit="#rc.edit#"
					backAction="admin:entity.detailproduct"
					backQueryString="productID=#rc.product.getProductID()#">
			<cfif rc.sku.getBundleFlag() eq true>		
				<cf_HibachiProcessCaller entity="#rc.sku#" action="admin:entity.preprocesssku" processContext="makeupBundledSkus" type="list" modal="true" />
				<cf_HibachiProcessCaller entity="#rc.sku#" action="admin:entity.preprocesssku" processContext="breakupBundledSkus" type="list" modal="true" />
				<li class="divider"></li>
			</cfif>
			<cf_HibachiActionCaller action="admin:entity.createalternateskucode" querystring="skuID=#rc.sku.getSkuID()#&redirectAction=#request.context.slatAction#" type="list" modal="true" />
			<cfif rc.product.getBaseProductType() EQ "event">
				<cf_HibachiProcessCaller entity="#rc.sku#" action="admin:entity.preprocesssku" processContext="changeeventdates" type="list" modal="true" />
				<cf_HibachiProcessCaller entity="#rc.sku#" action="admin:entity.preprocesssku" processContext="addlocation" type="list" modal="true" />
				<cf_HibachiProcessCaller entity="#rc.sku#" action="admin:entity.preprocesssku" processContext="removelocation" type="list" modal="true" />
				<cf_HibachiProcessCaller entity="#rc.sku#" action="admin:entity.preprocesssku" processContext="editcapacity" type="list" modal="true" />
				<cfif (rc.sku.getEventAttendanceType().getSystemCode() EQ "eatBundle" AND rc.sku.getbundleFlag())
					OR (rc.sku.getEventAttendanceType().getSystemCode() EQ "eatIndividual" AND !rc.sku.getbundleFlag())
					OR (rc.sku.getEventAttendanceType().getSystemCode() EQ "eatBoth")>
						<cf_HibachiProcessCaller entity="#rc.sku#" action="admin:entity.preprocesssku" processContext="logattendance" type="list" modal="true" />
				</cfif>
			</cfif>
			
			
		</cf_HibachiEntityActionBar>
		
		<cfif skuHasEventConflict>
			<div class="alert alert-error">
				This event time and location conflicts with another event. Click the Event Conflicts tab to view conflicts.
			</div>
		</cfif>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.sku#" property="activeFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.sku#" property="skuName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.sku#" property="skuCode" edit="#rc.edit#">
				<cfif rc.product.getBaseProductType() EQ "event">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="publishedFlag" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="eventStartDateTime" edit="false">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="eventEndDateTime" edit="false">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="startReservationDateTime" edit="false">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="endReservationDateTime" edit="false">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="purchaseStartDateTime" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="purchaseEndDateTime" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="eventCapacity" edit="false">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="allowEventWaitlistingFlag" edit="false">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="attendedquantity" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="eventAttendanceType" edit="#rc.edit#">
				</cfif>
				<cf_HibachiPropertyDisplay object="#rc.sku#" property="userDefinedPriceFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.sku#" property="price" edit="#rc.edit#">
				<cfif rc.product.getBaseProductType() EQ "subscription">
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="renewalPrice" edit="#rc.edit#">
				</cfif>
				<cf_HibachiPropertyDisplay object="#rc.sku#" property="listPrice" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<cf_HibachiTabGroup object="#rc.sku#">
			<cfif rc.product.getBaseProductType() eq "contentAccess">
				<cf_HibachiTab view="admin:entity/skutabs/subscription" />
			<cfelseif rc.product.getBaseProductType() eq "event">
				<cf_HibachiTab view="admin:entity/skutabs/inventory" />
				<cf_HibachiTab view="admin:entity/skutabs/locationconfigurations" />
				<cfset conflictLabel = $.slatwall.rbKey('admin.entity.skutabs.eventconflicts') />
				<cfif skuHasEventConflict>
					<cfset conflictLabel = conflictLabel & '*'>
				</cfif>
				<cf_HibachiTab view="admin:entity/skutabs/eventconflicts" text="#conflictLabel#" />
				<cf_HibachiTab view="admin:entity/skutabs/eventregistrations" />
				<cf_HibachiTab view="admin:entity/skutabs/productschedules" />
			<cfelseif rc.product.getBaseProductType() eq "subscription">
				<cf_HibachiTab property="accessContents" />
			<cfelseif rc.product.getBaseProductType() eq "merchandise">
				<cf_HibachiTab view="admin:entity/skutabs/inventory" />
				<cfif rc.sku.getBundleFlag() eq true>
					<cf_HibachiTab view="admin:entity/skutabs/bundledskus" />
				<cfelse>	
					<cf_HibachiTab view="admin:entity/skutabs/options" />
				</cfif>
			</cfif>
			<cfif (rc.sku.getBundleFlag() eq true) and (rc.product.getBaseProductType() neq "merchandise")>
				<cf_HibachiTab view="admin:entity/skutabs/bundledskus" />
			</cfif>
			<cf_HibachiTab property="skuDescription" />
			<cf_HibachiTab view="admin:entity/skutabs/saleshistory" />
			<cf_HibachiTab view="admin:entity/skutabs/currencies" />
			<cf_HibachiTab view="admin:entity/skutabs/alternateskucodes" />
			<cf_HibachiTab view="admin:entity/skutabs/skusettings" />

			<!--- Custom Attributes --->
			<cfloop array="#rc.sku.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
				<cf_SlatwallAdminTabCustomAttributes object="#rc.sku#" attributeSet="#attributeSet#" />
			</cfloop>
		</cf_HibachiTabGroup>

	</cf_HibachiEntityDetailForm>
	
</cfoutput>
