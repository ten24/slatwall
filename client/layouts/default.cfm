<cfoutput>
<!DOCTYPE html>
<html lang="en" ng-app="slatwall">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<meta charset="utf-8">
	<title>Collections | Slatwall</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1, user-scalable=no">
	<meta name="description" content="">
	<meta name="author" content="">
	<link rel="stylesheet" type="text/css" href="#request.slatwallScope.getBaseURL()#/client/lib/cloud/css/cloud-admin.css" >
	<link rel="stylesheet" type="text/css" href="#request.slatwallScope.getBaseURL()#/client/css/slatwall-theme.css">
	<link rel="stylesheet" type="text/css" href="#request.slatwallScope.getBaseURL()#/client/lib/cloud/css/responsive.css" >
	<link href="#request.slatwallScope.getBaseURL()#/client/lib/cloud/font-awesome/css/font-awesome.min.css" rel="stylesheet">
	<!-- ANIMATE -->
	<link rel="stylesheet" type="text/css" href="#request.slatwallScope.getBaseURL()#/client/lib/cloud/css/animatecss/animate.min.css" />
	<!-- DATE RANGE PICKER -->
	<link rel="stylesheet" type="text/css" href="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/bootstrap-daterangepicker/daterangepicker-bs3.css" />
	<!-- TODO -->
	<link rel="stylesheet" type="text/css" href="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/jquery-todo/css/styles.css" />
	<!-- FULL CALENDAR -->
	<link rel="stylesheet" type="text/css" href="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/fullcalendar/fullcalendar.min.css" />
	<!-- GRITTER -->
	<link rel="stylesheet" type="text/css" href="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/gritter/css/jquery.gritter.css" />
	<!-- FONTS -->
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700' rel='stylesheet' type='text/css'>
</head>
<body>
	#body#
	
	<!-- JAVASCRIPTS -->
	<!-- Placed at the end of the document so the pages load faster -->
	<!-- JQUERY -->
	<script src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/jquery/jquery-2.0.3.min.js"></script>
	<!-- JQUERY UI-->
	<script src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.min.js"></script>
	<!-- BOOTSTRAP -->
	<script src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/bootstrap-dist/js/bootstrap.min.js"></script>
		
	<!-- DATE RANGE PICKER -->
	<script src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/bootstrap-daterangepicker/moment.min.js"></script>
	
	<script src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/bootstrap-daterangepicker/daterangepicker.min.js"></script>
	<!-- SLIMSCROLL -->
	<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/jQuery-slimScroll-1.3.0/jquery.slimscroll.min.js"></script>
	<!-- SLIMSCROLL -->
	<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/jQuery-slimScroll-1.3.0/jquery.slimscroll.min.js"></script><script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/jQuery-slimScroll-1.3.0/slimScrollHorizontal.min.js"></script>
	<!-- BLOCK UI -->
	<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/jQuery-BlockUI/jquery.blockUI.min.js"></script>
	<!-- SPARKLINES -->
	<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/sparklines/jquery.sparkline.min.js"></script>
	<!-- EASY PIE CHART -->
	<script src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/jquery-easing/jquery.easing.min.js"></script>
	<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/easypiechart/jquery.easypiechart.min.js"></script>
	<!-- TODO -->
	<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/jquery-todo/js/paddystodolist.js"></script>
	<!-- TIMEAGO -->
	<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/timeago/jquery.timeago.min.js"></script>
	<!-- FULL CALENDAR -->
	<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/fullcalendar/fullcalendar.min.js"></script>
	<!-- COOKIE -->
	<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/jQuery-Cookie/jquery.cookie.min.js"></script>
	<!-- GRITTER -->
	<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/gritter/js/jquery.gritter.min.js"></script>
	
	<!---
	<!-- CUSTOM SCRIPT -->
	<script src="#request.slatwallScope.getBaseURL()#/client/lib/cloud/js/script.js"></script>
	<script>
		jQuery(document).ready(function() {		
			App.setPage("index");  //Set current page
			App.init(); //Initialise plugins and elements
		});
	</script>
	--->
	
	<!-- /JAVASCRIPTS -->
	<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/angularjs/1.0.7/angular.min.js"></script>
	<script type="text/javascript">
		var slatwall = angular.module('slatwall', []).config(function($httpProvider){
			$httpProvider.defaults.headers.common['X-Hibachi-AJAX'] = true;
			$httpProvider.defaults.headers.post["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8";
		});
	</script>
	<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/directives/swCollectionDisplay.js"></script>
	<!---<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/client/controllers/main.js"></script>--->
</body>
</html>
</cfoutput>