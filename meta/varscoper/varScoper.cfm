<!--- 
	varscoper.cfm
	
	
	
	Author: Mike Schierberl 
			mike@schierberl.com
	

	Change log:
		7/14/2006 - initial revision
		11/1/2007 - support for ColdFusion MX - 8

	Fixes:
		-changed processDirectory() not to be dependant on the resultset that cfdirectory returns for ColdFusion 7 - 8
 --->

<cffunction name="processDirectory" hint="used to traverse a directory structure">
	<cfargument name="startingDirectory" type="string" required="true">
	<cfargument name="recursive" type="boolean" required="false" default="false">
	
	<cfset var fileQuery = "" />
	<cfset var scoperFileName = "" />
	<cfset var xmlDoc = "" />
	<cfset var xmlDocData = "" />
	<cfset var directoryexcludelistXML = arrayNew(1) />
	<cfset var directoryexcludelist = "" />
	<cfset var fileexcludelistXML = arrayNew(1) />
	<cfset var fileexcludelist = "" />
	<cfset var pathsep = "/" />
	
	<!--- get properties --->
	<cfif fileExists("#getDirectoryFromPath(getCurrentTemplatePath())#properties.xml")>

		<!--- read xml file --->
		<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#properties.xml" variable="xmlDocData">

		<!--- get file to parse --->
		<cfset xmlDoc = XmlParse(xmlDocData) />
		
		<!--- get directory exclusion list --->
		<cfset directoryexcludelistXML = XmlSearch(xmlDoc, "/properties/directoryexcludelist") />
		<!--- if array size GT 0 the get the value --->
		<cfif arrayLen(directoryexcludelistXML) GT 0>
			<cfset directoryexcludelist = trim(directoryexcludelistXML[1].XmlText) />
		</cfif>
		
		<!--- get file exclusion list --->
		<cfset fileexcludelistXML = XmlSearch(xmlDoc, "/properties/fileexcludelist") />
		<!--- if array size GT 0 the get the value --->
		<cfif arrayLen(fileexcludelistXML) GT 0>
			<cfset fileexcludelist = trim(fileexcludelistXML[1].XmlText) />
		</cfif>
	</cfif>
		
	<cfdirectory directory="#arguments.startingDirectory#" name="fileQuery"  >
	<cfloop query="fileQuery">
	
		<!--- check to see if we want to exclude the diretory or file (from properties file) --->
		<cfif NOT listFindNoCase(directoryExcludeList, listLast(replace(arguments.startingDirectory, "\", "/", "ALL"), pathsep))
			AND NOT listFindNoCase(fileExcludeList, "#name#")
			>
			
			<cfset scoperFileName = "#arguments.startingDirectory##pathsep##name#" />
	
	
			
			<cfif listFind("cfc,cfm",right(fileQuery.name,3)) NEQ 0 and type IS "file">
				<cfset variables.totalFiles = variables.totalFiles + 1 />
				<cfinclude template="varScoperDisplay.cfm">
			<cfelseif type IS "Dir" and arguments.recursive >
				<cfset processDirectory(startingDirectory:scoperFileName, recursive:true) />
			</cfif>
		</cfif>		
		
	</cfloop>
</cffunction>

<cfif isDefined("URL.displayFormat") and url.displayFormat IS "unit">
	<cfset url.filePath="testCaseCFC.cfc">
	<cfset URL.parseCfscript = true />
</cfif>

<cfif isdefined("url.filePath")>
	<cfset scoperFileName=url.filePath>
<cfelse>
	<cfset scoperFileName="testCaseCFC.cfc">
</cfif>


<html>
<head>
<style>
body, input{
	font-family: verdana, arial, helvetica, sans-serif;
	font-size:12px;
	}
.scoperTable{
	font-family: verdana, arial, helvetica, sans-serif;
	font-size:	 10px;
	border-color: #0000cc;
	border-width: 2px; 
	border-style: solid;
}
.fileTitle{
	font-size: 18px;
	background-color:#4444cc;
	color: #ffffff;
}
.functionCell{
	font-size: 14px;
	background-color:#ccddff;
	border-width: 2px 0px 0px 0px;
	border-style: solid;
}
.varNameCell{
	font-size: 12px;
	border-width: 2px 2px 0px 0px;
	background-color:#ebebeb;
	border-style: solid;
}
.contextCell{
	border-width: 2px 0px 0px 0px;
	border-style: solid;
}
.summary{
	font-family: 	verdana, arial, helvetica, sans-serif;
	font-size:	 	14px;
	font-weight: 	bold;
}
 
.codeCell{
	font-size: 12px;
	padding-left:4ex;
	border-width: 2px 0px 0px 0px;
	border-style: solid;
}
th.codeCell{
	padding:0px;
	background-color:#ebebeb;
	border-width: 2px 2px 0px 0px;
	vertical-align:top;
}
.smallFunctionCell{
	font-size: 10px;
	background-color:#ccddff;
	color:#999999;
	border-width: 2px 0px 0px 0px;
	border-style: solid;
}
</style>
<title>varscoper</title>
</head>
<body>

<cfsetting showdebugoutput="false">
<cfparam name="displayFormat" default="">
<form action="varScoper.cfm" method="get" name="scoperForm" id="scoperForm" <!--- onsubmit="document.scoperForm.submitButton.disabled=true;" --->>
	absolute path:
	<cfoutput>
		<input type="text" name="filePath" id="filePath" size="75" value="#htmlEditFormat(scoperFileName)#" />
	</cfoutput>
	<input type="submit" value="start" name="submitButton" id="submitButton" /><br>
	output: 
	<input type="radio" name="displayFormat" value="screen" <cfif displayFormat is "" or displayFormat IS "screen">checked</cfif>> screen
	<input type="radio" name="displayFormat" value="csv" <cfif  displayFormat IS "csv">checked</cfif>> csv
	<input type="radio" name="displayFormat" value="xml" <cfif  displayFormat IS "xml">checked</cfif>> xml
	<input type="radio" name="displayFormat" value="unit" <cfif  displayFormat IS "unit">checked</cfif>> unit test
	<input type="radio" name="displayFormat" value="dump" <cfif  displayFormat IS "dump">checked</cfif>> dump (debug)
	<br>
	<input type="checkbox" name="showDuplicates" value="true" <cfif isDefined("URL.showDuplicates") and URL.showDuplicates>checked</cfif>> show duplicates (useful if some setters are in comments) 
	<!--- <input type="checkbox" name="hideLineNumbers" value="true" <cfif isDefined("URL.hideLineNumbers") and URL.hideLineNumbers>checked</cfif>> hide line numbers --->
	<br>
	<input type="hidden" name="recursiveDirectory" value="disabled" />
	<input type="checkbox" name="recursiveDirectory" value="true" <cfif NOT isDefined("URL.recursiveDirectory") or findNoCase('true',URL.recursiveDirectory)>checked</cfif>> include sub-folders<br>
	<input type="hidden" name="parseCFScript" value="disabled" /> 
	<input type="checkbox" name="parseCfscript" value="true" <cfif NOT isDefined("URL.parseCfscript") OR findNoCase('true',URL.parseCfscript) >checked</cfif>> parse cfscript. note: this will NOT return correct line numbers

</form>

<cfif isdefined("url.filePath") and trim(url.filePath) IS NOT "">
	<cfif isDefined("URL.displayFormat") AND URL.displayFormat IS "CSV">
			<cfscript>
			function CSVFormat(col){
				/* Look for quotes */
				if (Find("""", col)) {
					return_string = """" & Replace(col, """", """""", "All") & """";
				} //if
				/* Look for spaces */
				else if (Find(" ", col)) {
					return_string = """" & col & """";
				} //else if
				/* Look for commans */
				else if (Find(",", col)) {
					return_string = """" & col & """";
				} //else if
				else {
					return_string = col;
				} //else
				return return_String;
			}
			
			newLine = Chr(13)&Chr(10);
		</cfscript>
		<cfset request.allCSVData = '"Filename","Function Name","Function Line","Variable Name","Variable Line","Context"#Chr(13)##Chr(10)#'>
	</cfif>
	<cfif fileExists("#url.filePath#") or fileExists(expandPath(url.filePath))>
		<cfif fileExists(url.filePath)>
			<cfset scoperFileName=url.filePath>
		<cfelse>
			<cfset scoperFileName=expandPath(url.filePath)>
		</cfif>
		<cfset variables.totalMethods = 0 />
		<cfset directoryStart = getTickCount() />
		<cfoutput><script>fileLines = new Array(); </script></cfoutput>	
		<cfinclude template="varScoperDisplay.cfm">
		<cfset directoryEnd = getTickCount() />
		<cfoutput><br><br><span class="summary">Processed 1 file and #variables.totalMethods# cffunctions in #directoryEnd-directoryStart#ms</span></cfoutput>

	<cfelseif directoryExists("#url.filePath#") OR directoryExists(expandPath(url.filePath))>
		<cfif directoryExists(url.filePath)>
			<cfset startingDirectory = url.filePath>
		<cfelse>
			<cfset startingDirectory = expandPath(url.filePath)>
		</cfif>
	
		<cfif NOT isDefined("URL.recursiveDirectory") or findNoCase('true',URL.recursiveDirectory)>
			<cfset recursive=true>
		<cfelse>
			<cfset recursive=false>
		</cfif>
		<cfset variables.totalFiles = 0 />
		<cfset variables.totalMethods = 0 />
		<cfset directoryStart = getTickCount() />
		<cfoutput><script>fileLines = new Array(); </script></cfoutput>	
		<cfset processDirectory(startingDirectory:startingDirectory,recursive:recursive)>
		<cfset directoryEnd = getTickCount() />
		<cfoutput><br><br><span class="summary">Processed #variables.totalFiles# files and #variables.totalMethods# cffunctions in #directoryEnd-directoryStart#ms</span></cfoutput>
	<cfelse>
		<cfoutput>No file or directory exists for the path specified (#htmlEditFormat(url.filePath)#)</cfoutput>
	</cfif>
	
	<cfif isDefined("URL.displayFormat") AND URL.displayFormat IS "CSV">
		<cfsetting enablecfoutputonly="true" showdebugoutput="false">
		<cfset fileName="unscoped_variables.csv" />
		<cfheader name="Content-Disposition" value="attachment; filename=#FileName#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/octet-stream" reset="true"> <!--- vnd.ms-excel --->
		<cfcontent reset="true"><cfoutput>#request.allCSVData#</cfoutput><cfabort>
	
		
	</cfif>
	
	
	
	
</cfif>



</body>
</html>
