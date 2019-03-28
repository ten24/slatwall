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
																			
	This is an email template designed to be used to customize the emails	
	that slatwall sends.  If you would like to customize this template, it	
	should first be coppied into the /custom/templates/ directory in the	
	same folder path naming convention that it currently resides inside.	
																			
	All email templates have 2 objects that are passed in (seen below):		
																			
	email: This is the actually email entity that will have things like a	
	to, from, ext... that will eventually be persisted to the database as	
	a log of this e-mail so long as the "Log Email" setting is set to true	
																			
	emailData: This is a structure used to set values that will get			
	populated into the email entity once this processing is complete.		
	Typically you will want to set emailData.htmlBody & emailData.textBody	
	however, you can also set any of the other properties as well.  If you	
	do not set emailData.htmlBody, then the output of this include will be 	
	used as the htmlBody, and no textBody will be set.						
	It will also be used as a final stringReplace() struct for any ${} keys	
	that have not already been relpaced.  Another key field that you can	
	set in the emailData is voidSend=true which will cancel the sending of	
	this e-mail.															
																			
	Lastly, the base object that is being used for this email should also	
	be injected into the template and paramed at the top.					
																			
--->
<cfparam name="email" type="any" />	
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="account" type="any" />

<cfsilent>
	<cfset resetLink = "http://" />
	<cfset resetLink &= CGI.HTTP_HOST /> <!--- This adds the current domain name --->
	<cfset resetLink &= CGI.SCRIPT_NAME /> <!--- This adds the script name which includes the sub-directories that a site is in --->
	<cfif CGI.SCRIPT_NAME NEQ CGI.PATH_INFO> <!--- In IIS PATH_INFO is the same as SCRIPT_NAME by default where in Apache it is blank --->
		<cfset resetLink &= CGI.PATH_INFO /> <!--- This adds the current path information, basically what page you are on --->
	</cfif>
	<cfset resetLink &= "?swprid=#account.getPasswordResetID()#" /> <!--- This is what tells the page to execute a password reset --->
</cfsilent>

<cfsavecontent variable="emailData.emailBodyHTML">
	<cfoutput>
	<cfinclude template="../inc/header.cfm" />
	
	<!-- jumbotron_light_icon -->
	<table class="email_table" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
	 <tbody>
		 <tr>
			 <td class="email_body tc" style="box-sizing: border-box;vertical-align: top;line-height: 100%;text-align: center;padding-left: 16px;padding-right: 16px;background-color: #colorBackground#;font-size: 0 !important;">
				 <!--[if (mso)|(IE)]><table width="632" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:632px;Margin:0 auto;"><tbody><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
				 <div class="email_container" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 632px;margin: 0 auto;text-align: center;line-height: inherit;min-width: 0 !important;">
					 <table class="content_section" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
						 <tbody>
							 <tr>
								 <td class="content_cell light_b" style="box-sizing: border-box;vertical-align: top;width: 100%;background-color: #colorContainerAccent#;font-size: 0;text-align: center;padding-left: 16px;padding-right: 16px;line-height: inherit;min-width: 0 !important;">
									 <!-- col-6 -->
									 <div class="email_row" style="box-sizing: border-box;font-size: 0;display: block;width: 100%;vertical-align: top;margin: 0 auto;text-align: center;clear: both;line-height: inherit;min-width: 0 !important;max-width: 600px !important;">
									 <!--[if (mso)|(IE)]><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:600px;Margin:0 auto 0 0;"><tbody><tr><td width="600" style="width:600px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
										 <div class="col_6" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 600px;line-height: inherit;min-width: 0 !important;">
											 <table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
												 <tbody>
													 <tr>
														 <td class="column_cell px pte tc" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 32px;padding-bottom: 16px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: center;padding-left: 16px;padding-right: 16px;">
															 <table class="ic_h" align="center" width="64" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;display: table;margin-left: auto;margin-right: auto;width: 64px;">
																 <tbody>
																	 <tr>
																		 <td class="default_b" style="box-sizing: border-box;vertical-align: middle;background-color: #colorBackground#;line-height: 100%;font-family: Helvetica, Arial, sans-serif;text-align: center;mso-line-height-rule: exactly;padding: 16px;border-radius: 80px;">
																			 <p class="imgr mb_0" style="font-family: Helvetica, Arial, sans-serif;font-size: 0;line-height: 100%;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 0;clear: both;"><img src="/assets/images/unlocked.png" width="32" height="32" alt="" style="outline: none;border: 0;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;line-height: 100%;max-width: 32px;width: 100% !important;height: auto !important;display: block;margin-left: auto;margin-right: auto;"></p>
																		 </td>
																	 </tr>
																 </tbody>
															 </table>
															 
															 <!------- HEADER COPY ------->
															 <h1 class="mb_xxs" style="color: #colorHeaderText#;margin-left: 0;margin-right: 0;margin-top: 20px;margin-bottom: 16px;padding: 0;font-weight: bold;font-size: 32px;line-height: 42px;">Forgot Password</h1>
														 </td>
													 </tr>
												 </tbody>
											 </table>
										 </div>
									 <!--[if (mso)|(IE)]></td></tr></tbody></table><![endif]-->
									 </div>
								 </td>
							 </tr>
						 </tbody>
					 </table>
				 </div>
				 <!--[if (mso)|(IE)]></td></tr></tbody></table><![endif]-->
			 </td>
		 </tr>
	 </tbody>
	</table>

	<!-- content_center -->
	<table class="email_table" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
		<tbody>
			<tr>
				<td class="email_body tc" style="box-sizing: border-box;vertical-align: top;line-height: 100%;text-align: center;padding-left: 16px;padding-right: 16px;background-color: #colorBackground#;font-size: 0 !important;">
					<!--[if (mso)|(IE)]><table width="632" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:632px;Margin:0 auto;"><tbody><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
					<div class="email_container" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 632px;margin: 0 auto;text-align: center;line-height: inherit;min-width: 0 !important;">
						<table class="content_section" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
							<tbody>
								<tr>
									<td class="content_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;background-color: #colorContainer#;font-size: 0;text-align: center; padding: 20px 15px 45px; line-height: inherit;min-width: 0 !important;">
										<!-- col-6 -->
										<div class="email_row tl" style="box-sizing: border-box;font-size: 0;display: block;width: 100%;vertical-align: top;margin: 0 auto;text-align: left;clear: both;line-height: inherit;min-width: 0 !important;max-width: 600px !important;">
										<!--[if (mso)|(IE)]><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:600px;Margin:0 auto 0 0;"><tbody><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
											<div class="col_6" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 600px;line-height: inherit;min-width: 0 !important;">
												<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
													<tbody>
														<tr>
															<td class="column_cell px tc" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 16px;padding-bottom: 16px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: center;padding-left: 16px;padding-right: 16px;">
																
																<!------- BODY COPY ------->
																<p style="font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 16px;">Please reset your password by clicking this link where you will be prompted to enter a new password.</p>
															</td>
														</tr>
													</tbody>
												</table>
												<table class="ebtn" align="center" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;display: table;margin-left: auto;margin-right: auto;">
													<tbody>
														<tr>
															
															<!------- RESET PASSWORD LINK ------->
															<td class="active_b" style="box-sizing: border-box;vertical-align: top;background-color: #colorAccent#;line-height: 20px;font-family: Helvetica, Arial, sans-serif;mso-line-height-rule: exactly;border-radius: 4px;text-align: center;font-weight: bold;font-size: 17px;padding: 13px 22px;"><a href="#resetLink#" style="text-decoration: none;line-height: inherit;color: #colorContainer#;"><span style="text-decoration: none;line-height: inherit;color: #colorContainer#;">Reset password</span></a></td>
														</tr>
													</tbody>
												</table>
											</div>
										<!--[if (mso)|(IE)]></td></tr></tbody></table><![endif]-->
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<!--[if (mso)|(IE)]></td></tr></tbody></table><![endif]-->
				</td>
			</tr>
		</tbody>
	</table>

	
	<cfinclude template="../inc/footer.cfm" />
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="emailData.emailBodyText">
	
	<!-- PLAIN TEXT VERSION -->
	<cfoutput>
		Forgot Password
		
		Please reset your password by clicking this link where you will be prompted to enter a new password.
		
		#resetLink#
	</cfoutput>
	
</cfsavecontent>

