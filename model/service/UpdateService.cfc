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

	<cffunction name="update">
		<cfargument name="branch" type="string" default="master">
		
		<!--- this could take a while... --->
		<cfsetting requesttimeout="600" />
		<cftry>
			<cfset var updateCopyStarted = false />
			<cfset var zipName  = ''/> 		
			<cfset var isZipFromGithub = false/>
			<cfif arguments.branch eq 'master'>
				<cfset zipName  = 'slatwall-latest'/> 	
			<cfelseif arguments.branch eq 'hotfix'>
				<cfset zipName = 'slatwall-hotfix'/>	
			<cfelseif arguments.branch eq 'develop'>
				<cfset zipName  = 'slatwall-be'/> 		
			<cfelse>
				<cfset isZipFromGithub = true/>
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
			<cfset var deleteDestinationContentExclusionList = '/.git,/apps,/integrationServices,/custom,/WEB-INF,/.project,/setting.xml,/.htaccess,/web.config,/.settings,/.gitignore' />
			<cfset var copyContentExclusionList = "" />
			<cfset var slatwallDirectoryList = "" />

			<!--- If the meta directory exists, and it hasn't been dismissed then we want to delete without user action --->
			<cfif getMetaFolderExistsWithoutDismissalFlag()>
				<cfset removeMeta() />
			</cfif>

			<!--- if the meta directory doesn't exist, add it to the exclusion list--->
			<cfif !getMetaFolderExistsFlag()>
				<cfset copyContentExclusionList = "meta" />
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
					<cfif fileExists( "#slatwallRootPath#/custom/config/lastFullUpdate.txt.cfm" )>
						<cffile action="delete" file="#slatwallRootPath#/custom/config/lastFullUpdate.txt.cfm" >
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
				<cfif fileExists( "#slatwallRootPath#/custom/config/lastFullUpdate.txt.cfm" )>
					<cffile action="delete" file="#slatwallRootPath#/custom/config/lastFullUpdate.txt.cfm" >
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

	<cffunction name="updateCMSApplications">
		<!--- Overwrite all CMS Application.cfc's with the latest from the skeletonApp --->
		<cfset var apps = this.getAppSmartList().getRecords()>
		<cfloop array="#apps#" index="local.app">
			<cfset getService('appService').updateCMSApp(app)>
		</cfloop>
	</cffunction>

	<cffunction name="runScripts">
		<cfset var scripts = this.listUpdateScriptOrderByLoadOrder() />
		<cfloop array="#scripts#" index="local.script">
			<cfif isNull(script.getSuccessfulExecutionCount())>
				<cfset script.setSuccessfulExecutionCount(0) />
			</cfif>
			<cfif isNull(script.getExecutionCount())>
				<cfset script.setExecutionCount(0) />
			</cfif>
			<!--- Run the script if never ran successfully or success count < max count ---->
			<cfif isNull(script.getMaxExecutionCount()) OR script.getSuccessfulExecutionCount() EQ 0 OR script.getSuccessfulExecutionCount() LT script.getMaxExecutionCount()>
				<!---- try to run the script --->
				<cftry>
					<!--- if it's a database script look for db specific file --->
					<cfif findNoCase("database/",script.getScriptPath())>
						<cfset var dbSpecificFileName = replaceNoCase(script.getScriptPath(),".cfm",".#getApplicationValue("databaseType")#.cfm") />
						<cfif fileExists(expandPath("/Slatwall/config/scripts/#dbSpecificFileName#"))>
							<cfinclude template="#getHibachiScope().getBaseURL()#/config/scripts/#dbSpecificFileName#" />
						<cfelseif fileExists(expandPath("/Slatwall/config/scripts/#script.getScriptPath()#"))>
							<cfinclude template="#getHibachiScope().getBaseURL()#/config/scripts/#script.getScriptPath()#" />
						<cfelse>
							<cfthrow message="update script file doesn't exist" />
						</cfif>
					</cfif>
					<cfset script.setSuccessfulExecutionCount(script.getSuccessfulExecutionCount()+1) />
					<cfcatch>
						<!--- failed, let's log this execution count --->
						<cfset script.setExecutionCount(script.getExecutionCount()+1) />
					</cfcatch>
				</cftry>
				<cfset script.setLastExecutedDateTime(now()) />
				<cfset this.saveUpdateScript(script) />
			</cfif>
		</cfloop>
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
		<cfreturn directoryExists( expandPath('/Slatwall/meta') ) && !fileExists( expandPath('/Slatwall/custom/config/metaDismiss.txt.cfm') ) />
	</cffunction>

	<cffunction name='removeMeta'>
		<cfset directoryDelete( expandPath('/Slatwall/meta'), true ) />
	</cffunction>

	<cffunction name='dismissMeta'>
		<cfset fileWrite( expandPath('/Slatwall/custom/config') & '/metaDismiss.txt.cfm', now() ) />
	</cffunction>

	<cffunction name="getMetaFolderExistsFlag">
		<cfreturn directoryExists( expandPath('/Slatwall/meta') ) >
	</cffunction>
	<cfscript>
		 public boolean function updateEntitiesWithCustomProperties(){
			try{
				var path = "#ExpandPath('/Slatwall/')#" & "model/entity";
				var pathCustom = "#ExpandPath('/Slatwall/')#" & "custom/model/entity";
				var compiledPath = "#ExpandPath('/Slatwall/')#" & "model/entity";

				var directoryList = directoryList(path, false, "path", "*.cfc", "directory ASC");
				var directoryListByName = directoryList(path, false, "name", "*.cfc", "directory ASC");
				var directoryListCustom = directoryList(pathCustom, false, "name", "*.cfc", "directory ASC");
				var directories = ArrayToList(directoryList);

				//find which items have an override in the custom folder
				var matches = 0;
				var matchArray = [];
				for (var fileName in directoryListCustom){

					var result = ListFind(ArrayToList(directoryListByName), fileName);
					if (result >= 1){
						matches+=1;
						ArrayAppend(matchArray, fileName);
					}
				}
				if (matches <= 0){
					return true;
				}

				//iterate over overrides and merge them
				for (var match in matchArray){
					var results = mergeProperties("#match#");
					filewrite(compiledPath & '/#match#',results);
				}
				return true;
			}catch(any e){
				writeLog(file="Slatwall", text="Error reading from the file system while updating properties: #e#");
				return false;
			}
			return true;
		}
	</cfscript>
	<cffunction name="migrateAttributeToCustomProperty" returntype="void">
		<cfargument name="entityName"/>
		<cfargument name="customPropertyName"/>
		
		<cfset var entityMetaData = getEntityMetaData(arguments.entityName)/>
		<cfset var primaryIDName = getPrimaryIDPropertyNameByEntityName(arguments.entityName)/>
		
		<cfquery name="local.attributeToCustomProperty">
			UPDATE p

			SET p.#arguments.customPropertyName# = av.attributeValue
			
			FROM #entityMetaData.table# p
			
			INNER JOIN SwAttributeValue av
			
			ON p.#primaryIDName# = av.#primaryIDName#
			
			INNER JOIN SwAttribute a
			
			ON av.attributeID = a.attributeID 
			
			WHERE a.attributeCode = '#arguments.customPropertyName#'
		</cfquery>
	</cffunction>
	
	<cfscript>
		public any function mergeProperties(string filename){ 
			var lineBreak = getHibachiUtilityService().getLineBreakByEnvironment(getApplicationValue("lineBreakStyle"));
			var paddingCount = 2;
			var conditionalLineBreak="";
			if(lcase(getApplicationValue("lineBreakStyle")) == 'windows'){
				paddingCount = 3;
				conditionalLineBreak=lineBreak;
			}
			if(lcase(getApplicationValue("lineBreakStyle")) == 'mac'){
				paddingCount = 3;
				conditionalLineBreak=lineBreak;
			}
			
			//declared file paths
			var filePath =  "model/entity/#arguments.fileName#";
			var customFilePath =  "custom/model/entity/#arguments.fileName#";
		    //declared component paths
		    var fileComponentPath = left(filePath, len(filePath)-4);
		    fileComponentPath = replace(fileComponentPath, "/", ".", "All");
			var customFileComponentPath = left(customFilePath, len(customFilePath)-4);
		    customFileComponentPath = replace(customFileComponentPath, "/", ".", "All");

			var baseMeta = getComponentMetaData(fileComponentPath);
			var customMeta = getComponentMetaData(customFileComponentPath);

			//Grab the contents of the files and figure our the properties.
			var fileContent = ReReplace(fileRead(expandPath(filePath)),'\r','','All');

			//declared custom strings
			
			var customPropertyBeginString = '//CUSTOM PROPERTIES BEGIN';
			var customPropertyEndString = '//CUSTOM PROPERTIES END';
			var customFunctionBeginString = chr(9) &'//CUSTOM FUNCTIONS BEGIN';
			var customFunctionEndString = '//CUSTOM FUNCTIONS END';
			//if they already exists, then remove the custom properties and custom functions
			if(findNoCase(customPropertyBeginString, fileContent)){
				var customPropertyStartPos = findNoCase(chr(9)&customPropertyBeginString, fileContent);
				var customPropertyEndPos = findNoCase(customPropertyEndString, fileContent) + len(customPropertyEndString);
				fileContent = left(fileContent,customPropertyStartPos-1) & mid(fileContent,customPropertyEndPos, (len(fileContent) - customPropertyEndPos)+1);
				if(lcase(getApplicationValue("lineBreakStyle")) == 'windows'){
					conditionalLineBreak = "";
				}
			}

			if(findNoCase(customFunctionBeginString, fileContent)){
				var customFunctionStartPos = findNoCase(customFunctionBeginString, fileContent);
				var customFunctionEndPos = findNoCase(customFunctionEndString, fileContent) + len(customFunctionEndString);
				fileContent = left(fileContent,customFunctionStartPos-1) & mid(fileContent,customFunctionEndPos, abs(len(fileContent) - customFunctionEndPos) + 1);
				if(lcase(getApplicationValue("lineBreakStyle")) == 'windows'){
					conditionalLineBreak = "";
				}
			}
			
			var customFileContent = ReReplace(fileRead(expandPath(customFilePath)),'\r','','All') ;

			// check duplicate properties and if there is a duplicate then write it to log
			if(structKeyExists(customMeta,'properties')){
				for(var i=1; i <= arraylen(customMeta.properties); i++) {
					for(var j=1; j <= arraylen(baseMeta.properties); j++ ) {
						if(baseMeta.properties[j].name == customMeta.properties[i].name) {
							writeLog(
								file="Slatwall",
								text="Custom property names can't be same as core property names"
							);
						}
					}
				}
			}

			//declare custom positions
			var propertyStartPos = findNoCase("property name=", customFileContent) ;
			var privateFunctionLineStartPos = reFindNoCase('\private[^"].*function.*\(.*\)',customFileContent) ;
			var publicFunctionLineStartPos = reFindNoCase('\public[^"].*function.*\(.*\)',customFileContent) ;

			var functionLineStartPos = 0;
			if(privateFunctionLineStartPos && publicFunctionLineStartPos){
				if(privateFunctionLineStartPos > publicFunctionLineStartPos){
					functionLineStartPos = publicFunctionLineStartPos;
				}else{
					functionLineStartPos = privateFunctionLineStartPos;
				}
			}else if(privateFunctionLineStartPos){
				functionLineStartPos = privateFunctionLineStartPos;
			}else if(publicFunctionLineStartPos){
				functionLineStartPos = publicFunctionLineStartPos;
			}

			var componentEndPos = customFileContent.lastIndexOf("}") ;
			if(functionLineStartPos){
				var propertyEndPos = functionLineStartPos -1;
			}else{
				var propertyEndPos = componentEndPos;
			}

			//create function and properties strings
			var functionString = '';
			if(functionLineStartPos){
				functionString =  mid(customFileContent, functionLineStartPos, abs(componentEndPos - functionLineStartPos));
			}
			var propertyString = '';
			if(propertyStartPos){
				propertyString = mid(customFileContent, propertyStartPos, abs(propertyEndPos-propertyStartPos));
			}
			var newContent = fileContent;

			//add properties
			if(len(propertyString)){

				var customPropertyString = customPropertyBeginString & linebreak & chr(9) & propertyString & chr(9) & customPropertyEndString & linebreak;

				propertyStartPos = findNoCase("property name=", newContent) ;
				privateFunctionLineStartPos = reFind('private ',newContent);
				publicFunctionLineStartPos = reFind('public ',newContent);

				if(privateFunctionLineStartPos && publicFunctionLineStartPos){
					if(privateFunctionLineStartPos > publicFunctionLineStartPos){
						functionLineStartPos = publicFunctionLineStartPos;
					}else{
						functionLineStartPos = privateFunctionLineStartPos;
					}
				}else if(privateFunctionLineStartPos){
					functionLineStartPos = privateFunctionLineStartPos;
				}else if(publicFunctionLineStartPos){
					functionLineStartPos = publicFunctionLineStartPos;
				}

				componentEndPos = newContent.lastIndexOf("}") ;
				if(functionLineStartPos){
					propertyEndPos = functionLineStartPos -1;
				}else{
					propertyEndPos = componentEndPos;
				}

				var newContentPropertiesStartPos = propertyEndPos;
				newContent = left(newContent,newContentPropertiesStartPos-paddingCount) & conditionalLineBreak & chr(9) & customPropertyString & chr(9) & right(newContent,len(newContent) - newContentPropertiesStartPos);
			}
			//add functions
			if(len(functionString)){

				var customFunctionString =  customFunctionBeginString & lineBreak & chr(9) & functionString & lineBreak & chr(9) & customfunctionEndString & lineBreak;

				var newContentComponentEndPos = newContent.lastIndexOf("}") ;

				newContent = left(newContent,newContentComponentEndPos-(paddingCount-1)) & conditionalLineBreak & customFunctionString & '}';
			}

			return newContent;
		}
	</cfscript>
	<cffunction name="addPropertiesToFile" returntype="String">
	</cffunction>

</cfcomponent>
