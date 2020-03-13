<cfoutput>
	<table class="email_table" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
		<tbody>
			<tr>
				<td class="email_body tc" style="box-sizing: border-box;vertical-align: top;line-height: 100%;text-align: center;padding-left: 16px;padding-right: 16px;font-size: 0 !important;">
					<!--[if (mso)|(IE)]><table width="632" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:632px;Margin:0 auto;"><tbody><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
					<div class="email_container" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 632px;margin: 0 auto;text-align: center;line-height: inherit;min-width: 0 !important;">
						<table class="content_section" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
							<tbody>
								<tr>
									<td class="content_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;;font-size: 0;text-align: center;padding-left: 16px;padding-right: 16px;line-height: inherit;min-width: 0 !important;">
										<!-- col-6 -->
										<div class="email_row" style="box-sizing: border-box;font-size: 0;display: block;width: 100%;vertical-align: top;margin: 0 auto;text-align: center;clear: both;line-height: inherit;min-width: 0 !important;max-width: 600px !important;">
										<!--[if (mso)|(IE)]><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:600px;Margin:0 auto 0 0;"><tbody><tr><td width="600" style="width:600px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
											<div class="col_6" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 600px;line-height: inherit;min-width: 0 !important;">
												<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
													<tbody>
														<tr>
															<td class="column_cell px tc" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 16px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;mso-line-height-rule: exactly;text-align: center;padding-left: 16px;padding-right: 16px;">
																
																<!------- MAIN HEADER ------->
																<h1 class="mb_xxs" style="margin-left: 0;margin-right: 0;margin-top: 25px;margin-bottom: 4px;padding: 0;font-weight: bold;font-size: 32px;line-height: 42px;">Order Confirmation</h1>
																
																<!------- SUB-HEADER ------->
																<p class="mbe" style="font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 20px;">Thank you for your order, #order.getAccount().getFirstName()# #order.getAccount().getLastName()#! </p>
																
																<!------- ORDER NUMBER ------->
																<h4 class="mb_xxs mte" style="margin-left: 0;margin-right: 0;margin-top: 0;margin-bottom: 4px;padding: 0;font-weight: bold;font-size: 19px;line-height: 25px;">Order &##35;#order.getOrderNumber()#</h4>
																
																<!------- ORDER PLACED DATE ------->
																<p class="small tm" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 20px;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 16px;">Placed on #DateFormat(order.getOrderOpenDateTime(), "m/d/yyyy")# - #TimeFormat(order.getOrderOpenDateTime(), "short")#</p>
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
				<td class="email_body tc" style="box-sizing: border-box;vertical-align: top;line-height: 100%;text-align: center;padding-left: 16px;padding-right: 16px;font-size: 0 !important;">
					<!--[if (mso)|(IE)]><table width="632" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:632px;Margin:0 auto;"><tbody><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
					<div class="email_container" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 632px;margin: 0 auto;text-align: center;line-height: inherit;min-width: 0 !important;">
						<table class="content_section" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
							<tbody>
								<tr>
									<td class="content_cell pb" style="box-sizing: border-box;vertical-align: top;width: 100%;font-size: 0;text-align: center;line-height: inherit;min-width: 0 !important; padding: 25px 16px 0;">
										<!-- col-6 -->
										<div class="email_row" style="box-sizing: border-box;font-size: 0;display: block;width: 100%;vertical-align: top;margin: 0 auto;text-align: center;clear: both;line-height: inherit;min-width: 0 !important;max-width: 600px !important;">
										<!--[if (mso)|(IE)]><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:600px;Margin:0 auto;"><tbody><tr><td width="400" style="width:300px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
											<div class="col_3" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 300px;line-height: inherit;min-width: 0 !important;">
												<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
													<tbody>
														<tr>
															<td class="column_cell px pt_0 pb_0 tl" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 5px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;mso-line-height-rule: exactly;text-align: left;padding-left: 16px;padding-right: 16px;">
																<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 23px;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">Order Summary</p>
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
															<td class="column_cell px pt_0 tr ord_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 5px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;mso-line-height-rule: exactly;text-align: right;padding-left: 16px;padding-right: 16px;">
																<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 23px;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">Options</p>
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
															<td class="column_cell px pt_0 tr ord_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 5px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;mso-line-height-rule: exactly;text-align: right;padding-left: 16px;padding-right: 16px;">
																<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 23px;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">Price</p>
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
															<td class="column_cell px pt_0 tr ord_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 5px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;mso-line-height-rule: exactly;text-align: right;padding-left: 16px;padding-right: 16px;">
																<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 23px;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">Total</p>
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
				<td class="email_body tc" style="box-sizing: border-box;vertical-align: top;line-height: 100%;text-align: center;padding-left: 16px;padding-right: 16px;font-size: 0 !important;">
					<!--[if (mso)|(IE)]><table width="632" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:632px;Margin:0 auto;"><tbody><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
					<div class="email_container" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 632px;margin: 0 auto;text-align: center;line-height: inherit;min-width: 0 !important;">
						<table class="content_section" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
							<tbody>
								<tr>
									<td class="content_cell pb" style="box-sizing: border-box;vertical-align: top;width: 100%;font-size: 0;text-align: center;padding-left: 16px;padding-right: 16px;padding-bottom: 16px;line-height: inherit;min-width: 0 !important;">
										
										<!------- ORDER ITEM LOOP ------->
										<cfloop array="#order.getOrderItems()#" index="local.orderItem">
											<!-- col-6 -->
											<div class="email_row" style="box-sizing: border-box;font-size: 0;display: block;width: 100%;vertical-align: top;margin: 0 auto;text-align: center;clear: both;line-height: inherit;min-width: 0 !important;max-width: 600px !important; border-top: 1px solid #colorRule#; padding:16px 0;">
											<!--[if (mso)|(IE)]><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:600px;Margin:0 auto;"><tbody><tr><td width="100" style="width:100px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
												
												<!--[if (mso)|(IE)]></td><td width="300" style="width:300px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
												<div class="col_3" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 300px;line-height: inherit;min-width: 0 !important;">
													<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
														<tbody>
															<tr>
																<td class="column_cell px pt_0 pb_0 tl" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 0;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;mso-line-height-rule: exactly;text-align: left;padding-left: 16px;padding-right: 16px;">
																	
																	<!------- PRODUCT TITLE AND QUANTITY ------->
																	<h5 class="mt_xs mb_xxs" style="margin-left: 0;margin-right: 0;margin-top: 8px;margin-bottom: 4px;padding: 0;font-weight: bold;font-size: 16px;line-height: 21px;">#local.orderItem.getSku().getProduct().getTitle()# <span class="tm" style="color: #colorLighterText#;line-height: inherit;">x #NumberFormat(local.orderItem.getQuantity())# </span></h5>
																	
																	<!------- PRODUTC SKU ------->
																	<p class="small tm mb_0" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 20px;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 0;">SKU: #local.orderItem.getSku().getSkuCode()#</p>
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
																<td class="column_cell px pt_0 tr ord_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 0;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;mso-line-height-rule: exactly;text-align: right;padding-left: 0;">
																	
																	<!------- ITEM OPTIONS ------->
																	<cfif len(local.orderItem.getSku().displayOptions())>
																		<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 15px;line-height: 22px;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">#local.orderItem.getSku().displayOptions()#</p>
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
																<td class="column_cell px pt_0 tr ord_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;mso-line-height-rule: exactly;text-align: right;padding: 0 16px;">
																	
																	<!------- ITEM PRICE ------->
																	<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">#local.orderItem.getFormattedValue('price', 'currency')#</p>
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
																<td class="column_cell px pt_0 tr ord_cell" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 0;padding-bottom: 16px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;mso-line-height-rule: exactly;text-align: right;padding-left: 16px;">
																	
																	<!------- ITEM TOTAL ------->
																	<p class="mb_0 mt_xs" style="font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;mso-line-height-rule: exactly;display: block;margin-top: 8px;margin-bottom: 0;">
																		<cfif orderItem.getDiscountAmount() GT 0>
																			<span style="text-decoration:line-through; color:##cc0000;">#orderItem.getFormattedValue('extendedPrice', 'currency')#</span><br />
																			#local.orderItem.getFormattedValue('extendedPriceAfterDiscount', 'currency')#
																		<cfelse>
																			#local.orderItem.getFormattedValue('extendedPrice', 'currency')#
																		</cfif>
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


	<!-- order_total_alt -->
	<table class="email_table" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
		<tbody>
			<tr>
				<td class="email_body tc" style="box-sizing: border-box;vertical-align: top;line-height: 100%;text-align: center;padding-left: 16px;padding-right: 16px;font-size: 0 !important;">
					<!--[if (mso)|(IE)]><table width="632" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:632px;Margin:0 auto;"><tbody><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
					<div class="email_container" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 632px;margin: 0 auto;text-align: center;line-height: inherit;min-width: 0 !important;">
						<table class="content_section" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
							<tbody>
								<tr>
									<td class="content_cell pb" style="box-sizing: border-box;vertical-align: top;width: 100%;font-size: 0;text-align: center;padding-left: 16px;padding-right: 16px;padding-bottom: 16px;line-height: inherit;min-width: 0 !important;">
										<!-- col-6 -->
										<div class="email_row tr" style="box-sizing: border-box;font-size: 0;display: block;width: 100%;vertical-align: top;margin: 0 auto;text-align: right;clear: both;line-height: inherit;min-width: 0 !important;max-width: 600px !important;">
										<!--[if (mso)|(IE)]><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="vertical-align:top;width:600px;Margin:0 auto;"><tbody><tr><td width="100" style="width:100px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
											
						
											
											<!--[if (mso)|(IE)]></td><td width="300" style="width:300px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
											<div class="col_3" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 300px;line-height: inherit;min-width: 0 !important;">
												<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
													<tbody>
														<tr>
															<td class="column_cell px tl" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 16px;padding-bottom: 16px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;mso-line-height-rule: exactly;text-align: left;padding-left: 16px;padding-right: 16px;">
																<cfloop array="#order.getOrderFulfillments()#" index="local.orderFulfillment">
																	
																<!------- ORDER FULFILLMENT = SHIPPING ------->
																<cfif local.orderFulfillment.getFulfillmentMethodType() EQ "shipping">
																	<table class="ncard" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt; margin-bottom: 16px;">
																		<tbody>
																			<tr>
																				<td class="ncard_c px pt light_b" style="box-sizing: border-box;vertical-align: top;overflow: hidden;border-radius: 4px;padding-left: 16px;padding-right: 16px;padding-top: 16px;line-height: inherit;font-family: Helvetica, Arial, sans-serif;">
																					<cfif not local.orderFulfillment.getAddress().getNewFlag()>
																						<h6 style="margin-left: 0;margin-right: 0;margin-top: 0;margin-bottom: 5px;padding: 0;font-weight: bold;font-size: 13px;line-height: 20px;">Shipping Address</h6>
																						<p class="small" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 20px;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 16px;">
																							<cfif len(local.orderFulfillment.getAddress().getName())>#local.orderFulfillment.getAddress().getName()#<br /></cfif>
																							<cfif len(local.orderFulfillment.getAddress().getStreetAddress())>#local.orderFulfillment.getAddress().getStreetAddress()#<br /></cfif>
																							<cfif len(local.orderFulfillment.getAddress().getStreet2Address())>#local.orderFulfillment.getAddress().getStreet2Address()#<br /></cfif>
																							#local.orderFulfillment.getAddress().getCity()#, #local.orderFulfillment.getAddress().getStateCode()# #local.orderFulfillment.getAddress().getPostalCode()#<br />
																							#local.orderFulfillment.getAddress().getCountryCode()#
																						</p>
																					</cfif>
																					<cfif not isNull(local.orderFulfillment.getShippingMethod())>
																						<h6 style="margin-left: 0;margin-right: 0;margin-top: 20px;margin-bottom: 5px;padding: 0;font-weight: bold;font-size: 13px;line-height: 20px;">Shipping Method</h6>
																						<p class="small" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 20px;color: #colorLighterText#;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 16px;">#local.orderFulfillment.getShippingMethod().getShippingMethodName()#</p>
																					</cfif>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																	
																<!------- ORDER FULFILLMENT = EMAIL ------->
																<cfelseif orderFulfillment.getFulfillmentMethodType() EQ "email">
																	<table class="ncard" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt; margin-bottom: 16px;">
																		<tbody>
																			<tr>
																				<td class="ncard_c px pt light_b" style="box-sizing: border-box;vertical-align: top;overflow: hidden;border-radius: 4px;padding-left: 16px;padding-right: 16px;padding-top: 16px;line-height: inherit;font-family: Helvetica, Arial, sans-serif;">
																					<h6 style="margin-left: 0;margin-right: 0;margin-top: 0;margin-bottom: 5px;padding: 0;font-weight: bold;font-size: 13px;line-height: 20px;">Delivery Email</h6>
																					<p class="small" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 20px;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 16px;">#orderFulfillment.getEmailAddress()#</p>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																	
																<!------- ORDER FULFILLMENT = AUTO ------->
																<cfelseif orderFulfillment.getFulfillmentMethodType() EQ "auto">
																	<table class="ncard" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt; margin-bottom: 16px;">
																		<tbody>
																			<tr>
																				<td class="ncard_c px pt light_b" style="box-sizing: border-box;vertical-align: top;overflow: hidden;border-radius: 4px;padding-left: 16px;padding-right: 16px;padding-top: 16px;line-height: inherit;font-family: Helvetica, Arial, sans-serif;">
																					<h6 style="margin-left: 0;margin-right: 0;margin-top: 0;margin-bottom: 5px;padding: 0;font-weight: bold;font-size: 13px;line-height: 20px;">Auto Fulfilled</h6>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</cfif>
																</cfloop>
															</td>
														</tr>
													</tbody>
												</table>
											</div>
											
											<!--[if (mso)|(IE)]></td><td width="300" style="width:300px;line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
											<div class="col_3" style="box-sizing: border-box;font-size: 0;display: inline-block;width: 100%;vertical-align: top;max-width: 300px;line-height: inherit;min-width: 0 !important;">
												<table class="column" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;width: 100%;min-width: 100%;">
													<tbody>
														<tr>
															<td class="column_cell px tl" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 16px;padding-bottom: 16px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;mso-line-height-rule: exactly;text-align: left;padding-left: 16px;padding-right: 16px;">
																<table class="ncard" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;">
																	<tbody>
																		<tr>
																			<td class="ncard_c px pt light_b" style="box-sizing: border-box;vertical-align: top;overflow: hidden;border-radius: 4px;padding-left: 16px;padding-right: 16px;padding-top: 16px;line-height: inherit;font-family: Helvetica, Arial, sans-serif;">
																				
																				<!------- SUBTOTAL ------->
																				<p class="mb_xxs small" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 20px;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 4px;"><span class="tm" style="color: #colorLighterText#;line-height: inherit;">Subtotal</span> <span style="float: right; text-align: right;">#order.getFormattedValue('subtotal', 'currency')#</span></p>
																				
																				<!------- DELIVERY CHARGES ------->
																				<p class="mb_xxs small" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 20px;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 4px;"><span class="tm" style="color: #colorLighterText#;line-height: inherit;">Delivery Charges</span> <span style="float: right; text-align: right;">#order.getFormattedValue('fulfillmentTotal', 'currency')#</span></p>
																				
																				<!------- TAX ------->
																				<p class="mb_xxs small" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 20px;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 4px;"><span class="tm" style="color: #colorLighterText#;line-height: inherit;">Tax</span> <span style="float: right; text-align: right;">#order.getFormattedValue('taxTotal', 'currency')#</span></p>
																				
																				<!------- DISCOUNTS ------->
																				<cfif order.getDiscountTotal()>
																					<p class="mb_xxs small" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 20px;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 4px;"><span class="tm" style="color: #colorLighterText#;line-height: inherit;">Discounts</span> <span style="float: right; text-align: right;">-#order.getFormattedValue('discountTotal', 'currency')#</span></p>
																				</cfif>
																				
																				<!------- TOTAL ------->
																				<p class="mt_0 mb" style="font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;mso-line-height-rule: exactly;display: block;margin-top: 16px;margin-bottom: 16px;border-top: 1px solid #colorRule#;padding-top:16px;"><strong>Total</strong> <span class="tp" style="color: #colorAccent#;line-height: inherit; float:right; text-align: right;">#order.getFormattedValue('total', 'currency')#</span></p>
																			</td>
																		</tr>
																	</tbody>
																</table>
															</td>
														</tr>
														
														<!------- PAYMENTS METHODS ------->
														<cfif arrayLen(order.getOrderPayments())>
															<tr>
																<td class="column_cell px tl" style="box-sizing: border-box;vertical-align: top;width: 100%;min-width: 100%;padding-top: 16px;padding-bottom: 16px;font-family: Helvetica, Arial, sans-serif;font-size: 16px;line-height: 23px;mso-line-height-rule: exactly;text-align: left;padding-left: 16px;padding-right: 16px;">
																	<table class="ncard" width="100%" border="0" cellspacing="0" cellpadding="0" style="box-sizing: border-box;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;">
																		<tbody>
																			<tr>
																				<td class="ncard_c px pt" style="box-sizing: border-box;vertical-align: top;overflow: hidden;border-radius: 4px;padding:0 16px;line-height: inherit;font-family: Helvetica, Arial, sans-serif;">
																					<p class="mb_xxs small" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 20px;mso-line-height-rule: exactly;display: block;margin-top: 0;border-bottom: 1px solid #colorRule#; padding-bottom: 5px; margin-bottom: 10px;"><span class="tm" style="color: #colorLighterText#;line-height: inherit;">Payment Method</span> <span class="tm" style="float: right; text-align: right;">Amount</span></p>
																					
																					<!------- PAYMENT METHOD LOOP ------->
																					<cfloop array="#order.getOrderPayments()#" index="orderPayment">
																					<cfif orderPayment.getOrderPaymentStatusType().getSystemCode() EQ "opstActive">
																						<p class="mb_xxs small" style="font-family: Helvetica, Arial, sans-serif;font-size: 14px;line-height: 20px;mso-line-height-rule: exactly;display: block;margin-top: 0;margin-bottom: 4px;"><span  style="line-height: inherit;">#orderPayment.getPaymentMethod().getPaymentMethodName()#</span> <span style="float: right; text-align: right;">#orderPayment.getFormattedValue('amount', 'currency')#</span></p>
																					</cfif>
																					</cfloop>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</td>
															</tr>
														</cfif>
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
</cfoutput>
