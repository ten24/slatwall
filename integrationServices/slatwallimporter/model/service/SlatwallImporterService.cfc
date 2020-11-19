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
component extends="Slatwall.integrationServices.BaseImporterService" persistent="false" accessors="true" output="false"{
	
	property name="integrationServices";
	property name="hibachiDataService";
	property name="hibachiUtilityService";
	
	public any function getIntegration(){
	    
	    if( !structKeyExists( variables, 'integration') ){
	        variables.integration = this.getIntegrationByIntegrationPackage('slatwallimporter');
	    }
        return variables.integration;
    }
    
    
  	public struct function getAvailableSampleCsvFilesIndex(){
  	    
  	    if( !structKeyExists(variables, 'availableSampleCsvFilesIndex') ){
  	        
            //creating struct for fast-lookups
            variables.sampleCSVFilesOptions = {
                "Account"		    : "account",
                "Product"		    : "product",
                "Sku"   	    	: "sku",
                "Inventory"         : "inventory",
                "OrderItem"         : "orderItem",                
                "OrderFulfillment"  : "orderFulfillment"
            };
            // TODO, need a way to figureout which entity-mappings are allowed to be import, 
            // account vs account-phone-number
  	    }
  	    
  	    return variables.sampleCSVFilesOptions;
  	}
  	
  	public any function uploadCSVFile( required any data ){
  	    
		var importFilesUploadDirectory = this.getVirtualFileSystemPath() & '/importcsv/'; 

		try{
			var uploadData = FileUpload( importFilesUploadDirectory, "uploadFile", "text/csv", "makeunique");
			
			if ( !listFindNoCase("csv", uploadData.serverFileExt) ){
    		 	this.getHibachiScope().showMessage("The uploaded file is not of type CSV.", "error");
    	    }
    	    
    	    var header = this.getEntityCSVHeaderMetaData( data.entityName );
    	    var uploadedFilePath = uploadData.serverdirectory & '/' & uploadData.serverfile;
			
	    	var result = this.getHibachiDataService().csvFileToQuery(
				'csvFilePath'           = uploadedFilePath, 
				'columnTypes'           = header.columnTypes, 
				'columns'               = header.columns,
				'useHeaderRowAsColumns' = false
			);
			
			 // Adding this check so it doesn't mess with the UI
		    if( result.errors.len() <= 10 ){
			    
			    for( var error in result.errors ){
    				this.getHibachiScope().addError( "line-#error.line#", "Invalid data at Line-#error.line#, #ArrayToList(error.record)#" );
    			}
    			
		    } else {
		        
		        this.getHibachiScope().addError( "Errors in CSV", "CSV has invalid data at #result.errors.len()# lines" );
		    }
			
			
			if( result.query.recordCount ){

    		    var batch = this.pushRecordsIntoImportQueue( data.entityName, result.query );
    		    
    		    if( batch.getEntityQueueItemsCount() == batch.getInitialEntityQueueItemsCount() ){
    			    this.getHibachiScope().showMessage("All #batch.getInitialEntityQueueItemsCount()# items has been pushed to import-queue Successfully", "success");
    		    } 
    		    else {
    		        this.getHibachiScope().showMessage("#batch.getEntityQueueItemsCount()# out of #batch.getInitialEntityQueueItemsCount()# items has been pushed to import-queue", "warning");
    		    }
			} 
			// if there's no record count in the query, then there were some issues in the parsing 
			else {
			    this.getHibachiScope().showMessage("Nothing got imported", "warning");
			    this.getHibachiScope().showErrorsAndMessages();
			}
		    
			//delete uploaded file
			fileDelete( uploadedFilePath );
			
			if( !isNull(batch) ){
			    return batch;
			}
		} 
		catch ( any e ){ 
			this.getHibachiUtilityService().logException( e );
    		this.getHibachiScope().showMessage("An error occurred while uploading your file - " & e.Message, "error");
		}
		
  	}
}
