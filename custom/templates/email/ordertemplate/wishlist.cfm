<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="orderTemplate" type="any" />

<cfsavecontent variable="emailData.emailBodyHTML">
	<cfoutput>
	<cfinclude template="../inc/header.cfm" />
		
	<table class="email_table" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
		<tbody>
			<tr>
				<td class="email_body tc" style="box-sizing: border-box;vertical-align: top;line-height: 100%;text-align: center;padding-left: 16px;padding-right: 16px;background-color: #colorBackground#;">
					<div class="email_container" style="box-sizing: border-box;display: inline-block;width: 100%;vertical-align: top;max-width: 632px;margin: 0 auto;text-align: center;line-height: inherit;min-width: 0 !important;">
						<table class="content_section" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
							<tbody>
								<tr>
									<td class="content_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;background-color: #colorContainerAccent#;text-align: center;padding-left: 16px;padding-right: 16px;line-height: inherit;min-width: 0 !important;">
										<!-- col-6 -->
										<div class="email_row" style="box-sizing: border-box;display: block;width: 100%;vertical-align: top;margin: 0 auto;text-align: center;clear: both;line-height: inherit;min-width: 0 !important;max-width: 600px !important;">
											<div class="col_6" style="box-sizing: border-box;display: inline-block;width: 100%;vertical-align: top;max-width: 600px;line-height: inherit;min-width: 0 !important;margin-top: 15px;margin-bottom: 15px;">
												<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
													<tbody>
														<tr>
															<td class="column_cell px tc" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding: 16px;font-family: 'Miller-Banner-Roman', sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: center;text-align:left;">
																
																<cfif !isNull(orderTemplate.getAccount().getFullName())>
																	<cfset var wishlistOwnerName="#orderTemplate.getAccount().getFullName()#'s" />
																<cfelse>
																	<cfset var wishlistOwnerName="#orderTemplate.getAccount().getFirstName()# #orderTemplate.getAccount().getLastName()#'s" />
																</cfif>
																
																<cfif orderTemplate.getOrderTemplateName() DOES NOT CONTAIN 'wishlist' OR orderTemplate.getOrderTemplateName() DOES NOT CONTAIN 'wish list'>
																	<cfset wishlistTitle="#orderTemplate.getOrderTemplateName()#" />
																<cfelse>
																	<cfset wishlistTitle="#orderTemplate.getOrderTemplateName()# Wishlist" />
																</cfif>
																
																<h2 class="mbe" style="font-family: 'Miller-Banner-Roman', sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 20px;text-align:center;">
																	#wishlistOwnerName# #wishlistTitle#
																</h2>
																
																<p class="mbe" style="font-family: 'Miller-Banner-Roman', sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 20px;text-align:left;">
																		Hi there! These are some Monat products I love, thought you might like them too! 
																</p>
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

	<!------- TABLE HEADER ------->
	<table class="email_table" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
		<tbody>
			<tr>
				<td class="email_body tc" style="box-sizing: border-box;vertical-align: top;line-height: 100%;text-align:center;padding-left: 16px;padding-right: 16px;background-color: #colorBackground#;">
					<div class="email_container" style="box-sizing: border-box;display: inline-block;width: 100%;vertical-align: top;max-width: 632px;margin: 0 auto;line-height: inherit;min-width: 0 !important;">
						<div style="box-sizing: border-box;display: inline-block;width: 100%;vertical-align: top;line-height: inherit;min-width: 0 !important;">
							<table class="content_section" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
								<tbody>
									<tr>
										<td class="content_cell pb" style="box-sizing: border-box;vertical-align: top;width: 100%;background-color: #colorContainer#;line-height: inherit;min-width: 0 !important; padding: 25px 16px 0;">
											<!-- col-6 -->
											<div class="email_row" style="box-sizing: border-box;display: block;width: 100%;vertical-align: top;margin: 0 auto;clear: both;line-height: inherit;min-width: 0 !important;max-width: 600px !important;">
												<div class="" style="box-sizing: border-box;display: inline-block;width: 100%;vertical-align: top;max-width: 100%;line-height: inherit;min-width: 0 !important;margin-top: 15px;">
													
													<table align="center" class="container" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
														<tr style="line-height: 25px;  border: solid 1px #colorContainerAccent#;">
															<td style="line-height: 25px; margin: 5px; font-weight: bold;">
																Product ID
															</td>
															<td style="line-height: 25px; margin: 5px; font-weight: bold;">
																Name
															</td>
															<td style="line-height: 25px; margin: 5px; font-weight: bold;">
															</td>
														</tr>
														<!------- ORDER ITEM LOOP ------->
														<cfset skuCodeArray = []>
														<cfset skuIDArray = []>
														
														<cfloop array="#orderTemplate.getOrderTemplateItems()#" index="local.orderTemplateItem">
															<tr style="line-height: 25px;  border: solid 1px #colorContainerAccent#;">
																<td style="line-height: 25px; margin: 5px;">
																	#local.orderTemplateItem.getSku().getSkuCode()#
																	<cfset ArrayAppend(skuCodeArray,local.orderTemplateItem.getSku().getSkuCode())>
																	<cfset ArrayAppend(skuIDArray,local.orderTemplateItem.getSku().getSkuID())>
																</td>
																<td style="line-height: 25px; margin: 5px;">
																	#local.orderTemplateItem.getSku().getProduct().getTitle()#
																<td class="success_b" style="line-height: 25px; margin: 5px;">
																	<a href="#local.siteLink#shopping-cart/?slataction=public:cart.addOrderItems&amp;skuIds=#local.orderTemplateItem.getSku().getSkuID()#&amp;showLogin=true&amp;abandonedCart=true&amp;utm_source=abandonedCart&amp;utm_medium=email&amp;utm_campaign=Abandoned%20Cart%20Promo%20Code" style="text-decoration: none;line-height: inherit;color: #colorText#;">Add Item to Cart</a>
																</td>
															</tr>
														</cfloop>
														<cfset skuIDList = skuIDArray.toList()>
													</table>
												</div>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</td>
			</tr>
		</tbody>
	</table>
	
	<table class="email_table" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
		<tbody>
			<tr>
				<td class="email_body tc" style="box-sizing: border-box;vertical-align: top;line-height: 100%;text-align: center;padding-left: 16px;padding-right: 16px;background-color: #colorBackground#;">
					<div class="email_container" style="box-sizing: border-box;display: inline-block;width: 100%;vertical-align: top;max-width: 632px;margin: 0 auto;text-align: center;line-height: inherit;min-width: 0 !important;">
						<table class="content_section" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
							<tbody>
								<tr>
									<td class="content_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;background-color: #colorContainer#;text-align: center;padding-left: 16px;padding-right: 16px;line-height: inherit;min-width: 0 !important;">
										<!-- col-6 -->
										<div class="email_row" style="box-sizing: border-box;display: block;width: 100%;vertical-align: top;margin: 0 auto;text-align: center;clear: both;line-height: inherit;min-width: 0 !important;max-width: 600px !important;">
											<div class="col_6" style="box-sizing: border-box;display: inline-block;width: 100%;vertical-align: top;max-width: 600px;line-height: inherit;min-width: 0 !important;">
												<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%; margin-top: 15px;margin-bottom: 15px;">
													<tbody>
														<tr>
															<td class="column_cell px tc" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 16px;font-family: 'Miller-Banner-Roman', sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: center;padding-left: 16px;padding-right: 16px;text-align:left;">
																<!------- LINK ------->
															 <table class="ebtn" align="center" border="0" cellspacing="0" cellpadding="10" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;display: table;margin-left: auto;margin-right: auto;">
																	<tbody>
																		<tr>
																			<td class="success_b" style="box-sizing: border-box;vertical-align: top;background-color: #colorAccent#;line-height: 20px;font-family: 'Miller-Banner-Roman', sans-serif;mso-line-height-rule: exactly;border-radius: 4px;text-align: center;font-weight: bold;font-size: 17px;padding: 15px;"><a href="#local.siteLink#shopping-cart/?slataction=public:cart.addOrderItems&amp;skuIds=#skuIDList#&amp;showLogin=true&amp;abandonedCart=true&amp;utm_source=abandonedCart&amp;utm_medium=email&amp;utm_campaign=Abandoned%20Cart%20Promo%20Code" style="text-decoration: none;line-height: inherit;color: #colorContainer#;">Add All To Cart</a></td>
																		</tr>
																	</tbody>
																</table>
																
																<p class="mbe" style="font-family: 'Miller-Banner-Roman', sans-serif;font-size: 14px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 20px;text-align:left;">
																	<br/>
																	To contact us, simply reply to this message or use any of the following methods:<br/>
																	<span style="padding-left:15px;"><strong>E-mail:</strong> monatsupport@monatglobal.com</span><br/>
																	<span style="padding-left:15px;"><strong>Phone:</strong> (888) 867- 9987</span><br/>
																	<span style="padding-left:15px;"><strong>Address:</strong> 3450 NW 115th Ave, Doral, FL</span><br/>
																	<span style="padding-left:15px;"><strong>Online:</strong> #local.siteLink#</span><br/>
																</p>
															</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</td>
			</tr>
		</tbody>
	</table>
	
	<cfinclude template="../inc/footer.cfm" />
	</cfoutput>
</cfsavecontent>



<cfsavecontent variable="emailData.emailBodyText">
	<cfoutput>
		Dear #orderTemplate.getAccount().getFullName()#
		Thanks for visiting the Monat and creating a wish list. The current items on your wish list are included below.
		
		===========================================================================
		<cfloop array="#orderTemplate.getOrderTemplateItems()#" index="orderTemplateItem">
		#orderTemplateItem.getSku().getProduct().getTitle()#
		
		---------------------------------------------------------------------------
		</cfloop>
	
		To contact us, simply reply to this message or use any of the following methods:
		E-mail: monatsupport@monatglobal.com
		Phone: (888) 867- 9987
		Address: 3450 NW 115th Ave, Doral, FL
		Online: monat.com/store
	</cfoutput>
</cfsavecontent>