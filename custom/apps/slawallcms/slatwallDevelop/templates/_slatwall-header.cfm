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
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-ui.min.js"></script>

		<!--- This creates a client side object for Slatwall so that $.slatwall API works from the client side --->
		#$.slatwall.renderJSObject( subsystem="public" )#
		<style>
			[ng\:cloak],
			[ng-cloak],
			[data-ng-cloak],
			[x-ng-cloak],
			.ng-cloak,
			.x-ng-cloak {
				display: none !important;
			}
		</style>
		<script>
			var hibachiConfig = {
				action: 'slatAction',
				basePartialsPath: '/org/Hibachi/client/src/',
				customPartialsPath: '/custom/apps/#$.slatwall.getSite().getApp().getAppName()#/#$.slatwall.getSite().getSiteName()#/templates/partials/'
			};
		</script>
		<link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/css/jquery-ui.min.css" rel="stylesheet">
		<link href="//stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
		<link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">

		<style media="screen">
			@media (min-width: 768px) {
				.card .collapse {
					display: block;
				}
			}
		</style>

	</head>
  <body ng-cloak>
    <cfinclude template="inc/globalAngularVariables.cfm" />
    <!--- Header Nav --->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
      <div class="container">
      <a class="navbar-brand" href="##">#$.slatwall.getCurrentRequestSite().getSiteName()#</a>
        <div class="collapse navbar-collapse" id="navbarNav">
          <ul class="navbar-nav">
            <li class="nav-item active">
              <a class="nav-link" href="##">Home <span class="sr-only">(current)</span></a>
            </li>
            <cfif $.slatwall.getLoggedInFlag()>
            <li class="nav-item">
              <a class="nav-link" href="/product-listing">Product Listing</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/checkout">Checkout</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="##">Pricing</a>
            </li>
            </ul>
            <ul class="navbar-nav ml-auto"> 
             <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle col-xs-12" href="##" id="navbarDropdown" role="button" data-toggle="dropdown" >
                <i class="fa fa-shopping-cart"></i> <span class="cart-Items"> </span>

                <span ng-show="slatwall.cart.orderItems.length">
                 <span><small>{{slatwall.cart.orderItems.length}}/{{slatwall.cart.subtotal | currency}}</small></span>
                  
                </span>
              </a>
              <div class="dropdown-menu px-2">
                <cfinclude template="inc/header/minicart.cfm" />
              </div>
            </li>
              <li class="nav-item dropdown">
                  <a class="nav-link dropdown-toggle" href="##" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                   <i class="fa fa-user"></i> #$.slatwall.getAccount().getFirstName()#  #$.slatwall.getAccount().getLastName()#</a>
               
                  <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="/my-account">My Account</a>
                    <a class="dropdown-item" href="?slatAction=public:account.logout">Log Out</a>
                  </div>
             </li>
             </ul>
            </cfif>
          </div>
        </div>
    </nav>

</cfoutput>



