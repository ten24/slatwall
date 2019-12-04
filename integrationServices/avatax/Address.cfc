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

component accessors='true' output='false' displayname='Avalara-Address' 
extends="Slatwall.integrationServices.IntegrationTypeAddressBase"
implements="Slatwall.integrationServices.IntegrationTypeAddressInterface" {

	property name='avataxService' type='any' persistent='false';

	public any function init() {
		setAvataxService( getService('avataxService') );
		return this;
	}
	
	
	/**
	 * Function to test if we're able to communicate with the Avalara APIs
	 * API Endpoint: "GET /utilities/ping"
	 * 
	 * Example Response:
	 * { "version": "19.11.0", "authenticated": false, "authenticationType": "None" }
	 * 
	*/
	public struct function testIntegration() {
		return this.getAvalaraService().makeApiRequest('GET /utilities/ping');
	}

	/**
	 * Function to validate the address with Avalara
	 * @returns Struct of Success/failure response
	*/
	public struct function validateAddress(required struct address) {
		return this.getAvalaraService().validateAddress(argumentsCollection = arguments);
	}
	
	


}



/** 
 * 
 * 
 * 
 * 			
* typical successful response: 
{
	"address": {
		"textCase": "Upper",
		"line1": "2000 Main Street",
		"city": "Irvine",
		"region": "CA",
		"country": "US"
	},
	"validatedAddresses": [
		{
		"addressType": "StreetOrResidentialAddress",
		"line1": "2000 MAIN ST",
		"line2": "",
		"line3": "",
		"city": "IRVINE",
		"region": "CA",
		"country": "US",
		"postalCode": "92614-7202",
		"latitude": 33.684716,
		"longitude": -117.851489
		}
	],
	"coordinates": {
		"latitude": 33.684716,
		"longitude": -117.851489
	},
	"resolutionQuality": "Intersection",
	"taxAuthorities": [
		{
		"avalaraId": "267",
		"jurisdictionName": "ORANGE",
		"jurisdictionType": "County",
		"signatureCode": "AHXU"
		},
		{
		"avalaraId": "5000531",
		"jurisdictionName": "CALIFORNIA",
		"jurisdictionType": "State",
		"signatureCode": "AGAM"
		},
		{
		"avalaraId": "2001061425",
		"jurisdictionName": "ORANGE COUNTY DISTRICT TAX SP",
		"jurisdictionType": "Special",
		"signatureCode": "EMAZ"
		},
		{
		"avalaraId": "2001061784",
		"jurisdictionName": "ORANGE CO LOCAL TAX SL",
		"jurisdictionType": "Special",
		"signatureCode": "EMTN"
		},
		{
		"avalaraId": "2001067270",
		"jurisdictionName": "IRVINE",
		"jurisdictionType": "City",
		"signatureCode": "MHWX"
		},
		{
		"avalaraId": "2001077261",
		"jurisdictionName": "IRVINE HOTEL IMPROVEMENT DISTRICT",
		"jurisdictionType": "Special",
		"signatureCode": "NQKV"
		}
	]
}

***************************

* typical error response: 
{
	"error": {
		"code": "InvalidAddress",
		"message": "The address value was incomplete.",
		"target": "IncorrectData",
		"details": [
		{
			"code": "InvalidAddress",
			"number": 309,
			"message": "The address value was incomplete.",
			"description": "The address value NULL was incomplete. You must provide either a valid postal code, line1 + city + region, or line1 + postal code.",
			"faultCode": "Client",
			"helpLink": "http://developer.avalara.com/avatax/errors/InvalidAddress",
			"severity": "Error"
		}
		]
	}
}
*/