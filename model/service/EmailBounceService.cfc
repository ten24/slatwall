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
<cfcomponent output="false" accessors="true" extends="HibachiService">

	<cfproperty name="orderService" />


	<cfscript>
		public void function processBouncedEmails(){
			var mailServer = getService("SettingService").getSettingValue("emailIMAPServer");
			var mailServerPort = getService("SettingService").getSettingValue("emailIMAPServerPort");
			var mailServerUsername = getService("SettingService").getSettingValue("emailIMAPServerUsername");
			var mailServerPassword = getService("SettingService").getSettingValue("emailIMAPServerPassword");
			var useSSL = true;
			var giftCardBounce = false;

			var javaSystem = createObject("java", "java.lang.System");
			var javaSystemProps = javaSystem.getProperties();
			if(useSSL){
				javaSystemProps.setProperty("mail.pop3.socketFactory.class","javax.net.ssl.SSLSocketFactory");
				javaSystemProps.setProperty("mail.pop3.socketFactory.fallback","true");
			} else {
				javaSystemProps.setProperty("mail.pop3.socketFactory.class","");
			}
			var report = "";
			var deleteMsgIds = "";

			var imapAttributes = StructNew();
			imapAttributes.name = "local.emails";
			imapAttributes.action = "getAll";
			imapAttributes.server = mailServer;
			imapAttributes.port = mailServerPort;
			imapAttributes.username = mailServerUsername;
			imapAttributes.password = mailServerPassword;
			imapAttributes.generateuniquefilenames = "True";
			imapAttributes.attachmentpath = getTempDirectory();

			if(!structKeyExists(server, "railo") && !structKeyExists(server, "lucee")){
				imapAttributes.secure="true";
			}
			try{
				getService('HibachiTagService').cfimap(argumentCollection=imapAttributes);
			
				var fromAddress = "";
				var emailSubject = "";
				var emailBody = "";
	
				for(var i=1; i <= emails.recordcount; i++){
	
					fromAddress = emails.from[i];
					emailSubject = emails.subject[i];
					report &= "From: " & fromAddress & " Subject: " & emailSubject & "<br>";
	
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
					} else {
						report &= "Status: Not processed [From Allowed: #isAllowedFromAddress#, Subject Allowed: #isAllowedSubject#]" & "<br>";
					}
					report &= "<br>";
	
					//todo create a bounced email record
					var emailHeader = emails.header[i];
					var emailBounce = this.newEmailBounce();
	
					if(getHeaderValue(emailHeader, "Related-Object") NEQ ""){
						emailBounce.setRelatedObject(getHeaderValue(emailHeader, "Related-Object"));
						emailBounce.setRelatedObjectID(getHeaderValue(emailHeader, "Related-Object-ID"));
						giftCardBounce = true;
					} else {
	
						if(FindNoCase("Gift Card Code:", emailBody)){
	
							var startingIndex = FindNoCase("Gift Card Code:", emailBody);
							startingIndex = startingIndex + 16;
	
							var giftCardCode = Mid(emailBody, startingIndex, getService("SettingService").getSettingValue("skuGiftCardCodeLength")+1);
	
							var giftCardID = getDAO("GiftCardDAO").getIDbyCode(giftCardCode);
	
							if(giftCardID NEQ false){
								emailBounce.setRelatedObject("giftCard");
								emailBounce.setRelatedObjectID(giftCardID);
							}
	
							giftCardBounce = true;
						}
					}
	
					if(getHeaderValue(emailHeader, "X-Failed-Recipients") NEQ ""){
						emailBounce.setRejectedEmailTo(getHeaderValue(emailHeader, "X-Failed-Recipients"));
	
						var failedRecipient = true;
					} else {
	
						if(FindNoCase("To:", emailBody)){
	
							var startingIndex = FindNoCase("To:", emailBody);
							startingIndex = startingIndex + 4;
	
							var parsing = true;
							var toEmail = "";
	
							while(Mid(emailBody, startingIndex, 1) NEQ Chr(10)){
								toEmail &= Mid(emailBody, startingIndex, 1);
								startingIndex++;
							}
	
							emailBounce.setRejectedEmailTo(toEmail);
	
							var failedRecipient = true;
	
						}
	
					}
	
					emailBounce.setRejectedEmailFrom(emails.from[i]);
					emailBounce.setRejectedEmailSubject(emails.subject[i]);
					emailBounce.setRejectedEmailSendTime(emails.sentdate[i]);
					emailBounce.setRejectedEmailBody(emailBody);
					emailBounce = this.saveEmailBounce(emailBounce);
	
	
					if(failedRecipient){
						report &= "Failed Recipient: " & emailBounce.getRejectedEmailTo() & " ";
						deleteMsgIds = listAppend(deleteMsgIds,emails.uid[i]);
					}
	
					if(giftCardBounce){
						report &= "Gift Card Bounce " & emailBounce.getRelatedObjectID() & " ";
	
						var giftCard = getGiftCard(emailBounce.getRelatedObjectID());
						var processObject = giftCard.getOrder().getProcessObject("failedGiftRecipient");
						processObject.setGiftCard(giftCard);
						getOrderService().process(giftCard.getOrder(), processObject);
	
					}
	
					if(emailBounce.hasErrors()){
						report &= "Email Bounce Save Errors" &  emailBounce.getErrors() & "<br>";
					} else {
						report &= "Email Bounce Save Success" & "<br>";
					}
				}
			}catch(any e){
				report &="Error Reading Mailbox";
			}

			imap.action="delete";
			imap.uid=deleteMsgIds;
			
			try{
				getService('HibachiTagService').cfimap(argumentCollection=imapAttributes);
			}catch(any e){
				report &= "Error Deleting Mailbox";
			}
			getService('hibachiTagService').cfmail(
				to="#getService("SettingService").getSettingValue("emailToAddress")#",
				from="#getService("SettingService").getSettingValue("emailFromAddress")#",
				subject="Bounced Email Processing Report",
				cc="#getService("SettingService").getSettingValue("emailCCAddress")#",
				bcc="#getService("SettingService").getSettingValue("emailBCCAddress")#",
				body=writeoutput(report),
				charset="utf-8"
			);

		}
	</cfscript>

	<cffunction name="getHeaderValue" access="private" output="false" returntype="string">
		<cfargument name="fullHeader" required="yes" type="string">
		<cfargument name="headerKey" required="yes" type="string">

		<cfset var headerValues = ArrayNew(1)>
		<cfset var currentHeaderValue = "">

		<cfset headerValues = ListToArray(arguments.fullHeader, chr(10))>

		<cfloop from="1" to="#ArrayLen(headerValues)#" index="local.value">
			<cfif Left(headerValues[value], Len(arguments.headerKey)) IS arguments.headerKey>
				<cfset currentHeaderValue = Mid(headerValues[value], Len(arguments.headerKey) + 3, Len(headerValues[value]))>
				<cfbreak>
			</cfif>
		</cfloop>

		<cfreturn currentHeaderValue>
	</cffunction>

</cfcomponent>
