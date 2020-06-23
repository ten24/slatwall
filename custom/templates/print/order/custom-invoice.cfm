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
																			
	This is a print template designed to be used to customize the print job	
	that slatwall does.  If you would like to customize this template, it	
	should first be coppied into the /custom/templates/ directory in the	
	same folder path naming convention that it currently resides inside.	
																			
	All print templates have 2 objects that are passed in (seen below):		
																			
	print: This is the actually print entity that will have print settings	
	that will eventually be persisted to the database as a log of this		
	print job as long as the "Log Print" setting is set to true.			
																			
	printData: This is a structure used to set values that will get			
	populated into the print entity once this processing is complete.		
																			
	It will also be used as a final stringReplace() struct for any ${} keys	
	that have not already been relpaced.									
																			
	Lastly, the base object that is being used for this print should also	
	be injected into the template and paramed at the top.					
																			
--->

<cfparam name="print" type="any" />	
<cfparam name="printData" type="struct" default="#structNew()#" />
<cfparam name="order" type="any" />

<!-- Logo will only work on DEV or STAGING -->
<cfif FindNoCase('ten24dev', cgi.server_name ) || true>
	<cfset local.siteLink = "http://monat.ten24dev.com/" />
<cfelse>
	<cfset local.siteLink = "https://monatglobal.com/" />
</cfif>

<cfif !isNull(order.getVATTotal()) && order.getVATTotal() >
	<cfset local.taxType = 'VAT'>
<cfelse>
	<cfset local.taxType = 'Tax'>
</cfif>

	<cfset local.defaultTable = 'width: 100%; font-family: Arial, sans-serif; font-size: 11px; color: ##848484; border-collapse: collapse;' />
	<cfoutput>
		
		<table style="#local.defaultTable#">
			
			<!-- Header: Row 01 -->
			<tr>
				<td>
					
					<table style="#local.defaultTable#">
						
						<tr>
							<td width="33%" valign="top">
								<p>
									#order.getOrderCreatedSite().setting('siteInvoiceInformation') ?: ''#
								</p>
							</td>
							<td width="33%" valign="top">
								<img src="/themes/monat/assets/images/logo.png" alt="Monat logo">
							</td>
							<td width="33%" valign="top" style="text-align: right;">
								<table>
									<tr>
										<td style="text-align: right;">Order Number:</td>
										<td style="text-align: right;">#order.getOrderNumber()#</td>
									</tr>
									<tr>
										<td style="text-align: right;">Order Date:</td>
										<td style="text-align: right;">#DateFormat(order.getOrderOpenDateTime(), "MM/DD/YYYY")#</td>
									</tr>
								</table>
							</td>
						</tr>
						
					</table>
					
				</td>
			</tr>
			
			<!-- Header: Row 02 -->
			<tr>
				<td>
					
					<table style="#local.defaultTable# padding: 5px 0 20px 0;">
						<tr>
							
							<td width="33%" valign="top" style="text-align: center;">
								&nbsp;
							</td>
							
							<td width="33%" valign="top" style="text-align: center;">
								<b style="color: ##555; font-size: 15px;">Invoice</b>
							</td>
							
							<td width="33%" valign="top" style="text-align: center;">
								&nbsp;
							</td>
						</tr>
					</table>
					
				</td>
				
			</tr>
			
			<!-- Header: Row 03 -->
			<tr>
				<td>
					
					<table style="#local.defaultTable#">
						<tr>
							<td width="50%" valign="top">
								<p>
									<b>Billing Address:</b>
									
									<br>
										#order.getAccount().getLastName()#, #order.getAccount().getFirstName()#
									<br>
									<cfif not isNull(order.getAccount()) and not isNull(order.getAccount().getCompany())>
										#order.getAccount().getCompany()#<br />
									</cfif>
									<cfif not isNull(order.getBillingAddress().getStreetAddress())>
										#order.getBillingAddress().getStreetAddress()#<br />
									</cfif>
									<cfif not isNull(order.getBillingAddress().getStreet2Address())>
										#order.getBillingAddress().getStreet2Address()#<br />
									</cfif>
									<cfif not isNull(order.getBillingAddress().getLocality())>
										#order.getBillingAddress().getLocality()#<br />
									</cfif>
									<cfif not isNull(order.getBillingAddress().getCity()) and not isNull(order.getBillingAddress().getStateCode()) and not isNull(order.getBillingAddress().getPostalCode())>
										#order.getBillingAddress().getCity()#, #order.getBillingAddress().getStateCode()# #order.getBillingAddress().getPostalCode()#<br />
									<cfelse>
										<cfif not isNull(order.getBillingAddress().getCity())>
											#order.getBillingAddress().getCity()#<br />
										</cfif>
										<cfif not isNull(order.getBillingAddress().getStateCode())>
											#order.getBillingAddress().getStateCode()#<br />
										</cfif>
										<cfif not isNull(order.getBillingAddress().getPostalCode())>
											#order.getBillingAddress().getPostalCode()#<br />
										</cfif>
									</cfif>
									<cfif order.getBillingAddress().isNew() >
										<cfloop array="#order.getOrderPayments()#" index="orderPayment">
											<cfif orderPayment.getOrderPaymentStatusType().getSystemCode() EQ "opstActive" AND orderPayment.getAmount() GT 0 AND not isNull(orderPayment.getBillingAddress()) >
												<cfif not isNull(orderPayment.getBillingAddress().getStreetAddress())> 
													#orderPayment.getBillingAddress().getStreetAddress()#<br />
												</cfif>
												<cfif not isNull(orderPayment.getBillingAddress().getStreet2Address())>
													 #orderPayment.getBillingAddress().getStreet2Address()#<br />
												</cfif>
												<cfif not isNull(orderPayment.getBillingAddress().getLocality())>
													#orderPayment.getBillingAddress().getLocality()#<br />
												</cfif>
												<cfif not isNull(orderPayment.getBillingAddress().getCity()) and not isNull(orderPayment.getBillingAddress().getStateCode()) and not isNull(orderPayment.getBillingAddress().getPostalCode())>
													#orderPayment.getBillingAddress().getCity()#, #orderPayment.getBillingAddress().getStateCode()# #orderPayment.getBillingAddress().getPostalCode()#<br />
												<cfelse>
													<cfif not isNull(orderPayment.getBillingAddress().getCity())>
														#orderPayment.getBillingAddress().getCity()#<br />
													</cfif>
													<cfif not isNull(orderPayment.getBillingAddress().getStateCode())>
														#orderPayment.getBillingAddress().getStateCode()#<br />
													</cfif>
													<cfif not isNull(orderPayment.getBillingAddress().getPostalCode())>
														#orderPayment.getBillingAddress().getPostalCode()#<br />
													</cfif>
												</cfif>
												<cfbreak>
											</cfif>
										</cfloop>
									</cfif>
									
								</p>
							</td>
							<td width="50%" valign="top">
								<p>
									<b>Shipping Address:</b>
									<br>
									#order.getAccount().getCalculatedFullName()#
									<cfloop array="#order.getOrderFulfillments()#" index="local.orderFulfillment">
										<cfif local.orderFulfillment.getFulfillmentMethodType() EQ "shipping">
											<br>
											<cfif len(local.orderFulfillment.getAddress().getCompany())>
												#local.orderFulfillment.getAddress().getCompany()#<br />
											<cfelseif not isNull(order.getAccount()) and not isNull(order.getAccount().getCompany())>
												#order.getAccount().getCompany()#<br />
											</cfif>
											<cfif len(local.orderFulfillment.getAddress().getStreetAddress())>
												#local.orderFulfillment.getAddress().getStreetAddress()#<br />
											</cfif>
											<cfif len(local.orderFulfillment.getAddress().getStreet2Address())>
												#local.orderFulfillment.getAddress().getStreet2Address()#<br />
											</cfif>
											#local.orderFulfillment.getAddress().getCity()#, #local.orderFulfillment.getAddress().getStateCode()# #local.orderFulfillment.getAddress().getPostalCode()#
											#local.orderFulfillment.getAddress().getCountryCode()#<br />
										<cfelseif local.orderFulfillment.getFulfillmentMethodType() EQ "email">
											<div id="emailAddress" style="width:190px; margin-right:10px; float:left;">
												<strong>Delivery Email</strong><br /><br />
												#local.orderFulfillment.getEmailAddress()#
											</div>
										<cfelseif local.orderFulfillment.getFulfillmentMethodType() EQ "auto">
											<div id="fulfillmentAuto" style="width:190px; margin-right:10px; float:left;">
												<strong>Auto Fulfilled</strong><br /><br />
											</div>
										<cfelseif local.orderFulfillment.getFulfillmentMethodType() EQ "pickup">
											<div id="pickup" style="width:190px; margin-right:10px; float:left;">
												<strong>Store Pickup</strong><br />
												<cfif not isNull(local.orderFulfillment.getPickupDate()) AND Len(local.orderFulfillment.getPickupDate())>
													<p>Pickup Date: <strong>#dateformat(local.orderFulfillment.getPickupDate(),"mmm d, yyyy")#</strong></p>
												</cfif>
												<br/><br />
											</div>
			 							</cfif>
									</cfloop>
									
								</p>
							</td>
						</tr>
					</table>
					
				</td>
				
			</tr>
			
			<tr>
				<td>
					<p>&nbsp;</p>
				</td>
			</tr>
			
			<!--- General Information Table --->
			<tr>
				<td>
					
					<table style="#local.defaultTable# border-top: 2px solid ##C0C0C0; border-bottom: 2px solid ##C0C0C0; padding: 7px 0; margin-bottom: 2px;">
						<thead>
							<tr>
								<td style="font-weight: bold;">Distributor ID</td>
								<td style="font-weight: bold;">Period</td>
								<td style="font-weight: bold;">Ship Via</td>
								<td style="font-weight: bold;">Entry Initials</td>
								<td style="font-weight: bold;">Entry Date</td>
								<td style="font-weight: bold;">Entry Time</td>
							</tr>
						</thead>
						<tbody>
							<tr>
								
								<td>
									#order.getAccount().getAccountNumber()#
								</td>
								
								<td>
									#order.getCommissionPeriod()#
								</td>
								
								<td>
									<cfif not isNull(orderFulfillment) AND not isNull(orderFulfillment.getShippingMethod()) >
										#orderFulfillment.getShippingMethod().getShippingMethodName()#
									<cfelse>
										Shipping Information Unavailable 
									</cfif>
								</td>
								
								<td>
									<cfif !isNull(order.getCreatedByAccount())>
										#left(order.getCreatedByAccount().getFirstName(),1)# #left(order.getCreatedByAccount().getLastName(),1)#
									</cfif>
								</td>
								
								<td>
									#dateFormat(order.getOrderOpenDateTime())#
								</td>
								
								<td>
									#timeFormat(order.getOrderOpenDateTime())#
								</td>
								
							</tr>
						</tbody>
					</table>
					
				</td>
			</tr>
			
			<!--- Item/Description Table --->
			<tr>
				<td>
					
					<table style="#local.defaultTable# color: ##FFF; padding: 10px 0;">
						<thead>
							<tr style="background-color: ##A9A9A9; font-weight: bold;">
								<td style="padding: 5px 3px; text-align: left;">Item Code</td>
								<td style="padding: 5px 3px; text-align: left;">Description</td>
								<td style="padding: 5px 3px; text-align: center;">QTY</td>
								<td style="padding: 5px 3px; text-align: right;">Item<br>Vol</td>
								<td style="padding: 5px 3px; text-align: right;">Total<br>Vol</td>
								<td style="padding: 5px 3px; text-align: right;">Unit<br>Price</td>
								<td style="padding: 5px 3px; text-align: right;">Net<br>Amt</td>
								<td style="padding: 5px 3px; text-align: right;"> #local.taxType == 'VAT' ? 'VAT' :'Tax'# <br>Amt</td>
								<td style="padding: 5px 3px; text-align: right;">Gross<br>Amt</td>
							</tr>
						</thead>
						<tbody style="color: ##333;">
							
							<cfloop array="#order.getOrderItems()#" item="local.orderItem" index="local.index">
								
								<tr style="background-color: ##F5F5F5; margin-bottom: 2px;">
									<td style="border-top: 1px solid ##FFF; font-size: 10px; padding: 5px 10px 5px 3px; text-align: left;">
										#local.orderItem.getSku().getSkuCode()#
									</td>
									<td style="border-top: 1px solid ##FFF; font-size: 9px; padding: 5px 3px; text-align: left;">
										#local.orderItem.getSku().getProduct().getTitle()#<br>
										<cfif len(local.orderItem.getSku().getProduct().getProductDescription())>
											<strong>#local.orderItem.getSku().getProduct().getProductDescription()#</strong>
										</cfif>
									</td>
									<td style="border-top: 1px solid ##FFF; font-size: 9px; padding: 5px 3px; text-align: center;">
										#NumberFormat(local.orderItem.getQuantity())#
									</td>
									<td style="border-top: 1px solid ##FFF; font-size: 9px; padding: 5px 3px; text-align: right;">
										#local.orderItem.getPersonalVolume()#
									</td>
									<td style="border-top: 1px solid ##FFF; font-size: 9px; padding: 5px 3px; text-align: right;">
										#local.orderItem.getExtendedPersonalVolumeAfterDiscount()#
									</td>
									<td style="border-top: 1px solid ##FFF; font-size: 9px; padding: 5px 3px; text-align: right;">
										#local.orderItem.getFormattedValue('skuPrice', 'currency')#
									</td>
									<td style="border-top: 1px solid ##FFF; font-size: 9px; padding: 5px 3px; text-align: right;">
										#local.orderItem.getFormattedValue('netAmount', 'currency')#
									</td>
									<td style="border-top: 1px solid ##FFF; font-size: 9px; padding: 5px 3px; text-align: right;">
										<cfif local.taxType == 'VAT'>
											#local.orderItem.getFormattedValue('vatAmount', 'currency')#
										<cfelse>
											#local.orderItem.getFormattedValue('taxAmount', 'currency')#
										</cfif>
									
									</td>
									<td style="border-top: 1px solid ##FFF; font-size: 9px; padding: 5px 3px; text-align: right;">
										#local.orderItem.getFormattedValue('extendedPriceAfterDiscount', 'currency')#
									</td>
									
								</tr>
								
							</cfloop>
							
						</tbody>
					</table>
					
				</td>
			</tr>
			
			<!--- Bottom Table --->
			<tr>
				<td>
					
					<table style="#local.defaultTable# padding: 10px 0;">
						<tbody>
							
							<tr>
								
								<td valign="top" style="width: 33%;">
									<b>Comments:</b>
									<br>
									** Internet Order **
								</td>
								
								<td valign="top" style="width: 33%; padding-top: 13px;">
									Total Volume: 	#order.getPersonalVolumeTotal()#
								</td>
								
								<td valign="top" style="width: 33%;">
									
									<table style="#local.defaultTable# text-align: right;">
										<tr>
											<td style="padding: 2px 0;">
												Subtotal
											</td>
											<td style="padding: 2px 0;">
												#order.getFormattedValue('subtotal', 'currency')#
											</td>
										</tr>
										<tr>
											<td style="padding: 2px 0;">
												Shipping/Handling
											</td>
											<td style="padding: 2px 0;">
												#order.getFormattedValue('fulfillmentTotal', 'currency')#
											</td>
										</tr>
										<tr>
											<td style="padding: 2px 0;">
												Discount	
											</td>
											<td style="padding: 2px 0;">
												#order.getFormattedValue('discountTotal', 'currency')# 
											</td>
										</tr>
										<tr>
											<td style="padding: 2px 0; border-bottom: 1px solid ##C0C0C0;">
												Total  #local.taxType#
											</td>
											<td style="padding: 2px 0; border-bottom: 1px solid ##C0C0C0;">
												#order.getFormattedValue('#local.taxType#Total', 'currency')# 
											</td>
										</tr>
										<tr>
											<td style="padding: 2px 0;">
												Amount Due
											</td>
											<td style="padding: 2px 0;">
												#order.getFormattedValue('total', 'currency')# 
											</td>
										</tr>
										<tr>
											<td style="padding: 2px 0;">
												Amount Paid
											</td>
											<td style="padding: 2px 0;">
												#order.getFormattedValue('paymentAmountReceivedTotal', 'currency')#
											</td>
										</tr>
										<tr>
											<td style="padding: 2px 0;">
												Invoice Balance
											</td>
											<td style="padding: 2px 0;">
												#order.getFormattedValue('paymentAmountDue', 'currency')# 
											</td>
										</tr>
									</table>
									
								</td>
								
							</tr>
							
						</tbody>
					</table>
					
				</td>
			</tr>
			
			<!--- Messsage Table --->
			<tr>
				<td>
					
					<table style="#local.defaultTable# padding: 10px 0;">
						<tbody>
							
							<tr>
								
								<td valign="top" style="width: 100%; padding: 10px; background-color: ##DCDCDC;">
									<b>Message:</b>
									<div style="padding-top: 10px; color: ##444;">
										N/A
									</div>
								</td>
								
							</tr>
							
						</tbody>
					</table>
					
				</td>
			</tr>
			
		</table>
	</cfoutput>


