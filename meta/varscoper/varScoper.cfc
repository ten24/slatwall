<!--- 	varscoper.cfc
	
	This cfc takes a string argument and parses the string looking for any unscoped variables within a cffunction
	
	Author: Mike Schierberl 
			mike@schierberl.com
	

	Features:
		-cfset
		-can return line numbers of functions/variables
	
	Future TODOs:
		-create a library of all cf tags that can create variables
		-ignore things in comments (May need to use lookbehind?  Not supported in CF
		-automatically fix unscoped vars (potentially dangerous)
		-relative paths
		
	Known Limitations:
	
		-Returns false positive when variables are set within a comments block

		-If you don't scope an argument value, and then set that value it will return a false positive... May not be a bad idea to change the syntax though in this case
			<cfargument name="foo">
			<cfset foo.foo2 = bar /> instead of...
			<cfset arguments.foo.foo2 />
		
		-Cfscript does not return line numbers

 --->

<cfcomponent name="varscoper" 	hint="I am a component used to find improperly scoped variables within a cfc">

	<cfset variables.fileParseText 				= "" />
	<cfset variables.varscoperStruct 			= structNew() />
	<cfset variables.OrderedUnVarArray			= arrayNew(1) />
	<cfset variables.tempUnscopedArray			= "" />
	<cfset variables.currentFunctionLineCount	= 1 />
	<cfset variables.currentLineCountPosition	= 1 />
	<cfset variables.currentLineCountFuncPos	= 1 />
	<cfset variables.currentFunctionName		= "" />
	<cfset variables.ignoredScopes				= "super,variables,this,cgi,form,url,application,arguments,cfcatch,cgi,client,cookie,request,server,session" />
	<cfset variables.showDuplicates				= false />
	<cfset variables.showLineNumbers			= true />
	<cfset variables.parseCFscript				= false />
	
	<cfset variables.tagTypes					= arrayNew(1) />
	<cfset variables.cf9						= "true" />
	<cfset variables.allFunctionsScanned		= arrayNew(1) />
	
	<cfif variables.cf9>
		<cfset variables.ignoredScopes = listAppend(variables.ignoredScopes,"local") />
	</cfif>
	
	<!--- Identify all tags that should be checked here... --->
	<!--- These are key value pairs where the value is the parameter of the tag used to create a variable --->
	<!--- attributes defs
		attribute 1) tag name
		attribute 2) tag attribute name that accepts the variables
		
		attribute 3) tag attribute name that tells the tag it is to accept a variable
		attribute 4) tag attribute value (read, create, etc) that tells the tag it is to accept a variables (works in conjunction with attribute 3)
	--->
	<cfset arrayAppend(variables.tagTypes,"cfloop:index") />
	<cfset arrayAppend(variables.tagTypes,"cfloop:item") />
	<cfset arrayAppend(variables.tagTypes,"cfquery:name") />
	<cfset arrayAppend(variables.tagTypes,"cfinvoke:returnvariable") />
	<cfset arrayAppend(variables.tagTypes,"cfdirectory:name") />
	<cfset arrayAppend(variables.tagTypes,"cffile:variable") />
	<cfset arrayAppend(variables.tagTypes,"cfparam:name") />
	<cfset arrayAppend(variables.tagTypes,"cfsavecontent:variable") />
	<cfset arrayAppend(variables.tagTypes,"cfform:name") />
	<cfset arrayAppend(variables.tagTypes,"cfstoredproc:name")>
	<cfset arrayAppend(variables.tagTypes,"cfprocparam:variable:type:out")>
	<cfset arrayAppend(variables.tagTypes,"cfhttp:result")>
	<cfset arrayAppend(variables.tagTypes,"cfquery:result")>
	<cfset arrayAppend(variables.tagTypes,"cfimage:name")>
	<cfset arrayAppend(variables.tagTypes,"cfmail:query")>
	<cfset arrayAppend(variables.tagTypes,"cffeed:name")>
	<cfset arrayAppend(variables.tagTypes,"cffeed:query:action:read")>
	<cfset arrayAppend(variables.tagTypes,"cfftp:name")>
	<cfset arrayAppend(variables.tagTypes,"cfftp:result")>
	<cfset arrayAppend(variables.tagTypes,"cfwddx:output")>
	<cfset arrayAppend(variables.tagTypes,"cfobject:name")>
	<cfset arrayAppend(variables.tagTypes,"cfsearch:name")>
	<cfset arrayAppend(variables.tagTypes,"cfprocresult:name")>
	<cfset arrayAppend(variables.tagTypes,"cfpop:name")>
	<cfset arrayAppend(variables.tagTypes,"cfregistry:name")>
	<cfset arrayAppend(variables.tagTypes,"cfreport:name")>
	<cfset arrayAppend(variables.tagTypes,"cfdbinfo:name")>
	<cfset arrayAppend(variables.tagTypes,"cfdocument:name")>
	<cfset arrayAppend(variables.tagTypes,"cfexecute:variable")>
	<cfset arrayAppend(variables.tagTypes,"cfNtAuthenticate:result")>
	<cfset arrayAppend(variables.tagTypes,"cfcollection:name")>
	<cfset arrayAppend(variables.tagTypes,"cfpdf:name")>
	<cfset arrayAppend(variables.tagTypes,"cfxml:variable")>
	<cfset arrayAppend(variables.tagTypes,"cfzip:name")>
	<cfset arrayAppend(variables.tagTypes,"cfldap:name")>

	
	<cffunction name="init" access="public" output="false" 
		hint="I initialize an instance of the var scoper component which is used to find unscoped vars" >
		<cfargument name="fileParseText" required="true" type="string" 
			hint="I am the string representing the code within a cfc that needs to be parsed" />
		<cfargument name="showDuplicates" required="false" type="boolean"
			hint="I specify if duplicate instances of variables should be shown, useful because first instance may be in comments" />
		<cfargument name="showLineNumbers" required="false" type="boolean"
			hint="I specify if line numbers should be logged, this adds on extra processing time" />
		<cfargument name="parseCfscript" required="false" type="boolean"
			hint="I specify if CFScript should be parsed">
		
		<cfif isDefined("arguments.showDuplicates")>
			<cfset variables.showDuplicates = arguments.showDuplicates />
		</cfif>
		<cfif isDefined("arguments.showLineNumbers")>
			<cfset variables.showLineNumbers = arguments.showLineNumbers />
		</cfif>
		<cfif isDefined("arguments.parseCFscript")>
			<cfset variables.parseCFscript = arguments.parseCFscript />
		</cfif>
		<cfset variables.fileParseText = arguments.fileParseText />
		
		<cfreturn this>
			
	</cffunction>

	<cffunction name="runVarscoper" access="public" output="false" returntype="void"
		hint="I run the file parsing process and populate structs that represent scoped variables within the cfc being parsed">
		<cfset var currentPositionInFile 		= 1 />
		<cfset var functionREfind				= "" />
		<cfset var functionInnerText			= "" />
		<cfset var currentPositionVarFind		= 0 />
		<cfset var functionNameRE				= "" />
		<cfset var functionTagRE				= "" />
		<cfset var functionName					= "" />
		<cfset var varREFind					= "" />
		<cfset var varVariableName				= "" />
		<cfset var positionEndOfVarFind			= "" />
		<cfset var variableREFind				= "" />
		<cfset var tempVaredStruct				= "" />
		<cfset var tempUnVaredStruct			= "" />
		<cfset var RegExCFsetVar				= "<cfset+[\s]+var+[\s]+[a-zA-Z0-9_\[\]\.\s]+\=(.*?)\>" />
		<cfset var RegExCffunction				= "<\s?cffunction\b[^>]*>(.*?)</\s?cffunction\s?>" />
		<cfset var tempCurrentFunctionStruct	= "" />
		<cfset var tagTypeIdx					= "" />
		<cfset var findVarsResult				= "" />

		
		<!--- Use a RE to find text within the first cffunction, do this once here and once at the bottom of the loop so we can use a condition loop --->
			<!--- only run if a comment is found --->
			
			<!--- Stripping out comments is going to take some more work --->
			<!--- 			
			<cfif Find("<! ---", fileParseText)>
				<cfset variables.fileParseText = fileParseText.replaceAll("[^\r\n\t\-](?=[^\!]*\-\-\-)","") >
			</cfif> --->
			
			<cfset functionREfind = ReFindNoCase(RegExCffunction,fileParseText,currentPositionInFile,true)>
		
			<!--- Keep looping over the file until we have found all functions --->
			<cfloop condition="functionREfind.POS[1] NEQ 0">
				<cftry>
					<cfset functionTagRE = ReFindNoCase("<cffunction(.*?)\>",fileParseText,currentPositionInFile,true)>
	
					<cfif findNoCase("name",mid(fileParseText,functionTagRE.POS[1],functionTagRE.LEN[1])) GT 0>
						<cfset functionNameRE = ReFindNoCase('name(\s?)+\=(\s?)["''][^"\r\n]*["'']',fileParseText,functionTagRE.POS[1],true) />
					<cfelse>
						<cfthrow type="functionWithoutName">
					</cfif>
	
					<!--- Isolate the FunctionName for reference in the global struct --->
					<cfset functionNameRE = ReFindNoCase('name(\s?)+\=(\s?)["''][^"\r\n]*["'']',fileParseText,functionTagRE.POS[1],true) />
					<cfset functionName = mid(fileParseText,functionNameRE.POS[1],functionNameRE.LEN[1]) />
					<!--- Remove the variable name --->
					<cfset functionName = replaceNoCase(functionName,"name","")>
					<!--- Remove all equals, single and double quotes to isolate the variable created --->
					<cfset functionName = ReReplaceNoCase(functionName,'["''=]',"","all")>
			
					<cfset arrayAppend(variables.allFunctionsScanned,functionName) />
					<cfset variables.currentFunctionName = functionName />
					<cfset tempCurrentFunctionStruct = structNew() />
					<cfset tempCurrentFunctionStruct.functionName = functionName />
					
					<cfset variables.currentFunctionLineCount = variables.currentFunctionLineCount + countNumberOfLines(stringToParse:mid(fileParseText,variables.currentLineCountPosition,functionREfind.POS[1]-variables.currentLineCountPosition)) />
					<cfset tempCurrentFunctionStruct.lineNumber	= variables.currentFunctionLineCount />
					<cfset variables.tempUnscopedArray = arrayNew(1) />
					
					<cfset variables.currentLineCountFuncPos = functionREfind.POS[1] />
	
					<!--- set functionInnerText to return a string of everything contained within the current function --->
					<cfset functionInnerText = mid(fileParseText,functionREfind.POS[1],functionREfind.LEN[1])>
					
					<!--- Start parsing at position 1 within the current function string --->
					<cfset currentPositionVarFind = 1>
					
					<cfset variables.varscoperStruct["#functionName#"] = structNew() />
					<!--- Create a struct to identify all variables that have been correctly var-ed within this function --->
					<cfset variables.varscoperStruct["#functionName#"].varedStruct = structNew() />
					<cfset tempVaredStruct = variables.varscoperStruct["#functionName#"].varedStruct />
	
					<!--- Create another struct to identify variables that don't exist in the current functions var-ed variables --->
					<cfset variables.varscoperStruct["#functionName#"].unVaredStruct = structNew() />
					<cfset tempUnVaredStruct = variables.varscoperStruct["#functionName#"].unVaredStruct />
					
					<!--- findVars processes a string and returns a struct containing all variables set by vars as well as the line number of the end block for vars --->
					<cfset findVarsResult = findVars(functionInnerText) />
					
					<cfset structAppend(variables.varscoperStruct["#functionName#"].VaredStruct,findVarsResult.variableNames) />
					
					<!--- Set the position that we ended looking for vars --->
					<cfset positionEndOfVarFind = findVarsResult.endVarLine />
					
					<cfset findCFsetVariables(currentFunctionName:functionName,stringToParse=functionInnerText,positionToStart=positionEndOfVarFind) />
					
					<cfif variables.parseCFscript>
						<cfset findCFscriptVariables(currentFunctionName:functionName,stringToParse=functionInnerText,positionToStart=positionEndOfVarFind) />
					</cfif>
					
					<cfloop from="1" to="#arrayLen(variables.tagTypes)#" index="tagTypeIdx">

						<cfset findVarsByTag(currentFunctionName:functionName,tagName:getToken(variables.tagTypes[tagTypeIdx],1,':'),variableName:getToken(variables.tagTypes[tagTypeIdx],2,':'),tagAcceptAttribute:getToken(variables.tagTypes[tagTypeIdx],3,':'),tagAcceptAttributeValue:getToken(variables.tagTypes[tagTypeIdx],4,':'),stringToParse=functionInnerText,positionToStart=positionEndOfVarFind) />
						
					</cfloop>
					
	
					<!--- Done finding vars, lets append this to the array --->
					<!--- Only add functions where we have unscoped vars --->
					<cfif NOT arrayIsEmpty(variables.tempUnscopedArray) >
						<cfset tempCurrentFunctionStruct.unScopedArray = variables.tempUnscopedArray />
						<cfset arrayAppend(variables.OrderedUnVarArray,tempCurrentFunctionStruct) />
					</cfif>
	
					<cfcatch type="functionWithoutName">
					<!--- Found a function without a name, TODO: what to throw here? --->
						<cfrethrow>
					</cfcatch>
				</cftry>
				<cfset variables.currentLineCountPosition = functionREfind.POS[1] />
				<cfset currentPositionInFile = functionREfind.POS[1] + functionREfind.LEN[1] />
				<cfset functionREfind = ReFindNoCase(RegExCffunction,fileParseText,currentPositionInFile,true)>

			</cfloop>
		<!--- End looping over functions --->

		
	</cffunction>
	
	<cffunction name="findVars" output="false" returntype="struct"
				hint="I process a string (generally a block within a function) and return a struct of variables set with var statements">
		<cfargument name="stringToProcess" required="false" type="string">
		
		<cfset var RegExCFsetVar				= '<cfset+[\s]+var+([\s])+[a-zA-Z0-9_\[\"\''\]\##\.\s]+\=(.*?)\>' />
		<cfset var currentPositionVarFind = 1 />
		<cfset var returnStruct = structNew() />
		<cfset var varVariableName = "" />
		<cfset var tempVaredStruct = structNew() />
		<cfset var varREFind	= "" />
		<cfset var currentPositionVariableFind = "" />
		<cfset var VariableNameCfset	= "" />
		
		<cfset var variableCFScriptDelim=" #chr(13)##chr(9)##chr(8)#">
		<cfset var variableCFScriptStart = ""/>
		<cfset var variableCFScriptEND = ""/>
		<cfset var variableCFScriptText = ""/>
		<cfset var variableCFScriptTextTmp = ""/>
		<cfset var variableCFScriptCmd = ""/>
		<cfset var variableCFcommentSTART = "" />
		<cfset var variableCFcommentEND =""/>
		
		<!--- Loop over RegEx to find all variables that have been correctly var-ed within this cffunction --->
		<cfset varREFind = ReFindNoCase(RegExCFsetVar,arguments.stringToProcess,currentPositionVarFind,true)>
		<cfloop condition="varREFind.POS[1] NEQ 0">
			<!--- set varVariableName to the cfset tag --->
			<cfset varVariableName = mid(arguments.stringToProcess,varREFind.POS[1],varREFind.LEN[1])>
			<!--- strip the cfset code to isolate the variable name --->
			<cfset varVariableName = trim(reReplaceNoCase(left(varVariableName,find("=",varVariableName)-1),"<cfset+[\s]+var+[\s]",""))>
			
			<!--- if the variable a good variable name? --->
			<cfif isGoodVariableName(varVariableName)>
				<!--- add this variable to the var struct - we will set all variables to unused--->
				<!--- may use this in the future to identify orphaned vars--->
				<cfset tempVaredStruct["#varVariableName#"] = "unused">
			</cfif>
			
			<!--- Update the current parsing position to continue from the end of the cfset --->
			<cfset currentPositionVarFind = varREFind.POS[1] + varREFind.LEN[1]>

			<cfset varREFind = ReFindNoCase(RegExCFsetVar,arguments.stringToProcess,currentPositionVarFind,true)>
		</cfloop>
		
					
		<!--- Now start looping over all cfscript statements to identify variables that are being set --->
		
		<cfset currentPositionVariableFind = 1 />
		<cfif variables.parseCFscript>
			<cfset variableCFScriptStart = FindNoCase("<CFS"&"CRIPT>",arguments.stringToProcess,currentPositionVariableFind)/>
				
				<cfloop condition="variableCFScriptStart NEQ 0">
					<!--- Identify the cfscript statement --->
					<cfset variableCFScriptEND = FindNoCase("</CFS"&"CRIPT>",arguments.stringToProcess, variableCFScriptStart+1)/>
					
					
					<cfif variableCFScriptEND neq 0>
						<cfset variableCFScriptText=""/>
						
						<cfset variableCFScriptTextTmp =mid(arguments.stringToProcess, variableCFScriptSTART + len('<cfs'&'cript>'), 
									variableCFScriptEND-variableCFScriptSTART- len('<cfsc'&'ript>') )/>
									
						<!--- change to use unix style lines endings --->			
						<cfset variableCFScriptTextTmp =Replace(variableCFScriptTextTmp,"#chr(13)##chr(10)#",chr(13),"ALL")/>
				
						<!--- clean script --->
						<cfset variableCFScriptTextTmp = cleanScript(variableCFScriptTextTmp) />
										
						<cfloop index="variableCFScriptCmd" list="#variableCFScriptTextTmp#" delimiters=";">
							<cfset variableCFScriptCmd=ListFirst(ListChangeDelims(variableCFScriptCmd," ",variableCFScriptDelim),"=")/>
							<cfset variableCFScriptCmd=trim(variableCFScriptCmd)>
							<cfif ListFirst(trim(variableCFScriptCmd), " ") eq "var">
								<cfset VariableNameCfset=mid(variableCFScriptCmd,3,len(variableCFScriptCmd))/>
								<cfset VariableNameCfset=trim(ListGetAt(variableCFScriptCmd,2, " "))/>
								<!--- Update the var-ed struct to note that we are using this var --->
								<cfset tempVaredStruct["#VariableNameCfset#"] = "not used">
							</cfif>
						</cfloop>
						<!--- Update the current parsing position to start from the end of the cfset statement --->
						<cfset currentPositionVariableFind = variableCFScriptEND>
						<cfset variableCFScriptStart = FindNoCase("<CFS"&"CRIPT>",arguments.stringToProcess,currentPositionVariableFind)>
					<cfelse>	
						<cfset variableCFScriptStart=variableCFScriptStart+len("<CFS"&"CRIPT>")>
					</cfif>
				</cfloop>
		
			
			<cfset currentPositionVariableFind = variableCFScriptEND />
	
		</cfif>
		
		<cfif currentPositionVarFind GT currentPositionVariableFind>
			<cfset returnStruct.endVarLine = currentPositionVarFind>
		<cfelse>
			<cfset returnStruct.endVarLine = currentPositionVariableFind>
		</cfif>
		
		<!---TODO: if CF9 also look for "LOCAL" scoped variables in cfsets and cfscript
		<cfif ColdFusion9>
			
		</cfif>
		--->

		
		<!---TODO: endVarLine is no longer valid as vars can appear anywhere in CF9 --->
		<cfset returnStruct.endVarLine = currentPositionVarFind>		
		<cfset returnStruct.variableNames = tempVaredStruct />

		<cfif variables.cf9>
			<cfset returnStruct.endVarLine = 1 />
		</cfif>
		
		<cfreturn returnStruct>
	</cffunction>
	
	
	<cffunction name="findCFsetVariables" output="false" returntype="void"
		hint="I scope the function and process all variables that were created with a cfset">
			<cfargument name="stringToParse" type="string" hint="I am the block of text that will be parsed to find unscoped vars">
			<cfargument name="positionToStart" type="numeric" hint="I am the starting position, this is generally right after the var-ed variables">
			<cfargument name="currentFunctionName" type="string" hint="I am the name of the current function that is being parsed" >
			
			<cfset var REcfset = '<cfset+[\s]+[a-zA-Z0-9_\[\"\''\]\##\.\s\(\)]+\=(.*?)\>' />
			
			<cfset var variableREFind = "" />

			<cfset var VariableNameCfset = "" /> 
			<cfset var VariableNameCfsetIsolate="" /> 

			<cfset var currentPositionVariableFind = arguments.positionToStart />
			<cfset var functionInnerText = arguments.stringToParse />
			<cfset var tempVaredStruct = variables.varscoperStruct["#arguments.currentFunctionName#"].varedStruct />
			<cfset var tempUnVaredStruct = variables.varscoperStruct["#arguments.currentFunctionName#"].unVaredStruct />
						
			<!--- Now start looping over all cfset statements to identify variables that are being set --->
			<cfset variableREFind = ReFindNoCase(REcfset,functionInnerText,currentPositionVariableFind,true)>
			<cfloop condition="variableREFind.POS[1] NEQ 0">
				<!--- Identify the cfset statement --->
				<cfset VariableNameCfset = mid(functionInnerText,variableREFind.POS[1],variableREFind.LEN[1])>
				<!--- Isolate the name of the variable being set --->
				<cfset VariableNameCfsetIsolate = trim(ReReplaceNoCase(left(VariableNameCfset,find("=",VariableNameCfset)-1),"<cfset+[\s]",""))>
				
				<!--- Check to see if this is properly scoped already, make sure to check dot and array notation --->
				<cfset VariableNameCfsetIsolate = ListFirst(ListFirst(VariableNameCfsetIsolate,'.'),'[') />
				
				<!--- string leading and trailing quotes and pounds --->
				<cfset VariableNameCfsetIsolate = stripLeadingAndTrailingQuotesAndPoundsFromVariableName(VariableNameCfsetIsolate) />
				
				<!--- TODO: this is a bit of a hack to account for vars appearing anywhere in the function in CF9 --->
				<cfif variables.cf9 AND refindNoCase("var+[\s]",VariableNameCfsetIsolate)>
					<cfset VariableNameCfsetIsolate = ReReplaceNoCase(VariableNameCfsetIsolate,"var+[\s]","") />
				</cfif>
				
				<!--- if the variable a good variable name? --->
				<cfif isGoodVariableName(VariableNameCfsetIsolate)>
					<cfif structKeyExists(tempVaredStruct,"#VariableNameCfsetIsolate#")>
						<!--- Update the var-ed struct to note that we are using this var --->
						<cfset tempVaredStruct["#VariableNameCfsetIsolate#"] = "used">
					<cfelse>
						<!--- Log the unvared struct, just the root, before dot or array notation --->
						<cfset addToUnVarArray(variableName:"#ListFirst(ListFirst(VariableNameCfsetIsolate,'['),'.')#",VariableContext:VariableNAmeCfSet,textPositionInFunction:variableREFind.POS[1]) />
						<cfset tempUnvaredStruct["#ListFirst(ListFirst(VariableNameCfsetIsolate,'['),'.')#"] = VariableNameCfset />
					</cfif>
				</cfif>
				
				<!--- Update the current parsing position to start from the end of the cfset statement --->
				<cfset currentPositionVariableFind = variableREFind.POS[1] + variableREFind.LEN[1]>
				<cfset variableREFind = ReFindNoCase(REcfset,functionInnerText,currentPositionVariableFind,true)>
			</cfloop>
		
	</cffunction>
	
	
	<cffunction name="findCFscriptVariables" output="false" returntype="void"
		hint="I scope the function and process all variables that were created within a cfscript block">
			<cfargument name="stringToParse" type="string" hint="I am the block of text that will be parsed to find unscoped vars">
			<cfargument name="positionToStart" type="numeric" hint="I am the starting position, this is generally right after the var-ed variables">
			<cfargument name="currentFunctionName" type="string" hint="I am the name of the current function that is being parsed" >
			
			<cfset var REcfscript = "<\s?cfscript\b[^>]*>(.*?)</\s?cfscript\s?>" />
			
			<cfset var currentPositionVariableFind = arguments.positionToStart />
			<cfset var functionInnerText = arguments.stringToParse />
			<cfset var tempVaredStruct = variables.varscoperStruct["#arguments.currentFunctionName#"].varedStruct />
			<cfset var tempUnVaredStruct = variables.varscoperStruct["#arguments.currentFunctionName#"].unVaredStruct />
			<cfset var cfscriptArray = ""/>
			<cfset var setStatementArray = ""/>
			<cfset var variableNameSetIsolate = ""/>
			<cfset var cfscriptIdx = ""/>
			<cfset var setStatementIdx = ""/>
			
			<!--- cfscript array is an array of all cfscript blocks --->
			<cfset cfscriptArray = ReParserLoop(textToParse:functionInnerText,RegularExpression:REcfscript) />

			<cfloop from="1" to="#arrayLen(cfscriptArray)#" index="cfscriptIdx">
				
				<!--- clean script --->
				<cfset cfscriptArray[cfscriptIdx].TEXT = cleanScript(cfscriptArray[cfscriptIdx].TEXT) />
				
				<cfset setStatementArray = ReParserLoop(textToParse:cfscriptArray[cfscriptIdx].TEXT,RegularExpression:'[a-zA-Z0-9_\[\"\''\]\-\(\)\##\.\+\s]*?\=[\w\D]*?;(\s.*?)')>				
				
				<!--- Loop over all potential set statements --->
				<cfloop from="1" to="#arrayLen(setStatementArray)#" index="setStatementIdx">
					<!--- Script block could contain var and non-var statements, ignore the vars --->
					<cfif ReFindNoCase("[\s]+var+[\s]",setStatementArray[setStatementIdx].TEXT) EQ 0>
	
						<!--- Strip out else statements if they are first.  Else is reserved word in cfscript and you could have a situation where you have if(variable) foo=1;else bar=1; --->
						<cfset variableNameSetIsolate = setStatementArray[setStatementIdx].TEXT.replaceAll("else+[\s]","")>
						
						<!--- make sure we have a variable to parse --->
						<cfif find("=",variableNameSetIsolate)-1 GT 0>
						
							<!--- Check to see if this is properly scoped already, make sure to check dot and array notation --->
							<cfset variableNameSetIsolate = left(variableNameSetIsolate,find("=",variableNameSetIsolate)-1) />
							<cfset VariableNamesetIsolate = trim(ListFirst(ListFirst(VariableNamesetIsolate,'.'),'[')) />
							
							<!--- string leading and trailing quotes and pounds --->
							<cfset VariableNamesetIsolate = stripLeadingAndTrailingQuotesAndPoundsFromVariableName(VariableNamesetIsolate) />
	
							<!--- if the variable a good variable name? --->
							<cfif isGoodVariableName(VariableNamesetIsolate)>
								<cfif structKeyExists(tempVaredStruct,"#VariableNamesetIsolate#")>
									<!--- Update the var-ed struct to note that we are using this var --->
									<cfset tempVaredStruct["#VariableNamesetIsolate#"] = "used">
								<cfelse>
									<!--- Log the unvared struct, just the root, before dot or array notation --->
									<cfset addToUnVarArray(variableName:"#VariableNamesetIsolate#",VariableContext:setStatementArray[setStatementIdx].TEXT,textPositionInFunction:cfScriptArray[cfscriptIdx].POS+setStatementArray[setStatementIdx].POS+setStatementArray[setStatementIdx].LEN) />
									<cfset tempUnvaredStruct["#VariableNamesetIsolate#"] = setStatementArray[setStatementIdx] />
							
								</cfif>
							</cfif>
						</cfif>
					</cfif>
				</cfloop>
				
			</cfloop>

	</cffunction>
	
	
	<cffunction name="findVarsByTag" output="false" 
		hint="I scope for tags that can create variables, (cfquery, cffile, etc)">
		<cfargument name="tagName" type="string" hint="I am the name of the tag">
		<cfargument name="variableName" type="string" hint="I am the name of the variable that needs to be checked in this tag">
		<cfargument name="tagAcceptAttribute" type="string" hint="I hold the possibly tag attribute that allows the tag to accept a variable (example: action='read' for cffeed)">
		<cfargument name="tagAcceptAttributeValue" type="string" hint="I hold the value that the tagAcceptAttribute uses to allow the tag to accept a variable">
		<cfargument name="stringToParse" type="string" hint="I am the block of text that will be parsed to find unscoped vars">
		<cfargument name="positionToStart" type="numeric" hint="I am the starting position, this is generally right after the var-ed variables">
		<cfargument name="currentFunctionName" type="string" hint="I am the name of the current function that is being parsed" >
		
		<cfset var currentPositionLoopFind = 0 />
		<cfset var loopREFind = "" />
		<cfset var functionInnerText = "" />
		<cfset var tagIsolationString = "" />
		<cfset var findVariableRE = "" />
		<cfset var variableNameIsolationString = "" />
		<cfset var tagNameRegEx = "<#arguments.tagName# +[a-zA-Z0-9\.\s]+\=(.*?)\>" />
		
		<cfset functionInnerText = arguments.stringToParse />
		<cfset currentPositionLoopFind = arguments.positionToStart />
		
		<!--- Find the first instance of this combo of tag/variable name --->
		<cfset loopREFind = ReFindNoCase(tagNameRegEx,functionInnerText,currentPositionLoopFind,true) />
	
			<!--- Loop as long as we find more instances of this tag --->
			<cfloop condition="loopREFind.POS[1] NEQ 0">
				<cftry>					
						<!--- Isolate this tag --->
						<!--- Remove all RT, NL and TABS to help with variable debug display --->
						<cfset tagIsolationString = ReReplaceNoCase(mid(functionInnerText,loopREFind.POS[1],loopREFind.LEN[1]), "[\r\n\t]", " ", "ALL") />
	
						<!--- Use a RE to find instance of the variable name statement --->
						<!--- This will find the variable name, then a value following the equals sign enclosed in single or double quotes --->
											
						<cfset findVariableRE = ReFindNoCase('(\s)#arguments.variableName#(\s?)\=(\s?)*(["'']?)[^"^''\r\n\s]*(["'']?)',tagIsolationString,1,true) />
						
						<!--- Flow
							1. Check to see if the tag:variable (attributes 1 & 2 within tagTypes array) attributes was found
							2a. Make sure tagAcceptAttribute is not empty
							2b. Make sure tagAcceptAttributeValue is not empty
							2c. Check to see if the tag has the proper tag action to accept a variable (attributes 3 & 4 within tagTypes array. 
							    If found then mark as a valid tag that can accept a variable and continue the varScoper check otherwise flag it as a tag that CREATES a variable (which does not need to be scoped)
						--->
						
								
						
						<cfif findVariableRE.POS[1] EQ 0 
							OR 
								(
									arguments.tagAcceptAttribute IS NOT ""
									AND
									arguments.tagAcceptAttributeValue IS NOT ""
									AND
									NOT REFindNoCase('(\s)#arguments.tagAcceptAttribute#(\s?)\=(\s?)(["'']?)#arguments.tagAcceptAttributeValue#(["'']?)',tagIsolationString,1)
								)
							>
							<!--- NOTE: I was throwing an exception here, but it was annoying seeing so many in the debug output --->
							<!--- <cfthrow type="unknownVariableType" > --->
							<!--- message="#arguments.variableName# does not exist within #arguments.tagName#" --->
						
						<cfelse>
							<!--- isolate the string that encloses this variable --->
							<cfset variableNameIsolationString = mid(TagIsolationString,findVariableRE.POS[1],findVariableRE.LEN[1])>
							<!--- Remove the variable name --->
							<cfset variableNameIsolationString = replaceNoCase(variableNameIsolationString,"#arguments.variableName#","")>
							<!--- Remove all equals, single and double quotes to isolate the variable created --->
							<cfset variableNameIsolationString = trim(ReReplaceNoCase(variableNameIsolationString,'["''=]',"","all"))>
		
							<!--- TODO: does this work specifyin multiple delimiters in one function call --->
							<cfset variableNameIsolationString = ListFirst(ListFirst(variableNameIsolationString,'['),'.')>
							
							<!--- string leading and trailing quotes and pounds --->
							<cfset variableNameIsolationString = stripLeadingAndTrailingQuotesAndPoundsFromVariableName(variableNameIsolationString) >
						
							<!--- Check to see if this is properly scoped already, make sure to check dot and array notation --->
							<cfif structKeyExists(variables.varscoperStruct["#arguments.currentFunctionName#"].varedStruct,"#variableNameIsolationString#")>
								<!--- Update the var-ed struct to note that we are using this var --->
								<cfset variables.varscoperStruct["#arguments.currentFunctionName#"].varedStruct["#variableNameIsolationString#"] = "used">
							
							<!--- Removed this code because it is handled abovewith the double listFirst --->
							<!---<cfelseif structKeyExists(variables.varscoperStruct["#arguments.currentFunctionName#"].varedStruct,"#ListFirst(variableNameIsolationString,'[')#")>
								<!--- May exist in array notation --->
								<!--- Not sure if this is even a valid case??  --->
								<cfset variables.varscoperStruct["#arguments.currentFunctionName#"].varedStruct["#ListFirst(variableNameIsolationString,'[')#"] = "used">
							<cfelseif structKeyExists(variables.varscoperStruct["#arguments.currentFunctionName#"].varedStruct,"#ListFirst(variableNameIsolationString,'.')#")>
								<!--- May exist in dot notation --->
								<cfset variables.varscoperStruct["#arguments.currentFunctionName#"].varedStruct["#ListFirst(variableNameIsolationString,'.')#"] = "used">  --->							
							
							<cfelse>
								<!--- Var doesn't EXIST!!! this may be bad, lets track it --->
					
								<cfset addToUnVarArray(variableName:variableNameIsolationString,VariableContext:tagIsolationString,textPositionInFunction:loopREFind.POS[1]) />
								<cfset variables.varscoperStruct["#arguments.currentFunctionName#"].unvaredStruct["#variableNameIsolationString#"] = tagIsolationString>
							</cfif>
						</cfif>
					<cfcatch type="unknownVariableType">
						<!--- We found a tag that exists without creating the given variable name i.e. looping over condition or query--->
						<!--- Exit Gracefully and continue to next loop --->
					</cfcatch>
					<cfcatch type="any">
						<cfrethrow>
					</cfcatch>
				</cftry>
				<!--- Find the next cfloop --->
				<cfset currentPositionLoopFind = loopREFind.POS[1] + loopREFind.LEN[1] />
				<cfset loopREFind = ReFindNoCase(tagNameRegEx,functionInnerText,currentPositionLoopFind,true) />
			</cfloop>
		
	</cffunction>
	
	<cffunction name="addToUnVarArray" access="private" output="false" returntype="void"
		hint="I add the found unVared variable to an array for the current function">
		
		<cfargument name="variableName" type="string" required="true" hint="I am the name of the unscoped variable">
		<cfargument name="variableContext" type="string" required="true" hint="I am the string representing the tag that the variable was eclosed in">
		<cfargument name="textPositionInFunction" type="numeric" required="false" hint="I am the character position where we found this variable, used to find line position" />
		<cfset var tempUnscopedStruct = structNew() />
		<cfset var foundLineNumber = 0 />
		
		<cfif listFindNoCase(variables.ignoredScopes,arguments.variableName) EQ 0>
			<cfif NOT structKeyExists(variables.varscoperStruct[variables.currentFunctionName].unVaredStruct,arguments.variableName) OR variables.showDuplicates>
				<cfset tempUnscopedStruct.variableName = arguments.variableName />
				<cfset tempUnscopedStruct.variableContext = arguments.variableContext />
				<!--- If a text position in the function is passed we can count number of lines from the beginning of the function to return line numbers --->
				<cfif isDefined("arguments.textPositionInFunction")>
					<cfset foundLineNumber = variables.currentFunctionLineCount	+ countNumberOfLines(stringToParse:mid(variables.fileParseText,variables.currentLineCountFuncPos,textPositionInFunction)) />
					<cfset tempUnscopedStruct.lineNumber = foundLineNumber />
				</cfif>
				
				<cfset arrayAppend(variables.tempUnscopedArray, tempUnscopedStruct) />
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="countNumberOfLines" access="private" output="false" returntype="numeric"
		hint="I return the number of line breaks that appear in the given string">
	
		<cfargument name="stringToParse" type="string" required="true" hint="I am the string that will be parsed">
		
		<cfset var hasMoreLines = true />
		<cfset var lineCheckLine = 1 />
		<cfset var totalLines = 0 />
		<cfset var lineFeedArray = "" />

		<cfif variables.showLineNumbers>
			<cfloop condition="hasMoreLines EQ true">
				<!--- Make chr(13) optional, found some cases where we only had chr(10) --->
				<cfset lineFeedArray = REFind("#chr(13)#?#chr(10)#",arguments.stringToParse,lineCheckLine,true) />
				<cfif lineFeedArray.POS[1] EQ 0>
					<cfset hasMoreLines = false />
				<cfelse>
					<cfset totalLines = totalLines + 1 />
					<cfset lineCheckLine = lineFeedArray.POS[1] + lineFeedArray.LEN[1] />
				</cfif>
			</cfloop>
			
			<cfreturn totalLines />	
		<cfelse>
			<cfreturn 0 />
		</cfif>

	</cffunction>
	
	<cffunction name="ReParserLoop" access="public" output="false" returntype="array"
		hint="I take a string and a regular expression, parse it and return an array of strings that match the RE">
		
		<cfargument name="textToParse" required="true" type="string" hint="I am the text that should be parsed">
		<cfargument name="regularExpression" required="true" type="string" hint="I am the regular expression that should be used to parse">
		<cfargument name="positionToStart" required="false" type="numeric" default="1" hint="I am the position that parsing should start at">
		
		<cfset var returnArray = arrayNew(1) />
		<cfset var returnStruct = structNew() />
		<cfset var currentPositionVariableFind = arguments.positionToStart />
		<cfset var variableREFind = "" />
		
		<!--- Now start looping over all cfset statements to identify variables that are being set --->
		<cfset variableREFind = ReFindNoCase(arguments.regularExpression,arguments.textToParse,currentPositionVariableFind,true)>
			
		<cfloop condition="variableREFind.POS[1] NEQ 0">
	
			<!--- reset struct --->
			<cfset returnStruct = structNew() />
			
			<!--- text and position --->
			<cfset returnStruct.TEXT = mid(arguments.textToParse,variableREFind.POS[1],variableREFind.LEN[1]) />
			<cfset returnStruct.POS = variableREFind.POS[1] />
			<cfset returnStruct.LEN = variableREFind.LEN[1] />
			
			<cfset arrayAppend(returnArray,returnStruct ) />
	
			<!--- Update the current parsing position to start from the end of the regular Expression --->
			<cfset currentPositionVariableFind = variableREFind.POS[1] + variableREFind.LEN[1]>
			<cfset variableREFind = ReFindNoCase(arguments.regularExpression,arguments.textToParse,currentPositionVariableFind,true)>
		</cfloop>
	
		<cfreturn returnArray>
	</cffunction>
	
	<cffunction name="isGoodVariableName" access="public" output="false" returntype="boolean"
		hint="I check to see if this is a good variable name">
		<cfargument name="variableName" type="string" required="true" />
		
		<cfset var REBadVariableChars = "[\;\(]" />
		
		<cfif REFindNoCase(REBadVariableChars, arguments.variableName, 1)>
			<cfreturn false />	
		</cfif>
		<cfreturn true />
		
	</cffunction>
	
	<cffunction name="stripLeadingAndTrailingQuotesAndPoundsFromVariableName" access="public" output="false" returntype="string">
		<cfargument name="variableName" type="string" required="true" />
		
		<cfset var variableNameIsolationString = arguments.variableName />
		<cfset var hasPoundAsFirstChar = false />
		
		<!--- clear out before and after "'s --->
		<!--- this catch is here for variables that are set like so "test.go#1#", which will remove the "'s from the variable --->
		<!--- let's check the left side first --->

		<cfif len(variableNameIsolationString) NEQ 1>
			<cfif left(variableNameIsolationString, 1) EQ '"'>
				<cfset variableNameIsolationString = right(variableNameIsolationString, len(variableNameIsolationString)-1) />
			</cfif>
	
			<!--- let's now work on the right --->
			<cfif right(variableNameIsolationString, 1) IS '"' >
				<cfset variableNameIsolationString = left(variableNameIsolationString, len(variableNameIsolationString)-1) />
			</cfif>
			
			<!--- clear out before and after #'s --->
			<!--- this catch is here for tags that can accept variables to help dictate their return variable name --->
			<!--- let's check the left side first --->
			<cfif left(variableNameIsolationString, 1) EQ "##"  >
				<cfset variableNameIsolationString = right(variableNameIsolationString, len(variableNameIsolationString)-1) />
				<!--- if there is a pound the beginning of the variable then we want to strip the one at the end --->
				<!--- set variable to true so we can do this later ---> 
				<cfset hasPoundAsFirstChar = true />
			</cfif>
			<!--- let's now work on the right --->
			<!--- only strip off the pound if there was one at the beginning of the variable --->
			<cfif right(variableNameIsolationString, 1) IS "##" AND hasPoundAsFirstChar>
				<cfset variableNameIsolationString = left(variableNameIsolationString, len(variableNameIsolationString)-1) />
			</cfif>
		</cfif>
		
		<cfreturn variableNameIsolationString />
	
	</cffunction>
	
	<cffunction name="cleanScript" access="public" output="false" returntype="string"
		hint="I clean out script that could be within the string that could cause variable parsing issues">
		<cfargument name="textToClean" required="true" type="string" hint="I am the string that is going to be cleaned" />
		
		<cfset var text = arguments.textToClean />
		
		<!--- <cfset text = text.ReplaceAll("(<\s?cfscript\b[^>]*>|</\s?cfscript\s?>)","")> --->
		
		<!--- strip comments --->
		<cfset text = text.ReplaceAll("//(.*?)(?<!\)\;)#chr(13)#?#chr(10)#","") />
		
		<!--- This is a rockstar regex --->
		<cfset text = rereplaceNoCase(text,'(/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+/)','','all')/> 		
		<!--- strip out /* type comments */ --->
		<!---<cfset text = text.ReplaceAll("(?<!/)[^\r\n\s](?=[^/*]*\*/\s)","") />
		<!--- regex above strips between comments, but doesn't erase them --->
		<cfset text = replace(text,"/*","","all") />
		<cfset text = replace(text,"*/","","all") />--->
		
		<!--- strip out if statements ($custom change:hkl)
					quick and dirty, used for cases like
						if() x = y;
				 --->		
		<cfset text = REReplaceNoCase(text,"if[ ]*\(+(.*?)\)+[\s\{]*?[#chr(13)#?#chr(10)#]","","all")>

		<!--- Strip out for loops at start of statement, this is needed after Harry's fixes: ms --->
		<cfset text = text.ReplaceAll("for\s?\(","")>
		
		<!--- strip out variable sets within function calls ($custom:hkl)
			quick and dirty, used for cases like
				method(a=x, b=y);
		 --->
		<cfset text = text.ReplaceAll("\((.*?)\)","")>
                             
		<!--- strip out bracket statements ($custom:hkl)
			quick and dirty, used for cases like
				stTest["mykey"] = value;
		 --->
		<!--- remove all returns --->
		<cfset text = REReplaceNoCase(text,"[\;\>]+\s*return\s(.*?)+;","","all")>
		
		<cfreturn text />
	</cffunction>
	
	<cffunction name="getResultsStruct" access="public" output="false" returntype="struct" 
		hint="I return the results of scraping the vars in a struct">
		
		<cfreturn variables.varscoperStruct />
	</cffunction>
	
	<cffunction name="getResultsArray" access="public" output="false" returntype="array"
		hint="I am an ordered array of all the results that were found">
		<cfreturn variables.OrderedUnVarArray />
	</cffunction>
	
	<cffunction name="getAllFunctionsScanned" access="public" output="false" returntype="Array"
		hint="Returns an array of all functions that were processed">
		<cfreturn variables.allFunctionsScanned />	
	</cffunction>
	
</cfcomponent>