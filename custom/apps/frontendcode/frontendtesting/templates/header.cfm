<!DOCTYPE html>
    <!--- Using ng-app with slatwallClient allows the angular to have control over the entire application. This could be placed on any tag before you start using {{ these.things }} --->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script> 
	<script src="/custom/apps/frontendcode/frontendtesting/swfApp/angular.min.js"></script>
	<script src="/client/lib/angular/angular-resource.min.js"></script>
	<script src="/admin/client/js/es5/services/utilityService.js"></script>
	<script src="/admin/client/js/es5/modules/ngslatwall.js"></script>
	<script src="/admin/client/js/es5/modules/ngslatwallmodel.js"></script>
    <script src="/custom/apps/frontendcode/frontendtesting/swfApp/sw-modules/frontendmodule.js"></script>
    <script src="/custom/apps/frontendcode/frontendtesting/swfApp/sw-services/cartService.js"></script>
    <script src="/custom/apps/frontendcode/frontendtesting/swfApp/sw-services/accountService.js"></script>
    <script src="/custom/apps/frontendcode/frontendtesting/swfApp/sw-services/processObjectService.js"></script>
    <script src="/custom/apps/frontendcode/frontendtesting/swfApp/sw-controllers/frontend-controller.js"></script>
	<script src="/admin/client/js/es5/modules/loggingmodule.js"></script>
<html lang="en" ng-app="frontEndApplication">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<cfoutput>
	<meta name="description" content="">
	<meta name="author" content="">
	<title>${site.siteName}</title>
	</cfoutput>
	
	<!--- Styles --->
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300italic,300,400italic,600,600italic,700,700italic,800,800italic' rel='stylesheet' type='text/css'>
	
</head>
<!--- adding ng-controller lets this application have access to all the properties and methods in the angular controller {{ cart.orderID }} -> {{ account.firstName }} etc --->
<body role="document">

<header>
	<div class="container"></div>
</header>
<script type="text/javascript">
var slatwallAngular = {};
slatwallAngular.slatwallConfig = $.slatwall.getConfig();
<cfif !isnull(rc.ng)>
    slatwallAngular.hashbang = true;
</cfif>
slatwallAngular.constantPaths = [];
<cfloop collection="#$.slatwall.getService('hibachiService').getEntitiesMetaData()#" item="local.entityName">
    slatwallAngular.constantPaths.push('#local.entityName#');
</cfloop>
</script>
<div class="container"> 
	<!--- body_container start --->
  
