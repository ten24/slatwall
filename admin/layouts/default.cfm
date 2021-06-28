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
<html lang="en" id="ngApp" ng-strict-di>
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
		
		<link href="#request.slatwallScope.getBaseURL()#/admin/client/css/pacejs/pace-theme-flash.css" rel="stylesheet">
		<script>
		    // custom options for pace-js
			window.paceOptions = {
			    document: true, // disabled
			    eventLag: true,
			    restartOnPushState: true,
			    restartOnRequestAfter: true,
			    ajax: {
			        trackMethods: [ 'POST','GET']
			    }
			};
			
		</script>
		
		<link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/fonts/opensans/opensans.css" rel="stylesheet">
		<link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/css/bootstrap.min.css" rel="stylesheet">
		<link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/css/jquery-ui.min.css" rel="stylesheet">
		<link href="#request.slatwallScope.getBaseURL()#/admin/client/css/main.css?v=#$.slatwall.getApplicationValue('instantiationKey')#" rel="stylesheet">
		<cfset local.customStylesheet = request.slatwallScope.getAccount().setting('accountCustomAdminStylesheet') />
		<cfif !isNull(local.customStylesheet) >
			<style>#local.customStylesheet#</style>
		</cfif>
		<link href="#request.slatwallScope.getBaseURL()#/assets/flags/css/flag-icon.min.css" rel="stylesheet">
		<link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/client/lib/font-awesome/css/font-awesome.min.css" rel="stylesheet" type='text/css'>
		<link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/client/lib/metismenu/metismenu.css" rel="stylesheet">
        <link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/client/lib/angularjs-datetime-picker/angularjs-datetime-picker.css" rel="stylesheet">
        <hb:HibachiScript type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/client/lib/RetryProxy/lib/RetryProxyES5.js" charset="utf-8"></hb:HibachiScript>
        <script>
            function failSafeGlobalFunction(name) { //extra-args
				var args = [];
				for (var i = 1; i < arguments.length; ++i) {
		            args[i-1] = arguments[i];
		        }
		        
				//it will retry every 500ms, until succeed, or tried 2000 times 
				new RetryProxyES5(window, name, 500, 2000,true)
                .setArgs(args).run()
			}
			
			function failSafeGetTabHTMLForTabGroup( element, tab) {
				failSafeGlobalFunction('getTabHTMLForTabGroup', element, tab);
			}
        </script>
        
		<hb:HibachiScript type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/client/src/vendor.bundle.js" charset="utf-8"></hb:HibachiScript>
		<hb:HibachiScript type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/bootstrap.min.js"></hb:HibachiScript>
		#request.slatwallScope.renderJSObject()#
		<script type="text/javascript">
			var hibachiConfig = $.slatwall.getConfig();
		</script>
		<hb:HibachiScript type="text/javascript" src="#request.slatwallScope.getBaseURL()#/assets/js/admin.js"></hb:HibachiScript>
		<hb:HibachiScript type="text/javascript" src="#request.slatwallScope.getBaseURL()#/assets/js/qrcode.min.js"></hb:HibachiScript>
		<!--- Trigger Print Window --->
		<cfif $.slatwall.getLoggedInFlag() and listLen($.slatwall.getPrintQueue()) and request.context.slatAction neq "admin:print.default">
			<script type="text/javascript">
				var printWindow = window.open('#request.slatwallScope.getBaseURL()#?slatAction=admin:print.default', '_blank');
			</script>
		</cfif>
		<script src='https://www.google.com/recaptcha/api.js'></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.10.0/js/bootstrap-select.min.js"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.10.0/css/bootstrap-select.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.1/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous">

	</head>

	<body <cfif !$.slatwall.getLoggedInAsAdminFlag() && !structKeyExists(url,'ng')>class="s-login-screen"</cfif>>
		<span>
			
		<cfif $.slatwall.getLoggedInAsAdminFlag() || structKeyExists(url,'ng')>
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
							
							<hb:HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.products_nav')#" img="#request.slatwallScope.getBaseURL()#/assets/images/icon-products.svg" type="nav">
								<hb:HibachiDividerHider>
									<hb:HibachiActionCaller action="admin:entity.listproduct" type="list">
									<hb:HibachiActionCaller action="admin:entity.listproducttype" type="list">
									<hb:HibachiActionCaller action="admin:entity.listbrand" type="list">
									<hb:HibachiActionCaller action="admin:entity.listsku" type="list">
									<li class="divider"></li>
									<hb:HibachiActionCaller action="admin:entity.listoptiongroup" type="list">
									<hb:HibachiActionCaller action="admin:entity.listsubscriptionterm" type="list">
									<hb:HibachiActionCaller action="admin:entity.listsubscriptionbenefit" type="list">
								</hb:HibachiDividerHider>
							</hb:HibachiActionCallerDropdown>
							<hb:HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.orders_nav')#" img="#request.slatwallScope.getBaseURL()#/assets/images/icon-orders.svg"  type="nav">
								<hb:HibachiDividerHider>
									<hb:HibachiActionCaller action="admin:entity.listorder" type="list">
									<hb:HibachiActionCaller action="admin:entity.listreturnorder" type="list">
									<hb:HibachiActionCaller action="admin:entity.listordertemplate" type="list">
									<hb:HibachiActionCaller action="admin:entity.listcartandquote" type="list">
									<hb:HibachiActionCaller action="admin:entity.listorderitem" type="list">
									<hb:HibachiActionCaller action="admin:entity.listorderpayment" type="list">
									<li class="divider"></li>
									<hb:HibachiActionCaller action="admin:entity.listfulfillmentbatch" type="list">	
									<hb:HibachiActionCaller action="admin:entity.listorderfulfillment" type="list">
									<hb:HibachiActionCaller action="admin:entity.listorderdelivery" type="list">
									<li class="divider"></li>
									<hb:HibachiActionCaller action="admin:entity.listorderimportbatch" type="list">
									<hb:HibachiActionCaller action="admin:entity.listeventregistration" type="list">
									<hb:HibachiActionCaller action="admin:entity.listgiftcard" type="list">
									<li class="divider"></li>
									<hb:HibachiActionCaller action="admin:entity.listtemplateitembatch" type="list">
								</hb:HibachiDividerHider>
							</hb:HibachiActionCallerDropdown>
							<hb:HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.accounts_nav')#" img="#request.slatwallScope.getBaseURL()#/assets/images/icon-accounts.svg"  type="nav">
								<hb:HibachiDividerHider>
									<hb:HibachiActionCaller action="admin:entity.listaccount" type="list">
									<hb:HibachiActionCaller action="admin:entity.listwishlist" type="list">
									<hb:HibachiActionCaller action="admin:entity.listsubscriptionusage" type="list">
									<hb:HibachiActionCaller action="admin:entity.listpermissiongroup" type="list">
									<li class="divider"></li>
									<hb:HibachiActionCaller action="admin:entity.listledgeraccount" type="list">
									<hb:HibachiActionCaller action="admin:entity.listvendor" type="list">
								</hb:HibachiDividerHider>
							</hb:HibachiActionCallerDropdown>
							<hb:HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.warehouse_nav')#" img="#request.slatwallScope.getBaseURL()#/assets/images/icon-warehouse.svg" type="nav">
								<hb:HibachiDividerHider>
									<hb:HibachiActionCaller action="admin:entity.listlocation" type="list">
									<hb:HibachiActionCaller action="admin:entity.liststock" type="list">
									<hb:HibachiActionCaller action="admin:entity.liststockreceiver" type="list">
									<hb:HibachiActionCaller action="admin:entity.liststockadjustment" type="list">
									<hb:HibachiActionCaller action="admin:entity.liststockadjustmentitem" type="list">
									<hb:HibachiActionCaller action="admin:entity.listphysical" type="list">
									<hb:HibachiActionCaller action="admin:entity.listinventoryanalysis" type="list">
									<hb:HibachiActionCaller action="admin:entity.listcontainerpreset" type="list">
									<hb:HibachiActionCaller action="admin:entity.listcyclecountgroup" type="list">
									<hb:HibachiActionCaller action="admin:entity.listcyclecountbatch" type="list">
									<li class="divider"></li>
									<hb:HibachiActionCaller action="admin:entity.listminmaxsetup" type="list">
									<hb:HibachiActionCaller action="admin:entity.listminmaxstocktransfer" type="list">
									<li class="divider"></li>
									<hb:HibachiActionCaller action="admin:entity.listvendororder" type="list">
									<hb:HibachiActionCaller action="admin:entity.listvendororderitem" type="list">
								</hb:HibachiDividerHider>
							</hb:HibachiActionCallerDropdown>
							<hb:HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.marketing_nav')#" img="#request.slatwallScope.getBaseURL()#/assets/images/icon-marketing.svg" menuitemclass="border" type="nav">
								<hb:HibachiDividerHider>
									<hb:HibachiActionCaller action="admin:entity.listpromotion" type="list">
									<hb:HibachiActionCaller action="admin:entity.listpricegroup" type="list">
									<cfif $.slatwall.authenticateAction(action='admin:entity.listcontent')>
										<hb:HibachiActionCaller queryString="ng##!/entity/Content" text="#$.slatwall.rbKey('admin.entity.listcontent')#" type="list">
									</cfif>
									<hb:HibachiActionCaller action="admin:entity.listcategory" type="list">
									<hb:HibachiActionCaller action="admin:entity.listform" type="list">
									<hb:HibachiActionCaller action="admin:entity.listsite" type="list">
									<hb:HibachiActionCaller action="admin:entity.listemailtemplate" type="list">
									<hb:HibachiActionCaller action="admin:entity.listproductreview" type="list">
									<hb:HibachiActionCaller action="admin:entity.listloyalty" type="list">
									<hb:HibachiActionCaller action="admin:entity.listloyaltyterm" type="list">
								</hb:HibachiDividerHider>
							</hb:HibachiActionCallerDropdown>
							<hb:HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.telligence_nav')#" img="#request.slatwallScope.getBaseURL()#/assets/images/icon-telligence.svg" menuitemclass="border" type="nav">
								<hb:HibachiDividerHider>
									<hb:HibachiActionCaller action="admin:report" type="list">
									<hb:HibachiActionCaller action="admin:entity.listcollection" type="list">
									<cfif $.slatwall.authenticateAction(action='admin:entity.listworkflow')>
										<hb:HibachiActionCaller queryString="ng##!/entity/Workflow" text="#$.slatwall.rbKey('admin.entity.listworkflow')#" type="list">
									</cfif>
									<hb:HibachiActionCaller action="admin:entity.listbatch" type="list">
									<hb:HibachiActionCaller action="admin:entity.listentityqueue" type="list">
									<hb:HibachiActionCaller action="admin:entity.listimportermapping" type="list">
									<hb:HibachiActionCaller action="admin:report.revenuerecognitionreport" type="list">
									<hb:HibachiActionCaller action="admin:report.earnedrevenuereport" type="list">
									<hb:HibachiActionCaller action="admin:report.deferredrevenuereport" type="list">
									<hb:HibachiActionCaller action="admin:report.subscriptionOrdersReport" type="list">
									<hb:HibachiActionCaller action="admin:report.cancelledOrdersReport" type="list">
								</hb:HibachiDividerHider>
							</hb:HibachiActionCallerDropdown>
							<cfset local.integrationSubsystems = $.slatwall.getService('integrationService').getActiveFW1Subsystems() />
							<cfif arrayLen(local.integrationSubsystems)>
								<hb:HibachiActionCallerDropdown title="#$.slatwall.rbKey('admin.default.integrations_nav')#" img="#request.slatwallScope.getBaseURL()#/assets/images/icon-integrations.svg"  type="nav">
									<cfloop array="#local.integrationSubsystems#" index="local.intsys">
										<cfset local.integration = $.slatwall.getService('integrationService').getIntegrationByIntegrationPackage(local.intsys['subsystem']) />
										<hb:HibachiActionCaller action="#local.intsys['subsystem']#:main.default" text="#local.integration.getDisplayName()#" type="list">
										<cfset local.integrationCFC = $.slatwall.getService('integrationService').getIntegrationCFC(local.integration) />
										<cfif NOT isNull(local.integrationCFC) AND structKeyExists(local.integrationCFC,'getMenuItems')>
											<cfloop array="#local.integrationCFC.getMenuItems()#" index="local.menuitem">
												<hb:HibachiActionCaller action="#local.menuitem['action']#" text="#local.menuitem['text']#" type="list">
											</cfloop>
										</cfif>
									</cfloop>
								</hb:HibachiActionCallerDropdown>
							</cfif>

						</ul>
						<div class="pull-right s-temp-nav">
							<ul class="nav navbar-nav">
							    
							    <hb:HibachiActionCallerDropdown title="" img="#request.slatwallScope.getBaseURL()#/assets/images/icon-settings.svg" dropdownclass="pull-right s-settings-dropdown" type="nav">
									<hb:HibachiDividerHider>
										<hb:HibachiActionCaller action="admin:entity.settings" title="#$.slatwall.rbKey('admin.setting_nav')#" type="list">
										<hb:HibachiActionCaller action="admin:entity.listattributeset" type="list">
										<hb:HibachiActionCaller action="admin:entity.listintegration" type="list">
										<li class="divider"></li>
										<hb:HibachiActionCaller action="admin:entity.listapp" type="list">
										<hb:HibachiActionCaller action="admin:entity.listaddresszone" type="list">
										<hb:HibachiActionCaller action="admin:entity.listaccountrelationshiprole" type="list">
										<hb:HibachiActionCaller action="admin:entity.listcountry" type="list">
										<hb:HibachiActionCaller action="admin:entity.listcurrency" type="list">
										<hb:HibachiActionCaller action="admin:entity.listfulfillmentmethod" type="list">
										<hb:HibachiActionCaller action="admin:entity.listmeasurementunit" type="list">
										<hb:HibachiActionCaller action="admin:entity.listorderorigin" type="list">
										<hb:HibachiActionCaller action="admin:entity.listpaymentmethod" type="list">
										<hb:HibachiActionCaller action="admin:entity.listpaymentterm" type="list">
										<hb:HibachiActionCaller action="admin:entity.listprinttemplate" type="list">
										<hb:HibachiActionCaller action="admin:entity.listroundingrule" type="list">
										<hb:HibachiActionCaller action="admin:entity.listtaxcategory" type="list">
										<hb:HibachiActionCaller action="admin:entity.listterm" type="list">
										<hb:HibachiActionCaller action="admin:entity.listtype" type="list">
										<hb:HibachiActionCaller action="admin:entity.listfilegroup" type="list">
									</hb:HibachiDividerHider>
								</hb:HibachiActionCallerDropdown>
								
								<hb:HibachiActionCallerDropdown title="" img="#request.slatwallScope.getBaseURL()#/assets/images/icon-tools.svg" dropdownclass="pull-right" type="nav">
									<hb:HibachiDividerHider>
										<hb:HibachiActionCaller action="admin:entity.listschedule" type="list">
										<hb:HibachiActionCaller action="admin:main.ckfinder" type="list" modal="true">
									<hb:HibachiActionCaller action="admin:entity.listapilog" type="list">
										<hb:HibachiActionCaller action="admin:entity.listaudit" type="list">
										<hb:HibachiActionCaller action="admin:entity.listemail" type="list">
										<cfif $.slatwall.getLoggedInAsAdminFlag()> 
										<hb:HibachiActionCaller action="admin:entity.detailaccount" querystring="accountID=#$.slatwall.account('accountID')#" type="list">
										<hb:HibachiActionCaller action="admin:main.logout" type="list">
										<li class="divider"></li>
									</cfif>
									<li><a title="User Docs" href="https://www.slatwallcommerce.com/user-guide" target="_blank">#$.slatwall.rbKey('define.userGuide')#</a></li>
									<li><a title="Developer Docs" href="https://www.slatwallcommerce.com/developer" target="_blank">#$.slatwall.rbKey('define.developerDocs')#</a></li>
									<hb:HibachiActionCaller action="admin:main.system" type="list">
									</hb:HibachiDividerHider>
									<li class="divider"></li>
									<hb:HibachiActionCaller action="admin:main.changelanguage" 
										queryString="?rbLocale=en_us&redirectURL=#urlEncodedFormat($.slatwall.getURL())#" 
										text="<i class='flag-icon flag-icon-us'></i> #$.slatwall.rbKey('define.language.en_us')#" 
										type="list"
										ignoreHTMLEditFormat="true"
									>
									<hb:HibachiActionCaller action="admin:main.changelanguage" 
										queryString="?rbLocale=en_gb&redirectURL=#urlEncodedFormat($.slatwall.getURL())#" 
										text="<i class='flag-icon flag-icon-gb'></i> #$.slatwall.rbKey('define.language.en_gb')#" 
										type="list"
										ignoreHTMLEditFormat="true"
									>
									<hb:HibachiActionCaller action="admin:main.changelanguage" 
										queryString="?rbLocale=fr_fr&redirectURL=#urlEncodedFormat($.slatwall.getURL())#" 
										text="<i class='flag-icon flag-icon-fr'></i> #$.slatwall.rbKey('define.language.fr_fr')#" 
										type="list"
										ignoreHTMLEditFormat="true"
									>
									<hb:HibachiActionCaller action="admin:main.changelanguage" 
										queryString="?rbLocale=de_de&redirectURL=#urlEncodedFormat($.slatwall.getURL())#" 
										text="<i class='flag-icon flag-icon-de'></i> #$.slatwall.rbKey('define.language.de_de')#" 
										type="list"
										ignoreHTMLEditFormat="true"	
									>
								</hb:HibachiActionCallerDropdown>
							</ul>
						</div>
					</div><!--- navbar collapes --->
				</div>
			</div>
			<!--- End old navbar --->
			</cfif>

			<section class="content s-body-margin" id="j-main-content">

				<div class="col-md-12">
					<cfif structKeyExists(url, 'ng')>
						<ng-view></ng-view>
					<cfelseif structKeyExists(url, 'ngRedirectURL')>
						<script>window.location.href = "/?ng##!#EncodeForURL(url.ngRedirectURL)#";</script>
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
							<a href="##" class="btn btn-sm btn-primary" data-dismiss="modal" id="disabledOkLink"><i class="icon-ok icon-white"></i> #request.slatwallScope.rbKey('define.ok')#</a>
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
							<button type="submit" form="adminConfirmForm" class="btn btn-sm btn-default btn-primary hide" id="confirmYesButton"><i class="icon-ok icon-white"></i> #request.slatwallScope.rbKey('define.yes')#</button>
						</div>
					</div>
				</div>
			</div>

			<!--- Page Dialog Controller --->
			<div ng-controller="pageDialog">
				<div id="topOfPageDialog" >
					<div ng-style="{pageDialogStyle:pageDialogs.length}" ng-hide="!pageDialogs.length" ng-class="{'s-dialog-container':pageDialogs.length}" ng-repeat="pageDialog in pageDialogs" >
						<div class="s-swipe-background"></div>
						<div ng-include="pageDialog.path" ></div>
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

		<cfif
			(structKeyExists(request,'isWysiwygPage') AND request.isWysiwygPage)
			|| (structKeyExists(rc,'edit'))
		>
			<hb:HibachiScript type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/ckeditor/ckeditor.js"></hb:HibachiScript>
			<hb:HibachiScript type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/ckeditor/adapters/jquery.js"></hb:HibachiScript>
			<hb:HibachiScript type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/ckfinder/ckfinder.js"></hb:HibachiScript>
		</cfif>

		<!--- Webpack bundles--->
		<cfinclude template="#request.slatwallScope.getBaseURL()#/admin/client/dist/SlatwallAdminBundle.cfm" />
		
		<hb:HibachiScript type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/global.js"></hb:HibachiScript>

	</body>
</html>
</cfoutput>
