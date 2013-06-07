<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfcomponent extends="HibachiService" accessors="true">
	
	<cffunction name="update">
		<cfargument name="branch" type="string" default="master">
		
		<!--- this could take a while... --->
		<cfsetting requesttimeout="600" />
		
		<cftry>
			<cfset var downloadURL = "https://github.com/ten24/Slatwall/zipball/#arguments.branch#" />	
			<cfset var slatwallRootPath = expandPath("/Slatwall") />
			<cfset var downloadFileName = "slatwall.zip" />
			<cfset var deleteDestinationContentExclusionList = "/integrationServices,/config/custom" />
			<cfset var copyContentExclusionList = "" />
			
			<!--- before we do anything, make a backup --->
			<cfzip action="zip" file="#getTempDirectory()#slatwall_bak.zip" source="#slatwallRootPath#" recurse="yes" overwrite="yes" />
			
			<!--- start download --->
			<cfhttp url="#downloadURL#" method="get" path="#getTempDirectory()#" file="#downloadFileName#" />
			
			<!--- now read and unzip the downloaded file --->
			<cfset var dirList = "" />
			<cfzip action="unzip" destination="#getTempDirectory()#" file="#getTempDirectory()##downloadFileName#" >
			<cfzip action="list" file="#getTempDirectory()##downloadFileName#" name="dirList" >
			<cfset var sourcePath = getTempDirectory() & "#listFirst(dirList.name[1],'/')#" />
			<cfset getHibachiUtilityService().duplicateDirectory(source=sourcePath, destination=slatwallRootPath, overwrite=true, recurse=true, copyContentExclusionList=copyContentExclusionList, deleteDestinationContent=true, deleteDestinationContentExclusionList=deleteDestinationContentExclusionList ) />
			
			<!--- if there is any error during update, restore the old files and throw the error --->
			<cfcatch type="any">
				<cfzip action="unzip" destination="#slatwallRootPath#" file="#getTempDirectory()#slatwall_bak.zip" >
				<cfrethrow />
			</cfcatch>
			
		</cftry>
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
		
		<cfhttp method="get" url="https://raw.github.com/ten24/Slatwall/master/version.txt" result="masterVersion">
		<cfhttp method="get" url="https://raw.github.com/ten24/Slatwall/develop/version.txt" result="developVersion">
		
		<cfset versions.master = trim(masterVersion.filecontent) />
		<cfset versions.develop = trim(developVersion.filecontent) />
		
		<cfreturn versions />
	</cffunction>
</cfcomponent>
