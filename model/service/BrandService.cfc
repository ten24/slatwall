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

	property name="imageService" type="any";
    property name="hibachiService" type="any";
	property name="hibachiDataService" type="any";
	property name="settingService" type="any";
	// ===================== START: Logical Methods ===========================
	
	public array function getBrandPublicProperties(){
	    var publicProperties = ['brandID','brandName','urlTitle', 'brandDescription', 'activeFlag', 'brandFeatured', 'brandWebsite', 'imageFile'];
	    var publicAttributes = this.getHibachiService().getPublicAttributesByEntityName('Brand');
	    publicProperties.append(publicAttributes, true);
		return publicProperties;
	}
	
	public string function getImageBasePath( boolean frontendURL = false ) {
		return (arguments.frontendURL ? getHibachiScope().getBaseImageURL() : getHibachiScope().setting('globalAssetsImageFolderPath') ) & "/brand/logo";
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	public any function processBrand_uploadBrandLogo(required any brand, required any processObject) {
		// Wrap in try/catch to add validation error based on fileAcceptMIMEType
		try {
			
			var uploadDirectory = this.getImageBasePath();
			
			var fileUpload = getHibachiUtilityService().uploadFile( 
				uploadDirectory = uploadDirectory,
				fileFormFieldName = 'uploadFile',
				allowedMimeType = arguments.processObject.getPropertyMetaData('uploadFile').hb_fileAcceptMIMEType
			);
			
			if( !fileUpload.success ) {
 				arguments.brand.addError('imageFile', fileUpload.message);
 			} else {
 				
 				//delete existing image from object
 				if( arguments.brand.getImageFile() != "") {
 					arguments.brand = this.processBrand_deleteBrandLogo( arguments.brand, {"imageFile": arguments.brand.getImageFile()});
 				}
 				
 				arguments.brand.setImageFile( fileUpload.filePath );
 			}
		} catch(any e) {
			processObject.addError('imageFile', getHibachiScope().rbKey('validate.fileUpload'));
		}

		return arguments.brand;
	}
	
	public any function processBrand_deleteBrandLogo(required any brand, required struct data) {
		if(structKeyExists(arguments.data, "imageFile")) {
			
			var imageBasePath = this.getImageBasePath();
			
			getHibachiUtilityService().deleteFileFromPath( 
			 	directoryPath = imageBasePath,
			 	fileName = arguments.data.imageFile
			 );
			 
			arguments.brand.setImageFile('');
			getImageService().clearImageCache(imageBasePath, arguments.data.imageFile);
		}

		return arguments.brand;
	}
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function saveBrand(required any brand, required struct data) {
		if( (isNull(arguments.brand.getURLTitle()) || !len(arguments.brand.getURLTitle())) && (!structKeyExists(arguments.data, "urlTitle") || !len(arguments.data.urlTitle)) ) {
			if(structKeyExists(arguments.data, "brandName") && len(arguments.data.brandName)) {
				data.urlTitle = getHibachiUtilityService().createUniqueURLTitle(titleString=arguments.data.brandName, tableName="SwBrand");	
			} else if (!isNull(arguments.brand.getBrandName()) && len(arguments.brand.getBrandName())) {
				data.urlTitle = getHibachiUtilityService().createUniqueURLTitle(titleString=arguments.brand.getBrandName(), tableName="SwBrand");
			}
		}
		
		return super.save(arguments.brand, arguments.data);
	}
	
		/** 
	 * Function append settings value and options to existing sku List
	 * @param - array of skus
	 * @return - updated array of skus
	 **/
	public array function appendSettingsAndOptions(required array brands) {
		if(arrayLen(arguments.brands)) {
			var directory = 'brand/logo';
			for(var brand in arguments.brands) {
	            
	            var currentBrand = this.getBrand(brand.brandID);
				var attributeSets = currentBrand.getAssignedAttributes()
				var attributeStruct = currentBrand.getAttributeValuesByAttributeCodeStruct()
			    var attributes = [];
				for(var attribute in attributeSets) {
					if(StructKeyExists(attributeStruct, attribute["attributeCode"])){
						var thisAttributeObject = attributeStruct[attribute["attributeCode"]];
						ArrayAppend( attributes, {
							"attributeValueID" : thisAttributeObject.getAttributeValueID(),
							"attributeID" : thisAttributeObject.getAttributeID(),
							"attributeValue" : thisAttributeObject.getAttributeValue(),
							"attributeCode" : attribute["attributeCode"]
					} )
					}
					
				}

	            brand['settings']= {
		            "brandHTMLTitleString": currentBrand.stringReplace( template = currentBrand.setting('brandHTMLTitleString'), formatValues = true ),
	            	"brandMetaDescriptionString":  currentBrand.stringReplace( template = currentBrand.setting('brandMetaDescriptionString'), formatValues = true ),
	            	"brandMetaKeywordsString": currentBrand.stringReplace( template = currentBrand.setting('brandMetaKeywordsString'), formatValues = true )
	            }
                brand['imagePath'] = getImageService().getImagePathByImageFileAndDirectory(brand['imageFile'], directory);
	         	

	            brand['attributes'] = attributes;
	        }
		}
		return arguments.brands;
	}
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}
