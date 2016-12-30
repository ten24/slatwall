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

	property name="fileDAO" type="any";

	public any function downloadFile(required string fileID) {
		var file = this.getFile(arguments.fileID, true);

		if (!file.getNewFlag() && fileExists(file.getFilePath())) {
			// Download file
			try {
				getService("hibachiUtilityService").downloadFile(fileName=file.getURLTitle()&'.'&file.getFileType(), filePath=file.getFilePath(), contentType=file.getMimeType(), deleteFile=false);
			} catch (any error) {
				file.addError("fileDownload", rbKey("entity.file.download.fileDownloadError"));
			}
		} else {
			// File does not exist
			file.addError("fileDownload", rbKey("entity.file.download.fileMissingError"));
		}

		return file;
	}

	// ===================== START: Logical Methods ===========================

	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	public array function getRelatedFilesForEntity( required string baseID ) {
		// Find file relationships for base object entity
		return this.listFileRelationship(arguments);
	}

	public any function getRelatedFilesSmartListForEntity( required string baseID) {
		// Find file relationships for base object entity
		var smartlist = this.getFileRelationshipSmartList();
		smartlist.addFilter('baseID',arguments.baseID);
		return smartlist;
	}

	public boolean function removeAllEntityRelatedFiles(required any entity)
	{
		for (var fileRelationshipEntity in arguments.entity.getFiles()) {
			deleteFileRelationship(fileRelationshipEntity);
		}

		return true;
	}

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	// =====================  END: Process Methods ============================

	// ====================== START: Status Methods ===========================

	// ======================  END: Status Methods ============================

	// ====================== START: Save Overrides ===========================

	public any function saveFile(required any file, struct data, string context="save") {

		// Create urlTitle
		if (isNull(arguments.file.getURLTitle())) {

			// Look for URL Title in the data
			if (structKeyExists(arguments, "data") && structKeyExists(arguments.data, "urlTitle") && isSimpleValue(arguments.data.urlTitle) && len(arguments.data.urlTitle)) {
				arguments.file.setURLTitle(getService("hibachiUtilityService").createUniqueURLTitle(titleString=arguments.data.urlTitle, tableName=getMetaData(arguments.file).table));

			// Look for fileName in the data to set a urlTitle
			} else if (structKeyExists(arguments, "data") && structKeyExists(arguments.data, "filename") && isSimpleValue(arguments.data.filename) && len(arguments.data.filename)) {
				arguments.file.setURLTitle(getService("hibachiUtilityService").createUniqueURLTitle(titleString=arguments.data.filename, tableName=getMetaData(arguments.file).table));

			// Look for an non null filename to set the urlTitle
			} else if (!isNull(arguments.file.getFileName())) {
				arguments.file.setURLTitle(getService("hibachiUtilityService").createUniqueURLTitle(titleString=arguments.file.getFileName(), tableName=getMetaData(arguments.file).table));

			}
		}

		arguments.file = save(entity=arguments.file, data=arguments.data, context=arguments.context);

		// Only execute file operations when a file is submitted
		if (isSimpleValue(file.getFileUpload()) && len(file.getFileUpload()) && structKeyExists(form, 'fileUpload')) {

			if (!directoryExists(file.getFileDirectory())) {
				directoryCreate(file.getFileDirectory());
			}

			var typesToAccept = getService("SettingService").getSettingValue("globalMIMETypeWhiteList");

			// Rename file with .cfm extension in order to control file access
			var uploadData = fileUpload(file.getFilePath(), 'fileUpload', typesToAccept, 'overwrite');

			if (uploadData.fileWasSaved) {
				// Extract and retain uploaded file's original extension and mime type then resave
				arguments.file.setFileType(uploadData.clientFileExt);
				arguments.file.setMimeType(uploadData.contenttype & "/" & uploadData.contentsubtype);
				if(ListFindNoCase(getService("SettingService").getSettingValue("globalFileTypeWhiteList"), uploadData.clientFileExt) != 0){
					save(entity=arguments.file, context=arguments.context);
				} else {
					fileDelete(arguments.file.getFilePath());
					arguments.file.addError("InvalidFileType", "The File you have submitted cannot be trusted by the server", true);
					//need to notify the user
				}
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

		// Only delete file if entity successfully deleted
		if (deleteOK) {
			if (fileExists(file.getFilePath())) {
				fileDelete(file.getFilePath());
			}
		}

		return deleteOK;
	}

	public any function deleteFileRelationship(required any fileRelationship)
	{
		var deleteOK = delete(entity=arguments.fileRelationship);

		var relatedFile = fileRelationship.getFile();
		fileRelationship.removeFile(relatedFile);

		// Automatically delete file if it no longer has any entity relationships
		if (!relatedFile.hasFileRelationship()) {
			deleteFile(relatedFile);
		}

		return deleteOK;
	}

	// =====================  END: Delete Overrides ===========================

}