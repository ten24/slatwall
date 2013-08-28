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
component output="false" accessors="true" extends="HibachiService" {
	
	public any function init() {
		if(!encryptionKeyExists()){
			createEncryptionKey();
		}
		return super.init();
	}
	
	public string function encryptValue(required string value) {
		return encrypt(arguments.value, getEncryptionKey(), setting("globalEncryptionAlgorithm"), setting("globalEncryptionEncoding"));
	}

	public string function decryptValue(required string value) {
		try {
			return decrypt(arguments.value, getEncryptionKey(), setting("globalEncryptionAlgorithm"), setting("globalEncryptionEncoding"));	
		} catch (any e) {
			logHibachi("There was an error decrypting a value from the database.  This is usually because Slatwall cannot find the Encryption key used to encrypt the data.  Verify that you have a key file in the location specified in the advanced settings of the admin.", true);
			return "";
		}
	}
	
	public string function createEncryptionKey() {
		var	theKey = generateSecretKey(setting("globalEncryptionAlgorithm"), setting("globalEncryptionKeySize"));
		storeEncryptionKey(theKey);
		return theKey;
	}
	
	public string function getEncryptionKey() {
		var encryptionFileData = fileRead(getEncryptionKeyFilePath());
		var encryptionInfoXML = xmlParse(encryptionFileData);
		return encryptionInfoXML.crypt.key.xmlText;
	}
	
	private string function getEncryptionKeyFilePath() {
		return getEncryptionKeyLocation() & getEncryptionKeyFileName();
	}
	
	private string function getEncryptionKeyLocation() {
		return setting("globalEncryptionKeyLocation") NEQ "" ? setting("globalEncryptionKeyLocation") : expandPath('/Slatwall/config/custom/');
	}
	
	private string function getEncryptionKeyFileName() {
		return "key.xml.cfm";
	}
	
	private boolean function encryptionKeyExists() {
		return fileExists(getEncryptionKeyFilePath());
	}
	
	private void function storeEncryptionKey(required string key) {
		var theKey = "<crypt><key>#arguments.key#</key></crypt>";
		fileWrite(getEncryptionKeyFilePath(),theKey);
	}
	
	// ===================== START: Logical Methods ===========================
	
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
