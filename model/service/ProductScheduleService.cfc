/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/

component  extends="HibachiService" accessors="true" {

	property name="dataService" type="any";  
	property name="contentService" type="any";
	property name="optionService" type="any";
	
	// ===================== START: Logical Methods ===========================
	public any function getscheduleEndTypeOptions() {
		if(!structKeyExists(variables, "scheduleEndTypeOptions")) {
			var smartList = getService("settingService").getTypeSmartList();
			smartList.addSelect(propertyIdentifier="type", alias="name");
			smartList.addSelect(propertyIdentifier="typeID", alias="value");
			smartList.addFilter(propertyIdentifier="parentType_systemCode", value="scheduleEndType"); 
			smartList.addOrder("type|ASC");
			variables.scheduleEndTypeOptions = smartList.getRecords();
		}
		return variables.scheduleEndTypeOptions;
	}
	
	public any function getRepeatTimeUnitOptions() {
		var options = [
			{name="Day of the week", value="week"},
			{name="Day of the month", value="month"}
		];
		return options;
	}
	
	public any function getSchedulingTypeOptions() {
		if(!structKeyExists(variables, "schedulingTypeOptions")) {
			var smartList = getService("settingService").getTypeSmartList();
			smartList.addSelect(propertyIdentifier="type", alias="name");
			smartList.addSelect(propertyIdentifier="typeID", alias="value");
			smartList.addFilter(propertyIdentifier="parentType_systemCode", value="schedulingType"); 
			smartList.addOrder("type|D");
			variables.schedulingTypeOptions = smartList.getRecords();
		}
		return variables.schedulingTypeOptions;
	}
	
	public array function getRecurringTimeUnitOptions() {
		if(!structKeyExists(variables, "recurringTimeUnitTypeOptions")) {
			var smartList = getService("settingService").getTypeSmartList();
			smartList.addSelect(propertyIdentifier="type", alias="name");
			smartList.addSelect(propertyIdentifier="typeID", alias="value");
			smartList.addFilter(propertyIdentifier="parentType_systemCode", value="recurringTimeUnitType"); 
			smartList.addOrder("type|ASC");
			variables.recurringTimeUnitTypeOptions = smartList.getRecords();
		}
		return variables.recurringTimeUnitTypeOptions;
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	// =====================  END: Delete Overrides ===========================
	
}