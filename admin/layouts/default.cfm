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
<cfimport prefix="swa" taglib="../../tags" />
<cfimport prefix="hb" taglib="../../org/Hibachi/HibachiTags" />
<cfoutput>
<!DOCTYPE html>
<html lang="en" ng-app="slatwalladmin">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>#rc.pageTitle# &##124; Slatwall</title>

		<link rel="icon" href="#request.slatwallScope.getBaseURL()#/assets/images/favicon.png" type="image/png" />
		<link rel="shortcut icon" href="#request.slatwallScope.getBaseURL()#/assets/images/favicon.png" type="image/png" />
		<meta name="viewport" content="width=device-width,initial-scale=1.0">
		
		<cfif CGI.HTTP_USER_AGENT CONTAINS "MSIE 9">
			<cfset baseHREF=request.slatwallScope.getBaseURL() />
			<cfif len(baseHREF) gt 1>
				<cfset baseHREF = right(baseHREF, len(baseHREF)-1) & '/index.cfm/'>
			<cfelse>
				<cfset baseHREF = "index.cfm/">
			</cfif>
			
			<base href="#baseHREF#" />
		</cfif>

		<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet">
		<link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/css/jquery-ui-1.9.2.custom.css" rel="stylesheet">
		<link href="#request.slatwallScope.getBaseURL()#/admin/client/css/main.css" rel="stylesheet">
		<link href="#request.slatwallScope.getBaseURL()#/assets/flags/css/flag-icon.min.css" rel="stylesheet">
		<link href='//fonts.googleapis.com/css?family=Open+Sans:400,600,800,700' rel='stylesheet' type='text/css'>
		<link href="#request.slatwallScope.getBaseURL()#/client/lib/font-awesome/css/font-awesome.min.css" rel="stylesheet" type='text/css'>
		<link href="#request.slatwallScope.getBaseURL()#/client/lib/metismenu/metismenu.css" rel="stylesheet">

		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-ui-1.9.2.custom.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-ui-timepicker-addon-1.3.1.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-validate-1.9.0.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-typewatch-2.0.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/selectBoxIt/selectBoxIt.min.js"></script>

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
	
	<!--- Start old navbar --->
	<body>
		<span>
			<div class="navbar navbar-fixed-top navbar-inverse" role="navigation" id="slatwall-navbar">
				<div class="container-fluid" style="text-align:left;">
	
					<div class="navbar-header">
						<cfset homeLink = request.slatwallScope.getBaseURL() />
						<cfif not len(homeLink)>
							<cfset homeLink = "/" />
						</cfif>
						<a href="#homeLink#" target="_self" class="brand"><img src="#request.slatwallScope.getBaseURL()#/assets/images/admin.logo.png" title="Slatwall" /></a>
					</div>
					<div class="pull-right s-right-nav-content" id="j-mobile-nav">
						<ul class="nav navbar-nav">
							<li class="divider-vertical"></li>
							<hb:HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.products_nav')#" icon="tags icon-white" type="nav">
								<hb:HibachiDividerHider>
									<hb:HibachiActionCaller action="admin:entity.listproduct" type="list">
									<hb:HibachiActionCaller action="admin:entity.listproducttype" type="list">
									<hb:HibachiActionCaller action="admin:entity.listbrand" type="list">
									<hb:HibachiActionCaller action="admin:entity.listsku" type="list">
									<hb:HibachiActionCaller action="admin:entity.listproductreview" type="list">
									<li class="divider"></li>
									<hb:HibachiActionCaller action="admin:entity.listoptiongroup" type="list">
									<hb:HibachiActionCaller action="admin:entity.listsubscriptionterm" type="list">
									<hb:HibachiActionCaller action="admin:entity.listsubscriptionbenefit" type="list">
									<hb:HibachiActionCaller action="admin:entity.listcategory" type="list">
									<hb:HibachiActionCaller action="admin:entity.listcontent" type="list">
									<li class="divider"></li>
									<hb:HibachiActionCaller action="admin:entity.listpromotion" type="list">
									<hb:HibachiActionCaller action="admin:entity.listpricegroup" type="list">
								</hb:HibachiDividerHider>
							</hb:HibachiActionCallerDropdown>
							<hb:HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.orders_nav')#" icon="inbox icon-white" type="nav">
								<hb:HibachiDividerHider>
									<hb:HibachiActionCaller action="admin:entity.listorder" type="list">
									<hb:HibachiActionCaller action="admin:entity.listcartandquote" type="list">
									<hb:HibachiActionCaller action="admin:entity.listorderitem" type="list">
									<hb:HibachiActionCaller action="admin:entity.listorderfulfillment" type="list">
									<hb:HibachiActionCaller action="admin:entity.listorderpayment" type="list">
									<hb:HibachiActionCaller action="admin:entity.listorderdelivery" type="list">
									<li class="divider"></li>
									<hb:HibachiActionCaller action="admin:entity.listvendororder" type="list">
									<hb:HibachiActionCaller action="admin:entity.listvendororderitem" type="list">
								</hb:HibachiDividerHider>
							</hb:HibachiActionCallerDropdown>
							<hb:HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.accounts_nav')#" icon="user icon-white" type="nav">
								<hb:HibachiDividerHider>
									<hb:HibachiActionCaller action="admin:entity.listaccount" type="list">
									<hb:HibachiActionCaller action="admin:entity.listsubscriptionusage" type="list">
									<hb:HibachiActionCaller action="admin:entity.listpermissiongroup" type="list">
									<li class="divider"></li>
									<hb:HibachiActionCaller action="admin:entity.listloyalty" type="list">
									<hb:HibachiActionCaller action="admin:entity.listloyaltyterm" type="list">
									<li class="divider"></li>
									<hb:HibachiActionCaller action="admin:entity.listvendor" type="list">
								</hb:HibachiDividerHider>
							</hb:HibachiActionCallerDropdown>
							<hb:HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.warehouse_nav')#" icon="barcode icon-white" type="nav">
								<hb:HibachiActionCaller action="admin:entity.liststockreceiver" type="list">
								<hb:HibachiActionCaller action="admin:entity.liststockadjustment" type="list">
								<hb:HibachiActionCaller action="admin:entity.listphysical" type="list">
							</hb:HibachiActionCallerDropdown>
							<cfset local.integrationSubsystems = $.slatwall.getService('integrationService').getActiveFW1Subsystems() />
							<cfif arrayLen(local.integrationSubsystems)>
								<hb:HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.integrations_nav')#" icon="random icon-white" type="nav">
									<cfloop array="#local.integrationSubsystems#" index="local.intsys">
										<hb:HibachiActionCaller action="#local.intsys['subsystem']#:main.default" text="#local.intsys['name']#" type="list">
									</cfloop>
								</hb:HibachiActionCallerDropdown>
							</cfif>
							<hb:HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.configure_nav')#" icon="cog icon-white" type="nav">
								<hb:HibachiDividerHider>
									<hb:HibachiActionCaller action="admin:entity.settings" title="#$.slatwall.rbKey('admin.setting_nav')#" type="list">
									<hb:HibachiActionCaller action="admin:entity.listattributeset" type="list">
									<hb:HibachiActionCaller action="admin:entity.listintegration" type="list">
									<li class="divider"></li>
									<hb:HibachiActionCaller action="admin:entity.listaddresszone" type="list">
									<hb:HibachiActionCaller action="admin:entity.listcollection" type="list">
									<hb:HibachiActionCaller action="admin:entity.listcountry" type="list">
									<hb:HibachiActionCaller action="admin:entity.listcurrency" type="list">
									<hb:HibachiActionCaller action="admin:entity.listemailtemplate" type="list">
									<hb:HibachiActionCaller action="admin:entity.listfulfillmentmethod" type="list">
									<hb:HibachiActionCaller action="admin:entity.listlocation" type="list">
									<hb:HibachiActionCaller action="admin:entity.listmeasurementunit" type="list">
									<hb:HibachiActionCaller action="admin:entity.listorderorigin" type="list">
									<hb:HibachiActionCaller action="admin:entity.listpaymentmethod" type="list">
									<hb:HibachiActionCaller action="admin:entity.listpaymentterm" type="list">
									<hb:HibachiActionCaller action="admin:entity.listprinttemplate" type="list">
									<hb:HibachiActionCaller action="admin:entity.listroundingrule" type="list">
									<hb:HibachiActionCaller action="admin:entity.listsite" type="list">
									<hb:HibachiActionCaller action="admin:entity.listtaxcategory" type="list">
									<hb:HibachiActionCaller action="admin:entity.listterm" type="list">
									<hb:HibachiActionCaller action="admin:entity.listtype" type="list">
									<cfif $.slatwall.authenticateAction(action='admin:entity.listworkflow')>
										<hb:HibachiActionCaller queryString="ng##!/entity/Workflow" text="#$.slatwall.rbKey('admin.entity.listworkflow')#" type="list">
									</cfif>
								</hb:HibachiDividerHider>
							</hb:HibachiActionCallerDropdown>
							<hb:HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.tools_nav')#" icon="magnet icon-white" type="nav">
								<hb:HibachiDividerHider>
									<hb:HibachiActionCaller action="admin:report" type="list">
									<hb:HibachiActionCaller action="admin:entity.listeventtrigger" type="list">
									<hb:HibachiActionCaller action="admin:entity.listschedule" type="list">
									<hb:HibachiActionCaller action="admin:entity.listsession" type="list">
									<hb:HibachiActionCaller action="admin:entity.listtask" type="list">
									<hb:HibachiActionCaller action="admin:entity.listtaskhistory" type="list">
									<hb:HibachiActionCaller action="admin:main.ckfinder" type="list" modal="true" />
									<hb:HibachiActionCaller action="admin:main.log" type="list">
									<hb:HibachiActionCaller action="admin:entity.listaudit" type="list">
									<hb:HibachiActionCaller action="admin:main.update" type="list">
									<cfif $.slatwall.getAccount().getSuperUserFlag()>
										<hb:HibachiActionCaller action="admin:main.encryptionupdatepassword" type="list">
										<hb:HibachiActionCaller action="admin:main.encryptionreencryptdata" type="list">
										<hb:HibachiActionCaller action="admin:main.default" querystring="reload=true" type="list" text="Reload Slatwall">
									</cfif>
								</hb:HibachiDividerHider>
							</hb:HibachiActionCallerDropdown>
							
						</ul>
						<div class="pull-right s-temp-nav">
							<ul class="nav navbar-nav">
								<li ng-controller="globalSearch">
									<cfif $.slatwall.getLoggedInAsAdminFlag()>
	
										<!--- Start of Search --->
										<form name="search" class="navbar-form navbar-right s-header-search" action="/" onSubmit="return false;" autocomplete="off" style="padding: 7px;margin-right: 0px;margin-left: 20px;">
											<div class="form-group">
												<input type="text" name="search" class="form-control search-query col-xs-2" placeholder="#$.slatwall.rbKey('define.search')#" ng-model="keywords" ng-change="updateSearchResults()">
												<a ng-show="searchResultsOpen" class="s-close-icon-search" id="s-close-search" href="##" ng-click="hideResults()"><i class="fa fa-times"></i></a>
											</div>
											<div class="row s-search-results ng-hide" style="padding-top:15px;" ng-show="searchResultsOpen">
												<ul class="col-md-12 list-unstyled">
													<li ng-repeat="searchResult in searchResults" ng-show="searchResult.results.length && resultsFound">
														<div class="col-md-4 s-title">
															<h2 ng-bind="searchResult.title"></h2>
														</div>
														<div class="col-md-8 s-body">
															<ul class="list-unstyled" id="j-search-results"	>
																<li ng-repeat="result in searchResult.results"><a target="_self" href="{{result.link}}" ng-bind="result.name"></a></li>
															</ul>
														</div>
													</li>
													<li ng-hide="resultsFound" class="ng-hide col-md-8 s-body">
														<ul class="list-unstyled">
															<li class="s-no-results"><br /><em>#$.slatwall.rbKey('admin.define.nosearchresults')#</em></li>
														</ul>
													</li>
												</ul>
												<div class="spinner" ng-show="loading"><i class="fa fa-refresh fa-spin"></i></div>
											</div>
										</form>
										<!--- End of Search --->
	
									</cfif>
								</li>
								<hb:HibachiActionCallerDropdown title="" icon="cogs icon-white" dropdownclass="pull-right s-settings-dropdown" dropdownId="j-mobile-nav" type="nav">
									<cfif $.slatwall.getLoggedInAsAdminFlag()>
										<hb:HibachiActionCaller action="admin:entity.detailaccount" querystring="accountID=#$.slatwall.account('accountID')#" type="list">
										<hb:HibachiActionCaller action="admin:main.logout" type="list">
										<li class="divider"></li>
									</cfif>
									<li><a title="User Docs" href="http://docs.getslatwall.com/##users-administrator-overview" target="_blank">#$.slatwall.rbKey('define.userGuide')#</a></li>
									<li><a title="Developer Docs" href="http://docs.getslatwall.com/##developer" target="_blank">#$.slatwall.rbKey('define.developerDocs')#</a></li>
									<hb:HibachiActionCaller action="admin:main.about" type="list">
									<li class="divider"></li>
									<hb:HibachiActionCaller action="admin:main.changelanguage" queryString="?rbLocale=en_us&redirectURL=#urlEncodedFormat($.slatwall.getURL())#" text="<i class='flag-icon flag-icon-us'></i> #$.slatwall.rbKey('define.language.en_us')#" type="list">
									<hb:HibachiActionCaller action="admin:main.changelanguage" queryString="?rbLocale=en_gb&redirectURL=#urlEncodedFormat($.slatwall.getURL())#" text="<i class='flag-icon flag-icon-gb'></i> #$.slatwall.rbKey('define.language.en_gb')#" type="list">
									<hb:HibachiActionCaller action="admin:main.changelanguage" queryString="?rbLocale=fr_fr&redirectURL=#urlEncodedFormat($.slatwall.getURL())#" text="<i class='flag-icon flag-icon-fr'></i> #$.slatwall.rbKey('define.language.fr_fr')#" type="list">
									<hb:HibachiActionCaller action="admin:main.changelanguage" queryString="?rbLocale=de_de&redirectURL=#urlEncodedFormat($.slatwall.getURL())#" text="<i class='flag-icon flag-icon-de'></i> #$.slatwall.rbKey('define.language.de_de')#" type="list">
								</hb:HibachiActionCallerDropdown>
							</ul>
						</div>
					</div><!--- navbar collapes --->
				</div>
			</div>
			<!--- End old navbar --->
	
			<section class="content s-body-margin" id="j-main-content">
	
				<div class="col-md-12">
					<cfif structKeyExists(url, 'ng')>
						<ng-view></ng-view>
					<cfelse>
						#body#
					</cfif>
				</div>
	
			</section>
	
			<!-- Admin Modals -->
			<div id="adminModal" class="modal fade">
	
			</div>
			<div id="adminDisabled" class="modal">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header"><a class="close" data-dismiss="modal">&times;</a><h3>#request.slatwallScope.rbKey('define.disabled')#</h3></div>
						<div class="modal-body"></div>
						<div class="modal-footer">
							<a href="##" class="btn btn-sm btn-default btn-inverse" data-dismiss="modal" id="disabledOkLink"><i class="icon-ok icon-white"></i> #request.slatwallScope.rbKey('define.ok')#</a>
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
							<a href="##" target="_self" class="btn btn-sm btn-default btn-inverse" data-dismiss="modal" id="confirmNoLink"><i class="icon-remove icon-white"></i> #request.slatwallScope.rbKey('define.no')#</a>
							<a href="##" target="_self" class="btn btn-sm btn-default btn-primary" id="confirmYesLink"><i class="icon-ok icon-white"></i> #request.slatwallScope.rbKey('define.yes')#</a>
						</div>
					</div>
				</div>
			</div>
	
			<!--- Page Dialog Controller --->
			<div ng-controller="pageDialog">
				<div id="topOfPageDialog" >
					<div ng-style="{pageDialogStyle:pageDialogs.length}" ng-hide="!pageDialogs.length" ng-class="{'s-dialog-container':pageDialogs.length}" ng-repeat="pageDialog in pageDialogs" >
						<div  ng-include="pageDialog.path" ></div>
					</div>
				</div>
			</div>
	
			<!---displays alerts to the user --->
			<span ng-controller="alertController" >
				<span ng-repeat="alert in alerts">
					<div style="z-index:11000" ng-class="{fade:alert.fade,'alert\-success':alert.type==='success','alert\-danger':alert.type==='error'}" class="alert s-alert-footer fade in" role="alert" >
						<!---only show a dismissable button if we are showing info or a warning --->
						<button style="display:none;" ng-show="alert.dismissable" type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
						<!---show check mark only if success, always display message --->
						<i style="display:none;" class="fa fa-check" ng-show="alert.type === 'success'"></i>&nbsp;<span ng-bind="alert.msg"></span>
					</div>
				</span>
			</span>
		</span>
		
		<!---lib BEGIN --->
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/date/date.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/angular/angular.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/angular-ui-bootstrap/ui.bootstrap.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/angular/angular-resource.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/angular/angular-cookies.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/angular/angular-animate.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/angular/angular-route.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/metismenu/metismenu.js"></script>
		
		<!---lib END --->
		<script type="text/javascript">
			var slatwallAngular = {};
			slatwallAngular.slatwallConfig = $.slatwall.getConfig();
			<cfif !isnull(rc.ng)> 
				slatwallAngular.hashbang = true;
			</cfif>
			slatwallAngular.constantPaths = [];
			<cfloop collection="#rc.$.slatwall.getService('hibachiService').getEntitiesMetaData()#" item="local.entityName">
				slatwallAngular.constantPaths.push('#local.entityName#');
			</cfloop>

		</script>
		
		<!--- Load up the Slatwall Angular Provider --->
		

		<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/?slatAction=api:js.ngslatwall&instantiationKey=#$.slatwall.getApplicationValue('instantiationKey')#"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/?slatAction=api:js.ngcompressor&jspath=client/js&instantiationKey=#$.slatwall.getApplicationValue('instantiationKey')#"></script>
		<!--- Load up the Slatwall Admin --->
		<script type="text/javascript" src="#request.slatwallScope.getBaseUrl()#/?slatAction=api:js.ngcompressor&jspath=admin/client/js&instantiationKey=#$.slatwall.getApplicationValue('instantiationKey')#"></script>
		
	</body>
</html>
</cfoutput>
