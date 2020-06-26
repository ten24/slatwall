<cfparam name="orderTemplate" />
<cfoutput>
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
                                                <table style="font-family: helvetica, sans-serif; font-size: 13px; color:##696969; border-collapse: collapse; width: 97%; margin: 0 auto;">
                                                   <tr>
                                                      <th style="text-align: left; padding: 15px 10px; background-color: ##2F294B; color:##fff; width: 20%">Product ID</th>
                                                      <th style="text-align: left; padding: 15px 5px; background-color: ##2F294B; color:##fff; width: 40%">Name</th>
                                                      <th style="text-align: center; padding: 15px 5px; background-color: ##2F294B; color:##fff; width: 20%"> </th>
                                                   </tr>
                                                   
                                                   <!------- ORDER ITEM LOOP ------->
													<cfset local.skuCodeArray = []>
													<cfset local.skuIDArray = []>
													
													<cfloop array="#orderTemplate.getOrderTemplateItems()#" index="local.orderTemplateItem">
														<tr>
															<td style="text-align: left; padding: 10px 10px;">
																#local.orderTemplateItem.getSku().getSkuCode()#
																<cfset ArrayAppend(skuCodeArray,local.orderTemplateItem.getSku().getSkuCode())>
																<cfset ArrayAppend(skuIDArray,local.orderTemplateItem.getSku().getSkuID())>
															</td>
															<td style="text-align: left; padding: 10px 10px;">
																#local.orderTemplateItem.getSku().getProduct().getTitle()#
															<td style="text-align: left; padding: 10px 10px;">
																<a href="#local.siteLink#shopping-cart/?slataction=public:cart.addOrderItems&amp;skuIds=#local.orderTemplateItem.getSku().getSkuID()#&amp;showLogin=true&amp;abandonedCart=true&amp;utm_source=abandonedCart&amp;utm_medium=email&amp;utm_campaign=Abandoned%20Cart%20Promo%20Code" style="color: ##2E2A4B; text-decoration: underline;">Add Item to Cart</a>
															</td>
														</tr>
													</cfloop>
													<cfset local.skuIDList = skuIDArray.toList()>
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
   <div class="block-grid" style="Margin: 0 auto; min-width: 320px; max-width: 600px; overflow-wrap: break-word; word-wrap: break-word; word-break: break-word; background-color: ##ffffff;">
      <div style="border-collapse: collapse;display: table;width: 100%;background-color:##ffffff;">
         <!--[if (mso)|(IE)]>
         <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:transparent;">
            <tr>
               <td align="center">
                  <table cellpadding="0" cellspacing="0" border="0" style="width:600px">
                     <tr class="layout-full-width" style="background-color:##ffffff">
                        <![endif]-->
                        <!--[if (mso)|(IE)]>
                        <td align="center" width="600" style="background-color:##ffffff;width:600px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top">
                           <table width="100%" cellpadding="0" cellspacing="0" border="0">
                              <tr>
                                 <td style="padding-right: 0px; padding-left: 0px; padding-top:5px; padding-bottom:5px;">
                                    <![endif]-->
                                    <div class="col num12" style="min-width: 320px; max-width: 600px; display: table-cell; vertical-align: top; width: 600px;">
                                       <div style="width:100% !important;">
                                          <!--[if (!mso)&(!IE)]><!-->
                                          <div style="border-top:0px solid transparent; border-left:0px solid transparent; border-bottom:0px solid transparent; border-right:0px solid transparent; padding-top:5px; padding-bottom:5px; padding-right: 0px; padding-left: 0px;">
                                             <!--<![endif]-->
                                             <div align="center" class="button-container" style="padding-top:10px;padding-right:10px;padding-bottom:30px;padding-left:10px; margin: auto; text-align: center;">
                                                <!--[if mso]>
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="border-spacing: 0; border-collapse: collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;">
                                                   <tr>
                                                      <td style="padding-top: 10px; padding-right: 10px; padding-bottom: 40px; padding-left: 10px" align="center">
                                                         <v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" href="#local.siteLink#shopping-cart/?slataction=public:cart.addOrderItems&amp;skuIds=#skuIDList#&amp;showLogin=true&amp;abandonedCart=true&amp;utm_source=abandonedCart&amp;utm_medium=email&amp;utm_campaign=Abandoned%20Cart%20Promo%20Code" style="height:30.75pt; width:112.5pt; v-text-anchor:middle;" arcsize="0%" stroke="false" fillcolor="##2f294b">
                                                            <w:anchorlock/>
                                                            <v:textbox inset="0,0,0,0">
                                                               <center style="color:##ffffff; font-family:Arial, sans-serif; font-size:14px">
                                                                  <![endif]--><a href="#local.siteLink#shopping-cart/?slataction=public:cart.addOrderItems&amp;skuIds=#skuIDList#&amp;showLogin=true&amp;abandonedCart=true&amp;utm_source=abandonedCart&amp;utm_medium=email&amp;utm_campaign=Abandoned%20Cart%20Promo%20Code" style="-webkit-text-size-adjust: none; text-decoration: none; display: inline-block; color: ##ffffff; background-color: ##2f294b; border-radius: 0px; -webkit-border-radius: 0px; -moz-border-radius: 0px; width: auto; width: auto; font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; text-align: center; mso-border-alt: none; word-break: keep-all; padding: 8px 20px;" target="_blank"><span style="font-size: 16px; line-height: 2; word-break: break-word; font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; mso-line-height-alt: 32px;">Add All To Cart</span></a>
                                                                  <!--[if mso]>
                                                               </center>
                                                            </v:textbox>
                                                         </v:roundrect>
                                                      </td>
                                                   </tr>
                                                </table>
                                                <![endif]-->
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

</cfoutput>
