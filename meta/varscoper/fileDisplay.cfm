<cfif structKeyExists(URL,"fileName")>
	<cffile action="read" file="#URL.fileName#" variable="fileContent" />

<cfparam name="url.lines" default="" >	
			
<cfsetting enablecfoutputonly="true">
<cfoutput><pre></cfoutput>
<cfset totalLines = 0 />
<cfset lineCheckLine = 1 />
<cfset lastLineStart = 1 />
<cfset hasMoreLines = true />
<cfloop condition="hasMoreLines EQ true">
				<cfset lineFeedArray = REFind("#chr(13)#?#chr(10)#",fileContent,lineCheckLine,true) />
				<cfif lineFeedArray.POS[1] EQ 0>
					<cfset hasMoreLines = false />
				<cfelse>
					<cfset totalLines = totalLines + 1 />
					<cfset lineCheckLine = lineFeedArray.POS[1] + lineFeedArray.LEN[1] />
				</cfif>
				<cfif lineFeedArray.POS[1] -lastLineStart GT 0>

				<cfset highlightLine = false >
				<cfif listFind(url.lines, totalLines) >
					<cfset highlightLine = true >
					<cfoutput><b><font color="red"></cfoutput>
				</cfif>

				<cfoutput><a name="line#totalLines#">#totalLines#: #HTMLEditFormat(mid(fileContent,lastLineStart + 2,lineFeedArray.POS[1] -lastLineStart))#</cfoutput>
				
				<cfif highlightLine >
					<cfoutput></font></b></cfoutput>
				</cfif>

				</cfif>
				<cfset lastLineStart = lineFeedArray.POS[1] />
			</cfloop>

<cfoutput></pre></cfoutput>

	
</cfif>