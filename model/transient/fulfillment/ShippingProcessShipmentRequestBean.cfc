/*

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
    along with this program.  If not, see <http://www.gnu.org/licenses/;.

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

*/

component accessors="true" output="false" extends="Slatwall.model.transient.fulfillment.ShippingRequestBean" {
//
//
//  property name="Company"    type="string";
//  property name="Name"    type="string";
//  property name="Address1"    type="string";
//  property name="Address2" type="string" default="";
//  property name="City"    type="string";
//  property name="State"    type="string";
//  property name="ZIP"     type="string";
//  property name="Phone"    type="string";
//  property name="IsResident"    type="string" default="false";
//
//  property name="weight"    type="string";
//  property name="Length"    type="string";
//  property name="Width"    type="string";
//  property name="Height"    type="string";
//  property name="PackagingType" type="string" hint="Available Options : FEDEX_10KG_BOX, FEDEX_25KG_BOX, FEDEX_BOX, FEDEX_ENVELOPE, FEDEX_PAK, FEDEX_TUBE, YOUR_PACKAGING";
//
////  property name="orderid"    type="string" default="#CreateUUID()#";
//  property name="ShippingMethod" type="string" default="STANDARD_OVERNIGHT" hint="Available Options : EUROPE_FIRST_INTERNATIONAL_PRIORITY, FEDEX_1_DAY_FREIGHT, FEDEX_2_DAY, FEDEX_2_DAY_FREIGHT, FEDEX_3_DAY_FREIGHT, FEDEX_EXPRESS_SAVER, FEDEX_GROUND, FIRST_OVERNIGHT, GROUND_HOME_DELIVERY, INTERNATIONAL_ECONOMY, INTERNATIONAL_ECONOMY_FREIGHT, INTERNATIONAL_FIRST, INTERNATIONAL_PRIORITY, INTERNATIONAL_PRIORITY_FREIGHT, PRIORITY_OVERNIGHT, SMART_POST, STANDARD_OVERNIGHT";
////  property name="ShipDate"    type="string" default="#now()#";
//  property name="department"    type="string" default="";
//  property name="ponumber"    type="string" default="";
//  property name="DropoffType"    type="string" default="REGULAR_PICKUP" hint="Available Options : REGULAR_PICKUP, REQUEST_COURIER, DROP_BOX, BUSINESS_SERVICE_CENTER, STATION";
//  property name="SpecialServices" type="string" default="" hint="Available Options : DANGEROUS_GOODS, BROKER_SELECT_OPTION, COD, DRY_ICE, ELECTRONIC_TRADE_DOCUMENTS, EMAIL_NOTIFICATION, FUTURE_DAY_SHIPMENT, HOLD_AT_LOCATION, HOME_DELIVERY_PREMIUM, INSIDE_DELIVERY, INSIDE_PICKUP, PENDING_SHIPMENT, RETURN_SHIPMENT, SATURDAY_DELIVERY, SATURDAY_PICKUP";
//  property name="DryIceWeight" type="string" default="" hint="Dry Ice Weight";
//
//  property name="HoldAtAddress1" type="string" default="";
//  property name="HoldAtAddress2" type="string" default="";
//  property name="HoldAtCity"    type="string" default="";
//  property name="HoldAtState"    type="string" default="";
//  property name="HoldAtZIP"    type="string" default="";
//  property name="HoldAtPhone"    type="string" default="";
//  property name="HoldAtIsResident" type="string" default="false";
//
//  //property name="returnLog"    type="string" default="#ExpandPath('log/return/')#";
//  //property name="fedexcallLog" type="string" default="#ExpandPath('log/fedexcall/')#";
//
////  property name="key"     type="string" default="#application.FedExkey#";
////  property name="password"    type="string" default="#application.FedExpassword#";
////  property name="account"    type="string" default="#application.FedExaccount#";
////  property name="meter"    type="string" default="#application.FedExmeter#";
////  property name="serverurl"    type="string" default="#application.FedExserver#" hint="SandBox : https://gatewaybeta.fedex.com/xml , Production: https://gateway.fedex.com/xml";
////  property name="billingAct"    type="string" default="#application.FedExbillingAct#";
//  property name="PaymentType"    type="string" default="THIRD_PARTY" hint="Available Options : COLLECT, RECIPIENT, SENDER, THIRD_PARTY";
//  property name="LabelType"    type="string" default="PAPER_4X6" hint="Available Options : PAPER_4X6, PAPER_4X8, PAPER_4X9, PAPER_7X4.75, PAPER_8.5X11_BOTTOM_HALF_LABEL, PAPER_8.5X11_TOP_HALF_LABEL, STOCK_4X6, STOCK_4X6.75_LEADING_DOC_TAB, STOCK_4X6.75_TRAILING_DOC_TAB, STOCK_4X8, STOCK_4X9_LEADING_DOC_TAB, STOCK_4X9_TRAILING_DOC_TAB";
//
////  property name="FedexPDF"    type="string" default="#ExpandPath('FedexPDF/')#";
//  property name="labelFile"    type="string" default="pdf" hint="Available Options : DPL, EPL2, PDF, PNG, ZPLII";
//
//  property name="FromCompany"    type="string" default="My Company";
//  property name="FromName"    type="string" default="John Doe";
//  property name="FromAddress1" type="string" default="16 Court Street";
//  property name="FromAddress2" type="string" default="";
//  property name="FromCity"    type="string" default="New York";
//  property name="FromState"    type="string" default="NY";
//  property name="FromZIP"    type="string" default="10211";
//  property name="FromPhone"    type="string" default="2015282777";
//  property name="FromIsResident" type="string" default="false";


	public any function init() {
		// Set defaults


		return super.init();
	}



}
