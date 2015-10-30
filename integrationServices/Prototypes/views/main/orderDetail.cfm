

<!DOCTYPE html>
<html lang="en" ng-app="slatwalladmin">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>Order - Reinaldo Solares &#124; Slatwall</title>

		<link rel="icon" href="/assets/images/favicon.png" type="image/png" />
		<link rel="shortcut icon" href="/assets/images/favicon.png" type="image/png" />
		<meta name="viewport" content="width=device-width,initial-scale=1.0">
		
		

		<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet">
		<link href="/org/Hibachi/HibachiAssets/css/jquery-ui-1.9.2.custom.css" rel="stylesheet">
		<link href="/admin/client/css/main.css" rel="stylesheet">
		<link href="/assets/flags/css/flag-icon.min.css" rel="stylesheet">
		<link href='//fonts.googleapis.com/css?family=Open+Sans:400,600,800,700' rel='stylesheet' type='text/css'>
		<link href="/client/lib/font-awesome/css/font-awesome.min.css" rel="stylesheet" type='text/css'>
		<link href="/client/lib/metismenu/metismenu.css" rel="stylesheet">

		<script type="text/javascript" src="/org/Hibachi/HibachiAssets/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="/org/Hibachi/HibachiAssets/js/jquery-ui-1.9.2.custom.min.js"></script>
		<script type="text/javascript" src="/org/Hibachi/HibachiAssets/js/jquery-ui-timepicker-addon-1.3.1.js"></script>
		<script type="text/javascript" src="/org/Hibachi/HibachiAssets/js/jquery-validate-1.9.0.min.js"></script>
		<script type="text/javascript" src="/org/Hibachi/HibachiAssets/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="/org/Hibachi/HibachiAssets/js/jquery-typewatch-2.0.js"></script>
		<script type="text/javascript" src="/client/lib/selectBoxIt/selectBoxIt.min.js"></script>

		<script type="text/javascript" src="/org/Hibachi/HibachiAssets/js/hibachi-scope.js"></script><script type="text/javascript">(function( $ ){$.slatwall = new Hibachi({"rbLocale":"en_us","timeFormat":"hh:mm tt","instantiationKey":"2249601B-92D2-0DEF-33980D0AD074ADD8","debugFlag":true,"action":"slatAction","dateFormat":"mmm dd, yyyy","baseURL":""});})( jQuery );</script> 
		<script type="text/javascript">
			var hibachiConfig = $.slatwall.getConfig();
		</script>
		<script type="text/javascript" src="/org/Hibachi/HibachiAssets/js/global.js"></script>
		<script type="text/javascript" src="/assets/js/admin.js"></script>

		<script type="text/javascript" src="/org/Hibachi/ckeditor/ckeditor.js"></script>
		<script type="text/javascript" src="/org/Hibachi/ckeditor/adapters/jquery.js"></script>
		<script type="text/javascript" src="/org/Hibachi/ckfinder/ckfinder.js"></script>


		
		
	</head>
	
	
	<body>
		<span>
			<div class="navbar navbar-fixed-top navbar-inverse" role="navigation" id="slatwall-navbar">
				<div class="container-fluid" style="text-align:left;">
	
					<div class="navbar-header">
						<a href="/" target="_self" class="brand"><img src="/assets/images/admin.logo.png" title="Slatwall" /></a>
					</div>
					<div class="collapse navbar-collapse pull-right" id="bs-example-navbar-collapse-1">
						<ul class="nav navbar-nav">
							<li class="divider-vertical"></li>
							
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"><i class="fa fa-tags icon-white"></i> Products </a>
					<ul class="dropdown-menu ">
						<li><a title="Products" class="adminentitylistproduct " target="_self" href="/?slatAction=entity.listproduct">Products</a></li> <li><a title="Product Types" class="adminentitylistproducttype " target="_self" href="/?slatAction=entity.listproducttype">Product Types</a></li> <li><a title="Brands" class="adminentitylistbrand " target="_self" href="/?slatAction=entity.listbrand">Brands</a></li> <li><a title="Skus" class="adminentitylistsku " target="_self" href="/?slatAction=entity.listsku">Skus</a></li> <li><a title="Product Reviews" class="adminentitylistproductreview " target="_self" href="/?slatAction=entity.listproductreview">Product Reviews</a></li> 
									<li class="divider"></li>
									<li><a title="Option Groups" class="adminentitylistoptiongroup " target="_self" href="/?slatAction=entity.listoptiongroup">Option Groups</a></li> <li><a title="Subscription Terms" class="adminentitylistsubscriptionterm " target="_self" href="/?slatAction=entity.listsubscriptionterm">Subscription Terms</a></li> <li><a title="Subscription Benefits" class="adminentitylistsubscriptionbenefit " target="_self" href="/?slatAction=entity.listsubscriptionbenefit">Subscription Benefits</a></li> <li><a title="Categories" class="adminentitylistcategory " target="_self" href="/?slatAction=entity.listcategory">Categories</a></li> <li><a title="Contents" class="adminentitylistcontent " target="_self" href="/?slatAction=entity.listcontent">Contents</a></li> 
									<li class="divider"></li>
									<li><a title="Promotions" class="adminentitylistpromotion " target="_self" href="/?slatAction=entity.listpromotion">Promotions</a></li> <li><a title="Price Groups" class="adminentitylistpricegroup " target="_self" href="/?slatAction=entity.listpricegroup">Price Groups</a></li> 
					</ul>
				</li>
			
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"><i class="fa fa-inbox icon-white"></i> Orders </a>
					<ul class="dropdown-menu ">
						<li><a title="Orders" class="adminentitylistorder " target="_self" href="/?slatAction=entity.listorder">Orders</a></li> <li><a title="Carts & Quotes" class="adminentitylistcartandquote " target="_self" href="/?slatAction=entity.listcartandquote">Carts & Quotes</a></li> <li><a title="Order Items" class="adminentitylistorderitem " target="_self" href="/?slatAction=entity.listorderitem">Order Items</a></li> <li><a title="Order Fulfillments" class="adminentitylistorderfulfillment " target="_self" href="/?slatAction=entity.listorderfulfillment">Order Fulfillments</a></li> <li><a title="Order Payments" class="adminentitylistorderpayment " target="_self" href="/?slatAction=entity.listorderpayment">Order Payments</a></li> <li><a title="Order Deliveries" class="adminentitylistorderdelivery " target="_self" href="/?slatAction=entity.listorderdelivery">Order Deliveries</a></li> 
									<li class="divider"></li>
									<li><a title="Vendor Orders" class="adminentitylistvendororder " target="_self" href="/?slatAction=entity.listvendororder">Vendor Orders</a></li> <li><a title="Vendor Order Items" class="adminentitylistvendororderitem " target="_self" href="/?slatAction=entity.listvendororderitem">Vendor Order Items</a></li> 
					</ul>
				</li>
			
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"><i class="fa fa-user icon-white"></i> Accounts </a>
					<ul class="dropdown-menu ">
						<li><a title="Accounts" class="adminentitylistaccount " target="_self" href="/?slatAction=entity.listaccount">Accounts</a></li> <li><a title="Subscription Usages" class="adminentitylistsubscriptionusage " target="_self" href="/?slatAction=entity.listsubscriptionusage">Subscription Usages</a></li> <li><a title="Permission Groups" class="adminentitylistpermissiongroup " target="_self" href="/?slatAction=entity.listpermissiongroup">Permission Groups</a></li> 
									<li class="divider"></li>
									<li><a title="Loyalty Programs" class="adminentitylistloyalty " target="_self" href="/?slatAction=entity.listloyalty">Loyalty Programs</a></li> <li><a title="Loyalty Terms" class="adminentitylistloyaltyterm " target="_self" href="/?slatAction=entity.listloyaltyterm">Loyalty Terms</a></li> 
									<li class="divider"></li>
									<li><a title="Vendors" class="adminentitylistvendor " target="_self" href="/?slatAction=entity.listvendor">Vendors</a></li> 
					</ul>
				</li>
			
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"><i class="fa fa-barcode icon-white"></i> Warehouse </a>
					<ul class="dropdown-menu ">
						<li><a title="Stock Receivers" class="adminentityliststockreceiver " target="_self" href="/?slatAction=entity.liststockreceiver">Stock Receivers</a></li> <li><a title="Stock Adjustments" class="adminentityliststockadjustment " target="_self" href="/?slatAction=entity.liststockadjustment">Stock Adjustments</a></li> <li><a title="Physicals" class="adminentitylistphysical " target="_self" href="/?slatAction=entity.listphysical">Physicals</a></li> 
					</ul>
				</li>
			
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"><i class="fa fa-cog icon-white"></i> Config </a>
					<ul class="dropdown-menu ">
						<li><a title="View A List of Settings" class="adminentitysettings " target="_self" href="/?slatAction=entity.settings">Settings</a></li> <li><a title="Attribute Sets" class="adminentitylistattributeset " target="_self" href="/?slatAction=entity.listattributeset">Attribute Sets</a></li> <li><a title="Integrations" class="adminentitylistintegration " target="_self" href="/?slatAction=entity.listintegration">Integrations</a></li> 
									<li class="divider"></li>
									<li><a title="Address Zones" class="adminentitylistaddresszone " target="_self" href="/?slatAction=entity.listaddresszone">Address Zones</a></li> <li><a title="Collections" class="adminentitylistcollection " target="_self" href="/?slatAction=entity.listcollection">Collections</a></li> <li><a title="Countries" class="adminentitylistcountry " target="_self" href="/?slatAction=entity.listcountry">Countries</a></li> <li><a title="Currencies" class="adminentitylistcurrency " target="_self" href="/?slatAction=entity.listcurrency">Currencies</a></li> <li><a title="Email Templates" class="adminentitylistemailtemplate " target="_self" href="/?slatAction=entity.listemailtemplate">Email Templates</a></li> <li><a title="Fulfillment Methods" class="adminentitylistfulfillmentmethod " target="_self" href="/?slatAction=entity.listfulfillmentmethod">Fulfillment Methods</a></li> <li><a title="Locations" class="adminentitylistlocation " target="_self" href="/?slatAction=entity.listlocation">Locations</a></li> <li><a title="Measurement Units" class="adminentitylistmeasurementunit " target="_self" href="/?slatAction=entity.listmeasurementunit">Measurement Units</a></li> <li><a title="Order Origins" class="adminentitylistorderorigin " target="_self" href="/?slatAction=entity.listorderorigin">Order Origins</a></li> <li><a title="Payment Methods" class="adminentitylistpaymentmethod " target="_self" href="/?slatAction=entity.listpaymentmethod">Payment Methods</a></li> <li><a title="Payment Terms" class="adminentitylistpaymentterm " target="_self" href="/?slatAction=entity.listpaymentterm">Payment Terms</a></li> <li><a title="Print Templates" class="adminentitylistprinttemplate " target="_self" href="/?slatAction=entity.listprinttemplate">Print Templates</a></li> <li><a title="Rounding Rules" class="adminentitylistroundingrule " target="_self" href="/?slatAction=entity.listroundingrule">Rounding Rules</a></li> <li><a title="Sites" class="adminentitylistsite " target="_self" href="/?slatAction=entity.listsite">Sites</a></li> <li><a title="Tax Categories" class="adminentitylisttaxcategory " target="_self" href="/?slatAction=entity.listtaxcategory">Tax Categories</a></li> <li><a title="Terms" class="adminentitylistterm " target="_self" href="/?slatAction=entity.listterm">Terms</a></li> <li><a title="Types" class="adminentitylisttype " target="_self" href="/?slatAction=entity.listtype">Types</a></li> <li><a title="Workflows" class=" " target="_self" href="/?ng#!/entity/Workflow">Workflows</a></li> 
					</ul>
				</li>
			
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"><i class="fa fa-magnet icon-white"></i> Tools </a>
					<ul class="dropdown-menu ">
						<li><a title="Reporting Dashboard" class="adminreport " target="_self" href="/?slatAction=report">Reporting Dashboard</a></li> <li><a title="Event Triggers" class="adminentitylisteventtrigger " target="_self" href="/?slatAction=entity.listeventtrigger">Event Triggers</a></li> <li><a title="Schedules" class="adminentitylistschedule " target="_self" href="/?slatAction=entity.listschedule">Schedules</a></li> <li><a title="Sessions" class="adminentitylistsession " target="_self" href="/?slatAction=entity.listsession">Sessions</a></li> <li><a title="Tasks" class="adminentitylisttask " target="_self" href="/?slatAction=entity.listtask">Tasks</a></li> <li><a title="Task Histories" class="adminentitylisttaskhistory " target="_self" href="/?slatAction=entity.listtaskhistory">Task Histories</a></li> <li><a title="File Manager" class="adminmainckfinder  modalload" target="_self" href="/?slatAction=main.ckfinder" data-toggle="modal" data-target="#adminModal">File Manager</a></li> <li><a title="Slatwall Log" class="adminmainlog " target="_self" href="/?slatAction=main.log">Slatwall Log</a></li> <li><a title="Audits" class="adminentitylistaudit " target="_self" href="/?slatAction=entity.listaudit">Audits</a></li> <li><a title="Update Slatwall" class="adminmainupdate " target="_self" href="/?slatAction=main.update">Update Slatwall</a></li> <li><a title="Update Database Encryption Password" class="adminmainencryptionupdatepassword " target="_self" href="/?slatAction=main.encryptionupdatepassword">Update Database Encryption Password</a></li> <li><a title="Re-encrypt Database" class="adminmainencryptionreencryptdata " target="_self" href="/?slatAction=main.encryptionreencryptdata">Re-encrypt Database</a></li> <li><a title="Reload Slatwall" class="adminmaindefault " target="_self" href="/?reload=true">Reload Slatwall</a></li> 
					</ul>
				</li>
			
						</ul>
						<div class="pull-right s-temp-nav">
							<ul class="nav navbar-nav">
								<li ng-controller="globalSearch">
									
	
										
										<form name="search" class="navbar-form navbar-right s-header-search" action="/" onSubmit="return false;" autocomplete="off" style="padding: 7px;margin-right: 0px;margin-left: 20px;">
											<div class="form-group">
												<input type="text" name="search" class="form-control search-query col-xs-2" placeholder="Search" ng-model="keywords" ng-change="updateSearchResults()">
												<a ng-show="searchResultsOpen" class="s-close-icon-search" id="s-close-search" href="#" ng-click="hideResults()"><i class="fa fa-times"></i></a>
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
														<ul>
															<li class="s-no-results"><br /><em>No Results Found</em></li>
														</ul>
													</li>
												</ul>
												<div class="spinner" ng-show="loading"><i class="fa fa-refresh fa-spin"></i></div>
											</div>
										</form>
										
	
									
								</li>
								
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"><i class="fa fa-cogs icon-white"></i>  </a>
					<ul class="dropdown-menu pull-right">
						<li><a title="View Account" class="adminentitydetailaccount " target="_self" href="/?slatAction=entity.detailaccount&accountID=4028808d4a307132014a3083047e000a">View Account</a></li> <li><a title="Logout" class="adminmainlogout " target="_self" href="/?slatAction=main.logout">Logout</a></li> 
										<li class="divider"></li>
									
									<li><a title="User Docs" href="http://docs.getslatwall.com/#users-administrator-overview" target="_blank">User Guide</a></li>
									<li><a title="Developer Docs" href="http://docs.getslatwall.com/#developer" target="_blank">Developer Docs</a></li>
									<li><a title="About Slatwall" class="adminmainabout " target="_self" href="/?slatAction=main.about">About Slatwall</a></li> 
									<li class="divider"></li>
									<li><a title="<i class='flag-icon flag-icon-us'></i> English (US)" class="adminmainchangelanguage " target="_self" href="/?slatAction=main.changelanguage&rbLocale=en_us&redirectURL=http%3A%2F%2Fcf10%2Eslatwall%2Findex%2Ecfm%3FslatAction%3Dentity%2Eeditorder%26orderID%3D8a8080874a3b3ecb014a549547fb0050"><i class='flag-icon flag-icon-us'></i> English (US)</a></li> <li><a title="<i class='flag-icon flag-icon-gb'></i> English (UK)" class="adminmainchangelanguage " target="_self" href="/?slatAction=main.changelanguage&rbLocale=en_gb&redirectURL=http%3A%2F%2Fcf10%2Eslatwall%2Findex%2Ecfm%3FslatAction%3Dentity%2Eeditorder%26orderID%3D8a8080874a3b3ecb014a549547fb0050"><i class='flag-icon flag-icon-gb'></i> English (UK)</a></li> <li><a title="<i class='flag-icon flag-icon-fr'></i> French" class="adminmainchangelanguage " target="_self" href="/?slatAction=main.changelanguage&rbLocale=fr_fr&redirectURL=http%3A%2F%2Fcf10%2Eslatwall%2Findex%2Ecfm%3FslatAction%3Dentity%2Eeditorder%26orderID%3D8a8080874a3b3ecb014a549547fb0050"><i class='flag-icon flag-icon-fr'></i> French</a></li> <li><a title="<i class='flag-icon flag-icon-de'></i> German" class="adminmainchangelanguage " target="_self" href="/?slatAction=main.changelanguage&rbLocale=de_de&redirectURL=http%3A%2F%2Fcf10%2Eslatwall%2Findex%2Ecfm%3FslatAction%3Dentity%2Eeditorder%26orderID%3D8a8080874a3b3ecb014a549547fb0050"><i class='flag-icon flag-icon-de'></i> German</a></li> 
					</ul>
				</li>
			
							</ul>
						</div>
					</div>
				</div>
			</div>
			
	
			<section class="content s-body-margin" id="j-main-content">
	
				<div class="col-md-12">
								
			<form method="post" action="?s=1" class="" enctype="multipart/form-data" id="adminentitysaveorder">
			<input type="hidden" name="slatAction" value="admin:entity.saveorder" />
			<input type="hidden" name="orderID" value="8a8080874a3b3ecb014a549547fb0050" />
			<input type="hidden" name="sRedirectAction" value="admin:entity.detailorder" /> <input type="hidden" name="sRenderItem" value="detailorder" /> <input type="hidden" name="fRenderItem" value="editorder" /> 

			<div class="row s-body-nav">
				<nav class="navbar navbar-default" role="navigation">
				<div class="col-md-6 s-header-info">
					
						
						<ul class="list-unstyled list-inline">
							
							
						</ul>
						
						<h1 class="actionbar-title">Order - Reinaldo Solares</h1>
					</div>

					<div class="col-md-6">
						<div class="btn-toolbar">

							
							
								<div class="btn-group btn-group-sm">
									
									<a title="Carts & Quotes" class="adminentitylistcartandquote btn btn-default" target="_self" href="/?slatAction=entity.listcartandquote"><i class="glyphicon glyphicon-arrow-left"></i> Carts & Quotes</a> 
										<button class="btn dropdown-toggle btn-default" data-toggle="dropdown"><i class="icon-list-alt"></i> Actions <span class="caret"></span></button>
										<ul class="dropdown-menu pull-right">
											<li><a title="Place Order" class="adminentitypreProcessOrder  modalload" target="_self" href="/?slatAction=entity.preProcessOrder&sRedirectAction=admin:entity.detailorder&processContext=placeOrder&orderID=8a8080874a3b3ecb014a549547fb0050" data-toggle="modal" data-target="#adminModal">Place Order</a></li>  <li><a title="Force Status Update" class="adminentityprocessOrder " target="_self" href="/?slatAction=entity.processOrder&processContext=updateStatus&orderID=8a8080874a3b3ecb014a549547fb0050">Force Status Update</a></li> 
			
			<li class="divider"></li>
			
			
			<li><a title="Add Order Payment" class="adminentitypreProcessOrder  modalload" target="_self" href="/?slatAction=entity.preProcessOrder&processContext=addOrderPayment&orderID=8a8080874a3b3ecb014a549547fb0050" data-toggle="modal" data-target="#adminModal">Add Order Payment</a></li> <li><a title="Add Promotion Code" class="adminentitypreProcessOrder  modalload" target="_self" href="/?slatAction=entity.preProcessOrder&processContext=addPromotionCode&orderID=8a8080874a3b3ecb014a549547fb0050" data-toggle="modal" data-target="#adminModal">Add Promotion Code</a></li> <li><a title="Add Comment" class="adminentitycreatecomment  modalload" target="_self" href="/?slatAction=entity.createcomment&orderID=8a8080874a3b3ecb014a549547fb0050&redirectAction=admin:entity.editorder" data-toggle="modal" data-target="#adminModal">Add Comment</a></li> 
										</ul>
									
								</div>

								
								<div class="btn-group btn-group-sm">
									
											<a class="btn dropdown-toggle btn-default" data-toggle="dropdown" href="#"><i class="fa fa-envelope"></i></a>
											<ul class="dropdown-menu pull-right">
												<li><a title="Order Confirmation" class="adminentitypreprocessemail  modalload-fullwidth" target="_self" href="/?slatAction=entity.preprocessemail&emailTemplateID=dbb327e506090fde08cc4855fa14448d&orderID=8a8080874a3b3ecb014a549547fb0050&redirectAction=admin:entity.editorder&processContext=addToQueue" data-toggle="modal" data-target="#adminModal">Order Confirmation</a></li> 
											</ul>
										
								</div>
								

								
								

								
								
								<div class="btn-group btn-group-sm">
									
									<a title="Delete" class="adminentitydeleteorder btn btn-default s-remove alert-confirm" target="_self" href="/?slatAction=entity.deleteorder&redirectAction=admin:entity.listcartandquote&orderID=8a8080874a3b3ecb014a549547fb0050" data-confirm="Are you sure you would like to delete this Order?"><i class="glyphicon glyphicon-trash icon-white"></i> Delete</a> <a title="Cancel" class="adminentitydetailorder btn btn-default" target="_self" href="/?slatAction=entity.detailorder&orderID=8a8080874a3b3ecb014a549547fb0050"><i class="glyphicon glyphicon-remove icon-white"></i> Cancel</a> <button class="btn adminentitysaveorder btn btn-success" title="Save"type="submit"><i class="glyphicon glyphicon-ok icon-white"></i> Save</button> 
								</div>

								
								
						</div>
					</div>
				</nav>
			</div>
		
			<div class="row s-pannel-control">
				<div class="col-md-12 s-toggle-panels">
					<a href="#" class="j-openall j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Expand All"><i class="fa fa-expand"></i></a>
					<a href="#" class="j-closeall j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Collapse All"><i class="fa fa-compress"></i></a>
				</div>
			</div>

			
			<div class="panel-group s-pannel-group" id="accordion">		  
				
					<div class="j-panel panel panel-default">
						<a data-toggle="collapse"  href="#collapse1">
							<div class="panel-heading">
								<h4 class="panel-title">
									<span>Basic</span>
									<i class="fa fa-caret-left s-accordion-toggle-icon"></i>
								</h4>
							</div>
						</a>
						<div id="collapse1" class="panel-collapse collapse in">
							<content class="s-body-box">
								
									<div class="tab-pane" id="tabbasic">
										
			<div class="row">
		
		<div class="col-md-6">
			
				<div class="form-horizontal">
			
					<div class="form-group ">
						<label for="account.accountID" class="control-label col-sm-4" style="text-align:left;">Customer Account</label></dt>
						<div class="col-sm-8">
							
				<div class="autoselect-container">
					<input type="hidden" name="account.accountID" value="8a8080874a3b3ecb014a54954777004d" />
					<input type="text" name="account_accountID-autocompletesearch" autocomplete="off" class="textautocomplete  form-control" data-acfieldname="account.accountID" data-sugessionsid="accountaccountidsuggestions" data-acpropertyidentifiers="adminIcon,fullName,company,emailAddress,phoneNumber,address.simpleRepresentation" data-entityName="Account" data-acvalueproperty="accountID" data-acnameproperty="simpleRepresentation" disabled="disabled" />
					<div class="autocomplete-selected" ><a href="#" class="textautocompleteremove"><i class="glyphicon glyphicon-remove"></i></a> <span class="value" id="selected-accountaccountidsuggestions">Reinaldo Solares</span></div>
					<div class="autocomplete-options" style="display:none;">
						<ul class="accountid" id="accountaccountidsuggestions">
							
								<li>
									<a href="#" class="textautocompleteadd" data-acvalue="8a8080874a3b3ecb014a54954777004d" data-acname="Reinaldo Solares">
									
											<span class="adminIcon">
										<img src="http://www.gravatar.com/avatar/43dd9636a8746812cf0c4943ba468b16?s=55" style="width:55px;" /></span>
									
											<span class="fullName first">
										Reinaldo Solares</span>
									
											<span class="company">
										Ten24</span>
									
											<span class="emailAddress">
										reinaldosolares@gmail.com</span>
									
											<span class="phoneNumber">
										7604738055</span>
									
											<span class="simpleRepresentation">
										</span>
									
									</a>
								</li>
							
						</ul>
					</div>
					
				</div>
			
						</div>
					</div>
				
					<div class="form-group ">
						<label for="orderOrigin.orderOriginID" class="control-label col-sm-4" style="text-align:left;">Order Origin</label></dt>
						<div class="col-sm-8">
							
				<select name="orderOrigin.orderOriginID" class="form-control  j-custom-select" >
					
						<option value=""  selected="selected">None</option>
					
				</select>
			
						</div>
					</div>
				
					<div class="form-group s-required">
						<label for="orderType.typeID" class="control-label col-sm-4" style="text-align:left;">Order Type</label></dt>
						<div class="col-sm-8">
							
				<select name="orderType.typeID" class="form-control required j-custom-select" >
					
						<option value="444df2df9f923d6c6fd0942a466e84cc"  selected="selected">Sales Order</option>
					
						<option value="444df2e00b455a2bae38fb55f640c204" >Exchange Order</option>
					
				</select>
			
						</div>
					</div>
				
					<div class="form-group ">
						<label for="defaultStockLocation.locationID" class="control-label col-sm-4" style="text-align:left;">Default Stock Location</label></dt>
						<div class="col-sm-8">
							
				<select name="defaultStockLocation.locationID" class="form-control  j-custom-select" >
					
						<option value=""  selected="selected">None</option>
					
						<option value="88e6d435d3ac2e5947c81ab3da60eba2" >Default</option>
					
				</select>
			
						</div>
					</div>
				
					<div class="form-group ">
						<label for="assignedAccount.accountID" class="control-label col-sm-4" style="text-align:left;">Assigned Account</label></dt>
						<div class="col-sm-8">
							
				<div class="autoselect-container">
					<input type="hidden" name="assignedAccount.accountID" value="" />
					<input type="text" name="assignedAccount_accountID-autocompletesearch" autocomplete="off" class="textautocomplete  form-control" data-acfieldname="assignedAccount.accountID" data-sugessionsid="assignedaccountaccountidsuggestions" data-acpropertyidentifiers="adminIcon,fullName,company,emailAddress,phoneNumber,address.simpleRepresentation" data-entityName="Account" data-acvalueproperty="accountID" data-acnameproperty="simpleRepresentation"  />
					<div class="autocomplete-selected" style="display:none;"><a href="#" class="textautocompleteremove"><i class="glyphicon glyphicon-remove"></i></a> <span class="value" id="selected-assignedaccountaccountidsuggestions"></span></div>
					<div class="autocomplete-options" style="display:none;">
						<ul class="accountid" id="assignedaccountaccountidsuggestions">
							
						</ul>
					</div>
					
				</div>
			
						</div>
					</div>
				
				</div>
			
		</div>
	
		<div class="col-md-6">
			
				<div class="form-horizontal">
			
		<div class="table-responsive">
			<table class="table table-condensed" id="hibachiPropertyTable1">
				<tbody>
	
		<tr class="s-table-header">
			<td colspan="2" class="table-section" style="background-color: #ddd;font-weight:600;font-size:14px;color:#666;padding: 3px 10px;">Overview</td>
		</tr>
	
					<tr>
						<td class="title">Order Status</td>
						
							<td class="value">Not Placed</td>
						
					</tr>
				
					<tr>
						<td class="title">Currency Code</td>
						
							<td class="value">USD</td>
						
					</tr>
				
					<tr>
						<td class="title">Subtotal</td>
						
							<td class="value">$45.00</td>
						
					</tr>
				
					<tr>
						<td class="title">Tax Total</td>
						
							<td class="value">$0.00</td>
						
					</tr>
				
					<tr>
						<td class="title">Fulfillment Amount</td>
						
							<td class="value">$0.00</td>
						
					</tr>
				
					<tr>
						<td class="title">Discount</td>
						
							<td class="value">$0.00</td>
						
					</tr>
				
					<tr>
						<td class="title table-total">Total</td>
						
							<td class="value table-total">$45.00</td>
						
					</tr>
				
		<tr class="s-table-header">
			<td colspan="2" class="table-section" style="background-color: #ddd;font-weight:600;font-size:14px;color:#666;padding: 3px 10px;">Payments</td>
		</tr>
	
					<tr>
						<td class="title">Received Amount</td>
						
							<td class="value">$0.00</td>
						
					</tr>
				
					<tr>
						<td class="title">Credited Amount</td>
						
							<td class="value">$0.00</td>
						
					</tr>
				
					<tr>
						<td class="title table-total">Payment Amount Due</td>
						
							<td class="value table-total">$45.00</td>
						
					</tr>
				
				</tbody>
			</table>
		</div>
	
				</div>
			
		</div>
	
		</div>
	
									</div>
								
							</content>
						</div>
					</div>
				
					<div class="j-panel panel panel-default">
						<a data-toggle="collapse"  href="#collapse2">
							<div class="panel-heading">
								<h4 class="panel-title">
									<span>Sale Order Items</span> <span class="badge">1</span>
									<i class="fa fa-caret-left s-accordion-toggle-icon"></i>
								</h4>
							</div>
						</a>
						<div id="collapse2" class="panel-collapse collapse in">
							
							
							
							
							
<!--/////////////////// START BUNDLE LISTING EXAMPLE///////////////////-->						
						
							<content class="s-body-box">
								<div class="table-responsive">
									<table class="table table-bordered s-order-item-table">
										<thead>
											<tr>
												<th>Image</th>
												<th>Title</th>
												<th>Sku</th>
												<th>Details</th>
												<th>Customization</th>
												<th>Price</th>
												<th>Qty</th>
												<th>Discount</th>
												<th>Item Total</th>
												<th>Fullfilment</th>
												<th></th>
											</tr>
										</thead>
										<tbody class="s-main-product">
											<tr class="s-bundle-product l-1" data-id="B-625TX78">
												<td rowspan="1000" class="s-image" data-id="j-B-625TX78"><img src="http://placehold.it/90x90"></td>
												<td class="s-title">Custom Necklace <a href="" class="s-toggle-detail-link">hide detail</a></td>
												<td class="s-sku">B-625TX78</td>
												<td class="s-details"></td>
												<td class="s-customization"></td>
												<td class="s-price">
													<ul>
														<li class="s-price-total">$50.00</li>
														<li class="s-price-list">
															<ul>
																<li>+$0.00 (Base Price)</li>
																<li>+$50.00 (Extras)</li>
															</ul>
														</li>
													</ul>
												</td>
												<td class="s-qty">2</td>
												<td class="s-discount">-$5.00</td>
												<td class="s-total">
													<ul>
														<li class="s-price-total">$95.00</li>
														<li class="s-price-list">
															<ul>
																<li>+$0.00 (Base Price)</li>
																<li>+$100.00 (Extras)</li>
															</ul>
														</li>
													</ul>
												</td>
												<td rowspan="1000" class="s-fullfilment">
													<ul>
														<li class="s-header">Ship To: <a href="#" class="s-edit-link">edit</a></li>
														<li>
															<ul>
																<li>123 Demo.</li>
																<li>New York, NY 01532</li>
															</ul>
														</li>
													</ul>
												</td>
												<td rowspan="1000" class="s-actions">
													<ul>
														<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
														<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
													</ul>
												</td>
											</tr>
											<tr class="s-product l-2" data-id="B-625TX78">
												<td class="s-title">Charms: Heart Charm <a href="#" class="s-edit-link">edit</a></td>
												<td class="s-sku">F-JH67GH</td>
												<td class="s-details">
													<ul>
														<li>Color: Red</li>
													</ul>
												</td>
												<td class="s-customization">
													<ul>
														<li>Engraving: Reyjay</li>
													</ul>
												</td>
												<td class="s-price">+$10.00</td>
												<td class="s-qty">2</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">+$20.00</td>
											</tr>
											<tr class="s-bundle-product l-2" data-id="B-625TX78">
												<td class="s-title">Charms: Round Custom Charm <a href="#" class="s-edit-link">edit</a></td>
												<td class="s-sku">J-688DSF</td>
												<td class="s-details"></td>
												<td class="s-customization"></td>
												<td class="s-price">
													<ul>
														<li class="s-price-total">+$30.00</li>
														<li class="s-price-list">
															<ul>
																<li>+$20.00 (Base Price)</li>
																<li>+$10.00 (Extras)</li>
															</ul>
														</li>
													</ul>
												</td>
												<td class="s-qty">2</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">
													<ul>
														<li class="s-price-total">+$60.00</li>
														<li class="s-price-list">
															<ul>
																<li>+$40.00 (Base Price)</li>
																<li>+$20.00 (Extras)</li>
															</ul>
														</li>
													</ul>
												</td>
											</tr>
											<tr class="s-product l-3" data-id="B-625TX78">												
												<td class="s-title">Engraving: Front Engraving <a href="#" class="s-edit-link">edit</a></td>
												<td class="s-sku">H-JKHG675D</td>
												<td class="s-details"></td>
												<td class="s-customization">
													<ul>
														<li>Engraving Text: GJM</li>
														<li>Engraving Font: Arial</li>
													</ul>
												</td>
												<td class="s-price">+$5.00</td>
												<td class="s-qty">2</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">+$10.00</td>
											</tr>
											<tr class="s-product l-3" data-id="B-625TX78">
												<td class="s-title">Engraving: Back Engraving <a href="#" class="s-edit-link">edit</a></td>
												<td class="s-sku">T-JKU67GT</td>
												<td class="s-details"></td>
												<td class="s-customization">
													<ul>
														<li>Engraving Text: Yo</li>
														<li>Engraving Font: Arial</li>
													</ul>
												</td>
												<td class="s-price">+$5.00</td>
												<td class="s-qty">2</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">+$10.00</td>
											</tr>
											<tr class="s-product l-2" data-id="B-625TX78">
												<td class="s-title">Chain: Cross-Link Chain <a href="#" class="s-edit-link">edit</a></td>
												<td class="s-sku">D-67JHGT</td>
												<td class="s-details"></td>
												<td class="s-customization"></td>
												<td class="s-price">+$10.00</td>
												<td class="s-qty">2</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">+$20.00</td>
											</tr>
										</tbody>
										<tbody>
											<tr class="s-product l-1" data-id="T-YJH876">
												<td rowspan="1000" class="s-image"><img src="http://placehold.it/90x90"></td>
												<td class="s-title">Gold Necklace <a href="" class="s-toggle-detail-link">hide detail</a></td>
												<td class="s-sku">T-YJH876</td>
												<td class="s-details">
													<ul>
														<li>Color: Gold</li>
													</ul>
												</td>
												<td class="s-customization"></td>
												<td class="s-price">
													<ul>
														<li class="s-price-total">$10.00</li>
													<!-- 	<li class="s-price-list">
														<ul>
															<li>+$10.00 (Base Price)</li>
															<li>+$0.90 (Extras)</li>
														</ul>
													</li> -->
													</ul>
												</td>
												<td class="s-qty">1</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">
													<ul>
														<li class="s-price-total">$10.00</li>
														<!-- <li class="s-price-list">
															<ul>
																<li>+$100.00 (Base Price)</li>
																<li>+$59.00 (Extras)</li>
															</ul>
														</li> -->
													</ul>
												</td>
												<td rowspan="1000" class="s-fullfilment">
													<ul>
														<li class="s-header">Ship To: <a href="#" class="s-edit-link">edit</a></li>
														<li>
															<ul>
																<li>123 West Leucadia Blvd</li>
																<li>Encinitas, CA 92024</li>
															</ul>
														</li>
													</ul>
												</td>
												<td rowspan="1000" class="s-actions">
													<ul>
														<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
														<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
													</ul>
												</td>
											</tr>
											<tr class="s-sku-product l-2" data-id="T-YJH876">
												<td class="s-title">Spring Ring<a href="#" class="s-edit-link">edit</a></td>
												<td class="s-sku">Y-KYU564</td>
												<td class="s-details">
													<ul>
														<li>Color: Gold</li>
													</ul>
												</td>
												<td class="s-customization"></td>
												<td class="s-price">+$0.65</td>
												<td class="s-qty">1</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">+$0.65</td>
											</tr>
											<tr class="s-sku-product l-2" data-id="T-YJH876">
												<td class="s-title">Chain End <a href="#" class="s-edit-link">edit</a></td>
												<td class="s-sku">N-3647HJ</td>
												<td class="s-details">
													<ul>
														<l1>Color: Gold</l1>
													</ul>
												</td>
												<td class="s-customization"></td>
												<td class="s-price">+$0.25</td>
												<td class="s-qty">2</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">+$0.50</td>
											</tr>
										</tbody>
										<tbody>
											<tr class="s-product l-1">
												<td rowspan="1" class="s-image"><img src="http://placehold.it/90x90"></td>
												<td class="s-title">Nike - Air Jordans</td>
												<td class="s-sku">K-5748JH9</td>
												<td class="s-details">
													<ul>
														<li>
															<div class="s-detail-title">Size:</div>
															<div class="s-detail-content">Mens 12</div>
														</li>
														<li>
															<div class="s-detail-title">Color:</div>
															<div class="s-detail-content">Fire Red</div>
														</li>
													</ul>
												</td>
												<td class="s-customization">
													<ul>
														<li>
															<div class="s-detail-title">Embroidery:</div>
															<div class="s-detail-content">Big G</div>
														</li>
													</ul>
												</td>
												<td class="s-price">$89.99</td>
												<td class="s-qty">1</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">$89.99</td>
												<td rowspan="1" class="s-fullfilment">
													<ul>
														<li class="s-header">Shipping <a href="#" class="s-edit-link">edit</a></li>
														<li>
															<ul>
																<li>5748 Pope St.</li>
																<li>San Diego, CA 83746</li>
															</ul>
														</li>
													</ul>
												</td>
												<td rowspan="1" class="s-actions">
													<ul>
														<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
														<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
													</ul>
												</td>
											</tr>
										</tbody>
										<tbody>
											<tr class="s-product l-1">
												<td rowspan="1" class="s-image"><img src="http://placehold.it/90x90"></td>
												<td class="s-title">Nixon Tide Watch</td>
												<td class="s-sku">l-3847HJK</td>
												<td class="s-details">
													<ul>
														<li>
															<div class="s-detail-title">Color:</div>
															<div class="s-detail-content">Green</div>
														</li>
													</ul>
												</td>
												<td class="s-customization"></td>
												<td class="s-price">$129.99</td>
												<td class="s-qty">1</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">$129.99</td>
												<td rowspan="1" class="s-fullfilment">
													<ul>
														<li class="s-header">Shipping <a href="#" class="s-edit-link">edit</a></li>
														<li>
															<ul>
																<li>876 Doomed Folks Dr.</li>
																<li>Treelock, CA 37647</li>
															</ul>
														</li>
													</ul>
												</td>
												<td rowspan="1" class="s-actions">
													<ul>
														<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
														<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
													</ul>
												</td>
											</tr>
										</tbody>
										<tbody>
											<tr class="s-product s-product s-return l-1">
												<td rowspan="1" class="s-image"><img src="http://placehold.it/90x90"></td>
												<td class="s-title">Nixon Tide Watch</td>
												<td class="s-sku">l-3847HJK</td>
												<td class="s-details">
													<ul>
														<li>
															<div class="s-detail-title">Color:</div>
															<div class="s-detail-content">Green</div>
														</li>
													</ul>
												</td>
												<td class="s-customization"></td>
												<td class="s-price">(-$129.99)</td>
												<td class="s-qty">1</td>
												<td class="s-discount">($0.00)</td>
												<td class="s-total">(-$129.99)</td>
												<td rowspan="1" class="s-fullfilment">
													<ul>
														<li class="s-header">Shipping <a href="#" class="s-edit-link">edit</a></li>
														<li>
															<ul>
																<li>876 Doomed Folks Dr.</li>
																<li>Treelock, CA 37647</li>
															</ul>
														</li>
													</ul>
												</td>
												<td rowspan="1" class="s-actions">
													<ul>
														<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
														<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
													</ul>
												</td>
											</tr>
										</tbody>
										<tbody>
											<tr class="s-bundle-product l-1" data-id="S-786JRT">
												<td rowspan="1000" class="s-image"><img src="http://placehold.it/90x90"></td>
												<td class="s-title">Custom Skateboard Bundle <a href="" class="s-toggle-detail-link">hide detail</a></td>
												<td class="s-sku">S-786JRT</td>
												<td class="s-details"></td>
												<td class="s-customization"></td>
												<td class="s-price">
													<ul>
														<li class="s-price-total">$141.00</li>
														<li class="s-price-list">
															<ul>
																<li>+$100.00 (Base Price)</li>
																<li>+$41.00 (Extras)</li>
															</ul>
														</li>
													</ul>
												</td>
												<td class="s-qty">1</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">
													<ul>
														<li class="s-price-total">$159.00</li>
														<li class="s-price-list">
															<ul>
																<li>+$100.00 (Base Price)</li>
																<li>+$59.00 (Extras)</li>
															</ul>
														</li>
													</ul>
												</td>
												<td rowspan="1000" class="s-fullfilment">
													<ul>
														<li class="s-header">Ship To: <a href="#" class="s-edit-link">edit</a></li>
														<li>
															<ul>
																<li>123 West Leucadia Blvd</li>
																<li>Encinitas, CA 92024</li>
															</ul>
														</li>
													</ul>
												</td>
												<td rowspan="1000" class="s-actions">
													<ul>
														<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
														<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
													</ul>
												</td>
											</tr>
											<tr class="s-product l-2" data-id="S-786JRT">
												<td class="s-title">Deck: Tony Hawk <a href="#" class="s-edit-link">edit</a></td>
												<td class="s-sku">Y-THU7867</td>
												<td class="s-details">
													<ul>
														<li>Size: 8.75</li>
														<li>Color: Black/Silver</li>
													</ul>
												</td>
												<td class="s-customization">
													<ul>
														<li>Signature: Tony Hawk</li>
													</ul>
												</td>
												<td class="s-price">+$20.00</td>
												<td class="s-qty">1</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">+$20.00</td>
											</tr>
											<tr class="s-product l-2" data-id="S-786JRT">
												<td class="s-title">Trucks: Independent Super Light <a href="#" class="s-edit-link">edit</a></td>
												<td class="s-sku">N-3647HJ</td>
												<td class="s-details">
													<ul>
														<l1>Color: Black</l1>
													</ul>
												</td>
												<td class="s-customization"></td>
												<td class="s-price">+$10.00</td>
												<td class="s-qty">1</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">+$10.00</td>
											</tr>
											<tr class="s-product l-2" data-id="S-786JRT">												
												<td class="s-title">Wheels: Spitfilre <a href="#" class="s-edit-link">edit</a></td>
												<td class="s-sku">G-HJH678</td>
												<td class="s-details">
													<ul>
														<li>Color: Blue</li>
													</ul>
												</td>
												<td class="s-customization"></td>
												<td class="s-price">+$5.00</td>
												<td class="s-qty">4</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">+$20.00</td>
											</tr>
											<tr class="s-product l-2" data-id="S-786JRT">
												<td class="s-title">Add-Ons: Risers <a href="#" class="s-edit-link">edit</a></td>
												<td class="s-sku">Y-GHGR78</td>
												<td class="s-details"></td>
												<td class="s-customization"></td>
												<td class="s-price">+$1.00</td>
												<td class="s-qty">4</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">+$4.00</td>
											</tr>
											<tr class="s-product l-2" data-id="S-786JRT">
												<td class="s-title">Add-Ons: Black Magic Griptape <a href="#" class="s-edit-link">edit</a></td>
												<td class="s-sku">DE-3746YU</td>
												<td class="s-details"></td>
												<td class="s-customization"></td>
												<td class="s-price">+$5.00</td>
												<td class="s-qty">1</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">+$5.00</td>
											</tr>
										</tbody>
										<tbody>
											<tr class="s-event l-1">
												<td rowspan="1" class="s-image"><img src="http://placehold.it/90x90"></td>
												<td class="s-title">Michael Jackson & Tupac - Resurection Tour</td>
												<td class="s-sku">N-389JDG</td>
												<td class="s-details">
													<ul>
														<li>
															<div class="s-detail-title">Even Date:</div>
															<div class="s-detail-content">3-12-2014 @ 5pm-9pm</div>
														</li>
														<li>
															<div class="s-detail-title">Location:</div>
															<div class="s-detail-content">
																<ul>
																	<li>Coors Amphitheater</li>
																</ul>
															</div>
														</li>
													</ul>
												</td>
												<td class="s-customization"></td>
												<td class="s-price">$89.99</td>
												<td class="s-qty">1</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">$89.99</td>
												<td rowspan="1" class="s-fullfilment">
													<ul>
														<li class="s-header">Pick Up: <a href="#" class="s-edit-link">edit</a></li>
														<li>
															<ul>
																<li>666 Dead Rd.</li>
																<li>Miami, FL 83746</li>
															</ul>
														</li>
													</ul>
												</td>
												<td rowspan="1" class="s-actions">
													<ul>
														<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
														<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
													</ul>
												</td>
											</tr>
										</tbody>
										<tbody>
											<tr class="s-subscription l-1">
												<td rowspan="1" class="s-image"><img src="http://placehold.it/90x90"></td>
												<td class="s-title">Prime Service</td>
												<td class="s-sku">G-HJK876</td>
												<td class="s-details">
													<ul>
														<li>
															<div class="s-detail-title">Subscription Term:</div>
															<div class="s-detail-content">Annual - Auto Renew</div>
														</li>
														<li>
															<div class="s-detail-title">Subscription Benifits:</div>
															<div class="s-detail-content">
																<ul>
																	<li>2 Day Delivery</li>
																	<li>Prime Video</li>
																	<li>Prime Music</li>
																</ul>
															</div>
														</li>
													</ul>
												</td>
												<td class="s-customization"></td>
												<td class="s-price">$99.99</td>
												<td class="s-qty">1</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">$99.99</td>
												<td rowspan="1" class="s-fullfilment">
													<ul>
														<li class="s-header">Shipping <a href="#" class="s-edit-link">edit</a></li>
														<li>
															<ul>
																<li>896 Dear Springs Rd.</li>
																<li>Big Bear, CA 97364</li>
															</ul>
														</li>
													</ul>
												</td>
												<td rowspan="1" class="s-actions">
													<ul>
														<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
														<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
													</ul>
												</td>
											</tr>
										</tbody>
										<tbody>
											<tr class="s-event l-1">
												<td rowspan="1" class="s-image"><img src="http://placehold.it/90x90"></td>
												<td class="s-title">Region 10 - Leadership Development Conference</td>
												<td class="s-sku">C-567YGH</td>
												<td class="s-details">
													<ul>
														<li>
															<div class="s-detail-title">Even Date:</div>
															<div class="s-detail-content">9-12-2015 @ 7am-9pm</div>
														</li>
														<li>
															<div class="s-detail-title">Location:</div>
															<div class="s-detail-content">
																<ul>
																	<li>Region 10 Development Center</li>
																	<li>7874 Mesa Dr.</li>
																	<li>Freemont CA, 98374</li>
																</ul>
															</div>
														</li>
													</ul>
												</td>
												<td class="s-customization"></td>
												<td class="s-price">$1200.00</td>
												<td class="s-qty">1</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">$1200.00</td>
												<td rowspan="1" class="s-fullfilment">
													<ul>
														<li class="s-header">Attend:</li>
														<li>
															<ul>
																<li>7874 Mesa Dr.</li>
																<li>Freemont CA, 98374</li>
															</ul>
														</li>
													</ul>
												</td>
												<td rowspan="1" class="s-actions">
													<ul>
														<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
														<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
													</ul>
												</td>
											</tr>
										</tbody>
										<tbody>
											<tr class="s-content-access l-1">
												<td rowspan="1" class="s-image"><img src="http://placehold.it/90x90"></td>
												<td class="s-title">RainToday - Help Marketer Boost Revenue</td>
												<td class="s-sku">Y-JKF6754</td>
												<td class="s-details"></td>
												<td class="s-customization"></td>
												<td class="s-price">$297.00</td>
												<td class="s-qty">1</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">$297.00</td>
												<td rowspan="1" class="s-fullfilment">
													<ul>
														<li class="s-header">Download</li>
													</ul>
												</td>
												<td rowspan="1" class="s-actions">
													<ul>
														<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
														<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
													</ul>
												</td>
											</tr>
										</tbody>
										<tbody>
											<tr class="s-content-access l-1">
												<td rowspan="1" class="s-image"><img src="http://placehold.it/90x90"></td>
												<td class="s-title">RainToday - Build Your Brand</td>
												<td class="s-sku">Y-647DRT</td>
												<td class="s-details"></td>
												<td class="s-customization"></td>
												<td class="s-price">$87.00</td>
												<td class="s-qty">1</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">$87.00</td>
												<td rowspan="1" class="s-fullfilment">
													<ul>
														<li class="s-header">Email <a href="#" class="s-edit-link">edit</a></li>
														<li>
															<ul>
																<li>timmy@gmail.com</li>
															</ul>
														</li>
													</ul>
												</td>
												<td rowspan="1" class="s-actions">
													<ul>
														<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
														<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
													</ul>
												</td>
											</tr>
										</tbody>
										<tbody>
											<tr class="s-event s-deposit l-1" data-id="G-N86JRT">
												<td rowspan="1000" class="s-image"><img src="http://placehold.it/90x90"></td>
												<td class="s-title">NG-Conf 2016 <a href="" class="s-toggle-detail-link">hide detail</a></td>
												<td class="s-sku">G-N86JRT</td>
												<td class="s-details">
													<ul>
														<li>
															<div class="s-detail-title">Even Date:</div>
															<div class="s-detail-content">9-12-2015 @ 7am-9pm</div>
														</li>
														<li>
															<div class="s-detail-title">Location:</div>
															<div class="s-detail-content">
																<ul>
																	<li>Region 10 Development Center</li>
																	<li>7874 Mesa Dr.</li>
																	<li>Freemont CA, 98374</li>
																</ul>
															</div>
														</li>
													</ul>
												</td>
												<td class="s-customization"></td>
												<td class="s-price">
													<ul>
														<li class="s-price-total">$100.00  (Deposit)</li>
														<li class="s-price-list">
															<ul>
																<li>$299.99 (Event Price)</li>
															</ul>
														</li>
													</ul>
												</td>
												<td class="s-qty">2</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">$200.00</td>
												<td rowspan="1000" class="s-fullfilment">
													<ul>
														<li class="s-header">Attend:</li>
														<li>
															<ul>
																<li>123 West Leucadia Blvd</li>
																<li>Encinitas, CA 92024</li>
															</ul>
														</li>
													</ul>
												</td>
												<td rowspan="1000" class="s-actions">
													<ul>
														<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
														<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
													</ul>
												</td>
											</tr>
											<tr class="s-event s-deposit l-2" data-id="G-N86JRT">
												<td class="s-title">
													Ryan Marchand
													<ul class="list-unstyled s-status">
														<li>
															<div class="s-detail-title">Position:</div>
															<div class="s-detail-content">2 customers ahead</div> 
														</li>
													</ul>
													<div class="s-button-group">
														<button type="button" class="btn btn-xs s-btn-dgrey s-remove">Cancel Deposit</button>
													</div>
												</td>
												<td class="s-sku"></td>
												<td class="s-details"></td>
												<td class="s-customization"></td>
												<td class="s-price"></td>
												<td class="s-qty"></td>
												<td class="s-discount"></td>
												<td class="s-total"></td>
											</tr>
											<tr class="s-event s-deposit l-2" data-id="G-N86JRT">
												<td class="s-title">
													Chris Kundrat
													<ul class="list-unstyled s-status">
														<li>
															<div class="s-detail-title">Position:</div>
															<div class="s-detail-content">3 customers ahead</div> 
														</li>
													</ul>
													<div class="s-button-group">
														<button type="button" class="btn btn-xs s-btn-dgrey s-remove">Cancel Deposit</button>
													</div>
												</td>
												<td class="s-sku"></td>
												<td class="s-details"></td>
												<td class="s-customization"></td>
												<td class="s-price"></td>
												<td class="s-qty"></td>
												<td class="s-discount"></td>
												<td class="s-total"></td>
											</tr>
										</tbody>
										<tbody>
											<tr class="s-event s-pending-payment l-1" data-id="G-N86JRT">
												<td rowspan="1000" class="s-image"><img src="http://placehold.it/90x90"></td>
												<td class="s-title">NG-Conf 2016 <a href="" class="s-toggle-detail-link">hide detail</a></td>
												<td class="s-sku">G-N86JRT</td>
												<td class="s-details">
													<ul>
														<li>
															<div class="s-detail-title">Even Date:</div>
															<div class="s-detail-content">9-12-2015 @ 7am-9pm</div>
														</li>
														<li>
															<div class="s-detail-title">Location:</div>
															<div class="s-detail-content">
																<ul>
																	<li>Region 10 Development Center</li>
																	<li>7874 Mesa Dr.</li>
																	<li>Freemont CA, 98374</li>
																</ul>
															</div>
														</li>
													</ul>
												</td>
												<td class="s-customization"></td>
												<td class="s-price">
													<ul>
														<li class="s-price-total">$100.00  (Deposit)</li>
														<li class="s-price-list">
															<ul>
																<li>$299.99 (Event Price)</li>
															</ul>
														</li>
													</ul>
												</td>
												<td class="s-qty">2</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">$200.00</td>
												<td rowspan="1000" class="s-fullfilment">
													<ul>
														<li class="s-header">Attend:</li>
														<li>
															<ul>
																<li>123 West Leucadia Blvd</li>
																<li>Encinitas, CA 92024</li>
															</ul>
														</li>
													</ul>
												</td>
												<td rowspan="1000" class="s-actions">
													<ul>
														<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
														<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
													</ul>
												</td>
											</tr>
											<tr class="s-event s-pending-payment l-2" data-id="G-N86JRT">
												<td class="s-title"> 
													Ryan Marchand
													<ul class="list-unstyled s-status">
														<li>
															<div class="s-detail-title">Space reserve until:</div>
															<div class="s-detail-content">July 2nd, 2015</div> 
														</li>
													</ul>
													<div class="s-button-group">
														<button type="button" class="btn btn-xs btn-success">Claim Spot</button>
														<button type="button" class="btn btn-xs s-btn-dgrey s-remove">Cancel Deposit</button>
													</div>
												</td>
												<td class="s-sku"></td>
												<td class="s-details"></td>
												<td class="s-customization"></td>
												<td class="s-price"></td>
												<td class="s-qty"></td>
												<td class="s-discount"></td>
												<td class="s-total"></td>
											</tr>
											<tr class="s-event s-deposit l-2" data-id="G-N86JRT">
												<td class="s-title">
													Chris Kundrat
													<ul class="list-unstyled s-status">
														<li>
															<div class="s-detail-title">Position:</div>
															<div class="s-detail-content">1 customer ahead</div> 
														</li>
													</ul>
													<div class="s-button-group">
														<button type="button" class="btn btn-xs s-btn-dgrey s-remove">Cancel Deposit</button>
													</div>
												</td>
												<td class="s-sku"></td>
												<td class="s-details"></td>
												<td class="s-customization"></td>
												<td class="s-price"></td>
												<td class="s-qty"></td>
												<td class="s-discount"></td>
												<td class="s-total"></td>
											</tr>
										</tbody>
										</tbody>
										<tbody>
											<tr class="s-event s-deposit l-1">
												<td rowspan="1" class="s-image"><img src="http://placehold.it/90x90"></td>
												<td class="s-title">
													Britney Spears & Kevin Federline Reunion Tour
													<ul class="list-unstyled s-status">
														<li>
															<div class="s-detail-title">Position:</div>
															<div class="s-detail-content">3 customers ahead</div> 
														</li>
													</ul>
													<div class="s-button-group">
														<button type="button" class="btn btn-xs s-btn-dgrey s-remove">Cancel Deposit</button>
													</div>
												</td>
												<td class="s-sku">N-748JHG</td>
												<td class="s-details">
													<ul>
														<li>
															<div class="s-detail-title">Even Date:</div>
															<div class="s-detail-content">9-12-2015 @ 7am-9pm</div>
														</li>
														<li>
															<div class="s-detail-title">Location:</div>
															<div class="s-detail-content">
																<ul>
																	<li>Region 10 Development Center</li>
																	<li>7874 Mesa Dr.</li>
																	<li>Freemont CA, 98374</li>
																</ul>
															</div>
														</li>
													</ul>
												</td>
												<td class="s-customization"></td>
												<td class="s-price">
													<ul>
														<li class="s-price-total">$100.00  (Deposit)</li>
														<li class="s-price-list">
															<ul>
																<li>$299.99 (Event Price)</li>
															</ul>
														</li>
													</ul>
												</td>
												<td class="s-qty">1</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">$100.00</td>
												<td rowspan="1" class="s-fullfilment">
													<ul>
														<li class="s-header">Attend:</li>
														<li>
															<ul>
																<li>348 Moon Skip Ave.</li>
																<li>San Diego, CA 93847</li>
															</ul>
														</li>
													</ul>
												</td>
												<td rowspan="1" class="s-actions">
													<ul>
														<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
														<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
													</ul>
												</td>
											</tr>
										</tbody>
										<tbody>
											<tr class="s-event s-pending-payment l-1">
												<td rowspan="1" class="s-image"><img src="http://placehold.it/90x90"></td>
												<td class="s-title"> 
													Britney Spears & Kevin Federline Reunion Tour
													<ul class="list-unstyled s-status">
														<li>
															<div class="s-detail-title">Space reserve until:</div>
															<div class="s-detail-content">July 2nd, 2015</div> 
														</li>
													</ul>
													<div class="s-button-group">
														<button type="button" class="btn btn-xs btn-success">Claim Spot</button>
														<button type="button" class="btn btn-xs s-btn-dgrey s-remove">Cancel Deposit</button>
													</div>
												</td>
												<td class="s-sku">N-748JHG</td>
												<td class="s-details">
													<ul>
														<li>
															<div class="s-detail-title">Even Date:</div>
															<div class="s-detail-content">9-12-2015 @ 7am-9pm</div>
														</li>
														<li>
															<div class="s-detail-title">Location:</div>
															<div class="s-detail-content">
																<ul>
																	<li>Region 10 Development Center</li>
																	<li>7874 Mesa Dr.</li>
																	<li>Freemont CA, 98374</li>
																</ul>
															</div>
														</li>
													</ul>
												</td>
												<td class="s-customization"></td>
												<td class="s-price">
													<ul>
														<li class="s-price-total">$100.00 (Deposit)</li>
														<li class="s-price-list">
															<ul>
																<li>$299.99 (Event Price)</li>
															</ul>
														</li>
													</ul>
												</td>
												<td class="s-qty">1</td>
												<td class="s-discount">-$0.00</td>
												<td class="s-total">$100.00</td>
												<td rowspan="1" class="s-fullfilment">
													<ul>
														<li class="s-header">Attend:</li>
														<li>
															<ul>
																<li>348 Moon Skip Ave.</li>
																<li>San Diego, CA 93847</li>
															</ul>
														</li>
													</ul>
												</td>
												<td rowspan="1" class="s-actions">
													<ul>
														<li class="s-edit-btn"><button><i class="fa fa-eye"></i></button></li>
														<li class="s-remove-btn"><button><i class="fa fa-trash"></i></button></li>
													</ul>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								
								<div class="j-pagination" data-tableid="LD5B71785EEE16BC1BCF6F7E2063C5AE03">
									<ul class="pagination">
										<li><a href="#" class="paging-show-toggle">Show <span class="details">(1 - 10 of 11)</span></a></li>
										<li><a href="#" class="show-option" data-show="10" style="display: none;">10</a></li>
										<li><a href="#" class="show-option" data-show="25" style="display: none;">25</a></li>
										<li><a href="#" class="show-option" data-show="50" style="display: none;">50</a></li>
										<li><a href="#" class="show-option" data-show="100" style="display: none;">100</a></li>
										<li><a href="#" class="show-option" data-show="500" style="display: none;">500</a></li>
										<li><a href="#" class="show-option" data-show="ALL" style="display: none;">ALL</a></li>
										<li class="disabled"><a href="#" class="page-option prev">«</a></li>
										<li class="active"><a href="#" class="listing-pager page-option" data-page="1">1</a></li>
										<li><a href="#" class="listing-pager page-option" data-page="2">2</a></li>
										<li><a href="#" class="listing-pager page-option next" data-page="2">»</a></li>
									</ul>
								</div>
								
								<div class="row s-bundle-group-items">
									<div class="col-xs-12 s-search-bar">

										<ul class="list-unstyled s-search-bar-box">
											<li>
												<div class="dropdown input-group-btn search-panel">
													<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
														<span id="j-search-concept">Any</span>
														<span class="caret"></span>
													</button>
													<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
														<li><a href="#all">Any</a></li>
														<li><a href="#less_than">Product</a></li>
														<li><a href="#all">Skus</a></li>
													</ul>
												</div>
											</li>
											<li>
												<input id="j-temp-class-search" type="text" class="form-control s-search-input" name="x" placeholder="Search product or sku">
												<i class="fa fa-refresh fa-spin"></i>
											</li>
											<li>
												<ul class="list-unstyled">
													<li>
														<div class="s-checkbox"><input type="checkbox" id="j-checkbox25" checked="checked"><label for="j-checkbox25"> In stock</label></div>
													</li>
													<li>
														<div class="dropdown input-group-btn search-panel">
															<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
																<span id="j-search-concept">All Locations</span>
																<span class="caret"></span>
															</button>
															<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
																<li><input type="text" class="form-control" name="x" placeholder="Search"></li>
																<li><a href="#all">All Locations</a></li>
																<li><a href="#less_than">San Diego</a></li>
																<li><a href="#all">New York</a></li>
																<li><a href="#all">France</a></li>
															</ul>
														</div>
													</li>
												</ul>
											</li>
										</ul>

									</div>

									<div class="col-xs-12 s-bundle-add-items">
										<div class="col-xs-12 s-bundle-add-items-inner">

											<ul class="list-unstyled s-order-item-options">

												<li class="s-bundle-add-obj">
													<ul class="list-unstyled list-inline s-middle">
														<li class="j-tool-tip-item s-bundle-details">Subscription</li>
														<li class="j-tool-tip-item s-bundle-details">Skateboard Magazine 1 Year <span>K-3847UGH</span></li>
														<li class="j-tool-tip-item s-bundle-details">Qty: <span>1</span></li>
														<li class="j-tool-tip-item s-bundle-details">Location: <span>San Diego</span></li>
													</ul>
													<ul class="s-last">
														<li class="s-bundle-details-add">
															<a class="btn btn-default"><i class="fa fa-minus-square-o"></i> <span class="s-action-text">Return Item</span></a>
														</li>
														<li class="s-bundle-details-add">
															<a class="btn btn-primary"><i class="fa fa-plus-square-o"></i> <span class="s-action-text">Add Item</span></a>
														</li>
													</ul>
													<div class="clearfix"></div>
												</li>
												
												<li class="s-bundle-add-obj">
													<ul class="list-unstyled list-inline s-middle">
														<li class="j-tool-tip-item s-bundle-details">Product</li>
														<li class="j-tool-tip-item s-bundle-details">Skull Key Chain <span>K-3847UGH</span></li>
														<li class="j-tool-tip-item s-bundle-details">Qty: <span>1</span></li>
														<li class="j-tool-tip-item s-bundle-details">Location: <span>San Diego</span></li>
													</ul>
													<ul class="s-last">
														<li class="s-bundle-details-add">
															<a class="btn btn-default"><i class="fa fa-minus-square-o"></i> <span class="s-action-text">Return Item</span></a>
														</li>
														<li class="s-bundle-details-add">
															<a class="btn btn-primary"><i class="fa fa-plus-square-o"></i> <span class="s-action-text">Add Item</span></a>
														</li>
													</ul>
													<div class="clearfix"></div>
												</li>

											</ul>
										</div>
									</div>
								</div>
									
							</content>					
						</div>
					</div>
					
					
					
<!--/////////////////// END BUNDLE LISTING EXAMPLE///////////////////-->
					
				
					<div class="j-panel panel panel-default">
						<a data-toggle="collapse"  href="#collapse3">
							<div class="panel-heading">
								<h4 class="panel-title">
									<span>Deposit Order Items</span>
									<i class="fa fa-caret-left s-accordion-toggle-icon"></i>
								</h4>
							</div>
						</a>
						<div id="collapse3" class="panel-collapse collapse">
							<content class="s-body-box">
								
									<div class="tab-pane" id="tabdepositorderitems">
										

		<div class="s-table-header-nav s-listing-head-margin">
			<div class="col-xs-6 s-no-padding-left">
				<ul class="list-inline list-unstyled">
					<li>
						<h4>
							
						</h4>
					</li>
				</ul>
			</div>

			<div class="col-xs-6 s-table-view-options s-no-padding-right">
				<ul class="list-inline list-unstyled">
					<li>
						<form class="s-table-header-search">
							
								<input type="text" name="search" class="form-control input-sm general-listing-search" placeholder="Search" value="" tableid="LD2302740802646259A46FF60F6266EBB3" >
							
						</form>
					</li>
					<li>
						<div class="btn-group navbar-left dropdown">

							<button type="button" class="btn btn-sm s-btn-dgrey dropdown-toggle"><i class="fa fa-cog"></i></button>

								<ul class="dropdown-menu pull-right" role="menu">
									<li><a title="Export List" class="adminentityexportSlatwallOrderItem " target="_self" href="/?slatAction=entity.exportSlatwallOrderItem">Export List</a></li> 
								</ul>
								
								

						</div>
					</li>
				</ul>

			</div>
		</div>

		<div class="table-responsive">
			<table id="LD2302740802646259A46FF60F6266EBB3" class="table table-bordered table-hover" data-norecordstext="There aren't any Order Items." data-savedstateid="23027408-0264-6259-A46FF60F6266EBB3" data-entityname="SlatwallOrderItem" data-idproperty="orderItemID" data-processobjectproperties="" data-propertyidentifiers="orderItemID,sku.skuCode,sku.product.calculatedTitle,sku.skuDefinition,orderItemStatusType.typeName,quantity,price,discountAmount,extendedPriceAfterDiscount,quantityDelivered" >
				<thead>

					<tr>
						
						
							<th class="data " data-propertyIdentifier="sku.skuCode">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">SKU Code <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:sku.skuCode" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="sku.product.calculatedTitle">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Title <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:sku.product.calculatedTitle" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="sku.skuDefinition">
								Sku Definition 
							</th>
						
							<th class="data " data-propertyIdentifier="orderItemStatusType.typeName">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Name <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:orderItemStatusType.typeName" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="quantity">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Qty. <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Range</li>
													<li class="range-filter"><label for="">From</label><input type="text" class="text form-control range-filter-lower" name="R:quantity" value="" /></li>
													<li class="range-filter"><label for="">To</label><input type="text" class="text form-control range-filter-upper" name="R:quantity" value="" /></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="price">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Price <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Range</li>
													<li class="range-filter"><label for="">From</label><input type="text" class="text form-control range-filter-lower" name="R:price" value="" /></li>
													<li class="range-filter"><label for="">To</label><input type="text" class="text form-control range-filter-upper" name="R:price" value="" /></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="discountAmount">
								Discounts 
							</th>
						
							<th class="data " data-propertyIdentifier="extendedPriceAfterDiscount">
								Total 
							</th>
						
							<th class="data " data-propertyIdentifier="quantityDelivered">
								Qty. Delivered 
							</th>
						
							<th class="admin admin2" data-detailaction="admin:entity.detailorderitem" data-detailquerystring="" data-detailmodal="false" data-editaction="admin:entity.editorderitem" data-editquerystring="" data-editmodal="false">&nbsp;</th>
						
					</tr>
				</thead>
				<tbody >
					
						<tr><td colspan="10" style="text-align:center;"><em>There aren't any Order Items.</em></td></tr>
					
				</tbody>
			</table>

			</div>


		
		
									</div>
								
							</content>
						</div>
					</div>
				
					<div class="j-panel panel panel-default">
						<a data-toggle="collapse"  href="#collapse4">
							<div class="panel-heading">
								<h4 class="panel-title">
									<span>Order Payments</span>
									<i class="fa fa-caret-left s-accordion-toggle-icon"></i>
								</h4>
							</div>
						</a>
						<div id="collapse4" class="panel-collapse collapse">
							<content class="s-body-box">
								
									<div class="tab-pane" id="taborderpayments">
										

		<div class="s-table-header-nav s-listing-head-margin">
			<div class="col-xs-6 s-no-padding-left">
				<ul class="list-inline list-unstyled">
					<li>
						<h4>
							
								<span style="font-size:14px;color:#666666;">Charges</span>
							
						</h4>
					</li>
				</ul>
			</div>

			<div class="col-xs-6 s-table-view-options s-no-padding-right">
				<ul class="list-inline list-unstyled">
					<li>
						<form class="s-table-header-search">
							
								<input type="text" name="search" class="form-control input-sm general-listing-search" placeholder="Search" value="" tableid="LD2302760FC7A0836064F0A9C1097CB080" >
							
						</form>
					</li>
					<li>
						<div class="btn-group navbar-left dropdown">

							<button type="button" class="btn btn-sm s-btn-dgrey dropdown-toggle"><i class="fa fa-cog"></i></button>

								<ul class="dropdown-menu pull-right" role="menu">
									<li><a title="Export List" class="adminentityexportSlatwallOrderPayment " target="_self" href="/?slatAction=entity.exportSlatwallOrderPayment">Export List</a></li> 
								</ul>
								
								

						</div>
					</li>
				</ul>

			</div>
		</div>

		<div class="table-responsive">
			<table id="LD2302760FC7A0836064F0A9C1097CB080" class="table table-bordered table-hover" data-norecordstext="There aren't any Order Payments." data-savedstateid="2302760F-C7A0-8360-64F0A9C1097CB080" data-entityname="SlatwallOrderPayment" data-idproperty="orderPaymentID" data-processobjectproperties="" data-propertyidentifiers="orderPaymentID,paymentMethod.paymentMethodName,orderPaymentType.typeName,dynamicAmountFlag,amount,amountReceived,amountCredited" >
				<thead>

					<tr>
						
						
							<th class="data " data-propertyIdentifier="paymentMethod.paymentMethodName">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Payment Method Name <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:paymentMethod.paymentMethodName" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="orderPaymentType.typeName">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Name <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:orderPaymentType.typeName" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="dynamicAmountFlag">
								Dynamic Amount 
							</th>
						
							<th class="data " data-propertyIdentifier="amount">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Amount <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Range</li>
													<li class="range-filter"><label for="">From</label><input type="text" class="text form-control range-filter-lower" name="R:amount" value="" /></li>
													<li class="range-filter"><label for="">To</label><input type="text" class="text form-control range-filter-upper" name="R:amount" value="" /></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="amountReceived">
								Amount Received 
							</th>
						
							<th class="data " data-propertyIdentifier="amountCredited">
								Amount Credited 
							</th>
						
							<th class="admin admin2" data-detailaction="admin:entity.detailorderpayment" data-detailquerystring="" data-detailmodal="false" data-editaction="admin:entity.editorderpayment" data-editquerystring="" data-editmodal="false">&nbsp;</th>
						
					</tr>
				</thead>
				<tbody >
					
						<tr><td colspan="7" style="text-align:center;"><em>There aren't any Order Payments.</em></td></tr>
					
				</tbody>
			</table>

			</div>


		
		

		<div class="s-table-header-nav s-listing-head-margin">
			<div class="col-xs-6 s-no-padding-left">
				<ul class="list-inline list-unstyled">
					<li>
						<h4>
							
								<span style="font-size:14px;color:#666666;">Credits</span>
							
						</h4>
					</li>
				</ul>
			</div>

			<div class="col-xs-6 s-table-view-options s-no-padding-right">
				<ul class="list-inline list-unstyled">
					<li>
						<form class="s-table-header-search">
							
								<input type="text" name="search" class="form-control input-sm general-listing-search" placeholder="Search" value="" tableid="LD230276E0EEF2F568E2CA40DFDA31591B" >
							
						</form>
					</li>
					<li>
						<div class="btn-group navbar-left dropdown">

							<button type="button" class="btn btn-sm s-btn-dgrey dropdown-toggle"><i class="fa fa-cog"></i></button>

								<ul class="dropdown-menu pull-right" role="menu">
									<li><a title="Export List" class="adminentityexportSlatwallOrderPayment " target="_self" href="/?slatAction=entity.exportSlatwallOrderPayment">Export List</a></li> 
								</ul>
								
								

						</div>
					</li>
				</ul>

			</div>
		</div>

		<div class="table-responsive">
			<table id="LD230276E0EEF2F568E2CA40DFDA31591B" class="table table-bordered table-hover" data-norecordstext="There aren't any Order Payments." data-savedstateid="230276E0-EEF2-F568-E2CA40DFDA31591B" data-entityname="SlatwallOrderPayment" data-idproperty="orderPaymentID" data-processobjectproperties="" data-propertyidentifiers="orderPaymentID,paymentMethod.paymentMethodName,orderPaymentType.typeName,dynamicAmountFlag,amount,amountReceived,amountCredited" >
				<thead>

					<tr>
						
						
							<th class="data " data-propertyIdentifier="paymentMethod.paymentMethodName">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Payment Method Name <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:paymentMethod.paymentMethodName" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="orderPaymentType.typeName">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Name <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:orderPaymentType.typeName" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="dynamicAmountFlag">
								Dynamic Amount 
							</th>
						
							<th class="data " data-propertyIdentifier="amount">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Amount <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Range</li>
													<li class="range-filter"><label for="">From</label><input type="text" class="text form-control range-filter-lower" name="R:amount" value="" /></li>
													<li class="range-filter"><label for="">To</label><input type="text" class="text form-control range-filter-upper" name="R:amount" value="" /></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="amountReceived">
								Amount Received 
							</th>
						
							<th class="data " data-propertyIdentifier="amountCredited">
								Amount Credited 
							</th>
						
							<th class="admin admin2" data-detailaction="admin:entity.detailorderpayment" data-detailquerystring="" data-detailmodal="false" data-editaction="admin:entity.editorderpayment" data-editquerystring="" data-editmodal="false">&nbsp;</th>
						
					</tr>
				</thead>
				<tbody >
					
						<tr><td colspan="7" style="text-align:center;"><em>There aren't any Order Payments.</em></td></tr>
					
				</tbody>
			</table>

			</div>


		
		

		<div class="s-table-header-nav s-listing-head-margin">
			<div class="col-xs-6 s-no-padding-left">
				<ul class="list-inline list-unstyled">
					<li>
						<h4>
							
								<span style="font-size:14px;color:#666666;">Invalid & Removed</span>
							
						</h4>
					</li>
				</ul>
			</div>

			<div class="col-xs-6 s-table-view-options s-no-padding-right">
				<ul class="list-inline list-unstyled">
					<li>
						<form class="s-table-header-search">
							
								<input type="text" name="search" class="form-control input-sm general-listing-search" placeholder="Search" value="" tableid="LD230277ACBE12148E36674817F19EC902" >
							
						</form>
					</li>
					<li>
						<div class="btn-group navbar-left dropdown">

							<button type="button" class="btn btn-sm s-btn-dgrey dropdown-toggle"><i class="fa fa-cog"></i></button>

								<ul class="dropdown-menu pull-right" role="menu">
									<li><a title="Export List" class="adminentityexportSlatwallOrderPayment " target="_self" href="/?slatAction=entity.exportSlatwallOrderPayment">Export List</a></li> 
								</ul>
								
								

						</div>
					</li>
				</ul>

			</div>
		</div>

		<div class="table-responsive">
			<table id="LD230277ACBE12148E36674817F19EC902" class="table table-bordered table-hover" data-norecordstext="There aren't any Order Payments." data-savedstateid="230277AC-BE12-148E-36674817F19EC902" data-entityname="SlatwallOrderPayment" data-idproperty="orderPaymentID" data-processobjectproperties="" data-propertyidentifiers="orderPaymentID,orderPaymentStatusType.typeName,paymentMethod.paymentMethodName,orderPaymentType.typeName,dynamicAmountFlag,amount,amountReceived,amountCredited" >
				<thead>

					<tr>
						
						
							<th class="data " data-propertyIdentifier="orderPaymentStatusType.typeName">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Name <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:orderPaymentStatusType.typeName" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="paymentMethod.paymentMethodName">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Payment Method Name <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:paymentMethod.paymentMethodName" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="orderPaymentType.typeName">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Name <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:orderPaymentType.typeName" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="dynamicAmountFlag">
								Dynamic Amount 
							</th>
						
							<th class="data " data-propertyIdentifier="amount">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Amount <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Range</li>
													<li class="range-filter"><label for="">From</label><input type="text" class="text form-control range-filter-lower" name="R:amount" value="" /></li>
													<li class="range-filter"><label for="">To</label><input type="text" class="text form-control range-filter-upper" name="R:amount" value="" /></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="amountReceived">
								Amount Received 
							</th>
						
							<th class="data " data-propertyIdentifier="amountCredited">
								Amount Credited 
							</th>
						
							<th class="admin admin2" data-detailaction="admin:entity.detailorderpayment" data-detailquerystring="" data-detailmodal="false" data-editaction="admin:entity.editorderpayment" data-editquerystring="" data-editmodal="false">&nbsp;</th>
						
					</tr>
				</thead>
				<tbody >
					
						<tr><td colspan="8" style="text-align:center;"><em>There aren't any Order Payments.</em></td></tr>
					
				</tbody>
			</table>

			</div>


		
		<a title="Add Order Payment" class="adminentitypreprocessorder btn btn-default modalload" target="_self" href="/?slatAction=entity.preprocessorder&processContext=addOrderPayment&orderID=8a8080874a3b3ecb014a549547fb0050" data-toggle="modal" data-target="#adminModal"><i class="glyphicon glyphicon-plus"></i> Add Order Payment</a> 
									</div>
								
							</content>
						</div>
					</div>
				
					<div class="j-panel panel panel-default">
						<a data-toggle="collapse"  href="#collapse5">
							<div class="panel-heading">
								<h4 class="panel-title">
									<span>Order Fulfillments</span> <span class="badge">1</span>
									<i class="fa fa-caret-left s-accordion-toggle-icon"></i>
								</h4>
							</div>
						</a>
						<div id="collapse5" class="panel-collapse collapse">
							<content class="s-body-box">
								
									<div class="tab-pane" id="taborderfulfillments">
										

		<div class="s-table-header-nav s-listing-head-margin">
			<div class="col-xs-6 s-no-padding-left">
				<ul class="list-inline list-unstyled">
					<li>
						<h4>
							
						</h4>
					</li>
				</ul>
			</div>

			<div class="col-xs-6 s-table-view-options s-no-padding-right">
				<ul class="list-inline list-unstyled">
					<li>
						<form class="s-table-header-search">
							
								<input type="text" name="search" class="form-control input-sm general-listing-search" placeholder="Search" value="" tableid="LD230279F0B4E6790284637062909723F5" >
							
						</form>
					</li>
					<li>
						<div class="btn-group navbar-left dropdown">

							<button type="button" class="btn btn-sm s-btn-dgrey dropdown-toggle"><i class="fa fa-cog"></i></button>

								<ul class="dropdown-menu pull-right" role="menu">
									<li><a title="Export List" class="adminentityexportSlatwallOrderFulfillment " target="_self" href="/?slatAction=entity.exportSlatwallOrderFulfillment">Export List</a></li> 
								</ul>
								
								

						</div>
					</li>
				</ul>

			</div>
		</div>

		<div class="table-responsive">
			<table id="LD230279F0B4E6790284637062909723F5" class="table table-bordered table-hover" data-norecordstext="There aren't any Order Fulfillments." data-savedstateid="230279F0-B4E6-7902-84637062909723F5" data-entityname="SlatwallOrderFulfillment" data-idproperty="orderFulfillmentID" data-processobjectproperties="" data-propertyidentifiers="orderFulfillmentID,fulfillmentMethod.fulfillmentMethodName,fulfillmentCharge,discountAmount,chargeAfterDiscount,quantityDelivered,quantityUndelivered" >
				<thead>

					<tr>
						
						
							<th class="data primary" data-propertyIdentifier="fulfillmentMethod.fulfillmentMethodName">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Fulfillment Method Name <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:fulfillmentMethod.fulfillmentMethodName" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="fulfillmentCharge">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Fulfillment Charge <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Range</li>
													<li class="range-filter"><label for="">From</label><input type="text" class="text form-control range-filter-lower" name="R:fulfillmentCharge" value="" /></li>
													<li class="range-filter"><label for="">To</label><input type="text" class="text form-control range-filter-upper" name="R:fulfillmentCharge" value="" /></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="discountAmount">
								Discounts 
							</th>
						
							<th class="data " data-propertyIdentifier="chargeAfterDiscount">
								Total Fulfillment Charge 
							</th>
						
							<th class="data " data-propertyIdentifier="quantityDelivered">
								Quantity Delivered 
							</th>
						
							<th class="data " data-propertyIdentifier="quantityUndelivered">
								Quantity Undelivered 
							</th>
						
							<th class="admin admin2" data-detailaction="admin:entity.detailorderfulfillment" data-detailquerystring="" data-detailmodal="false" data-editaction="admin:entity.editorderfulfillment" data-editquerystring="" data-editmodal="false">&nbsp;</th>
						
					</tr>
				</thead>
				<tbody >
					
						<tr id="8a8080874a3b3ecb014a5495a12a0056" >
							
							
									<td class="primary">
										Shipping 
									</td>
								
									<td class="">
										$0.00 
									</td>
								
									<td class="">
										$0.00 
									</td>
								
									<td class="">
										$0.00 
									</td>
								
									<td class="">
										0 
									</td>
								
									<td class="">
										1 
									</td>
								
								<td class="admin admin2">
									
									<a title="" class="adminentitydetailorderfulfillment btn btn-default btn-xs" target="_self" href="/?slatAction=entity.detailorderfulfillment&orderFulfillmentID=8a8080874a3b3ecb014a5495a12a0056"id="adminentitydetailorderfulfillment_8a8080874a3b3ecb014a5495a12a0056"><i class="glyphicon glyphicon-eye-open"></i> </a> <a title="" class="adminentityeditorderfulfillment btn btn-default btn-xs" target="_self" href="/?slatAction=entity.editorderfulfillment&orderFulfillmentID=8a8080874a3b3ecb014a5495a12a0056"id="adminentityeditorderfulfillment_8a8080874a3b3ecb014a5495a12a0056"><i class="glyphicon glyphicon-pencil"></i> </a> 
								</td>
							
						</tr>
					
				</tbody>
			</table>

			</div>


		
		
									</div>
								
							</content>
						</div>
					</div>
				
					<div class="j-panel panel panel-default">
						<a data-toggle="collapse"  href="#collapse6">
							<div class="panel-heading">
								<h4 class="panel-title">
									<span>Order Deliveries</span>
									<i class="fa fa-caret-left s-accordion-toggle-icon"></i>
								</h4>
							</div>
						</a>
						<div id="collapse6" class="panel-collapse collapse">
							<content class="s-body-box">
								
									<div class="tab-pane" id="taborderdeliveries">
										

		<div class="s-table-header-nav s-listing-head-margin">
			<div class="col-xs-6 s-no-padding-left">
				<ul class="list-inline list-unstyled">
					<li>
						<h4>
							
						</h4>
					</li>
				</ul>
			</div>

			<div class="col-xs-6 s-table-view-options s-no-padding-right">
				<ul class="list-inline list-unstyled">
					<li>
						<form class="s-table-header-search">
							
								<input type="text" name="search" class="form-control input-sm general-listing-search" placeholder="Search" value="" tableid="LD23027B6B9CE83491BCC41B61A60E38FC" >
							
						</form>
					</li>
					<li>
						<div class="btn-group navbar-left dropdown">

							<button type="button" class="btn btn-sm s-btn-dgrey dropdown-toggle"><i class="fa fa-cog"></i></button>

								<ul class="dropdown-menu pull-right" role="menu">
									<li><a title="Export List" class="adminentityexportSlatwallOrderDelivery " target="_self" href="/?slatAction=entity.exportSlatwallOrderDelivery">Export List</a></li> 
								</ul>
								
								

						</div>
					</li>
				</ul>

			</div>
		</div>

		<div class="table-responsive">
			<table id="LD23027B6B9CE83491BCC41B61A60E38FC" class="table table-bordered table-hover" data-norecordstext="There aren't any Order Deliveries." data-savedstateid="23027B6B-9CE8-3491-BCC41B61A60E38FC" data-entityname="SlatwallOrderDelivery" data-idproperty="orderDeliveryID" data-processobjectproperties="" data-propertyidentifiers="orderDeliveryID,fulfillmentMethod.fulfillmentMethodName,createdDateTime,totalQuantityDelivered" >
				<thead>

					<tr>
						
						
							<th class="data primary" data-propertyIdentifier="fulfillmentMethod.fulfillmentMethodName">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Fulfillment Method Name <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:fulfillmentMethod.fulfillmentMethodName" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="createdDateTime">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Delivered On <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Range</li>
													<li class="range-filter"><label for="">From</label><input type="text" class="datetimepicker form-control range-filter-lower" name="R:createdDateTime" value="" /></li>
													<li class="range-filter"><label for="">To</label><input type="text" class="datetimepicker form-control range-filter-upper" name="R:createdDateTime" value="" /></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="totalQuantityDelivered">
								Total Qty. Delivered 
							</th>
						
							<th class="admin admin1" data-detailaction="admin:entity.detailorderdelivery" data-detailquerystring="" data-detailmodal="false">&nbsp;</th>
						
					</tr>
				</thead>
				<tbody >
					
						<tr><td colspan="4" style="text-align:center;"><em>There aren't any Order Deliveries.</em></td></tr>
					
				</tbody>
			</table>

			</div>


		
		
									</div>
								
							</content>
						</div>
					</div>
				
					<div class="j-panel panel panel-default">
						<a data-toggle="collapse"  href="#collapse7">
							<div class="panel-heading">
								<h4 class="panel-title">
									<span>Promotions</span>
									<i class="fa fa-caret-left s-accordion-toggle-icon"></i>
								</h4>
							</div>
						</a>
						<div id="collapse7" class="panel-collapse collapse">
							<content class="s-body-box">
								
									<div class="tab-pane" id="tabpromotions">
										<a title="Add Promotion Code" class="adminentitypreProcessOrder btn btn-default modalload" target="_self" href="/?slatAction=entity.preProcessOrder&processContext=addPromotionCode&orderID=8a8080874a3b3ecb014a549547fb0050" data-toggle="modal" data-target="#adminModal"><i class="glyphicon glyphicon-plus"></i> Add Promotion Code</a> 
									</div>
								
							</content>
						</div>
					</div>
				
					<div class="j-panel panel panel-default">
						<a data-toggle="collapse"  href="#collapse8">
							<div class="panel-heading">
								<h4 class="panel-title">
									<span>Account Details</span>
									<i class="fa fa-caret-left s-accordion-toggle-icon"></i>
								</h4>
							</div>
						</a>
						<div id="collapse8" class="panel-collapse collapse">
							<content class="s-body-box">
								
									<div class="tab-pane" id="tabaccountdetails">
										
			<div class="row">
		
		<div class="col-md-6">
			
				<div class="form-horizontal">
			

		<div class="s-table-header-nav s-listing-head-margin">
			<div class="col-xs-6 s-no-padding-left">
				<ul class="list-inline list-unstyled">
					<li>
						<h4>
							
								<span style="font-size:14px;color:#666666;">Account Email Addresses</span>
							
						</h4>
					</li>
				</ul>
			</div>

			<div class="col-xs-6 s-table-view-options s-no-padding-right">
				<ul class="list-inline list-unstyled">
					<li>
						<form class="s-table-header-search">
							
								<input type="text" name="search" class="form-control input-sm general-listing-search" placeholder="Search" value="" tableid="LD23027CB3E325272999D8836CB6D29008" >
							
						</form>
					</li>
					<li>
						<div class="btn-group navbar-left dropdown">

							<button type="button" class="btn btn-sm s-btn-dgrey dropdown-toggle"><i class="fa fa-cog"></i></button>

								<ul class="dropdown-menu pull-right" role="menu">
									<li><a title="Export List" class="adminentityexportSlatwallAccountEmailAddress " target="_self" href="/?slatAction=entity.exportSlatwallAccountEmailAddress">Export List</a></li> 
								</ul>
								
								

						</div>
					</li>
				</ul>

			</div>
		</div>

		<div class="table-responsive">
			<table id="LD23027CB3E325272999D8836CB6D29008" class="table table-bordered table-hover" data-norecordstext="There aren't any Account Email Addresses." data-savedstateid="23027CB3-E325-2729-99D8836CB6D29008" data-entityname="SlatwallAccountEmailAddress" data-idproperty="accountEmailAddressID" data-processobjectproperties="" data-propertyidentifiers="accountEmailAddressID,emailAddress,accountEmailType.typeName,verifiedFlag" >
				<thead>

					<tr>
						
						
							<th class="data primary" data-propertyIdentifier="emailAddress">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Email Address <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:emailAddress" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="accountEmailType.typeName">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Name <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:accountEmailType.typeName" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="verifiedFlag">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Verified <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Filter</li>
													
													<input type="hidden" name="F:verifiedFlag" value="" />
													
														<li><a href="#" class="listing-filter" data-filtervalue="NO"><i class="hibachi-ui-checkbox"></i> NO</a></li>
										</ul>
									</div>
								
							</th>
						
					</tr>
				</thead>
				<tbody >
					
						<tr id="8a8080874a3b3ecb014a5495479f004e" >
							
							
									<td class="primary">
										reinaldosolares@gmail.com 
									</td>
								
									<td class="">
										
									</td>
								
									<td class="">
										No 
									</td>
								
						</tr>
					
				</tbody>
			</table>

			</div>


		
		
			
			<hr />
			<br />
			
			
			

		<div class="s-table-header-nav s-listing-head-margin">
			<div class="col-xs-6 s-no-padding-left">
				<ul class="list-inline list-unstyled">
					<li>
						<h4>
							
								<span style="font-size:14px;color:#666666;">Account Phone Numbers</span>
							
						</h4>
					</li>
				</ul>
			</div>

			<div class="col-xs-6 s-table-view-options s-no-padding-right">
				<ul class="list-inline list-unstyled">
					<li>
						<form class="s-table-header-search">
							
								<input type="text" name="search" class="form-control input-sm general-listing-search" placeholder="Search" value="" tableid="LD23027E0709B8161BE088D87260605802" >
							
						</form>
					</li>
					<li>
						<div class="btn-group navbar-left dropdown">

							<button type="button" class="btn btn-sm s-btn-dgrey dropdown-toggle"><i class="fa fa-cog"></i></button>

								<ul class="dropdown-menu pull-right" role="menu">
									<li><a title="Export List" class="adminentityexportSlatwallAccountPhoneNumber " target="_self" href="/?slatAction=entity.exportSlatwallAccountPhoneNumber">Export List</a></li> 
								</ul>
								
								

						</div>
					</li>
				</ul>

			</div>
		</div>

		<div class="table-responsive">
			<table id="LD23027E0709B8161BE088D87260605802" class="table table-bordered table-hover" data-norecordstext="There aren't any Account Phone Numbers." data-savedstateid="23027E07-09B8-161B-E088D87260605802" data-entityname="SlatwallAccountPhoneNumber" data-idproperty="accountPhoneNumberID" data-processobjectproperties="" data-propertyidentifiers="accountPhoneNumberID,phoneNumber,accountPhoneType.typeName" >
				<thead>

					<tr>
						
						
							<th class="data primary" data-propertyIdentifier="phoneNumber">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Phone Number <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:phoneNumber" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="accountPhoneType.typeName">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Name <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:accountPhoneType.typeName" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
					</tr>
				</thead>
				<tbody >
					
						<tr id="8a8080874a3b3ecb014a549547ba004f" >
							
							
									<td class="primary">
										7604738055 
									</td>
								
									<td class="">
										
									</td>
								
						</tr>
					
				</tbody>
			</table>

			</div>


		
		
			
			<hr />
			<br />
			
			
			

		<div class="s-table-header-nav s-listing-head-margin">
			<div class="col-xs-6 s-no-padding-left">
				<ul class="list-inline list-unstyled">
					<li>
						<h4>
							
								<span style="font-size:14px;color:#666666;">Price Groups</span>
							
						</h4>
					</li>
				</ul>
			</div>

			<div class="col-xs-6 s-table-view-options s-no-padding-right">
				<ul class="list-inline list-unstyled">
					<li>
						<form class="s-table-header-search">
							
								<input type="text" name="search" class="form-control input-sm general-listing-search" placeholder="Search" value="" tableid="LD23027EC6F8FDFB0353DB39139EA3C443" >
							
						</form>
					</li>
					<li>
						<div class="btn-group navbar-left dropdown">

							<button type="button" class="btn btn-sm s-btn-dgrey dropdown-toggle"><i class="fa fa-cog"></i></button>

								<ul class="dropdown-menu pull-right" role="menu">
									<li><a title="Export List" class="adminentityexportSlatwallPriceGroup " target="_self" href="/?slatAction=entity.exportSlatwallPriceGroup">Export List</a></li> 
								</ul>
								
								

						</div>
					</li>
				</ul>

			</div>
		</div>

		<div class="table-responsive">
			<table id="LD23027EC6F8FDFB0353DB39139EA3C443" class="table table-bordered table-hover" data-norecordstext="There aren't any Price Groups." data-savedstateid="23027EC6-F8FD-FB03-53DB39139EA3C443" data-entityname="SlatwallPriceGroup" data-idproperty="priceGroupID" data-processobjectproperties="" data-propertyidentifiers="priceGroupID,priceGroupName" >
				<thead>

					<tr>
						
						
							<th class="data primary" data-propertyIdentifier="priceGroupName">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Price Group Name <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:priceGroupName" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
					</tr>
				</thead>
				<tbody >
					
						<tr><td colspan="1" style="text-align:center;"><em>There aren't any Price Groups.</em></td></tr>
					
				</tbody>
			</table>

			</div>


		
		
			
			<hr />
			<br />
			
			
			<h5>Term Account Credit Details</h5>	
			
					<div class="form-group">
						<label class="control-label col-sm-4 title" style="text-align:left;">Term Account Available Credit</label>
						
						<div class="col-sm-8">
							
									<p class="form-control-static value">$0.00</p>
								
						</div>
					</div>
				
					<div class="form-group">
						<label class="control-label col-sm-4 title" style="text-align:left;">Term Account Balance</label>
						
						<div class="col-sm-8">
							
									<p class="form-control-static value">$0.00</p>
								
						</div>
					</div>
				
				</div>
			
		</div>
	
		<div class="col-md-6">
			
				<div class="form-horizontal">
			

		<div class="s-table-header-nav s-listing-head-margin">
			<div class="col-xs-6 s-no-padding-left">
				<ul class="list-inline list-unstyled">
					<li>
						<h4>
							
								<span style="font-size:14px;color:#666666;">Account Payment Methods</span>
							
						</h4>
					</li>
				</ul>
			</div>

			<div class="col-xs-6 s-table-view-options s-no-padding-right">
				<ul class="list-inline list-unstyled">
					<li>
						<form class="s-table-header-search">
							
								<input type="text" name="search" class="form-control input-sm general-listing-search" placeholder="Search" value="" tableid="LD23027FFA9404008FC9E1242EC2097FAD" >
							
						</form>
					</li>
					<li>
						<div class="btn-group navbar-left dropdown">

							<button type="button" class="btn btn-sm s-btn-dgrey dropdown-toggle"><i class="fa fa-cog"></i></button>

								<ul class="dropdown-menu pull-right" role="menu">
									<li><a title="Export List" class="adminentityexportSlatwallAccountPaymentMethod " target="_self" href="/?slatAction=entity.exportSlatwallAccountPaymentMethod">Export List</a></li> 
								</ul>
								
								

						</div>
					</li>
				</ul>

			</div>
		</div>

		<div class="table-responsive">
			<table id="LD23027FFA9404008FC9E1242EC2097FAD" class="table table-bordered table-hover" data-norecordstext="There aren't any Account Payment Methods." data-savedstateid="23027FFA-9404-008F-C9E1242EC2097FAD" data-entityname="SlatwallAccountPaymentMethod" data-idproperty="accountPaymentMethodID" data-processobjectproperties="" data-propertyidentifiers="accountPaymentMethodID,accountPaymentMethodName,paymentMethod.paymentMethodName" >
				<thead>

					<tr>
						
						
							<th class="data primary" data-propertyIdentifier="accountPaymentMethodName">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Nickname <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:accountPaymentMethodName" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="paymentMethod.paymentMethodName">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Payment Method Name <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:paymentMethod.paymentMethodName" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="admin admin1" data-detailaction="admin:entity.detailaccountpaymentmethod" data-detailquerystring="accountID=8a8080874a3b3ecb014a54954777004d" data-detailmodal="true">&nbsp;</th>
						
					</tr>
				</thead>
				<tbody >
					
						<tr><td colspan="3" style="text-align:center;"><em>There aren't any Account Payment Methods.</em></td></tr>
					
				</tbody>
			</table>

			</div>


		
		
			
			<hr />
			<br />
			
			
			

		<div class="s-table-header-nav s-listing-head-margin">
			<div class="col-xs-6 s-no-padding-left">
				<ul class="list-inline list-unstyled">
					<li>
						<h4>
							
								<span style="font-size:14px;color:#666666;">Account Addresses</span>
							
						</h4>
					</li>
				</ul>
			</div>

			<div class="col-xs-6 s-table-view-options s-no-padding-right">
				<ul class="list-inline list-unstyled">
					<li>
						<form class="s-table-header-search">
							
								<input type="text" name="search" class="form-control input-sm general-listing-search" placeholder="Search" value="" tableid="LD230280FFD8B7F1C278A00393028A4496" >
							
						</form>
					</li>
					<li>
						<div class="btn-group navbar-left dropdown">

							<button type="button" class="btn btn-sm s-btn-dgrey dropdown-toggle"><i class="fa fa-cog"></i></button>

								<ul class="dropdown-menu pull-right" role="menu">
									<li><a title="Export List" class="adminentityexportSlatwallAccountAddress " target="_self" href="/?slatAction=entity.exportSlatwallAccountAddress">Export List</a></li> 
								</ul>
								
								

						</div>
					</li>
				</ul>

			</div>
		</div>

		<div class="table-responsive">
			<table id="LD230280FFD8B7F1C278A00393028A4496" class="table table-bordered table-hover" data-norecordstext="There aren't any Account Addresses." data-savedstateid="230280FF-D8B7-F1C2-78A00393028A4496" data-entityname="SlatwallAccountAddress" data-idproperty="accountAddressID" data-processobjectproperties="" data-propertyidentifiers="accountAddressID,accountAddressName,address.name,address.streetAddress,address.street2Address,address.city,address.stateCode,address.postalCode" >
				<thead>

					<tr>
						
						
							<th class="data primary" data-propertyIdentifier="accountAddressName">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Nickname <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:accountAddressName" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="address.name">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Name <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:address.name" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="address.streetAddress">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Street Address <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:address.streetAddress" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="address.street2Address">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Street Address 2 <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:address.street2Address" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="address.city">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">City <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:address.city" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="address.stateCode">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">State <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:address.stateCode" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
							<th class="data " data-propertyIdentifier="address.postalCode">
								
									<div class="dropdown">
										<a href="#" class="dropdown-toggle">Postal Code <i class="fa fa-sort-desc"></i></a>
										<ul class="dropdown-menu nav scrollable">
											<li class="dropdown-header">Sort</li>
													<li><a href="#" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
													<li><a href="#" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Descending</a></li>
													<li class="divider"></li>
												
													<li class="dropdown-header">Search</li>
													<li class="search-filter"><input type="text" class="listing-search form-control" name="FK:address.postalCode" value="" /> <i class="icon-search"></i></li>
										</ul>
									</div>
								
							</th>
						
					</tr>
				</thead>
				<tbody >
					
						<tr><td colspan="7" style="text-align:center;"><em>There aren't any Account Addresses.</em></td></tr>
					
				</tbody>
			</table>

			</div>


		
			
			
			<hr />
			<br />
			
			
			<h5>Comments</h5>
			
	
	<div class="tab-pane" id="tabComments">
		
			<table class="table table-bordered table-hover">
				<tr>
					<th class="primary">Comment</th>
					<th>Public</th>
					<th>Created By</th>
					<th>Created Date Time</th>
					
				</tr>
				
					<tr><td colspan="4" style="text-align:center;"><em>There aren't any Comments.</em></td></tr>
				
			</table>
			

			<br><br>
			
			
			
	</div>

				</div>
			
		</div>
	
		</div>
	
									</div>
								
							</content>
						</div>
					</div>
				
					<div class="j-panel panel panel-default">
						<a data-toggle="collapse"  href="#collapse9">
							<div class="panel-heading">
								<h4 class="panel-title">
									<span>Comments</span>
									<i class="fa fa-caret-left s-accordion-toggle-icon"></i>
								</h4>
							</div>
						</a>
						<div id="collapse9" class="panel-collapse collapse">
							<content class="s-body-box">
								
									<div class="tab-pane" id="comments">
										
		<div class="tab-pane" id="tabComments">
			
	
	<div class="tab-pane" id="tabComments">
		
			<table class="table table-bordered table-hover">
				<tr>
					<th class="primary">Comment</th>
					<th>Public</th>
					<th>Created By</th>
					<th>Created Date Time</th>
					<th class="admin1">&nbsp;</th>
				</tr>
				
					<tr><td colspan="5" style="text-align:center;"><em>There aren't any Comments.</em></td></tr>
				
			</table>
			<a title="Add Comment" class="adminentitycreatecomment btn btn-default modalload" target="_self" href="/?slatAction=entity.createcomment&orderID=8a8080874a3b3ecb014a549547fb0050&redirectAction=admin:entity.editorder" data-toggle="modal" data-target="#adminModal"><i class="glyphicon glyphicon-plus"></i> Add Comment</a> 

			<br><br>
			
			
			
				<table class="table table-bordered table-hover">
					<tr>
						<th class="primary">Related Children Comment</th>
						<th>Public</th>
						<th>Created By</th>
						<th>Created Date Time</th>
						<th class="admin1">&nbsp;</th>
					</tr>
					
						<tr><td colspan="5" style="text-align:center;"><em>There aren't any Comments.</em></td></tr>
					
				</table>
			
	</div>

		</div>
	
									</div>
								
							</content>
						</div>
					</div>
				
					<div class="j-panel panel panel-default">
						<a data-toggle="collapse" href="#tabSystem">
							<div class="panel-heading">
								<h4 class="panel-title">
									<span>System</span>
									<i class="fa fa-caret-left s-accordion-toggle-icon"></i>
								</h4>
							</div>
						</a>
						<div id="tabSystem" class="panel-collapse collapse">
							<content class="s-body-box">
								
									<div  class="tab-pane"  id="tabSystem">
										
											
		<div class="col-md-12">
			
				<div class="form-horizontal">
			
					<div class="form-group">
						<label class="control-label col-sm-4 title" style="text-align:left;">Order ID</label>
						
						<div class="col-sm-8">
							
									<p class="form-control-static value">8a8080874a3b3ecb014a549547fb0050</p>
								
						</div>
					</div>
				
					<div class="form-group">
						<label class="control-label col-sm-4 title" style="text-align:left;">Remote ID</label>
						
						<div class="col-sm-8">
							
									<p class="form-control-static value"></p>
								
						</div>
					</div>
				
				</div>
			
		</div>
	
		<div class="table-responsive">	
			<table class="table table-bordered table-hover">
				<tbody>
					
								
								<tr>
									<th colspan="3">December 2014</th>
								</tr>
								
							
							<tr>
								<td style="white-space:nowrap;width:1%;"> - Reyjay solares</td>
								<td class="primary">
									Created <a title="Order - Reinaldo Solares" class="adminentitydetailOrder " target="_self" href="/?slatAction=entity.detailOrder&OrderID=8a8080874a3b3ecb014a549547fb0050">Order - Reinaldo Solares</a> 
										<br />
										
											<em>Set: 
											Order Type, Order Status, Customer Account, Currency Code 
											</em>
										
								</td>
								<td class="admin admin1">
									<a title="" class="adminentitypreprocessaudit btn btn-xs modalload" target="_self" href="/?slatAction=entity.preprocessaudit&processContext=rollback&auditID=8a8080874a3b3ecb014a549549470053&redirectAction=admin:entity.detailOrder" data-toggle="modal" data-target="#adminModal"><i class="glyphicon glyphicon-eye-open"></i> </a> 
								</td>
							</tr>
						
				</tbody>
			</table>
		</div>
	
										
									</div>
								
							</content>
						
					</div>
					
			</div>
		
			</form>
		
				</div>
	
			</section>
	
			<!-- Admin Modals -->
			<div id="adminModal" class="modal fade">
	
			</div>
			<div id="adminDisabled" class="modal">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header"><a class="close" data-dismiss="modal">&times;</a><h3>Disabled</h3></div>
						<div class="modal-body"></div>
						<div class="modal-footer">
							<a href="#" class="btn btn-sm btn-default btn-inverse" data-dismiss="modal" id="disabledOkLink"><i class="icon-ok icon-white"></i> Ok</a>
						</div>
					</div>
				</div>
			</div>
			<div id="adminConfirm" class="modal">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header"><a class="close" data-dismiss="modal">&times;</a><h3>Confirm</h3></div>
						<div class="modal-body"></div>
						<div class="modal-footer">
							<a href="#" target="_self" class="btn btn-sm btn-default btn-inverse" data-dismiss="modal" id="confirmNoLink"><i class="icon-remove icon-white"></i> No</a>
							<a href="#" target="_self" class="btn btn-sm btn-default btn-primary" id="confirmYesLink"><i class="icon-ok icon-white"></i> Yes</a>
						</div>
					</div>
				</div>
			</div>
	
			
			<div ng-controller="pageDialog">
				<div id="topOfPageDialog" >
					<div style="z-index:3000" class="s-dialog-container" ng-repeat="pageDialog in pageDialogs" >
						<div  ng-include="pageDialog.path" ></div>
					</div>
				</div>
			</div>
	
			
			<span ng-controller="alertController" >
				<span ng-repeat="alert in alerts">
					<div style="z-index:5000" ng-class="{fade:alert.fade,'alert\-success':alert.type==='success','alert\-danger':alert.type==='error'}" class="alert s-alert-footer fade in" role="alert" >
						
						<button style="display:none;" ng-show="alert.dismissable" type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
						
						<i style="display:none;" class="fa fa-check" ng-show="alert.type === 'success'"></i>&nbsp;<span ng-bind="alert.msg"></span>
					</div>
				</span>
			</span>
		</span>
		
		
		<script type="text/javascript" src="/client/lib/date/date.min.js"></script>
		<script type="text/javascript" src="/client/lib/angular/angular.min.js"></script>
		<script type="text/javascript" src="/client/lib/angular-ui-bootstrap/ui.bootstrap.js"></script>
		<script type="text/javascript" src="/client/lib/angular/angular-resource.min.js"></script>
		<script type="text/javascript" src="/client/lib/angular/angular-cookies.min.js"></script>
		<script type="text/javascript" src="/client/lib/angular/angular-animate.min.js"></script>
		<script type="text/javascript" src="/client/lib/angular/angular-route.min.js"></script>
		<script type="text/javascript" src="/client/lib/metismenu/metismenu.js"></script>
		
		
		<script type="text/javascript">
			var slatwallConfig = $.slatwall.getConfig();
		</script>
		
		
		<script type="text/javascript" >
			angular.module('slatwalladmin', ['ngSlatwall','ui.bootstrap','ngAnimate','ngRoute']).
			config(
				["$provide",'$logProvider','$filterProvider','$httpProvider','$routeProvider','$locationProvider','datepickerConfig', 'datepickerPopupConfig',
				function ($provide, $logProvider,$filterProvider,$httpProvider,$routeProvider,$locationProvider,datepickerConfig, datepickerPopupConfig
			) {
				datepickerConfig.showWeeks = false;
				datepickerPopupConfig.toggleWeeksText = null;
				
				$locationProvider.html5Mode( false ).hashPrefix('!');
				$provide.constant("baseURL", $.slatwall.getConfig().baseURL);
				
				var _partialsPath = $.slatwall.getConfig().baseURL + '/admin/client/js/directives/partials/';
				
				$provide.constant("partialsPath", _partialsPath);
				$provide.constant("productBundlePartialsPath", _partialsPath+'productbundle/');
				$provide.constant("collectionPartialsPath", _partialsPath+'collection/');
				$provide.constant("workflowPartialsPath", _partialsPath+'workflow/');
				
				$logProvider.debugEnabled( $.slatwall.getConfig().debugFlag );
				$filterProvider.register('likeFilter',function(){
					return function(text){
						if(angular.isDefined(text) && angular.isString(text)){
							return text.replace(new RegExp('%', 'g'), '');
						}
					};
				});
				
				$filterProvider.register('truncate',function(){
					return function (input, chars, breakOnWord) {
						if (isNaN(chars)) return input;
						if (chars <= 0) return '';
						if (input && input.length > chars) {
							input = input.substring(0, chars);
							if (!breakOnWord) {
								var lastspace = input.lastIndexOf(' ');
								//get last space
								if (lastspace !== -1) {
									input = input.substr(0, lastspace);
								}
							}else{
								while(input.charAt(input.length-1) === ' '){
									input = input.substr(0, input.length -1);
								}
							}
							return input + '...';
						}
						return input;
					};
				});
				
				$httpProvider.interceptors.push('slatwallInterceptor');
				
				
				$routeProvider.when('/entity/:entityName/', {
					templateUrl: $.slatwall.getConfig().baseURL + '/admin/client/js/directives/partials/router.html',
					controller: 'routerController'
				}).when('/entity/:entityName/:entityID', {
					templateUrl: $.slatwall.getConfig().baseURL + '/admin/client/js/directives/partials/router.html',
					controller: 'routerController'
				}).otherwise({
					templateUrl: $.slatwall.getConfig().baseURL + '/admin/client/js/partials/otherwise.html',
				});
				
			}]).run(['$rootScope','$filter','$slatwall','dialogService', function($rootScope,$filter, $slatwall ,dialogService) {
				$rootScope.openPageDialog = function( partial ) {
					dialogService.addPageDialog( partial );
				};
				
				$rootScope.closePageDialog = function( index ) {
					dialogService.removePageDialog( index );
				};
				
				$rootScope.loadedResourceBundle = false;
				$rootScope.loadedResourceBundle = $slatwall.hasResourceBundle();
				
				var rbListener = $rootScope.$watch('loadedResourceBundle',function(newValue,oldValue){
					if(newValue !== oldValue){
						$rootScope.$broadcast('hasResourceBundle');
						rbListener();
					}
				});

			}]).filter('entityRBKey',['$slatwall', function($slatwall) {
				
				return function(text){
					if(angular.isDefined(text) && angular.isString(text)){
						text = text.replace('_', '').toLowerCase();
						text = $slatwall.getRBKey('entity.'+text);
						return text;
					}
				};
			}]);
			
		</script>

		<script type="text/javascript" src="/?slatAction=api:js.ngslatwall&instantiationKey=2249601B-92D2-0DEF-33980D0AD074ADD8"></script>
		
		
		<script type="text/javascript" src="/?slatAction=api:js.ngcompressor&jspath=admin/client/js&instantiationKey=2249601B-92D2-0DEF-33980D0AD074ADD8"></script>
		
		
		<!-- JS to toggle data in table bundles -->
		<script charset="utf-8">
			$('.s-toggle-detail-link').each(function(){
				var dataId = $(this).closest('tr').attr('data-id');
				var textValue = $(this).html();
				$(this).closest('tr').siblings('[data-id="' + dataId + '"]').toggle();
				$(this).html($(this).text() == 'hide detail' ? 'show detail' : 'hide detail');
			});	
			$('.s-toggle-detail-link').click(function(){
				var dataId = $(this).closest('tr').attr('data-id');
				var textValue = $(this).html();
				$(this).closest('tr').siblings('[data-id="' + dataId + '"]').toggle();
				$(this).html($(this).text() == 'hide detail' ? 'show detail' : 'hide detail');
			});	
		</script>
		
		
	</body>
</html>
