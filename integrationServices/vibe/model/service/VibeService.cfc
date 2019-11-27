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
	 * @hint helper function to return the instance of this integration
	*/
	private any function getIntegration(){

		if( !structKeyExists(variables,'integration') ){
			variables['integration'] = getService('integrationService').getIntegrationByIntegrationPackage( 'vibe' );
		}

		return variables.integration;
	}

	/**
	 * @hint helper function to return the instance of this integration/Data.cfc
	*/
	private any function getDataIntegrationCFC(){

		if( !structKeyExists(variables,'dataIntegrationCFC') ){
			variables['dataIntegrationCFC'] = getService('integrationService').getDataIntegrationCFC( getIntegration() );
		}

		return variables.dataIntegrationCFC;
	}

	/**
	 *  helper function to return setting value by setting-name( both integrationSetting or SlatwallSetting), 
	*/
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		return getDataIntegrationCFC().setting(argumentCollection = arguments);
	}

	/**
	 * helper function, to add query params to the redirect URL, after successful authentication
	 * 
	*/ 
	public string function appendVibeQueryParamsToURL(required string urlString, required any user ){
		var consultant_id = arguments.user.getVibeUserID();
		var authToken = this.setting('authToken');
		var dateString = DateFormat( DateConvert('local2Utc', now()), "mm/dd/YYYY");
		
		var string_to_hash = consultant_id & authToken & dateString;
		var token = hash(string_to_hash); //default hashing algo is MD5
		
		if( Find("?", arguments.urlString) ) {
			arguments.urlString &= "&token=#token#&consultant_id=#consultant_id#"
		} else{
			arguments.urlString &= "?token=#token#&consultant_id=#consultant_id#"
		}
		
		return arguments.urlString;
	}
	
	
	/**
	 * @hint helper function to create a struct of properties+values from @entity/Account.cfc.
	 * 
	 * @account, @enty/Account.cfc 
	 * @returns, Struct of account properties+values required by Vibe createUser API.
	*/ 
	public any function convertSwAccountToVibeAccount(required any account){
		
		var accountPropList =  "accountID,firstName,lastName,activeFlag,username,accountNumber,accountType,languagePreference,primaryEmailAddress.emailAddress,primaryPhoneNumber.phoneNumber";
		var addressPropList = getService('hibachiUtilityService').prefixListItem("streetAddress,street2Address,city,postalCode,stateCode,countryCode", "primaryAddress.address.");

		accountPropList = accountPropList & ',' & addressPropList;
		var swAccountStruct = arguments.account.getStructRepresentation( accountPropList );

		/* required fields
			{	"user" : {
					"customerid":12345678,
					"screenname":"nitin.testing12",
					"firstname": "Nitin",
					"lastname" : "yadav",
					"companyname":"ten 24",
					"email" :"test.test1233@test.com",
					"typeid" : 1,
					"statusid" : 1,
					"password": "Changeme@123"
				}
			}
		*/

		var vibeAccount = {};
		vibeAccount['customerid'] = swAccountStruct['accountNumber'] ;
		vibeAccount['firstname'] = swAccountStruct['firstName'];
		vibeAccount['lastname'] = swAccountStruct['lastName'];
		vibeAccount['screenname'] = swAccountStruct['username'];
		
		vibeAccount['email'] = swAccountStruct['primaryEmailAddress_emailAddress'];
		vibeAccount['homephone'] = swAccountStruct['primaryPhoneNumber_phoneNumber'];
		
		vibeAccount['address1'] = swAccountStruct['primaryAddress_address_streetAddress'];
		vibeAccount['address2'] = swAccountStruct['primaryAddress_address_street2Address'];
		vibeAccount['city'] = swAccountStruct['primaryAddress_address_city'];
		vibeAccount['state'] = swAccountStruct['primaryAddress_address_stateCode'];
		vibeAccount['zip'] = swAccountStruct['primaryAddress_address_postalCode'];
		vibeAccount['country'] = swAccountStruct['primaryAddress_address_countryCode'];

		if( StructKeyExists( swAccountStruct, 'languagePreference' ) && !IsNull(swAccountStruct.languagePreference) ){
			vibeAccount['preferredlanguage'] = swAccountStruct['languagePreference'];
		}
		
		if( !StructKeyExists( swAccountStruct, 'activeFlag' ) || IsNull(swAccountStruct.activeFlag) ) {
			vibeAccount['statusid'] = 1; // we treat null as active
		} 
		else if( IsBoolean(swAccountStruct.activeFlag) ) {
			vibeAccount['statusid'] = swAccountStruct.activeFlag ? 1 : 0;
		}
		
		vibeAccount['type'] = 1; //default for customer(Retail) type
		if( StructKeyExists( swAccountStruct, 'accountType' ) && 
			!IsNull(swAccountStruct.accountType) &&
			Len( Trim(swAccountStruct.accountType ) )
		) {
			
			swAccountStruct.accountType = Lcase(swAccountStruct.accountType);
			if( swAccountStruct.accountType == 'vip' ) {
				vibeAccount['type'] = 2; 
			} 
			else if( swAccountStruct.accountType = 'marketpartner' ) {
				vibeAccount['type'] = 3; 
			}
		}

		vibeAccount['password'] = setting('defaultUserPassword');
		
		return vibeAccount;		
	}
	
	
	/**
	 * @hint helper function, to push Data into @thisIntegration/Data.cfc for further processing, from EntityQueue
	 * 
	*/ 
	public void function push(required any entity, any data ={}){
		arguments.data.payload = this.convertSwAccountToVibeAccount(arguments.entity);
		getDataIntegrationCFC().pushData(argumentCollection=arguments);
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
