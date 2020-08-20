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


component accessors="true" output="false" displayname="Monat" extends="Slatwall.org.Hibachi.HibachiObject" {
	// Variables Saved in this application scope, but not set by end user
	
	public any function init(){
		return this;
	}

	public any function testIntegration() {
		
	}

	// @hint helper function to return a Setting
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		if(structKeyExists(getIntegration().getSettings(), arguments.settingName)) {
			return getService("settingService").getSettingValue(settingName="integration#getPackageName()##arguments.settingName#", object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
		}
		return getService("settingService").getSettingValue(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
	}

	// @hint helper function to return the integration entity that this belongs to
	public any function getIntegration() {
		return getService("integrationService").getIntegrationByIntegrationPackage(getPackageName());
	}

	// @hint helper function to return the packagename of this integration
	public any function getPackageName() {
		return lcase(listGetAt(getClassFullname(), listLen(getClassFullname(), '.') - 1, '.'));
	}

	public any function getContentByResponse(required string response){
		return deserializeJson(arguments.response.fileContent);
	}
	
	public any function pullData(){

	}
	
	public void function importAccountUpdates(required struct rc){
		try{
			getService("MonatDataService").importAccountUpdates(argumentCollection=arguments);
		}catch(any accountErrors){
			logHibachi("The account update failed with #accountErrors.message#");
		}
	}
	
	public void function importOrderUpdates(required struct rc){
		try{
			getService("MonatDataService").importOrderUpdates(argumentCollection=arguments);
		}catch(any orderErrors){
			logHibachi("The order update failed with #orderErrors.message#");
		}
	}
	
	public void function importOrderShipments(required struct rc){
		try{
			getService("MonatDataService").importOrderShipments(argumentCollection=arguments);
		}catch(any shipmentErrors){
			logHibachi("The shipment update failed with #shipmentErrors.message#");
		}
	}
	
	public void function importInventoryUpdates(required struct rc){
		try{
			getService("MonatDataService").importInventoryUpdates(argumentCollection=arguments);
		}catch(any inventoryErrors){
			logHibachi("The inventory update failed with #inventoryErrors.message#");
		}
	}
	
	public void function importMonatProducts(required struct rc){
		try{
			getService("MonatDataService").importMonatProducts(argumentCollection=arguments);
		}catch(any inventoryErrors){
			logHibachi("The product update failed with #inventoryErrors.message#");
		}
	}
}

