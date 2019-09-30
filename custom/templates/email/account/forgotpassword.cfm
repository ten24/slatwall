<cfparam name="email" type="any" />
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="account" type="any" />

<cfsilent>
	<cfif FindNoCase('ten24dev', CGI.SERVER_NAME )>
		<cfset siteLink = "https://monatglobal.com/" />
	<cfelse>
		<cfset siteLink = "http://monat.ten24dev.com/" />
	</cfif>

	<cfset resetLink = "http://" />
	<cfset resetLink &= CGI.HTTP_HOST /> <!--- This adds the current domain name --->
	<cfset resetLink &= '/my-account/?swprid=#account.getPasswordResetID()#' />
</cfsilent>

<cfsavecontent variable="emailData.emailBodyHTML">

<cfoutput>
<cfset colorAccent = "##1c1932" />
<cfset colorContainer = "##ffffff" />
<cfset colorLighterText = "##a7b1b6" />

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<style type="text/css"> ##outlook a { padding: 0; }
		 html {background-color: ##ffffff;}
		 body { width: 100% !important; -webkit-text-size-adjust: none; -ms-text-size-adjust: none; margin: 0; padding: 0; background-color: ##ffffff; }
		 ##backgroundTable { margin: 0; padding: 0; width: 100% !important; line-height: 100% !important; }
		 img { outline: none; text-decoration: none; border: none; -ms-interpolation-mode: bicubic; }
		 a img { border: none; }
		 p { margin: 0px 0px !important; }
		 table td { border-collapse: collapse; }
		 table { border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
		 a { color: ##190d10; text-decoration: underline; }
		
		
		@media only screen and (max-width:640px) {
		 table[class=devicewidth] { width: 90%!important; text-align: center!important; }
		 img[class=logo] { width: 100%!important; max-width: 200px; height: auto!important; display: block; margin-left: auto; margin-right: auto; width:100%}
		 img[class=banner] { width: 100%!important; height: auto!important; display: block; margin-left: auto; margin-right: auto; width:100%}
		}
		
		@media only screen and (max-width:480px) {
		 table[class=devicewidth] { width: 90%!important; text-align: center!important; }
		 td[class=devicewidth] { width: 90%!important; }
		}
		 </style>
	</head>
	<body style="background-color: ##ffffff;">
		<table width="100%" bgcolor="##ffffff" height="1" cellpadding="0" cellspacing="0" border="0" id="backgroundTable">
			<tbody>
				<tr>
					<td height="1">
						<table width="600" height="1" cellpadding="0" cellspacing="0" border="0" align="center" bgcolor="##fff" class="devicewidth">
						  <tbody>
							<tr>
							  <td>
								  <table width="600" height="1" cellpadding="0" cellspacing="0" border="0" align="center" class="devicewidth">
										<tbody>
											<tr>
												<td width="350" height="90" valign="top" align="center" bgcolor="##fff">
													<cfset logo = siteLink & "themes/monat/assets/images/logo.svg">
													<img style="display: block; padding:0; margin:0 auto;" src="#logo#" border="0" alt="Monat" width="350" height="90" align="center" class="logo">
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
							<tr>
							  <td width="100%" height="1">
									<table width="600" height="1" cellpadding="0" cellspacing="0" border="0" align="center" class="devicewidth">
										<tbody>
											<tr>
												<td height="40" width="600" style="font-size:0px; line-height:0px; mso-line-height-rule: exactly;">&nbsp;</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
		
							<tr>
							  <td align="center">
									<table width="85%" height="1" cellpadding="0" cellspacing="0" border="0" align="center" class="devicewidth" style="font-family:Arial,sans-serif;font-size:13px;">
										<tbody>
											<tr>
												<td align="left" style="font-family:Arial,sans-serif; font-size: 13px; line-height:18px; color: ##190d10; mso-line-height-rule: exactly;">
		                                            <p>Hello,</p>
		                                            <p>Please click on the link below to update your password and access your account.</p>
		                                            <table class="ebtn" align="center" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;display: table;margin-left: auto;margin-right: auto;">
														<tbody>
															<tr>
																
																<!------- RESET PASSWORD LINK ------->
																<td class="active_b" style="box-sizing: border-box;vertical-align: top;background-color: #colorAccent#;line-height: 20px;font-family: Helvetica, Arial, sans-serif;mso-line-height-rule: exactly;border-radius: 4px;text-align: center;font-weight: bold;font-size: 17px;padding: 13px 22px;"><a href="#resetLink#" style="text-decoration: none;line-height: inherit;color: #colorContainer#;padding: 10px 8px;margin-top: 20px;"><span style="text-decoration: none;line-height: inherit;color: #colorContainer#;">Reset Password</span></a></td>
															</tr>
														</tbody>
													</table>
													<p>To make additional changes to your account settings, simply sign in to <a href="#siteLink#my-account">My Account</a> from the site. Questions? Our team would be delighted to help at <a href="mailto:monatsupport@monatglobal.com">monatsupport@monatglobal.com</a> or (888) 867- 9987.</p>
		                                        </td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
		
							<tr>
							  <td align="center" height="2px">
									<table width="85%" height="2px" cellpadding="0" cellspacing="0" border="0" align="center" class="devicewidth">
										<tbody>
											<tr>
												<td align="center">
													<table width="100px" height="2px" cellpadding="0" cellspacing="0" border="0" align="left">
														<tbody>
															<tr>
																<td height="2px" bgcolor="##aa842c" width="100px" style="font-size:0px; line-height:0px; mso-line-height-rule: exactly;">&nbsp;</td>
															</tr>
														</tbody>
													</table>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
		
							<tr>
								<td bgcolor="##ffffff">
									<table width="600" height="1" cellpadding="0" cellspacing="0" border="0" align="center" class="devicewidth" style="font-family:Arial,sans-serif;font-size:11px;">
										<tbody>
											<tr>
												<td align="center" style="font-family:  Arial, sans-serif; font-size: 11px; line-height:19px; color: ##555555; mso-line-height-rule: exactly;">
													<table width="85%" height="1" cellpadding="0" cellspacing="0" border="0" align="center" class="devicewidth" style="font-family:Arial,sans-serif;font-size:11px;">
														<tbody>
															<tr>
																<td style="font-size: 11px; text-align: center">&copy; #DateFormat(Now(),"yyyy")# Monat. All rights reserved.</td>
															</tr>
														</tbody>
													</table>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
		
							<tr>
								<td bgcolor="##ffffff">
									<table width="600" height="1" cellpadding="0" cellspacing="0" border="0" align="center" class="devicewidth">
										<tbody>
											<tr>
												<td align="center" style="background-color:##e3e1e1;">
													<table width="150px" height="1" cellpadding="0" cellspacing="0" border="0" align="center">
														<tbody>
															<tr>
																<td width="60">
																	<!-- FACEBOOK ICON/LINK -->
																	<a href="https://www.facebook.com/monatofficial" style="text-decoration: underline;line-height: inherit;color: #colorLighterText#;"><img src="#siteLink#Slatwall/assets/images/social-facebook_white.png" width="24" height="24" alt="facebook" style="outline: none;border: 0;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;line-height: 100%;max-width: 24px;height: auto !important;"></a> 
																</td>
																
																<td width="60">
																	<!-- INSTAGRAM ICON/LINK -->
																	<a href="https://instagram.com/monatofficial" style="text-decoration: underline;line-height: inherit;color: #colorLighterText#;"><img src="#siteLink#Slatwall/assets/images/social-instagram_white.png" width="24" height="24" alt="instagram" style="outline: none;border: 0;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;line-height: 100%;max-width: 24px;height: auto !important;"></a>
																</td>
																<td width="60">
																	<!-- TWITTER ICON/LINK -->
																	<a href="https://twitter.com/monatofficial" style="text-decoration: underline;line-height: inherit;color: #colorLighterText#;"><img src="#siteLink#Slatwall/assets/images/social-twitter_white.png" width="24" height="24" alt="twitter" style="outline: none;border: 0;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;line-height: 100%;max-width: 24px;height: auto !important;"></a> 
																</td>
																<td width="60">
																	<!-- YOUTUBE ICON/LINK -->
																	<a href="https://www.youtube.com/user/MONATOfficial" style="text-decoration: underline;line-height: inherit;color: #colorLighterText#;"><img src="#siteLink#Slatwall/assets/images/social_youtube.png" width="24" height="24" alt="twitter" style="outline: none;border: 0;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;line-height: 100%;max-width: 24px;height: auto !important;"></a> 
																</td>
															</tr>
														</tbody>
													</table>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						  </tbody>
						</table>
					</td>
				</tr>
			</tbody>
		</table>
	</body>
</html>
</cfoutput>
</cfsavecontent>

<cfsavecontent variable="emailData.emailBodyText">
	<cfoutput>
		Hello,
		Please click on the link below to update your password and access your account.
		
		#resetLink#
	</cfoutput>
</cfsavecontent>
