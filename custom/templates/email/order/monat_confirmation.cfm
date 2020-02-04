<cfparam name="email" type="any" />	
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="order" type="any" />

<cfset accountType = order.getAccount().getAccountType() ?: 'customer' />

<cfinclude template="../inc/header.cfm" />

<table bgcolor="#FFFFFF" cellpadding="0" cellspacing="0" class="nl-container" role="presentation" style="table-layout: fixed; vertical-align: top; min-width: 320px; Margin: 0 auto; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; background-color: #FFFFFF; width: 100%;"
        valign="top" width="100%">
        <tbody>
            <tr style="vertical-align: top;" valign="top">
                <td style="word-break: break-word; vertical-align: top; border-collapse: collapse;" valign="top">
                    <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td align="center" style="background-color:#FFFFFF"><![endif]-->
                    <div style="background-color:transparent;">
                        <div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;;">
                            <div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
                                <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:600px"><tr class="layout-full-width" style="background-color:transparent"><![endif]-->
                                <!--[if (mso)|(IE)]><td align="center" width="600" style="background-color:transparent;width:600px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:0px; padding-bottom:0px;"><![endif]-->
                                <div class="col num12" style="min-width: 320px; max-width: 600px; display: table-cell; vertical-align: top;;">
                                    <div style="width:100% !important;">
                                        <!--[if (!mso)&(!IE)]><!-->
                                        <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:0px; padding-bottom:0px; padding-right: 0px; padding-left: 0px;">
                                            <!--<![endif]-->
                                            <div align="center" class="img-container center autowidth fullwidth" style="padding-right: 0px;padding-left: 0px;">
                                                <!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr style="line-height:0px"><td style="padding-right: 0px;padding-left: 0px;" align="center"><![endif]--><img align="center" alt="Header VIP" border="0" class="center autowidth fullwidth" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/38b34f8f-a275-4b33-8819-f14e2a2df653.jpg" style="outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; clear: both; border: 0; height: auto; float: none; width: 100%; max-width: 600px; display: block;"
                                                    title="Header VIP" width="600" />
                                                <!--[if mso]></td></tr></table><![endif]-->
                                            </div>
                                            <table border="0" cellpadding="0" cellspacing="0" class="divider" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;"
                                                valign="top" width="100%">
                                                <tbody>
                                                    <tr style="vertical-align: top;" valign="top">
                                                        <td class="divider_inner" style="word-break: break-word; vertical-align: top; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-top: 10px; padding-right: 10px; padding-bottom: 10px; padding-left: 10px; border-collapse: collapse;"
                                                            valign="top">
                                                            <table align="center" border="0" cellpadding="0" cellspacing="0" class="divider_content" height="0" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; border-top: 1px solid #BBBBBB; height: 0px;"
                                                                valign="top" width="100%">
                                                                <tbody>
                                                                    <tr style="vertical-align: top;" valign="top">
                                                                        <td height="0" style="word-break: break-word; vertical-align: top; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; border-collapse: collapse;" valign="top"><span></span></td>
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
                                <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
                                <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
                            </div>
                        </div>
                    </div>
                    <div style="background-color:transparent;">
                        <div class="block-grid two-up" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;;">
                            <div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
                                <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:600px"><tr class="layout-full-width" style="background-color:transparent"><![endif]-->
                                <!--[if (mso)|(IE)]><td align="center" width="300" style="background-color:transparent;width:300px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:10px;"><![endif]-->
                                <div class="col num6" style="max-width: 320px; min-width: 300px; display: table-cell; vertical-align: top;;">
                                    <div style="width:100% !important;">
                                        <!--[if (!mso)&(!IE)]><!-->
                                        <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:10px; padding-right: 0px; padding-left: 0px;">
                                            <!--<![endif]-->
                                            <!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 20px; padding-left: 20px; padding-top: 20px; padding-bottom: 20px; font-family: Arial, sans-serif"><![endif]-->
                                            <div style="color:#5b5b5f;font-family:'Helvetica Neue', Helvetica, Arial, sans-serif;line-height:150%;padding-top:20px;padding-right:20px;padding-bottom:20px;padding-left:20px;">
                                                <div style="font-size: 12px; line-height: 18px; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: #5b5b5f;">
                                                    <p style="font-size: 12px; line-height: 19px; text-align: left; margin: 0;"><span style="font-size: 13px; mso-ansi-font-size: 14px;"><strong><span style="line-height: 19px; font-size: 13px; mso-ansi-font-size: 14px;">Billing Address</span></strong>
                                                        </span><br/><br/><span style="font-size: 13px; line-height: 19px; mso-ansi-font-size: 14px;"><strong><span style="line-height: 19px; font-size: 13px; mso-ansi-font-size: 14px;"><span style="line-height: 19px; font-size: 13px; mso-ansi-font-size: 14px;"><cfoutput>#order.getAccount().getFirstName()# #order.getAccount().getLastName()#</cfoutput></span></span>
                                                        </strong>
                                                        <!---<cfdump var = "#order.getOrderPayments()#" abort top=2>--->
                                                        </span><br/><span style="font-size: 13px; line-height: 19px; mso-ansi-font-size: 14px;"><strong><span style="line-height: 19px; font-size: 13px; mso-ansi-font-size: 14px;"><span style="line-height: 19px; font-size: 13px; mso-ansi-font-size: 14px;"><cfoutput>#order.billingAccountAddress().getBillingAddress().getAccountAddressName()# #order.getOrderPayments().getBillingAddress().getStreetAddress()# #order.getOrderPayments().getBillingAddress().getStreet2Address()#</cfoutput></span></span>
                                                        </strong>
                                                        </span><br/><span style="font-size: 13px; line-height: 19px; mso-ansi-font-size: 14px;"><strong><span style="line-height: 19px; font-size: 13px; mso-ansi-font-size: 14px;"><span style="line-height: 19px; font-size: 13px; mso-ansi-font-size: 14px;">#order.getOrderPayments().getBillingAddress().getCity()#, #order.getOrderPayments().getBillingAddress().getStateCode()# #order.getOrderPayments().getBillingAddress().getPostalCode()#</span></span>
                                                        </strong>
                                                        </span>
                                                    </p>
                                                </div>
                                            </div>
                                            <!--[if mso]></td></tr></table><![endif]-->
                                            <!--[if (!mso)&(!IE)]><!-->
                                        </div>
                                        <!--<![endif]-->
                                    </div>
                                </div>
                                <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
                                <!--[if (mso)|(IE)]></td><td align="center" width="300" style="background-color:transparent;width:300px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]-->
                                <div class="col num6" style="max-width: 320px; min-width: 300px; display: table-cell; vertical-align: top;;">
                                    <div style="width:100% !important;">
                                        <!--[if (!mso)&(!IE)]><!-->
                                        <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
                                            <!--<![endif]-->
                                            <!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 20px; padding-left: 20px; padding-top: 20px; padding-bottom: 20px; font-family: Arial, sans-serif"><![endif]-->
                                            <div style="color:#5b5b5f;font-family:'Helvetica Neue', Helvetica, Arial, sans-serif;line-height:150%;padding-top:20px;padding-right:20px;padding-bottom:20px;padding-left:20px;">
                                                <div style="font-size: 12px; line-height: 18px; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: #5b5b5f;">
                                                    <p style="font-size: 12px; line-height: 19px; margin: 0;"><span style="font-size: 13px; mso-ansi-font-size: 14px;"><strong><span style="line-height: 19px; font-size: 13px; mso-ansi-font-size: 14px;">Shipping Address</span></strong>
                                                        </span>
                                                    </p>
                                                    <p style="font-size: 12px; line-height: 18px; margin: 0;"> </p>
                                                    <p style="font-size: 12px; line-height: 19px; margin: 0;"><span style="font-size: 13px; mso-ansi-font-size: 14px;"><strong><span style="line-height: 19px; font-size: 13px; mso-ansi-font-size: 14px;"><cfoutput>#order.getOrderFulfillments().getAddress().getName()# </cfoutput></span></strong>
                                                        </span>
                                                    </p>
                                                    <p style="font-size: 12px; line-height: 19px; margin: 0;"><span style="font-size: 13px; mso-ansi-font-size: 14px;"><strong><span style="line-height: 19px; font-size: 13px; mso-ansi-font-size: 14px;"><cfoutput>#order.getOrderFulfillments().getAddress().getStreetAddress()#</cfoutput></span></strong>
                                                        </span>
                                                    </p>
                                                    <p style="font-size: 12px; line-height: 19px; margin: 0;"><span style="font-size: 13px; mso-ansi-font-size: 14px;"><strong><span style="line-height: 19px; font-size: 13px; mso-ansi-font-size: 14px;"><cfoutput>#order.getOrderFulfillments().getAddress().getCity()#, #order.getOrderFulfillments().getAddress().getStateCode()# #order.getOrderFulfillments().getAddress().getPostalCode()#</cfoutput></span></strong>
                                                        </span>
                                                    </p>
                                                </div>
                                            </div>
                                            <!--[if mso]></td></tr></table><![endif]-->
                                            <!--[if (!mso)&(!IE)]><!-->
                                        </div>
                                        <!--<![endif]-->
                                    </div>
                                </div>
                                <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
                                <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
                            </div>
                        </div>
                    </div>
                    <div style="background-color:transparent;">
                        <div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;;">
                            <div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
                                <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:600px"><tr class="layout-full-width" style="background-color:transparent"><![endif]-->
                                <!--[if (mso)|(IE)]><td align="center" width="600" style="background-color:transparent;width:600px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]-->
                                <div class="col num12" style="min-width: 320px; max-width: 600px; display: table-cell; vertical-align: top;;">
                                    <div style="width:100% !important;">
                                        <!--[if (!mso)&(!IE)]><!-->
                                        <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
                                            <!--<![endif]-->
                                            <table border="0" cellpadding="0" cellspacing="0" class="divider" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;"
                                                valign="top" width="100%">
                                                <tbody>
                                                    <tr style="vertical-align: top;" valign="top">
                                                        <td class="divider_inner" style="word-break: break-word; vertical-align: top; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-top: 10px; padding-right: 10px; padding-bottom: 10px; padding-left: 10px; border-collapse: collapse;"
                                                            valign="top">
                                                            <table align="center" border="0" cellpadding="0" cellspacing="0" class="divider_content" height="0" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; border-top: 3px solid #5b5b5f; height: 0px;"
                                                                valign="top" width="100%">
                                                                <tbody>
                                                                    <tr style="vertical-align: top;" valign="top">
                                                                        <td height="0" style="word-break: break-word; vertical-align: top; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; border-collapse: collapse;" valign="top"><span></span></td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <div style="font-size:16px;text-align:center;font-family:Arial, 'Helvetica Neue', Helvetica, sans-serif">
                                                <div class="our-class">
                                                    <table style="font-family: helvetica, sans-serif; font-size: 13px; color:#5b5b5f; border-collapse: collapse; width: 100%;">
                                                        <tr>
                                                            <th style="text-align: left; padding: 8px;">Order Number</th>
                                                            <th style="text-align: left; padding: 8px;">Distributor ID</th>
                                                            <th style="text-align: left; padding: 8px;">Ship Via</th>
                                                            <th style="text-align: left; padding: 8px;">Period</th>
                                                            <th style="text-align: right; padding: 8px;">Entry Date</th>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: left; padding: 8px;"></td>
                                                            <td style="text-align: left; padding: 8px;"></td>
                                                            <td style="text-align: left; padding: 8px;"></td>
                                                            <td style="text-align: left; padding: 8px;"></td>
                                                            <td style="text-align: right; padding: 8px;"></td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </div>
                                            <table border="0" cellpadding="0" cellspacing="0" class="divider" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;"
                                                valign="top" width="100%">
                                                <tbody>
                                                    <tr style="vertical-align: top;" valign="top">
                                                        <td class="divider_inner" style="word-break: break-word; vertical-align: top; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-top: 10px; padding-right: 10px; padding-bottom: 10px; padding-left: 10px; border-collapse: collapse;"
                                                            valign="top">
                                                            <table align="center" border="0" cellpadding="0" cellspacing="0" class="divider_content" height="0" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; border-top: 3px solid #5b5b5f; height: 0px;"
                                                                valign="top" width="100%">
                                                                <tbody>
                                                                    <tr style="vertical-align: top;" valign="top">
                                                                        <td height="0" style="word-break: break-word; vertical-align: top; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; border-collapse: collapse;" valign="top"><span></span></td>
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
                                <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
                                <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
                            </div>
                        </div>
                    </div>
                    <div style="background-color:transparent;">
                        <div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;;">
                            <div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
                                <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:600px"><tr class="layout-full-width" style="background-color:transparent"><![endif]-->
                                <!--[if (mso)|(IE)]><td align="center" width="600" style="background-color:transparent;width:600px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]-->
                                <div class="col num12" style="min-width: 320px; max-width: 600px; display: table-cell; vertical-align: top;;">
                                    <div style="width:100% !important;">
                                        <!--[if (!mso)&(!IE)]><!-->
                                        <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
                                            <!--<![endif]-->
                                            <!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 10px; padding-left: 10px; padding-top: 20px; padding-bottom: 20px; font-family: Arial, sans-serif"><![endif]-->
                                            <div style="color:#555555;font-family:Arial, 'Helvetica Neue', Helvetica, sans-serif;line-height:120%;padding-top:20px;padding-right:10px;padding-bottom:20px;padding-left:10px;">
                                                <div style="font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; font-size: 12px; line-height: 14px; color: #555555;">
                                                    <p style="font-size: 14px; line-height: 16px; text-align: center; margin: 0;"><strong>&lt;insert invoice&gt;</strong></p>
                                                </div>
                                            </div>
                                            <!--[if mso]></td></tr></table><![endif]-->
                                            <!--[if (!mso)&(!IE)]><!-->
                                        </div>
                                        <!--<![endif]-->
                                    </div>
                                </div>
                                <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
                                <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
                            </div>
                        </div>
                    </div>
                    <div style="background-color:transparent;">
                        <div class="block-grid three-up" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;;">
                            <div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
                                <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:600px"><tr class="layout-full-width" style="background-color:transparent"><![endif]-->
                                <!--[if (mso)|(IE)]><td align="center" width="150" style="background-color:transparent;width:150px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]-->
                                <div class="col num3" style="display: table-cell; vertical-align: top; max-width: 320px; min-width: 150px;;">
                                    <div style="width:100% !important;">
                                        <!--[if (!mso)&(!IE)]><!-->
                                        <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
                                            <!--<![endif]-->
                                            <div></div>
                                            <!--[if (!mso)&(!IE)]><!-->
                                        </div>
                                        <!--<![endif]-->
                                    </div>
                                </div>
                                <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
                                <!--[if (mso)|(IE)]></td><td align="center" width="150" style="background-color:transparent;width:150px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]-->
                                <div class="col num3" style="display: table-cell; vertical-align: top; max-width: 320px; min-width: 150px;;">
                                    <div style="width:100% !important;">
                                        <!--[if (!mso)&(!IE)]><!-->
                                        <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
                                            <!--<![endif]-->
                                            <div></div>
                                            <!--[if (!mso)&(!IE)]><!-->
                                        </div>
                                        <!--<![endif]-->
                                    </div>
                                </div>
                                <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
                                <!--[if (mso)|(IE)]></td><td align="center" width="300" style="background-color:transparent;width:300px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]-->
                                <div class="col num6" style="display: table-cell; vertical-align: top; max-width: 320px; min-width: 300px;;">
                                    <div style="width:100% !important;">
                                        <!--[if (!mso)&(!IE)]><!-->
                                        <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
                                            <!--<![endif]-->
                                            <!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 10px; padding-left: 0px; padding-top: 20px; padding-bottom: 20px; font-family: Arial, sans-serif"><![endif]-->
                                            <div style="color:#5b5b5f;font-family:'Helvetica Neue', Helvetica, Arial, sans-serif;line-height:150%;padding-top:20px;padding-right:10px;padding-bottom:20px;padding-left:0px;">
                                                <div style="font-size: 12px; line-height: 18px; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: #5b5b5f;">
                                                    <p style="font-size: 12px; line-height: 18px; text-align: right; margin: 0;"><strong><span style="font-size: 13px; line-height: 19px; mso-ansi-font-size: 14px;">Sub Total: &lt;SUBTOTAL&gt;</span></strong></p>
                                                    <p style="font-size: 12px; line-height: 19px; text-align: right; margin: 0;"><span style="font-size: 13px; mso-ansi-font-size: 14px;">Tax: &lt;TAX&gt;</span></p>
                                                    <p style="font-size: 12px; line-height: 19px; text-align: right; margin: 0;"><span style="font-size: 13px; mso-ansi-font-size: 14px;">Shipping: &lt;SHIPPING COST&gt;</span></p>
                                                    <p style="font-size: 12px; line-height: 19px; text-align: right; margin: 0;"><span style="font-size: 13px; mso-ansi-font-size: 14px;">Handling: &lt;HANDLING COST&gt;</span></p>
                                                    <p style="font-size: 12px; line-height: 19px; text-align: right; margin: 0;"><span style="font-size: 13px; mso-ansi-font-size: 14px;">Misc: &lt;MISC COST&gt;</span></p>
                                                    <p style="font-size: 12px; line-height: 19px; text-align: right; margin: 0;"><span style="font-size: 13px; mso-ansi-font-size: 14px;">Discount: &lt;DISCOUNT AMOUNT&gt;</span></p>
                                                    <p style="font-size: 12px; line-height: 18px; text-align: right; margin: 0;"><strong><span style="font-size: 13px; line-height: 19px; mso-ansi-font-size: 14px;">Total Amount: &lt;TOTAL AMOUNT&gt;</span></strong></p>
                                                    <p style="font-size: 12px; line-height: 18px; text-align: right; margin: 0;"><strong><span style="font-size: 13px; line-height: 19px; mso-ansi-font-size: 14px;">Paid Amount: &lt;PAID AMOUNT&gt;</span></strong></p>
                                                </div>
                                            </div>
                                            <!--[if mso]></td></tr></table><![endif]-->
                                            <!--[if (!mso)&(!IE)]><!-->
                                        </div>
                                        <!--<![endif]-->
                                    </div>
                                </div>
                                <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
                                <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
                            </div>
                        </div>
                    </div>
                    <div style="background-color:transparent;">
                        <div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;;">
                            <div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
                                <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:600px"><tr class="layout-full-width" style="background-color:transparent"><![endif]-->
                                <!--[if (mso)|(IE)]><td align="center" width="600" style="background-color:transparent;width:600px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]-->
                                <div class="col num12" style="min-width: 320px; max-width: 600px; display: table-cell; vertical-align: top;;">
                                    <div style="width:100% !important;">
                                        <!--[if (!mso)&(!IE)]><!-->
                                        <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
                                            <!--<![endif]-->
                                            <!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 30px; padding-left: 30px; padding-top: 30px; padding-bottom: 30px; font-family: Arial, sans-serif"><![endif]-->
                                            <div style="color:#5b5b5f;font-family:'Helvetica Neue', Helvetica, Arial, sans-serif;line-height:150%;padding-top:30px;padding-right:30px;padding-bottom:30px;padding-left:30px;">
                                                <div style="font-size: 12px; line-height: 18px; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: #5b5b5f;">
                                                    <p style="font-size: 12px; line-height: 21px; text-align: center; margin: 0;"><span style="font-size: 14px;">For more information on Returns and Cancellations please review your </span></p>
                                                    <p style="font-size: 12px; line-height: 21px; text-align: center; margin: 0;"><span style="font-size: 14px;"><strong><a href="https://monatglobal.com/wp-content/uploads/2019/05/VIP-Customer-Agreement_US_V5_CMedits_050119.pdf" rel="noopener" style="text-decoration: none; color: #a598d5;" target="_blank">VIP Customer Agreement</a></strong>.</span></p>
                                                    <p style="font-size: 12px; line-height: 21px; text-align: center; margin: 0;"><span style="font-size: 14px;"> </span></p>
                                                    <p style="font-size: 12px; line-height: 21px; text-align: center; margin: 0;"><span style="font-size: 14px;"><em><span style="line-height: 21px; font-size: 14px;">Thank you for being a MONAT VIP!</span></em>
                                                        </span>
                                                    </p>
                                                </div>
                                            </div>
                                            <!--[if mso]></td></tr></table><![endif]-->
                                            <!--[if (!mso)&(!IE)]><!-->
                                        </div>
                                        <!--<![endif]-->
                                    </div>
                                </div>
                                <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
                                <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
                            </div>
                        </div>
                    </div>
                    <div style="background-color:transparent;">
                        <div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: #E5E5E5;;">
                            <div style="border-collapse: collapse;display: table;width: 100%;background-color:#E5E5E5;">
                                <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:600px"><tr class="layout-full-width" style="background-color:#E5E5E5"><![endif]-->
                                <!--[if (mso)|(IE)]><td align="center" width="600" style="background-color:#E5E5E5;width:600px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]-->
                                <div class="col num12" style="min-width: 320px; max-width: 600px; display: table-cell; vertical-align: top;;">
                                    <div style="width:100% !important;">
                                        <!--[if (!mso)&(!IE)]><!-->
                                        <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
                                            <!--<![endif]-->
                                            <!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 20px; padding-left: 20px; padding-top: 20px; padding-bottom: 20px; font-family: Arial, sans-serif"><![endif]-->
                                            <div style="color:#555555;font-family:Arial, 'Helvetica Neue', Helvetica, sans-serif;line-height:120%;padding-top:20px;padding-right:20px;padding-bottom:20px;padding-left:20px;">
                                                <div style="font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; font-size: 12px; line-height: 14px; color: #555555; text-align:center;">
                                                    <p style="font-size: 14px; line-height: 15px; margin: 0;"><span style="font-size: 13px; mso-ansi-font-size: 14px;"><strong>Shipping #&lt;AUTOSHIPNUMBER&gt; **Internet Order</strong></span></p>
                                                </div>
                                            </div>
                                            <!--[if mso]></td></tr></table><![endif]-->
                                            <!--[if (!mso)&(!IE)]><!-->
                                        </div>
                                        <!--<![endif]-->
                                    </div>
                                </div>
                                <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
                                <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
                            </div>
                        </div>
                    </div>
                    <div style="background-color:transparent;">
                        <div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: transparent;;">
                            <div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
                                <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;"><tr><td align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:600px"><tr class="layout-full-width" style="background-color:transparent"><![endif]-->
                                <!--[if (mso)|(IE)]><td align="center" width="600" style="background-color:transparent;width:600px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;"><![endif]-->
                                <div class="col num12" style="min-width: 320px; max-width: 600px; display: table-cell; vertical-align: top;;">
                                    <div style="width:100% !important;">
                                        <!--[if (!mso)&(!IE)]><!-->
                                        <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
                                            <!--<![endif]-->
                                            <div align="center" class="img-container center autowidth fullwidth" style="padding-right: 0px;padding-left: 0px;">
                                                <!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr style="line-height:0px"><td style="padding-right: 0px;padding-left: 0px;" align="center"><![endif]-->
                                                <div style="font-size:1px;line-height:20px"> </div><img align="center" alt="footer vip" border="0" class="center autowidth fullwidth" src="https://gallery.mailchimp.com/5b14e3c0bd6372e1d93e9a8f6/images/d0a4c027-7c81-4ce6-b07d-51b86d4239cb.jpg" style="outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; clear: both; border: 0; height: auto; float: none; width: 100%; max-width: 600px; display: block;"
                                                    title="footer vip" width="600" />
                                                <!--[if mso]></td></tr></table><![endif]-->
                                            </div>
                                            <table border="0" cellpadding="0" cellspacing="0" class="divider" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;"
                                                valign="top" width="100%">
                                                <tbody>
                                                    <tr style="vertical-align: top;" valign="top">
                                                        <td class="divider_inner" style="word-break: break-word; vertical-align: top; min-width: 100%; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-top: 15px; padding-right: 10px; padding-bottom: 10px; padding-left: 10px; border-collapse: collapse;"
                                                            valign="top">
                                                            <table align="center" border="0" cellpadding="0" cellspacing="0" class="divider_content" height="0" role="presentation" style="table-layout: fixed; vertical-align: top; border-spacing: 0; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; border-top: 1px solid #BBBBBB; height: 0px;"
                                                                valign="top" width="100%">
                                                                <tbody>
                                                                    <tr style="vertical-align: top;" valign="top">
                                                                        <td height="0" style="word-break: break-word; vertical-align: top; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; border-collapse: collapse;" valign="top"><span></span></td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                          
                          
                          
<cfinclude template="../inc/footer.cfm">