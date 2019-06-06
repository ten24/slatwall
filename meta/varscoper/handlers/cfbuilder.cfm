<cfsetting showdebugoutput="false">

<cfset start = getTickCount()/>
<cfset noErrors=true />
<cfset totalCount = 0 />
<cfparam name="ideeventinfo"> 
<cfif not isXML(ideeventinfo)>
	<cfexit>
</cfif>

<cfset data = xmlParse(ideeventinfo)>
<cfset resource = data.event.ide.projectview.resource>

<cfset files = arrayNew(1)>
<cfif resource.xmlAttributes.type is "file">
	<cfset arrayAppend(files, resource.xmlAttributes.path)>
<cfelse>
	<cfdirectory directory="#resource.xmlAttributes.path#" recurse="true" name="fileDir" filter="*.cfc|*.cfm">
	<cfloop query="fileDir">
		<cfset arrayAppend(files, directory & "/" & name)>
	</cfloop>
</cfif>

<cfsavecontent variable="responseContent">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
  <title>varScoper</title>
</head>
<style>
body, input{
	font-family: verdana, arial, helvetica, sans-serif;
	font-size:12px;
	}
.scoperTable{
	font-family: verdana, arial, helvetica, sans-serif;
	font-size:	 10px;
	border-color: #999999;
	border-width: 2px; 
	border-style: solid;
}
.fileTitle{
	font-size: 14px;
	background-color:#4444cc;
	color: #ffffff;
}
.functionCell{
	font-size: 12px;
	background-color:#ccddff;
	border-width: 2px 0px 0px 0px;
	border-style: solid;
	border-color: #999999;
}
.varNameCell{
	font-size: 12px;
	border-width: 2px 2px 0px 0px;
	background-color:#ebebeb;
	border-style: solid;
	border-color: #999999;
}
.contextCell{
	border-width: 2px 0px 0px 0px;
	border-style: solid;
	border-color: #999999;
}
.summary{
	font-family: 	verdana, arial, helvetica, sans-serif;
	font-size:	 	12px;
	font-weight: 	bold;
}
 
.codeCell{
	font-size: 10px;
	padding-left:4ex;
	border-width: 2px 0px 0px 0px;
	border-style: solid;
	border-color: #999999;
}
th.codeCell{
	padding:0px;
	background-color:#ebebeb;
	border-width: 2px 2px 0px 0px;
	vertical-align:top;
	border-color: #999999;
}

</style>
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
<body>
<cfset currentFileIteration = 0>
<cfloop from="1" to="#ArrayLen(files)#" index="i">
	<cfset fileIdx = files[i] />
	<cfset currentFileIteration = currentFileIteration + 1 />
	<cftry>
		<cffile action="READ" file="#fileIdx#" variable="fileParseText">
		<cfcatch>
			<cfset fileParseText = "">
		</cfcatch>
	</cftry>
	<cfset showDuplicates="false">
	<cfset showLineNumbers = "true">
	<cfset parseCfscript="true">

	<cfif len(fileParseText)>
		<cfset varscoperArgs = structNew() />
		<cfset varscoperArgs.fileParseText = fileParseText />
		<cfset varscoperArgs.showDuplicates = showDuplicates />
		<cfset varscoperArgs.showLineNumbers = showLineNumbers />
		<cfset varscoperArgs.parseCfscript = parseCfscript />
		
		<cfinvoke component="varScoper" method="init" argumentcollection="#varscoperArgs#" returnvariable="varscoper">
		
		<cfset varscoper.runVarscoper() />
		<cfset scoperResults = varscoper.getResultsArray() />
		
		<cfset totalUnscopedVariables = 0 />
		<cfloop from="1" to="#arrayLen(scoperResults)#" index="idx">
			<cfset totalUnscopedVariables = totalUnscopedVariables + arrayLen(scoperResults[idx].unscopedArray) />
		</cfloop>
		<cfset totalCount = totalCount + totalUnscopedVariables>
		<cfif arrayLen(scoperResults)>
			<cfset noErrors=false/>
			
			<table border="0" cellpadding="2" cellspacing="0" width="100%" class="scoperTable">
			<tr>
				<td class="fileTitle" colspan="4">
					<cfoutput>#fileIdx# - #totalUnscopedVariables# unscoped variables<cfif totalUnscopedVariables GT 1>s</cfif></cfoutput>
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
								<!---#htmlEditFormat("<cffunction name='#scoperResults[scoperIdx].functionName#'>")#--->
									#scoperResults[scoperIdx].functionName#
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
								<td class="varNameCell" align="right" nowrap>
									<cfoutput>line: #tempUnscopedArray[unscopedIdx].LineNumber#</cfoutput>
									<cfset allLines = listAppend(allLines, currLine) >
								</td>
								</cfif>
								<td class="contextCell" ><cfoutput>#htmlEditFormat(left(tempUnscopedArray[unscopedIdx].VariableContext,100))#</cfoutput></td>
							</tr>
						</cfloop>
						
						
				</cfif>
			</cfloop>
		
		</table><br><br>

		
		<!---<cfoutput>#replaceNoCase(varScoperDetails, "${allLines}", allLines, "ALL")#</cfoutput>
		--->	

		</cfif>
	</cfif>
	
</cfloop>

<cfoutput>
<cfset end = getTickCount() />
<p>
<b>Processed #arrayLen(files)# files in #end-start#ms.</b>
</p>

</cfoutput>
</body>
</html>
</cfsavecontent>

<cfheader name="Content-Type" value="text/xml">
<cfoutput> 
<cfif noErrors>
	<response showresponse="false" status="success" > 
	<ide message="No unscoped variables found. Processed #arrayLen(files)# files in #end-start#ms.">
<cfelse>
	<response showresponse="true"  > 
	<ide > 
</cfif>
<dialog width="800" height="600" /> 
<body> 
<![CDATA[ 
<p>
<strong>Found #totalCount# unscoped variable<cfif totalCount GT 1>s</cfif> in #arrayLen(files)# file<cfif arrayLen(files) GT 1>s</cfif></strong>
</p>
#responseContent#
]]> 
</body> 
</ide> 
</response> 
</cfoutput>

