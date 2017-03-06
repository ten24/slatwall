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
component extends="HibachiService" accessors="true" output="false" {

	property name="physicalDAO" type="any";
	
	property name="locationService" type="any";
	property name="skuService" type="any";
	property name="stockService" type="any";
	property name="settingService" type="any";
	property name="typeService" type="any";
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public query function getPhysicalDiscrepancyQuery() {
		return getPhysicalDAO().getPhysicalDiscrepancyQuery(argumentCollection=arguments);
	}
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// Physical 
	public any function processPhysical_commit(required any physical) {
		
		// Setup a locations adjustment to only create 1 new stock adjustment per location
		var locationAdjustments = {};
		
		// get the discrepancy records
		var physicalCountDescrepancies = arguments.physical.getDiscrepancyQuery();
		
		// Loop over discrepancy records
		for(var rowCount=1; rowCount <= physicalCountDescrepancies.recordCount; rowCount++) {
			
			if(!structKeyExists(locationAdjustments, physicalCountDescrepancies["locationID"][rowCount])) {
				var location = getLocationService().getLocation( physicalCountDescrepancies["locationID"][rowCount] );
				locationAdjustments[ location.getLocationID() ] = getStockService().newStockAdjustment();
				locationAdjustments[ location.getLocationID() ].setToLocation( location );
				locationAdjustments[ location.getLocationID() ].setFromLocation( location );
				locationAdjustments[ location.getLocationID() ].setStockAdjustmentType( getTypeService().getTypeBySystemCode("satPhysicalCount") );
				locationAdjustments[ location.getLocationID() ].setStockAdjustmentStatusType( getTypeService().getTypeBySystemCode("sastNew") );
				locationAdjustments[ location.getLocationID() ].setPhysical( arguments.physical );
			}
			
			var stockAdjustment = locationAdjustments[ physicalCountDescrepancies["locationID"][rowCount] ];
			var stock = getStockService().getStock( physicalCountDescrepancies["stockID"][rowCount] );
			var stockAdjustmentItem = getStockService().newStockAdjustmentItem();
			
			// Attach the item to the adjustment
			stockAdjustmentItem.setStockAdjustment( stockAdjustment );
			
			// If discrepancy > 0 set the stockIn attribute
			if( physicalCountDescrepancies["discrepancy"][rowCount] > 0 ){
				
				stockAdjustmentItem.setToStock( stock );
				stockAdjustmentItem.setQuantity( physicalCountDescrepancies["discrepancy"][rowCount] );
				
			// If the discrepancy < 0 then set the stockOut attribute
			} else {
				
				stockAdjustmentItem.setFromStock( stock );
				stockAdjustmentItem.setQuantity( physicalCountDescrepancies["discrepancy"][rowCount]*-1 );
			}
			
		}
		
		// process each of the the stockAdjustments
		for(var key in locationAdjustments) {
			getStockService().processStockAdjustment(locationAdjustments[key], structNew(), "processAdjustment");
		}
		
		//set physical status to closed
		arguments.physical.setPhysicalStatusType( getTypeService().getTypeBySystemCode('pstClosed') );
		
		return arguments.physical;
	}
	
	public any function processPhysical_addPhysicalCount(required any physical, required any processObject) {
		// Create a new Physical count
		var physicalCount = this.newPhysicalCount();
		
		// Set the physical for this count
		physicalCount.setPhysical( arguments.physical );
		
		// Set the location for this count
		physicalCount.setLocation( getLocationService().getLocation( arguments.processObject.getLocationID() ));
		
		// Set the count post date time
		physicalCount.setCountPostDateTime( arguments.processObject.getCountPostDateTime() );
		
		// Save the physicalCount in hibernate scope
		this.savePhysicalCount( physicalCount );
		
		// If a count file was uploaded, then we can use that
		if( !isNull(arguments.processObject.getCountFile()) ) {
			
			// Get the temp directory
			var tempDir = getHibachiTempDirectory();
			
			// Upload file to temp directory
			var documentData = fileUpload( tempDir,'countFile','','makeUnique' );
			
			//check uploaded file if its a valid text file
			if( documentData.serverFileExt != "txt" ){
				
				// Make sure that nothing is persisted
				getHibachiScope().setORMHasErrors( true );
				
				//delete uploaded file if its not a text file
				fileDelete( "#tempDir##documentData.serverFile#" );
				arguments.processObject.addError('invalidFile', getHibachiScope().rbKey('validate.processPhysical_addPhysicalCount.invalidFile'));
				
			} else {	
				
				// set meta data
				var fileName = documentData.serverFile;	
				
				// Read the File from temp directory 
				var fileObj = fileOpen( "#tempDir##fileName#", "read" );
				
				// Setup a valid entity boolean to be set to true once one line meets requirements
				var valid = 0; 
				var rowError = 0;
				var skuCodeError = 0;
				
				// Loop over the records in the file we just read
				while( !fileIsEof( fileObj ) ) {
					 
					var fileRow = fileReadLine( fileObj ); 
		
					if( listLen(fileRow) >= 2 && isNumeric(listGetAt(fileRow, 2)) ) {
						valid++;
						
						// Create a PhysicalCountItem for each row in the file
						var physicalCountItem = this.newPhysicalCountItem();
						physicalCountItem.setPhysicalCount( physicalCount );
						
						// Set the original skuCode value
						physicalCountItem.setSkuCode( listGetAt( fileRow, 1 ) );
						
						// Set the quantity that was verified above
						physicalCountItem.setQuantity( listGetAt( fileRow, 2 ) );
						
						// Check for a countPostDateTime on the record
						if(listLen(fileRow) >= 3 && isDate(listGetAt(fileRow, 3))) {
							physicalCountItem.setCountPostDateTime(listGetAt(fileRow, 3));
						}
						
						// Get sku from sku code
						var sku = getSkuService().getSkuBySkuCode( physicalCountItem.getSkuCode() );
						
						if( !isNull(sku) ){
							// Get stock by sku and location
							var stock = getStockService().getStockBySkuAndLocation(sku, physicalCount.getLocation());
							
							// Set physical stock from scanned data
							physicalCountItem.setStock( stock );
						} else {
							skuCodeError++;	
						}
						
						// Save each physicalcountitem 
						this.savePhysicalCountItem( physicalCountItem );
					} else {
						rowError++;
					}
				}
				
				// Close the file object
				fileClose( fileObj ); 
				
				// As long as one count item was created we should save the count and just display a message
				if(valid) {
					
					// Get the assets folder from the global assets folder
					var assetsFileFolderPath = getHibachiScope().setting('globalAssetsFileFolderPath');
					
					// Create the folder if it does not exist 
					if(!directoryExists("#assetsFileFolderPath#/physicalcounts/")) {
						directoryCreate("#assetsFileFolderPath#/physicalcounts/");
					}
					
					// Move a copy of the file from the temp directory to /custom/assets/files/physicalcounts/{physicalCount.getPhysicalCountID()}.txt
					filemove( "#tempDir##fileName#", "#assetsFileFolderPath#/physicalcounts/#physicalCount.getPhysicalCountID()#.txt" );
					
					// Add info for how many were matched
					arguments.physical.addMessage('validInfo', getHibachiScope().rbKey('validate.processPhysical_addPhysicalCount.validInfo', {valid=valid}));
					
					// Add message for non-processed rows
					if(rowError) {
						arguments.physical.addMessage('rowErrorWarning', getHibachiScope().rbKey('validate.processPhysical_addPhysicalCount.rowErrorWarning', {rowError=rowError}));	
					}
					
					// Add message for not found sku codes
					if(skuCodeError) {
						arguments.physical.addMessage('skuCodeErrorWarning', getHibachiScope().rbKey('validate.processPhysical_addPhysicalCount.skuCodeErrorWarning', {skuCodeError=skuCodeError}));
					}
		
				// If there were no rows imported then we can add the error message to the processObject
				} else {
					// Make sure that nothing is persisted
					getHibachiScope().setORMHasErrors( true );
					
					// Add the count file error to the process object
					arguments.processObject.addError('countFile', getHibachiScope().rbKey('validate.processPhysical_addPhysicalCount.countFile'));
					
				}// end check for valid count
				
			} // end check for valid text file
			
		}// end check for a valid file name		
		
		// Return the physical that came in from the arguments scope
		return arguments.physical;
	}


	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	
	public any function savePhysicalCountItem(required any entity, struct data={}) {
		
		// Call the super to do the standard logic
		arguments.entity = this.save(entity=arguments.entity, data=arguments.data);
		
		// As long as there is a physical count attached to this item, we can attach a stock that might not have been attached before, or if the sku has changed for this countItem, then we can update the stock to refelect
		if(!isNull(arguments.entity.getPhysicalCount()) && ((isNull(arguments.entity.getStock()) && !isNull(arguments.entity.getSku())) || (!isNull(arguments.entity.getStock()) && !isNull(arguments.entity.getSku()) && arguments.entity.getStock().getSku().getSkuID() != arguments.entity.getSku().getSkuID()))) {
			arguments.entity.setStock(getStockService().getStockBySkuAndLocation(sku=arguments.entity.getSku(), location=arguments.entity.getPhysicalCount().getLocation()));
		}
		
		// Return the entity
		return arguments.entity;
	}
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	// =====================  END: Delete Overrides ===========================
	
	
}

