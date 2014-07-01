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

<cfinterface>
	
	<cffunction name="init" access="public" returntype="any">
		
	</cffunction>
	
	<cffunction name="getDisplayName" access="public" returntype="string">
		<!---
			This method should return a String with the display name
			that you would like for the integration to have
		--->
	</cffunction>
	
	<cffunction name="getIntegrationTypes" access="public" returntype="string">
		<!---
			This method should return a comma seperated list of the integration types
			that it supports.  Here are the possible integration types:
			
			shipping		|		When set this integration will be able to be used by shipping methods / rates
			payment			|		When set this integration will be able to be used by payment methods
			tax				|		When set this integration will be able to be used by tax methods
			fw1				|		When set then this integration can have custom views, ect.
			custom			|		This is defined when all you want to do is hook into events, but no views or anything else.
		--->
	</cffunction>
	
	<cffunction name="getSettings" access="public" returntype="struct">
		<!---
			This method should return true only if there is a /views/main/default.cfm file
			inside of the integration service
		--->
	</cffunction>
	
	<cffunction name="getEventHandlers" returntype="array">
		<!---
			This method should return a valid coldspring xml that overrides the default xml
		--->
		
	</cffunction> 

</cfinterface>
