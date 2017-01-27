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
<cfcomponent extends="HibachiService" persistent="false" accessors="true" output="false">

	<cfproperty name="templateService" />
	<cfproperty name="hibachiUtilityService" />

	<!--- ===================== START: Logical Methods =========================== --->

	<cffunction name="sendEmail" returntype="void" access="public">
		<cfargument name="email" type="any" required="true" />

		<!--- Send Multipart E-mail --->
		<cfif len(arguments.email.getEmailBodyHTML()) && len(arguments.email.getEmailBodyText()) && len(arguments.email.getEmailTo())>
			<cfmail to="#arguments.email.getEmailTo()#"
				from="#arguments.email.getEmailFrom()#"
				subject="#arguments.email.getEmailSubject()#"
				cc="#arguments.email.getEmailCC()#"
				bcc="#arguments.email.getEmailBCC()#"
				charset="utf-8">
				<cfif !isNull(arguments.email.getRelatedObject())>
					<cfmailparam name="Related-Object" value="#arguments.email.getRelatedObject()#">
					<cfmailparam name="Related-Object-ID" value="#arguments.email.getRelatedObjectID()#">
				</cfif>
				<cfif !isNull(arguments.email.getEmailReplyTo())>
					<cfmailparam name="Reply-To" value="#arguments.email.getEmailReplyTo()#">
				</cfif>
				<cfif !isNull(arguments.email.getEmailFailTo())>
					<cfmailparam name="Return-Path" value="#arguments.email.getEmailFailTo()#">
				</cfif>
				<cfmailpart type="text/plain">
					<cfoutput>#arguments.email.getEmailBodyText()#</cfoutput>
				</cfmailpart>
				<cfmailpart type="text/html">
					<cfoutput>#arguments.email.getEmailBodyHTML()#</cfoutput>
				</cfmailpart>
			</cfmail>
		<!--- Send HTML Only E-mail --->
		<cfelseif len(arguments.email.getEmailBodyHTML()) && len(arguments.email.getEmailTo())>
			<cfmail to="#arguments.email.getEmailTo()#"
				from="#arguments.email.getEmailFrom()#"
				subject="#arguments.email.getEmailSubject()#"
				cc="#arguments.email.getEmailCC()#"
				bcc="#arguments.email.getEmailBCC()#"
				charset="utf-8"
				type="text/html">
				<cfif !isNull(arguments.email.getEmailFailTo())>
					<cfmailparam name="Return-Path" value="#arguments.email.getEmailFailTo()#">
				</cfif>
				<cfif !isNull(arguments.email.getRelatedObject())>
					<cfmailparam name="Related-Object" value="#arguments.email.getRelatedObject()#">
					<cfmailparam name="Related-Object-ID" value="#arguments.email.getRelatedObjectID()#">
				</cfif>
				<cfif !isNull(arguments.email.getEmailReplyTo())>
					<cfmailparam name="Reply-To" value="#arguments.email.getEmailReplyTo()#">
				</cfif>
				<cfoutput>#arguments.email.getEmailBodyHTML()#</cfoutput>
			</cfmail>
		<!--- Send Text Only E-mail --->
		<cfelseif len(arguments.email.getEmailBodyText()) && len(arguments.email.getEmailTo())>
			<cfmail to="#arguments.email.getEmailTo()#"
				from="#arguments.email.getEmailFrom()#"
				subject="#arguments.email.getEmailSubject()#"
				cc="#arguments.email.getEmailCC()#"
				bcc="#arguments.email.getEmailBCC()#"
				charset="utf-8"
				type="text/plain">
				<cfif !isNull(arguments.email.getEmailFailTo())>
					<cfmailparam name="Return-Path" value="#arguments.email.getEmailFailTo()#">
				</cfif>
				<cfif !isNull(arguments.email.getRelatedObject())>
					<cfmailparam name="Related-Object" value="#arguments.email.getRelatedObject()#">
					<cfmailparam name="Related-Object-ID" value="#arguments.email.getRelatedObjectID()#">
				</cfif>
				<cfif !isNull(arguments.email.getEmailReplyTo())>
					<cfmailparam name="Reply-To" value="#arguments.email.getEmailReplyTo()#">
				</cfif>
				<cfoutput>#arguments.email.getEmailBodyText()#</cfoutput>
			</cfmail>
		</cfif>

		<!--- If the email is set to be saved, then we persist to the DB --->
		<cfif arguments.email.getLogEmailFlag()>
			<cfset getHibachiDAO().save(arguments.email) />
		</cfif>
	</cffunction>

	<cffunction name="sendEmailQueue" returntype="void" access="public">
		<cfset var email = "" />
		<!--- Loop over the queue --->
		<cfloop array="#getHibachiScope().getEmailQueue()#" index="local.email">

			<!--- Send the email --->
			<cfset sendEmail(email) />
		</cfloop>

		<!--- Clear out the queue --->
		<cfset getHibachiScope().setEmailQueue( [] ) />
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

	<cfscript>

	public any function getEmailTemplateOptions(required emailTemplateObject){
		var sl = this.getEmailTemplateSmartList();

		sl.addFilter('emailTemplateObject', arguments.emailTemplateObject);
		sl.addSelect('emailTemplateName', 'name');
		sl.addSelect('emailTemplateID', 'value');

		return sl.getRecords();
	}

	public any function generateAndSendFromEntityAndEmailTemplate( required any entity, required any emailTemplate ) {
		var email = this.newEmail();
		arguments[arguments.entity.getClassName()] = arguments.entity;
		email = this.processEmail(email, arguments, 'createFromTemplate');
		email = this.processEmail(email, 'addToQueue');
		return email;
	}

	public void function generateAndSendFromEntityAndEmailTemplateID( required any entity, required any emailTemplateID ) {
		var email = this.newEmail();
		var emailData = {
			emailTemplateID = arguments.emailTemplateID
		};
		emailData[ arguments.entity.getPrimaryIDPropertyName() ] = arguments.entity.getPrimaryIDValue();
		email = this.processEmail(email, emailData, 'createFromTemplate');
		email = this.processEmail(email, {}, 'addToQueue');
	}

	</cfscript>

	<!--- =====================  END: Logical Methods ============================ --->

	<!--- ===================== START: DAO Passthrough =========================== --->

	<!--- ===================== START: DAO Passthrough =========================== --->

	<!--- ===================== START: Process Methods =========================== --->

	<cfscript>

	public any function processEmail_createFromTemplate(required any email, required struct data) {

		if(structKeyExists(arguments.data, "emailTemplate") && isObject(arguments.data.emailTemplate)) {
			var emailTemplate = arguments.data.emailTemplate;
		} else if(structKeyExists(arguments.data, "emailTemplateID")) {
			var emailTemplate = getTemplateService().getEmailTemplate( arguments.data.emailTemplateID );
		}

		if(!isNull(emailTemplate)) {
			var templateObjectIDProperty = getPrimaryIDPropertyNameByEntityName(emailTemplate.getEmailTemplateObject());
			var templateObject = javaCast('null','');

			if(structKeyExists(arguments.data, emailTemplate.getEmailTemplateObject()) && isObject(arguments.data[emailTemplate.getEmailTemplateObject()])) {
				// Set the template object from the passed object
				var templateObject = arguments.data[ emailTemplate.getEmailTemplateObject() ];

			} else if(structKeyExists(arguments.data, templateObjectIDProperty)) {
				// Set the template object from the passed ID
				var templateObject = getServiceByEntityName( emailTemplate.getEmailTemplateObject() ).invokeMethod("get#emailTemplate.getEmailTemplateObject()#", {1=arguments.data[ templateObjectIDProperty ]});
			}

			if(!isNull(templateObject) && isObject(templateObject) && structKeyExists(templateObject, "stringReplace")) {

				// Setup the email values
				arguments.email.setEmailTo( templateObject.stringReplace( emailTemplate.setting('emailToAddress'), false, true ) );
				arguments.email.setEmailFrom( templateObject.stringReplace( emailTemplate.setting('emailFromAddress'), false, true ) );
				arguments.email.setEmailCC( templateObject.stringReplace( emailTemplate.setting('emailCCAddress'), false, true ) );
				arguments.email.setEmailBCC( templateObject.stringReplace( emailTemplate.setting('emailBCCAddress'), false, true ) );
				arguments.email.setEmailReplyTo( templateObject.stringReplace( emailTemplate.setting('emailReplyToAddress'), false, true ) );
				arguments.email.setEmailFailTo( templateObject.stringReplace( emailTemplate.setting('emailFailToAddress'), false, true ) );
				arguments.email.setEmailSubject( templateObject.stringReplace( emailTemplate.setting('emailSubject'), true, true ) );
				arguments.email.setEmailBodyHTML( templateObject.stringReplace( emailTemplate.getEmailBodyHTML(),true ) );
				arguments.email.setEmailBodyText( templateObject.stringReplace( emailTemplate.getEmailBodyText(),true ) );


				var templateFileResponse = "";
				var templatePath = getTemplateService().getTemplateFileIncludePath(templateType="email", objectName=emailTemplate.getEmailTemplateObject(), fileName=emailTemplate.getEmailTemplateFile());

				local.email = arguments.email;
				local[ emailTemplate.getEmailTemplateObject() ] = templateObject;
				local.emailData["relatedObject"] = mid(templateObject.getEntityName(), 9, len(templateObject.getEntityName())-8);
				local.emailData["relatedObjectID"] = templateObject.getPrimaryIDValue();

				if(len(templatePath)) {
					savecontent variable="templateFileResponse" {
						include '#templatePath#';
					}
				}

				if(len(templateFileResponse) && !structKeyExists(local.emailData, "emailBodyHTML")) {
					local.emailData.emailBodyHTML = templateFileResponse;
				}

				arguments.email.populate( local.emailData );

				// Do a second string replace for any additional keys added to emailData
				arguments.email.setEmailTo( getHibachiUtilityService().replaceStringTemplate(template=arguments.email.getEmailTo(), object=emailData) );
				arguments.email.setEmailFrom( getHibachiUtilityService().replaceStringTemplate(template=arguments.email.getEmailFrom(), object=emailData) );
				arguments.email.setEmailCC( getHibachiUtilityService().replaceStringTemplate(template=arguments.email.getEmailCC(), object=emailData) );
				arguments.email.setEmailBCC( getHibachiUtilityService().replaceStringTemplate(template=arguments.email.getEmailBCC(), object=emailData) );
				arguments.email.setEmailReplyTo( getHibachiUtilityService().replaceStringTemplate(template=arguments.email.getEmailReplyTo(), object=emailData) );
				arguments.email.setEmailFailTo( getHibachiUtilityService().replaceStringTemplate(template=arguments.email.getEmailFailTo(), object=emailData) );
				arguments.email.setEmailSubject( getHibachiUtilityService().replaceStringTemplate(template=arguments.email.getEmailSubject(), object=emailData, formatValues=true) );
				arguments.email.setEmailBodyHTML( getHibachiUtilityService().replaceStringTemplate(template=arguments.email.getEmailBodyHTML(), object=emailData, formatValues=true) );
				arguments.email.setEmailBodyText( getHibachiUtilityService().replaceStringTemplate(template=arguments.email.getEmailBodyText(), object=emailData, formatValues=true) );

				arguments.email.setLogEmailFlag( emailTemplate.getLogEmailFlag() );
			}

		}

		return arguments.email;
	}

	public any function processEmail_addToQueue(required any email, required struct data) {
		// Populate the email with any data that came in
		arguments.email.populate( arguments.data );

		// Make sure that the email isn't voided, and that it has a To, CC, or BCC, as well as a subject
		if( ( !isBoolean(arguments.email.getVoidSendFlag()) || !arguments.email.getVoidSendFlag() )
			&&
			(
				(!isNull(arguments.email.getEmailTo()) && len(arguments.email.getEmailTo()))
			  ||
			  	(!isNull(arguments.email.getEmailCC()) && len(arguments.email.getEmailCC()))
			  ||
			  	(!isNull(arguments.email.getEmailBCC()) && len(arguments.email.getEmailBCC()))
			)
			&&
			!isNull(arguments.email.getEmailSubject())
			&&
			len(arguments.email.getEmailSubject())
		) {
			// Append the email to the email queue
			arrayAppend(getHibachiScope().getEmailQueue(), arguments.email);
		}

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
