<cfset currentFileName = scoperFileName />
<cfparam name="currentFileIteration" default="0">
<cfset currentFileIteration = currentFileIteration + 1 />
<cfset scoperResults = varscoper.getResultsArray() />

<script language="javascript">
	function toggleCorrectiveCode(idx){
		if (document.getElementById('correctiveCode'+idx).style.display == 'none'){
			document.getElementById('correctiveCode'+idx).style.display='';
			document.getElementById('showHide'+idx).innerHTML = 'hide corrective code';	
		}else{
			document.getElementById('correctiveCode'+idx).style.display='none';
			document.getElementById('showHide'+idx).innerHTML = 'show corrective code';
		}
	}
</script>

<cfset totalUnscopedVariables = 0 />
<cfloop from="1" to="#arrayLen(scoperResults)#" index="idx">
	<cfset totalUnscopedVariables = totalUnscopedVariables + arrayLen(scoperResults[idx].unscopedArray) />
</cfloop>
	
	<cfif ArrayIsEmpty(scoperResults)>
		<!--- <cfoutput>Check was successful for (#htmlEditFormat(scoperFileName)#)</cfoutput><br><br> --->

	<cfelse>
		<cfif isDefined('URL.sendBadStatus')>
			<cfheader statuscode="599" statustext="unscoped">
		</cfif>
		<cfsavecontent variable="varScoperDetails" >
		<table border="0" cellpadding="2" cellspacing="0" width="100%" class="scoperTable">
			<tr>
				<td class="fileTitle" colspan="4">
					<cfoutput><a href="fileDisplay.cfm?fileName=#URLEncodedFormat(currentFileName)#&lines=${allLines}" target="varscoper" class="fileTitle">#currentFileName#</a> (#totalUnscopedVariables# unscoped variables) </cfoutput>
				</td>
			</tr>
			
			<cfset allLines = "" >			
			<cfloop from="1" to="#arrayLen(scoperResults)#" index="scoperIdx">
				<cfset tempUnscopedArray = scoperResults[scoperIdx].unscopedArray />
				<cfif NOT ArrayIsEmpty(tempUnscopedArray)>


					<tr>
						<td colspan="3" class="functionCell" >
							<strong>
								<cfoutput>
									<span style="float:right;">
										<a href="###currentFileIteration#_#scoperIdx#" onclick="toggleCorrectiveCode('#currentFileIteration#_#scoperIdx#');">
											<span style="font-size: 10px;" id="showHide#currentFileIteration#_#scoperIdx#">show corrective code</span>
										</a>
									</span>
								#htmlEditFormat("<cffunction name='#scoperResults[scoperIdx].functionName#'>")#
									<cfif structKeyExists(scoperResults[scoperIdx],"LineNumber") AND scoperResults[scoperIdx].LineNumber NEQ 1>
										<cfset currLine = scoperResults[scoperIdx].LineNumber >
										<a href="fileDisplay.cfm?fileName=#URLEncodedFormat(currentFileName)#&lines=${allLines}##line#currLine#" target="varscoper" >line: #scoperResults[scoperIdx].LineNumber#</a>
										<cfset allLines = listAppend(allLines, currLine) >
									</cfif>
								</cfoutput>
							</strong>
						</td>
					</tr>	
					
					<!--- CorrectiveCode Block --->		
					<cfoutput>
					<tbody id="correctiveCode#currentFileIteration#_#scoperIdx#" style="display:none;">
					<tr>
						<td colspan="3" align="center" bgcolor="##E2DDB5">Disclaimer: Each function should be inspected individually to determine if the intended scope should be local(var).</td>
					</tr>
					<tr>
						<th class="codeCell" colspan="2" align="right">Corrective Code:</th>
						<td class="codeCell" bgcolor="##E2DDB5">
						<cfloop from="1" to="#arrayLen(tempUnscopedArray)#" index="unscopedIdx">
								<cfif structKeyExists(tempUnscopedArray[unscopedIdx],"LineNumber") AND tempUnscopedArray[unscopedIdx].LineNumber NEQ 1>
									<cfoutput>#htmlEditFormat("<cfset var " & trim(tempUnscopedArray[unscopedIdx].VariableName) & "	= '' />")#<br></cfoutput> 
								</cfif>
						</cfloop>
						</td>
					</tr>
					</tbody>
					</cfoutput>
						<cfloop from="1" to="#arrayLen(tempUnscopedArray)#" index="unscopedIdx">
							<cfoutput>
							<tr>
							</cfoutput>
								<td class="varNameCell" align="right"><cfoutput>#tempUnscopedArray[unscopedIdx].VariableName#</cfoutput></td>
								<cfif structKeyExists(tempUnscopedArray[unscopedIdx],"LineNumber") AND tempUnscopedArray[unscopedIdx].LineNumber NEQ 1>
								<cfset currLine = tempUnscopedArray[unscopedIdx].LineNumber >
								<td class="varNameCell" align="right">
									<cfoutput><a href="fileDisplay.cfm?fileName=#URLEncodedFormat(currentFileName)#&lines=${allLines}##line#currLine#" target="varscoper" >line: #tempUnscopedArray[unscopedIdx].LineNumber#</a></cfoutput>
									<cfset allLines = listAppend(allLines, currLine) >
								</td>
								</cfif>
								<td class="contextCell" ><cfoutput>#htmlEditFormat(left(tempUnscopedArray[unscopedIdx].VariableContext,100))#</cfoutput></td>
							</tr>
						</cfloop>
						
						
				</cfif>
			</cfloop>
		
		</table><br><br>
		</cfsavecontent>
		
		<cfoutput>#replaceNoCase(varScoperDetails, "${allLines}", allLines, "ALL")#</cfoutput>
	</cfif>
		

<cfflush>
