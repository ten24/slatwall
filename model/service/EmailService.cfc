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
<cfcomponent extends="HibachiService" persistent="false" accessors="true" output="false">
	
	<cfproperty name="templateService" />
	
		
	<!--- ===================== START: Logical Methods =========================== --->
		
	<cffunction name="sendEmail" returntype="void" access="public">
		<cfargument name="email" type="any" required="true" />
		
		<!--- Send the actual E-mail --->
		<cfmail to="#arguments.email.getEmailTo()#"
				from="#arguments.email.getEmailFrom()#"
				subject="#arguments.email.getEmailSubject()#"
				cc="#arguments.email.getEmailCC()#"
				bcc="#arguments.email.getEmailBCC()#"
				charset="utf-8">
			
			<!--- If a Text Body exists --->
			<cfif len(arguments.email.getEmailBodyText())>
				<cfmailpart type="text/plain">
					#arguments.email.getEmailBodyText()#
				</cfmailpart>
			</cfif>
			
			<cfmailpart type="text/html">
				<html>
					<body>#arguments.email.getEmailBodyHTML()#</body>
				</html>
			</cfmailpart>
		</cfmail>
		
		<!--- If the email is set to be saved, then we persist to the DB --->
		<cfif(arguments.email.getLogEmailFlag()) >
			<cfset getHibachiDAO().save(arguments.email) />
		</cfif>
	</cffunction>
		
	<cffunction name="sendEmailQueue" returntype="void" access="public">
		<cfset var email = "" />
		<cfloop array="#getHibachiScope().getEmailQueue()#" index="email">
			<cfset sendEmail(email) />
		</cfloop>
	</cffunction>
		
	<cffunction name="getEmailTemplateFileOptions" output="false" access="public">
		<cfargument name="object" type="string" required="true" />
		
		<cfset var dir = "" />
		<cfset var fileOptions = [] />
		
		<cfif directoryExists("#getApplicationValue('applicationRootMappingPath')#/templates/email/#arguments.object#")>
			<cfdirectory action="list" directory="#getApplicationValue('applicationRootMappingPath')#/templates/email/#arguments.object#" name="dir" />
			<cfloop query="dir">
				<cfif listLast(dir.name, '.') eq 'cfm'>
					<cfset arrayAppend(fileOptions, dir.name) />
				</cfif>
			</cfloop>
		</cfif>
		<cfif directoryExists("#getApplicationValue('applicationRootMappingPath')#/custom/templates/email/#arguments.object#")>
			<cfdirectory action="list" directory="#getApplicationValue('applicationRootMappingPath')#/custom/templates/email/#arguments.object#" name="dir" />
			<cfloop query="dir">
				<cfif listLast(dir.name, '.') eq 'cfm' and !arrayFind(fileOptions, dir.name)>
					<cfset arrayAppend(fileOptions, dir.name) />
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn fileOptions />
	</cffunction>
	
	<cffunction name="getEmailTemplateOptions" access="public" returntype="array">
		<cfargument name="emailTemplateObject" type="string" required="true">
		
		<cfset var sl = this.getEmailTemplateSmartList() />
		<cfset sl.addFilter('emailTemplateObject', arguments.emailTemplateObject) />
		<cfset sl.addSelect('emailTemplateName', 'name') />
		<cfset sl.addSelect('emailTemplateID', 'value') />
		
		<cfreturn sl.getRecords() />
	</cffunction>
	
	<!--- =====================  END: Logical Methods ============================ --->
	
	<!--- ===================== START: DAO Passthrough =========================== --->
	
	<!--- ===================== START: DAO Passthrough =========================== --->
	
	<!--- ===================== START: Process Methods =========================== --->
	
	<cfscript>
	
	public any function processEmail_createFromTemplate(required any email, required struct data) {
		
		if(structKeyExists(arguments.data, "emailTemplateID")) {
			var emailTemplate = getTemplateService().getEmailTemplate( arguments.data.emailTemplateID );
			
			if(!isNull(emailTemplate)) {
				var templateObjectIDProperty = getPrimaryIDPropertyNameByEntityName(emailTemplate.getEmailTemplateObject());
						
				if(structKeyExists(arguments.data, templateObjectIDProperty)) {
					
					var templateObject = getServiceByEntityName( emailTemplate.getEmailTemplateObject() ).invokeMethod("get#emailTemplate.getEmailTemplateObject()#", {1=arguments.data[ templateObjectIDProperty ]});
					
					if(!isNull(templateObject)) {
						
						// Setup the email values
						arguments.email.setEmailTo( templateObject.stringReplace( emailTemplate.setting('emailToAddress') ) );
						arguments.email.setEmailFrom( templateObject.stringReplace( emailTemplate.setting('emailFromAddress') ) );
						arguments.email.setEmailCC( templateObject.stringReplace( emailTemplate.setting('emailCCAddress') ) );
						arguments.email.setEmailBCC( templateObject.stringReplace( emailTemplate.setting('emailBCCAddress') ) );
						arguments.email.setEmailSubject( templateObject.stringReplace( emailTemplate.setting('emailSubject') ) );
						arguments.email.setEmailBodyHTML( templateObject.stringReplace( emailTemplate.getEmailBodyHTML() ) );
						arguments.email.setEmailBodyText( templateObject.stringReplace( emailTemplate.getEmailBodyText() ) );
						
						var templateFileResponse = "";
						var templatePath = getTemplateService().getTemplateFileIncludePath(templateType="email", objectName=emailTemplate.getEmailTemplateObject(), fileName=emailTemplate.getEmailTemplateFile());
						
						local.email = arguments.email;
						local.emailData = {};
						local[ emailTemplate.getEmailTemplateObject() ] = templateObject;
						
						if(len(templatePath)) {
							savecontent variable="templateFileResponse" {
								include '#templatePath#';
							}
						}
						
						if(len(templateFileResponse) && !structKeyExists(local.emailData, "bodyHTML")) {
							local.emailData.bodyHTML = templateFileResponse;
						}
						
						arguments.email.populate( local.emailData );
					}
					
					// Take all the Settings & String Replace on them (to, from, cc, bcc, subject, bodyHTML, bodyText)
				}
			}
		}
		
		return arguments.email;
	}
	
	public any function processEmail_addToQueue(required any email, required struct data) {
		// Populate the email with any data that came in
		arguments.email.populate( arguments.data );
		
		// Append the email to the email queue
		arrayAppend(getHibachiScope().getEmailQueue(), arguments.email);
		
		return arguments.email;
	}
		
	</cfscript>
	
	<!--- =====================  END: Process Methods ============================ --->
	
	<!--- ====================== START: Save Overrides =========================== --->
	
	<!--- ======================  END: Save Overrides ============================ --->
	
	<!--- ==================== START: Smart List Overrides ======================= --->
	
	<!--- ====================  END: Smart List Overrides ======================== --->
	
	<!--- ====================== START: Get Overrides ============================ --->
	
	<!--- ======================  END: Get Overrides ============================= --->
	
</cfcomponent>
