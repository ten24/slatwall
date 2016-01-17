<!DOCTYPE html>
<html lang="en">
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
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script> 
    <script src="/org/hibachi/client/src/slatwall_frontend.js"></script>
    
    <cfoutput>
        <script>
        	/** this is a temp holdover until solution is found to remove slatwallAngular altogether */
            var slatwallAngular = {
                slatwallConfig:{
                    baseUrl:'/'
                }
            };
            /********************************************************************************************************************************/
            /** Overwrite the partialPath and baseUrl for this application */
            /*angular.module('customfrontend',['frontend'])
                .config(['pathBuilderConfig', function(pathBuilderConfig){
                    pathBuilderConfig.setBaseURL('http://#cgi.server_name#/'); 
                    pathBuilderConfig.setBasePartialsPath('custom/assets/');
                }]).constant('frontendPartialsPath','frontend/');*/
            /********************************************************************************************************************************/    
        </script>
    </cfoutput>
</head>
<body role="document">

<header>
	<div class="container"></div>
</header>

<div class="container"> 
	<!--- body_container start --->
