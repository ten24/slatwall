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
		var accountNumber = arguments.user.getAccountNumber();
		var authToken = this.setting('ssoAuthKey');

		var dateString = DateFormat( DateConvert('local2Utc', now()), "m/d/YYYY");
		var string_to_hash = accountNumber & authToken & dateString;
		var md5hash = lCase(hash(string_to_hash));
		var token = ToBase64(md5hash);
		
		if( Find("?", arguments.urlString) ) {
			arguments.urlString &= "&token=#token#&consultant_id=#accountNumber#"
		} else{
			arguments.urlString &= "?token=#token#&consultant_id=#accountNumber#"
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
		
		var accountPropList =  "accountID,firstName,lastName,activeFlag,username,accountNumber,accountType,company,languagePreference,enrollmentDate,primaryEmailAddress.emailAddress,primaryPhoneNumber.phoneNumber,ownerAccount.accountNumber";
		var addressPropList = getService('hibachiUtilityService').prefixListItem("streetAddress,street2Address,city,postalCode,stateCode,countryCode", "primaryAddress.address.");

		accountPropList = accountPropList & ',' & addressPropList;
		var swAccountStruct = arguments.account.getStructRepresentation( accountPropList );

		var mapping = {
			'accountNumber':'customerid',
			'firstName':'firstname',
			'lastName':'lastname',
			'username':'screenname',
			'company':'companyname',
			'ownerAccount_accountNumber':'sponsorid',
			'primaryEmailAddress_emailAddress':'email',
			'primaryPhoneNumber_phoneNumber':'homephone',
			'primaryAddress_address_street2Address':'address1',
			'primaryAddress_address_city':'city',
			'primaryAddress_address_stateCode':'state',
			'primaryAddress_address_postalCode':'zip',
			'primaryAddress_address_countryCode':'country',
			'languagePreference':'preferredlanguage'
		};

		var vibeAccount = {};
		
		for(var fromKey in mapping){
			if( StructKeyExists( swAccountStruct, fromKey ) && !IsNull(swAccountStruct[fromKey]) ){
				vibeAccount[mapping[fromKey]] = swAccountStruct[fromKey];
			}
		}
		
		if( !StructKeyExists( swAccountStruct, 'activeFlag' ) || IsNull(swAccountStruct['activeFlag']) ) {
			vibeAccount['statusid'] = 1; // we treat null as active
		} else if( IsBoolean(swAccountStruct['activeFlag']) ) {
			vibeAccount['statusid'] = swAccountStruct['activeFlag'] ? 1 : 0;
		}
		
		vibeAccount['typeid'] = 1; //default for customer(Retail) type
	
		if( StructKeyExists( swAccountStruct, 'accountType' ) &&  !IsNull(swAccountStruct['accountType']) && Len( Trim(swAccountStruct['accountType'] ) )) {

			swAccountStruct['accountType'] = Lcase(swAccountStruct['accountType']);
			
			if( swAccountStruct['accountType'] == 'vip' ) {
				vibeAccount['typeid'] = 2; 
			}else if( swAccountStruct['accountType'] == 'marketpartner' ) {
				vibeAccount['typeid'] = 3; 
				vibeAccount['rankid'] = 1; 
				vibeAccount['lifetimerankid'] = 1; 
			}
		}
		
		if( StructKeyExists( swAccountStruct, 'enrollmentDate' ) &&  !IsNull( swAccountStruct['enrollmentDate']) ){
			//2019-08-25T15:23:42.7198285+05:30
			vibeAccount['signupdate'] = DateTimeFormat( swAccountStruct['enrollmentDate'], "yyyy-mm-dd'T'hh:nn:ss" );
		}
		
		vibeAccount['password'] = setting('defaultUserPassword');
	
		return vibeAccount;		
	}
	
	
	/**
	 * @hint helper function, to push Data into @thisIntegration/Data.cfc for further processing, from EntityQueue
	 * 
	*/ 
	public void function push(required any entity, any data ={}){
		logHibachi("VIBE - Start pushData - Account: #arguments.entity.getAccountID()#");
		
		arguments.data.payload = this.convertSwAccountToVibeAccount(arguments.entity);
		getDataIntegrationCFC().pushData(argumentCollection=arguments);
		
		logHibachi("VIBE - End pushData");
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
