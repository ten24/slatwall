<cfsetting enablecfoutputonly="true" />
<cfset currentFileName = scoperFileName />
<cfset scoperResults = varscoper.getResultsArray() />

<!--- variable to contain xml packet which we we are building up --->
<cfparam name="xmlPacket" default="" />
<cfset totalUnscopedVariables = 0 />

<cfloop from="1" to="#arrayLen(scoperResults)#" index="idx">
	<cfset totalUnscopedVariables = totalUnscopedVariables + arrayLen(scoperResults[idx].unscopedArray) />
</cfloop>
	
	<cfif NOT ArrayIsEmpty(scoperResults)>
	
		<cfsavecontent variable="currentXML" >
			
			<!--- for each file, create a new file element... --->
			<cfoutput><file><filepath>#currentFileName#(#totalUnscopedVariables# unscoped variables)</filepath></cfoutput>
			<cfloop from="1" to="#arrayLen(scoperResults)#" index="scoperIdx">
				
				<cfset tempUnscopedArray = scoperResults[scoperIdx].unscopedArray />
				<cfif NOT ArrayIsEmpty(tempUnscopedArray)>

					<!--- display xml tag for function name --->
					<cfoutput><function name="#scoperResults[scoperIdx].functionName#" line="#scoperResults[scoperIdx].LineNumber#"></cfoutput>
						<cfloop from="1" to="#arrayLen(tempUnscopedArray)#" index="unscopedIdx">
							<cfoutput><detail></cfoutput>
								<cfoutput><type>#tempUnscopedArray[unscopedIdx].VariableName#</type></cfoutput>
								<cfif structKeyExists(tempUnscopedArray[unscopedIdx],"LineNumber") AND tempUnscopedArray[unscopedIdx].LineNumber NEQ 1>
									<cfoutput><line_number>#tempUnscopedArray[unscopedIdx].LineNumber#</line_number></cfoutput>
								</cfif>
								<cfoutput><context><![CDATA[#(left(tempUnscopedArray[unscopedIdx].VariableContext,100))#]]></context></detail></cfoutput>
						</cfloop>
					<cfoutput></function></cfoutput>
					
				</cfif>
				
			</cfloop>
			
			<!--- ...close file element --->
			<cfoutput></file></cfoutput>
			</cfsavecontent>
			
			<!--- continune to build up xml document... --->
			<cfset xmlPacket = xmlPacket & currentXML />
			
</cfif>

<!--- ...add root element opening and closing tags... --->
<cfset xmlPacket = "<results>" & xmlPacket  />
<cfset xmlPacket = xmlPacket & "</results>" />	
<cfcontent type="text/xml"  reset="true" />
<cfoutput>#xmlPacket#</cfoutput>

<!--- abort so we don't get the summary etc messing up the XML  --->
<cfabort/>


<!---XML support is coming, but if you want it now, please write the code and send it to me. Done! --->