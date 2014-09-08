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
<html lang="en" ng-app="slatwall">
	<head>
		<meta charset="utf-8">
		<title>#rc.pageTitle# &##124; Slatwall</title>

		<link rel="icon" href="#request.slatwallScope.getBaseURL()#/assets/images/favicon.png" type="image/png" />
		<link rel="shortcut icon" href="#request.slatwallScope.getBaseURL()#/assets/images/favicon.png" type="image/png" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0">



		<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet">
		<link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/css/jquery-ui-1.9.2.custom.css" rel="stylesheet">
		<link href="#request.slatwallScope.getBaseURL()#/admin/client/css/main.css" rel="stylesheet">
		<link href="#request.slatwallScope.getBaseURL()#/assets/flags/css/flag-icon.min.css" rel="stylesheet">
		<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,600,800,700' rel='stylesheet' type='text/css'>
		<link rel="stylesheet" href="../../client/lib/font-awesome/css/font-awesome.min.css">
		
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-ui-1.9.2.custom.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-ui-timepicker-addon-1.3.1.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-validate-1.9.0.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-typewatch-2.0.js"></script>
		
		#request.slatwallScope.renderJSObject()#
		<script type="text/javascript">
			var hibachiConfig = $.slatwall.getConfig();
		</script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/global.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/assets/js/admin.js"></script>

		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/ckeditor/ckeditor.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/ckeditor/adapters/jquery.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/ckfinder/ckfinder.js"></script>

		<!--- Trigger Print Window --->
		<cfif arrayLen($.slatwall.getPrintQueue()) and request.context.slatAction neq "admin:print.default">
			<script type="text/javascript">
				var printWindow = window.open('#request.slatwallScope.getBaseURL()#?slatAction=admin:print.default', '_blank');
			</script>
		</cfif>
	</head>
	<body>
		<nav class="navbar navbar-default navbar-fixed-top navbar-inverse" id="slatwall-primary-navbar" role="navigation">
			<div class="container-fluid">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="##slatwall-primary-nav">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
					<cfset homeLink = request.slatwallScope.getBaseURL() />
					<cfif not len(homeLink)>
						<cfset homeLink = "/" />
					</cfif>
					<a href="#homeLink#" class="navbar-brand"><img src="#request.slatwallScope.getBaseURL()#/assets/images/admin.logo.png" style="width:100px;heigh:16px;" title="Slatwall" /></a>
				</div><!-- .navbar-header -->

				<div class="collapse navbar-collapse" id="slatwall-primary-nav">
					<ul class="nav navbar-nav">
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
								<cf_HibachiActionCaller action="admin:entity.listloyalty" type="list">
								<cf_HibachiActionCaller action="admin:entity.listloyaltyterm" type="list">
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
									<cf_HibachiActionCaller action="#local.intsys['subsystem']#:main.default" text="#local.intsys['name']#" type="list">
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
								<cf_HibachiActionCaller action="admin:entity.listaudit" type="list">
								<cf_HibachiActionCaller action="admin:main.update" type="list">
								<cfif $.slatwall.getAccount().getSuperUserFlag()>
									<cf_HibachiActionCaller action="admin:main.default" querystring="reload=true" type="list" text="Reload Slatwall">
								</cfif>
							</cf_HibachiDividerHider>
						</cf_HibachiActionCallerDropdown>
					</ul>

					<cfif $.slatwall.getLoggedInAsAdminFlag()>
						<form name="search" class="navbar-form navbar-right" action="/" onSubmit="return false;">
							<div class="form-group">
								<input id="global-search" type="text" name="serach" class="form-control search-query span2" placeholder="Search">
							</div>
						</form>
					</cfif>

					<ul class="nav navbar-nav navbar-right">
						<cfif $.slatwall.getLoggedInAsAdminFlag()>
							<cf_HibachiActionCallerDropdown title="" icon="user icon-white" dropdownclass="pull-right" type="nav">
								<cf_HibachiActionCaller action="admin:entity.detailaccount" querystring="accountID=#$.slatwall.account('accountID')#" type="list">
								<cf_HibachiActionCaller action="admin:main.logout" type="list">
								<li class="divider"></li>
								<li><a title="User Docs" href="http://docs.getslatwall.com/##users" target="_blank">User Docs</a></li>
								<li><a title="Developer Docs" href="http://docs.getslatwall.com/##developer" target="_blank">Developer Docs</a></li>
								<cf_HibachiActionCaller action="admin:main.about" type="list">
							</cf_HibachiActionCallerDropdown>
						</cfif>
						<cf_HibachiActionCallerDropdown icon=" flag-icon flag-icon-#lcase(listLast($.slatwall.getRBLocale(), '_' ))#" dropdownclass="pull-right" type="nav">
							<cf_HibachiActionCaller action="admin:main.changelanguage" queryString="?rbLocale=en_us&redirectURL=#urlEncodedFormat($.slatwall.getURL())#" text="<i class='flag-icon flag-icon-us'></i> #$.slatwall.rbKey('define.language.en_us')#" type="list">
							<cf_HibachiActionCaller action="admin:main.changelanguage" queryString="?rbLocale=en_gb&redirectURL=#urlEncodedFormat($.slatwall.getURL())#" text="<i class='flag-icon flag-icon-gb'></i> #$.slatwall.rbKey('define.language.en_gb')#" type="list">
							<cf_HibachiActionCaller action="admin:main.changelanguage" queryString="?rbLocale=fr_fr&redirectURL=#urlEncodedFormat($.slatwall.getURL())#" text="<i class='flag-icon flag-icon-fr'></i> #$.slatwall.rbKey('define.language.fr_fr')#" type="list">
							<cf_HibachiActionCaller action="admin:main.changelanguage" queryString="?rbLocale=de_de&redirectURL=#urlEncodedFormat($.slatwall.getURL())#" text="<i class='flag-icon flag-icon-de'></i> #$.slatwall.rbKey('define.language.de_de')#" type="list">
						</cf_HibachiActionCallerDropdown>
					</ul>

				</div><!-- /##slatwall-primary-nav /.navbar-collapse -->

			</div><!-- /.container-fluid -->
		</nav><!-- /.navbar -->

		<!---
		<div id="search-results" class="search-results">
			<div class="container-fluid">
				<div class="row">

					<div class="col-md-3 result-bucket">
						<h5>#$.slatwall.rbKey('entity.product_plural')#</h5>
						<ul class="nav" id="golbalsr-product">
							<cfif not $.slatwall.authenticateEntity("Read", "Product")>
								<li><em>#$.slatwall.rbKey('define.noAccess')#</em></li>
							</cfif>
						</ul>
					</div>

					<div class="col-md-3 result-bucket">
						<h5>#$.slatwall.rbKey('entity.productType_plural')#</h5>
						<ul class="nav" id="golbalsr-productType">
							<cfif not $.slatwall.authenticateEntity("Read", "ProductType")>
								<li><em>#$.slatwall.rbKey('define.noAccess')#</em></li>
							</cfif>
						</ul>
					</div>

					<div class="col-md-3  result-bucket">
						<h5>#$.slatwall.rbKey('entity.brand_plural')#</h5>
						<ul class="nav" id="golbalsr-brand">
							<cfif not $.slatwall.authenticateEntity("Read", "Brand")>
								<li><em>#$.slatwall.rbKey('define.noAccess')#</em></li>
							</cfif>
						</ul>
					</div>

					<div class="col-md-3 result-bucket">
						<h5>#$.slatwall.rbKey('entity.promotion_plural')#</h5>
						<ul class="nav" id="golbalsr-promotion">
							<cfif not $.slatwall.authenticateEntity("Read", "Promotion")>
								<li><em>#$.slatwall.rbKey('define.noAccess')#</em></li>
							</cfif>
						</ul>
					</div>

				</div>
				<div class="row">

					<div class="col-md-3 result-bucket">
						<h5>#$.slatwall.rbKey('entity.order_plural')#</h5>
						<ul class="nav" id="golbalsr-order">
							<cfif not $.slatwall.authenticateEntity("Read", "Order")>
								<li><em>#$.slatwall.rbKey('define.noAccess')#</em></li>
							</cfif>
						</ul>
					</div>

					<div class="col-md-3 result-bucket">
						<h5>#$.slatwall.rbKey('entity.account_plural')#</h5>
						<ul class="nav nav-navbar" id="golbalsr-account">
							<cfif not $.slatwall.authenticateEntity("Read", "Account")>
								<li><em>#$.slatwall.rbKey('define.noAccess')#</em></li>
							</cfif>
						</ul>
					</div>

					<div class="col-md-3 result-bucket">
						<h5>#$.slatwall.rbKey('entity.vendorOrder_plural')#</h5>
						<ul class="nav" id="golbalsr-vendorOrder">
							<cfif not $.slatwall.authenticateEntity("Read", "VendorOrder")>
								<li><em>#$.slatwall.rbKey('define.noAccess')#</em></li>
							</cfif>
						</ul>
					</div>

					<div class="col-md-3 result-bucket">
						<h5>#$.slatwall.rbKey('entity.vendor_plural')#</h5>
						<ul class="nav" id="golbalsr-vendor">
							<cfif not $.slatwall.authenticateEntity("Read", "Vendor")>
								<li><em>#$.slatwall.rbKey('define.noAccess')#</em></li>
							</cfif>
						</ul>
					</div>

				</div>
				<div class="row">
					<div class="col-md-12">
						<a class="close search-close"><span class="text">Close</span> &times;</a>
					</div>
				</div>
			</div>
		</div>
		--->
		<script type="text/javascript">
			var guid = (function() {
			  function s4() {
			    return Math.floor((1 + Math.random()) * 0x10000)
			               .toString(16)
			               .substring(1);
			  }
			  return function() {
			    return s4() + s4() + s4() + s4() +
			           s4() + s4() + s4() + s4();
			  };
			})();
		</script>
		
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/date/date.min.js"></script>

		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/angular/angular.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/angular-ui-bootstrap/ui.bootstrap.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/angular/angular-resource.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/angular/angular-cookies.min.js"></script>
		
		<!---modules --->
		<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/client/js/slatwall.js"></script>
	 	<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/slatwalladmin.js"></script>
	 	<!---services --->
	 	<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/services/slatwallservice.js"></script>
	 	<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/services/alertservice.js"></script>
	 	<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/services/collectionservice.js"></script>

	 	<!---controllers --->
	 	<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/controllers/collections.js"></script>
	 	<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/controllers/collectionstabcontroller.js"></script>
	 	<!---directives --->
	 	<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/directives/swheaderwithtabs.js"></script>
	 	<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/directives/swdirective.js"></script>

		<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/directives/swfiltergroups.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/directives/swfilteritem.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/directives/swaddfilterbuttons.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/directives/sweditfilteritem.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/directives/swfiltergroupitem.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/directives/swcriteria.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/directives/swdisplayoptions.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/directives/swcolumnitem.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/directives/pagination.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/admin/client/js/directives/swpropertydisplay.js"></script>

		<div class="container-fluid">
			<div class="row">
				<div class="col-md-12">
					<cfset currentURL = request.context.slatAction >
					<cfif findNoCase("entity.list", currentURL)>
						<div class="s-nav-spacer">
							#body#
						</div>	
					<cfelse>
						#body#
					</cfif>
				</div>
			</div>

		</div>

		<div id="adminModal" class="modal fade">
			
		</div>
		<div id="adminDisabled" class="modal">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header"><a class="close" data-dismiss="modal">&times;</a><h3>#request.slatwallScope.rbKey('define.disabled')#</h3></div>
					<div class="modal-body"></div>
					<div class="modal-footer">
						<a href="##" class="btn btn-default btn-inverse" data-dismiss="modal" id="disabledOkLink"><i class="icon-ok icon-white"></i> #request.slatwallScope.rbKey('define.ok')#</a>
					</div>
				</div>
			</div>
		</div>
		<div id="adminConfirm" class="modal">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header"><a class="close" data-dismiss="modal">&times;</a><h3>#request.slatwallScope.rbKey('define.confirm')#</h3></div>
					<div class="modal-body"></div>
					<div class="modal-footer">
						<a href="##" class="btn btn-default btn-inverse" data-dismiss="modal" id="confirmNoLink"><i class="icon-remove icon-white"></i> #request.slatwallScope.rbKey('define.no')#</a>
						<a href="##" class="btn btn-default btn-primary" id="confirmYesLink"><i class="icon-ok icon-white"></i> #request.slatwallScope.rbKey('define.yes')#</a>
					</div>
				</div>
			</div>
		</div>
		<!---displays alerts to the user --->
		<div  ng-class="{fade:alert.fade,'alert\-success':alert.type==='success','alert\-danger':alert.type==='error'}" class="alert s-alert-footer" role="alert"
		ng-repeat="alert in alerts"
		>
			<!---only show a dismissable button if we are showing info or a warning --->
		  	<button style="display:none;" ng-show="alert.dismissable" type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
		  	<!---show check mark only if success, always display message --->
		  	<i style="display:none;" class="fa fa-check" ng-show="alert.type === 'success'"></i>&nbsp;<span ng-bind="alert.msg"></span>
	    </div>
	</body>
</html>
</cfoutput>
