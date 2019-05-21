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
component extends="Slatwall.org.Hibachi.HibachiObject" {

	public any function init() {
		return this;
	}
	
	public string function getDisplayName() {
		return "Not Defined";
	}
	
	public string function getIntegrationTypes() {
		return "";
	}
	
	public struct function getSettings() {
		return {};
	}

	// @hint Determines whether integration should allow site specific setting overrides
	public boolean function getAllowSiteSpecificSettingsFlag() {
		return false;
	}

	// @hint comma-delimitd list of settings to display that allow site specific overrides (without 'integration{packageName}' prefix)
	public string function getAllowedSiteSettingNames() {
		return "";
	}

	public string function getAllowedSiteSettingNamesPrefixed() {
		variables.settingNamesPrefixed = "";
		for (var settingName in listToArray(getAllowedSiteSettingNames())) {
			variables.settingNamesPrefixed = listAppend(variables.settingNamesPrefixed, "integration#getPackageName()##settingName#");
		}
		return variables.settingNamesPrefixed;
	}
	
	public array function getEventHandlers() {
		return [];
	} 
	
	public array function getDetailActions(){
		return [];
	}
	
	public array function getMenuItems() {
		return [];
	}
	
	public string function getAdminNavbarHTML() {
		return '';
	}
	
	public string function getJSObjectAdditions() {
		return '';
	}
	
	// @hint helper function to return a Setting
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		//preventing multiple look ups on the external cache look up
		var cacheKey = "#arguments.settingName##arguments.formatValue#";
		for(var filterEntity in arguments.filterEntities){
			cacheKey &= filterEntity.getPrimaryIDValue();
		}
		if(!structKeyExists(variables,cacheKey)){
			if(structKeyExists(getIntegration().getSettings(), arguments.settingName)) {
				variables[cacheKey] = getService("settingService").getSettingValue(settingName="integration#getPackageName()##arguments.settingName#", object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);	
			}else{
				variables[cacheKey] = getService("settingService").getSettingValue(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
			}
		}
		
		return variables[cacheKey];
	
		
	}
	
	// @hint helper function to return the integration entity that this belongs to
	public any function getIntegration() {
		return getService("integrationService").getIntegrationByIntegrationPackage(getPackageName());
	}
	
	// @hint helper function to return the packagename of this integration
	public any function getPackageName() {
		return lcase(listGetAt(getClassFullname(), listLen(getClassFullname(), '.') - 1, '.'));
	}
}
