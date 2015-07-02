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
component displayname="Image" entityname="SlatwallImage" table="SwImage" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="imageService" {
			
	// Persistent Properties
	property name="imageID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="imageName" ormtype="string";
	property name="imageDescription" ormtype="string" length="4000" hb_formFieldType="wysiwyg";
	property name="imageFile" ormtype="string" hb_formFieldType="file" hb_fileUpload="true" hb_fileAcceptMIMEType="image/gif,image/jpeg,image/pjpeg,image/png,image/x-png" hb_fileAcceptExtension=".jpeg,.jpg,.png,.gif";
	property name="directory" ormtype="string";
	
	// Related Object Properties (many-to-many)
	property name="options" singularname="option" cfc="Option" fieldtype="many-to-many" linktable="SwImageOption" fkcolumn="imageID" inversejoincolumn="optionID"; 

	// Related entity properties (many-to-one)
	property name="imageType" cfc="Type" fieldtype="many-to-one" fkcolumn="imageTypeID" hb_optionsSmartListData="f:parentType.systemCode=imageType";
	
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	property name="promotion" cfc="Promotion" fieldtype="many-to-one" fkcolumn="promotionID";
	property name="option" cfc="Option" fieldtype="many-to-one" fkcolumn="optionID";
	
	// Related Object Properties (one-to-many)
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" fkcolumn="imageID" inverse="true" cascade="all-delete-orphan";

	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	public string function getImageFileUploadDirectory() {
		return setting('globalAssetsImageFolderPath') & "/" & getDirectory();
	}
	
	public string function getImageExtension() {
		return listLast(getImageFile(), ".");
	}
	
	public string function getImagePath() {
		return "#getHibachiScope().getBaseImageURL()#/#getDirectory()#/#getImageFile()#";
	}
	
	public string function getImage() {
    	return getResizedImage(argumentcollection=arguments);
    }
    
	public string function getResizedImage() {
		
		// Setup Image Path
		arguments.imagePath = getImagePath();
		
		// Alt Title Setting
		if(!structKeyExists(arguments, "alt") && len(setting('imageAltString'))) {
			arguments.alt = stringReplace(setting('imageAltString'));
		}
		
		// Missing Image Path Setting
		if(!structKeyExists(arguments, "missingImagePath")) {
			arguments.missingImagePath = setting('imageMissingImagePath');
		}
		
		// *** DEPRECATED SIZE LOGIC ***
		if(structKeyExists(arguments, "size") && !isNull(getProduct()) && !structKeyExists(arguments, "width") && !structKeyExists(arguments, "height")) {
			arguments.size = lcase(arguments.size);
			if(arguments.size eq "l") {
				arguments.size = "Large";
			} else if (arguments.size eq "m") {
				arguments.size = "Medium";
			} else {
				arguments.size = "Small";
			}
			arguments.width = getProduct().setting("productImage#arguments.size#Width");
			arguments.height = getProduct().setting("productImage#arguments.size#Height");
			structDelete(arguments, "size");
		}
		
		return getService("imageService").getResizedImage(argumentCollection=arguments);
	}
	
	public string function getResizedImagePath() {
		
		// Setup Image Path
		arguments.imagePath = getImagePath();
		
		// Missing Image Path Setting
		if(!structKeyExists(arguments, "missingImagePath")) {
			arguments.missingImagePath = setting('imageMissingImagePath');
		}
		
		// DEPRECATED SIZE LOGIC
		if(structKeyExists(arguments, "size") && !isNull(getProduct()) && !structKeyExists(arguments, "width") && !structKeyExists(arguments, "height")) {
			arguments.size = lcase(arguments.size);
			if(arguments.size eq "l") {
				arguments.size = "Large";
			} else if (arguments.size eq "m") {
				arguments.size = "Medium";
			} else {
				arguments.size = "Small";
			}
			arguments.width = getProduct().setting("productImage#arguments.size#Width");
			arguments.height = getProduct().setting("productImage#arguments.size#Height");
			structDelete(arguments, "size");
		}
		
		return getService("imageService").getResizedImagePath(argumentCollection=arguments);
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Product (many-to-one)
	public void function setProduct(required any product) {
		variables.product = arguments.product;
		if(isNew() or !arguments.product.hasProductImage( this )) {
			arrayAppend(arguments.product.getProductImages(), this);
		}
	}
	public void function removeProduct(any product) {
		if(!structKeyExists(arguments, "product")) {
			arguments.product = variables.product;
		}
		var index = arrayFind(arguments.product.getProductImages(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.product.getProductImages(), index);
		}
		structDelete(variables, "product");
	}
	
	// Promotion (many-to-one)
	public void function setPromotion(required any promotion) {
		variables.promotion = arguments.promotion;
		if(isNew() or !arguments.promotion.hasPromotionImage( this )) {
			arrayAppend(arguments.promotion.getPromotionImages(), this);
		}
	}
	public void function removePromotion(any promotion) {
		if(!structKeyExists(arguments, "promotion")) {
			arguments.promotion = variables.promotion;
		}
		var index = arrayFind(arguments.promotion.getPromotionImages(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.promotion.getPromotionImages(), index);
		}
		structDelete(variables, "promotion");
	}
	
	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setImage( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeImage( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "imageFile";
	}
	
	public any function getOptionsSmartlist() {
		var smartList = getService("optionService").getOptionSmartList();
		smartList.setSelectDistinctFlag(1);
		smartList.addFilter("optionGroup.imageGroupFlag",1);
		smartList.addFilter("skus.product.productID",this.getProduct().getProductID());
		smartList.addOrder("optionGroup|ASC,sortOrder|ASC");
		return smartList;
	}
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
