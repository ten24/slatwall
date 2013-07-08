<cfcomponent output="false" accessors="true" extends="HibachiService">
	
	<cfproperty name="hibachiTagService" type="any" />
	
	<cfscript>
		// @hint this method allows you to properly format a value against a formatType
		public any function formatValue( required string value, required string formatType, struct formatDetails={} ) {
			if(listFindNoCase("currency,date,datetime,pixels,percentage,second,time,truefalse,url,weight,yesno", arguments.formatType)) {
				return this.invokeMethod("formatValue_#arguments.formatType#", {value=arguments.value, formatDetails=arguments.formatDetails});	
			}
			return arguments.value;
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
		
		public string function replaceStringTemplate(required string template, required any object, boolean formatValues=false) {
			var templateKeys = reMatchNoCase("\${[^}]+}",arguments.template);
			var replacementArray = [];
			var returnString = arguments.template;
			
			for(var i=1; i<=arrayLen(templateKeys); i++) {
				var replaceDetails = {};
				replaceDetails.key = templateKeys[i];
				replaceDetails.value = templateKeys[i];
				
				var valueKey = replace(replace(templateKeys[i], "${", ""),"}","");
				if( isStruct(arguments.object) && structKeyExists(arguments.object, valueKey) ) {
					replaceDetails.value = arguments.object[ valueKey ];
				} else if (isObject(arguments.object)) {
					replaceDetails.value = arguments.object.getValueByPropertyIdentifier(valueKey, arguments.formatValues);	
				}
				
				arrayAppend(replacementArray, replaceDetails);
			}
			
			for(var i=1; i<=arrayLen(replacementArray); i++) {
				returnString = replace(returnString, replacementArray[i].key, replacementArray[i].value, "all");
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
		
		private void function copyFile(required string source, required string destination, boolean overwrite=false){
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
			getHibachiTagService().cfheader(name="Content-Disposition", value="inline; filename=#arguments.fileName#"); 
			getHibachiTagService().cfcontent(type="#arguments.contentType#", file="#arguments.filePath#", deletefile="#arguments.deleteFile#");
		}
		
		public string function encryptValue(required string value) {
			return encrypt(arguments.value, getEncryptionKey(), "AES", "Base64");
		}
	
		public string function decryptValue(required string value) {
			try {
				return decrypt(arguments.value, getEncryptionKey(), "AES", "Base64");	
			} catch (any e) {
				logHibachi("There was an error decrypting a value from the database.  This is usually because the application cannot find the Encryption key used to encrypt the data.  Verify that you have a key file in the location specified in the advanced settings of the admin.", true);
				return "";
			}
		}
		
		public string function createEncryptionKey() {
			var	theKey = generateSecretKey("Base64", "128");
			storeEncryptionKey(theKey);
			return theKey;
		}
		
		public string function getEncryptionKey() {
			if(!encryptionKeyExists()){
				createEncryptionKey();
			}
			var encryptionFileData = fileRead(getEncryptionKeyFilePath());
			var encryptionInfoXML = xmlParse(encryptionFileData);
			return encryptionInfoXML.crypt.key.xmlText;
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
		
		private boolean function encryptionKeyExists() {
			return fileExists(getEncryptionKeyFilePath());
		}
		
		private void function storeEncryptionKey(required string key) {
			var theKey = "<crypt><key>#arguments.key#</key></crypt>";
			fileWrite(getEncryptionKeyFilePath(),theKey);
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
</cfcomponent>