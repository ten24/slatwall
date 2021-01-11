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
component extends='Slatwall.model.service.HibachiService' persistent='false' accessors='true' output='false' {

	// ===================== START: Logical Methods ===========================

	/**
	 * Helper function to return the instance of this integration
	 * TODO: THIS logic can be passed to some-BASE--.cfc
	*/
	private any function getIntegration(){

		if( !structKeyExists(variables,'integration') ){
			variables['integration'] = getService('integrationService').getIntegrationByIntegrationPackage( 'usps' );
		}

		return variables.integration;
	}

	/**
	 * Helper function to return the instance of this integration/Data.cfc
	 * TODO: THIS logic can be passed to some-BASE--.cfc
	*/
	private any function getAddressIntegrationCFC(){
		
		if( !structKeyExists(variables,'addressIntegrationCFC') ){
			variables['addressIntegrationCFC'] = getService('integrationService').getAddressIntegrationCFC( getIntegration() );
		}

		return variables.dataIntegrationCFC;
	}

	/**
	 *  helper function to return setting value by setting-name( both integrationSetting or SlatwallSetting), 
	*/
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		return getAddressIntegrationCFC().setting(argumentCollection = arguments);
	}
	
	/**
	 * verifyAddress return {...... "success" : true .....} if the address passed in is an exact match with
	 * the one the shipping integration provides. Otherwise, it returns {...... "success" : false .....} with either
	 * an error message or a suggested address
	 * 
	 * { 
	 *   "success" : boolean, 
	 *   "message": "error message string if any", 
	 *   "suggestedAddress": {...if any....} 
	 * }
	*/
	public any function verifyAddress(required struct data){
		
		param name="arguments.data.streetAddress" default="";	
		param name="arguments.data.street2Address" default="";
		param name="arguments.data.city" default="";
		param name="arguments.data.stateCode" default="";
		param name="arguments.data.postalCode" default="";	
		param name="arguments.data.countryCode" default="";		
		param name="arguments.data.addressID" default="";
		
		var requestURL = "";
        
        var testingFlag = setting('testingFlag');
        
        if(testingFlag) {
        	requestURL = setting("testAddressAPIEndpointURL");
        } else {
        	requestURL = setting("liveAddressAPIEndpointURL");
        }
		
		var xmlPacket = "";
		var response = {};
		savecontent variable="xmlPacket"{
			include "../VerifyAddressTemplate.cfm"
		}
		
		requestUrl &= "?API=Verify&XML=#trim(xmlPacket)#";
		var httpRequest = new http();
        httpRequest.setMethod("GET");
        if(findNoCase("https://",requestURL)){
			httpRequest.setPort(443);
        } else {
			httpRequest.setPort(80);
        }
		httpRequest.setTimeout(45);
		httpRequest.setURL(requestURL);
		httpRequest.setResolveurl(false);
		
		var xmlResponse = XmlParse(REReplace(httpRequest.send().getPrefix().fileContent, "^[^<]*", "", "one"));
		if (isDefined('xmlResponse.AddressValidateResponse.Address.Error')) {
			
			response['success'] = false;
			response['message'] = xmlResponse.AddressValidateResponse.Address.Error.Description.xmlText;

		} else if(!structKeyExists(xmlResponse,'AddressValidateResponse')){
			response['success'] = false;
			response['message'] = getHibachiScope().rbKey("admin.entity.cannotVerifyAddressNoMessage");
		} else if (	!findNoCase(arguments.data["streetAddress"], xmlResponse.AddressValidateResponse.Address.Address2.xmlText) ||
					!findNoCase(arguments.data["street2Address"], xmlResponse.AddressValidateResponse.Address.Address2.xmlText) ||
					!findNoCase(arguments.data["city"], xmlResponse.AddressValidateResponse.Address.City.xmlText) ||
					!findNoCase(arguments.data["stateCode"], xmlResponse.AddressValidateResponse.Address.State.xmlText) ||
					!findNoCase(arguments.data["postalCode"], xmlResponse.AddressValidateResponse.Address.Zip5.xmlText)
		){
			var formattedZipCode = "";
			if(isDefined('xmlResponse.AddressValidateResponse.Address.Zip4') && len(xmlResponse.AddressValidateResponse.Address.Zip4.xmlText)){
				formattedZipCode = xmlResponse.AddressValidateResponse.Address.Zip5.xmlText & "-" & xmlResponse.AddressValidateResponse.Address.Zip4.xmlText;
			} else {
				formattedZipCode = xmlResponse.AddressValidateResponse.Address.Zip5.xmlText;
			}
			
			response['message'] = "";
			response['suggestedAddress'] = {
				"streetAddress" = xmlResponse.AddressValidateResponse.Address.Address2.xmlText,
				"city" = xmlResponse.AddressValidateResponse.Address.City.xmlText,
				"stateCode" = xmlResponse.AddressValidateResponse.Address.State.xmlText,
				"postalCode" = formattedZipCode,
				"addressID" = arguments.data['addressID']
			};
			
			//match postal code only up to first 5
			
			response['success'] = compareNoCase(arguments.data["streetAddress"],response['suggestedAddress']["streetAddress"]) == 0
								  && compareNoCase(arguments.data["city"],response['suggestedAddress']["city"]) == 0
								  && compareNoCase(arguments.data["stateCode"],response['suggestedAddress']["stateCode"]) == 0
								  && compareNoCase(left(arguments.data["postalCode"],5),left(response['suggestedAddress']["postalCode"],5)) == 0;

		}
		return response;
	}
	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	// =====================  END: Process Methods ============================

	// ====================== START: Save Overrides ===========================

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

}
