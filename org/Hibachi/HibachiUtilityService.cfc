<cfcomponent output="false" accessors="true" extends="HibachiService">

	<cfproperty name="hibachiTagService" type="any" />

	<cfscript>

		//antisamy setup
		variables.antisamyConfig = {
			policyFile = ExpandPath("org/Hibachi/antisamy/antisamy-slashdot-1.4.1.xml"),
			jarArray = [
				ExpandPath("/Slatwall/org/Hibachi/antisamy/lib/antisamy-bin.1.4.1.jar"),
				ExpandPath("/Slatwall/org/Hibachi/antisamy/lib/antisamy-required-libs/batik-css.jar"),
				ExpandPath("/Slatwall/org/Hibachi/antisamy/lib/antisamy-required-libs/batik-util.jar"),
				ExpandPath("/Slatwall/org/Hibachi/antisamy/lib/antisamy-required-libs/nekohtml.jar"),
				ExpandPath("/Slatwall/org/Hibachi/antisamy/lib/antisamy-required-libs/xercesImpl.jar")
			]
		};
		variables.antisamyConfig.classLoader = CreateObject("component", "Slatwall.org.Hibachi.antisamy.lib.javaloader.JavaLoader").init(variables.antisamyConfig.jarArray);
		variables.antiSamy = variables.antisamyConfig.classLoader.create("org.owasp.validator.html.AntiSamy").init();
		
		public any function precisionCalculate(required numeric value, numeric scale=2){
			var roundingmode = createObject('java','java.math.RoundingMode');
			return javacast('bigdecimal',arguments.value).setScale(arguments.scale,roundingmode.HALF_EVEN);
		}
		
		/**
		* Sorts an array of structures based on a key in the structures.
		*
		* @param aofS      Array of structures.
		* @param key      Key to sort by.
		* @param sortOrder      Order to sort by, asc or desc.
		* @param sortType      Text, textnocase, or numeric.
		* @param delim      Delimiter used for temporary data storage. Must not exist in data. Defaults to a period.
		* @return Returns a sorted array.
		* @author Nathan Dintenfass (nathan@changemedia.com)
		* @version 1, December 10, 2001
		*/
		public array function arrayOfStructsSort(aOfS,key,sortOrder2="des"){


		        //by default, we'll use a textnocase sort
		        var sortType = "textnocase";
		        //by default, use ascii character 30 as the delim
		        var delim = ".";
		        //make an array to hold the sort stuff
		        var sortArray = arraynew(1);

		        //make an array to return
		        var returnArray = arraynew(1);

		        //grab the number of elements in the array (used in the loops)
		        var count = arrayLen(aOfS);
		        //make a variable to use in the loop
		        var ii = 1; var j=1;
		        //if there is a 3rd argument, set the sortOrder
		        if(arraylen(arguments) GT 2)
		            sortOrder = arguments[3];
		        //if there is a 4th argument, set the sortType
		        if(arraylen(arguments) GT 3)
		            sortType = arguments[4];
		        //if there is a 5th argument, set the delim
		        if(arraylen(arguments) GT 4)
		            delim = arguments[5];
		        //loop over the array of structs, building the sortArray
		        for(ii = 1; ii lte count; ii = ii + 1)
		            sortArray[ii] = aOfS[ii][key] & delim & ii;
		        //now sort the array
		        arraySort(sortArray,sortType,arguments.sortOrder2);
		        //now build the return array
		        for(ii = 1; ii lte count; ii = ii + 1)
		            returnArray[ii] = aOfS[listLast(sortArray[ii],delim)];
		        //return the array
		        return returnArray;
		}

		// @hint this method will sanitize a struct of data
		public void function sanitizeData(required any data){
			for(var key in data){
			  if( isSimpleValue(data[key]) && key != 'serializedJsonData'){
			    data[key] = variables.antisamy.scan(data[key],variables.antiSamyConfig.policyFile).getCleanHTML();
			  }
			}
		}

		// @hint this method allows you to properly format a value against a formatType
		public any function formatValue( required string value, required string formatType, struct formatDetails={} ) {

			if(listFindNoCase("decimal,currency,date,datetime,pixels,percentage,second,time,truefalse,url,weight,yesno,urltitle,alphanumericdash", arguments.formatType)) {
				return this.invokeMethod("formatValue_#arguments.formatType#", {value=arguments.value, formatDetails=arguments.formatDetails});
			}
			return arguments.value;
		}

		public any function formatValue_decimal(required string value){
			if(isNumeric(arguments.value)){
				return numberFormat(arguments.value,'_.__');	
			}else{
				//used in cases such as string "N/A"
				return arguments.value;				
			}
		}

		public any function formatValue_second( required string value, struct formatDetails={} ) {
			return arguments.value & ' ' & rbKey('define.sec');
		}

		public any function formatValue_yesno( required string value, struct formatDetails={} ) {
			if(isBoolean(arguments.value) && arguments.value) {
				return rbKey('define.yes');
			} else {
				return rbKey('define.no');
			}
		}

		public any function formatValue_truefalse( required string value, struct formatDetails={} ) {
			if(isBoolean(arguments.value) && arguments.value) {
				return rbKey('define.true');
			} else {
				return rbKey('define.false');
			}
		}

		public any function formatValue_currency( required string value, struct formatDetails={} ) {
			if(structKeyExists(arguments.formatDetails, "currencyCode") && len(arguments.formatDetails.currencyCode) == 3 ) {
				return LSCurrencyFormat(arguments.value, arguments.formatDetails.currencyCode, getHibachiScope().getRBLocale());
			}
			// If no currency code was passed in then we can default to USD
			return LSCurrencyFormat(arguments.value, "USD", getHibachiScope().getRBLocale());
		}

		public any function formatValue_datetime( required string value, struct formatDetails={} ) {
			return dateFormat(arguments.value, "MM/DD/YYYY") & " " & timeFormat(value, "HH:MM");
		}

		public any function formatValue_date( required string value, struct formatDetails={} ) {
			return dateFormat(arguments.value, "MM/DD/YYYY");
		}

		public any function formatValue_time( required string value, struct formatDetails={} ) {
			return timeFormat(value, "HH:MM");
		}

		public any function formatValue_weight( required string value, struct formatDetails={} ) {
			return arguments.value & " " & "lbs";
		}

		public any function formatValue_pixels( required string value, struct formatDetails={} ) {
			return arguments.value & "px";
		}

		public any function formatValue_percentage( required string value, struct formatDetails={} ) {
			return arguments.value & "%";
		}

		public any function formatValue_url( required string value, struct formatDetails={} ) {
			return '<a href="#arguments.value#" target="_blank">' & arguments.value & '</a>';
		}

		public any function formatValue_urltitle( required string value, struct formatDetails={} ) {
			return createUniqueURLTitle(arguments.value, arguments.formatDetails.tableName);
		}

		public any function formatValue_alphanumericdash( required string value, struct formatDetails={} ) {
			return createSEOString(arguments.data.value);
		}

		public string function createUniqueURLTitle(required string titleString, string tableName="", string entityName="") {
			if(len(arguments.tableName)){
				return createUniqueColumn(arguments.titleString,arguments.tableName,'urlTitle');	
			}else if(len(arguments.entityName)){
				return createUniqueProperty(arguments);				
			}
		}

		public string function createUniqueColumn(required string titleString, required string tableName, required string columnName) {

			var addon = 1;

			var urlTitle = createSEOString(arguments.titleString);

			var returnTitle = urlTitle;

			var unique = getHibachiDAO().verifyUniqueTableValue(tableName=arguments.tableName, column=arguments.columnName, value=returnTitle);

			while(!unique) {
				addon++;
				returnTitle = "#urlTitle#-#addon#";
				unique = getHibachiDAO().verifyUniqueTableValue(tableName=arguments.tableName, column=arguments.columnName, value=returnTitle);
			}

			return returnTitle;
		}
		
		public string function createUniqueProperty(required string titleString, required string entityName, required string propertyName){
			var addon = 1;

			var urlTitle = createSEOString(arguments.titleString);

			var returnTitle = urlTitle;

			var unique = getHibachiDAO().verifyUniquePropertyValue(entityName=arguments.entityName, propertyName=arguments.propertyName, value=returnTitle);

			while(!unique) {
				addon++;
				returnTitle = "#urlTitle#-#addon#";
				unique = getHibachiDAO().verifyUniquePropertyValue(entityName=arguments.entityName, propertyName=arguments.propertyName, value=returnTitle);
			}

			return returnTitle;
		}

  		public string function generateRandomID( numeric numCharacters = 8){

  			var chars="abcdefghijklmnopqrstuvwxyz1234567890";
  			var random = createObject("java", "java.util.Random" ).init();
  			var result = createObject("java", "java.lang.StringBuffer").init (javaCast("int",arguments.numCharacters));
  			var index = 0;

  			for(var i=0; i<numCharacters; i++){
  				result.append(chars.charAt(random.nextInt(chars.length())));
  			}

			return result.toString().toUppercase();
  		}

  		public any function hibachiTernary(required any condition, required any expression1, required any expression2){
  			return (arguments.condition) ? arguments.expression1 : arguments.expression2;
  		}

		public any function buildPropertyIdentifierListDataStruct(required any object, required string propertyIdentifierList, required string availablePropertyIdentifierList) {
			var responseData = {};

			for(var propertyIdentifier in listToArray(arguments.propertyIdentifierList)) {
				if( listFindNoCase(arguments.availablePropertyIdentifierList, trim(propertyIdentifier)) ) {
					buildPropertyIdentifierDataStruct(arguments.object, trim(propertyIdentifier), responseData);
				}
			}

			return responseData;
		}

		public any function buildPropertyIdentifierDataStruct(required parentObject, required string propertyIdentifier, required any data) {
			if(listLen(arguments.propertyIdentifier, ".") eq 1) {
				data[ arguments.propertyIdentifier ] = parentObject.getValueByPropertyIdentifier( arguments.propertyIdentifier );
				return;
			}
			var object = parentObject.invokeMethod("get#listFirst(arguments.propertyIdentifier, '.')#");
			if(!isNull(object) && isObject(object)) {
				var thisProperty = listFirst(arguments.propertyIdentifier, '.');
				param name="data[thisProperty]" default="#structNew()#";

				if(!structKeyExists(data[thisProperty],"errors")) {
					// add error messages
					data[thisProperty]["hasErrors"] = object.hasErrors();
					data[thisProperty]["errors"] = object.getErrors();
				}

				buildPropertyIdentifierDataStruct(object,listDeleteAt(arguments.propertyIdentifier, 1, "."), data[thisProperty]);
			} else if(!isNull(object) && isArray(object)) {
				var thisProperty = listFirst(arguments.propertyIdentifier, '.');
				param name="data[thisProperty]" default="#arrayNew(1)#";

				for(var i = 1; i <= arrayLen(object); i++){
					param name="data[thisProperty][i]" default="#structNew()#";

					if(!structKeyExists(data[thisProperty][i],"errors")) {
						// add error messages
						data[thisProperty][i]["hasErrors"] = object[i].hasErrors();
						data[thisProperty][i]["errors"] = object[i].getErrors();
					}

					buildPropertyIdentifierDataStruct(object[i],listDeleteAt(arguments.propertyIdentifier, 1, "."), data[thisProperty][i]);
				}
			}
		}

		public any function lcaseStructKeys( required any data ) {
			if( isStruct(arguments.data) ) {
				var newData = {};
				for(var key in arguments.data) {
					if(!structKeyExists(arguments.data, key )) {
						newData[ lcase(key) ] = javaCast('null', '');
					} else {
						newData[ lcase(key) ] = lcaseStructKeys(arguments.data[ key ]);
					}
				}
				return newData;
			} else if (isArray(arguments.data)) {
				for(var i=1; i<=arrayLen(arguments.data); i++) {
					arguments.data[i] = lcaseStructKeys(arguments.data[i]);
				}
			}

			return arguments.data;
		}
		//evaluate double brackets ${{}} and ${()}
		public string function replaceStringEvaluateTemplate(required string template, any object){
			if(isNull(arguments.object)){
				arguments.object = getHibachiScope();
			}
			var templateKeys = reMatchNoCase("\${{[^}]+}}",arguments.template);

			var parenthesisTemplateKeys =  reMatchNoCase("\${\([^}]+\)}",arguments.template);
			var replacementArray = [];
			var returnString = arguments.template;

			for(var i=1; i<=arrayLen(templateKeys); i++) {
				var replaceDetails = {};
				replaceDetails.key = templateKeys[i];
				replaceDetails.value = templateKeys[i];

				var valueKey = replace(replace(templateKeys[i], "${{", ""),"}}","");
				//check to see if a function exists on the object
			    if(structKeyExists(arguments.object, ListFirst(valueKey,"("))){
					replaceDetails.value = evaluate("arguments.object.#valueKey#");
			    } else {
                    replaceDetails.value = evaluate(valueKey);
                }
				arrayAppend(replacementArray, replaceDetails);
			}

			for(var i=1; i<=arrayLen(parenthesisTemplateKeys); i++) {
				var replaceDetails = {};
				replaceDetails.key = parenthesisTemplateKeys[i];
				replaceDetails.value = parenthesisTemplateKeys[i];

				var valueKey = replace(replace(parenthesisTemplateKeys[i], "${(", ""),")}","");

				replaceDetails.value = evaluate(valueKey);

				arrayAppend(replacementArray, replaceDetails);
			}


			for(var i=1; i<=arrayLen(replacementArray); i++) {
				returnString = replace(returnString, replacementArray[i].key, replacementArray[i].value, "all");
			}

			if(arraylen(reMatchNoCase("\${{[^}]+}}",returnString))){
				returnString = replaceStringEvaluateTemplate(returnString);
			}

			return returnString;
		}

		public array function getTemplateKeys(required string template){
			//matches only ${} not ${{}}
			return reMatchNoCase("\${[^{(}]+}",arguments.template);
		}

		//replace single brackets ${}
		public string function replaceStringTemplate(required string template, required any object, boolean formatValues=false, boolean removeMissingKeys=false) {

			var templateKeys = getTemplateKeys(arguments.template);
			var replacementArray = [];
			var returnString = arguments.template;
			for(var i=1; i<=arrayLen(templateKeys); i++) {
				var replaceDetails = {};
				replaceDetails.key = templateKeys[i];
				replaceDetails.value = templateKeys[i];

				var valueKey = replace(replace(templateKeys[i], "${", ""),"}","");
				if( isStruct(arguments.object) && structKeyExists(arguments.object, valueKey) ) {
					replaceDetails.value = arguments.object[ valueKey ];
				} else if (isObject(arguments.object) && (
					(
						arguments.object.isPersistent() && getHasPropertyByEntityNameAndPropertyIdentifier(arguments.object.getEntityName(), valueKey))
						||
						(
							arguments.object.isPersistent() 
							&& structKeyExists(getService('hibachiService'),'getHasAttributeByEntityNameAndPropertyIdentifier')
							&& getService('hibachiService').getHasAttributeByEntityNameAndPropertyIdentifier(arguments.object.getEntityName(), valueKey))
							||
						(
							!arguments.object.isPersistent() && arguments.object.hasProperty(valueKey)
						)	
					)
				) {
					replaceDetails.value = arguments.object.getValueByPropertyIdentifier(valueKey, arguments.formatValues);
				} else if (arguments.removeMissingKeys) {
					replaceDetails.value = '';
				}

				arrayAppend(replacementArray, replaceDetails);
			}
			for(var i=1; i<=arrayLen(replacementArray); i++) {
				returnString = replace(returnString, replacementArray[i].key, replacementArray[i].value, "all");
			}
			if(
				arguments.template != returnString
				&& arraylen(getTemplateKeys(returnString))
			){
				returnString = replaceStringTemplate(returnString, arguments.object, arguments.formatValues,arguments.removeMissingKeys);
			}

			return returnString;
		}

		/**
			* Concatenates two arrays.
			*
			* @param a1      The first array.
			* @param a2      The second array.
			* @return Returns an array.
			* @author Craig Fisher (craig@altainetractive.com)
			* @version 1, September 13, 2001
			* Modified by Tony Garcia 18Oct09 to deal with metadata arrays, which don't act like normal arrays
			*/
		public array function arrayConcat(required array a1, required array a2) {
			var newArr = [];
		    var i=1;
		    if ((!isArray(a1)) || (!isArray(a2))) {
		        writeoutput("Error in <Code>ArrayConcat()</code>! Correct usage: ArrayConcat(<I>Array1</I>, <I>Array2</I>) -- Concatenates Array2 to the end of Array1");
		        return arrayNew(1);
		    }
		    /*we have to copy the array elements to a new array because the properties array in ColdFusion
		      is a "read only" array (see http://www.bennadel.com/blog/760-Converting-A-Java-Array-To-A-ColdFusion-Array.htm)*/
		    for (i=1;i <= ArrayLen(a1);i++) {
		        newArr[i] = a1[i];
		    }
		    for (i=1;i <= ArrayLen(a2);i++) {
		        newArr[arrayLen(a1)+i] = a2[i];
		    }
		    return newArr;
		}

		public string function filterFilename(required string filename) {
			// Lower Case The Filename
			arguments.filename = lcase(trim(arguments.filename));

			// Remove anything that isn't alphanumeric
			arguments.filename = reReplace(arguments.filename, "[^a-z|0-9| ]", "", "all");

			// Remove any spaces that are multiples to a single spaces
			arguments.filename = reReplace(arguments.filename, "[ ]{1,} ", " ", "all");

			// Replace any spaces with a dash
			arguments.filename = replace(arguments.filename, " ", "-", "all");

			return arguments.filename;
		}

		public string function createSEOString(required string toFormat, string delimiter="-"){

			//take out all special characters except -
			arguments.toFormat = reReplace(lcase(trim(arguments.toFormat)), "[^a-z0-9 \-]", "", "all");

			//replate spaces with -
			return reReplace(arguments.toFormat, "[-\s]+", delimiter, "all");
		}

		public void function duplicateDirectory(required string source, required string destination, boolean overwrite=false, boolean recurse=true, string copyContentExclusionList='', boolean deleteDestinationContent=false, string deleteDestinationContentExclusionList="" ){
			arguments.source = replace(arguments.source,"\","/","all");
			arguments.destination = replace(arguments.destination,"\","/","all");

			// set baseSourceDir so it's persisted through recursion
			if(isNull(arguments.baseSourceDir)){
				arguments.baseSourceDir = arguments.source;
			}

			// set baseDestinationDir so it's persisted through recursion, baseDestinationDir is passed in recursion so, this will run only once
			if(isNull(arguments.baseDestinationDir)){
				arguments.baseDestinationDir = arguments.destination;
				// Loop through destination and delete the files and folder if needed
				if(arguments.deleteDestinationContent){
					var destinationDirList = directoryList(arguments.destination,false,"query");
					for(var i = 1; i <= destinationDirList.recordCount; i++){
						if(destinationDirList.type[i] == "Dir"){
							// get the current directory without the base path
							var currentDir = replacenocase(replacenocase(destinationDirList.directory[i],'\','/','all'),arguments.baseDestinationDir,'') & "/" & destinationDirList.name[i];
							// if the directory exists and not part of exclusion the delete
							if(directoryExists("#arguments.destination##currentDir#") && findNoCase(currentDir,arguments.deleteDestinationContentExclusionList) EQ 0){
								try {
									directoryDelete("#arguments.destination##currentDir#",true);
								} catch(any e) {
									logHibachi("Could not delete the directory: #arguments.destination##currentDir# most likely because it is in use by the file system", true);
								}
							}
						} else if(destinationDirList.type[i] == "File") {
							// get the current file path without the base path
							var currentFile = replacenocase(replacenocase(destinationDirList.directory[i],'\','/','all'),arguments.baseDestinationDir,'') & "/" & destinationDirList.name[i];
							// if the file exists and not part of exclusion the delete
							if(fileExists("#arguments.destination##currentFile#") && findNoCase(currentFile,arguments.deleteDestinationContentExclusionList) EQ 0){
								try {
									fileDelete("#arguments.destination##currentFile#");
								} catch(any e) {
									logHibachi("Could not delete file: #arguments.destination##currentFile# most likely because it is in use by the file system", true);
								}
							}
						}
					}
				}
			}

			var dirList = directoryList(arguments.source,false,"query");
			for(var i = 1; i <= dirList.recordCount; i++){
				if(dirList.type[i] == "File" && !listFindNoCase(arguments.copyContentExclusionList,dirList.name[i])){
					var copyFrom = "#replace(dirList.directory[i],'\','/','all')#/#dirList.name[i]#";
					var copyTo = "#arguments.destination##replacenocase(replacenocase(dirList.directory[i],'\','/','all'),arguments.baseSourceDir,'')#/#dirList.name[i]#";
					copyFile(copyFrom,copyTo,arguments.overwrite);
				} else if(dirList.type[i] == "Dir" && arguments.recurse && !listFindNoCase(arguments.copyContentExclusionList,dirList.name[i])){
					duplicateDirectory(source="#dirList.directory[i]#/#dirList.name[i]#", destination=arguments.destination, overwrite=arguments.overwrite, recurse=arguments.recurse, copyContentExclusionList=arguments.copyContentExclusionList, deleteDestinationContent=arguments.deleteDestinationContent, deleteDestinationContentExclusionList=arguments.deleteDestinationContentExclusionList, baseSourceDir=arguments.baseSourceDir, baseDestinationDir=arguments.baseDestinationDir);
				}
			}

			// set the file permission in linux
			if(!findNoCase(server.os.name,"Windows")){
				fileSetAccessMode(arguments.destination, "775");
			}
		}

		public void function copyFile(required string source, required string destination, boolean overwrite=false){
			var destinationDir = getdirectoryFromPath(arguments.destination);
			//create directory
			if(!directoryExists(destinationDir)){
				directoryCreate(destinationDir);
			}
			//copy file if it doens't exist in destination
			if(arguments.overwrite || !fileExists(arguments.destination)) {
				fileCopy(arguments.source,arguments.destination);
			}
		}

		// helper method for downloading a file
		public void function downloadFile(required string fileName, required string filePath, string contentType = 'application/unknown', boolean deleteFile = false) {
			getHibachiTagService().cfheader(name="Content-Disposition", value="attachment; filename=#arguments.fileName#");
			getHibachiTagService().cfcontent(type="#arguments.contentType#", file="#arguments.filePath#", deletefile="#arguments.deleteFile#");
		}

		public string function encryptValue(required string value, string salt="") {
			var passwords = getEncryptionPasswordArray();
			return encrypt(arguments.value, generatePasswordBasedEncryptionKey(password=passwords[1].password, salt=arguments.salt, iterationCount=passwords[1].iterationCount), getEncryptionAlgorithm(), getEncryptionEncoding());
		}

		public string function hibachiHTMLEditFormat(required string html){
			var sanitizedString = htmlEditFormat(arguments.html);
			sanitizedString = sanitizeForAngular(sanitizedString);
			return sanitizedString;
		}

		public string function sanitizeForAngular(required string html){
			return ReReplace(arguments.html,'{',chr(123)&chr(002),'all');
		}

		public string function decryptValue(required string value, string salt="") {
			for (var passwordData in getEncryptionPasswordArray()) {
				var key = "";
				var algorithm = getEncryptionAlgorithm();
				var encoding = getEncryptionEncoding();
				// Using key with password based derivation method
				if (structKeyExists(passwordData, 'password')) {
					key = generatePasswordBasedEncryptionKey(password=passwordData.password, salt=arguments.salt, iterationCount=passwordData.iterationCount);
				// Using legacy key (absolute)
				} else if (structKeyExists(passwordData, 'legacyKey')) {
					key = passwordData.legacyKey;

					// Override decrypt arguments to work with legacy encrypt/decrypt
					algorithm = passwordData.legacyEncryptionAlgorithm;
					encoding = passwordData.legacyEncryptionEncoding;
				}

				// Attempt to decrypt
				try {
					var decryptedResult = decrypt(arguments.value, key, algorithm, encoding);
					// Necessary due to a possible edge case when no error occurs during a
					// decryption attempt with an incorrect key
					if (!len(decryptedResult)) {
						continue;
					}

					return decryptedResult;

				// Graceful handling of decrypt failure
				} catch (any e) {}
			}

			logHibachi("There was an error decrypting a value from the database.  This is usually because the application cannot derive the Encryption key used to encrypt the data.  Verify that you have a password file in the location specified in the advanced settings of the admin.", true);
			return "";
		}

		public function generatePasswordBasedEncryptionKey(required string password, string salt="", numeric iterationCount=1000) {
			// Notes: Another possible implementation using Java 'PBKDF2WithHmacSHA1'
			// https://gist.github.com/scotttam/874426

			var hashResult = "";
			var key = "";
			var iterationIndex = 1;

			// Derive key using password, salt, and current iteration index
			// Use current iteration generated key output as salt input for the next iteration
			do {
				hashResult = hash("#arguments.password##arguments.salt##iterationIndex#", "MD5" );
				key = binaryEncode(binaryDecode(hashResult, "hex"), "base64");

				// Update salt for next iteration
				arguments.salt = key;
				iterationIndex++;
			} while (iterationIndex <= arguments.iterationCount);

			return key;
		}

		public any function createDefaultEncryptionPasswordData() {
			return {'iterationCount'= randRange(500, 2500), 'password'=createHibachiUUID(), 'createdDateTime'=dateFormat(now(),"yyyy-mm-dd") & " " & timeFormat(now(), "HH:MM:SS")};
		}

		public any function addEncryptionPasswordData(required struct data) {
			if (!isNumeric(arguments.data.iterationCount)) {
				arguments.data.iterationCount = randRange(500, 2500);
			}

			var passwordData = {'iterationCount'= arguments.data.iterationCount, 'password'=arguments.data.password, 'createdDateTime'=dateFormat(now(),"yyyy-mm-dd") & " " & timeFormat(now(), "HH:MM:SS")};

			var passwords = [passwordData];

			// NOTE: Do not want to call getEncryptionPasswordArray() if no password file existed prior, otherwise a unnecessary password will be also generated automatically in addition
			if (encryptionPasswordFileExists()) {
				passwords = getEncryptionPasswordArray();

				// Prepend new password data to existing passwords so it becomes the newest password used
				arrayInsertAt(passwords, 1, passwordData);
			}

			// Write new contents to the encryption password file
			writeEncryptionPasswordFile(passwords);
		}

		public any function getEncryptionPasswordArray() {
			var passwords = [];

			// Generate default password if necessary
			if (!encryptionPasswordFileExists()) {
				arrayAppend(passwords, createDefaultEncryptionPasswordData());
				writeEncryptionPasswordFile(passwords);
			}

			// Read password file
			passwords = readEncryptionPasswordFile().passwords;

			// Migrate legacy key to encryption password file
			if (encryptionKeyExists()) {
				var migrateLegacyKeyFlag = true;
				var legacyKey = getLegacyEncryptionKey();

				// Make sure key does not already exist in passwords
				// eg. file could have been restored by version control, etc.
				for (var passwordData in passwords) {
					if (structKeyExists(passwordData, "legacyKey") && passwordData.legacyKey == legacyKey) {
						migrateLegacyKeyFlag = false;
						break;
					}
				}

				// Update passwords file
				if (migrateLegacyKeyFlag) {
					arrayAppend(passwords, {'legacyKey'=legacyKey, 'legacyEncryptionAlgorithm'=getLegacyEncryptionAlgorithm(), 'legacyEncryptionEncoding'=getLegacyEncryptionEncoding(), 'legacyEncryptionKeySize'=getLegacyEncryptionKeySize()});
					writeEncryptionPasswordFile(passwords);
				}

				// Remove legacy key file from file system
				removeLegacyEncryptionKeyFile();
			}

			var legacyPasswords = [];
			var sortedPasswords = [];

			//  Sort passwords array from newest to oldest
			if (arraylen(passwords) > 1) {
				var unsortedPasswordsStruct = {};
				for (var p in passwords) {
					if (structKeyExists(p, 'createdDateTime')) {
						// Create temporary uniqueID used for identification purposes during sorting
						p['uniqueID'] = createHibachiUUID();
						structInsert(unsortedPasswordsStruct, p.uniqueID, p);
					} else {
						arrayAppend(legacyPasswords, p);
					}
				}

				// Perform sort on createdDateTime
				sortedPasswordKeys = structSort(unsortedPasswordsStruct, 'textnocase', 'desc', 'createdDateTime');

				// Build array of sorted passwords
				for (var spk in sortedPasswordKeys) {
					// Delete temporary uniqueID used for identification purposes during sorting
					structDelete(unsortedPasswordsStruct[spk], 'uniqueID');
					arrayAppend(sortedPasswords, unsortedPasswordsStruct[spk]);
				}

				// Append legacy keys to end
				for (var lp in legacyPasswords) {
					arrayAppend(sortedPasswords, lp);
				}

				passwords = sortedPasswords;
			}

			return passwords;
		}

		private string function getEncryptionKeyFilePath() {
			return getEncryptionKeyLocation() & getEncryptionKeyFileName();
		}

		private string function getEncryptionKeyLocation() {
			return expandPath('/#getApplicationValue('applicationKey')#/custom/config/');
		}

		private string function getEncryptionKeyFileName() {
			return "key.xml.cfm";
		}

		public boolean function encryptionKeyExists() {
			return fileExists(getEncryptionKeyFilePath());
		}

		private string function getEncryptionPasswordFilePath() {
			return getEncryptionKeyLocation() & getEncryptionPasswordFileName();
		}

		private string function getEncryptionPasswordFileName() {
			return "password.txt.cfm";
		}

		private boolean function encryptionPasswordFileExists() {
			return fileExists(getEncryptionPasswordFilePath());
		}

		public string function getEncryptionAlgorithm() {
			//return "AES";
			return "AES/CBC/PKCS5Padding";
		}

		public string function getEncryptionEncoding() {
			return "Base64";
		}

		public string function getLegacyEncryptionKey() {
			var encryptionFileData = fileRead(getEncryptionKeyFilePath());
			var encryptionInfoXML = xmlParse(encryptionFileData);
			return encryptionInfoXML.crypt.key.xmlText;
		}

		public string function getLegacyEncryptionAlgorithm() {
			return "AES";
		}

		public string function getLegacyEncryptionEncoding() {
			return "Base64";
		}

		public string function getLegacyEncryptionKeySize() {
			return "128";
		}

		public void function removeLegacyEncryptionKeyFile(string method) {
			if (fileExists(getEncryptionKeyFilePath())) {
				if (!isNull(arguments.method) && arguments.method == "rename") {
					// Filename without extension
					var filename = listDeleteAt(getEncryptionKeyFileName(),listLen(getEncryptionKeyFileName(), "."),".");
					fileMove(getEncryptionKeyFilePath(), '#getEncryptionKeyLocation()##filename#.#hash(getTickCount(), "SHA", "utf-8")#.cfm');
				} else {
					fileDelete(getEncryptionKeyFilePath());
				}
			}
		}

		public void function reencryptData(numeric batchSizeLimit=0) {
			getHibachiDAO().reencryptData(argumentCollection=arguments);
		}

		private void function writeEncryptionPasswordFile(array encryptionPasswordArray) {
			// WARNING DO NOT CHANGE THIS ENCRYPTION KEY FOR ANY REASON
			var hardCodedFileEncryptionKey = generatePasswordBasedEncryptionKey('0ae8fc11293444779bd4358177931793', 1024);

			var passwordsJSON = serializeJSON({'passwords'=arguments.encryptionPasswordArray});
			fileWrite(getEncryptionPasswordFilePath(), encrypt(passwordsJSON, hardCodedFileEncryptionKey, "AES/CBC/PKCS5Padding"));
		}

		private any function readEncryptionPasswordFile() {
			// WARNING DO NOT CHANGE THIS ENCRYPTION KEY FOR ANY REASON
			var hardCodedFileEncryptionKey = generatePasswordBasedEncryptionKey('0ae8fc11293444779bd4358177931793', 1024);

			return deserializeJSON(decrypt(fileRead(getEncryptionPasswordFilePath()), hardCodedFileEncryptionKey, "AES/CBC/PKCS5Padding"));
		}

		public any function updateCF9SerializeJSONOutput( required any data ) {
			var reMatchArray = reMatch(':0[0-9][0-9]*\.?[0-9]*,', arguments.data);
			for(var i=1; i<=arrayLen(reMatchArray); i++) {
				arguments.data = reReplace(arguments.data, ':0[0-9][0-9]*\.?[0-9]*,', ':"#right(reMatchArray[i], len(reMatchArray[i])-1)#",');
			}

			return arguments.data;
		}

		public any function getLineBreakByEnvironment(required string environmentName){
			var linebreak = "";

			if ( findNoCase('windows', arguments.environmentName) ){
				linebreak =  Chr(13) & Chr(10);
			}else if (findNoCase('mac', arguments.environmentName) ){
				linebreak = Chr(10);
			}else if (findNoCase('linux', arguments.environmentName)){
				linebreak = Chr(10);
			}else {
				linebreak = CreateObject("java", "java.lang.System").getProperty("line.separator");
			}

			return linebreak;
		}

	</cfscript>

	<cffunction name="logException" returntype="void" access="public">
		<cfargument name="exception" required="true" />

		<!--- All logic in this method is inside of a cftry so that it doesnt cause an exception --->
		<cftry>
			<cflog file="#getApplicationValue('applicationKey')#" text="START EXCEPTION" />
			<cfif structKeyExists(arguments.exception, "detail") and isSimpleValue(arguments.exception.detail)>
				<cflog file="#getApplicationValue('applicationKey')#" text="#arguments.exception.detail#" />
			</cfif>
			<cfif structKeyExists(arguments.exception, "errNumber") and isSimpleValue(arguments.exception.errNumber)>
				<cflog file="#getApplicationValue('applicationKey')#" text="#arguments.exception.errNumber#" />
			</cfif>
			<cfif structKeyExists(arguments.exception, "message") and isSimpleValue(arguments.exception.message)>
				<cflog file="#getApplicationValue('applicationKey')#" text="#arguments.exception.message#" />
			</cfif>
			<cfif structKeyExists(arguments.exception, "stackTrace") and isSimpleValue(arguments.exception.stackTrace)>
				<cflog file="#getApplicationValue('applicationKey')#" text="#arguments.exception.stackTrace#" />
			</cfif>
			<cflog file="#getApplicationValue('applicationKey')#" text="END EXCEPTION" />
			<cfcatch>
				<cflog file="#getApplicationValue('applicationKey')#" text="Log Exception Error" />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="logMessage" returntype="void" access="public">
		<cfargument name="message" default="" />
		<cfargument name="messageType" default="" />
		<cfargument name="messageCode" default="" />
		<cfargument name="templatePath" default="" />
		<cfargument name="logType" default="Information" /><!--- Information  |  Error  |  Fatal  |  Warning  --->
		<cfargument name="generalLog" type="boolean" default="false" />

		<cfif getHibachiScope().setting("globalLogMessages") neq "none" and (getHibachiScope().setting("globalLogMessages") eq "detail" or arguments.generalLog)>
			<cfif generalLog>
				<cfset var logText = "General Log" />
			<cfelse>
				<cfset var logText = "Detail Log" />
			</cfif>

			<cfif arguments.messageType neq "" and isSimpleValue(arguments.messageType)>
				<cfset logText &= " - #arguments.messageType#" />
			</cfif>
			<cfif arguments.messageCode neq "" and isSimpleValue(arguments.messageCode)>
				<cfset logText &= " - #arguments.messageCode#" />
			</cfif>
			<cfif arguments.templatePath neq "" and isSimpleValue(arguments.templatePath)>
				<cfset logText &= " - #arguments.templatePath#" />
			</cfif>
			<cfif arguments.message neq "" and isSimpleValue(arguments.message)>
				<cfset logText &= " - #arguments.message#" />
			</cfif>

			<!--- Verify that the log type was correct --->
			<cfif not ListFind("Information,Error,Fatal,Warning", arguments.logType)>
				<cfset logMessage(messageType="Internal Error", messageCode = "500", message="The Log type that was attempted was not valid", logType="Warning") />
				<cfset arguments.logType = "Information" />
			</cfif>

			<cflog file="#getApplicationValue('applicationKey')#" text="#logText#" type="#arguments.logType#" />
		</cfif>

	</cffunction>

	<cffunction name="compareLists" access="public" returntype="struct" output="false" hint="Given two versions of a list, I return a struct containing the values that were added, the values that were removed, and the values that stayed the same.">
		<cfargument name="originalList" type="any" required="true" hint="List of original values." />
		<cfargument name="newList" type="any" required="true" hint="List of new values." />
		<cfset var local = StructNew() />

		<cfset local.results = StructNew() />
		<cfset local.results.addedList = "" />
		<cfset local.results.removedList = "" />
		<cfset local.results.sameList = "" />

		<cfloop list="#arguments.originalList#" index="local.thisItem">
			<cfif ListFindNoCase(arguments.newList, local.thisItem)>
				<cfset local.results.sameList = ListAppend(local.results.sameList, local.thisItem) />
			<cfelse>
				<cfset local.results.removedList = ListAppend(local.results.removedList, local.thisItem) />
			</cfif>
		</cfloop>

		<cfloop list="#arguments.newList#" index="local.thisItem">
			<cfif not ListFindNoCase(arguments.originalList, local.thisItem)>
				<cfset local.results.addedList = ListAppend(local.results.addedList, local.thisItem) />
			</cfif>
		</cfloop>

		<cfreturn local.results />
	</cffunction>

	<cffunction name="buildFormCollections" access="public" returntype="any" output="false" hint="">
		<cfargument name="formScope" type="struct" required="true" />
		<cfargument name="updateFormScope" type="boolean" required="true" default="true" hint="If true, adds the collections to the form scope." />
		<cfargument name="trimFields" type="boolean" required="true" default="true" />
		<cfset var local = StructNew() />

		<cfset local.tempStruct = StructNew() />
		<cfset local.tempStruct['formCollectionsList'] = "" />

		<!--- Loop over the form scope. --->
		<cfloop collection="#arguments.formScope#" item="local.thisField">

			<cfset local.thisField = Trim(local.thisField) />

			<!--- If the field has a dot or a bracket... --->
			<cfif hasFormCollectionSyntax(local.thisField)>

				<!--- Add collection to list if not present. --->
				<cfset local.tempStruct['formCollectionsList'] = addCollectionNameToCollectionList(local.tempStruct['formCollectionsList'], local.thisField) />

				<cfset local.currentElement = local.tempStruct />

				<!--- Loop over the field using . as the delimiter. --->
				<cfset local.delimiterCounter = 1 />
				<cfloop list="#local.thisField#" delimiters="." index="local.thisElement">
					<cfset local.tempElement = local.thisElement />
					<cfset local.tempIndex = 0 />

					<!--- If the current piece of the field has a bracket, determine the index and the element name. --->
					<cfif local.tempElement contains "[">
						<cfset local.tempIndex = ReReplaceNoCase(local.tempElement, '.+\[|\]', '', 'all') />
						<cfset local.tempElement = ReReplaceNoCase(local.tempElement, '\[.+\]', '', 'all') />
					</cfif>

					<!--- If there is a temp element defined, means this field is an array or struct. --->
					<cfif not StructKeyExists(local.currentElement, local.tempElement)>

						<!--- If tempIndex is 0, it's a Struct, otherwise an Array. --->
						<cfif local.tempIndex eq 0>
							<cfset local.currentElement[local.tempElement] = StructNew() />
						<cfelse>
							<cfset local.currentElement[local.tempElement] = ArrayNew(1) />
						</cfif>
					</cfif>

					<!--- If this is the last element defined by dots in the form field name, assign the form field value to the variable. --->
					<cfif local.delimiterCounter eq ListLen(local.thisField, '.')>

						<cfif local.tempIndex eq 0>
							<cfset local.currentElement[local.tempElement] = arguments.formScope[local.thisField] />
						<cfelse>
							<cfset local.currentElement[local.tempElement][local.tempIndex] = arguments.formScope[local.thisField] />
						</cfif>

					<!--- Otherwise, keep going through the field name looking for more structs or arrays. --->
					<cfelse>

						<!--- If this field was a Struct, make the next element the current element for the next loop iteration. --->
						<cfif local.tempIndex eq 0>
							<cfset local.currentElement = local.currentElement[local.tempElement] />
						<cfelse>

							<!--- If we're on CF8, leverage the ArrayIsDefined() function to avoid throwing costly exceptions. --->
							<cfif server.coldfusion.productName eq "ColdFusion Server" and ListFirst(server.coldfusion.productVersion) gte 8>

								<cfif ArrayIsEmpty(local.currentElement[local.tempElement])
										or ArrayLen(local.currentElement[local.tempElement]) lt local.tempIndex
										or not ArrayIsDefined(local.currentElement[local.tempElement], local.tempIndex)>
									<cfset local.currentElement[local.tempElement][local.tempIndex] = StructNew() />
								</cfif>

							<cfelse>

								<!--- Otherwise it's an Array, so we have to catch array element undefined errors and set them to new Structs. --->
								<cftry>
									<cfset local.currentElement[local.tempElement][local.tempIndex] />
									<cfcatch type="any">
										<cfset local.currentElement[local.tempElement][local.tempIndex] = StructNew() />
									</cfcatch>
								</cftry>

							</cfif>

							<!--- Make the next element the current element for the next loop iteration. --->
							<cfset local.currentElement = local.currentElement[local.tempElement][local.tempIndex] />

						</cfif>
						<cfset local.delimiterCounter = local.delimiterCounter + 1 />
					</cfif>

				</cfloop>
			</cfif>
		</cfloop>

		<!--- Done looping. If we've been set to update the form scope, append the created form collections to the form scope. --->
		<cfif arguments.updateFormScope>
			<cfset StructAppend(arguments.formScope, local.tempStruct) />
		</cfif>

		<cfreturn local.tempStruct />
	</cffunction>

	<cffunction name="hasFormCollectionSyntax" access="private" returntype="boolean" output="false" hint="I determine if the field has the form collection syntax, meaning it contains a dot or a bracket.">
		<cfargument name="fieldName" type="any" required="true" />
		<cfreturn arguments.fieldName contains "." or arguments.fieldName contains "[" />
	</cffunction>

	<cffunction name="addCollectionNameToCollectionList" access="private" returntype="string" output="false" hint="I add the collection name to the list of collection names if it isn't already there.">
		<cfargument name="formCollectionsList" type="string" required="true" />
		<cfargument name="fieldName" type="string" required="true" />
		<cfif not ListFindNoCase(arguments.formCollectionsList, ReReplaceNoCase(arguments.fieldName, '(\.|\[).+', ''))>
			<cfset arguments.formCollectionsList = ListAppend(arguments.formCollectionsList, ReReplaceNoCase(arguments.fieldName, '(\.|\[).+', '')) />
		</cfif>
		<cfreturn arguments.formCollectionsList />
	</cffunction>

	<cffunction name="QueryToCSV" access="public" returntype="string" output="false" hint="I take a query and convert it to a comma separated value string.">

	    <!--- Define arguments. --->
	    <cfargument name="Query" type="query" required="true" hint="I am the query being converted to CSV." />
	    <cfargument name="Fields" type="string" required="true" hint="I am the list of query fields to be used when creating the CSV value." />
	    <cfargument name="CreateHeaderRow" type="boolean" required="false" default="true" hint="I flag whether or not to create a row of header values." />
	    <cfargument name="Delimiter" type="string" required="false" default="," hint="I am the field delimiter in the CSV value." />

	    <!--- Define the local scope. --->
	    <cfset var LOCAL = {} />

	    <!---
	        First, we want to set up a column index so that we can
	        iterate over the column names faster than if we used a
	        standard list loop on the passed-in list.
	    --->
	    <cfset LOCAL.ColumnNames = [] />

	    <!---
	        Loop over column names and index them numerically. We
	        are working with an array since I believe its loop times
	        are faster than that of a list.
	    --->
	    <cfloop
	        index="LOCAL.ColumnName"
	        list="#ARGUMENTS.Fields#"
	        delimiters=",">

	        <!--- Store the current column name. --->
	        <cfset ArrayAppend(
	            LOCAL.ColumnNames,
	            Trim( LOCAL.ColumnName )
	            ) />

	    </cfloop>

	    <!--- Store the column count. --->
	    <cfset LOCAL.ColumnCount = ArrayLen( LOCAL.ColumnNames ) />


	    <!---
	        Now that we have our index in place, let's create
	        a string buffer to help us build the CSV value more
	        effiently.
	    --->
	    <cfset LOCAL.Buffer = CreateObject( "java", "java.lang.StringBuffer" ).Init() />

	    <!--- Create a short hand for the new line characters. --->
	    <cfset LOCAL.NewLine = (Chr( 13 ) & Chr( 10 )) />


	    <!--- Check to see if we need to add a header row. --->
	    <cfif ARGUMENTS.CreateHeaderRow>

	        <!--- Create array to hold row data. --->
	        <cfset LOCAL.RowData = [] />

	        <!--- Loop over the column names. --->
	        <cfloop
	            index="LOCAL.ColumnIndex"
	            from="1"
	            to="#LOCAL.ColumnCount#"
	            step="1">

	            <!--- Add the field name to the row data. --->
	            <cfset LOCAL.RowData[ LOCAL.ColumnIndex ] = """#LOCAL.ColumnNames[ LOCAL.ColumnIndex ]#""" />

	        </cfloop>

	        <!--- Append the row data to the string buffer. --->
	        <cfset LOCAL.Buffer.Append(
	            JavaCast(
	                "string",
	                (
	                    ArrayToList(
	                        LOCAL.RowData,
	                        ARGUMENTS.Delimiter
	                        ) &
	                    LOCAL.NewLine
	                ))
	            ) />

	    </cfif>


	    <!---
	        Now that we have dealt with any header value, let's
	        convert the query body to CSV. When doing this, we are
	        going to qualify each field value. This is done be
	        default since it will be much faster than actually
	        checking to see if a field needs to be qualified.
	    --->

	    <!--- Loop over the query. --->
	    <cfloop query="ARGUMENTS.Query">

	        <!--- Create array to hold row data. --->
	        <cfset LOCAL.RowData = [] />

	        <!--- Loop over the columns. --->
	        <cfloop
	            index="LOCAL.ColumnIndex"
	            from="1"
	            to="#LOCAL.ColumnCount#"
	            step="1">

	            <!--- Add the field to the row data. --->
	            <cfset LOCAL.RowData[ LOCAL.ColumnIndex ] = """#Replace( ARGUMENTS.Query[ LOCAL.ColumnNames[ LOCAL.ColumnIndex ] ][ ARGUMENTS.Query.CurrentRow ], """", """""", "all" )#""" />

	        </cfloop>


	        <!--- Append the row data to the string buffer. --->
	        <cfset LOCAL.Buffer.Append(
	            JavaCast(
	                "string",
	                (
	                    ArrayToList(
	                        LOCAL.RowData,
	                        ARGUMENTS.Delimiter
	                        ) &
	                    LOCAL.NewLine
	                ))
	            ) />

	    </cfloop>


	    <!--- Return the CSV value. --->
	    <cfreturn LOCAL.Buffer.ToString() />
	</cffunction>

	<cffunction name="getCurrentUtcTime" returntype="Numeric" >
        <cfset local.currentDate = Now()>
        <cfset local.utcDate = dateConvert( "local2utc", local.currentDate )>
        <cfreturn round( local.utcDate.getTime() / 1000 )>
    </cffunction>

    <cffunction name="convertBase64GIFToBase64PDF">
    	<cfargument name="base64GIF" />
    	<cfset var myImage = ImageReadBase64("data:image/gif;base64,#arguments.base64GIF#")>
    	<cfset var tempDirectory = getTempDirectory()&'/newimage.gif'>
    	<cfset imageWrite(myImage,tempDirectory)>
		<cfdocument name="local.newpdf" format="pdf" localUrl="yes">
			<cfoutput>
				<img src="file:///#tempDirectory#" />
			</cfoutput>
		</cfdocument>
		<cfreturn ToBase64(newpdf) />
    </cffunction>


</cfcomponent>
