<cfoutput>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Tony's Tacos</title>
    
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

    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">

    <style media="screen">
    @media (min-width: 768px) {
        .card .collapse  {
            display: block;
        }
    }
    </style>

  </head>

  <body>

    <!-- Navigation -->
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		<div class="container">
			<a class="navbar-brand" href="##">Tony's Tacos</a>
			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="##navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarResponsive">
				<ul class="navbar-nav ml-auto">
					<li class="nav-item active">
						<a class="nav-link" href="##">Home
						<span class="sr-only">(current)</span>
						</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="##">Product Listing</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="##">Product Detail</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="##">Shopping Cart</a>
					</li>
				</ul>
			</div>
		</div>
	</nav>
</cfoutput>