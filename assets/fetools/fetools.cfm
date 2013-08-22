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
<!--- Menu Building based on Permissions --->
<cfsavecontent variable="local.productSub">
	<cfoutput>
		<cfif request.slatwallScope.authenticateAction('admin:entity.listproduct')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.listproduct">#request.slatwallScope.rbKey('entity.product_plural')#</a></li>
		</cfif>
		<cfif request.slatwallScope.authenticateAction('admin:entity.listproducttype')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.listproducttype">#request.slatwallScope.rbKey('entity.producttype_plural')#</a></li>
		</cfif>
		<cfif request.slatwallScope.authenticateAction('admin:entity.listoptiongroup')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.listoptiongroup">#request.slatwallScope.rbKey('entity.optiongroup_plural')#</a></li>
		</cfif>
		<cfif request.slatwallScope.authenticateAction('admin:entity.listbrand')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.listbrand">#request.slatwallScope.rbKey('entity.brand_plural')#</a></li>
		</cfif>
		<cfif request.slatwallScope.authenticateAction('admin:entity.listsubscriptionterm')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.listsubscriptionterm">#request.slatwallScope.rbKey('entity.subscriptionterm_plural')#</a></li>
		</cfif>
		<cfif request.slatwallScope.authenticateAction('admin:entity.listsubscriptionbenefit')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.listsubscriptionbenefit">#request.slatwallScope.rbKey('entity.subscriptionbenefit_plural')#</a></li>
		</cfif>
		<cfif request.slatwallScope.authenticateAction('admin:entity.listproductreview')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.listproductreview">#request.slatwallScope.rbKey('entity.productreview_plural')#</a></li>	
		</cfif> 
		<cfif request.slatwallScope.authenticateAction('admin:entity.listpromotion')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.listpromotion">#request.slatwallScope.rbKey('entity.promotion_plural')#</a></li>
		</cfif>
		<cfif request.slatwallScope.authenticateAction('admin:entity.listpricegroup')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.listpricegroup">#request.slatwallScope.rbKey('entity.pricegroup_plural')#</a></li>
		</cfif>
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="local.orderSub">
	<cfoutput>
		<cfif request.slatwallScope.authenticateAction('admin:entity.listorder')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.listorder">#request.slatwallScope.rbKey('entity.order_plural')#</a></li>
		</cfif>
		<cfif request.slatwallScope.authenticateAction('admin:entity.listorderfulfillment')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.listorderfulfillment">#request.slatwallScope.rbKey('entity.orderfulfillment_plural')#</a></li>
		</cfif>
		<cfif request.slatwallScope.authenticateAction('admin:entity.listvendororder')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.listvendororder">#request.slatwallScope.rbKey('entity.vendororder_plural')#</a></li>
		</cfif>
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="local.accountSub">
	<cfoutput>
		<cfif request.slatwallScope.authenticateAction('admin:entity.listaccount')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.listaccount">#request.slatwallScope.rbKey('entity.account_plural')#</a></li>
		</cfif>
		<cfif request.slatwallScope.authenticateAction('admin:entity.listvendor')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.listvendor">#request.slatwallScope.rbKey('entity.vendor_plural')#</a></li>
		</cfif>
		<cfif request.slatwallScope.authenticateAction('admin:entity.listsubscriptionusage')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.listsubscriptionusage">#request.slatwallScope.rbKey('entity.subscriptionusage_plural')#</a></li>
		</cfif>
		<cfif request.slatwallScope.authenticateAction('admin:entity.listpermissiongroup')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.listpermissiongroup">#request.slatwallScope.rbKey('entity.permissiongroup_plural')#</a></li>
		</cfif>
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="local.integrationSub">
	<cfoutput>
		<cfif request.slatwallScope.authenticateAction('admin:integration.listintegration')>
			<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:integration.listintegration">#request.slatwallScope.rbKey('entity.integration_plural')#</a></li>
		</cfif>
		<cfset local.integrationSubsystems = request.slatwallScope.getService('integrationService').getActiveFW1Subsystems() />
		<cfloop array="#local.integrationSubsystems#" index="local.intsys">
			<cfif request.slatwallScope.authenticateAction('#local.intsys.subsystem#:main.default')>
				<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=#local.intsys.subsystem#:main.default">#local.intsys.name#</a></li>
			</cfif>
		</cfloop>
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="local.pageSub">
	<cfoutput>
		<cfif not request.slatwallScope.getCurrentProduct().isNew()>
			<cfif request.slatwallScope.authenticateAction('admin:entity.detailproduct')>
				<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.detailproduct&productID=#request.slatwallScope.getCurrentProduct().getProductID()#">Product Admin</a></li>
			</cfif>
			<cfif request.slatwallScope.authenticateAction('admin:entity.detailproducttype')>
				<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.detailproducttype&productTypeID=#request.slatwallScope.getCurrentProduct().getProductType().getProductTypeID()#">Product Type Admin</a></li>
			</cfif>
			<cfif request.slatwallScope.authenticateAction('admin:entity.detailbrand') && !isNull(request.slatwallScope.getCurrentProduct().getBrand())>
				<li><a href="#request.slatwallScope.getBaseURL()#/?slatAction=admin:entity.detailbrand&brandID=#request.slatwallScope.getCurrentProduct().getBrand().getBrandID#">Brand Admin</a></li>
			</cfif>
		</cfif>
	</cfoutput>
</cfsavecontent>

<!--- Actual Output --->
<cfif len(local.productSub) or len(local.orderSub) or len(local.accountSub) or len(local.integrationSub) or len(pageSub)>
	<cfoutput>
		<link rel="stylesheet" href="#request.slatwallScope.getSlatwallRootURL()#/assets/fetools/fetools.css" type="text/css" media="all" />
		<script src="#request.slatwallScope.getSlatwallRootURL()#/assets/fetools/fetools.js" type="text/javascript" language="Javascript"></script>
		<div id="sw-fetools">
			<div class="sw-handle">
				<a href="##" class="sw-logo"></a>	
			</div>
			<ul class="sw-menu">
				<cfif len(local.productSub)>
					<li>
						<a href="##" class="sw-submenu-toggle"><i class="icon icon-tags"></i> #request.slatwallScope.rbKey('admin.product_nav')#</a>
						<ul>
							#local.productSub#
						</ul>
					</li>
					<li class="divider"></li>
				</cfif>
				<cfif len(local.orderSub)>
					<li>
						<a href="##" class="sw-submenu-toggle"><i class="icon icon-inbox"></i> #request.slatwallScope.rbKey('admin.order_nav')#</a>
						<ul>
							#local.orderSub#
						</ul>
					</li>
					<li class="divider"></li>
				</cfif>
				<cfif len(local.accountSub)>
					<li>
						<a href="##" class="sw-submenu-toggle"><i class="icon icon-user"></i> #request.slatwallScope.rbKey('admin.account_nav')#</a>
						<ul>
							#local.accountSub#
						</ul>
					</li>
					<li class="divider"></li>
				</cfif>
				<cfif len(local.integrationSub)>
					<li>
						<a href="##" class="sw-submenu-toggle"><i class="icon icon-random"></i> #request.slatwallScope.rbKey('admin.integration_nav')#</a>
						<ul>
							#local.integrationSub#
						</ul>
					</li>
					<li class="divider"></li>
				</cfif>
				<cfif len(local.pageSub)>
					<li>
						<a href="##" class="sw-submenu-toggle active"><i class="icon icon-file"></i> Page Tools</a>
						<ul class="open">
							#local.pageSub#
						</ul>
					</li>
				</cfif>
			</ul>	
		</div>
	</cfoutput>
</cfif>
