/*

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

*/
<cfcomponent displayname="EmailBounceService" output="false" accessors="true" extends="HibachiService">

	<cffunction name="processBouncedEmails" access="public" returntype="void" output="false">

		<cfscript>
			var mailServer = getService("SettingService").getSettingValue("emailPOPServer");
			var mailServerPort = getService("SettingService").getSettingValue("emailPOPServerPort");
			var mailServerUsername = getService("SettingService").getSettingValue("emailPOPServerUsername");
			var mailServerPassword = getService("SettingService").getSettingValue("emailPOPServerPassword");
			var useSSL = true;

			var javaSystem = createObject("java", "java.lang.System");
			var javaSystemProps = javaSystem.getProperties();
			if(useSSL){
				javaSystemProps.setProperty("mail.pop3.socketFactory.class","javax.net.ssl.SSLSocketFactory");
				javaSystemProps.setProperty("mail.pop3.socketFactory.fallback","true");
			} else {
				javaSystemProps.setProperty("mail.pop3.socketFactory.class","");
			}
			var allowedFromAddress = "scomp@aol.net|feedback@feedback.comcast.net|feedbackloop@fbl.apps.rackspace.com|feedbackloop@comcastfbl.senderscore.net|feedbackloop@feedback.bluetie.com|feedbackloop@fbl.usa.net|feedbackloop@fbl.hostedemail.com|feedbackloop@fbl.cox.net|do-not-reply@junkemailfilter.com|feedbackloop@feedback.postmaster.rr.com";
			var allowedSubjects = "";
			var report = "";
			var deleteMsgIds = "";
		</cfscript>

		<cfpop name="local.emails" action="getAll" server="#mailServer#" port="#mailServerPort#" username="#mailServerUsername#" password="#mailServerPassword#" generateuniquefilenames="true" attachmentpath="#attachmentPath#"  />

		<cfscript>

			var fromAddress = "";
			var emailSubject = "";
			var emailBody = "";
			var unsubscribeLinkArray = [];
			var unsubscribeLink = "";
			var unsubscribeResult = "";
			var isAllowedFromAddress = false;
			var isAllowedSubject = false;
			var listOwnerInfo = getListOwnerInfoService().getListOwnerInfo();

			for(var i=1; i <= emails.recordcount; i++){

				fromAddress = emails.from[i];
				emailSubject = emails.subject[i];
				report &= "From: " & fromAddress & " Subject: " & emailSubject & "<br>";
				isAllowedFromAddress = ReFindNoCase(allowedFromAddress,fromAddress);
				isAllowedSubject = ReFindNoCase(allowedSubjects,emailSubject);
				if(isAllowedFromAddress && isAllowedSubject){
					emailBody = emails.body[i];

					// read all the attachments as well
					if(trim(emails.attachmentfiles[i]) NEQ ""){
						var attachmentArray = listToArray(emails.attachmentfiles[i],"#chr(9)#") ;
						var attachmentFile = "";
						for(attachmentFile in attachmentArray){
							try{
								emailBody &= fileread(attachmentFile);
							}
							catch(Any e){
								//WriteOutput("Error: " & e.message);
							}
						}
					}

				} else {
					report &= "Status: Not processed [From Allowed: #isAllowedFromAddress#, Subject Allowed: #isAllowedSubject#]" & "<br>";
				}
				report &= "<br>";

				//create a bounced email record
			}

			writeoutput(report);

		</cfscript>

		<cfpop action="delete" uid="#deleteMsgIds#" server="#mailServer#" port="#mailServerPort#" username="#mailServerUsername#" password="#mailServerPassword#" />
		<cfmail from="" to="" subject="" type="html">#report#</cfmail>
		<cfabort/>
	</cffunction>

</cfcomponent>