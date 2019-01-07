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
<cfparam name="orderDelivery" type="any" />

<cfsavecontent variable="emailData.emailBodyHTML">
	<cfoutput>
		<cfinclude template="../inc/header.cfm" />
		
		<table class="email_table" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
		<tbody>
			<tr>
				<td class="email_body tc" style="box-sizing: border-box;vertical-align: top;line-height: 100%;text-align: center;padding-left: 16px;padding-right: 16px;background-color: #colorBackground#;font-size: 0 !important;">
					<!--[if (mso)|(IE)]><table width="632" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:632px;Margin:0 auto;"><tbody><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
					<div class="email_container" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 632px;margin: 0 auto;text-align: center;line-height: inherit;min-width: 0 !important;">
						<table class="content_section" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
							<tbody>
								<tr>
									<td class="content_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;background-color: #colorContainerAccent#;font-size: 0;text-align: center;padding-left: 16px;padding-right: 16px;line-height: inherit;min-width: 0 !important;">
										<!-- col-6 -->
										<div class="email_row" style="box-sizing: border-box;font-size: 0;display: block;width: 100%;vertical-align: top;margin: 0 auto;text-align: center;clear: both;line-height: inherit;min-width: 0 !important;max-width: 600px !important;">
										<!--[if (mso)|(IE)]><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:600px;Margin:0 auto 0 0;"><tbody><tr><td width="600" style="width:600px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
											<div class="col_6" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 600px;line-height: inherit;min-width: 0 !important;">
												<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
													<tbody>
														<tr>
															<td class="column_cell px tc" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 16px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: center;padding-left: 16px;padding-right: 16px;">
																
																
																<!------- MAIN HEADER ------->
																<h1 class="mb_xxs" style="color: #colorHeaderText#;margin-left: 0;margin-right: 0;margin-top: 25px;margin-bottom: 4px;padding: 0;font-weight: bold;font-size: 32px;line-height: 42px;">Order Delivery Confirmation</h1>
															
																<!------- ORDER NUMBER ------->
																<h4 class="mb_xxs mte" style="color: #colorAccent#;margin-left: 0;margin-right: 0;margin-top: 0;margin-bottom: 4px;padding: 0;font-weight: bold;font-size: 19px;line-height: 25px;">Order &##35;#orderDelivery.getOrder().getOrderNumber()#</h4>
																
																<!------- ORDER PLACED DATE ------->
																<p class="small tm" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 20px;color: #colorLighterText#;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 16px;">Placed on #DateFormat(orderDelivery.getOrder().getOrderOpenDateTime(), "m/d/yyyy")# - #TimeFormat(orderDelivery.getOrder().getOrderOpenDateTime(), "short")#</p>
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
				<td class="email_body tc" style="box-sizing: border-box;vertical-align: top;line-height: 100%;text-align: center;padding-left: 16px;padding-right: 16px;background-color: #colorBackground#;font-size: 0 !important;">
					<!--[if (mso)|(IE)]><table width="632" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:632px;Margin:0 auto;"><tbody><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
					<div class="email_container" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 632px;margin: 0 auto;text-align: center;line-height: inherit;min-width: 0 !important;">
						<table class="content_section" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
							<tbody>
								<tr>
									<td class="content_cell pb" style="box-sizing: border-box;vertical-align: top;width: 100%;background-color: #colorContainer#;font-size: 0;text-align: center;line-height: inherit;min-width: 0 !important; padding: 25px 16px 0;">
										<!-- col-6 -->
										<div class="email_row" style="box-sizing: border-box;font-size: 0;display: block;width: 100%;vertical-align: top;margin: 0 auto;text-align: center;clear: both;line-height: inherit;min-width: 0 !important;max-width: 600px !important;">
										<!--[if (mso)|(IE)]><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:600px;Margin:0 auto;"><tbody><tr><td width="400" style="width:300px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
											<div class="col_3" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 300px;line-height: inherit;min-width: 0 !important;">
												<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
													<tbody>
														<tr>
															<td class="column_cell px pt_0 pb_0 tl" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 5px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: left;padding-left: 16px;padding-right: 16px;">
																<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 23px;color: #colorLighterText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">Order Summary</p>
															</td>
														</tr>
													</tbody>
												</table>
											</div>
											<!--[if (mso)|(IE)]></td><td width="100" style="width:100px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
											<div class="col_1 hide" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 100px;line-height: inherit;min-width: 0 !important;">
												<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
													<tbody>
														<tr>
															<td class="column_cell px pt_0 tr ord_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 5px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: right;padding-left: 16px;padding-right: 16px;">
																<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 23px;color: #colorLighterText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">Options</p>
															</td>
														</tr>
													</tbody>
												</table>
											</div>
											<!--[if (mso)|(IE)]></td><td width="100" style="width:100px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
											<div class="col_1 hide" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 100px;line-height: inherit;min-width: 0 !important;">
												<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
													<tbody>
														<tr>
															<td class="column_cell px pt_0 tr ord_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 5px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: right;padding-left: 16px;padding-right: 16px;">
																<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 23px;color: #colorLighterText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">Price</p>
															</td>
														</tr>
													</tbody>
												</table>
											</div>
										<!--[if (mso)|(IE)]></td><td width="100" style="width:100px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
											<div class="col_1 hide" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 100px;line-height: inherit;min-width: 0 !important;">
												<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
													<tbody>
														<tr>
															<td class="column_cell px pt_0 tr ord_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 5px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: right;padding-left: 16px;padding-right: 16px;">
																<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 23px;color: #colorLighterText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">Total</p>
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
	<!-- order_product_small -->
	<table class="email_table" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
		<tbody>
			<tr>
				<td class="email_body tc" style="box-sizing: border-box;vertical-align: top;line-height: 100%;text-align: center;padding-left: 16px;padding-right: 16px;background-color: #colorBackground#;font-size: 0 !important;">
					<!--[if (mso)|(IE)]><table width="632" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:632px;Margin:0 auto;"><tbody><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
					<div class="email_container" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 632px;margin: 0 auto;text-align: center;line-height: inherit;min-width: 0 !important;">
						<table class="content_section" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
							<tbody>
								<tr>
									<td class="content_cell pb" style="box-sizing: border-box;vertical-align: top;width: 100%;background-color: #colorContainer#;font-size: 0;text-align: center;padding-left: 16px;padding-right: 16px;padding-bottom: 16px;line-height: inherit;min-width: 0 !important;">
										
										
										<!------- ORDER ITEM LOOP ------->
										<cfloop array="#orderDelivery.getOrderDeliveryItems()#" index="local.orderDeliveryItem">
											<!-- col-6 -->
											<div class="email_row" style="box-sizing: border-box;font-size: 0;display: block;width: 100%;vertical-align: top;margin: 0 auto;text-align: center;clear: both;line-height: inherit;min-width: 0 !important;max-width: 600px !important; border-top: 1px solid #colorRule#; padding:16px 0;">
											<!--[if (mso)|(IE)]><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:600px;Margin:0 auto;"><tbody><tr><td width="100" style="width:100px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
												
												<!--[if (mso)|(IE)]></td><td width="300" style="width:300px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
												<div class="col_3" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 300px;line-height: inherit;min-width: 0 !important;">
													<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
														<tbody>
															<tr>
																<td class="column_cell px pt_0 pb_0 tl" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 0;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: left;padding-left: 16px;padding-right: 16px;">
																	
																	<!------- PRODUCT TITLE AND QUANTITY ------->
																	<h5 class="mt_xs mb_xxs" style="color: #colorHeaderText#;margin-left: 0;margin-right: 0;margin-top: 8px;margin-bottom: 4px;padding: 0;font-weight: bold;font-size: 16px;line-height: 21px;">#local.orderDeliveryItem.getOrderItem().getSku().getProduct().getTitle()# <span class="tm" style="color: #colorLighterText#;line-height: inherit;">x #NumberFormat(local.orderDeliveryItem.getOrderItem().getQuantity())# </span></h5>
																	
																	<!------- PRODUCT SKU ------->
																	<p class="small tm mb_0" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 20px;color: #colorLighterText#;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 0;">SKU: #local.orderDeliveryItem.getOrderItem().getSku().getSkuCode()#</p>
																</td>
															</tr>
														</tbody>
													</table>
												</div>
												<!--[if (mso)|(IE)]></td><td width="100" style="width:100px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
												<div class="col_1" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 100px;line-height: inherit;min-width: 0 !important;">
													<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
														<tbody>
															<tr>
																<td class="column_cell px pt_0 tr ord_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 0;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: right;padding-left: 0;">
																	
																	<!------- ITEM OPTIONS ------->
																	<cfif len(local.orderDeliveryItem.getOrderItem().getSku().displayOptions())>
																		<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 15px;line-height: 22px;color: #colorLighterText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">#local.orderDeliveryItem.getOrderItem().getSku().displayOptions()#</p>
																	</cfif>
																</td>
															</tr>
														</tbody>
													</table>
												</div>
												<!--[if (mso)|(IE)]></td><td width="100" style="width:100px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
												<div class="col_1 hide" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 100px;line-height: inherit;min-width: 0 !important;">
													<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
														<tbody>
															<tr>
																<td class="column_cell px pt_0 tr ord_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: right;padding: 0 16px;">
																	
																	<!------- ITEM PRICE ------->
																	<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">#local.orderDeliveryItem.getOrderItem().getFormattedValue('price', 'currency')#</p>
																</td>
															</tr>
														</tbody>
													</table>
												</div>
											<!--[if (mso)|(IE)]></td><td width="100" style="width:100px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
												<div class="col_1" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 100px;line-height: inherit;min-width: 0 !important;">
													<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
														<tbody>
															<tr>
																<td class="column_cell px pt_0 tr ord_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 16px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: right;padding-left: 16px;">
																	
																	<!------- ITEM TOTAL ------->
																	<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;"><cfif local.orderDeliveryItem.getOrderItem().getDiscountAmount() GT 0>
																		<span style="text-decoration:line-through; color:##cc0000;">#local.orderDeliveryItem.getOrderItem().getFormattedValue('extendedPrice', 'currency')#</span><br />
																		#local.orderDeliveryItem.getOrderItem().getFormattedValue('extendedPriceAfterDiscount', 'currency')#
																	<cfelse>
																		#local.orderDeliveryItem.getOrderItem().getFormattedValue('extendedPrice', 'currency')#
																	</cfif></p>
																</td>
															</tr>
														</tbody>
													</table>
												</div>
											<!--[if (mso)|(IE)]></td></tr></tbody></table><![endif]-->
											</div>
										</cfloop>
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


	<!-- order_total_alt -->
	<table class="email_table" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
		<tbody>
			<tr>
				<td class="email_body tc" style="box-sizing: border-box;vertical-align: top;line-height: 100%;text-align: center;padding-left: 16px;padding-right: 16px;background-color: #colorBackground#;font-size: 0 !important;">
					<!--[if (mso)|(IE)]><table width="632" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:632px;Margin:0 auto;"><tbody><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
					<div class="email_container" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 632px;margin: 0 auto;text-align: center;line-height: inherit;min-width: 0 !important;">
						<table class="content_section" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
							<tbody>
								<tr>
									<td class="content_cell pb" style="box-sizing: border-box;vertical-align: top;width: 100%;background-color: #colorContainer#;font-size: 0;text-align: center;padding-left: 16px;padding-right: 16px;padding-bottom: 16px;line-height: inherit;min-width: 0 !important;">
										<!-- col-6 -->
										<div class="email_row tr" style="box-sizing: border-box;font-size: 0;display: block;width: 100%;vertical-align: top;margin: 0 auto;text-align: right;clear: both;line-height: inherit;min-width: 0 !important;max-width: 600px !important;">
										<!--[if (mso)|(IE)]><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:600px;Margin:0 auto 0 0;"><tbody><tr><td width="600" style="width:600px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
											<div class="col_6" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 600px;line-height: inherit;min-width: 0 !important;">
												<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
													<tbody>
														<tr>
															<td class="column_cell px tl" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 16px;padding-bottom: 16px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: left;padding-left: 16px;padding-right: 16px;">
															
																	<table class="ncard" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt; margin-bottom: 16px;">
																		<tbody>
																			<tr>
																				<td class="ncard_c px pt light_b" style="box-sizing: border-box;vertical-align: top;color: #colorText#;overflow: hidden;border-radius: 4px;background-color: #colorContainerAccent#;line-height: inherit;font-family: Helvetica, Arial, sans-serif;padding:16px;">
																					
																					<!------- DELIVERY METHOD ------->
																					<h6 style="color: #colorHeaderText#;margin-left: 0;margin-right: 0;margin-top: 0;margin-bottom: 5px;padding: 0;font-weight: bold;font-size: 13px;line-height: 20px;">Delivery Via: &nbsp;<span style="color: #colorLighterText#; font-weight:400; font-size:14px;">#orderDelivery.getFulfillmentMethod().getFulfillmentMethodName()#</span></h6>
																					
																					<!------- DELIVERY VIA EMAIL ------->
																					<cfif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() EQ "email">
																						<h6 style="color: #colorHeaderText#;margin-left: 0;margin-right: 0;margin-top: 0;margin-bottom: 5px;padding: 0;font-weight: bold;font-size: 13px;line-height: 20px;">Delivery Email: &nbsp;<span style="color: #colorLighterText#; font-weight:400; font-size:14px;">#orderDelivery.getOrderFulfillment().getEmailAddress()#</span></h6>
																						
																					<!------- PICKUP ------->
																					<cfelseif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() EQ "pickup">
																						<h6 style="color: #colorHeaderText#;margin-left: 0;margin-right: 0;margin-top: 0;margin-bottom: 5px;padding: 0;font-weight: bold;font-size: 13px;line-height: 20px;">Picked Up From: &nbsp;<span style="color: #colorLighterText#; font-weight:400; font-size:14px;">#orderDelivery.getLocation().getLocationName()#</span></h6>
																						
																					<!------- SHIPPING ------->
																					<cfelseif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() EQ "shipping">
																					
																					<!------- TRACKING NUMBER ------->
																					<cfif not isNull(orderDelivery.getTrackingNumber()) and len(orderDelivery.getTrackingNumber())>
																						<h6 style="color: #colorHeaderText#;margin-left: 0;margin-right: 0;margin-top: 0;margin-bottom: 5px;padding: 0;font-weight: bold;font-size: 13px;line-height: 20px;">Tracking Number: &nbsp;<span style="color: #colorLighterText#; font-weight:400; font-size:14px;">#orderDelivery.getTrackingNumber()#</span></h6>
																					</cfif>
																					
																					<!------- SHIPPING METHOD ------->
																					<cfif not isNull(orderDelivery.getShippingMethod())>
																						<h6 style="color: #colorHeaderText#;margin-left: 0;margin-right: 0;margin-top: 0;margin-bottom: 5px;padding: 0;font-weight: bold;font-size: 13px;line-height: 20px;">Shipping Method: &nbsp;<span style="color: #colorLighterText#; font-weight:400; font-size:14px;">#orderDelivery.getShippingMethod().getShippingMethodName()#</span></h6>
																					</cfif>
																					
																					<!------- SHIPPING ADDRESS ------->
																					<h6 style="color: #colorHeaderText#;margin-left: 0;margin-right: 0;margin-top: 0;margin-bottom: 5px;padding: 0;font-weight: bold;font-size: 13px;line-height: 20px;">Shipping Address: &nbsp;<span style="color: #colorLighterText#; font-weight:400; font-size:14px;"><cfif len(orderDelivery.getShippingAddress().getName())>#orderDelivery.getShippingAddress().getName()#, </cfif>
																					<cfif len(orderDelivery.getShippingAddress().getStreetAddress())>#orderDelivery.getShippingAddress().getStreetAddress()#, </cfif>
																					<cfif len(orderDelivery.getShippingAddress().getStreet2Address())>#orderDelivery.getShippingAddress().getStreet2Address()#, </cfif>
																					#orderDelivery.getShippingAddress().getCity()#, #orderDelivery.getShippingAddress().getStateCode()# #orderDelivery.getShippingAddress().getPostalCode()#
																					#orderDelivery.getShippingAddress().getCountryCode()#</span></h6>
																						
																					</cfif>
																				</td>
																			</tr>
																		</tbody>
																	</table>
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
					<!--[if (mso)|(IE)]></td></tr></tbody></table><![endif]-->
				</td>
			</tr>
		</tbody>
	</table>
		
	<cfinclude template="../inc/footer.cfm" />
	</cfoutput>
</cfsavecontent>

<cfsavecontent variable="emailData.emailBodyText">
	<cfoutput>
        Order Delivery Confirmation
        ---------------------------

        Order Number: #orderDelivery.getOrder().getOrderNumber()#
		Order Placed: #DateFormat(orderDelivery.getOrder().getOrderOpenDateTime(), "DD/MM/YYYY")# - #TimeFormat(orderDelivery.getOrder().getOrderOpenDateTime(), "short")#
		Customer: #orderDelivery.getOrder().getAccount().getFirstName()# #orderDelivery.getOrder().getAccount().getLastName()#

		Delivery Info:
		===========================================================================
		Delivered Via: #orderDelivery.getFulfillmentMethod().getFulfillmentMethodName()#
		<cfif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() EQ "email">
		Delivery Email: #orderDelivery.getOrderFulfillment().getEmailAddress()#
		<cfelseif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() EQ "pickup">
       	Picked Up From: #orderDelivery.getLocation().getLocationName()#
		<cfelseif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() EQ "shipping">
		<cfif not isNull(orderDelivery.getTrackingNumber()) and len(orderDelivery.getTrackingNumber())>
		Tracking Number : #orderDelivery.getTrackingNumber()#
		</cfif>
		<cfif not isNull(orderDelivery.getShippingMethod())>
		Shipping Method : #orderDelivery.getShippingMethod().getShippingMethodName()#
        Ship-To Address:
        <cfif len(orderDelivery.getShippingAddress().getName())>#orderDelivery.getShippingAddress().getName()#</cfif>
		<cfif len(orderDelivery.getShippingAddress().getStreetAddress())>#orderDelivery.getShippingAddress().getStreetAddress()#</cfif>
		<cfif len(orderDelivery.getShippingAddress().getStreet2Address())>#orderDelivery.getShippingAddress().getStreet2Address()#</cfif>
		#orderDelivery.getShippingAddress().getCity()#, #orderDelivery.getShippingAddress().getStateCode()# #orderDelivery.getShippingAddress().getPostalCode()#
		#orderDelivery.getShippingAddress().getCountryCode()#
		</cfif>
		</cfif>
		Items Delivered:
		===========================================================================
		<cfloop array="#orderDelivery.getOrderDeliveryItems()#" index="local.orderDeliveryItem">
		#local.orderDeliveryItem.getOrderItem().getSku().getProduct().getTitle()#
		<cfif len(local.orderDeliveryItem.getOrderItem().getSku().displayOptions())>#local.orderDeliveryItem.getOrderItem().getSku().displayOptions()#</cfif>
		#local.orderDeliveryItem.getOrderItem().getFormattedValue('price', 'currency')# | #NumberFormat(local.orderDeliveryItem.getOrderItem().getQuantity())# | #local.orderDeliveryItem.getOrderItem().getFormattedValue('extendedPrice', 'currency')#
		---------------------------------------------------------------------------
		</cfloop>


	</cfoutput>
</cfsavecontent>

