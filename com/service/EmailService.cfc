<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfcomponent extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false">
	
	<cffunction name="sendEmailByEvent">
		<cfargument name="eventName" type="string" required="true" />
		<cfargument name="entity" type="any" required="true" />
		
		<cfset logSlatwall("Email sending event triggered. eventName: #arguments.eventName#, entityName: #arguments.entity.getEntityName()#, entityID: #arguments.entity.getPrimaryIDValue()#") />
		
		<cfset emailsToSend = this.listEmail({eventName=arguments.eventName}) />
		
		<cfset var email = "" />
		
		<cfloop array="#emailsToSend#" index="email">
			<cfset sendEmail(email, arguments.entity) />
		</cfloop>
	</cffunction>

	<cffunction name="sendEmail" access="public" returntype="void" output="false">
		<cfargument name="email" type="any" required="true" />
		<cfargument name="entity" type="any" required="true" />
		
		<cfset logSlatwall("Send email triggerd for emailID: #arguments.email.getEmailID()#") />
		
		<!--- Setup Scope so that it can be used by includes --->
		<cfset var $ = request.context.$ />
		<cfset var siteID = "default" />
		<cfset var themeName = "" />
		<cfif structKeyExists($,"siteConfig")>
			<cfset themeName = $.siteConfig('theme') />
		</cfif>
		
		<!--- Figure out the siteID: This needs to get changed --->
		<cfif structKeyExists($,"event")>
			<cfset var siteID = $.event('siteid') />
		<cfelseif structKeyExists(session,"site")>
			<cfset var siteID = session.siteid />
		</cfif>
		
		<!--- Setup the object in a local variable --->
		<cfset local[ replace(arguments.entity.getEntityName(),"Slatwall","") ] = arguments.entity />
		
		<!--- Setup the HTML body --->
		<cfset var htmlBody = arguments.email.getEmailTemplate().getEmailBodyHTML() />
		<cfset var includesToReplace = reMatch("\$\{include:email.[a-z|A-Z|0-9]*\}", htmlBody) />
		<cfset var inc = "" />
		
		<cfloop array="#includesToReplace#" index="inc">
			<cfset var fileName = mid(inc, 17, len(inc) - 17) />
			<cfset var themeFileInclude = "#application.configBean.getContext()#/#siteID#/includes/themes/#themeName#/display_objects/custom/slatwall/email/#fileName#.cfm" />
			<cfset var siteFileInclude = "#application.configBean.getContext()#/#siteID#/includes/display_objects/custom/slatwall/email/#fileName#.cfm" />
			<cfset var includeContent = "" />
			<cfif fileExists( expandPath(themeFileInclude) )>
				<cfsavecontent variable="includeContent">
					<cfinclude template="#themeFileInclude#" />
				</cfsavecontent>
			<cfelseif fileExists( expandPath(siteFileInclude) )>
				<cfsavecontent variable="includeContent">
					<cfinclude template="#siteFileInclude#" />
				</cfsavecontent>
			</cfif>
			<cfset htmlBody = replaceNoCase(htmlBody, inc, includeContent) />
		</cfloop>
		
		<!--- Setup the Text Body --->
		<cfset var textBody = arguments.email.getEmailTemplate().getEmailBodyText() />
		<cfset var includesToReplace = reMatch("\$\{include:email.[a-z|A-Z|0-9|\_]*\}", textBody) />
		<cfset var inc = "" />
		<cfloop array="#includesToReplace#" index="inc">
			<cfset var fileName = mid(inc, 17, len(inc) - 17) />
			<cfset var themeFileInclude = "#application.configBean.getContext()#/#siteID#/includes/themes/#themeName#/display_objects/custom/slatwall/email/#fileName#.cfm" />
			<cfset var siteFileInclude = "#application.configBean.getContext()#/#siteID#/includes/display_objects/custom/slatwall/email/#fileName#.cfm" />
			<cfset var includeContent = "" />
			<cfif fileExists( expandPath(themeFileInclude) )>
				<cfsavecontent variable="includeContent">
					<cfinclude template="#themeFileInclude#" />
				</cfsavecontent>
			<cfelseif fileExists( expandPath(siteFileInclude) )>
				<cfsavecontent variable="includeContent">
					<cfinclude template="#siteFileInclude#" />
				</cfsavecontent>
			</cfif>
			<cfset textBody = replaceNoCase(textBody, inc, includeContent) />
		</cfloop>
			
		<cftry>
			<!--- Send the actual E-mail --->
			<cfmail to="#arguments.entity.stringReplace(email.setting('emailToAddress'))#"
					from="#arguments.entity.stringReplace(email.setting('emailFromAddress'))#"
					subject="#arguments.entity.stringReplace(email.setting('emailSubject'))#"
					cc="#arguments.entity.stringReplace(email.setting('emailCCAddress'))#"
					bcc="#arguments.entity.stringReplace(email.setting('emailBCCAddress'))#">
				<cfmailpart type="text/plain">
					#arguments.entity.stringReplace(textBody, true)#
				</cfmailpart>
				<cfmailpart type="text/html">
					#arguments.entity.stringReplace(htmlBody, true)#
				</cfmailpart>
			</cfmail>
			
			<cfset logSlatwall("Email Sent to SMTP Server") />
			
			<cfcatch>
				<cfset logSlatwall("There was an unexpected error while attempting to send this email") />
				<cfset logSlatwallException(cfcatch) />
			</cfcatch>
			
		</cftry>
	</cffunction>
	
		
	<!--- ===================== START: Logical Methods =========================== --->
	
	<!--- =====================  END: Logical Methods ============================ --->
	
	<!--- ===================== START: DAO Passthrough =========================== --->
	
	<!--- ===================== START: DAO Passthrough =========================== --->
	
	<!--- ===================== START: Process Methods =========================== --->
	
	<!--- =====================  END: Process Methods ============================ --->
	
	<!--- ====================== START: Save Overrides =========================== --->
	
	<!--- ======================  END: Save Overrides ============================ --->
	
	<!--- ==================== START: Smart List Overrides ======================= --->
	
	<!--- ====================  END: Smart List Overrides ======================== --->
	
	<!--- ====================== START: Get Overrides ============================ --->
	
	<!--- ======================  END: Get Overrides ============================= --->
	
</cfcomponent>
