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

	Resize Methods
	scaleBest
	scale
	scaleAndCrop
	crop
*/
component persistent="false" extends="HibachiService" output="false" accessors="true" {

	property name="hibachiTagService" type="any";
	property name="settingService" type="any";
	property name="skuService" type="any";

	// @hint Returns an image HTML element with the additional attributes
	public string function getResizedImage() {

		// Setup the core src
		var returnHTML = '<img src="#getResizedImagePath(argumentcollection=arguments)#"';

		// Loop over all arguments and add as attributes if they aren't the resizing keys
		for(var key in arguments) {
			if(!listFindNoCase("imagePath,size,resizeMethod,cropLocation,cropXStart,cropYStart,scaleWidth,scaleHeight,missingImagePath", key) && isSimpleValue(arguments[key]) && (!structKeyExists(arguments, "resizeMethod") || !listFindNoCase("scaleBest", arguments.resizeMethod) || !listFindNoCase("width,height", key)) ) {
				returnHTML = listAppend(returnHTML, '#key#="#arguments[key]#"', ' ');
			}
		}

		// Close image tag
		returnHTML &= ' />';

		return returnHTML;
	}

	/**
     * This will return the path to an image based on the skuIDs (sent as a comma seperated list)
     * and a 'profile name' that determines the size of that image.
     * getResizedImageByProfileName
     * profileName="xlarge"
     * skuIDList = "8a8080834721af1a0147220714810083,4028818d4b31a783014b5653ad5d00d2,4028818d4b05b871014b102acb0700d5"
     * ...should return three paths.
     */
    public any function getResizedImageByProfileName(required any skuIDList="", any profileName="") {

        if(arguments.profileName == "medium"){
            var imageHeight = getSettingService().getSettingValue("productImageMediumHeight");
            var imageWidth  = getSettingService().getSettingValue("productImageMediumWidth");
        } else if (arguments.profileName == "large"){
            var imageHeight = getSettingService().getSettingValue("productImageLargeHeight");
            var imageWidth  = getSettingService().getSettingValue("productImageLargeWidth");
        } else{ //default case small
            var imageHeight = getSettingService().getSettingValue("productImageSmallHeight");
            var imageWidth  = getSettingService().getSettingValue("productImageSmallWidth");
        }


        var resizedImagePaths = [];
        var skus = [];

        //smart list to load up sku array
        var skuSmartList = getSkuService().getSkuSmartList();
        skuSmartList.addInFilter('skuID', arguments.skuIDList);

        if( skuSmartList.getRecordsCount() > 0){
            var skus = skuSmartList.getRecords();

            for  (var sku in skus){
                ArrayAppend(resizedImagePaths, sku.getResizedImagePath(width=imageWidth, height=imageHeight));
            }
        }
        return resizedImagePaths;
    }
    
    public string function getProductImagePathByImageFile(required string imageFile) {
   	 	return "#getHibachiScope().getBaseImageURL()#/product/default/#arguments.imageFile#";
    }
    
    public string function getImagePathByImageFileAndDirectory(required string imageFile, required string directory){
		return "#getHibachiScope().getBaseImageURL()#/#arguments.directory#/#arguments.imageFile#";
	}

	// Image File Methods
	public string function getResizedImagePath(required string imagePath, numeric width, numeric height, string resizeMethod="scale", string cropLocation="center", numeric cropX, numeric cropY, numeric scaleWidth, numeric scaleHeight, string missingImagePath, string canvasColor="") {
		var resizedImagePath = "";
		// If the image can't be found default to a missing image
		if(!fileExists(expandPath(arguments.imagePath))) {
			
			//look if the path was supplied
			if(structKeyExists(arguments, "missingImagePath") && fileExists(expandPath(arguments.missingImagePath))) {
			
				arguments.imagePath = "#getApplicationValue('baseURL')##arguments.missingImagePath#";
				
		    //look if this has been supplied at the site level.
			} else if (!isNull(getService('siteService').getCurrentRequestSite()) && !isNull(getService('siteService').getCurrentRequestSite().setting('siteMissingImagePath'))) {
                
                arguments.imagePath = getService('siteService').getCurrentRequestSite().setting('siteMissingImagePath');
			
			//check the custom location
			} else if(fileExists(expandPath("#getApplicationValue('baseURL')#/custom/assets/images/missingimage.jpg"))) {
               
                arguments.imagePath = "#getApplicationValue('baseURL')#/custom/assets/images/missingimage.jpg";
                
            //Check settings location
			}else if( fileExists(expandPath(getHibachiScope().setting('imageMissingImagePath'))) ){
               
				arguments.imagePath = "#getApplicationValue('baseURL')##getHibachiScope().setting('imageMissingImagePath')#";			
            
            //check the default location
            } else {
			  
				arguments.imagePath = "#getApplicationValue('baseURL')#/assets/images/missingimage.jpg";
			
			}
			
		}

		// if no width and height is passed in, display the original image
		if(!structKeyExists(arguments, "width") && !structKeyExists(arguments, "height")) {

			resizedImagePath = arguments.imagePath;

		// if there was a width or a height passed in then we can resize
		} else {

			// if dimensions are passed in, check to see if the image has already been created. If so, display it, if not create it first and then display it
			//var imageNameSuffix = (arguments.width && arguments.height) ? "_#arguments.width#w_#arguments.height#h" : (arguments.width ? "_#arguments.width#w" : "_#arguments.height#h");

			var imageNameSuffix = "";

			// Attach Width
			if(structKeyExists(arguments, "width")) {
				imageNameSuffix &= "_#arguments.width#w";
			}

			// Attach Height
			if(structKeyExists(arguments, "height")) {
				imageNameSuffix &= "_#arguments.height#h";
			}

			// Setup the crop or scaleAndCrop indicator
			if(listFindNoCase("scaleBest", arguments.resizeMethod)){
				imageNameSuffix &= "_sb";
			} else if(listFindNoCase("crop,scaleAndCrop", arguments.resizeMethod)) {

				// If this is scale and crop, then we need to look for scaleWidth & scaleHeight, as well as define the resizeMode
				if(lcase(arguments.resizeMethod) eq "scaleandcrop") {
					imageNameSuffix &= "_sc";

					// check for scaleWidth
					if(structKeyExists(arguments, "scaleWidth")) {
						imageNameSuffix &= "_#arguments.scaleWidth#sw";
					}
					// check for scaleHeight
					if(structKeyExists(arguments, "scaleHeight")) {
						imageNameSuffix &= "_#arguments.scaleHeight#sh";
					}
				} else if ( lcase(arguments.resizeMethod) eq "crop" ) {
					imageNameSuffix &= "_c";
				}

				// check for cropX
				if(structKeyExists(arguments, "cropX")) {
					imageNameSuffix &= "_#arguments.cropX#cx";
				}
				// check for cropY
				if(structKeyExists(arguments, "cropY")) {
					imageNameSuffix &= "_#arguments.cropY#cy";
				}
				// If no X or Y, then use the cropLocation
				if(!structKeyExists(arguments, "cropX") && !structKeyExists(arguments, "cropY")) {
					imageNameSuffix &= "_#lcase(arguments.cropLocation)#cl";
				}

			}

			// Figure out the image extension
			var imageExt = listLast(arguments.imagePath,".");

			var cacheDirectory = replaceNoCase(replaceNoCase(expandPath(arguments.imagePath), '\', '/', 'all'), listLast(arguments.imagePath, "/"), "cache/");

			if(!directoryExists(cacheDirectory)) {
				directoryCreate(cacheDirectory);
			}

			var resizedImagePath = replaceNoCase(replaceNoCase(arguments.imagePath, listLast(arguments.imagePath, "/\"), "cache/#listLast(arguments.imagePath, "/\")#"),".#imageExt#","#imageNameSuffix#.#imageExt#");

			// Make sure that if a cached images exists that it is newer than the original
			if(fileExists(expandPath(resizedImagePath))) {

				var originalFileObject = createObject("java","java.io.File").init(expandPath(arguments.imagePath));
				var resizedFileObject = createObject("java","java.io.File").init(expandPath(resizedImagePath));

				if(originalFileObject.lastModified() > resizedFileObject.lastModified()) {
					fileDelete(expandPath(resizedImagePath));
				}
			}

			if(!fileExists(expandPath(resizedImagePath))) {

				// wrap image functions in a try-catch in case the image uploaded is "problematic" for CF to work with
				try{

					// Read the Image
					var img = imageRead(expandPath(arguments.imagePath));

					// If the method is scale
					if(listFindNoCase("scale", arguments.resizeMethod)) {
						if(structKeyExists(arguments, "width") && structKeyExists(arguments,"height")) {
							img = scaleImage(image=img, width=arguments.width, height=arguments.height, canvasColor=arguments.canvasColor);
						} else if (structKeyExists(arguments, "width")) {
							img = scaleImage(image=img, width=arguments.width, canvasColor=arguments.canvasColor);
						} else if (structKeyExists(arguments, "height")) {
							img = scaleImage(image=img, height=arguments.height, canvasColor=arguments.canvasColor);
						}

					// If the method is scaleBest, then check the proportions and scaleToFit
					} else if (listFindNoCase("scaleBest", arguments.resizeMethod)) {

						// If width and hight passed in, then figure out which is better to use
						if(structKeyExists(arguments, "width") && structKeyExists(arguments,"height")) {

							// Resize based on width
							if((arguments.height / img.height) > (arguments.width / img.width)) {
								imageScaleToFit(img, arguments.width, "");

							// Resize based on
							} else {
								imageScaleToFit(img, "", arguments.height);

							}

						} else if (structKeyExists(arguments, "width")) {
							imageScaleToFit(img, arguments.width, "");

						} else if (structKeyExists(arguments, "height")) {
							imageScaleToFit(img, "", arguments.height);

						}

					// If the method is scaleAndCrop, then do the scale first based on scaleHeight
					} else if (listFindNoCase("scaleAndCrop", arguments.resizeMethod)) {

						if(structKeyExists(arguments, "scaleWidth") && structKeyExists(arguments,"scaleHeight")) {
							img = scaleImage(image=img, width=arguments.scaleWidth, height=arguments.scaleHeight, canvasColor=arguments.canvasColor);
						} else if (structKeyExists(arguments, "scaleWidth")) {
							img = scaleImage(image=img, width=arguments.scaleWidth, canvasColor=arguments.canvasColor);
						} else if (structKeyExists(arguments, "scaleHeight")) {
							img = scaleImage(image=img, height=arguments.scaleHeight, canvasColor=arguments.canvasColor);
						}

					}


					// If the method is crop or scaleAndCrop, then we need to do the crop next
					if(listFindNoCase("crop,scaleAndCrop", arguments.resizeMethod)) {

						// Make sure a height and width are defined
						if(!structKeyExists(arguments, "width")) {
							arguments.width = img.width;
						}
						if(!structKeyExists(arguments, "height")) {
							arguments.height = img.height;
						}

						// Figure out the cropX & cropY
						if(!structKeyExists(arguments, "cropX") && !structKeyExists(arguments, "cropY")) {
							arguments.cropX = 0;
							arguments.cropY = 0;

							// Setup the cropY
							if(left(lcase(arguments.cropLocation), 6) eq "center") {
								arguments.cropY = (img.height - arguments.height)/2;
							} else if (left(lcase(arguments.cropLocation), 6) eq "bottom") {
								arguments.cropY = img.height - arguments.height;
							}

							// Setup the cropX
							if(right(lcase(arguments.cropLocation), 6) eq "center") {
								arguments.cropX = (img.width - arguments.width)/2;
							} else if (right(lcase(arguments.cropLocation), 5) eq "right") {
								arguments.cropX = img.width - arguments.width;
							}
						} else if (!structKeyExists(arguments, "cropX")) {
							arguments.cropX = 0;
						} else if (!structKeyExists(arguments, "cropY")) {
							arguments.cropY = 0;
						}

						// Crop the Image
						imageCrop(img, arguments.cropX, arguments.cropY, arguments.width, arguments.height);

					}


					// Write the image to the disk
					imageWrite(img,expandPath(resizedImagePath));
				} catch(any e) {
					// log the error
					logHibachiException(e);
				}
			}
		}
		return resizedImagePath;
	}

	private any function scaleImage(required any image, numeric height, numeric width, string canvasColor="") {

		// Scale Height And Widht - If Height and Width was defined then we need to add whitespace
		if(structKeyExists(arguments, "width") && structKeyExists(arguments, "height")) {

			// If the aspect ratio is the same
			if((arguments.height / arguments.image.height) == (arguments.width / arguments.image.width)) {

				imageResize(arguments.image, arguments.width, arguments.height);

			// If the aspect ratio is different
			} else {

				// Setup variables for where the resized image is going to sit on the new canvis
				var pasteX = 0;
				var pasteY = 0;

				// Resize based on width
				if((arguments.height / arguments.image.height) > (arguments.width / arguments.image.width)) {
					imageResize(arguments.image, arguments.width, "");
					pasteY = (arguments.height - arguments.image.height)/2;

				// Resize based on height
				} else if ((arguments.height / arguments.image.height) < (arguments.width / arguments.image.width)) {
					imageResize(image, "", arguments.height);
					pasteX = (arguments.width - image.width)/2;
				}

				// Create New Canvis
				if(listFindNoCase('png,gif',listLast(image.source, '.')) && !len(arguments.canvasColor)) {
					var imgBG = imageNew("", arguments.width, arguments.height, "argb");
				} else {
					if(!len(arguments.canvasColor)) {
						arguments.canvasColor = "FFFFFF";
					}
					var imgBG = imageNew("", arguments.width, arguments.height, "rgb", arguments.canvasColor);
				}

				// Place resized image in center of canvis
				imagePaste(imgBG, arguments.image, pasteX, pasteY);

				// Set Canvis as image
				arguments.image = imgBG;
			}

		// Just Scale Height
		} else if (structKeyExists(arguments, "height")) {
			imageScaleToFit(arguments.image, "", arguments.height);

		// Just Scale Width
		} else if (structKeyExists(arguments, "width")) {
			imageScaleToFit(arguments.image, arguments.width, "");
		}

		return arguments.image;
	}


	// =================== OLD FUNCTIONS =================================

	public void function clearImageCache(string directoryPath, string imageName){
		var cacheFolder = expandpath(arguments.directoryPath & "/cache/");

		var files = getUtilityTagService().cfdirectory(action="list",directory=cacheFolder);

		cachedFiles = new Query();
	    cachedFiles.setDBType('query');
	    cachedFiles.setAttributes(rs=files);
	    cachedFiles.addParam(name='filename', value='#listgetat(arguments.imageName,1,'.')#%', cfsqltype='cf_sql_varchar');
	    cachedFiles.setSQL('SELECT * FROM rs where NAME like :filename');
	    cachedFiles = cachedFiles.execute().getResult();

		for(i=1; i <= cachedFiles.recordcount; i++){
			if(fileExists(cachedFiles.directory[i] & '/' & cachedFiles.name)) {
				fileDelete(cachedFiles.directory[i] & '/' & cachedFiles.name);
			}
		}
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

