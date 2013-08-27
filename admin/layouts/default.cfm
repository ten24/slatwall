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

<cfoutput>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>#rc.pageTitle# &##124; Slatwall</title>

		<link rel="icon" href="#request.slatwallScope.getBaseURL()#/assets/images/favicon.png" type="image/png" />
		<link rel="shortcut icon" href="#request.slatwallScope.getBaseURL()#/assets/images/favicon.png" type="image/png" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0">

		<link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/css/bootstrap.2.3.2.min.css" rel="stylesheet">
		<!---<link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/css/bootstrap.min.css" rel="stylesheet">--->
		<link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/css/jquery-ui-1.9.2.custom.css" rel="stylesheet">
		<link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/css/global.css" rel="stylesheet">

		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-1.7.1.min.js"></script>
		
		<cfif arrayLen($.slatwall.getPrintQueue()) and request.context.slatAction neq "admin:print.default">
			<script type="text/javascript">
				var printWindow = window.open('#request.slatwallScope.getBaseURL()#?slatAction=admin:print.default', '_blank');
			</script>
		</cfif>
		<style type="text/css">
			.navbar .brand {margin-left:0px;}
		</style>
	</head>
	<body>
		<div class="navbar navbar-fixed-top navbar-inverse">
			<div class="navbar-inner">
				<div class="container-fluid">
					<cfset homeLink = request.slatwallScope.getBaseURL() />
					<cfif not len(homeLink)>
						<cfset homeLink = "/" />
					</cfif>
					<a href="#homeLink#" class="brand" style="margin-left:-20px;"><img src="#request.slatwallScope.getBaseURL()#/assets/images/admin.logo.png" style="width:100px;heigh:16px;" title="Slatwall" /></a>
					<cfloop array="#$.slatwall.getService('integrationService').getAdminNavbarHTMLArray()#" index="navbarHTML">
						#navbarHTML#
					</cfloop>
					<ul class="nav">
						<li class="divider-vertical"></li>
						<cf_HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.products_nav')#" icon="tags icon-white" type="nav">
							<cf_HibachiDividerHider>
								<cf_HibachiActionCaller action="admin:entity.listproduct" type="list">
								<cf_HibachiActionCaller action="admin:entity.listproducttype" type="list">
								<cf_HibachiActionCaller action="admin:entity.listbrand" type="list">
								<cf_HibachiActionCaller action="admin:entity.listsku" type="list">
								<cf_HibachiActionCaller action="admin:entity.listproductreview" type="list">
								<li class="divider"></li>
								<cf_HibachiActionCaller action="admin:entity.listoptiongroup" type="list">
								<cf_HibachiActionCaller action="admin:entity.listsubscriptionterm" type="list">
								<cf_HibachiActionCaller action="admin:entity.listsubscriptionbenefit" type="list">
								<cf_HibachiActionCaller action="admin:entity.listcategory" type="list">
								<cf_HibachiActionCaller action="admin:entity.listcontent" type="list">
								<li class="divider"></li>
								<cf_HibachiActionCaller action="admin:entity.listpromotion" type="list">
								<cf_HibachiActionCaller action="admin:entity.listpricegroup" type="list">
							</cf_HibachiDividerHider>
						</cf_HibachiActionCallerDropdown>
						<cf_HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.orders_nav')#" icon="inbox icon-white" type="nav">
							<cf_HibachiDividerHider>
								<cf_HibachiActionCaller action="admin:entity.listorder" type="list">
								<cf_HibachiActionCaller action="admin:entity.listcartandquote" type="list">
								<cf_HibachiActionCaller action="admin:entity.listorderitem" type="list">
								<cf_HibachiActionCaller action="admin:entity.listorderfulfillment" type="list">
								<cf_HibachiActionCaller action="admin:entity.listorderpayment" type="list">
								<cf_HibachiActionCaller action="admin:entity.listorderdelivery" type="list">
								<li class="divider"></li>
								<cf_HibachiActionCaller action="admin:entity.listvendororder" type="list">
								<cf_HibachiActionCaller action="admin:entity.listvendororderitem" type="list">
							</cf_HibachiDividerHider>
						</cf_HibachiActionCallerDropdown>
						<cf_HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.accounts_nav')#" icon="user icon-white" type="nav">
							<cf_HibachiDividerHider>
								<cf_HibachiActionCaller action="admin:entity.listaccount" type="list">
								<cf_HibachiActionCaller action="admin:entity.listsubscriptionusage" type="list">
								<cf_HibachiActionCaller action="admin:entity.listpermissiongroup" type="list">
								<li class="divider"></li>
								<cf_HibachiActionCaller action="admin:entity.listvendor" type="list">
							</cf_HibachiDividerHider>
						</cf_HibachiActionCallerDropdown>
						<cf_HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.warehouse_nav')#" icon="barcode icon-white" type="nav">
							<cf_HibachiActionCaller action="admin:entity.liststockreceiver" type="list">
							<cf_HibachiActionCaller action="admin:entity.liststockadjustment" type="list">
							<cf_HibachiActionCaller action="admin:entity.listphysical" type="list">
						</cf_HibachiActionCallerDropdown>
						<cfset local.integrationSubsystems = $.slatwall.getService('integrationService').getActiveFW1Subsystems() />
						<cfif arrayLen(local.integrationSubsystems)>
							<cf_HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.integrations_nav')#" icon="random icon-white" type="nav">
								<cfloop array="#local.integrationSubsystems#" index="local.intsys">
									<cf_HibachiActionCaller action="#local.intsys.subsystem#:main.default" text="#local.intsys.name#" type="list">
								</cfloop>
							</cf_HibachiActionCallerDropdown>
						</cfif>
						<cf_HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.configure_nav')#" icon="cog icon-white" type="nav">
							<cf_HibachiDividerHider>
								<cf_HibachiActionCaller action="admin:entity.settings" title="#$.slatwall.rbKey('admin.setting_nav')#" type="list">
								<cf_HibachiActionCaller action="admin:entity.listattributeset" type="list">
								<cf_HibachiActionCaller action="admin:entity.listintegration" type="list">
								<li class="divider"></li>
								<cf_HibachiActionCaller action="admin:entity.listaddresszone" type="list">
								<cf_HibachiActionCaller action="admin:entity.listcollection" type="list">
								<cf_HibachiActionCaller action="admin:entity.listcountry" type="list">
								<cf_HibachiActionCaller action="admin:entity.listcurrency" type="list">
								<cf_HibachiActionCaller action="admin:entity.listemailtemplate" type="list">
								<cf_HibachiActionCaller action="admin:entity.listfulfillmentmethod" type="list">
								<cf_HibachiActionCaller action="admin:entity.listlocation" type="list">
								<cf_HibachiActionCaller action="admin:entity.listmeasurementunit" type="list">
								<cf_HibachiActionCaller action="admin:entity.listorderorigin" type="list">
								<cf_HibachiActionCaller action="admin:entity.listpaymentmethod" type="list">
								<cf_HibachiActionCaller action="admin:entity.listpaymentterm" type="list">
								<cf_HibachiActionCaller action="admin:entity.listprinttemplate" type="list">
								<cf_HibachiActionCaller action="admin:entity.listroundingrule" type="list">
								<cf_HibachiActionCaller action="admin:entity.listsite" type="list">
								<cf_HibachiActionCaller action="admin:entity.listtaxcategory" type="list">
								<cf_HibachiActionCaller action="admin:entity.listterm" type="list">
								<cf_HibachiActionCaller action="admin:entity.listtype" type="list">
							</cf_HibachiDividerHider>
						</cf_HibachiActionCallerDropdown>
						<cf_HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.tools_nav')#" icon="magnet icon-white" type="nav">
							<cf_HibachiDividerHider>
								<cf_HibachiActionCaller action="admin:report" type="list">
								<cf_HibachiActionCaller action="admin:entity.listeventtrigger" type="list">
								<cf_HibachiActionCaller action="admin:entity.listschedule" type="list">
								<cf_HibachiActionCaller action="admin:entity.listsession" type="list">
								<cf_HibachiActionCaller action="admin:entity.listtask" type="list">
								<cf_HibachiActionCaller action="admin:entity.listtaskhistory" type="list">
								<cf_HibachiActionCaller action="admin:main.ckfinder" type="list" modal="true" />
								<cf_HibachiActionCaller action="admin:main.log" type="list">
								<cf_HibachiActionCaller action="admin:main.update" type="list">
								<cfif $.slatwall.getAccount().getSuperUserFlag()>
									<cf_HibachiActionCaller action="admin:main.default" querystring="reload=true" type="list" text="Reload Slatwall">
								</cfif>
							</cf_HibachiDividerHider>
						</cf_HibachiActionCallerDropdown>
					</ul>
					<cfif $.slatwall.getLoggedInAsAdminFlag()>
						<div class="pull-right">
							<ul class="nav">
								<cf_HibachiActionCallerDropdown title="" icon="user icon-white" dropdownclass="pull-right" type="nav">
									<cf_HibachiActionCaller action="admin:entity.detailaccount" querystring="accountID=#$.slatwall.account('accountID')#" type="list">
									<cf_HibachiActionCaller action="admin:main.logout" type="list">
									<li class="divider"></li>
									<li><a title="User Docs" href="http://docs.getslatwall.com/##users" target="_blank">User Docs</a></li>
									<li><a title="Developer Docs" href="http://docs.getslatwall.com/##developer" target="_blank">Developer Docs</a></li>
									<cf_HibachiActionCaller action="admin:main.about" type="list">
								</cf_HibachiActionCallerDropdown>
							</ul>
							<form name="search" class="navbar-search" action="/" onSubmit="return false;">
								<input id="global-search" type="text" name="serach" class="search-query span2" placeholder="Search">
							</form>
						</div>
					</cfif>
				</div>
			</div>
		</div>

		<div id="search-results" class="search-results">
			<div class="container-fluid">
				<div class="row-fluid">

					<div class="span3 result-bucket">
						<h5>#$.slatwall.rbKey('entity.product_plural')#</h5>
						<ul class="nav" id="golbalsr-product">
							<cfif not $.slatwall.authenticateEntity("Read", "Product")>
								<li><em>#$.slatwall.rbKey('define.noAccess')#</em></li>
							</cfif>
						</ul>
					</div>

					<div class="span3 result-bucket">
						<h5>#$.slatwall.rbKey('entity.productType_plural')#</h5>
						<ul class="nav" id="golbalsr-productType">
							<cfif not $.slatwall.authenticateEntity("Read", "ProductType")>
								<li><em>#$.slatwall.rbKey('define.noAccess')#</em></li>
							</cfif>
						</ul>
					</div>

					<div class="span3  result-bucket">
						<h5>#$.slatwall.rbKey('entity.brand_plural')#</h5>
						<ul class="nav" id="golbalsr-brand">
							<cfif not $.slatwall.authenticateEntity("Read", "Brand")>
								<li><em>#$.slatwall.rbKey('define.noAccess')#</em></li>
							</cfif>
						</ul>
					</div>

					<div class="span3 result-bucket">
						<h5>#$.slatwall.rbKey('entity.promotion_plural')#</h5>
						<ul class="nav" id="golbalsr-promotion">
							<cfif not $.slatwall.authenticateEntity("Read", "Promotion")>
								<li><em>#$.slatwall.rbKey('define.noAccess')#</em></li>
							</cfif>
						</ul>
					</div>

				</div>
				<div class="row-fluid">

					<div class="span3 result-bucket">
						<h5>#$.slatwall.rbKey('entity.order_plural')#</h5>
						<ul class="nav" id="golbalsr-order">
							<cfif not $.slatwall.authenticateEntity("Read", "Order")>
								<li><em>#$.slatwall.rbKey('define.noAccess')#</em></li>
							</cfif>
						</ul>
					</div>

					<div class="span3 result-bucket">
						<h5>#$.slatwall.rbKey('entity.account_plural')#</h5>
						<ul class="nav" id="golbalsr-account">
							<cfif not $.slatwall.authenticateEntity("Read", "Account")>
								<li><em>#$.slatwall.rbKey('define.noAccess')#</em></li>
							</cfif>
						</ul>
					</div>

					<div class="span3 result-bucket">
						<h5>#$.slatwall.rbKey('entity.vendorOrder_plural')#</h5>
						<ul class="nav" id="golbalsr-vendorOrder">
							<cfif not $.slatwall.authenticateEntity("Read", "VendorOrder")>
								<li><em>#$.slatwall.rbKey('define.noAccess')#</em></li>
							</cfif>
						</ul>
					</div>

					<div class="span3 result-bucket">
						<h5>#$.slatwall.rbKey('entity.vendor_plural')#</h5>
						<ul class="nav" id="golbalsr-vendor">
							<cfif not $.slatwall.authenticateEntity("Read", "Vendor")>
								<li><em>#$.slatwall.rbKey('define.noAccess')#</em></li>
							</cfif>
						</ul>
					</div>

				</div>
				<div class="row-fluid">
					<div class="span12">
						<a class="close search-close"><span class="text">Close</span> &times;</a>
					</div>
				</div>
			</div>
		</div>

		<div class="container-fluid">
			<div class="row-fluid">
				<div class="span12">
					#body#
				</div>
			</div>
		</div>
		<div id="adminModal" class="modal fade"></div>
		<div id="adminDisabled" class="modal">
			<div class="modal-header"><a class="close" data-dismiss="modal">&times;</a><h3>#request.slatwallScope.rbKey('define.disabled')#</h3></div>
			<div class="modal-body"></div>
			<div class="modal-footer">
				<a href="##" class="btn btn-inverse" data-dismiss="modal"><i class="icon-ok icon-white"></i> #request.slatwallScope.rbKey('define.ok')#</a>
			</div>
		</div>
		<div id="adminConfirm" class="modal">
			<div class="modal-header"><a class="close" data-dismiss="modal">&times;</a><h3>#request.slatwallScope.rbKey('define.confirm')#</h3></div>
			<div class="modal-body"></div>
			<div class="modal-footer">
				<a href="##" class="btn btn-inverse" data-dismiss="modal"><i class="icon-remove icon-white"></i> #request.slatwallScope.rbKey('define.no')#</a>
				<a href="##" class="btn btn-primary"><i class="icon-ok icon-white"></i> #request.slatwallScope.rbKey('define.yes')#</a>
			</div>
		</div>

		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-ui-1.9.2.custom.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-ui-timepicker-addon-1.3.1.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-validate-1.9.0.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-hashchange-1.3.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-typewatch-2.0.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/bootstrap.2.3.2.min.js"></script>
		#request.slatwallScope.renderJSObject()#
		<script type="text/javascript">
			var hibachiConfig = $.slatwall.getConfig();
		</script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/global.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/assets/js/admin.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/ckeditor/ckeditor.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/ckeditor/adapters/jquery.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/ckfinder/ckfinder.js"></script>
		
		<!---
		<cfif $.slatwall.setting('globalUsageStats') and getSubsystem(request.context.slatAction) eq "admin">
			<script type="text/javascript">
				var _gaq = _gaq || [];
				_gaq.push(['_setAccount', 'UA-22767386-5']);
				_gaq.push(['_setCustomVar', 1, 'instance', '#HASH(CGI.HTTP_HOST)#']);
				_gaq.push(["_set", "title", "#request.context.slatAction#"]);
				_gaq.push(['_trackPageview']);

				(function() {
				var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
				ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
				var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
				})();
			</script>
		</cfif>
		--->
	</body>
</html>
</cfoutput>

