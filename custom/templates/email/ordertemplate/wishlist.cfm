<cfparam name="email" type="any" />	
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="order" type="any" />

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
															<td class="column_cell px tc" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding: 16px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: center;text-align:left;">
																
																<p class="mbe" style="font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 20px;text-align:left;">
																	Dear #order.getAccount().getFullName()#
																</p>
																
																<p class="mbe" style="font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 20px;text-align:left;">
																		Thanks for visiting the Monat and creating a wish list.
																</p>
																
																<p class="mbe" style="font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 20px;text-align:left;">
																	We hope you return soon to complete your purchase. To show our appreciation, we'd like to offer a one-time free shipping offer on your order!
																	Use the one-time free shipping code <strong>SHIPCART</strong> when you return and complete your order.
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
											<div class="col_1 hide" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 100px;line-height: inherit;min-width: 0 !important;">
												<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
													<tbody>
														<tr>
															<td class="column_cell px pt_0 pb_0 tl" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 5px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: left;padding-left: 16px;padding-right: 16px;">
																<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 23px;color: #colorLighterText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">
																	Product ID
																</p>
															</td>
														</tr>
													</tbody>
												</table>
											</div>
											<!--[if (mso)|(IE)]></td><td width="100" style="width:100px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
											<div class="col_3" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 200px;line-height: inherit;min-width: 0 !important;">
												<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
													<tbody>
														<tr>
															<td class="column_cell px pt_0 tr ord_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 5px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align:left;padding-left: 16px;padding-right: 16px;">
																<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 23px;color: #colorLighterText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">
																	Name
																</p>
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
																<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 23px;color: #colorLighterText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">
																	Quantity
																</p>
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
																<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 23px;color: #colorLighterText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">
																	Price
																</p>
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
																<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 23px;color: #colorLighterText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">
																	Amount
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
										<cfloop array="#order.getOrderItems()#" index="local.orderItem">
											<!-- col-6 -->
											<div class="email_row" style="box-sizing: border-box;font-size: 0;display: block;width: 100%;vertical-align: top;margin: 0 auto;text-align: center;clear: both;line-height: inherit;min-width: 0 !important;max-width: 600px !important; border-top: 1px solid #colorRule#; padding:16px 0;">
											<!--[if (mso)|(IE)]><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:600px;Margin:0 auto;"><tbody><tr><td width="100" style="width:100px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
												
												<!--[if (mso)|(IE)]></td><td width="100" style="width:100px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
												<div class="col_1" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 100px;line-height: inherit;min-width: 0 !important;">
													<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
														<tbody>
															<tr>
																<td class="column_cell px pt_0 tr ord_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 0;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: right;padding-left: 0;">
																	<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 15px;line-height: 22px;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">
																		#local.orderItem.getSku().getSkuCode()#
																	</p>
																</td>
															</tr>
														</tbody>
													</table>
												</div>
												<!--[if (mso)|(IE)]></td><td width="100" style="width:100px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
												<div class="col_2" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 200px;line-height: inherit;min-width: 0 !important;">
													<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
														<tbody>
															<tr>
																<td class="column_cell px pt_0 tr ord_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 0;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: left;padding-left: 10px;">
																	<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 15px;line-height: 22px;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">
																		#local.orderItem.getSku().getProduct().getTitle()#
																	</p>
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
																	<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 15px;line-height: 22px;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">
																		#local.orderItem.getQuantity()#
																	</p>
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
																	<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 15px;line-height: 22px;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">
																		#local.orderItem.getFormattedValue('price', 'currency')#
																	</p>
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
																	<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 15px;line-height: 22px;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">
																		#local.orderItem.getFormattedValue('extendedPrice', 'currency')#
																	</p>
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
	
	<table class="email_table" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
		<tbody>
			<tr>
				<td class="email_body tc" style="box-sizing: border-box;vertical-align: top;line-height: 100%;text-align: center;padding-left: 16px;padding-right: 16px;background-color: #colorBackground#;font-size: 0 !important;">
					<!--[if (mso)|(IE)]><table width="632" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:632px;Margin:0 auto;"><tbody><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
					<div class="email_container" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 632px;margin: 0 auto;text-align: center;line-height: inherit;min-width: 0 !important;">
						<table class="content_section" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
							<tbody>
								<tr>
									<td class="content_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;background-color: #colorContainer#;font-size: 0;text-align: center;padding-left: 16px;padding-right: 16px;line-height: inherit;min-width: 0 !important;">
										<!-- col-6 -->
										<div class="email_row" style="box-sizing: border-box;font-size: 0;display: block;width: 100%;vertical-align: top;margin: 0 auto;text-align: center;clear: both;line-height: inherit;min-width: 0 !important;max-width: 600px !important;">
										<!--[if (mso)|(IE)]><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:600px;Margin:0 auto 0 0;"><tbody><tr><td width="600" style="width:600px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
											<div class="col_6" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 600px;line-height: inherit;min-width: 0 !important;">
												<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
													<tbody>
														<tr>
															<td class="column_cell px tc" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 16px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;text-align: center;padding-left: 16px;padding-right: 16px;text-align:left;">
																<!------- LINK ------->
															 <table class="ebtn" align="center" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;display: table;margin-left: auto;margin-right: auto;">
																	<tbody>
																		<tr>
																			<td class="success_b" style="box-sizing: border-box;vertical-align: top;background-color: #colorAccent#;line-height: 20px;font-family: Helvetica, Arial, sans-serif;mso-line-height-rule: exactly;border-radius: 4px;text-align: center;font-weight: bold;font-size: 17px;padding: 13px 22px;"><a href="#storeLink#/shopping-cart/?slataction=public:cart.change&amp;orderId=#order.getOrderId()#&amp;showLogin=true&amp;abandonedCart=true&amp;utm_source=abandonedCart&amp;utm_medium=email&amp;utm_campaign=Abandoned%20Cart%20Promo%20Code" style="text-decoration: none;line-height: inherit;color: #colorContainer#;">Restore Cart &amp; Continue Shopping</a></td>
																		</tr>
																	</tbody>
																</table>
																
																<p class="mbe" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 20px;text-align:left;">
																	<br/>
																	To contact us, simply reply to this message or use any of the following methods:<br/>
																	<span style="padding-left:15px;"><strong>E-mail:</strong> monatsupport@monatglobal.com</span><br/>
																	<span style="padding-left:15px;"><strong>Phone:</strong> (888) 867- 9987</span><br/>
																	<span style="padding-left:15px;"><strong>Address:</strong> 3450 NW 115th Ave, Doral, FL</span><br/>
																	<span style="padding-left:15px;"><strong>Online:</strong> #storeLink#</span><br/>
																</p>
																<p class="mbe" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 23px;color: #colorText#;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 20px;text-align:left;">
																	When contacting us, please have this e-mail handy. We look forward to hearing from you!
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
	
	<cfinclude template="../inc/footer.cfm" />
	</cfoutput>
</cfsavecontent>



<cfsavecontent variable="emailData.emailBodyText">
	<cfoutput>
		Dear #order.getAccount().getFullName()#
		Thanks for visiting the Monat and creating a wish list. We hope you return soon to complete your purchase. To show our appreciation, we’d like to offer a one-time free shipping offer on your order!
		Use the one-time free shipping code SHIPCART when you return and complete your order.
		
		===========================================================================
		<cfloop array="#order.getOrderItems()#" index="orderItem">
		#orderItem.getSku().getProduct().getTitle()#
		<cfif len(orderItem.getSku().displayOptions())>#orderItem.getSku().displayOptions()#</cfif>
		#orderItem.getFormattedValue('price', 'currency')# | #NumberFormat(orderItem.getQuantity())# | #orderItem.getFormattedValue('extendedPrice', 'currency')# 
		---------------------------------------------------------------------------
		</cfloop>
	
		To contact us, simply reply to this message or use any of the following methods:
		E-mail: monatsupport@monatglobal.com
		Phone: (888) 867- 9987
		Address: 3450 NW 115th Ave, Doral, FL
		Online: monat.com/store

		When contacting us, please have this e-mail handy. We look forward to hearing from you!
	</cfoutput>
</cfsavecontent>

