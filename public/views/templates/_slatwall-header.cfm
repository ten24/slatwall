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

<!DOCTYPE html>
<html lang="en">
	<head>
	    <meta charset="utf-8">
	    <title>Slatwall</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">

		<!--- jQuery is only required if you would like to use the Slatwall client side object --->
		<script src="https://code.jquery.com/jquery-3.1.1.min.js" integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8=" crossorigin="anonymous"></script>

		<!--- This creates a client side object for Slatwall so that $.slatwall API works from the client side --->
		<cfoutput>#$.slatwall.renderJSObject( subsystem="public" )#</cfoutput>
		<style>
			[ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
			  display: none !important;
			}
		</style>
		<!--- Bootstrap and Fontawesome CDNs -- Replace with local file copies for production --->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
		<!---<script src='https://www.google.com/recaptcha/api.js'></script>--->
		<cfoutput>
			<script>
		        var hibachiConfig = {
		            action:'slatAction'
					,basePartialsPath: '/org/Hibachi/client/src/'
					,customPartialsPath:'/custom/apps/#$.slatwall.getSite().getApp().getAppName()#/#$.slatwall.getSite().getSiteName()#/templates/partials/'
		        };
		    </script>
	    </cfoutput>
	</head>
	<body>
		<!--- This is only used by the sample app that is contained in /meta/sample --->
		<cfif structKeyExists(request, "sampleNavigation")>
			<cfoutput>#request.sampleNavigation#</cfoutput>
		</cfif>
