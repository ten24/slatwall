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
component displayname="Integration" entityname="SlatwallIntegration" table="SwIntegration" persistent=true output=false accessors=true extends="HibachiEntity" cacheuse="transactional" hb_serviceName="integrationService" hb_permission="this" hb_defaultOrderProperty="integrationName" {
	
	// Persistent Properties
	property name="integrationID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="integrationPackage" ormtype="string" unique="true";
	property name="integrationName" ormtype="string";
	property name="installedFlag" ormtype="boolean";
	
	//Active Flag and IntegrationTypeList
	property name="activeFlag" ormtype="boolean";
	property name="integrationTypeList" ormtype="string"; 
	
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-persistent properties
	property name="enabledFlag" type="boolean" persistent="false";
	
	
	public boolean function getEnabledFlag() {
		return getActiveFlag();
	}
	
	public array function getShippingMethodOptions() {
		if(!structKeyExists(variables, "shippingMethodOptions")) {
			var integrationSmartlist = getService("integrationService").getIntegrationSmartList();
			integrationSmartlist.addFilter('activeFlag', '1');
			integrationSmartlist.addLikeFilter('integrationTypeList', '%shipping%');
			integrationSmartlist.addSelect('integrationName', 'name');
			integrationSmartlist.addSelect('integrationID', 'value');
			variables.shippingMethodOptions = integrationSmartlist.getRecords();
		}
		return variables.shippingMethodOptions;
	}	

	public any function getIntegrationCFC( string integrationType="" ) {
		switch (arguments.integrationType) {
			case "authentication" : {
				return getService("integrationService").getAuthenticationIntegrationCFC(this);
				break;
			}
			case "payment" : {
				return getService("integrationService").getPaymentIntegrationCFC(this);
				break;
			}
			case "shipping" : {
				return getService("integrationService").getShippingIntegrationCFC(this);
				break;
			}
			case "tax" : {
				return getService("integrationService").getTaxIntegrationCFC(this);
				break;
			}
			default : {
				return getService("integrationService").getIntegrationCFC(this);
			}
		}
	}
	
	public any function getSettings() {
		return getIntegrationCFC().getSettings();
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public boolean function isDeletable() {
		return false;
	}
	
	// @hint helper function to return a Setting
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		if(structKeyExists(getSettings(), arguments.settingName)) {
			return getService("settingService").getSettingValue(settingName="integration#getIntegrationPackage()##arguments.settingName#", object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);	
		}
		return super.setting(argumentcollection=arguments);
	}
	
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}

