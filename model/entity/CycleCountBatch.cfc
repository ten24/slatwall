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
component entityname="SlatwallCycleCountBatch" table="SwCycleCountBatch" output="false" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="physicalService" hb_permission="this" hb_processContexts="physicalcount" {
	
	// Persistent Properties
	property name="cycleCountBatchID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="totalDayCount" ormtype="integer";
	property name="cycleCountBatchName" ormtype="string";

	// Related Object Properties (many-to-one)
	property name="cycleCountBatchStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="cycleCountBatchTypeID" hb_optionsSmartListData="f:parentType.systemCode=cycleCountBatchStatusType";
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	
	// Related Object Properties (one-to-many)
	property name="cycleCountBatchItems" singularname="cycleCountBatchItem" cfc="CycleCountBatchItem" type="array" fieldtype="one-to-many" fkcolumn="CycleCountBatchID" cascade="all-delete-orphan" inverse="true";
	property name="physicals" cfc="Physical" singularname="physical" fieldtype="one-to-many" fkcolumn="cycleCountBatchID" inverse="true";

	// Related Object Properties (many-to-many - owner)
	property name="cycleCountGroups" singularname="cycleCountGroup" cfc="CycleCountGroup" type="array" fieldtype="many-to-many" linktable="SwCycleCountBatchCountGroup" fkcolumn="cycleCountBatchID"  inversejoincolumn="cycleCountGroupID" hint="this is for reference in case we need to look up which groups were seelcted";
	
	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="statusCode" persistent="false";
	property name="physicalsCount" persistent="false";
	property name="futureCounts" persistent="false";
	property name="cycleCountItemsList" persistent="false";
	property name="physicalCountCollectionList" persistent="false";
	
	// ============ START: Non-Persistent Property Methods =================
	public string function getStatusCode() {
		if ( !isNull(getCycleCountBatchStatusType()) ){
			return getCycleCountBatchStatusType().getSystemCode();
		}
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Cycle Count Groups (many-to-many - owner)
	public void function addCycleCountGroup(required any cycleCountGroup) {
		if(arguments.cycleCountGroup.isNew() or !hasCycleCountGroup(arguments.cycleCountGroup)) {
			arrayAppend(variables.cycleCountGroups, arguments.cycleCountGroup);
		}
		if(isNew() or !arguments.cycleCountGroup.hasCycleCountBatch( this )) {
			arrayAppend(arguments.cycleCountGroup.getCycleCountBatches(), this);
		}
	}
	
	public void function removeCycleCountGroup(required any cycleCountGroup) {
		var thisIndex = arrayFind(variables.cycleCountGroups, arguments.cycleCountGroup);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.cycleCountGroups, thisIndex);
		}
		var thatIndex = arrayFind(arguments.cycleCountGroup.getCycleCountBatches(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.cycleCountGroup.getCycleCountBatches(), thatIndex);
		}
	}

	public numeric function getPhysicalsCount(){
		if(!structKeyExists(variables, 'physicalsCount')){
			if(structKeyExists(variables, 'physicals') && arrayLen(variables.physicals)){
				variables.physicalsCount = arrayLen(variables.physicals);
			}else{
				variables.physicalsCount = 0;
			}
		}
		return variables.physicalsCount;
	}
	
	public numeric function getTotalDayCount(){
		if(!structKeyExists(variables,'totalDayCount')){
			var days = 0;
			for(var cycleCountGroup in getCycleCountGroups()){
				if(!isNull(cycleCountGroup.getDaysInCycle()) && cycleCountGroup.getDaysInCycle() > days){
					days = cycleCountGroup.getDaysInCycle();
				}
			}
			variables.totalDayCount = days;
		}
		return variables.totalDayCount;
	}
	
	public numeric function getRemainingDayCount(){
		return getTotalDayCount() - getPhysicalsCount();
	}

	public numeric function getNextDayNumber(){
		return getPhysicalsCount() + 1;
	}
	
	public array function getFutureCounts(){
		if(!structKeyExists(variables,futureCounts)){
			var futureCounts = [];
			var countGroupListings = {};
			var cycleCountGroups = getCycleCountGroups();
			for(var cycleCountGroup in cycleCountGroups){
				countGroupListings[cycleCountGroup.getCycleCountGroupID()] = cycleCountGroup.getFutureCounts(getRemainingDayCount());
			}
			var startDay = 1;
			for(var i = startDay; i < getRemainingDayCount(); i++){
				var dayCount = [];
				for(var key in countGroupListings){
					if(!isNull(countGroupListings[key][i])){
						arrayAppend(dayCount,countGroupListings[key][index],true);
					}else{
						arrayAppend(dayCount,[]);
					}
				}
				arrayAppend(futureCounts,dayCount);
			}
		}

		return variables.futureCounts;
	}
	
	public array function getItemsToCountByDay(required numeric countDay, boolean padArrays = false){
		var countItems = [];
		var cycleDay = countDay + getPhysicalsCount();
		var cycleCountGroups = getCycleCountGroups();
		for(var cycleCountGroup in cycleCountGroups){
			arrayAppend(countItems,cycleCountGroup.getCountItemsByDay(arguments.countDay, cycleDay, arguments.padArrays),true);
		}
		return countItems;
	}
	
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicet Getters ===================
	
	public any function getPhysicalCountCollectionList(){
		if(!structKeyExists(variables,'physicalCountCollectionList')){
			var physicalCountCollectionList = getService('physicalService').getPhysicalCountCollectionList();
			physicalCountCollectionList.addFilter('physical.cycleCountBatch.cycleCountBatchID',this.getCycleCountBatchID());
			physicalCountCollectionList.addOrderBy('countPostDateTime','ASC');
			variables.physicalCountCollectionList = physicalCountCollectionList;
		}
		return variables.physicalCountCollectionList;
	}
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentation() {
		var simpleRep = 'Batch';
		
		if( len(getCycleCountBatchName()) ){
			simpleRep = simpleRep & " - " & getCycleCountBatchName();
		}
		return simpleRep;
	}

	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}
