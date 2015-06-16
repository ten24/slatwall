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
			<cfset var downloadURL = "https://github.com/ten24/Slatwall/zipball/#arguments.branch#" />	
			<cfset var slatwallRootPath = expandPath("/Slatwall") />
			<cfset var downloadFileName = "slatwall#createUUID()#.zip" />
			<cfset var deleteDestinationContentExclusionList = getHibachiScope().getApplicationValue('updateDestinationContentExclustionList') />
			<cfset var copyContentExclusionList = "" />
			<cfset var slatwallDirectoryList = "" />
			
			<!--- If the meta directory exists, and it hasn't been dismissed then we want to delete without user action --->
			<cfif getMetaFolderExistsWithoutDismissalFlag()>
				<cfset removeMeta() />
			</cfif>
			
			<!--- if the meta directory doesn't exist, add it tothe exclusion list--->
			<cfif !getMetaFolderExistsFlag()>
				<cfset copyContentExclusionList = "meta" />
			</cfif>
			
			<!--- before we do anything, make a backup --->
			<cfdirectory action="list" directory="#slatwallRootPath#" name="slatwallDirectoryList">
			<cfzip action="zip" file="#getTempDirectory()#slatwall_bak.zip" recurse="yes" overwrite="yes" source="#slatwallRootPath#">
				<cfloop query="slatwallDirectoryList">
					<cfif not listFindNoCase("WEB-INF,.project,setting.xml", slatwallDirectoryList.name)>
						<cfif slatwallDirectoryList.type eq "File">
							<cfzipparam source="#slatwallDirectoryList.name#" />
						<cfelse>
							<cfzipparam source="#slatwallDirectoryList.name#" prefix="#slatwallDirectoryList.name#" />
						</cfif>
					</cfif>
				</cfloop>
			</cfzip>
			
			<!--- start download --->
			<cfhttp url="#downloadURL#" method="get" path="#getTempDirectory()#" file="#downloadFileName#" throwonerror="true" />
			
			<!--- now read and unzip the downloaded file --->
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
		<cfloop array="#apps#" index="app">
			<cfset getService('appService').updateCMSApp(app)>
		</cfloop>
	</cffunction>
	
	<cffunction name="runScripts">
		<cfset var scripts = this.listUpdateScriptOrderByLoadOrder() />
		<cfset var script = "" />
		<cfloop array="#scripts#" index="script">
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
		<cfset var versions = {} />
		
		<cfhttp method="get" url="https://raw.github.com/ten24/Slatwall/master/version.txt.cfm" result="masterVersion">
		<cfhttp method="get" url="https://raw.github.com/ten24/Slatwall/develop/version.txt.cfm" result="developVersion">
		
		<cfset versions.master = trim(masterVersion.filecontent) />
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
	
	<cffunction name="updateEntitiesWithCustomProperties" returntype="boolean">
		 <cfscript>
			try{
				path = "#ExpandPath('/')#" & "/model/entity";
				pathCustom = "#ExpandPath('/')#" & "/custom/model/entity";
				directoryList = directoryList(path, false, "path", "*.cfc", "directory ASC");
				directoryListByName = directoryList(path, false, "name", "*.cfc", "directory ASC");
				directoryListCustom = directoryList(pathCustom, false, "name", "*.cfc", "directory ASC");
				directories = ArrayToList(directoryList);
				
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
				for (var match in matchArray){
					var results = mergeProperties("#match#");
				}
				return true;
			}catch(any e){
				writeLog(file="Slatwall", text="Error reading from the file system while updating properties: #e#");
				return false;
			}
			return true;
		</cfscript>
	</cffunction>
	<cffunction name="mergeProperties" returntype="any">
	  <cfargument name="fileName" type="String">
		<cfscript>
			
			var fileContent =  "Slatwall/custom/model/entity/#fileName#";
			var customFileContent =  "Slatwall/model/entity/#fileName#";
		    
		    var fileContentName = left(fileContent, len(fileContent)-4);
		     	  fileContentName = replace(fileContent, "/", ".", "All");
			var customFileContentName = left(fileContent, len(fileContent)-4);
		     	  customFileContentName = replace(fileContent, "/", ".", "All"); 	  
			
			var baseMeta = getComponentMetaData(fileContentName);
			var customMeta = getComponentMetaData(customFileContentName);
			writeDump(customMeta);
			//Grab the contents of the files and figure our the properties.
			fileContent = fileRead(fileContent) ;
			customFileContent = fileRead(customFileContent) ;
			// check duplicate properties
			for(var i=1; i <= arraylen(customMeta.properties); i++) {
				for(var j=1; j <= arraylen(baseMeta.properties); j++ ) {
					if(baseMeta.properties[j].name == customMeta.properties[i].name) {
						writeLog("Slatwall", "Custom property names can't be same as core property names");
					}
				}
			}			
			var propertyStartPos = findNoCase("property ", customFileContent) ;
			var functionLineStartPos = reFindNoCase('private|public(.*)function',customFileContent) ; 
			var endPos = customFileContent.lastIndexOf("}") ;
			var propertyString = mid(customFileContent, propertyStartPos, functionLineStartPos - propertyStartPos) ;
			var functionString = mid(customFileContent, functionLineStartPos, endPos - functionLineStartPos) ;
			var newContent = fileContent;
			
			// add property
			if(!findNoCase(propertyString,fileContent)) {
				functionLineStartPos = reFindNoCase('private|public(.*)function',fileContent) ; 
				endPos = fileContent.lastIndexOf("}") ;	
				newContent = left(fileContent,functionLineStartPos-1) & propertyString & mid(fileContent, functionLineStartPos, len(fileContent)-functionLineStartPos);
				writedump("#newContent#");abort;
			}
		return newContent;
		</cfscript>
	</cffunction>
	<cffunction name="addPropertiesToFile" returntype="String">	
	</cffunction>
	
</cfcomponent>

