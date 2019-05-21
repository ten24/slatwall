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
component extends="Slatwall.org.Hibachi.HibachiEntityQueueService" persistent="false" accessors="true" output="false" {
	
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	public void function addQueueHistoryAndDeleteQueue(required any entityQueue, required boolean success){
		var entityQueueHistory = this.newEntityQueueHistory();
		entityQueueHistory.setEntityQueueType(arguments.entityQueue.getEntityQueueType());
		entityQueueHistory.setBaseObject(arguments.entityQueue.getBaseObject());
		entityQueueHistory.setBaseID(arguments.entityQueue.getBaseID());
		entityQueueHistory.setEntityQueueHistoryDateTime(arguments.entityQueue.getEntityQueueDateTime());
		entityQueueHistory.setSuccessFlag(arguments.success);
		entityQueueHistory = this.saveEntityQueueHistory(entityQueueHistory);

		this.deleteEntityQueue(entityQueue);
	}

	public any function processEntityQueue_executeQueue(required any entityQueue, any processObject) {
		//call process from Queued Entity
		var entityService = getServiceByEntityName( entityName=arguments.entityQueue.getBaseObject());
		var processContext = arguments.entityQueue.getProcessMethod();
		var entity = entityService.invokeMethod("get#arguments.entityQueue.getBaseObject()#", {1=arguments.entityQueue.getBaseID()});
		if(isNull(entity)){
			return entityQueue;
		}
		var processData = {'1'=entity};

		if(!isNull(processContext) && entity.hasProcessObject(processContext)){
			processData['2'] = entity.getProcessObject(processContext);
		}

		try{
			var processMethod = entityService.invokeMethod("process#arguments.entityQueue.getBaseObject()#_#arguments.entityQueue.getProcessMethod()#", processData);
			if(!isNull(entityQueue.getLogHistoryFlag()) && entityQueue.getLogHistoryFlag()){
				addQueueHistoryAndDeleteQueue(entityQueue, true);
			}
		}catch(any e){
			if(!isNull(entityQueue.getLogHistoryFlag()) && entityQueue.getLogHistoryFlag()){
				addQueueHistoryAndDeleteQueue(entityQueue, false);
			}
			rethrow;
		}

		return entityQueue;
	}

	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}
