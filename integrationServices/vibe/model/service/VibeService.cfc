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

	private any function getIntegration(){
		
		if( !structKeyExists(variables,'integration') ){
			variables.integration = getService('integrationService').getIntegrationByIntegrationPackage( 'vibe' );
		}
		
		return variables.integration;
	}
	
	private string function formatDistibutorName(required any account){
		var distributorName = '';
		
		if( len(arguments.account.getLastName()) ){
			distributorName &= '#arguments.account.getLastName()#, ';
		}
		
		distributorName &= '#arguments.account.getFirstName()#';
		
		return left(distributorName, 60);
	}
	
	private string function formatDistributorType(string accountType){
		
		if(!structKeyExists(arguments, 'accountType')){
			return 'C';
		}
		var mapping = {
			'MarketPartner' = 'D',
			'VIP'           = 'P',
			'Customer'      = 'C'
		};
		
		return structKeyExists(mapping, accountType) ? mapping[accountType] : 'C';
	}

	public string function getCityStateZipcode(required any address) {
		var cityStateZipcode = "";
		cityStateZipcode = listAppend(cityStateZipcode,address.getCity());
		cityStateZipcode = listAppend(cityStateZipcode,address.getStateCode());
		cityStateZipcode = listAppend(cityStateZipcode,address.getPostalCode());
		return cityStateZipcode;
	}
	
	public any function convertSwAccountToVibeAccount(required any account){
		
		var distributorData = { 
			'referenceID' = arguments.account.getAccountNumber(), //Potentially Slatwall ID (may only retain in MGB Hub) 
			'distId'      = arguments.account.getAccountNumber(), //Slatwall will be master
			'name'        = formatDistibutorName(arguments.account), // Distributor Name (lastname, firstname)
			'distType'    = formatDistributorType(arguments.account.getAccountType()),//D (MP), P (VIP), C (Customer) 
			'country'     = arguments.account.getPrimaryAddress().getAddress().getCountry().getCountryCode3Digit(),//Member country(ISO Format) e.g. USA
			'address1'    = left(arguments.account.getPrimaryAddress().getAddress().getStreetAddress(), 60),//Member Street Address
			'address2'    = left(arguments.account.getPrimaryAddress().getAddress().getStreet2Address(), 60),//Suite or Apartment Number
			'address3'    = getCityStateZipcode(arguments.account.getPrimaryAddress().getAddress()),
			'city'        = left(arguments.account.getPrimaryAddress().getAddress().getCity(), 25),
			'state'       = left(arguments.account.getPrimaryAddress().getAddress().getStateCode(), 10),
			'postalCode'  = left(arguments.account.getPrimaryAddress().getAddress().getPostalCode(), 15),
			'email'       = left(arguments.account.getEmailAddress(), 60),
			'referralId' = arguments.account.getOwnerAccount().getAccountNumber()//ID of Member who referred person to the business
		};
		
		if(!isNull(arguments.account.getCompany()) && len(arguments.account.getCompany())){
			distributorData['companyname'] = arguments.account.getCompany(); // Distributor Company
		}
		
		if(isDate(arguments.account.getDOB())){
			distributorData['birthDate'] = dateFormat(arguments.account.getDOB(), 'yyyymmdd');//Member Birthday YYYYMMDD
		}
		
		if(len(arguments.account.getRenewalDate())){
			distributorData['renewalDate'] = dateFormat(arguments.account.getRenewalDate(), 'yyyymmdd');//Renewal Date (YYYYMMDD)
		}
		
		if( arguments.account.getAccountGovernmentIdentificationsCount() ){
			distributorData['governmentId'] = arguments.account.getAccountGovernmentIdentifications()[1].getGovernmentIdentificationNumber();//Government ID (Only necessary if using ICE for payout)
		}
		
		if( len(arguments.account.getPhoneNumber()) ){
			distributorData['homePhone'] = left(formatNumbersOnly(arguments.account.getPhoneNumber()), 20);//Home Phone (NNNNNNNNNN)
		}
		
		return distributorData;
	}
	
	
	/**
	 * to be called from entity queue 
	 * 
	*/ 
	public void function push(required any entity, any data ={}){
		
		if( !structKeyExists(arguments.data, 'event') ){
			return;
		}
		
		switch ( arguments.entity.getClassName() ) {
			
			case 'Account':
				arguments.data.DTSArguments = convertSwAccountToVibeAccount(arguments.entity);
				break;
			default:
				return;
		}
		
		getIntegration().getIntegrationCFC('data').pushData(argumentCollection=arguments);
	
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
