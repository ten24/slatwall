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
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public array function getFilesForEntity( required string baseObject, required string baseID, boolean publicflag ) {
		var filterCriteria = arguments;
		return listFile(filterCriteria=filterCriteria);
	}
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function saveFile(required any file, struct data, string context="save") {
		arguments.file = save(entity=arguments.file, data=arguments.data, context=arguments.context);
		
		// only execute file operations when a file is submitted
		if (isSimpleValue(file.getFileUpload()) && len(file.getFileUpload()) && structKeyExists(form, 'fileUpload'))
		{
			// rename file with .cfm extension in order to control file access
			var destinationFilePath = getService("settingService").getSettingValue('globalAssetsFileFolderPath') & "/#arguments.file.getFileID()#.cfm";
			var uploadData = fileUpload(destinationFilePath, 'fileUpload', '*', 'overwrite');
			
			if (uploadData.filewasSaved)
			{
				// extract and retain uploaded file's original extension and resave
				arguments.file.setFileType(uploadData.clientFileExt);
				save(entity=arguments.file, context=arguments.context);
			}
		}
		
		return arguments.file;
	}
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	public any function deleteFile(required any file) {
		var deleteOK = delete(entity=arguments.file);
		
		// only delete file if entity successfully deleted
		if (deleteOK)
		{
			var filePath = getService("settingService").getSettingValue('globalAssetsFileFolderPath') & "/#arguments.file.getFileID()#.cfm";
			if (fileExists(filePath))
			{
				fileDelete(filepath);
			}
		}
		
		return deleteOK;
	}
	
	// =====================  END: Delete Overrides ===========================
	
}