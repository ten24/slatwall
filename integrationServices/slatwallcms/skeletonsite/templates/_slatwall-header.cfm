<cfoutput>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>#$.slatwall.getCurrentRequestSite().getSiteName()#</title>
    <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/client/src/vendor.bundle.js" charset="utf-8"></script>

    <!--- This creates a client side object for Slatwall so that $.slatwall API works from the client side --->
    #$.slatwall.renderJSObject( subsystem="public" )#
		<style>
			[ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
			  display: none !important;
			}
		</style>
		<script>
	        var hibachiConfig = {
	            action:'slatAction'
				,basePartialsPath: '/org/Hibachi/client/src/'
				,customPartialsPath:'/custom/apps/#$.slatwall.getSite().getApp().getAppName()#/#$.slatwall.getSite().getSiteName()#/templates/partials/'
	        };
	   </script>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">

    <style media="screen">
    @media (min-width: 768px) {
        .card .collapse  {
            display: block;
        }
    }
    </style>

  </head>

  <body>

	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		<div class="container">
			<a class="navbar-brand" href="##">#$.slatwall.getCurrentRequestSite().getSiteName()#</a>
		</div>
	</nav>
</cfoutput>