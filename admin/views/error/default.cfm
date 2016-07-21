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

<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cftry>
	<cfset local.errorDisplayFlag = false />
	<cfset local.errorNotifyEmailAddresses = '' />
	
	<cfif structKeyExists(request, "slatwallScope")>
		<cfset local.errorDisplayFlag = request.slatwallScope.getApplicationValue('errorDisplayFlag') />
		<cfset local.errorNotifyEmailAddresses = request.slatwallScope.getApplicationValue('errorNotifyEmailAddresses') />
	</cfif>
	
	<cfif local.errorDisplayFlag>
		<cfdump var="#request.exception#" />
	<cfelse>
		<h1>There was an unexpected error while processing your request.</h1><br />
		<cftry>
			<cfif len(local.errorNotifyEmailAddresses)>
				<cfsavecontent variable="local.errorText">
					<cfoutput>
					<h2>An error occurred</h2>
					Template: http://#cgi.server_name##cgi.script_name#?#cgi.query_string#<br />
					Time: #dateFormat(now(), "short")# #timeFormat(now(), "short")#<br />
					Remote IP Address: #cgi.REMOTE_ADDR#<br />
					<cfdump var="#request.exception#" label="Error">				
					</cfoutput>
				</cfsavecontent>
				
				<cfmail to="#local.errorNotifyEmailAddresses#" from="#listFirst(local.errorNotifyEmailAddresses)#" subject="Slatwall Error Notification" type="html">
					#local.errorText#	
				</cfmail>
				<strong>An error notification email was sent to the administrator.</strong><br /><br />
			<cfelse>
				<strong>Please notify your system administrator.</strong><br /><br />
			</cfif>
			
			<cfcatch>
				Please notify your system administrator.<br /><br />
				An error notification email was unable to be sent likely because of an invalid 'errorNotifyEmailAddresses' setting configuration<cfif isSimpleValue(local.errorNotifyEmailAddresses)> which is currently set to: <strong><cfoutput>#local.errorNotifyEmailAddresses#</cfoutput></strong> and should be a comma seperated list of email addresses (see below for example)</cfif><br /><br />
			</cfcatch>
		</cftry>
	</cfif>
	<cfcatch>
		An Unexpected Error occured and the error cannot be displayed or emailed
		<cfdump var="#cfcatch#" />
	</cfcatch>
</cftry>
<hr />
<br />
To see errors, add the following line to /Slatwall/custom/config/configFramework.cfm:<br />
<pre>&lt;cfset variables.framework.hibachi.errorDisplayFlag = true /&gt;</pre><br /><br />
To have errors emailed you can add the following line to /Slatwall/custom/config/configFramework.cfm:<br />
<pre>&lt;cfset variables.framework.hibachi.errorNotifyEmailAddresses = "admin1@mysite.com,admin2@mysite.com" /&gt;</pre>
		
<cfabort />
