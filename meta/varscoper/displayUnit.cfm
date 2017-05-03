
<cfset unitTestObject = createObject("component","testCaseCFC") />

<cfif not isDefined("varscoper")>
	<!--- Allow this file to be called directly if it doesn't have results already --->
	<cfset scoperFileName = "testCaseCFC.cfc" />
	<cfset fileParseText = fileRead(expandPath("./testCaseCFC.cfc")) />
	<cfset varscoper = createObject("component","varScoper").init(fileParseText:fileParseText,showDuplicates:true,showLineNumbers:true,parseCfscript:true) />
	<cfset varscoper.runVarscoper() />
</cfif>


<hr>
<cfoutput>#scoperFileName#</cfoutput><br><br>
NOTE: If a false positive and negative case are contained in the same function it may report success

<hr>
<br>

<cfset resultsArray = varscoper.getResultsArray() />
<cfset resultsStruct = structNew() />

<cfloop from="1" to="#arrayLen(resultsArray)#" index="arrIdx">
	<cfset resultsStruct["#resultsArray[arrIdx].functionName#"] = structNew() />
	<cfset resultsStruct["#resultsArray[arrIdx].functionName#"].count = arrayLen(resultsArray[arrIdx].unscopedArray) >
	<cfset resultsStruct["#resultsArray[arrIdx].functionName#"].lineNumber = resultsArray[arrIdx].lineNumber >
</cfloop>

<cfset objMetadata = getMetadata(unitTestObject).functions>
<cfset hintStruct = structNew() />
<cfloop array="#objMetadata#" index="hintdx">
	<cfif structKeyExists(hintdx,"hint")>
		<cfset hintStruct["#hintdx.name#"] = hintdx.hint />
	</cfif>
</cfloop>


<cfset badTestsHTML = arrayNew(1) />
<cfset goodTestsHTML = arrayNew(1) />
<table border="0" cellpadding="4" cellspacing="0" width="100%" class="scoperTable">
		<tr>
			<td class="fileTitle" colspan="5" nowrap>
				<cfoutput><a href="fileDisplay.cfm?fileName=#URLEncodedFormat(scoperFileName)#" target="varscoper" class="fileTitle">#scoperFileName#</a></cfoutput>
			</td>
		</tr>
<cfloop array="#varscoper.getAllFunctionsScanned()#" index="resultIdx">

	<cfset currentFunction = resultIdx />
	
	<cfinvoke component="#unitTestObject#" method="#currentFunction#" returnvariable="scopedCount">
	<cfsavecontent variable="functionHTML">
		<cfset passFunction=false />
		<tr>
			<td nowrap class="functionCell">
				<strong>
					<cfoutput>#htmlEditFormat("#currentFunction#")#</cfoutput>
				</strong>
			</td>
			<cfif structKeyExists(resultsStruct,currentFunction)>
				<cfset found = resultsStruct["#currentFunction#"].count />
			<cfelse>
				<cfset found = 0 />
			</cfif>

			<td nowrap  class="functionCell" >
				<cfif found GT scopedCount>
				 	<span style="font-weight:bold;color:#ff8000;">FAIL</span>
				<cfelseif found LT scopedCount>
					<span style="font-weight:bold;color:#c03000;">FAIL</span>
				<cfelse>
					<cfset passFunction=true>
					<span style="color:green;">PASS</span>
				</cfif>
			</td>
			<td nowrap class="functionCell" >
				<cfif found NEQ scopedCount>
				 	<cfoutput>#scopedCount# expected - #found# found</cfoutput>
				<cfelse>&nbsp;
				</cfif>
			</td>
			<td width="99%" class="smallfunctionCell">
			<cfif structKeyExists(hintStruct,currentFunction)>
			<cfoutput>#hintStruct[currentFunction]#</cfoutput>
			<cfelse>&nbsp;
			</cfif>
			</td>
		</tr>	
	</cfsavecontent>
	<cfif passFunction>
		<cfset arrayAppend(goodTestsHTML,functionHTML) />
	<cfelse>
		<cfset arrayAppend(badTestsHTML,functionHTML) />
	</cfif>
</cfloop>

<!--- Display the failed tests at the top --->
<cfloop array="#badTestsHTML#" index="htmlIdx">
	<cfoutput>#htmlIdx#</cfoutput>
</cfloop>
<cfloop array="#goodTestsHTML#" index="htmlIdx">
	<cfoutput>#htmlIdx#</cfoutput>
</cfloop>
</table>
<!--- <cfdump var="#varscoper.getResultsArray()#" label="Array Of Unscoped Variables"> --->
<cfflush>