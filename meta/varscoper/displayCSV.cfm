<cfset csvData="">
<cfset csvRow="">

<cfset currentFileName = scoperFileName />
<cfset scoperResults = varscoper.getResultsArray() />

<cfloop from="1" to="#arrayLen(scoperResults)#" index="scoperIdx">
	<cfset tempUnscopedArray = scoperResults[scoperIdx].unscopedArray />
	<cfif NOT ArrayIsEmpty(tempUnscopedArray)>	
		<cfloop from="1" to="#arrayLen(tempUnscopedArray)#" index="unscopedIdx">				
			<cfset csvRow = "" />
			<cfset csvRow = listAppend(csvRow,CSVFormat(currentFileName))>
			<cfset csvRow = listAppend(csvRow,CSVFormat(scoperResults[scoperIdx].functionName))>
			<cfif structKeyExists(scoperResults[scoperIdx],"LineNumber")>
				<cfset csvRow = listAppend(csvRow,CSVFormat(scoperResults[scoperIdx].LineNumber))>
			<cfelse>
				<cfset csvRow = listAppend(csvRow,CSVFormat(0))>
			</cfif>			
			<cfset csvRow = listAppend(csvRow,CSVFormat(tempUnscopedArray[unscopedIdx].VariableName))>

			<cfif structKeyExists(tempUnscopedArray[unscopedIdx],"LineNumber")>
				<cfset csvRow = listAppend(csvRow,CSVFormat(tempUnscopedArray[unscopedIdx].LineNumber))>
			<cfelse>
				<cfset csvRow = listAppend(csvRow,CSVFormat(0))>
			</cfif>
			<cfset csvRow = listAppend(csvRow,CSVFormat(tempUnscopedArray[unscopedIdx].VariableContext))>
			<cfset csvData="#csvData##csvRow##newLine#">
		</cfloop>			
	</cfif>
</cfloop>

<cfset request.allCSVData = request.allCSVData & csvData >


		