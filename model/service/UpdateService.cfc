<!---

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

--->
<cfcomponent extends="HibachiService" accessors="true">
	
	<!--- prepare constants and environment variables --->
	<cffunction name="init" returntype="void" >
		<cfscript>
			getEnvironmentVariables();
			
		</cfscript>
	</cffunction>
	
	<cffunction name="getEnvironmentVariables" returntype="void">
		<cfscript>
			variables.lineBreak = getService('HibachiUtilityService').getLineBreakByEnvironment(getApplicationValue("lineBreakStyle"));
			
			variables.paddingCount = 2;
			variables.conditionLineBreak="";
			if(lcase(getApplicationValue("lineBreakStyle")) == 'windows'){
				variables.paddingCount = 3;
				variables.conditionLineBreak=variables.lineBreak;
			}
			if(lcase(getApplicationValue("lineBreakStyle")) == 'mac' || lcase(getApplicationValue("lineBreakStyle")) == 'unix'){
				variables.paddingCount = 0;
				variables.conditionLineBreak=variables.lineBreak;
			}
			
		</cfscript>
	</cffunction>
	
	<cffunction name="update">
		<cfargument name="branch" type="string" default="master">
		<cfargument name="branchType" type="string" default="standard">
		
		<!--- this could take a while... --->
		<cfsetting requesttimeout="600" />
		<cftry>
			<cfset var updateCopyStarted = false />
			<cfset var zipName  = ''/> 		
			<cfset var isZipFromGithub = false/>
			
			<cfif arguments.branchType EQ 'custom'>
				<cfset isZipFromGithub = true />
			</cfif>
			
			<cfif arguments.branch eq 'master'>
				<cfset zipName  = 'slatwall-latest'/> 	
			<cfelseif arguments.branch eq 'hotfix'>
				<cfset zipName = 'slatwall-hotfix'/>	
			<cfelseif arguments.branch eq 'develop'>
				<cfset zipName  = 'slatwall-be'/> 		
			</cfif>
			
			<cfif isZipFromGithub>
				<cfset var downloadURL = "https://github.com/ten24/Slatwall/zipball/#arguments.branch#" />	
			<cfelse>
				<cfset var downloadURL = "https://s3.amazonaws.com/slatwall-releases/#zipName#.zip" />
			</cfif>
			<cfset var downloadHashURL = "https://s3.amazonaws.com/slatwall-releases/#zipName#.md5.txt" />
			<cfset var slatwallRootPath = expandPath("/Slatwall") />
			<cfset var downloadUUID = createUUID() />
			<cfset var downloadFileName = "slatwall-#downloadUUID#.zip" />
			<cfset var downloadHashFileName = "slatwall-#downloadUUID#.md5.txt" />
			<cfset var deleteDestinationContentExclusionList = '/.git,/apps,/integrationServices,/custom,/WEB-INF,/.project,/setting.xml,/.rewriterule,/.htaccess,/web.config,/.settings,/.gitignore,/CODEOWNERS' />
			<cfset var copyContentExclusionList = "CODEOWNERS" />
			<cfset var slatwallDirectoryList = "" />

			<!--- If the meta directory exists, and it hasn't been dismissed then we want to delete without user action --->
			<cfif getMetaFolderExistsWithoutDismissalFlag()>
				<cfset removeMeta() />
			</cfif>

			<!--- if the meta directory doesn't exist, add it to the exclusion list--->
			<cfif !getMetaFolderExistsFlag()>
				<cfset copyContentExclusionList = ListAppend(copyContentExclusionList, "meta") />
			</cfif>

			<!--- before we do anything, make a backup --->
			<cfdirectory action="list" directory="#slatwallRootPath#" name="slatwallDirectoryList">
			<cfzip action="zip" file="#getTempDirectory()#slatwall_bak.zip" recurse="yes" overwrite="yes" source="#slatwallRootPath#">
				<cfloop query="slatwallDirectoryList">
					<cfif not listFindNoCase("WEB-INF,.project,setting.xml", slatwallDirectoryList.name)>
						<cfif slatwallDirectoryList.type eq "File">
							<cfzipparam source="#slatwallDirectoryList.name#"  />
						</cfif>
					</cfif>
				</cfloop>
			</cfzip>

			<!--- start download of zip & hash --->
			<cfhttp url="#downloadURL#" method="get" path="#getTempDirectory()#" file="#downloadFileName#" throwonerror="true" />
			<cfif !isZipFromGithub>
				<cfhttp url="#downloadHashURL#" method="get" path="#getTempDirectory()#" file="#downloadHashFileName#" throwonerror="true" />
				<!--- Get the MD5 hash of the downloaded file --->
				<cfset var downloadedZipHash = hash(fileReadBinary("#getTempDirectory()##downloadFileName#"), "MD5") />
				<cfset var hashFileValue = listFirst(fileRead("#getTempDirectory()##downloadHashFileName#"), " ") />
				<cfif (downloadedZipHash eq hashFileValue)>
					<!--- now read and unzip the downloaded file --->
					<cfset var dirList = "" />
					<cfset var unzipDirectoryName = "#getTempDirectory()#"&zipName/>
					<cfset directoryCreate(unzipDirectoryName)/>
					<cfzip action="unzip" destination="#unzipDirectoryName#" file="#getTempDirectory()##downloadFileName#" >
					<cfzip action="list" file="#getTempDirectory()##downloadFileName#" name="dirList" >
					<cfset var sourcePath = unzipDirectoryName />
					<cfif fileExists( "#slatwallRootPath#/custom/system/lastFullUpdate.txt.cfm" )>
						<cffile action="delete" file="#slatwallRootPath#/custom/system/lastFullUpdate.txt.cfm" >
					</cfif>
					<cfset updateCopyStarted = true />
					
					
					<cfset getHibachiUtilityService().duplicateDirectory(source=sourcePath, destination=slatwallRootPath, overwrite=true, recurse=true, copyContentExclusionList=copyContentExclusionList, deleteDestinationContent=true, deleteDestinationContentExclusionList=deleteDestinationContentExclusionList ) />
					<!--- Delete .zip file and unzipped folder --->
					<cffile action="delete" file="#getTempDirectory()##downloadFileName#" >
					<cfdirectory action="delete" directory="#sourcePath#" recurse="true">
					<cfset updateCMSApplications()>
				</cfif>
			<cfelseif isZipFromGitHub>
				<cfset var dirList = "" />
				<cfzip action="unzip" destination="#getTempDirectory()#" file="#getTempDirectory()##downloadFileName#" >
				<cfzip action="list" file="#getTempDirectory()##downloadFileName#" name="dirList" >
				<cfset var sourcePath = getTempDirectory() & "#listFirst(dirList.name[1],'/')#" />
				<cfif fileExists( "#slatwallRootPath#/custom/system/lastFullUpdate.txt.cfm" )>
					<cffile action="delete" file="#slatwallRootPath#/custom/system/lastFullUpdate.txt.cfm" >
				</cfif>
				<cfset updateCopyStarted = true /> 
				<cfset getHibachiUtilityService().duplicateDirectory(source=sourcePath, destination=slatwallRootPath, overwrite=true, recurse=true, copyContentExclusionList=copyContentExclusionList, deleteDestinationContent=true, deleteDestinationContentExclusionList=deleteDestinationContentExclusionList ) />
			
				<!--- Delete .zip file and unzipped folder --->
				<cffile action="delete" file="#getTempDirectory()##downloadFileName#" >
				<cfdirectory action="delete" directory="#sourcePath#" recurse="true">
				<cfset updateCMSApplications()>
			</cfif>
			
			<!--- if there is any error during update, restore the old files and throw the error --->
			<cfcatch type="any">
				<cfif updateCopyStarted>
					<cfzip action="unzip" destination="#slatwallRootPath#" file="#getTempDirectory()#slatwall_bak.zip" >
				</cfif>
				<cfset logHibachiException(cfcatch) />
				<cfset getHibachiScope().showMessageKey('admin.main.update.unexpected_error') />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="updateAttributeIsMigratedFlagByAttributeID" >
		<cfargument name="attributeID" type="string" required="true"/>
		<cfargument name="isMigratedFlag" type="boolean" required="true"/>
		<cfquery>
			UPDATE swAttribute
			SET isMigratedFlag = #arguments.isMigratedFlag#
			WHERE attributeID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.attributeID#" /> 
		</cfquery>
	</cffunction>

	<cffunction name="updateCMSApplications">
		<!--- Overwrite all CMS Application.cfc's with the latest from the skeletonApp --->
		<cfif getService('settingService').getSettingValue('globalDeploySitesAndApplicationsOnUpdate')>
			<cfset var apps = this.getAppSmartList().getRecords()>
			<cfloop array="#apps#" index="local.app">
				<cfset getService('appService').updateCMSApp(app)>
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="runScripts">
		<cfset var scripts = this.listUpdateScriptOrderByLoadOrder() />
		<cfloop array="#scripts#" index="local.script">
			<cfset runScript(local.script)/>
		</cfloop>
	</cffunction>
	
	<cffunction name="runScript">
		<cfargument name="script" type="any"/>
		<cfif isNull(arguments.script.getSuccessfulExecutionCount())>
			<cfset arguments.script.setSuccessfulExecutionCount(0) />
		</cfif>
		<cfif isNull(arguments.script.getExecutionCount())>
			<cfset arguments.script.setExecutionCount(0) />
		</cfif>
		<!--- Run the script if never ran successfully or success count < max count ---->
		<cfif isNull(arguments.script.getMaxExecutionCount()) OR arguments.script.getSuccessfulExecutionCount() EQ 0 OR arguments.script.getSuccessfulExecutionCount() LT arguments.script.getMaxExecutionCount()>
			<!---- try to run the script --->
			<cftry>
				<!--- if it's a database script look for db specific file --->
				<cfif findNoCase("database/",arguments.script.getScriptPath())>
					<cfset var dbSpecificFileName = replaceNoCase(arguments.script.getScriptPath(),".cfm",".#getApplicationValue("databaseType")#.cfm") />
					<cfif fileExists(expandPath("/Slatwall/config/scripts/#dbSpecificFileName#"))>
						<cfinclude template="#getHibachiScope().getBaseURL()#/config/scripts/#dbSpecificFileName#" />
					<cfelseif fileExists(expandPath("/Slatwall/config/scripts/#arguments.script.getScriptPath()#"))>
						<cfinclude template="#getHibachiScope().getBaseURL()#/config/scripts/#arguments.script.getScriptPath()#" />
					<cfelse>
						<cfthrow message="update script file doesn't exist #getHibachiScope().getBaseURL()#/config/scripts/#arguments.script.getScriptPath()#" />
					</cfif>
				</cfif>
				<cfset arguments.script.setSuccessfulExecutionCount(arguments.script.getSuccessfulExecutionCount()+1) />
				<cfcatch>
					<!--- failed, let's log this execution count --->
					<cfset arguments.script.setExecutionCount(arguments.script.getExecutionCount()+1) />
					<cfset arguments.script.setUpdateScriptException(cfcatch)/>
				</cfcatch>
			</cftry>
			<cfset arguments.script.setLastExecutedDateTime(now()) />
			<cfset getDao('HibachiDao').save(arguments.script) />
			<cfset getDao('HibachiDao').flushORMSession()/>
		</cfif>
	</cffunction>

	<cffunction name="getAvailableVersions">
		<cfset var masterVersion = "" />
		<cfset var developVersion = "" />
		<cfset var hotfixVersion = "" />
		<cfset var versions = {} />

		<cfhttp method="get" url="https://raw.github.com/ten24/Slatwall/master/version.txt.cfm" result="masterVersion">
		<cfhttp method="get" url="https://raw.github.com/ten24/Slatwall/hotfix/version.txt.cfm" result="hotfixVersion">
		<cfhttp method="get" url="https://raw.github.com/ten24/Slatwall/develop/version.txt.cfm" result="developVersion">

		<cfset versions.master = trim(masterVersion.filecontent) />
		<cfset versions.hotfix = trim(hotfixVersion.filecontent) />
		<cfset versions.develop = trim(developVersion.filecontent) />

		<cfreturn versions />
	</cffunction>

	<cffunction name='getMetaFolderExistsWithoutDismissalFlag'>
		<cfreturn directoryExists( expandPath('/Slatwall/meta') ) && !fileExists( expandPath('/Slatwall/custom/system/metaDismiss.txt.cfm') ) />
	</cffunction>

	<cffunction name='removeMeta'>
		<cfset directoryDelete( expandPath('/Slatwall/meta'), true ) />
	</cffunction>

	<cffunction name='dismissMeta'>
		<cfset fileWrite( expandPath('/Slatwall/custom/system') & '/metaDismiss.txt.cfm', now() ) />
	</cffunction>

	<cffunction name="getMetaFolderExistsFlag">
		<cfreturn directoryExists( expandPath('/Slatwall/meta') ) >
	</cffunction>
	
	<cffunction name="migrateAttributeToCustomProperty" returntype="void">
		<cfargument name="entityName" type="string" required="true"/>
		<cfargument name="customPropertyName" type="string" required="true"/>
		<cfargument name="overrideDataFlag" type="boolean" default="false" >
		
		<cfset var entityMetaData = getEntityMetaData(arguments.entityName)/>
		<cfset var primaryIDName = getPrimaryIDColumnNameByEntityName(arguments.entityName)/>
		
		<cfif getApplicationValue("databaseType") eq "MySQL">
			
			<cfquery name="local.attributeToCustomProperty">
				UPDATE #entityMetaData.table# p
				
				INNER JOIN SwAttributeValue av
				
				ON p.#primaryIDName# = av.#primaryIDName#
				
				INNER JOIN SwAttribute a
				
				ON av.attributeID = a.attributeID
				
				SET p.#arguments.customPropertyName# = av.attributeValue
				
				WHERE a.attributeCode = '#arguments.customPropertyName#'
				
				<cfif NOT overrideDataFlag >
					AND p.#arguments.customPropertyName# IS NULL
				</cfif>
				
			</cfquery>
		<cfelse>
			<cfquery name="local.attributeToCustomProperty">
				UPDATE p
	
				SET p.#arguments.customPropertyName# = av.attributeValue
				
				FROM #entityMetaData.table# p
				
				INNER JOIN SwAttributeValue av
				
				ON p.#primaryIDName# = av.#primaryIDName#
				
				INNER JOIN SwAttribute a
				
				ON av.attributeID = a.attributeID 
				
				WHERE a.attributeCode = '#arguments.customPropertyName#'
				
				<cfif NOT overrideDataFlag >
					AND p.#arguments.customPropertyName# IS NULL
				</cfif>
				
			</cfquery>
		</cfif>
	</cffunction>
	

	<cfscript>
	
	public any function migrateAttributeValuesToCustomProperties(){
			//let's get all attributes flagged to become custom properties
			var attributeDataQuery = getSlatwallScope().getDAO('attributeDAO').getAttributeDataQueryByCustomPropertyFlag();
			var rbKeyValuePairStrings = '';
			var path = expandPath('/#getApplicationKey()#') & '/custom/config/resourceBundles/en.properties';
			
			if(fileExists(path)){
				var rbKeysFileRead = FileRead(path);
				var rbKeysFileAppend = FileOpen(path,"append");
			}
			
			for(var attribute in attributeDataQuery){
				//if we have never done this before...
				if(len(attribute['isMigratedFlag']) && !attribute['isMigratedFlag']){
					//migrate values
					migrateAttributeToCustomProperty(entityName=attribute['attributeSetObject'],customPropertyName=attribute['attributeCode']);
					updateAttributeIsMigratedFlagByAttributeID(attribute['attributeID'],true);
				}
				//if we don't have the rbKey in the file we read
				var rbKey = 'entity.' & attribute['attributeSetObject'] & '.' & attribute['attributeCode'];
				if(!isNull(rbKeysFileRead) && !findNoCase(rbKey,rbKeysFileRead)){
					rbKeyValuePairStrings = rbKeyValuePairStrings & getRbKeyValuePairByAttribute(attribute);
				}
			}
			//if we have new rbkeys to add
			if(len(rbKeyValuePairStrings) && !isNull(rbKeysFileAppend)){
				//write to the .properties file
				FileWriteLine(rbKeysFileAppend, rbKeyValuePairStrings); 
				//recreate the JSON file
				getService("HibachiJSONService").createJson();
				
				FileClose(rbKeysFileAppend);
			}
		}
		
		public string function getRbKeyValuePairByAttribute(required any attribute){
			var newLine = (chr(13) & chr(10));
			return newLine & 'entity.' & attribute['attributeSetObject'] & '.' & attribute['attributeCode'] & '=' & attribute['attributeName'];
		}
		
		public boolean function updateEntitiesWithCustomProperties(){
				var path = "#ExpandPath('/Slatwall/')#" & "model/entity";
				var pathCustom = "#ExpandPath('/Slatwall/')#" & "custom/model/entity";

				var directoryList = directoryList(path, false, "path", "*.cfc", "directory ASC");
				var directoryListByName = directoryList(path, false, "name", "*.cfc", "directory ASC");
				var directoryListCustom = directoryList(pathCustom, false, "name", "*.cfc", "directory ASC");
				var directories = ArrayToList(directoryList);

				//find which items have an override in the custom folder or attributes to be copied
				var attributeDataQuery = getSlatwallScope().getDAO('attributeDAO').getAttributeDataQueryByCustomPropertyFlag();

				var matches = 0;
				var matchArray = [];
				var queryService = new query();
				var entityNameToAttributeDataQueryHash = {};

				for (var fileName in directoryListByName){

					var entityName = listFirst(fileName,".");
					queryService.setName("queryAttributeDataQuery");
					queryService.setDBType("query");
					queryService.setAttributes(sourceQuery=attributeDataQuery);
					queryService.clearParams();
					queryService.addParam(name="entityNameParam",value="#entityName#",cfsqltype="cf_sql_varchar");
					var attributeDataQueryByEntity = queryService.execute(sql="SELECT * from sourceQuery where attributeSetObject = :entityNameParam").getResult();
					if(attributeDataQueryByEntity.recordCount >= 1){
						matches+=1;
						entityNameToAttributeDataQueryHash[entityName] = attributeDataQueryByEntity;
						ArrayAppend(matchArray,fileName);
					}
				}

				for (var fileName in directoryListCustom){

					var result = ListFind(ArrayToList(directoryListByName), fileName);

					if (result >= 1){
						matches+=1;
						if(!ArrayFind(matchArray,fileName)){
							ArrayAppend(matchArray, fileName);
						}
					}
				}
				if (matches <= 0){
					return true;
				}

			//iterate over overrides and merge them
			for (var match in matchArray) {
				var entityName = listFirst(match,".");
				if(structKeyExists(entityNameToAttributeDataQueryHash,entityName)){
					var results = mergeProperties("#match#",entityNameToAttributeDataQueryHash[entityName]);
					filewrite(path & '/#match#', results);
				} else {
					var results = mergeProperties("#match#");
					filewrite(path & '/#match#', results);
				}
			}
			return true;
		}

		public void function checkIfCustomPropertiesExistInBase(required any customMeta, required any baseMeta){
			// check duplicate properties and if there is a duplicate then write it to log
			if(structKeyExists(arguments.customMeta,'properties')){
				for(var i=1; i <= arraylen(arguments.customMeta.properties); i++) {
					for(var j=1; j <= arraylen(arguments.baseMeta.properties); j++ ) {
						if(arguments.baseMeta.properties[j].name == arguments.customMeta.properties[i].name) {
							writeLog(
								file="Slatwall",
								text="Custom property names can't be same as core property names: #arguments.customMeta.properties[i].name#"
							);
						}
					}
				}
			}
		}
		
		public string function mergeAttributesIntoPropertyString(required any coreEntityParser, required string propertyString, required string entityName, query attributeDataQueryByEntity){
			var returnString = arguments.propertyString;
			for(var attributeData in arguments.attributeDataQueryByEntity){
				var attributePropertyString = arguments.coreEntityParser.getPropertyStringByAttributeData(attributeData);
				returnString = returnString & attributePropertyString;
			}
			return returnString;
		}

		public any function mergeEntityParsers(required any coreEntityParser, required any customEntityParser, boolean purgeCustomProperties=false, query attributeDataQueryByEntity){

			var entityName = arguments.customEntityParser.getEntityName();

			var conditionalLineBreak = variables.conditionLineBreak;
			
			if(lcase(getApplicationValue("lineBreakStyle")) == 'windows'){
				conditionalLineBreak = "";
			}
			var newContent = "";
			//add properties

			var propertyString = '';
			if(
				!isNull(arguments.customEntityParser.getFileContent())
				|| !isNull(arguments.customEntityParser.getFilePath())
			){
				PropertyString = arguments.customEntityParser.getPropertyString();
			}
			if(!isNull(arguments.attributeDataQueryByEntity)){
				propertyString = mergeAttributesIntoPropertyString(arguments.coreEntityParser,propertyString,entityName,arguments.attributeDataQueryByEntity);
			}
			if(len(PropertyString)){
				
				if(arguments.coreEntityParser.hasCustomProperties() && arguments.purgeCustomProperties){
					arguments.coreEntityParser.setFileContent(replace(arguments.coreEntityParser.getFileContent(),arguments.coreEntityParser.getCustomPropertyContent(),''));
				}
				
				if(arguments.coreEntityParser.hasCustomProperties()){
				
					var customPropertyStartPos = arguments.coreEntityParser.getCustomPropertyStartPosition();
					var customPropertyEndPos = arguments.coreEntityParser.getCustomPropertyEndPosition();
					
					if(!arguments.coreEntityParser.getCustomPropertyContent() CONTAINS PropertyString){
						var contentBeforeCustomPropertiesStart = left(arguments.coreEntityParser.getFileContent(),arguments.coreEntityParser.getCustomPropertyContentStartPosition()-1);
						var contentAfterCustomPropertiesStart = mid(arguments.coreEntityParser.getFileContent(),arguments.coreEntityParser.getCustomPropertyContentEndPosition(), (len(arguments.coreEntityParser.getFileContent()) - arguments.coreEntityParser.getCustomPropertyContentEndPosition())+1);
						var combinedPropertyContent = coreEntityParser.getCustomPropertyContent()&variables.lineBreak&PropertyString;
						var customPropertyContent = contentBeforeCustomPropertiesStart & combinedPropertyContent & contentAfterCustomPropertiesStart;
						arguments.coreEntityParser.setFileContent(customPropertyContent);	
					}
				}else{
				
					var customPropertyString = arguments.customEntityParser.getCustomPropertyStringByPropertyString(PropertyString);
					newContent = 	left(arguments.coreEntityParser.getFileContent(),arguments.coreEntityParser.getPropertyEndPos()-variables.paddingCount) 
									& conditionalLineBreak & chr(9) & customPropertyString & chr(9) & 
									right(arguments.coreEntityParser.getFileContent(),len(arguments.coreEntityParser.getFileContent()) -arguments.coreEntityParser.getPropertyEndPos())
					;
					arguments.coreEntityParser.setFileContent(newContent);
				} 
			}
			//add functions
			var functionString = '';
			if(
				!isNull(arguments.customEntityParser.getFileContent())
				|| !isNull(arguments.customEntityParser.getFilePath())
			){
				functionString = arguments.customEntityParser.getFunctionString();
			}
			if(len(functionString)){
				if(arguments.purgeCustomProperties && arguments.coreEntityParser.hasCustomFunctions()){
					arguments.coreEntityParser.setFileContent(replace(arguments.coreEntityParser.getFileContent(),arguments.coreEntityParser.getCustomFunctionContent(),''));	
				}	
				
				if(arguments.coreEntityParser.hasCustomFunctions()){
					var customFunctionStartPos = arguments.coreEntityParser.getCustomFunctionStartPosition();
					var customFunctionEndPos = arguments.coreEntityParser.getCustomFunctionEndPosition();
					if(!arguments.coreEntityParser.getCustomFunctionContent() CONTAINS functionString){
						var contentBeforeCustomFunctionsStart = left(arguments.coreEntityParser.getFileContent(),arguments.coreEntityParser.getCustomFunctionContentStartPosition()-1);
						var contentAfterCustomFunctionsStart = mid(arguments.coreEntityParser.getFileContent(),arguments.coreEntityParser.getCustomFunctionContentEndPosition(), (len(arguments.coreEntityParser.getFileContent()) - arguments.coreEntityParser.getCustomPropertyContentEndPosition())+1);
						var combinedFunctionContent = coreEntityParser.getCustomFunctionContent()&variables.lineBreak&customEntityParser.getFunctionString();
						var customFunctionContent = contentBeforeCustomFunctionsStart & combinedFunctionContent & contentAfterCustomFunctionsStart;
						arguments.coreEntityParser.setFileContent(customFunctionContent);	
					}
				}else{
					var customFunctionString = arguments.customEntityParser.getCustomFunctionStringByFunctionString();

					newContent = left(arguments.coreEntityParser.getFileContent(),arguments.coreEntityParser.getComponentEndPos()-(variables.paddingCount?variables.paddingCount-1:0)) & conditionalLineBreak & customFunctionString & '}';
					arguments.coreEntityParser.setFileContent(newContent);
				}
			}
		}
	
		public any function mergeProperties(string filename,query attributeDataQueryByEntity){
	
			var entityName = listFirst(filename,".");

			var customEntityParser = getTransient('HibachiEntityParser');
			customEntityParser.setFilePath("custom/model/entity/#arguments.filename#");
			customEntityParser.setEntityName(entityName);
			
			//declared file paths
			var coreEntityParser = getTransient('HibachiEntityParser');
			coreEntityParser.setFilePath("model/entity/#arguments.filename#");
			coreEntityParser.setEntityName(entityName);
			if(!isNull(arguments.attributeDataQueryByEntity)){
				mergeEntityParsers(coreEntityParser,customEntityParser,true,arguments.attributeDataQueryByEntity);
			} else {
			mergeEntityParsers(coreEntityParser,customEntityParser,true);
			}
			return coreEntityParser.getFileContent();
		
		}
	</cfscript>
	 
</cfcomponent>
