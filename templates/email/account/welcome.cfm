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
<cfscript>
	var accountType = account.getAccountType() ?: 'Retail';
	var emailBody = email.getAttributeValue('body'&accountType);
</cfscript>
<cfsavecontent variable="emailData.emailBodyHTML">
	<cfoutput>
	<cfinclude template="../inc/header.cfm" />
	<cfif accountType == "retail" OR accountType == "customer">
		<style type="text/css">
			body {
				margin: 0;
				padding: 0;
			}
	
			table,
			td,
			tr {
				vertical-align: top;
				border-collapse: collapse;
			}
	
			* {
				line-height: inherit;
			}
	
			a[x-apple-data-detectors=true] {
				color: inherit !important;
				text-decoration: none !important;
			}
		</style>
		<style id="media-query" type="text/css">
			@media (max-width: 620px) {
	
				.block-grid,
				.col {
					min-width: 320px !important;
					max-width: 100% !important;
					display: block !important;
				}
	
				.block-grid {
					width: 100% !important;
				}
	
				.col {
					width: 100% !important;
				}
	
				.col>div {
					margin: 0 auto;
				}
	
				img.fullwidth,
				img.fullwidthOnMobile {
					max-width: 100% !important;
				}
	
				.no-stack .col {
					min-width: 0 !important;
					display: table-cell !important;
				}
	
				.no-stack.two-up .col {
					width: 50% !important;
				}
	
				.no-stack .col.num4 {
					width: 33% !important;
				}
	
				.no-stack .col.num8 {
					width: 66% !important;
				}
	
				.no-stack .col.num4 {
					width: 33% !important;
				}
	
				.no-stack .col.num3 {
					width: 25% !important;
				}
	
				.no-stack .col.num6 {
					width: 50% !important;
				}
	
				.no-stack .col.num9 {
					width: 75% !important;
				}
	
				.video-block {
					max-width: none !important;
				}
	
				.mobile_hide {
					min-height: 0px;
					max-height: 0px;
					max-width: 0px;
					display: none;
					overflow: hidden;
					font-size: 0px;
				}
	
				.desktop_hide {
					display: block !important;
					max-height: none !important;
				}
			}
		</style>
		<body class="clean-body" style="margin: 0; padding: 0; -webkit-text-size-adjust: 100%; background-color: ##F3F3F3;">
			<!--[if IE]>
			<div class="ie-browser">
				<![endif]-->
				<table bgcolor="##F3F3F3" cellpadding="0" cellspacing="0" class="nl-container" role="presentation" style="table-layout: fixed; vertical-align: top; min-width: 320px; Margin: 0 auto; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; background-color: ##F3F3F3; width: 100%;" valign="top" width="100%">
					<tbody>
						<tr style="vertical-align: top;" valign="top">
							<td style="word-break: break-word; vertical-align: top;" valign="top">
								<!--[if (mso)|(IE)]>
								<table width="100%" cellpadding="0" cellspacing="0" border="0">
									<tr>
										<td align="center" style="background-color:##F3F3F3">
											<![endif]-->
											<div style="background-color:transparent;">
												<div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: ##FFFFFF;">
													<div style="border-collapse: collapse;display: table;width: 100%;background-color:##FFFFFF;">
														<!--[if (mso)|(IE)]>
														<table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;">
															<tr>
																<td align="center">
																	<table cellpadding="0" cellspacing="0" border="0" style="width:600px">
																		<tr class="layout-full-width" style="background-color:##FFFFFF">
																			<![endif]-->
																			<!--[if (mso)|(IE)]>
																			<td align="center" width="600" style="background-color:##FFFFFF;width:600px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top">
																				<table width="100%" cellpadding="0" cellspacing="0" border="0">
																					<tr>
																						<td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:0px;">
																							<![endif]-->
																							<div class="col num12" style="min-width: 320px; max-width: 600px; display: table-cell; vertical-align: top; width: 600px;">
																								<div style="width:100% !important;">
																									<!--[if (!mso)&(!IE)]>
																									<!-->
																									<div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:0px; padding-right: 0px; padding-left: 0px;">
																										<!--
																										<![endif]-->
																										<div align="center" class="img-container center fixedwidth" style="padding-right: 0px;padding-left: 0px;">
																											<!--[if mso]>
																											<table width="100%" cellpadding="0" cellspacing="0" border="0">
																												<tr style="line-height:0px">
																													<td style="padding-right: 0px;padding-left: 0px;" align="center">
																														<![endif]-->
																														<div style="font-size:1px;line-height:40px"></div>
																														<img align="center" alt="Image" border="0" class="center fixedwidth" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/059a0b67-3539-40b1-b84e-49b9710b4bb4.png" style="text-decoration: none; -ms-interpolation-mode: bicubic; border: 0; height: auto; width: 100%; max-width: 180px; display: block;" title="Image" width="180"/>
																														<div style="font-size:1px;line-height:40px"></div>
																														<!--[if mso]>
																													</td>
																												</tr>
																											</table>
																											<![endif]-->
																										</div>
																										<table border="0" cellpadding="0" cellspacing="0" class="divider" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;" valign="top" width="100%">
																											<tbody>
																												<tr style="vertical-align: top;" valign="top">
																													<td class="divider_inner" style="word-break: break-word; vertical-align: top; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px;" valign="top">
																														<table align="center" border="0" cellpadding="0" cellspacing="0" class="divider_content" height="0" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; border-top: 2px solid ##f3f3f3; height: 0px;" valign="top" width="100%">
																															<tbody>
																																<tr style="vertical-align: top;" valign="top">
																																	<td height="0" style="word-break: break-word; vertical-align: top; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;" valign="top">
																																		<span></span>
																																	</td>
																																</tr>
																															</tbody>
																														</table>
																													</td>
																												</tr>
																											</tbody>
																										</table>
																										<!--[if mso]>
																										<table width="100%" cellpadding="0" cellspacing="0" border="0">
																											<tr>
																												<td style="padding-right: 45px; padding-left: 45px; padding-top: 45px; padding-bottom: 45px; font-family: Georgia, 'Times New Roman', serif">
																													<![endif]-->
																													<div style="color:##696969;font-family:Georgia, Times, 'Times New Roman', serif;line-height:120%;padding-top:45px;padding-right:45px;padding-bottom:45px;padding-left:45px;">
																														<div style="font-family: Georgia, Times, 'Times New Roman', serif; font-size: 12px; line-height: 14px; color: ##696969;">
																															<p style="font-size: 14px; line-height: 28px; text-align: center; margin: 0;">
																																<span style="font-size: 24px; color: ##000000;">Dear Valued Market Partner
																																
																																</span>
																															</p>
																															<p style="font-size: 14px; line-height: 28px; text-align: center; margin: 0;">
																																<span style="font-size: 24px; color: ##000000;">and VIP customer,</span>
																															</p>
																														</div>
																													</div>
																													<!--[if mso]>
																												</td>
																											</tr>
																										</table>
																										<![endif]-->
																										<!--[if mso]>
																										<table width="100%" cellpadding="0" cellspacing="0" border="0">
																											<tr>
																												<td style="padding-right: 60px; padding-left: 60px; padding-top: 0px; padding-bottom: 60px; font-family: Arial, sans-serif">
																													<![endif]-->
																													<div style="color:##696969;font-family:Arial, 'Helvetica Neue', Helvetica, sans-serif;line-height:120%;padding-top:0px;padding-right:60px;padding-bottom:60px;padding-left:60px;">
																														<div style="font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; font-size: 12px; line-height: 14px; color: ##696969;">
																															<p style="font-size: 14px; line-height: 19px; text-align: left; margin: 0;">
																																<span style="font-size: 16px; color: ##696969;">We are contacting you in regards to your recently shipped order.  An error was made and as a result your order is being returned to our distribution facility.  We apologize greatly for the error.   </span>
																															</p>
																															<p style="font-size: 14px; line-height: 16px; text-align: left; margin: 0;"></p>
																															<p style="font-size: 14px; line-height: 19px; text-align: left; margin: 0;">
																																<span style="font-size: 16px; color: ##696969;">As our way of saying THANK YOU for your patience, we will be including a FREE Replenish Masque in your order.  We anticipate that you will receive your original order which will include your free Replenish Masque within 5 business days.     </span>
																															</p>
																															<p style="font-size: 14px; line-height: 16px; text-align: left; margin: 0;"></p>
																															<p style="font-size: 14px; line-height: 19px; text-align: left; margin: 0;">
																																<span style="font-size: 16px; color: ##696969;">We hope you enjoy it!</span>
																															</p>
																														</div>
																													</div>
																													<!--[if mso]>
																												</td>
																											</tr>
																										</table>
																										<![endif]-->
																										<!--[if (!mso)&(!IE)]>
																										<!-->
																									</div>
																									<!--
																									<![endif]-->
																								</div>
																							</div>
																							<!--[if (mso)|(IE)]>
																						</td>
																					</tr>
																				</table>
																				<![endif]-->
																				<!--[if (mso)|(IE)]>
																			</td>
																		</tr>
																	</table>
																</td>
															</tr>
														</table>
														<![endif]-->
													</div>
												</div>
											</div>
											<div style="background-color:transparent;">
												<div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: ##2F294B;">
													<div style="border-collapse: collapse;display: table;width: 100%;background-color:##2F294B;">
														<!--[if (mso)|(IE)]>
														<table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;">
															<tr>
																<td align="center">
																	<table cellpadding="0" cellspacing="0" border="0" style="width:600px">
																		<tr class="layout-full-width" style="background-color:##2F294B">
																			<![endif]-->
																			<!--[if (mso)|(IE)]>
																			<td align="center" width="600" style="background-color:##2F294B;width:600px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top">
																				<table width="100%" cellpadding="0" cellspacing="0" border="0">
																					<tr>
																						<td style="padding-right: 0px; padding-left: 0px; padding-top:0px; padding-bottom:0px;">
																							<![endif]-->
																							<div class="col num12" style="min-width: 320px; max-width: 600px; display: table-cell; vertical-align: top; width: 600px;">
																								<div style="width:100% !important;">
																									<!--[if (!mso)&(!IE)]>
																									<!-->
																									<div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:0px; padding-bottom:0px; padding-right: 0px; padding-left: 0px;">
																										<!--
																										<![endif]-->
																										<div align="center" class="img-container center fixedwidth" style="padding-right: 50px;padding-left: 50px;">
																											<!--[if mso]>
																											<table width="100%" cellpadding="0" cellspacing="0" border="0">
																												<tr style="line-height:0px">
																													<td style="padding-right: 50px;padding-left: 50px;" align="center">
																														<![endif]-->
																														<div style="font-size:1px;line-height:50px"></div>
																														<img align="center" alt="Image" border="0" class="center fixedwidth" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/d079ba95-6d5a-4084-b897-c788ba0bdf9f.png" style="text-decoration: none; -ms-interpolation-mode: bicubic; border: 0; height: auto; width: 100%; max-width: 300px; display: block;" title="Image" width="300"/>
																														<div style="font-size:1px;line-height:50px"></div>
																														<!--[if mso]>
																													</td>
																												</tr>
																											</table>
																											<![endif]-->
																										</div>
																										<table border="0" cellpadding="0" cellspacing="0" class="divider" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;" valign="top" width="100%">
																											<tbody>
																												<tr style="vertical-align: top;" valign="top">
																													<td class="divider_inner" style="word-break: break-word; vertical-align: top; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px;" valign="top">
																														<table align="center" border="0" cellpadding="0" cellspacing="0" class="divider_content" height="0" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; border-top: 2px solid ##433E5D; height: 0px;" valign="top" width="100%">
																															<tbody>
																																<tr style="vertical-align: top;" valign="top">
																																	<td height="0" style="word-break: break-word; vertical-align: top; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;" valign="top">
																																		<span></span>
																																	</td>
																																</tr>
																															</tbody>
																														</table>
																													</td>
																												</tr>
																											</tbody>
																										</table>
																										<table cellpadding="0" cellspacing="0" class="social_icons" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt;" valign="top" width="100%">
																											<tbody>
																												<tr style="vertical-align: top;" valign="top">
																													<td style="word-break: break-word; vertical-align: top; padding-top: 15px; padding-right: 15px; padding-bottom: 15px; padding-left: 15px;" valign="top">
																														<table activate="activate" align="center" alignment="alignment" cellpadding="0" cellspacing="0" class="social_table" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: undefined; mso-table-tspace: 0; mso-table-rspace: 0; mso-table-bspace: 0; mso-table-lspace: 0;" to="to" valign="top">
																															<tbody>
																																<tr align="center" style="vertical-align: top; display: inline-block; text-align: center;" valign="top">
																																	<td style="word-break: break-word; vertical-align: top; padding-bottom: 5px; padding-right: 3px; padding-left: 3px;" valign="top">
																																		<a href="https://www.instagram.com/monatofficial/" target="_blank">
																																			<img alt="Instagram" height="32" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/9e10015d-f33c-4c35-ac49-0c9edcb1d8f1.png" style="text-decoration: none; -ms-interpolation-mode: bicubic; height: auto; border: none; display: block;" title="Instagram" width="32"/>
																																		</a>
																																	</td>
																																	<td style="word-break: break-word; vertical-align: top; padding-bottom: 5px; padding-right: 3px; padding-left: 3px;" valign="top">
																																		<a href="https://www.facebook.com/monatofficial" target="_blank">
																																			<img alt="Facebook" height="32" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/b23c934a-8da1-4a3b-9ea9-1a8edffb1dd6.png" style="text-decoration: none; -ms-interpolation-mode: bicubic; height: auto; border: none; display: block;" title="Facebook" width="32"/>
																																		</a>
																																	</td>
																																	<td style="word-break: break-word; vertical-align: top; padding-bottom: 5px; padding-right: 3px; padding-left: 3px;" valign="top">
																																		<a href="https://twitter.com/monatofficial" target="_blank">
																																			<img alt="Twitter" height="32" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/e15d88da-51d6-4c1c-a3c8-ae6f035e63a5.png" style="text-decoration: none; -ms-interpolation-mode: bicubic; height: auto; border: none; display: block;" title="Twitter" width="32"/>
																																		</a>
																																	</td>
																																	<td style="word-break: break-word; vertical-align: top; padding-bottom: 5px; padding-right: 3px; padding-left: 3px;" valign="top">
																																		<a href="https://www.youtube.com/user/MONATOfficial" target="_blank">
																																			<img alt="YouTube" height="32" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/8b052cb9-fee7-49bc-ab08-55f98d509654.png" style="text-decoration: none; -ms-interpolation-mode: bicubic; height: auto; border: none; display: block;" title="YouTube" width="32"/>
																																		</a>
																																	</td>
																																</tr>
																															</tbody>
																														</table>
																													</td>
																												</tr>
																											</tbody>
																										</table>
																										<!--[if (!mso)&(!IE)]>
																										<!-->
																									</div>
																									<!--
																									<![endif]-->
																								</div>
																							</div>
																							<!--[if (mso)|(IE)]>
																						</td>
																					</tr>
																				</table>
																				<![endif]-->
																				<!--[if (mso)|(IE)]>
																			</td>
																		</tr>
																	</table>
																</td>
															</tr>
														</table>
														<![endif]-->
													</div>
												</div>
											</div>
											<!--[if (mso)|(IE)]>
										</td>
									</tr>
								</table>
								<![endif]-->
							</td>
						</tr>
					</tbody>
				</table>
				<!--[if (IE)]>
			</div>
			<![endif]-->
		</body>
	<cfelseif account.getAccountType() == 'VIP'>
		<style type="text/css">
		body {
			margin: 0;
			padding: 0;
		}

		table,
		td,
		tr {
			vertical-align: top;
			border-collapse: collapse;
		}

		* {
			line-height: inherit;
		}

		a[x-apple-data-detectors=true] {
			color: inherit !important;
			text-decoration: none !important;
		}

		.ie-browser table {
			table-layout: fixed;
		}

		[owa] .img-container div,
		[owa] .img-container button {
			display: block !important;
		}

		[owa] .fullwidth button {
			width: 100% !important;
		}

		[owa] .block-grid .col {
			display: table-cell;
			float: none !important;
			vertical-align: top;
		}

		.ie-browser .block-grid,
		.ie-browser .num12,
		[owa] .num12,
		[owa] .block-grid {
			width: 600px !important;
		}

		.ie-browser .mixed-two-up .num4,
		[owa] .mixed-two-up .num4 {
			width: 200px !important;
		}

		.ie-browser .mixed-two-up .num8,
		[owa] .mixed-two-up .num8 {
			width: 400px !important;
		}

		.ie-browser .block-grid.two-up .col,
		[owa] .block-grid.two-up .col {
			width: 300px !important;
		}

		.ie-browser .block-grid.three-up .col,
		[owa] .block-grid.three-up .col {
			width: 300px !important;
		}

		.ie-browser .block-grid.four-up .col [owa] .block-grid.four-up .col {
			width: 150px !important;
		}

		.ie-browser .block-grid.five-up .col [owa] .block-grid.five-up .col {
			width: 120px !important;
		}

		.ie-browser .block-grid.six-up .col,
		[owa] .block-grid.six-up .col {
			width: 100px !important;
		}

		.ie-browser .block-grid.seven-up .col,
		[owa] .block-grid.seven-up .col {
			width: 85px !important;
		}

		.ie-browser .block-grid.eight-up .col,
		[owa] .block-grid.eight-up .col {
			width: 75px !important;
		}

		.ie-browser .block-grid.nine-up .col,
		[owa] .block-grid.nine-up .col {
			width: 66px !important;
		}

		.ie-browser .block-grid.ten-up .col,
		[owa] .block-grid.ten-up .col {
			width: 60px !important;
		}

		.ie-browser .block-grid.eleven-up .col,
		[owa] .block-grid.eleven-up .col {
			width: 54px !important;
		}

		.ie-browser .block-grid.twelve-up .col,
		[owa] .block-grid.twelve-up .col {
			width: 50px !important;
		}
	</style>
		<style id="media-query" type="text/css">
		@media only screen and (min-width: 620px) {
			.block-grid {
				width: 600px !important;
			}

			.block-grid .col {
				vertical-align: top;
			}

			.block-grid .col.num12 {
				width: 600px !important;
			}

			.block-grid.mixed-two-up .col.num3 {
				width: 150px !important;
			}

			.block-grid.mixed-two-up .col.num4 {
				width: 200px !important;
			}

			.block-grid.mixed-two-up .col.num8 {
				width: 400px !important;
			}

			.block-grid.mixed-two-up .col.num9 {
				width: 450px !important;
			}

			.block-grid.two-up .col {
				width: 300px !important;
			}

			.block-grid.three-up .col {
				width: 200px !important;
			}

			.block-grid.four-up .col {
				width: 150px !important;
			}

			.block-grid.five-up .col {
				width: 120px !important;
			}

			.block-grid.six-up .col {
				width: 100px !important;
			}

			.block-grid.seven-up .col {
				width: 85px !important;
			}

			.block-grid.eight-up .col {
				width: 75px !important;
			}

			.block-grid.nine-up .col {
				width: 66px !important;
			}

			.block-grid.ten-up .col {
				width: 60px !important;
			}

			.block-grid.eleven-up .col {
				width: 54px !important;
			}

			.block-grid.twelve-up .col {
				width: 50px !important;
			}
		}

		@media (max-width: 620px) {

			.block-grid,
			.col {
				min-width: 320px !important;
				max-width: 100% !important;
				display: block !important;
			}

			.block-grid {
				width: 100% !important;
			}

			.col {
				width: 100% !important;
			}

			.col>div {
				margin: 0 auto;
			}

			img.fullwidth,
			img.fullwidthOnMobile {
				max-width: 100% !important;
			}

			.no-stack .col {
				min-width: 0 !important;
				display: table-cell !important;
			}

			.no-stack.two-up .col {
				width: 50% !important;
			}

			.no-stack .col.num4 {
				width: 33% !important;
			}

			.no-stack .col.num8 {
				width: 66% !important;
			}

			.no-stack .col.num4 {
				width: 33% !important;
			}

			.no-stack .col.num3 {
				width: 25% !important;
			}

			.no-stack .col.num6 {
				width: 50% !important;
			}

			.no-stack .col.num9 {
				width: 75% !important;
			}

			.video-block {
				max-width: none !important;
			}

			.mobile_hide {
				min-height: 0px;
				max-height: 0px;
				max-width: 0px;
				display: none;
				overflow: hidden;
				font-size: 0px;
			}

			.desktop_hide {
				display: block !important;
				max-height: none !important;
			}
		}
	</style>
		<body class="clean-body" style="margin: 0; padding: 0; -webkit-text-size-adjust: 100%; background-color: ##FFFFFF;">
		<style id="media-query-bodytag" type="text/css">
			@media (max-width: 620px) {
			.block-grid {
				min-width: 320px!important;
				max-width: 100%!important;
				width: 100%!important;
				display: block!important;
			}
			.col {
				min-width: 320px!important;
				max-width: 100%!important;
				width: 100%!important;
				display: block!important;
			}
			.col > div {
				margin: 0 auto;
			}
			img.fullwidth {
				max-width: 100%!important;
				height: auto!important;
			}
			img.fullwidthOnMobile {
				max-width: 100%!important;
				height: auto!important;
			}
			.no-stack .col {
				min-width: 0!important;
				display: table-cell!important;
			}
			.no-stack.two-up .col {
				width: 50%!important;
			}
			.no-stack.mixed-two-up .col.num4 {
				width: 33%!important;
			}
			.no-stack.mixed-two-up .col.num8 {
				width: 66%!important;
			}
			.no-stack.three-up .col.num4 {
				width: 33%!important
			}
			.no-stack.four-up .col.num3 {
				width: 25%!important
			}
			}
		</style>
		<!--[if IE]>
		<div class="ie-browser">
			<![endif]-->
			<table bgcolor="##FFFFFF" cellpadding="0" cellspacing="0" class="nl-container" role="presentation" style="table-layout: fixed; vertical-align: top; min-width: 320px; Margin: 0 auto; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; background-color: ##FFFFFF; width: 100%;" valign="top" width="100%">
				<tbody>
					<tr style="vertical-align: top;" valign="top">
						<td style="word-break: break-word; vertical-align: top; border-collapse: collapse;" valign="top">
							<!--[if (mso)|(IE)]>
							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td align="center" style="background-color:##FFFFFF">
										<![endif]-->
										<div style="background-color:transparent;">
											<div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;;">
												<div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
													<!--[if (mso)|(IE)]>
													<table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;">
														<tr>
															<td align="center">
																<table cellpadding="0" cellspacing="0" border="0" style="width:600px">
																	<tr class="layout-full-width" style="background-color:transparent">
																		<![endif]-->
																		<!--[if (mso)|(IE)]>
																		<td align="center" width="600" style="background-color:transparent;width:600px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top">
																			<table width="100%" cellpadding="0" cellspacing="0" border="0">
																				<tr>
																					<td style="padding-right: 0px; padding-left: 0px; padding-top:0px; padding-bottom:0px;">
																						<![endif]-->
																						<div class="col num12" style="min-width: 320px; max-width: 600px; display: table-cell; vertical-align: top;;">
																							<div style="width:100% !important;">
																								<!--[if (!mso)&(!IE)]>
																								<!-->
																								<div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:0px; padding-bottom:0px; padding-right: 0px; padding-left: 0px;">
																									<!--
																									<![endif]-->
																									<div align="center" class="img-container center autowidth fullwidth" style="padding-right: 0px;padding-left: 0px;">
																										<!--[if mso]>
																										<table width="100%" cellpadding="0" cellspacing="0" border="0">
																											<tr style="line-height:0px">
																												<td style="padding-right: 0px;padding-left: 0px;" align="center">
																													<![endif]-->
																													<img align="center" alt="Header VIP" border="0" class="center autowidth fullwidth" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/38b34f8f-a275-4b33-8819-f14e2a2df653.jpg" style="outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; clear: both; border: 0; height: auto; float: none; width: 100%; max-width: 600px; display: block;" title="Header VIP" width="600"/>
																													<!--[if mso]>
																												</td>
																											</tr>
																										</table>
																										<![endif]-->
																									</div>
																									<div align="center" class="img-container center autowidth" style="padding-right: 30px;padding-left: 30px;">
																										<!--[if mso]>
																										<table width="100%" cellpadding="0" cellspacing="0" border="0">
																											<tr style="line-height:0px">
																												<td style="padding-right: 30px;padding-left: 30px;" align="center">
																													<![endif]-->
																													<div style="font-size:1px;line-height:30px"></div>
																													<img align="center" alt="stars VIP" border="0" class="center autowidth" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/b653dd21-92da-4a13-bca4-28d62bff0dbf.gif" style="outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; clear: both; border: 0; height: auto; float: none; width: 100%; max-width: 179px; display: block;" title="stars VIP" width="179"/>
																													<!--[if mso]>
																												</td>
																											</tr>
																										</table>
																										<![endif]-->
																									</div>
																									<!--[if mso]>
																									<table width="100%" cellpadding="0" cellspacing="0" border="0">
																										<tr>
																											<td style="padding-right: 10px; padding-left: 10px; padding-top: 20px; padding-bottom: 5px; font-family: Arial, sans-serif">
																												<![endif]-->
																												<div style="color:##5b5b5f;font-family:'Helvetica Neue', Helvetica, Arial, sans-serif;line-height:120%;padding-top:20px;padding-right:10px;padding-bottom:5px;padding-left:10px;">
																													<div style="font-size: 12px; line-height: 14px; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: ##5b5b5f;">
																														<p style="font-size: 12px; line-height: 40px; text-align: center; margin: 0;">
																															<span style="font-size: 34px;">EXCITING THINGS ARE 
																															
																															</span>
																														</p>
																														<p style="font-size: 12px; line-height: 40px; text-align: center; margin: 0;">
																															<span style="font-size: 34px; color: ##a598d5;">HAPPENING!</span>
																														</p>
																													</div>
																												</div>
																												<!--[if mso]>
																											</td>
																										</tr>
																									</table>
																									<![endif]-->
																									<table border="0" cellpadding="0" cellspacing="0" class="divider" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;" valign="top" width="100%">
																										<tbody>
																											<tr style="vertical-align: top;" valign="top">
																												<td class="divider_inner" style="word-break: break-word; vertical-align: top; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-top: 25px; padding-right: 25px; padding-bottom: 25px; padding-left: 25px; border-collapse: collapse;" valign="top">
																													<table align="center" border="0" cellpadding="0" cellspacing="0" class="divider_content" height="0" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 10%; border-top: 4px solid ##a598d5; height: 0px;" valign="top" width="10%">
																														<tbody>
																															<tr style="vertical-align: top;" valign="top">
																																<td height="0" style="word-break: break-word; vertical-align: top; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; border-collapse: collapse;" valign="top">
																																	<span></span>
																																</td>
																															</tr>
																														</tbody>
																													</table>
																												</td>
																											</tr>
																										</tbody>
																									</table>
																									<!--[if mso]>
																									<table width="100%" cellpadding="0" cellspacing="0" border="0">
																										<tr>
																											<td style="padding-right: 30px; padding-left: 30px; padding-top: 10px; padding-bottom: 10px; font-family: Arial, sans-serif">
																												<![endif]-->
																												<div style="color:##5b5b5f;font-family:'Helvetica Neue', Helvetica, Arial, sans-serif;line-height:150%;padding-top:10px;padding-right:30px;padding-bottom:10px;padding-left:30px;">
																													<div style="font-size: 12px; line-height: 18px; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: ##5b5b5f;">
																														<p style="font-size: 12px; line-height: 22px; text-align: center; margin: 0;">
																															<span style="font-size: 15px;">Dear 
																																<strong>#account.getFirstName()#</strong>,
																															</span>
																														</p>
																														<p style="font-size: 12px; line-height: 18px; text-align: center; margin: 0;"></p>
																														<p style="font-size: 12px; line-height: 22px; text-align: center; margin: 0;">
																															<span style="font-size: 15px;">Congratulations on becoming a MONAT VIP and THANK YOU for your order! #email.getBodyVIP()#</span>
																														</p>
																														<p style="font-size: 12px; line-height: 18px; text-align: center; margin: 0;"></p>
																														<p style="font-size: 12px; line-height: 22px; text-align: center; margin: 0;">
																															<span style="font-size: 15px;">As a VIP, your one-time enrollment fee of $24.95 grants you exclusive VIP privileges; receiving your first MONAT order in the mail and getting 15% OFF on all products are only the beginning!</span>
																														</p>
																													</div>
																												</div>
																												<!--[if mso]>
																											</td>
																										</tr>
																									</table>
																									<![endif]-->
																									<!--[if mso]>
																									<table width="100%" cellpadding="0" cellspacing="0" border="0">
																										<tr>
																											<td style="padding-right: 10px; padding-left: 10px; padding-top: 40px; padding-bottom: 5px; font-family: Arial, sans-serif">
																												<![endif]-->
																												<div style="color:##5b5b5f;font-family:'Helvetica Neue', Helvetica, Arial, sans-serif;line-height:120%;padding-top:40px;padding-right:10px;padding-bottom:5px;padding-left:10px;">
																													<div style="font-size: 12px; line-height: 14px; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: ##5b5b5f;">
																														<p style="font-size: 12px; line-height: 28px; text-align: center; margin: 0;">
																															<span style="font-size: 24px;">GETTING STARTED!</span>
																														</p>
																													</div>
																												</div>
																												<!--[if mso]>
																											</td>
																										</tr>
																									</table>
																									<![endif]-->
																									<table border="0" cellpadding="0" cellspacing="0" class="divider" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;" valign="top" width="100%">
																										<tbody>
																											<tr style="vertical-align: top;" valign="top">
																												<td class="divider_inner" style="word-break: break-word; vertical-align: top; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-top: 0px; padding-right: 10px; padding-bottom: 30px; padding-left: 10px; border-collapse: collapse;" valign="top">
																													<table align="center" border="0" cellpadding="0" cellspacing="0" class="divider_content" height="0" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 38%; border-top: 3px solid ##A598D5; height: 0px;" valign="top" width="38%">
																														<tbody>
																															<tr style="vertical-align: top;" valign="top">
																																<td height="0" style="word-break: break-word; vertical-align: top; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; border-collapse: collapse;" valign="top">
																																	<span></span>
																																</td>
																															</tr>
																														</tbody>
																													</table>
																												</td>
																											</tr>
																										</tbody>
																									</table>
																									<!--[if (!mso)&(!IE)]>
																									<!-->
																								</div>
																								<!--
																								<![endif]-->
																							</div>
																						</div>
																						<!--[if (mso)|(IE)]>
																					</td>
																				</tr>
																			</table>
																			<![endif]-->
																			<!--[if (mso)|(IE)]>
																		</td>
																	</tr>
																</table>
															</td>
														</tr>
													</table>
													<![endif]-->
												</div>
											</div>
										</div>
										<div style="background-color:transparent;">
											<div class="block-grid three-up" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;;">
												<div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
													<!--[if (mso)|(IE)]>
													<table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;">
														<tr>
															<td align="center">
																<table cellpadding="0" cellspacing="0" border="0" style="width:600px">
																	<tr class="layout-full-width" style="background-color:transparent">
																		<![endif]-->
																		<!--[if (mso)|(IE)]>
																		<td align="center" width="200" style="background-color:transparent;width:200px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top">
																			<table width="100%" cellpadding="0" cellspacing="0" border="0">
																				<tr>
																					<td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;">
																						<![endif]-->
																						<div class="col num4" style="max-width: 320px; min-width: 200px; display: table-cell; vertical-align: top;;">
																							<div style="width:100% !important;">
																								<!--[if (!mso)&(!IE)]>
																								<!-->
																								<div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
																									<!--
																									<![endif]-->
																									<div align="center" class="img-container center fixedwidth" style="padding-right: 5px;padding-left: 5px;">
																										<!--[if mso]>
																										<table width="100%" cellpadding="0" cellspacing="0" border="0">
																											<tr style="line-height:0px">
																												<td style="padding-right: 5px;padding-left: 5px;" align="center">
																													<![endif]-->
																													<div style="font-size:1px;line-height:5px"></div>
																													<img align="center" alt="number 1" border="0" class="center fixedwidth" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/c788a5cc-9589-490c-9d0a-5a0e0ff87b7d.jpg" style="outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; clear: both; border: 0; height: auto; float: none; width: 100%; max-width: 60px; display: block;" title="number 1" width="60"/>
																													<div style="font-size:1px;line-height:5px"></div>
																													<!--[if mso]>
																												</td>
																											</tr>
																										</table>
																										<![endif]-->
																									</div>
																									<!--[if mso]>
																									<table width="100%" cellpadding="0" cellspacing="0" border="0">
																										<tr>
																											<td style="padding-right: 10px; padding-left: 10px; padding-top: 10px; padding-bottom: 10px; font-family: Arial, sans-serif">
																												<![endif]-->
																												<div style="color:##555555;font-family:Arial, 'Helvetica Neue', Helvetica, sans-serif;line-height:150%;padding-top:10px;padding-right:10px;padding-bottom:10px;padding-left:10px;">
																													<div style="font-size: 14px; line-height: 21px; font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; color: ##555555;">
																														<p style="font-size: 14px; line-height: 21px; text-align: center; margin: 0;">Go to
																															<br/>
																															<strong>
																																<a href="http://www.monatglobal.com" rel="noopener" style="text-decoration: none; color: ##a598d5;" target="_blank">www.monatglobal.com</a>
																															</strong>
																														</p>
																													</div>
																												</div>
																												<!--[if mso]>
																											</td>
																										</tr>
																									</table>
																									<![endif]-->
																									<!--[if (!mso)&(!IE)]>
																									<!-->
																								</div>
																								<!--
																								<![endif]-->
																							</div>
																						</div>
																						<!--[if (mso)|(IE)]>
																					</td>
																				</tr>
																			</table>
																			<![endif]-->
																			<!--[if (mso)|(IE)]>
																		</td>
																		<td align="center" width="200" style="background-color:transparent;width:200px; border-top: 0px solid transparent; border-left: 1px solid ##BBBBBB; border-bottom: 0px solid transparent; border-right: 1px solid ##BBBBBB;" valign="top">
																			<table width="100%" cellpadding="0" cellspacing="0" border="0">
																				<tr>
																					<td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;">
																						<![endif]-->
																						<div class="col num4" style="max-width: 320px; min-width: 200px; display: table-cell; vertical-align: top;;">
																							<div style="width:100% !important;">
																								<!--[if (!mso)&(!IE)]>
																								<!-->
																								<div style="border-top:0px solid transparent; border-left:1px solid ##BBBBBB; border-bottom:0px solid transparent; border-right:1px solid ##BBBBBB; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
																									<!--
																									<![endif]-->
																									<div align="center" class="img-container center fixedwidth" style="padding-right: 5px;padding-left: 5px;">
																										<!--[if mso]>
																										<table width="100%" cellpadding="0" cellspacing="0" border="0">
																											<tr style="line-height:0px">
																												<td style="padding-right: 5px;padding-left: 5px;" align="center">
																													<![endif]-->
																													<div style="font-size:1px;line-height:5px"></div>
																													<img align="center" alt="Number2" border="0" class="center fixedwidth" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/26b50a5e-421b-4057-bbdd-eb9b7ad1d5ed.jpg" style="outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; clear: both; border: 0; height: auto; float: none; width: 100%; max-width: 59px; display: block;" title="Number2" width="59"/>
																													<div style="font-size:1px;line-height:5px"></div>
																													<!--[if mso]>
																												</td>
																											</tr>
																										</table>
																										<![endif]-->
																									</div>
																									<!--[if mso]>
																									<table width="100%" cellpadding="0" cellspacing="0" border="0">
																										<tr>
																											<td style="padding-right: 10px; padding-left: 10px; padding-top: 10px; padding-bottom: 10px; font-family: Arial, sans-serif">
																												<![endif]-->
																												<div style="color:##555555;font-family:Arial, 'Helvetica Neue', Helvetica, sans-serif;line-height:150%;padding-top:10px;padding-right:10px;padding-bottom:10px;padding-left:10px;">
																													<div style="font-size: 14px; line-height: 21px; font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; color: ##555555;">
																														<p style="font-size: 14px; line-height: 21px; text-align: center; margin: 0;"></p>
																													</div>
																												</div>
																												<!--[if mso]>
																											</td>
																										</tr>
																									</table>
																									<![endif]-->
																									<!--[if (!mso)&(!IE)]>
																									<!-->
																								</div>
																								<!--
																								<![endif]-->
																							</div>
																						</div>
																						<!--[if (mso)|(IE)]>
																					</td>
																				</tr>
																			</table>
																			<![endif]-->
																			<!--[if (mso)|(IE)]>
																		</td>
																		<td align="center" width="200" style="background-color:transparent;width:200px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top">
																			<table width="100%" cellpadding="0" cellspacing="0" border="0">
																				<tr>
																					<td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;">
																						<![endif]-->
																						<div class="col num4" style="max-width: 320px; min-width: 200px; display: table-cell; vertical-align: top;;">
																							<div style="width:100% !important;">
																								<!--[if (!mso)&(!IE)]>
																								<!-->
																								<div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
																									<!--
																									<![endif]-->
																									<div align="center" class="img-container center fixedwidth" style="padding-right: 5px;padding-left: 5px;">
																										<!--[if mso]>
																										<table width="100%" cellpadding="0" cellspacing="0" border="0">
																											<tr style="line-height:0px">
																												<td style="padding-right: 5px;padding-left: 5px;" align="center">
																													<![endif]-->
																													<div style="font-size:1px;line-height:5px"></div>
																													<img align="center" alt="Number3" border="0" class="center fixedwidth" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/48c9cdf4-24e4-4a67-bdf8-e26326a549d3.jpg" style="outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; clear: both; border: 0; height: auto; float: none; width: 100%; max-width: 60px; display: block;" title="Number3" width="60"/>
																													<div style="font-size:1px;line-height:5px"></div>
																													<!--[if mso]>
																												</td>
																											</tr>
																										</table>
																										<![endif]-->
																									</div>
																									<!--[if mso]>
																									<table width="100%" cellpadding="0" cellspacing="0" border="0">
																										<tr>
																											<td style="padding-right: 10px; padding-left: 10px; padding-top: 10px; padding-bottom: 10px; font-family: Arial, sans-serif">
																												<![endif]-->
																												<div style="color:##555555;font-family:Arial, 'Helvetica Neue', Helvetica, sans-serif;line-height:150%;padding-top:10px;padding-right:10px;padding-bottom:10px;padding-left:10px;">
																													<div style="font-size: 14px; line-height: 21px; font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; color: ##555555;">
																														<p style="font-size: 14px; line-height: 21px; text-align: center; margin: 0;">Enter your unique username and password (which you created during your enrollment).</p>
																													</div>
																												</div>
																												<!--[if mso]>
																											</td>
																										</tr>
																									</table>
																									<![endif]-->
																									<!--[if (!mso)&(!IE)]>
																									<!-->
																								</div>
																								<!--
																								<![endif]-->
																							</div>
																						</div>
																						<!--[if (mso)|(IE)]>
																					</td>
																				</tr>
																			</table>
																			<![endif]-->
																			<!--[if (mso)|(IE)]>
																		</td>
																	</tr>
																</table>
															</td>
														</tr>
													</table>
													<![endif]-->
												</div>
											</div>
										</div>
										<div style="background-color:transparent;">
											<div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;;">
												<div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
													<!--[if (mso)|(IE)]>
													<table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;">
														<tr>
															<td align="center">
																<table cellpadding="0" cellspacing="0" border="0" style="width:600px">
																	<tr class="layout-full-width" style="background-color:transparent">
																		<![endif]-->
																		<!--[if (mso)|(IE)]>
																		<td align="center" width="600" style="background-color:transparent;width:600px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top">
																			<table width="100%" cellpadding="0" cellspacing="0" border="0">
																				<tr>
																					<td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;">
																						<![endif]-->
																						<div class="col num12" style="min-width: 320px; max-width: 600px; display: table-cell; vertical-align: top;;">
																							<div style="width:100% !important;">
																								<!--[if (!mso)&(!IE)]>
																								<!-->
																								<div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
																									<!--
																									<![endif]-->
																									<!--[if mso]>
																									<table width="100%" cellpadding="0" cellspacing="0" border="0">
																										<tr>
																											<td style="padding-right: 45px; padding-left: 45px; padding-top: 25px; padding-bottom: 20px; font-family: Arial, sans-serif">
																												<![endif]-->
																												<div style="color:##5b5b5f;font-family:'Helvetica Neue', Helvetica, Arial, sans-serif;line-height:150%;padding-top:25px;padding-right:45px;padding-bottom:20px;padding-left:45px;">
																													<div style="font-size: 12px; line-height: 18px; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: ##5b5b5f;">
																														<p style="font-size: 12px; line-height: 22px; text-align: center; margin: 0;">
																															<span style="font-size: 15px;">Once in your VIP Suite, you can schedule your Flexship. Your qualifying Flexship (with a minimum order of $110) entitles you to unique VIP benefits, including the FREE monthly Only For You product plus FREE shipping!</span>
																														</p>
																														<p style="font-size: 12px; line-height: 18px; text-align: center; margin: 0;"></p>
																														<p style="font-size: 12px; line-height: 22px; text-align: center; margin: 0;">
																															<span style="font-size: 15px;">Plus, it’s easy to keep your Flexship orders going because you can choose and alternate your selections every month.. You can even push out your Flexship up to 60 days and continue to enjoy all these VIP perks!</span>
																														</p>
																														<p style="font-size: 12px; line-height: 22px; text-align: center; margin: 0;">
																															<span style="font-size: 15px;"></span>
																														</p>
																														<p style="font-size: 12px; line-height: 22px; text-align: center; margin: 0;">
																															<span style="font-size: 15px;">For more information on the benefits and obligations of the VIP Program, please review the</span>
																															<span style="font-size: 15px; line-height: 22px;"></span>
																															<span style="background-color: transparent; font-size: 15px; line-height: 22px;">
																																<strong>
																																	<a href="https://monatglobal.com/ca/wp-content/uploads/sites/5/2019/06/VIP-Customer-Agreement-%E2%80%93-VIP-Program_CAN.pdf" rel="noopener" style="text-decoration: none; color: ##a598d5;" target="_blank">VIP Customer Agreement</a>
																																</strong>
																															</span>
																															<span style="background-color: transparent; font-size: 15px; line-height: 22px;">.</span>
																														</p>
																													</div>
																												</div>
																												<!--[if mso]>
																											</td>
																										</tr>
																									</table>
																									<![endif]-->
																									<!--[if (!mso)&(!IE)]>
																									<!-->
																								</div>
																								<!--
																								<![endif]-->
																							</div>
																						</div>
																						<!--[if (mso)|(IE)]>
																					</td>
																				</tr>
																			</table>
																			<![endif]-->
																			<!--[if (mso)|(IE)]>
																		</td>
																	</tr>
																</table>
															</td>
														</tr>
													</table>
													<![endif]-->
												</div>
											</div>
										</div>
										<div style="background-color:transparent;">
											<div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;;">
												<div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
													<!--[if (mso)|(IE)]>
													<table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;">
														<tr>
															<td align="center">
																<table cellpadding="0" cellspacing="0" border="0" style="width:600px">
																	<tr class="layout-full-width" style="background-color:transparent">
																		<![endif]-->
																		<!--[if (mso)|(IE)]>
																		<td align="center" width="600" style="background-color:transparent;width:600px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top">
																			<table width="100%" cellpadding="0" cellspacing="0" border="0">
																				<tr>
																					<td style="padding-right: 0px; padding-left: 0px; padding-top:0px; padding-bottom:0px;">
																						<![endif]-->
																						<div class="col num12" style="min-width: 320px; max-width: 600px; display: table-cell; vertical-align: top;;">
																							<div style="width:100% !important;">
																								<!--[if (!mso)&(!IE)]>
																								<!-->
																								<div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:0px; padding-bottom:0px; padding-right: 0px; padding-left: 0px;">
																									<!--
																									<![endif]-->
																									<!--[if mso]>
																									<table width="100%" cellpadding="0" cellspacing="0" border="0">
																										<tr>
																											<td style="padding-right: 30px; padding-left: 30px; padding-top: 10px; padding-bottom: 30px; font-family: Arial, sans-serif">
																												<![endif]-->
																												<div style="color:##5b5b5f;font-family:'Helvetica Neue', Helvetica, Arial, sans-serif;line-height:150%;padding-top:10px;padding-right:30px;padding-bottom:30px;padding-left:30px;">
																													<div style="font-size: 12px; line-height: 18px; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: ##5b5b5f;">
																														<p style="font-size: 12px; line-height: 22px; text-align: center; margin: 0;">
																															<strong>
																																<span style="font-size: 15px; line-height: 22px;">MONAT Customer Care is always happy to help:</span>
																															</strong>
																															<br/>
																															<a href="mailto:canadamonatsupport@monatglobal.com" rel="noopener" style="text-decoration: none; color: ##a598d5;" target="_blank">
																																<strong>
																																	<span style="font-size: 15px; line-height: 22px;">canadamonatsupport@monatglobal.com</span>
																																</strong>
																															</a>
																															<br/>
																															<span style="font-size: 15px;">(833) 750-4880</span>
																															<br/>
																															<span style="font-size: 15px; line-height: 22px;">Monday - Friday 8:00 am - 5:00 pm Eastern</span>
																															<br/>
																															<br/>
																															<em>
																																<span style="font-size: 15px; line-height: 22px;">Thank you for being a MONAT VIP!</span>
																															</em>
																														</p>
																													</div>
																												</div>
																												<!--[if mso]>
																											</td>
																										</tr>
																									</table>
																									<![endif]-->
																									<!--[if (!mso)&(!IE)]>
																									<!-->
																								</div>
																								<!--
																								<![endif]-->
																							</div>
																						</div>
																						<!--[if (mso)|(IE)]>
																					</td>
																				</tr>
																			</table>
																			<![endif]-->
																			<!--[if (mso)|(IE)]>
																		</td>
																	</tr>
																</table>
															</td>
														</tr>
													</table>
													<![endif]-->
												</div>
											</div>
										</div>
										<div style="background-color:transparent;">
											<div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;;">
												<div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
													<!--[if (mso)|(IE)]>
													<table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;">
														<tr>
															<td align="center">
																<table cellpadding="0" cellspacing="0" border="0" style="width:600px">
																	<tr class="layout-full-width" style="background-color:transparent">
																		<![endif]-->
																		<!--[if (mso)|(IE)]>
																		<td align="center" width="600" style="background-color:transparent;width:600px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top">
																			<table width="100%" cellpadding="0" cellspacing="0" border="0">
																				<tr>
																					<td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;">
																						<![endif]-->
																						<div class="col num12" style="min-width: 320px; max-width: 600px; display: table-cell; vertical-align: top;;">
																							<div style="width:100% !important;">
																								<!--[if (!mso)&(!IE)]>
																								<!-->
																								<div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
																									<!--
																									<![endif]-->
																									<div align="center" class="img-container center autowidth fullwidth" style="padding-right: 0px;padding-left: 0px;">
																										<!--[if mso]>
																										<table width="100%" cellpadding="0" cellspacing="0" border="0">
																											<tr style="line-height:0px">
																												<td style="padding-right: 0px;padding-left: 0px;" align="center">
																													<![endif]-->
																													<img align="center" alt="footer vip" border="0" class="center autowidth fullwidth" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/b9143a14-0ef2-428e-9ef4-385ef50e057f.jpg" style="outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; clear: both; border: 0; height: auto; float: none; width: 100%; max-width: 600px; display: block;" title="footer vip" width="600"/>
																													<!--[if mso]>
																												</td>
																											</tr>
																										</table>
																										<![endif]-->
																									</div>
																									<table border="0" cellpadding="0" cellspacing="0" class="divider" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;" valign="top" width="100%">
																										<tbody>
																											<tr style="vertical-align: top;" valign="top">
																												<td class="divider_inner" style="word-break: break-word; vertical-align: top; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-top: 15px; padding-right: 10px; padding-bottom: 10px; padding-left: 10px; border-collapse: collapse;" valign="top">
																													<table align="center" border="0" cellpadding="0" cellspacing="0" class="divider_content" height="0" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; border-top: 1px solid ##BBBBBB; height: 0px;" valign="top" width="100%">
																														<tbody>
																															<tr style="vertical-align: top;" valign="top">
																																<td height="0" style="word-break: break-word; vertical-align: top; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; border-collapse: collapse;" valign="top">
																																	<span></span>
																																</td>
																															</tr>
																														</tbody>
																													</table>
																												</td>
																											</tr>
																										</tbody>
																									</table>
																									<!--[if mso]>
																									<table width="100%" cellpadding="0" cellspacing="0" border="0">
																										<tr>
																											<td style="padding-right: 5px; padding-left: 5px; padding-top: 20px; padding-bottom: 0px; font-family: Arial, sans-serif">
																												<![endif]-->
																												<div style="color:##A9A9A9;font-family:'Helvetica Neue', Helvetica, Arial, sans-serif;line-height:120%;padding-top:20px;padding-right:5px;padding-bottom:0px;padding-left:5px;">
																													<div style="font-size: 12px; line-height: 14px; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: ##A9A9A9;">
																														<p style="font-size: 12px; line-height: 14px; text-align: center; margin: 0;">
																															<span style="font-size: 12px; line-height: 14px;">Get Social and Go Viral with the MONAT Family</span>
																														</p>
																													</div>
																												</div>
																												<!--[if mso]>
																											</td>
																										</tr>
																									</table>
																									<![endif]-->
																									<table cellpadding="0" cellspacing="0" class="social_icons" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt;" valign="top" width="100%">
																										<tbody>
																											<tr style="vertical-align: top;" valign="top">
																												<td style="word-break: break-word; vertical-align: top; padding-top: 10px; padding-right: 10px; padding-bottom: 10px; padding-left: 10px; border-collapse: collapse;" valign="top">
																													<table activate="activate" align="center" alignment="alignment" cellpadding="0" cellspacing="0" class="social_table" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: undefined; mso-table-tspace: 0; mso-table-rspace: 0; mso-table-bspace: 0; mso-table-lspace: 0;" to="to" valign="top">
																														<tbody>
																															<tr align="center" style="vertical-align: top; display: inline-block; text-align: center;" valign="top">
																																<td style="word-break: break-word; vertical-align: top; padding-bottom: 5px; padding-right: 3px; padding-left: 3px; border-collapse: collapse;" valign="top">
																																	<a href="https://www.facebook.com/monatcanadaofficial" target="_blank">
																																		<img alt="Facebook" height="32" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/a82e77e6-c722-432b-b286-5f4af21b2c57.png" style="outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; clear: both; height: auto; float: none; border: none; display: block;" title="Facebook" width="32"/>
																																	</a>
																																</td>
																																<td style="word-break: break-word; vertical-align: top; padding-bottom: 5px; padding-right: 3px; padding-left: 3px; border-collapse: collapse;" valign="top">
																																	<a href="https://twitter.com/monatofficial" target="_blank">
																																		<img alt="Twitter" height="32" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/ced021a3-c49e-49e5-ab35-3cf00df5a151.png" style="outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; clear: both; height: auto; float: none; border: none; display: block;" title="Twitter" width="32"/>
																																	</a>
																																</td>
																																<td style="word-break: break-word; vertical-align: top; padding-bottom: 5px; padding-right: 3px; padding-left: 3px; border-collapse: collapse;" valign="top">
																																	<a href="https://www.youtube.com/user/MONATOfficial" target="_blank">
																																		<img alt="YouTube" height="32" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/e40143e1-2d6b-4189-8399-dfca4bba03f8.png" style="outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; clear: both; height: auto; float: none; border: none; display: block;" title="YouTube" width="32"/>
																																	</a>
																																</td>
																																<td style="word-break: break-word; vertical-align: top; padding-bottom: 5px; padding-right: 3px; padding-left: 3px; border-collapse: collapse;" valign="top">
																																	<a href="https://www.pinterest.com/MonatOfficial/" target="_blank">
																																		<img alt="Pinterest" height="32" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/25f5c949-e4a1-4ae4-b5c2-fef7986e8fe7.png" style="outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; clear: both; height: auto; float: none; border: none; display: block;" title="Pinterest" width="32"/>
																																	</a>
																																</td>
																																<td style="word-break: break-word; vertical-align: top; padding-bottom: 5px; padding-right: 3px; padding-left: 3px; border-collapse: collapse;" valign="top">
																																	<a href="https://www.instagram.com/monatcanadaofficial/" target="_blank">
																																		<img alt="Instagram" height="32" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/8240127a-c481-4473-b439-2c412c0d3d5e.png" style="outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; clear: both; height: auto; float: none; border: none; display: block;" title="Instagram" width="32"/>
																																	</a>
																																</td>
																															</tr>
																														</tbody>
																													</table>
																												</td>
																											</tr>
																										</tbody>
																									</table>
																									<!--[if (!mso)&(!IE)]>
																									<!-->
																								</div>
																								<!--
																								<![endif]-->
																							</div>
																						</div>
																						<!--[if (mso)|(IE)]>
																					</td>
																				</tr>
																			</table>
																			<![endif]-->
																			<!--[if (mso)|(IE)]>
																		</td>
																	</tr>
																</table>
															</td>
														</tr>
													</table>
													<![endif]-->
												</div>
											</div>
										</div>
										<!--[if (mso)|(IE)]>
									</td>
								</tr>
							</table>
							<![endif]-->
						</td>
					</tr>
				</tbody>
			</table>
			<!--[if (IE)]>
		</div>
		<![endif]-->
		</body>
	<cfelse>
	
					<!-----MARKET PARTER TEMPLATE HERE ----->
					
	</cfif>
	
	<cfinclude template="../inc/footer.cfm" />
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="emailData.emailBodyText">
	
	<!-- PLAIN TEXT VERSION -->
	<cfoutput>
		Welcome!
		
		You have finished setting up your new account
		
		<a href="/my-account/" target="_blank">My Account</a>
	</cfoutput>
	
</cfsavecontent>

