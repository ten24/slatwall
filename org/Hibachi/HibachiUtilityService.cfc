<cfcomponent output="false" accessors="true" extends="HibachiService">

	<cfproperty name="hibachiTagService" type="any" />
	<cfproperty name="encryptionPasswordArray" type="any" />

	<cfscript>
	
		public any function hibachiArrayMap(required array data, required any closure, numeric parallelThreadNumber, boolean debug = false){
		
			if(!structKeyExists(arguments, 'parallelThreadNumber')){
				arguments.parallelThreadNumber = createObject( "java", "java.lang.Runtime" ).getRuntime().availableProcessors();
			}
			
			if(!isClosure(arguments.closure)){
				throw('Invalid argument type, hibachiArrayMap expects a closure');
			}
			
			var resultArray = [];
			var threadNameList = '';
			var dataCount = arrayLen(arguments.data);
			for( var i = 1; i <= dataCount; i++ ){
				var threadName = 'hibachiArrayMap-#CreateUUID()#-#i#';
				threadNameList = listAppend(threadNameList, threadName);
				
				thread item=arguments.data[i] closure=arguments.closure name=threadName {
					writeOutput(closure(item));
				}
				if(i % arguments.parallelThreadNumber == 0){
				
					thread action="join" name=threadNameList;
				
					for(var threadResult in threadNameList){
						if(!structKeyExists(cfthread[threadResult], 'error')){
							arrayAppend(resultArray, trim(cfthread[threadResult]['output']));
						}else if(arguments.debug){
							throw(cfthread[threadResult].error);
						}
					}
					threadNameList = '';
				}
			}
			
			if(len(threadNameList)){
			
				thread action="join" name=threadNameList;
				
				for(var threadResult in threadNameList){
					if(!structKeyExists(cfthread[threadResult], 'error')){
						arrayAppend(resultArray, trim(cfthread[threadResult]['output']));
					}else if(arguments.debug){
						throw(cfthread[threadResult].error);
					}
				}
			}
			
			return resultArray;
		}
	
		public any function getHttpResponse(required any http, numeric timeout = 3, boolean throwOnTimeout = true){
			arguments.http.setTimeout(arguments.timeout);
			var result = arguments.http.send().getPrefix();
			if( arguments.throwOnTimeout && result['status_code'] == 408 ){
				throw(result['errordetail']);
			}
			if( findNoCase('application/json', result['header']) ){
				return deserializeJson(result['filecontent']);
			}else{
				return result['filecontent'];
			}
		}
		
		public string function getDatabaseUUID(){
			switch(getHibachiScope().getApplicationValue('databaseType')){
				case 'Oracle10g':
					return 'LOWER(SYS_GUID())';
				case 'MySQL':
					return "LOWER(REPLACE(CAST(UUID() as char character set utf8),'-',''))";
				case 'MicrosoftSQLServer':
					return "LOWER(REPLACE(newid(),'-',''))";
			}
		}
		
		
		public function formatStructKeyList(required string str){
 		    if (!structKeyExists(server, "lucee")){
 		        return str;
 		    }
 		    var formattedStructKeyList = '';
 		    var strArray = listToArray(str, '.');
 		    for( var key in strArray){
 		        if(isNumeric(left(key, 1))){
 		            formattedStructKeyList &= "['#key#']";
 		        }else{
 		            formattedStructKeyList = listAppend(formattedStructKeyList, key, '.');
 		        }
 		    };
 		    return formattedStructKeyList;
 		}	

		public function removeListValue(required string list, required string value){ 
			var listIndex = listFindNoCase(arguments.list, arguments.value);
			if(listIndex != 0){
				return listDeleteAt(arguments.list, listIndex); 
			} 
			return arguments.list; 	
		} 

 		public any function getQueryLabels(required any query){
 			var qryColumns = "";
 			for (var column in getMetaData(arguments.query)){
 				qryColumns = listAppend(qryColumns, column.name);
 			}
 			return local.qryColumns;
 		}

 		public string function getSQLType(required any ormtype){
 			var types = {
 				"big_decimal":"decimal",
 				"text":"varchar"
 			};
 			if(structKeyExists(types, ormtype)){
 				return types[ormtype];
 			}
 			return ormtype;
 		}
 		
		public any function precisionCalculate(required numeric value, numeric scale=2){
			var roundingmode = createObject('java','java.math.RoundingMode');
			return javacast('bigdecimal',arguments.value).setScale(arguments.scale,roundingmode.HALF_EVEN);
		}
		
		public string function lowerCaseToTitleCase(required string stringValue){
			return REReplace(arguments.stringValue, "\b(\S)(\S*)\b", "\u\1\L\2", "all");
		}
		
		public string function snakeCaseToTitleCase(required string stringValue){
			arguments.stringValue = REReplace(stringValue,'-',' ','all');
			return lowerCaseToTitleCase(arguments.stringValue);
		}
		
		public string function camelCaseToTitleCase(required string stringValue){
			return rereplace(rereplace(arguments.stringValue,"(^[a-z])","\u\1"),"([A-Z])"," \1","all");
		}

		public string function arrayOfStructsToList(required array structs, required string structKeyForList, string delimiter=','){
			var listToReturn = "";
			for(var record in arguments.structs){
				listToReturn = listAppend(listToReturn, record[arguments.structKeyForList], arguments.delimiter );
			} 
			return listToReturn; 
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
		public array function arrayOfStructsSort(aOfS,key,sortOrder="asc"){


		        //by default, we'll use a textnocase sort
		        var sortType = "textnocase";
		        //by default, use ascii character 30 as the delim
		        var delim = ".";
		        //make an array to hold the sort stuff
		        var sortArray = arraynew(1);

		        //make an array to return
		        var returnArray = arraynew(1);

		        //grab the number of elements in the array (used in the loops)
		        var count = arrayLen(arguments.aOfS);
		        //make a variable to use in the loop
		        var ii = 1; var j=1;
		        //if there is a 4th argument, set the sortType
		        if(arraylen(arguments) GT 3)
		            sortType = arguments[4];
		        //if there is a 5th argument, set the delim
		        if(arraylen(arguments) GT 4)
		            delim = arguments[5];
		        //loop over the array of structs, building the sortArray
		        for(ii = 1; ii lte count; ii = ii + 1)
		            sortArray[ii] = arguments.aOfS[ii][arguments.key] & delim & ii;
		        //now sort the array
		        arraySort(sortArray,sortType,arguments.sortOrder);
		        //now build the return array
		        for(ii = 1; ii lte count; ii = ii + 1)
		            returnArray[ii] = arguments.aOfS[listLast(sortArray[ii],delim)];
		        //return the array
		        return returnArray;
		}

		public boolean function isInThread(){
			//java 8
			try{
				var ThreadAPI = createObject("java","java.lang.Thread");
			//java 7
			}catch(any e){
				var ThreadAPI = createObject("java","java.lang.thread");
			}


			var currentThread = ThreadAPI.currentThread();

			return currentThread.getThreadGroup().getName() == "cfthread";
		}

		public string function obfuscateValue(required string value){
			if(len(value)){
				return lcase(rereplace(CreateUUID(), '[^A-Z]', '', 'ALL'));
			}
			return '';
		}

		// @hint this method will sanitize a struct of data
		public void function sanitizeData(required any data){
			for(var key in arguments.data){
			  if( isSimpleValue(arguments.data[key]) && key != 'serializedJsonData'){
			    arguments.data[key] = variables.antisamy.scan(data[key],variables.antiSamyConfig.policyFile).getCleanHTML();
			  }
			}
		}

		// @hint this method allows you to properly format a value against a formatType
		public any function formatValue( required string value, required string formatType, struct formatDetails={} ) {

			if(listFindNoCase("decimal,currency,date,datetime,pixels,percentage,second,time,truefalse,url,weight,yesno,urltitle,alphanumericdash", arguments.formatType)) {
				return this.invokeMethod("formatValue_#arguments.formatType#", {value=arguments.value, formatDetails=arguments.formatDetails});
			}else{
				return this.formatValue_language(value=arguments.value,formatDetails=arguments.formatDetails);
			}
			return arguments.value;
		}
		
		public any function formatValue_language(required string value, struct formatDetails={}){
			if(structKeyExists(arguments.formatDetails,'locale') 
				&& structKeyExists(arguments.formatDetails,'propertyName')
				&& structKeyExists(arguments.formatDetails,'object')
				&& structKeyExists(arguments.formatDetails.object, 'getPrimaryIDValue')
			){
				var translation = getService('TranslationService').getTranslationValue(
					baseObject=arguments.formatDetails.object.getClassName(),
					baseID = arguments.formatDetails.object.getPrimaryIDValue(),
					basePropertyName=arguments.formatDetails.propertyName,
					locale=arguments.formatDetails.locale
				);

				if(!isNull(translation)){
					return translation;
				}else if(!isNull(formatDetails.useFallback) && !formatDetails.useFallback){
					var globalLocale = getService('SettingService').getSettingValue('globalLocale');
					if(globalLocale != arguments.formatDetails.locale){
						return '';
					}
				}
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

			if(!structKeyExists(arguments, 'formatDetails')){
				arguments.formatDetails.locale = getHibachiScope().getRBLocale();   
			}

			if(structKeyExists(arguments.formatDetails, "currencyCode") && len(arguments.formatDetails.currencyCode) == 3 ) {
				return LSCurrencyFormat(arguments.value, arguments.formatDetails.currencyCode, arguments.formatDetails.locale);
			}
			return LSCurrencyFormat(arguments.value, "local", arguments.formatDetails.locale);
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

			var addon = 0;

			var urlTitle = createSEOString(arguments.titleString);

			var returnTitle = urlTitle;

			var unique = getHibachiDAO().verifyUniqueTableValue(tableName=arguments.tableName, column=arguments.columnName, value=returnTitle);

			while(!unique) {
				addon++;
				//check to inc the addon.
				var idx = len(addon)+1;//+1 for dash
				if (right(returnTitle, idx) == "-#addon#"){
					addon++;
					//increase the addon index and then replace the last two chars instead of appending.
					var removedLast = Left(returnTitle, len(returnTitle)-idx);
					returnTitle = "#removedLast#-#addon#";
				}else{
					returnTitle = "#urlTitle#-#addon#";	
				}
				
				unique = getHibachiDAO().verifyUniqueTableValue(tableName=arguments.tableName, column=arguments.columnName, value=returnTitle);
			}

			return returnTitle;
		}
		
		public string function createUniqueCode(required string tableName, required string column, string prefix = '', numeric size = 7) {
			var isUnique = false;
			var uniqueCode = "";
			while(!isUnique) {
				uniqueCode = prefix & getHibachiUtilityService().generateRandomID(size);
				isUnique = getHibachiDAO().verifyUniqueTableValue(tableName=arguments.tableName, column=arguments.column, value=uniqueCode);
			}
			return uniqueCode;
		}
		
		public string function createUniqueProperty(required string propertyValue, required string entityName, required string propertyName, boolean requiresCount = false){
			var addon = 0;

			arguments.propertyValue = createSEOString(arguments.propertyValue);
			
			var returnValue = arguments.propertyValue;
			
			if (requiresCount) {
				returnValue = '#returnValue#-1';
			}

            var unique = getHibachiDAO().verifyUniquePropertyValue(
    			entityName=arguments.entityName, 
    			propertyName=arguments.propertyName, 
    			value=returnValue
			);
			
			while(!unique) {
				addon++;
				returnValue = "#arguments.propertyValue#-#addon#";
				unique = getHibachiDAO().verifyUniquePropertyValue(entityName=arguments.entityName, propertyName=arguments.propertyName, value=returnValue);
			}

			return returnValue;
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
	  	/**
	    * Returns a URI that can be used in a QR code with a multi factor authenticator app implementations
	    * Resources: 
	    * 	https://github.com/google/google-authenticator/wiki/Conflicting-Accounts
	    * 	https://github.com/google/google-authenticator/wiki/Key-Uri-Format
	    *
	    * @param email the email address of the user account
	    * @param key the Base32 encoded secret key to use in the code
	    */
	    public string function buildOTPUri(required string email, required string secretKey)
	    {
	        return "otpauth://totp/#getApplicationValue('applicationKey')#:#arguments.email#?secret=#arguments.secretKey#&issuer=#getApplicationValue('applicationKey')#";
	    }
	    
	    //be careful with this. Not for general use. can pose security risk if not used properly.
	    public string function hibachiDecodeForHTML(string stringValue){
		
			var encoder = createObject('java','org.owasp.esapi.ESAPI').encoder();
			return encoder.decodeForHTML(arguments.stringValue);
		}

		public any function buildPropertyIdentifierListDataStruct(required any object, required string propertyIdentifierList, string availablePropertyIdentifierList) {
			var responseData = {};
			
			if(!structKeyExists(arguments,'availablePropertyIdentifierList')){
				arguments.availablePropertyIdentifierList = arguments.propertyIdentifierList;
			}
			
			var propertyIdentifierArray = listToArray(arguments.propertyIdentifierList);
			for(var i=1; i <= arraylen(propertyIdentifierArray);i++) {
				var propertyIdentifier = propertyIdentifierArray[i];
				if( listFindNoCase(arguments.availablePropertyIdentifierList, trim(propertyIdentifier)) ) {
					buildPropertyIdentifierDataStruct(arguments.object, trim(propertyIdentifier), responseData);
				}
			}

			return responseData;
		}

		public any function buildPropertyIdentifierDataStruct(required parentObject, required string propertyIdentifier, required any data) {
			if(listLen(arguments.propertyIdentifier, ".") eq 1) {
				if(structkeyExists(arguments.parentObject,'getValueByPropertyIdentifier')){
					arguments.data[ arguments.propertyIdentifier ] = arguments.parentObject.getValueByPropertyIdentifier( arguments.propertyIdentifier );
				}else{
					arguments.data[ arguments.propertyIdentifier ] = arguments.parentObject[ arguments.propertyIdentifier ];
				}
				return;
			}

			if(structKeyExists(arguments.parentObject,'invokeMethod')){
				var object = arguments.parentObject.invokeMethod("get#listFirst(arguments.propertyIdentifier, '.')#");
			}else{
				var object = arguments.parentObject[listFirst(arguments.propertyIdentifier, '.')];
			}
			//only structs using closures
			if(!isNull(object) && (isObject(object) || isStruct(object))) {
				var thisProperty = listFirst(arguments.propertyIdentifier, '.');
				param name="arguments.data[thisProperty]" default="#structNew()#";

				if(!structKeyExists(arguments.data[thisProperty],"errors")) {
					// add error messages
					arguments.data[thisProperty]["hasErrors"] = object.hasErrors();
					arguments.data[thisProperty]["errors"] = object.getErrors();
				}

				buildPropertyIdentifierDataStruct(object,listDeleteAt(arguments.propertyIdentifier, 1, "."), arguments.data[thisProperty]);
			} else if(!isNull(object) && isArray(object)) {
				var thisProperty = listFirst(arguments.propertyIdentifier, '.');
				param name="arguments.data[thisProperty]" default="#arrayNew(1)#";

				for(var i = 1; i <= arrayLen(object); i++){
					param name="arguments.data[thisProperty][i]" default="#structNew()#";

					if(!structKeyExists(arguments.data[thisProperty][i],"errors")) {
						// add error messages
						try{
							if(structKeyExists(arguments.data[thisProperty][i],'hasErrors')){
								arguments.data[thisProperty][i]["hasErrors"] = object[i].hasErrors();
								arguments.data[thisProperty][i]["errors"] = object[i].getErrors();
							}else{
								arguments.data[thisProperty][i]["hasErrors"] = false;
								arguments.data[thisProperty][i]["errors"] = {};
							}


						}catch(any e){
							writeDump(var=object[i],top=1);abort;
						}
					}

					buildPropertyIdentifierDataStruct(object[i],listDeleteAt(arguments.propertyIdentifier, 1, "."), arguments.data[thisProperty][i]);
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

		public boolean function isStringTemplate(required string value){
			return arraylen(getTemplateKeys(arguments.value));
		}

		//replace single brackets ${}
		public string function replaceStringTemplate(required string template, required any object, boolean formatValues=false, boolean removeMissingKeys=false, string templateContextPathList, string locale=getHibachiScope().getSession().getRbLocale()) {

			var templateKeys = getTemplateKeys(arguments.template);
			var replacementArray = [];
			var returnString = arguments.template;
			
			for(var i=1; i<=arrayLen(templateKeys); i++) {
				var replaceDetails = {};
				replaceDetails.key = templateKeys[i];
				replaceDetails.value = templateKeys[i];

				var valueKey = replace(replace(templateKeys[i], "${", ""),"}","");

				if( listLen(valueKey,':') == 2 && 
					listFirst(valueKey,':') == 'template' &&
					structKeyExists(arguments, 'templateContextPathList')	
				){
				
					//${template:order-details} load order-details.cfm  
					var templateBody = '';
					var templateFileName = listRest(valueKey, ':') & '.cfm';


					var contextPaths = listToArray(arguments.templateContextPathList); 

					var templateContextPath = ''; 	
					for(var contextPath in contextPaths){
						
						if(fileExists(contextPath & templateFileName)){
						    templateContextPath = contextPath & templateFileName; 
							break;	
						} 
					} 

					if(len(templateContextPath)){ 

						//TODO: remove Slatwall reference from hibachi
						templateContextPath = replaceNoCase(templateContextPath, getApplicationValue('applicationRootMappingPath'), getApplicationValue('slatwallRootURL'));

						//make object available in scope with its given name
						if(structKeyExists(arguments.object, 'getClassName')){
							local[arguments.object.getClassName()] = arguments.object;
						} else if(isStruct(arguments.object)) {
							structAppend(local, arguments.object); 
						}

						local.locale = arguments.locale;

						savecontent variable="templateBody" {
							include '#templateContextPath#';
						} 

						replaceDetails.value = templateBody; 
					}

				} else if( isStruct(arguments.object) && structKeyExists(arguments.object, valueKey) ) {
					replaceDetails.value = arguments.object[ valueKey ];
				} else if (isObject(arguments.object) &&
					(
						(
							arguments.object.isPersistent() && getService('hibachiservice').getHasPropertyByEntityNameAndPropertyIdentifier(arguments.object.getEntityName(), valueKey)
						)
						||
						(
							arguments.object.isPersistent()
							&& structKeyExists(getService('hibachiService'),'getHasAttributeByEntityNameAndPropertyIdentifier')
							&& getService('hibachiService').getHasAttributeByEntityNameAndPropertyIdentifier(arguments.object.getEntityName(), valueKey)
						)
						||
						(
							!arguments.object.isPersistent() && arguments.object.hasPropertyByPropertyIdentifier(valueKey)
						)
						||
						(
							!arguments.object.isPersistent() && arguments.object.hasProperty(valueKey)
						)
					)
				) {
					replaceDetails.value = arguments.object.getValueByPropertyIdentifier(valueKey, arguments.formatValues);
				}
					
				if ( arguments.removeMissingKeys && replaceDetails.key == replaceDetails.value) {
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
				var args = arguments; 
				args['template'] = returnString; 

				returnString = replaceStringTemplate(argumentCollection=args);
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
			
			
		    if (structKeyExists(server, "lucee")){
				//using CF10 now so don't need to support CF9
				arrayAppend(arguments.a1,arguments.a2,true);
				return arguments.a1;
		    }else{
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
		}
		
		//name value pair string to struct. Separates url string by & ampersand
		public struct function convertNVPStringToStruct( required string data ) {
			if(left(arguments.data,1) == '?'){
				arguments.data = right(arguments.data,len(arguments.data)-1);
			}
			var returnStruct = {};
			var ampArray = listToArray(arguments.data, "&");
			for(var i=1; i<=arrayLen(ampArray); i++) {
				returnStruct[ listFirst(ampArray[i], "=") ] = listLast(ampArray[i], "=");
			}
			return returnStruct;
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

		/**
          * Utlility Function to sluggify any string input;
          * 
          * @stringToBeSlugged 
          * @spacer, the char to seperate words int the slug
          *
          * Uses: 
          * 
          * ``` var sluggified = createSEOString( "example string", '-' ); ```
          * ``` var sluggified = createSEOString("[{,./?:;(*&^%$@!~ This IS a sTrIng abcde àáâãäå èéêë ìíîï òóôö ùúûü ñ año ñññññññññññññ"); ```
        */
		public string function createSEOString(required string toFormat, string delimiter="-", boolean smallCase=true){

			var result = replace(arguments.toFormat,"'", "", "all");

        	result = trim(ReReplaceNoCase(result, "<[^>]*>", "", "ALL"));

        	result = ReplaceList(result, "À,Á,Â,Ã,Ä,Å,Æ,È,É,Ê,Ë,Ì,Í,Î,Ï,Ð,Ñ,Ò,Ó,Ô,Õ,Ö,Ø,Ù,Ú,Û,Ü,Ý,à,á,â,ã,ä,å,æ,è,é,ê,ë,ì,í,î,ï,ñ,ò,ó,ô,õ,ö,ø,ù,ú,û,ü,ý,&nbsp;,&amp;", "A,A,A,A,A,A,AE,E,E,E,E,I,I,I,I,D,N,O,O,O,O,O,0,U,U,U,U,Y,a,a,a,a,a,a,ae,e,e,e,e,i,i,i,i,n,o,o,o,o,o,0,u,u,u,u,y, , ");

        	result = trim(rereplace(result, "[[:punct:]]"," ","all"));

        	result = rereplace(result, "[[:space:]]+","!","all");

        	result = ReReplace(result, "[^a-zA-Z0-9!]", "", "ALL");

        	result = trim(rereplace(result, "!+", arguments.delimiter, "all"));

            if( arguments.smallCase ){
                result = lcase(result);
            }

        	return result;
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
		public void function downloadFile(required string fileName, required string filePath, string contentType = 'application/unknown; charset=UTF-8', boolean deleteFile = false) {
			getHibachiTagService().cfheader(name="Content-Disposition", value="attachment; filename=""#arguments.fileName#""");
			getHibachiTagService().cfcontent(type="#arguments.contentType#", file="#arguments.filePath#", deletefile="#arguments.deleteFile#");
		}
		
		public string function getIdentityHashCode(required any value) {
			return createObject("java","java.lang.System").identityHashCode(arguments.value);
		}

		public string function encryptValue(required string value, string salt="") {
			if(len(arguments.value)){
				var passwords = getEncryptionPasswordArray();
				return encrypt(arguments.value, generatePasswordBasedEncryptionKey(password=passwords[1].password, salt=arguments.salt, iterationCount=passwords[1].iterationCount), getEncryptionAlgorithm(), getEncryptionEncoding());				
			}
		}

		public string function hibachiHTMLEditFormat(required any html="", boolean angularSanitize=true){
			//If its something that can be turned into a string, make sure its a string.
			if (isSimpleValue(arguments.html)){
				arguments.html = "#arguments.html#";
			//Otherwise, it can't be passed into htmlEditFormat
			}else{
				return "";
			}
			if(structKeyExists(server,"railo") || structKeyExists(server,'lucee')) {
				var sanitizedString = esapiEncode('html', arguments.html);
			}else{
				var sanitizedString = encodeForHTML(arguments.html);
			}
			if(arguments.angularSanitize){
				sanitizedString = sanitizeForAngular(sanitizedString);
			}
			return sanitizedString;
		}
		
		public string function hibachiEncodeForXML(required string xmlString){
			arguments.xmlString = encodeForXML(arguments.xmlString);
			arguments.xmlString = ReReplace(arguments.xmlString, '&', '&amp;', 'all');
			arguments.xmlString = ReReplace(arguments.xmlString, '<', '&lt;', 'all');
			arguments.xmlString = ReReplace(arguments.xmlString, '>', '&rt;', 'all');
			return arguments.xmlString;
		}

		public string function sanitizeForAngular(required string html){
			if(structKeyExists(server,"railo") || structKeyExists(server,'lucee')) {
				arguments.html = ReReplace(arguments.html,'{',chr(123)&chr(002),'all');
				arguments.html = ReReplace(arguments.html,'%7B',chr(123)&chr(002),'all');
				return arguments.html;
			}else{
				return ReReplace(ReReplace(arguments.html,'&##x7b;',chr(123)&chr(002),'all'),'&##x7d;','}','all');
			}
		}

		public string function decryptValue(required string value, string salt="") {
			var encryptionPasswordArray = getEncryptionPasswordArray();
			for (var passwordData in encryptionPasswordArray) {
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
			
			var errorMessage = "There was an error decrypting a value from the database.  This is usually because the application cannot derive the Encryption key used to encrypt the data.  Verify that you have a password file in the location specified in the advanced settings of the admin."; 
		    if( !isNull(this.getHibachiScope().getAccount()) && this.getHibachiScope().getAccount().getAdminAccountFlag() ){
		        this.getHibachiScope().showMessage( errorMessage, 'error');
		    }
			this.logHibachi(errorMessage, true);
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
		
			if(structKeyExists(variables, 'encryptionPasswordArray')){
				return variables.encryptionPasswordArray;
			}
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
					
					// Remove legacy key file from file system
					// Commented out 2018-10-30 because the application initialization calls EncryptionService.verifyEncryptionKeyExists() which will recreate the key.xml.cfm during next reload
					// And the encryption key stored in key.xml.cfm will be ported into the password.txt.cfm with unbound file growth
					// removeLegacyEncryptionKeyFile();
				}
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
				var sortedPasswordKeys = structSort(unsortedPasswordsStruct, 'textnocase', 'desc', 'createdDateTime');

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
			
			variables.encryptionPasswordArray = passwords;

			return passwords;
		}
		
		/**
		 * Utility function to generate random passowrds of given @length
		 *  Example. generateRandomPassword(10);
		*/
		public string function generateRandomPassword( numeric length=8 ){

            if(arguments.length<5){
                throw("there must be at least 5 chars in the password")
            }

    		//  Set up available lower case values. 
    		var strLowerCaseAlpha = "abcdefghjkmnpqrstuvwxyz"; // o,i,l has been ignored as they can have confusing-font
    		var strUpperCaseAlpha = UCase( strLowerCaseAlpha );
    		//  Set up available numbers. 
    		var strNumbers = "123456789"; // 0 is ignored as it can has confusing fonts for example  o,O,0
    		//  Set up additional valid password chars. 
    		var strOtherChars = "~!@##$%^&*";

    		var strAllValidChars = ( strLowerCaseAlpha & strUpperCaseAlpha & strNumbers & strOtherChars );

    		// Create an array to contain the password ( think of a string as an array of character).
    		var arrPassword = [];
    		/* 
    		    Rules
    		
            	the password must:
            	- must be exactly [@arguments.length] characters in length
            	- must have at least 1 number
            	- must have at least 1 uppercase letter
            	- must have at least 1 lower case letter
            */

    		//  Select the random number from our number set. 
    		arrPassword[ 1 ] = Mid( strNumbers, RandRange( 1, Len(strNumbers) ), 1 );
    		//  Select the random letter from our lower case set. 
    		arrPassword[ 2 ] = Mid( strLowerCaseAlpha, RandRange( 1, Len(strLowerCaseAlpha) ), 1 );
    		//  Select the random letter from our upper case set. 
    		arrPassword[ 3 ] = Mid( strUpperCaseAlpha, RandRange( 1, Len(strUpperCaseAlpha) ), 1 );
    		/* 
            	ASSERT: At this time, we have satisfied the character
            	requirements of the password, but NOT the length
            	requirement. In order to do that, we must add more
            	random characters to make up a proper length. 
            */

    		//  Create rest of the password. 
    		for ( var charIndex=(ArrayLen( arrPassword ) + 1) ; charIndex<= arguments.length ; charIndex++ ) {
        		/*  Pick random value. For this character, we can choose from the entire set of valid characters. */
        		arrPassword[ charIndex ] = Mid( strAllValidChars, RandRange( 1, Len(strAllValidChars) ), 1 );
    		}

    		/* 
            	Now, we have an array that has the proper number of
            	characters and fits the business rules. But, we don't
            	always want the first three characters to be of the
            	same order (by type).
            */
    		CreateObject( "java", "java.util.Collections" ).Shuffle( arrPassword );
    		/* 
            	We now have a randomly shuffled array. Now, we just need to join all the characters into a single string.
            */
    		return ArrayToList( arrPassword, "" );
	    }

		private string function getEncryptionKeyFilePath() {
			return getEncryptionKeyLocation() & getEncryptionKeyFileName();
		}

		private string function getEncryptionKeyLocation() {
			return expandPath('/#getApplicationValue('applicationKey')#/custom/system/');
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
			logHibachi("Encryption key file updated", true);
			structDelete(variables, 'encryptionPasswordArray');
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

		public string function trimList(required string originalList, string delimiter = ","){
			return REReplace(trim(originalList),"\s*#delimiter#\s*",delimiter,"ALL");
		}


		public void function queryToCsvFile(required string filePath, required query queryData, boolean includeHeaderRow = true, string delimiter = ",", string columnNames = "", string columnTitles = ""){

			var newLine     = (chr(13) & chr(10));
			var buffer      = CreateObject('java','java.lang.StringBuffer').Init();

			if(!listLen(arguments.columnNames)){
				arguments.columnNames = arguments.queryData.columnlist;
			}

			if(!listLen(arguments.columnTitles)){
				arguments.columnTitles = arguments.columnNames;
			}

			// Check if we should include a header row
			if(arguments.includeHeaderRow){
				//Create the file with the headers
				fileWrite(arguments.filePath,"#ListQualify(arguments.columnTitles,'"',',','all')##newLine#");
			}else{
				//Create the file
				fileWrite(arguments.filePath,"");
			}

			var colArray = listToArray(arguments.columnNames);
			var dataFile = fileOpen(filePath,"append");

			// Loop over query and build csv rows
			for(var i=1; i <= arguments.queryData.recordcount; i++){
				// this individual row
				var thisRow = [];
				// loop over column list
				for(var j=1; j <= arrayLen(colArray); j=j+1){

					var value = replace(arguments.queryData[colArray[j]][i],'"',"'",'all');

					value = '"#value#"'; //let's wrap the whole thing in double quotes to make sure spaces and newlines get preserved

					// create our row
					thisRow[j] = replace( value,',','','all');
				}
				// Append new row to csv output
				buffer.append(JavaCast('string', (ArrayToList(thisRow, arguments.delimiter))));
				if(i mod 1000 EQ 0){
					fileWriteLine(dataFile,buffer.toString());
					buffer.setLength(0);
				}else if (i != arguments.queryData.recordcount){ 
					buffer.append(JavaCast('string', newLine));
				}
			}
			if(buffer.length()){
				fileWriteLine(dataFile,buffer.toString());
				buffer.setLength(0);
			}
			fileClose(dataFile);
		};

		//Lucee 4 can't handle decoding base64 strings unless the length is divisible by 4. You can pad them with equals without changing the result
		public string function luceeSafeBase64Decode(required any base64String){
			var excess = len(base64String)%4;
			if(excess == 0){
				return toString(binaryDecode(base64String,'base64'));
			}
			
			for(var i = 4; i > excess; i--){
				base64String &= '=';
			}

			return toString(binaryDecode(base64String,'base64'));
		}
		
		public any function logApiRequest(required struct rc,  required string requestType, any data = {} ){
	    
		    var content = arguments.rc.apiResponse.content;
	        
	        var apiRequestAudit = getService('hibachiService').newApiRequestAudit();
	        
	        if( structKeyExists(content, 'recordsCount') ){
	            apiRequestAudit.setResultsCount(content.recordsCount);
	        }else {
	            apiRequestAudit.setResultsCount(1);
	        }
	        
	        if( structKeyExists(content, 'collectionConfig')){
	            apiRequestAudit.setCollectionConfig(content.collectionConfig);
	        }
	        
	        if( structKeyExists(content, 'currentPage')){
	            apiRequestAudit.setCurrentPage(content.currentPage);
	        }
	       
	        if(structKeyExists(content, 'pageRecordsShow')){
	            apiRequestAudit.setPageShow(content.pageRecordsShow);
		    }
	        
	        var clientIP = cgi.remote_addr;
	        var clientHeaders = GetHttpRequestData().headers;
	    	if(structKeyExists(clientHeaders,"X-Forwarded-For") ) {
			    clientIP = clientHeaders["X-Forwarded-For"];
	        }
	        apiRequestAudit.setIpAddress(clientIP);
	        
	        var urlEndpoint = cgi.http_host & '' & cgi.path_info;
	        apiRequestAudit.setUrlEndpoint( urlEndpoint );
	        
	        if ( !structIsEmpty(url) ){
	            apiRequestAudit.setUrlQueryString(serializeJson(url));
	        }
	        
	        if ( !structIsEmpty(form) ){
	             apiRequestAudit.setParams( serializeJson(form) );
	        }
	        
	        apiRequestAudit.setStatusCode( getPageContext().getResponse().getStatus() );
	        
	        apiRequestAudit.setRequestType( arguments.requestType);
	        apiRequestAudit.setAccount(getHibachiScope().getAccount());
	        
	        apiRequestAudit = getService("HibachiService").saveApiRequestAudit(apiRequestAudit);
	        
		}
		
		public numeric function getTimeZoneOffsetInSecondsWithDST() {
			var timezoneInfo = GetTimeZoneInfo();
			var timezoneOffsetInSeconds = timezoneInfo.utcTotalOffset ;

 			if ( timezoneInfo.isDSTon) {
				if(!isNull(SERVER.lucee) && Left(SERVER.lucee.version,1) >= 5) {  //XXX DSTOffset is only available since lucee 5

 					timezoneOffsetInSeconds += timezoneInfo.DSTOffset;

 				}else{ //HACK  This only works if you're in the America/NewYork timezone.

 					timezoneOffsetInSeconds += 3600; 
				}
			}

 			return timezoneOffsetInSeconds;
		}

 		public date function getLocalServerDateTimeByUtcEpoch(numeric utcEpoch) {
			//XXX explaination: for "* -1"  ==> https://www.bennadel.com/blog/1595-converting-to-gmt-and-from-gmt-in-coldfusion-for-use-with-http-time-stamps.htm
			var localEpoch = utcEpoch + getTimeZoneOffsetInSecondsWithDST() * -1 ;
			return DateAdd("s", localEpoch, CreateDateTime(1970, 1, 1, 0, 0, 0)); // convert from epoch 
		}
		
    	/**
    	 * Takes a CSV string and convert it to an array of arrays based on the given field delimiter. 
    	 * Line delimiter is assumed to be new line / carriage return related.
    	 * based on https://www.bennadel.com/blog/991-csvtoarray-coldfusion-udf-for-parsing-csv-data-files.htm
    	 * UPDATE https://gist.github.com/bennadel/9760097
    	*/
    	public array function csvStringToArray(string csvString="", string delimiter=",", trimTrailingEmptyLine=true ){

    		/* 
    			Check to see if we need to trimTrailingEmptyLine the data. By default, we are
    			going to pull off any new line and carraige returns that are
    			at the end of the file (we do NOT want to strip spaces or
    			tabs as those are field delimiters).
    		*/
    		if( arguments.trimTrailingEmptyLine ){
    			//  Remove trailing line breaks and carriage returns. 
    			arguments.csvString = reReplace( arguments.csvString, "[\r\n]+$", "", "all" );
    		}

    		//  Make sure the delimiter is just one character. 
    		if( (len( arguments.delimiter ) != 1) ){
    			//  Set the default delimiter value. 
    			arguments.delimiter = ",";
    		}

    		/* 
    			Now, let's define the pattern for parsing the CSV data. We are going to use verbose regular expression 
    			since this is a rather complicated pattern.
    			NOTE: We are using the verbose flag such that we can use 	white space in our regex for readability.
    			
    			"(?x)\G(?:""([^""]*+ (?>""""[^""]*+)* )"" | ([^""\,\r\n]*+)) (\,\r\n?|\n|$)"
    		*/
    		var regEx = ""
    		savecontent variable="regEx"{

    			writeOutput("(?x)");

    			//  Make sure we pick up where we left off. 
    			writeOutput("\G");

    			/* 
    				We are going to start off with a field value since
    				the first thing in our file should be a field (or a completely empty file).
    			*/
    			writeOutput("(?:");
    				//  Quoted value - GROUP 1 
    				writeOutput("""([^""]*+ (?>""""[^""]*+)* )""");
    				writeOutput("|");
    				//  Standard field value - GROUP 2 
    				writeOutput("([^""\#arguments.delimiter#\r\n]*+)");
    			writeOutput(")");

    			//  Delimiter - GROUP 3 
    			writeOutput(
    				"(
    					\#arguments.delimiter# |
    					\r\n? |
    					\n |
    					$
    				)"
    			);
    		};

    		/* 
    			Create a compiled Java regular expression pattern object
    			for the experssion that will be parsing the CSV.
    		*/
    		var pattern = createObject( "java", "java.util.regex.Pattern").compile(javaCast( "string", regEx ) );

    		/* 
    			Now, get the pattern matcher for our target text (the CSV
    			data). This will allows us to iterate over all the tokens
    			in the CSV data for individual evaluation.
    		*/
    		var matcher = pattern.matcher( javaCast("string", arguments.csvString) );

    		/* 
    			Create an array to hold the CSV data. We are going to create an array of arrays in which 
    			each nested array represents a row in the CSV data file. We are going to start off the CSV
    			data with a single row.
    			NOTE: It is impossible to differentiate an empty dataset from a dataset that has one empty row. 
    			As such, we will always have at least one row in our result.
    		*/
    		var csvParsedRows = [ [] ];

    		/* 
    			Here's where the magic is taking place; we are going to use the Java pattern matcher 
    			to iterate over each of the CSV data fields using the regular expression we defined above.
    			Each match will have at least the field value and possibly an optional trailing delimiter.
    		*/
    		while( matcher.find() ){

    			// Next, try to get the qualified field value. If the field was not qualified, this value will be null.
    			var fieldValue = matcher.group( javaCast("int", 1) );
    			/* 
    				Check to see if the value exists in the local scope. 
    				If it doesn't exist, then we want the non-qualified field.
    				If it does exist, then we want to replace any escaped, embedded quotes.
    			*/

    			if( !isNull(fieldValue) ){

    				// The qualified field was found. 
    				// Replace escpaed quotes (two double quotes in a row) with an unescaped double quote.
    				fieldValue = replace( fieldValue, '""', '"', "all" );

    			} else {

    				// No qualified field value was found; as such, let's use the non-qualified field value.
    				fieldValue = matcher.group( javaCast("int", 2) );
    			}

    			// Now that we have our parsed field value, let's add it to the most recently created CSV row collection.
    			arrayAppend( csvParsedRows[arrayLen(csvParsedRows)], fieldValue );

    			/* 
    				Get the delimiter. We know that the delimiter will always be matched, 
    				but in the case that it matched the end of the CSV string, it will not have a length.
    			*/
    			var delimiterGroup = matcher.group( javaCast("int", 3) );

    			/* 
    				Check to see if we found a delimiter that is not the field delimiter (end-of-file delimiter will not have
    				a length). If this is the case, then our delimiter is the line delimiter. 
    				Add a new data array to the CSV data collection.
    			*/
    			if( len(delimiterGroup) && delimiterGroup != arguments.delimiter ){

    				arrayAppend( csvParsedRows, arrayNew( 1 ) );

    			} else if( !len( delimiterGroup ) ) {
    				/* 
    					If our delimiter has no length, it means that we reached the end of the CSV data. 
    					Let's explicitly break out of the loop otherwise we'll get an extra empty space.
    				*/
    				break;
    			}
    		}

    		/* 
    			At this point, our array should contain the parsed contents
    			of the CSV value as an array of arrays. Return the array.
    		*/
    		return csvParsedRows;
    	}
    	
    	
    public string function getSQLfromHQL(required string HQL, required struct hqlParams) {

		var hydratedHQL = arguments.HQL; 
		for(var key in arguments.hqlParams ){
			hydratedHQL = replace(hydratedHQL, ":#key#", "'#arguments.hqlParams[key]#'");
		}
		
		// java magic
		var javaTranslatorFactory = createObject("java", "org.hibernate.hql.ast.ASTQueryTranslatorFactory");
		var javaCollections = createObject("java", "java.util.Collections");
		var javaTranslator = javaTranslatorFactory.createQueryTranslator('', hydratedHQL, javaCollections.EMPTY_MAP, ormGetSessionFactory());
		javaTranslator.compile(javaCollections.EMPTY_MAP, false);
		var sqlStr = javaTranslator.getSQLString();

		// sqlstr = rereplace(sqlstr, "as .*?\d+_\d+_", '', "ALL"); //\sas\s\w+\d+_\d+_,

		return sqlstr;
	}
	
	/**
	 * Method to upload file
	 * @param uploadDirectory
	 * @param fileFormFieldName - name of file type field in form, to get it from POST request
	 * @param allowedMimeType - file types to be allowed for upload
	 * */
	public any function uploadFile( string uploadDirectory, string fileFormFieldName = "uploadFile", string allowedMimeType = "*" ) {
		
		if( this.isS3Path( arguments.uploadDirectory ) ){
			uploadDirectory = this.formatS3Path( arguments.uploadDirectory );
		}
		
		// If the directory where this file is going doesn't exists, then create it
		if(!directoryExists(arguments.uploadDirectory)) {
			directoryCreate(arguments.uploadDirectory);
		}
		
		// Upload the file to temp directory
		var uploadData = fileUpload( getHibachiTempDirectory(), arguments.fileFormFieldName, arguments.allowedMimeType , 'overwrite', 'makeUnique' );
		var fileSize = uploadData.fileSize;
		
		//get max image size
		var maxFileSizeString = getHibachiScope().setting('imageMaxSize');
		var maxFileSize = val(maxFileSizeString) * 1000000;
		
		//check allowed filesize validation
 		if(len(maxFileSizeString) > 0 && fileSize > maxFileSize){
 			return {
 				'success': false,
 				'message': getHibachiScope().rbKey('validate.save.File.fileUpload.maxFileSize')
 			}
 		}
 		
 		//move file to correct location	
 		fileMove("#getHibachiTempDirectory()#/#uploadData.serverFile#", arguments.uploadDirectory);
 		
 		if( this.isS3Path( arguments.uploadDirectory ) ){
 			StoreSetACL( arguments.uploadDirectory, [{group="all", permission="read"}]);
 		}
 		
 		return {
 			'success': true,
 			'filePath': uploadData.serverFile
 		}
	}
	
	/**
	 * Method to delete file from server
	 * @param directoryPath
	 * @param fileName
	 * */
	public void function deleteFileFromPath( string directoryPath, string fileName ) {
		if( this.isS3Path( arguments.directoryPath ) ){
			arguments.directoryPath = this.formatS3Path( arguments.directoryPath );
		}
		
		var finalPath = arguments.directoryPath & arguments.fileName;
		
		if(fileExists( finalPath ) ) {
			fileDelete( finalPath );
		}
	}
	
	public string function prefixListItems( required string theList, required string thePrefix ){
		return ListMap(arguments.theList , function(item){
			return thePrefix & arguments.item; //beware of scope
		});
	}
	
	public array function prefixArrayItems( required struct theArray, required string thePrefix ){
		return arguments.theArray.map( function(item){
			return thePrefix & arguments.item; //beware of arguments scope
		});
	}
	
	public struct function prefixStructKeys( required struct theStruct, required string thePrefix ){
	    var prefixed = {};
	    arguments.theStruct.each( function(key, value){
	        prefixed[ thePrefix & arguments.key] = arguments.value;
	    })
	    return prefixed;
	}
	
	public struct function flattenStruct( required struct original, string delimiter=".", string prefix="" ){
	    var flattened = {};
	    
		var keysArray = arguments.original.keyArray();
		for ( var thisKey in keysArray ) {
		    
		    var nextPrefix = prefix & thisKey;
		    
			if( isArray(arguments.original[thisKey]) ){
				
				var flattenedArray = flattenArray(arguments.original[thisKey], arguments.delimiter, nextPrefix & arguments.delimiter);
				flattened.append(flattenedArray);
				
			} else if ( IsStruct(arguments.original[thisKey]) ) {
				
				var flattenedStruct = flattenStruct(arguments.original[thisKey], arguments.delimiter, nextPrefix & arguments.delimiter);
				flattened.append(flattenedStruct);
				
			} else {
			
				flattened[ nextPrefix ] = arguments.original[thisKey];
			}
		}
		
		return flattened;
	}
	
	public struct function flattenArray( required array original, string delimiter=".", string prefix="" ){
	    var flattened = {};
	    
		for ( var i=1; i<= arguments.original.len(); i++ ){
		    
		    var nextPrefix = arguments.prefix &"["& i &"]";
		    
			if( isArray(arguments.original[i]) ){
				
				var flattenedArray = this.flattenArray(arguments.original[i], arguments.delimiter, nextPrefix & arguments.delimiter);
				flattened.append(flattenedArray);
				
			} else if ( isStruct(arguments.original[i]) ){
				
				var flattenedStruct = this.flattenStruct(arguments.original[i], arguments.delimiter, nextPrefix & arguments.delimiter);
				flattened.append(flattenedStruct);
				
			} else {
			
				flattened[nextPrefix] = arguments.original[i];
			}
		}
		
		return flattened;
	}

	</cfscript>

	<cffunction name="logException" returntype="void" access="public"  output="false">
		<cfargument name="exception" required="true" />

		<!--- All logic in this method is inside of a cftry so that it doesnt cause an exception --->
		<cftry>
			<cflog file="#getApplicationValue('applicationKey')#" text="START EXCEPTION" />
			<cfif structKeyExists(arguments.exception, "detail") and isSimpleValue(arguments.exception.detail)>
				<cflog file="#getApplicationValue('applicationKey')#" text="Detail: #arguments.exception.detail#" />
			</cfif>
			<cfif structKeyExists(arguments.exception, "errNumber") and isSimpleValue(arguments.exception.errNumber)>
				<cflog file="#getApplicationValue('applicationKey')#" text="errNumber: #arguments.exception.errNumber#" />
			</cfif>
			<cfif structKeyExists(arguments.exception, "message") and isSimpleValue(arguments.exception.message)>
				<cflog file="#getApplicationValue('applicationKey')#" text="Message: #arguments.exception.message#" />
			</cfif>
			<cfif structKeyExists(arguments.exception, "stackTrace") and isSimpleValue(arguments.exception.stackTrace)>
				<cflog file="#getApplicationValue('applicationKey')#" text="Stack Trace: #arguments.exception.stackTrace#" />
			</cfif>
			<cflog file="#getApplicationValue('applicationKey')#" text="END EXCEPTION" />
			<cfcatch>
				<cflog file="#getApplicationValue('applicationKey')#" text="Log Exception Error" />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="logMessage" returntype="void" access="public"  output="false">
		<cfargument name="message" default="" />
		<cfargument name="messageType" default="" />
		<cfargument name="messageCode" default="" />
		<cfargument name="templatePath" default="" />
		<cfargument name="logType" default="Information" /><!--- Information  |  Error  |  Fatal  |  Warning | Trace  --->
		<cfargument name="generalLog" type="boolean" default="false" />
		<cfargument name="logPrefix" default="" />

		<cfif getHibachiScope().setting("globalLogMessages") neq "none" and (getHibachiScope().setting("globalLogMessages") eq "detail" or arguments.generalLog)>
			<!--- Set default logPrefix if not explicitly provided --->
			<cfif arguments.logType EQ "Trace">
				<cfif NOT getHibachiScope().hasValue('startTimer')>
					<cfset getHibachiScope().setValue('startTimer', getTickCount()) />
					<cfset getHibachiScope().setValue('lastTimer', getTickCount()) />
				</cfif>
				<cfset var timeSpentSinceFirstMarker = getTickCount() - getHibachiScope().getValue('startTimer') />
				<cfset var timeSpentSinceLastMarker = getTickCount() - getHibachiScope().getValue('lastTimer') />
				<cfset getHibachiScope().setValue('lastTimer', getTickCount()) />
			</cfif>
			
			<cfif not len(arguments.logPrefix)>
				<cfif arguments.generalLog>
					<cfset arguments.logPrefix = "General Log" />
				<cfelse>
					<cfset arguments.logPrefix = "Detail Log" />
				</cfif>
			</cfif>
			
			<cfset var logText = arguments.logPrefix />

			<cfif arguments.logType eq "Trace">
				<cfset logText &= " - [ Time Spent: #timeSpentSinceLastMarker# / #timeSpentSinceFirstMarker# ]" />
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
			<cfif not ListFind("Information,Error,Fatal,Warning,Trace", arguments.logType)>
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
			<cfif hasFormCollectionSyntax(local.thisField) AND !isStruct(arguments.formScope[local.thisField])>

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

	<cffunction name="getCurrentUtcTime" returntype="Numeric"  output="false">
        <!--- 
	        According to https://www.bennadel.com/blog/2428-change-in-coldfusion-date-gettime-method-in-coldfusion-10.htm 
	        getTime() returns the current UTC time independently of server time zone
         --->
        <cfreturn round( now().getTime() / 1000 )>
    </cffunction>
    
    <cffunction name="getTimeByUtc" returntype="any">
    	<cfargument name="utctimestamp" type="numeric"/>
    	<cfreturn dateAdd("s", arguments.utctimestamp, createDateTime(1970, 1, 1, 0, 0, 0))/>
    </cffunction>

    <cffunction name="convertBase64GIFToBase64PDF" output="false">
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

	
	<cffunction name="HMAC_SHA1" returntype="binary" access="private" output="false" hint="NSA SHA-1 Algorithm">
		<cfargument name="signKey" type="string" required="true" />
		<cfargument name="signMessage" type="string" required="true" />

		<cfset var jMsg = JavaCast("string",arguments.signMessage).getBytes("iso-8859-1") />
		<cfset var jKey = JavaCast("string",arguments.signKey).getBytes("iso-8859-1") />
		<cfset var key = createObject("java","javax.crypto.spec.SecretKeySpec") />
		<cfset var mac = createObject("java","javax.crypto.Mac") />

		<cfset key = key.init(jKey,"HmacSHA1") />
		<cfset mac = mac.getInstance(key.getAlgorithm()) />
		<cfset mac.init(key) />
		<cfset mac.update(jMsg) />

		<cfreturn mac.doFinal() />
	</cffunction>

	<cffunction name="HMAC_SHA256" returntype="binary" access="public" output="false">
		<cfargument name="signKey" type="string" required="true" />
		<cfargument name="signMessage" type="string" required="true" />

		<cfset var jMsg = JavaCast("string",arguments.signMessage).getBytes("iso-8859-1") />
		<cfset var jKey = JavaCast("string",arguments.signKey).getBytes("iso-8859-1") />

		<cfset var key = createObject("java","javax.crypto.spec.SecretKeySpec") />
		<cfset var mac = createObject("java","javax.crypto.Mac") />

		<cfset key = key.init(jKey,"HmacSHA256") />

		<cfset mac = mac.getInstance(key.getAlgorithm()) />
		<cfset mac.init(key) />
		<cfset mac.update(jMsg) />

		<cfreturn mac.doFinal() />

	</cffunction>

	<cffunction name="createS3Signature" returntype="string" access="public" output="false">
		<cfargument name="stringToSign" type="string" required="true" />
		<cfargument name="awsSecretAccessKey" type="string" required="true">
		
		<!--- Replace "\n" with "chr(10)" to get a correct digest --->
		<cfset var fixedData = replace(arguments.stringToSign,"\n","#chr(10)#","all")>
		<!--- Calculate the hash of the information --->
		<cfset var digest = HMAC_SHA1(awsSecretAccessKey,fixedData)>
		<!--- fix the returned data to be a proper signature --->
		<cfset var signature = ToBase64("#digest#")>
		
		<cfreturn signature>
	</cffunction>

	<cffunction name="uploadToS3" access="public" output="false" returntype="boolean"
					description="Puts an object into a bucket.">
		<cfargument name="bucketName" type="string" required="true">
		<cfargument name="fileName" type="string" required="true">
		<cfargument name="contentType" type="string" required="true">
		<cfargument name="awsAccessKeyId" type="string" required="true">
		<cfargument name="awsSecretAccessKey" type="string" required="true">
		<cfargument name="uploadDir" type="string" required="false" default="#ExpandPath('./')#">
		<cfargument name="HTTPtimeout" type="numeric" required="false" default="300">
		<cfargument name="cacheControl" type="boolean" required="false" default="true">
		<cfargument name="cacheDays" type="numeric" required="false" default="30">
		<cfargument name="acl" type="string" required="false" default="public-read">
		<cfargument name="storageClass" type="string" required="false" default="STANDARD">
		<cfargument name="keyName" type="string" required="false">
		
		<cfset var versionID = "">
		<cfset var binaryFileData = "">
		<cfset var dateTimeString = GetHTTPTimeString(Now())>
		<cfset var cs = "">
		<cfset var signature = "">
		
		<cfif !structKeyExists(arguments, "keyName") or not compare(arguments.keyName, '')>
			<cfset arguments.keyName = arguments.fileName>
		</cfif>

		<!--- Create a canonical string to send --->
		<cfset cs = "PUT\n\n#arguments.contentType#\n#dateTimeString#\nx-amz-acl:#arguments.acl#\nx-amz-storage-class:#arguments.storageClass#\n/#arguments.bucketName#/#arguments.keyName#">
		
		<cfset signature = createS3Signature(cs,awsSecretAccessKey)>
		 
		<cfif right(arguments.uploadDir, 1) NEQ '/'>
			<cfset arguments.uploadDir &= '/' />
		</cfif>

		<cffile action="readBinary" file="#arguments.uploadDir##arguments.fileName#" variable="binaryFileData">
		
		<cfhttp method="PUT" url="http://s3.amazonaws.com/#arguments.bucketName#/#arguments.keyName#" timeout="#arguments.HTTPtimeout#">
			<cfhttpparam type="header" name="Authorization" value="AWS #arguments.awsAccessKeyId#:#signature#">
			<cfhttpparam type="header" name="Content-Type" value="#arguments.contentType#">
			<cfhttpparam type="header" name="Date" value="#dateTimeString#">
			<cfhttpparam type="header" name="x-amz-acl" value="#arguments.acl#">
			<cfhttpparam type="header" name="x-amz-storage-class" value="#arguments.storageClass#">
			<cfhttpparam type="body" value="#binaryFileData#">
			<cfif arguments.cacheControl>
				<cfhttpparam type="header" name="Cache-Control" value="max-age=2592000">
				<cfhttpparam type="header" name="Expires" value="#DateFormat(now()+arguments.cacheDays,'ddd, dd mmm yyyy')# #TimeFormat(now(),'H:MM:SS')# GMT">
			</cfif>
		</cfhttp>

		<cfreturn !isNull(cfhttp) AND structKeyExists(cfhttp.responseHeader, 'Status_Code') AND cfhttp.responseHeader['Status_Code'] EQ 200>
	</cffunction>


	<cffunction name="getSignedS3ObjectLink" access="public" output="false" returntype="string">
		<cfargument name="bucketName" type="string" required="true">
		<cfargument name="keyName" type="string" required="true">
		<cfargument name="awsAccessKeyId" type="string" required="true">
		<cfargument name="awsSecretAccessKey" type="string" required="true">
		<cfargument name="minutesValid" type="numeric" required="true" default="1">

		<cfset var s3link = "" />
		<cfset var epochTime = dateDiff( "s", DateConvert("utc2Local", "January 1 1970 00:00"), now() ) + (arguments.minutesValid * 60) />
		<cfset var cs = "GET\n\n\n#epochTime#\n/#arguments.bucketName#/#arguments.keyName#" />
		<cfset var signature = createS3Signature(cs,arguments.awsSecretAccessKey)>
		<cfset s3link = "https://#arguments.bucketName#.s3.amazonaws.com/#arguments.keyName#?AWSAccessKeyId=#URLEncodedFormat(arguments.awsAccessKeyId)#&Expires=#epochTime#&Signature=#URLEncodedFormat(signature)#" />
		<cfreturn s3link />

	</cffunction>

	<cffunction name="getClientFileName" returntype="string" output="false" hint="">
	    <cfargument name="fieldName" required="true" type="string" hint="Name of the Form field" />

	    <cfset var tmpPartsArray = Form.getPartsArray() />

	    <cfif IsDefined("tmpPartsArray")>
	        <cfloop array="#tmpPartsArray#" index="local.tmpPart">
	            <cfif local.tmpPart.isFile() AND local.tmpPart.getName() EQ arguments.fieldName>
	                <cfreturn local.tmpPart.getFileName() />
	            </cfif>
	        </cfloop>
	    </cfif>

	    <cfreturn "" />
	</cffunction>

	<cffunction name="formatS3Path" returntype="string" output="false">
		<cfargument name="filePath" required="true" type="string" />
		<cfif find('@', arguments.filePath)>
			<cfreturn arguments.filePath />
		<cfelse>
			<cfreturn replace(arguments.filePath, 's3://', 's3://#getHibachiScope().setting("globalS3AccessKey")#:#getHibachiScope().setting("globalS3SecretAccessKey")#@') />
		</cfif>

	</cffunction>

	<cffunction name="isS3Path" returntype="boolean" output="false">
		<cfargument name="filePath" required="true" type="string" />
		<cfreturn left(arguments.filePath, 5) EQ 's3://' />
	</cffunction>


	<cffunction name="hibachiExpandPath" returntype="string" output="false">
		<cfargument name="filePath" required="true" type="string" />
		<cfif isS3Path(arguments.filePath) >
			<cfreturn formatS3Path(arguments.filePath) />
		<cfelse>
			<cfreturn expandPath(arguments.filePath) />
		</cfif>
	</cffunction>
	<!---check if this is a 32 character id string--->
	<cffunction name="isHibachiUUID" returntype="boolean" output="false">
		<cfargument name="idString" type="any">
		
		<cfif !isValid("string",arguments.idString)>
			<cfreturn false/>
		</cfif>
		
		<cfif len(arguments.idString) neq 32>
			<cfreturn false/>
		</cfif>
		
		<cfset var uuid = left(arguments.idString,8) & '-' & mid(arguments.idString,9,4) & '-' & mid(arguments.idString,13,4) & '-' & right(arguments.idString,16)/>
		<cfreturn isValid('uuid',uuid)/>
	</cffunction>
	
	<!--- Given a total number of strings to generate, and a length for each string, generates a list. --->
	<cffunction name="generateRandomStrings" output="no" returntype="string">
		<cfargument name="length" type="numeric" required="yes">
		<cfargument name="total" type="numeric" required="yes">
		
		
		<!--- Local vars --->
		<cfset var listOfAccessCodes = "">
	    <cfset var j = "" > 
	    <cfloop  index = "j" from = "1" to = "#total#"> 
			<cfset var result="">
			<cfset var i = "" >
			<!--- Create string --->
			<cfloop index="i" from="1" to="#ARGUMENTS.length#">
				<!--- Random character in range A-Z --->
				<cfif i mod 5 eq 0>
					<cfset result= result & chr(randRange(49, 57))>
			    <cfelseif i mod 3 eq 0 and j mod 2 eq 0>
					<cfset result= result & chr(randRange(49, 57))>
				<cfelse>
					<cfset result= result & chr(randRange(65, 90))>    
			    </cfif>
	
			</cfloop>
	
			<cfif listFind(listOfAccessCodes, result) eq 0>
			    <cfset listOfAccessCodes = listAppend(listOfAccessCodes, result)>
			<cfelse>
			    <cfset j = j - 1>    <!--- resets the counter by one if there was a dupe. --->
			</cfif>

	    </cfloop>
		<!--- Return it --->
		<cfreturn listOfAccessCodes>
	</cffunction>
</cfcomponent>
