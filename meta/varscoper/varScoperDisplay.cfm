<cftry>
		
		<cfif NOT fileExists(scoperFileName)>
			<cfthrow type="noFile">
		</cfif>
		<cffile action="read" file="#scoperFileName#" variable="fileParseText">
		
		<cfif isDefined("URL.showDuplicates") and URL.showDuplicates>
			<cfset showDuplicates = TRUE >
		<cfelse>
			<cfset showDuplicates = FALSE >
		</cfif>
		
		<cfif isDefined("URL.hideLineNumbers") and URL.hideLineNumbers>
			<cfset showLineNumbers = FALSE >
		<cfelse>
			<cfset showLineNumbers = TRUE >
		</cfif>
		
		<cfif NOT isDefined("URL.parseCfscript") OR findNoCase('true',URL.parseCfscript) >
			<cfset parseCfscript = TRUE >
		<cfelse>
			<cfset parseCfscript = FALSE >
		</cfif>
		
		
		<cfset varscoper = createObject("component","varScoper").init(fileParseText:fileParseText,showDuplicates:showDuplicates,showLineNumbers:showLineNumbers,parseCfscript:parseCfscript) />
		<!--- <cftimer label="Scope Checking Execution" type="comment"> --->
			<cfset varscoper.runVarscoper() />
		<!--- </cftimer> --->
		<cfparam name="variables.totalMethods" default="0">
		<cfset variables.totalMethods = variables.totalMethods + structCount(varscoper.getResultsStruct()) />
		
		<cfif isDefined("URL.displayFormat")>
			<cfset displayFormat = URL.displayFormat />
		<cfelse>
			<cfset displayFormat = "screen" />
		</cfif>
		<cfswitch expression="#displayFormat#">
			<cfcase value="screen">
				<cfinclude template="displayScreen.cfm">
			</cfcase>
			<cfcase value="dump">
				<cfinclude template="displayDump.cfm">
			</cfcase>
			<cfcase value="csv">
				<cfinclude template="displayCSV.cfm">
			</cfcase>
			<cfcase value="XML">
				<cfinclude template="displayXML.cfm">
			</cfcase>
			<cfcase value="unit">
				<cfinclude template="displayUnit.cfm">
			</cfcase>
		</cfswitch>
		
	<cfcatch type="noFile">
		<cfoutput>No file or directory exists for the path specified (#htmlEditFormat(scoperFileName)#)</cfoutput>
	</cfcatch>
	<cfcatch type="functionWithoutName">
		There was a parsing error with one of the functions - the function did not have a name, exiting processing
	</cfcatch>
	<cfcatch type="any">
		<cfdump var="#cfcatch#">
	</cfcatch>

</cftry>