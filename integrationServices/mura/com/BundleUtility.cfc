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
<cfcomponent>
	
	<cffunction name="init">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="toBundle">
		<cfargument name="pluginConfig" />
		
		<cfset var rs = "" />
		<cfset var tableList = getTableList() />
		
		<cfloop list="#tableList#" index="local.tableName">
			
			<cfif not listFind("SwLog,SwSession", tableName)>
				<cfquery name="rs">
					SELECT
						*
					FROM
						#tableName#
				</cfquery>
				
				<cfset arguments.pluginConfig.setCustomSetting('#tableName#', rs) />
				<cflog text="The Table: #tableName# - was exported to a mura bundle" file="Slatwall" />
			</cfif>
			
		</cfloop>
		
	</cffunction>
	
	<cffunction name="fromBundle">
		<cfargument name="pluginConfig" />
		
		<cfset var rs = "" />
		<cfset var columnName = "" />
		<cfset var tableList = getTableList() />
		
		<cfloop list="#tableList#" index="local.tableName">
			
			<cfset var importQuery = arguments.pluginConfig.getCustomSetting('#tableName#') />
			
			<cfif isQuery(importQuery)>
				<cfif not listFind("SwLog,SwSession", tableName)>
					
					<cfif application.configBean.getDBType() eq "mssql">
						<cfquery name="rs">
							ALTER TABLE '#tableName#'NOCHECK CONSTRAINT ALL
						</cfquery>
					<cfelseif application.configBean.getDBType() eq "mssql">
						<cfquery name="rs">
							ALTER TABLE '#tableName#' DISABLE KEYS
						</cfquery>
					</cfif>
					
					<cfquery name="rs" >
						TRUNCATE TABLE #tableName#
					</cfquery>
					
					<cfquery name="rs" >
						INSERT INTO #tableName# 
							(
								#importQuery.columnList#
							)
						VALUES
							(
								<cfloop list="#importQuery.columnList#" index="local.columnName">
									'#importQuery[ columnName ]#'
								</cfloop>
							)
					</cfquery>
					
					<cflog text="The Table: #tableName# - was updated from a mura bundle" file="Slatwall" />
				</cfif>
			</cfif>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="getTableList">
		<cfset var tableList = "" />
		<cfset var entityList = "" />
		<cfset var entityDirectory = replace(getCurrentTemplatePath(),"\","/","all") />
		<cfset entityDirectory = replace(entityDirectory,"/plugin/","/com/") />
		<cfset entityDirectory = replace(entityDirectory,"/bundleUtility.cfc","/entity/") />
		
		<cfset var componentPath = replace(right(entityDirectory, len(entityDirectory) - find("/plugins", entityDirectory)),"/",".","all") />
		
		<cfdirectory action="list" directory="#entityDirectory#" name="entityList" filter="*.cfc">
		
		<cfloop query="entityList">
			<cfset var thisComponent = createObject("component","#componentPath##listFirst(entityList.name,'.')#") />
			<cfset var thisComponentMetaData = getMetaData(thisComponent) />
			
			<cfif structKeyExists(thisComponentMetaData, "table") and not listFind(tableList, thisComponentMetaData.table)>
				<cfset tableList = listAppend(tableList,thisComponentMetaData.table) />
			</cfif>
		</cfloop>
		
		<cfreturn tableList />
	</cffunction>

</cfcomponent>