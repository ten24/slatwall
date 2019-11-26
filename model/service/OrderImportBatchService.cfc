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
component extends="HibachiService" persistent="false" accessors="true" output="false" {
	
	// ===================== START: Logical Methods ===========================
	
	public any function processOrderImportBatch_Create(required any orderImportBatch, required any processObject){
	    // If a count file was uploaded, then we can use that
		if( !isNull(arguments.processObject.getBatchFile()) ) {

			getService('hibachiTagService').cfsetting(requesttimeout="600");			
			
			// Get the temp directory
			var tempDir = getHibachiTempDirectory();
			
			// Upload file to temp directory
			var documentData = fileUpload( tempDir,'batchFile','','makeUnique' );
			writeDump(var=documentData,top=4);abort;
			
			//check uploaded file if its a valid text file
			if( documentData.serverFileExt != "txt" && documentData.serverFileExt != "csv"  ){
				
				// Make sure that nothing is persisted
				getHibachiScope().setORMHasErrors( true );
				
				//delete uploaded file if its not a text file
				fileDelete( "#tempDir##documentData.serverFile#" );
				arguments.processObject.addError('invalidFile', getHibachiScope().rbKey('validate.processOrderImportBatch_Create.invalidFile'));
				
			} else {	
				
				
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
					arguments.physical.addMessage('validInfo', getHibachiScope().rbKey('validate.processOrderImportBatch_Create.validInfo', {valid=valid}));
					
					// Add message for non-processed rows
					if(rowError) {
						arguments.physical.addMessage('rowErrorWarning', getHibachiScope().rbKey('validate.processOrderImportBatch_Create.rowErrorWarning', {rowError=rowError}));	
					}
					
					// Add message for not found sku codes
					if(skuCodeError) {
						arguments.physical.addMessage('skuCodeErrorWarning', getHibachiScope().rbKey('validate.processOrderImportBatch_Create.skuCodeErrorWarning', {skuCodeError=skuCodeError}));
					}
		
				// If there were no rows imported then we can add the error message to the processObject
				} else {
					// Make sure that nothing is persisted
					getHibachiScope().setORMHasErrors( true );
					
					// Add the count file error to the process object
					arguments.processObject.addError('batchFile', getHibachiScope().rbKey('validate.processOrderImportBatch_Create.batchFile'));
					
				}// end check for valid count
				
			} // end check for valid text file
			
		}// end check for a valid file name		
		
		// Return the physical that came in from the arguments scope
		return arguments.orderImportBatch;
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
