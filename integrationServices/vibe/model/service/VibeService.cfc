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
	
	
	public any function getSetting(required string settingName, array filterEntities=[], formatValue=false) {
		if(structKeyExists(getIntegration().getSettings(), arguments.settingName)) {
			return getService('settingService').getSettingValue(settingName='integration#getPackageName()##arguments.settingName#', object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
		}
		return getService('settingService').getSettingValue(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
	}
	
	public string function appendVibeQueryParamsToURL(required string url, ){
		// var consultant_id = getHibachiScope().getAccount().getVibeID();
		var authentication_key = getSetting('apikey');
		var authentication_key = 'sacacacacacacacacaca;
		var  dateString = DateFormat( DateConvert('local2Utc', now()), "mm/dd/YYYY");
		var string_to_hash = consultant_id & authentication_key & dateString;
		var token = hash(string_to_hash); //default is MD5
		
		return arguments.url &= "&token=#token#&consultant_id=#consultant_id#"
	}
	

	public any function convertSwAccountToVibeAccount(required any account){
		
		return arguments.account.getJsonRepresentation();
	}
	
	
	/**
	 * to be called from entity queue 
	 * 
	*/ 
	public void function push(required any entity, any data ={}){
		dump("in 'VibeService::push' account: #arguments.entity.getAccountID()#");
		dump(arguments.data);
		writelog(file='vibe',text="in 'VibeService::push' account: #arguments.entity.getAccountID()#");

		arguments.data.payload = convertSwAccountToVibeAccount(arguments.entity);
		
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
