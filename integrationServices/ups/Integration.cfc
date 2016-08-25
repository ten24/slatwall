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

*/
component accessors="true" output="false" displayname="UPS" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" {
	
	public any function init() {
		return this;
	}
	
	public string function getIntegrationTypes() {
		return "shipping";
	}
		
	public string function getDisplayName() {
		return "UPS";
	}

	public struct function getSettings() {
		var settings = {
			apiKey = {fieldType="text"},
			username = {fieldType="text"},
			password = {fieldType="password", encryptValue=true},
			testingFlag = {fieldType="yesno", defaultValue="1"},
			shipperNumber = {fieldType="text"},
			shipFromName = {fieldType="text"},
			shipFromEmailAddress = {fieldType="text"},
			shipFromCompany = {fieldType="text"},
			shipFromPhoneNumber = {fieldType="text"},
			shipFromAddressLine = {fieldType="text"},
			shipFromCity = {fieldType="text"},
			shipFromStateCode = {fieldType="text"},
			shipFromPostalCode = {fieldType="text"},
			shipFromCountryCode = {fieldType="text"},
			pickupTypeCode = {fieldType="select", defaultValue="03", valueOptions=[
				{name="(01) Daily Pickup", value="01"},
				{name="(03) Customer Counter", value="03"},
				{name="(06) One Time Pickup", value="06"},
				{name="(07) On Call Air", value="07"},
				{name="(11) Suggested Retail Rates", value="11"},
				{name="(19) Letter Center", value="19"},
				{name="(20) Air Service Center", value="20"}
			]},
			customerClassificationCode = {fieldType="select", defaultValue="04", valueOptions=[
				{name="(00) Negotiated (rates associated with shipper number)", value="00"},
				{name="(01) Wholesale (default for daily pickups)", value="01"},
				{name="(03) Occasional (default for other pickups)", value="03"},
				{name="(04) Retail (default for customer counter pickups)", value="04"}
			]}
		};
		
		return settings;
	}
}
