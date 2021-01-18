<cfoutput>
<div style="background-color:transparent;">
    <div class="block-grid two-up" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: ##FFFFFF;">
        <div style="border-collapse: collapse;display: table;width: 100%;background-color:##FFFFFF;">
           <!--[if (mso)|(IE)]>
           <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;">
              <tr>
                 <td align="center">
                    <table cellpadding="0" cellspacing="0" border="0" style="width:600px">
                       <tr class="layout-full-width" style="background-color:##FFFFFF">
                          <![endif]-->
                          <!--[if (mso)|(IE)]>
                          <td align="center" width="300" style="background-color:##FFFFFF;width:300px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top">
                             <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                   <td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;">
                                      <![endif]-->
                                      <div class="col num6" style="max-width: 320px; min-width: 300px; display: table-cell; vertical-align: top; width: 300px;">
                                         <div style="width:100% !important;">
                                            <!--[if (!mso)&(!IE)]><!-->
                                            <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
                                               <!--<![endif]-->
                                               <!--[if mso]>
                                               <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                  <tr>
                                                     <td style="padding-right: 30px; padding-left: 30px; padding-top: 50px; padding-bottom: 50px; font-family: Arial, sans-serif">
                                                        <![endif]-->
                                                        <div style="color:##696969;font-family:Arial, 'Helvetica Neue', Helvetica, sans-serif;line-height:1.5;padding-top:50px;padding-right:30px;padding-bottom:50px;padding-left:30px;">
                                                           <div style="font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; font-size: 12px; line-height: 1.5; color: ##696969; mso-line-height-alt: 18px;">
                                                              <p style="font-size: 16px; line-height: 1.5; text-align: left; mso-line-height-alt: 24px; margin: 0; color: ##2f294b;"><strong>Billing Address</strong></p>
                                                              <p style="font-size: 14px; line-height: 1.5; text-align: left; mso-line-height-alt: 24px; margin: 0;">
															  #order.getAccount().getFirstName()# #order.getAccount().getLastName()#<br/>#order.getBillingAddress().getStreetAddress()# #order.getBillingAddress().getStreet2Address()#<br/> #order.getBillingAddress().getCity()#, #order.getBillingAddress().getStateCode()# #order.getBillingAddress().getPostalCode()# </br> #order.getBillingAddress().getCountryCode()#
                                                              </p>
                                                           </div>
                                                        </div>
                                                        <!--[if mso]>
                                                     </td>
                                                  </tr>
                                               </table>
                                               <![endif]-->
                                               <!--[if (!mso)&(!IE)]><!-->
                                            </div>
                                            <!--<![endif]-->
                                         </div>
                                      </div>
                                      <!--[if (mso)|(IE)]>
                                   </td>
                                </tr>
                             </table>
                             <![endif]-->
                             <!--[if (mso)|(IE)]>
                          </td>
                          
                          <td align="center" width="300" style="background-color:##FFFFFF;width:300px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top">
                             <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                   <td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;">
                                      <![endif]-->
                                      <cfloop array="#order.getOrderFulfillments()#" index="local.orderFulfillment">
	                                      <div class="col num6" style="max-width: 320px; min-width: 300px; display: table-cell; vertical-align: top; width: 300px;">
	                                         <div style="width:100% !important;">
	                                            <!--[if (!mso)&(!IE)]><!-->
	                                            <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
	                                               <!--<![endif]-->
	                                               <!--[if mso]>
	                                               <table width="100%" cellpadding="0" cellspacing="0" border="0">
	                                                  <tr>
	                                                     <td style="padding-right: 30px; padding-left: 30px; padding-top: 50px; padding-bottom: 50px; font-family: Arial, sans-serif">
	                                                        <![endif]-->
	                                                        <div style="color:##696969;font-family:Arial, 'Helvetica Neue', Helvetica, sans-serif;line-height:1.5;padding-top:50px;padding-right:30px;padding-bottom:50px;padding-left:30px;">
	                                                           <div style="font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; font-size: 12px; line-height: 1.5; color: ##696969; mso-line-height-alt: 18px;">
	                                                           	<!------- ORDER FULFILLMENT = SHIPPING ------->
																<cfif local.orderFulfillment.getFulfillmentMethodType() EQ "shipping">
																
																	<cfif not local.orderFulfillment.getAddress().getNewFlag()>
																		<p style="font-size: 16px; line-height: 1.5; text-align: left; mso-line-height-alt: 24px; margin: 0; color: ##2f294b;"><strong>Shipping Address</strong></p>
																		<p style="font-size: 14px; line-height: 1.5; text-align: left; mso-line-height-alt: 24px; margin: 0;">
																			<cfif len(local.orderFulfillment.getAddress().getName())>#local.orderFulfillment.getAddress().getName()#<br /></cfif>
																			<cfif len(local.orderFulfillment.getAddress().getStreetAddress())>#local.orderFulfillment.getAddress().getStreetAddress()#<br /></cfif>
																			<cfif len(local.orderFulfillment.getAddress().getStreet2Address())>#local.orderFulfillment.getAddress().getStreet2Address()#<br /></cfif>
																			#local.orderFulfillment.getAddress().getCity()#, #local.orderFulfillment.getAddress().getStateCode()# #local.orderFulfillment.getAddress().getPostalCode()#<br />
																			#local.orderFulfillment.getAddress().getCountryCode()#
																		</p>
																	</cfif>
																
																<!------- ORDER FULFILLMENT = EMAIL ------->
																<cfelseif orderFulfillment.getFulfillmentMethodType() EQ "email">
																	<p style="font-size: 14px; line-height: 1.5; text-align: left; mso-line-height-alt: 24px; margin: 0;">Delivery Email</p>
																	<p style="font-size: 14px; line-height: 1.5; text-align: left; mso-line-height-alt: 24px; margin: 0;">#orderFulfillment.getEmailAddress()#</p>
																
																<!------- ORDER FULFILLMENT = AUTO ------->
																<cfelseif orderFulfillment.getFulfillmentMethodType() EQ "auto">
																	<p style="font-size: 14px; line-height: 1.5; text-align: left; mso-line-height-alt: 24px; margin: 0;">Auto Fulfilled</p>
																</cfif>
	                                                              
	                                                           </div>
	                                                        </div>
	                                                        <!--[if mso]>
	                                                     </td>
	                                                  </tr>
	                                               </table>
	                                               <![endif]-->
	                                               <!--[if (!mso)&(!IE)]><!-->
	                                            </div>
	                                            <!--<![endif]-->
	                                         </div>
	                                      </div>
	                                  </cfloop>
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
                                   <td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;">
                                      <![endif]-->
                                      <div class="col num12" style="min-width: 320px; max-width: 600px; display: table-cell; vertical-align: top; width: 600px;">
                                         <div style="width:100% !important;">
                                            <!--[if (!mso)&(!IE)]><!-->
                                            <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
                                               <!--<![endif]-->
                                               <table border="0" cellpadding="0" cellspacing="0" class="divider" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;" valign="top" width="100%">
                                                  <tbody>
                                                     <tr style="vertical-align: top;" valign="top">
                                                        <td class="divider_inner" style="word-break: break-word; vertical-align: top; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-top: 10px; padding-right: 10px; padding-bottom: 10px; padding-left: 10px;" valign="top">
                                                           <table align="center" border="0" cellpadding="0" cellspacing="0" class="divider_content" height="0" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; border-top: 3px solid ##BBBBBB; height: 0px; width: 100%;" valign="top" width="100%">
                                                              <tbody>
                                                                 <tr style="vertical-align: top;" valign="top">
                                                                    <td height="0" style="word-break: break-word; vertical-align: top; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;" valign="top"><span></span></td>
                                                                 </tr>
                                                              </tbody>
                                                           </table>
                                                        </td>
                                                     </tr>
                                                  </tbody>
                                               </table>
                                               <div style="font-size:16px;text-align:center;font-family:Arial, 'Helvetica Neue', Helvetica, sans-serif">
                                                  <table style="font-family: helvetica, sans-serif; font-size: 12px; color:##696969; border-collapse: collapse; width: 93%; margin: 0 auto;">
                                                     <tr>
                                                        <th style="text-align: left; padding: 8px;">Order Number</th>
                                                        <cfif not isNull(order.getAccount().getAccountNumber()) && len(order.getAccount().getAccountNumber())>
                                                            <th style="text-align: center; padding: 8px;">Distributor ID</th>
                                                        </cfif>
                                                        <cfif not isNull(local.orderFulfillment) and not isNull(local.orderFulfillment.getShippingMethod())>
                                                        	<th style="text-align: center; padding: 8px;">Ship Via</th>
                                                        </cfif>
                                                        <cfif not isNull(order.getCommissionPeriod()) && len(order.getCommissionPeriod())>
                                                            <th style="text-align: center; padding: 8px;">Period</th>
                                                        </cfif>
                                                        <th style="text-align: right; padding: 8px;">Entry Date</th>
                                                     </tr>
                                                     <tr>
                                                        <td style="text-align: left; padding: 5px;">#order.getOrderNumber()#</td>
                                                        <cfif not isNull(order.getAccount().getAccountNumber()) && len(order.getAccount().getAccountNumber())>
                                                            <td style="text-align: center; padding: 5px;">#order.getAccount().getAccountNumber()#</td>
                                                        </cfif>
                                                        <cfif not isNull(local.orderFulfillment) and not isNull(local.orderFulfillment.getShippingMethod())>
                                                    		<td style="text-align: center; padding: 5px;">#local.orderFulfillment.getShippingMethod().getShippingMethodName()#</td>
                                                        </cfif>
                                                        <cfif not isNull(order.getCommissionPeriod()) && len(order.getCommissionPeriod())>
                                                            <td style="text-align: center; padding: 5px;">#order.getCommissionPeriod()#</td>
                                                        </cfif>
                                                        <td style="text-align: right; padding: 5px;">#DateFormat(order.getOrderOpenDateTime(), "m/d/yyyy")# - #TimeFormat(order.getOrderOpenDateTime(), "short")#</td>
                                                     </tr>
                                                  </table>
                                               </div>
                                               <table border="0" cellpadding="0" cellspacing="0" class="divider" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;" valign="top" width="100%">
                                                  <tbody>
                                                     <tr style="vertical-align: top;" valign="top">
                                                        <td class="divider_inner" style="word-break: break-word; vertical-align: top; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-top: 10px; padding-right: 10px; padding-bottom: 10px; padding-left: 10px;" valign="top">
                                                           <table align="center" border="0" cellpadding="0" cellspacing="0" class="divider_content" height="0" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; border-top: 3px solid ##BBBBBB; height: 0px; width: 100%;" valign="top" width="100%">
                                                              <tbody>
                                                                 <tr style="vertical-align: top;" valign="top">
                                                                    <td height="0" style="word-break: break-word; vertical-align: top; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;" valign="top"><span></span></td>
                                                                 </tr>
                                                              </tbody>
                                                           </table>
                                                        </td>
                                                     </tr>
                                                  </tbody>
                                               </table>
                                               <!--[if (!mso)&(!IE)]><!-->
                                            </div>
                                            <!--<![endif]-->
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
                                   <td style="padding-right: 0px; padding-left: 0px; padding-top:15px; padding-bottom:20px;">
                                      <![endif]-->
                                      <div class="col num12" style="min-width: 320px; max-width: 600px; display: table-cell; vertical-align: top; width: 600px;">
                                         <div style="width:100% !important;">
                                            <!--[if (!mso)&(!IE)]><!-->
                                            <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:15px; padding-bottom:20px; padding-right: 0px; padding-left: 0px;">
                                               <!--<![endif]-->
                                               <div style="font-size:16px;text-align:center;font-family:Arial, 'Helvetica Neue', Helvetica, sans-serif">
                                                  <table style="font-family: helvetica, sans-serif; font-size: 12px; color:##696969; border-collapse: collapse; width: 97%; margin: 0 auto;">
                                                     <tr>
                                                        <th style="text-align: left; padding: 15px 10px; background-color: ##2F294B; color:##fff; width: 20%">Item Code</th>
                                                        <th style="text-align: left; padding: 15px 5px; background-color: ##2F294B; color:##fff; width: 40%">Item Description</th>
                                                        <th style="text-align: center; padding: 15px 5px; background-color: ##2F294B; color:##fff; width: 20%">Quantity Ordered</th>
                                                        <th style="text-align: right; padding: 15px 10px; background-color: ##2F294B; color:##fff; width: 20%">Item Price</th>
                                                     </tr>
                                                     <!------- ORDER ITEM LOOP ------->
													<cfloop array="#order.getOrderItems()#" index="local.orderItem">
														<tr>
															<td style="text-align: left; padding: 10px 10px;">
																#local.orderItem.getSku().getSkuCode()#
															</td>
															<td style="text-align: left; padding: 10px 10px;">
																#local.orderItem.getSku().getProduct().getTitle()#<br />
																<!------- ITEM OPTIONS ------->
																<cfif len(local.orderItem.getSku().displayOptions())>
																	#local.orderItem.getSku().displayOptions()#
																</cfif>
															</td>
															<td style="text-align: center; padding: 10px 10px;">
																#NumberFormat(local.orderItem.getQuantity())#
															</td>
															<td style="text-align: right; padding: 10px 10px;">
																#local.orderItem.getFormattedValue('price', 'currency')#
															</td>
														</tr>
													</cfloop>
                                                  </table>
                                               </div>
                                               <!--[if (!mso)&(!IE)]><!-->
                                            </div>
                                            <!--<![endif]-->
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
                                   <td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;">
                                      <![endif]-->
                                      <div class="col num12" style="min-width: 320px; max-width: 600px; display: table-cell; vertical-align: top; width: 600px;">
                                         <div style="width:100% !important;">
                                            <!--[if (!mso)&(!IE)]><!-->
                                            <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
                                               <!--<![endif]-->
                                               <!--[if mso]>
                                               <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                  <tr>
                                                     <td style="padding-right: 30px; padding-left: 30px; padding-top: 10px; padding-bottom: 20px; font-family: Arial, sans-serif">
                                                        <![endif]-->
                                                        <div style="color:##696969;font-family:Arial, 'Helvetica Neue', Helvetica, sans-serif;line-height:1.5;padding-top:10px;padding-right:30px;padding-bottom:20px;padding-left:30px;">
                                                           <div style="font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; font-size: 12px; line-height: 1.5; color: ##696969; mso-line-height-alt: 18px;">
                                                              <p style="font-size: 12px; line-height: 1.5; text-align: right; mso-line-height-alt: 18px; margin: 0;"><span style="color: ##2f294b; font-size: 12px;"><strong><span style="font-size: 16px;">Sub Total: #order.getFormattedValue('subtotal', 'currency')#</span></strong></span></p>
                                                              <p style="font-size: 14px; line-height: 1.5; text-align: right; mso-line-height-alt: 21px; margin: 0;"><span style="font-size: 14px;">Shipping: #order.getFormattedValue('fulfillmentChargeTotalBeforeHandlingFees', 'currency')#</span></p>
                                                              <p style="font-size: 14px; line-height: 1.5; text-align: right; mso-line-height-alt: 21px; margin: 0;"><span style="font-size: 14px;">Handling: #order.getFormattedValue('fulfillmentHandlingFeeTotal', 'currency')#</span></p>
                                                              <cfif order.getDiscountTotal()>
																	<p style="font-size: 14px; line-height: 1.5; text-align: right; mso-line-height-alt: 21px; margin: 0;"><span style="font-size: 14px;">Discount: -#order.getFormattedValue('discountTotal', 'currency')#</span></p>
                                                              </cfif>
                                                              <p style="font-size: 14px; line-height: 1.5; text-align: right; mso-line-height-alt: 21px; margin: 0;"><span style="font-size: 14px;">Total Amount: #order.getFormattedValue('total', 'currency')#</span></p>
                                                                <p style="font-size: 14px; line-height: 1.5; text-align: right; mso-line-height-alt: 21px; margin: 0;">
                                                                    <cfif order.getVATTotal()>
                                                                        <span style="font-size: 14px;">VAT Total: #order.getVATTotal()#</span>
                                                                    <cfelse>
                                                                        <span style="font-size: 14px;">Tax Total: #order.getTaxTotal()#</span>
                                                                    </cfif>
                                                                </p>
                                                              <p style="font-size: 14px; line-height: 1.5; text-align: right; mso-line-height-alt: 21px; margin: 0;"><span style="font-size: 14px;">Paid Amount: #order.getFormattedValue('paymentAmountTotal','currency')#</span></p>
                                                           </div>
                                                        </div>
                                                        <!--[if mso]>
                                                     </td>
                                                  </tr>
                                               </table>
                                               <![endif]-->

												<!--[if (!mso)&(!IE)]><!-->
                                            </div>
                                            <!--<![endif]-->
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

</cfoutput>
