<!--- 
Author:		Tom de Manincor
Homepage:	http://yuicompressorcfc.riaforge.org/
--->

<cfcomponent displayname="YUICompressor" output="false">

	<cffunction name="init" access="public" output="false" returntype="YUICompressor">
		<cfargument	name="javaLoader" type="any" required="true" hint="JavaLoader object or path to JavaLoader CFC.">
		<cfargument	name="libPath" type="string" required="false" hint="absolute path to folder containing the library jars">
		<cfargument name="loadColdFusionClassPath" hint="Loads the ColdFusion libraries" type="boolean" required="No" default="false">
		<cfargument name="parentClassLoader" hint="(Expert use only) The parent java.lang.ClassLoader to set when creating the URLClassLoader" type="any" default="" required="false">
		<cfargument name="sourceDirectories" hint="Directories that contain Java source code that are to be dynamically compiled" type="array" required="No">
		<cfargument name="compileDirectory" hint="the directory to build the .jar file for dynamic compilation in, defaults to ./tmp" type="string" required="No" default="#getDirectoryFromPath(getMetadata(this).path)#/tmp">
		<cfargument name="trustedSource" hint="Whether or not the source is trusted, i.e. it is going to change? Defaults to false, so changes will be recompiled and loaded" type="boolean" required="No" default="false">
		
		<cfset variables.instance = structNew() /> 
		<cfset setupJavaLoader(argumentCollection = arguments) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- PUBLIC --->
	<cffunction name="getVersion" access="public" returntype="string" output="false">
		<cfreturn '0.2' />
	</cffunction>
	
	<cffunction name="getJavaLoader" access="public" returntype="any" output="false">
		<cfreturn instance.javaLoader />
	</cffunction>
	
	<cffunction name="compress" access="public" output="false" returntype="struct">
		<cfargument name="inputType" type="string" required="false" default="">
		<cfargument name="inputString" type="string" required="false" default="">
		<cfargument name="inputFilePath" type="string" required="false" default="">
		<cfargument name="outputFilePath" type="string" required="false" default="">
		<cfargument name="linebreak" type="numeric" required="false" default="-1" hint="The linebreak option is used in that case to split long lines after a specific column.">
		<cfargument name="munge" type="boolean" required="false" default="false" hint="Minify only. Do not obfuscate local symbols.">
		<cfargument name="verbose" type="boolean" required="false" default="false" hint="Display informational messages and warnings.">
		<cfargument name="preserveAllSemiColons" type="boolean" required="false" default="false" hint="Preserve unnecessary semicolons.">
		<cfargument name="disableOptimizations" type="boolean" required="false" default="false" hint="Disable all the built-in micro optimizations.">
		<cfargument name="charset" type="string" required="false" default="UTF-8" hint="If a supported character set is specified, the YUI Compressor will use it to read the input file.">
		
		<cfset var stReturn = structNew() />
		
		<cfset var joInput = '' />
		<cfset var joOutput = createObject('java','java.io.StringWriter').init() />
			
		<cfif len(arguments.inputFilePath) and fileExists(arguments.inputFilePath)>
			<cffile action="read" file="#arguments.inputFilePath#" variable="arguments.inputString" />
			<!--- detect input type from file extension --->
			<cfif not len(arguments.inputType) and listFindNoCase('js,css',listLast(arguments.inputFilePath,'.'))>
				<cfset arguments.inputType = listLast(arguments.inputFilePath,'.') />
			</cfif>
		</cfif>
		
		<cfset joInput = createObject('java','java.io.StringReader').init(arguments.inputString) />
		
		<cfif arguments.inputType eq 'js'>
			<cfset getJavaLoader().create('com.yahoo.platform.yui.compressor.JavaScriptCompressor').init(joInput,javacast('null','')).compress(joOutput,javaCast('int',arguments.linebreak),javaCast('boolean',arguments.munge),javaCast('boolean',arguments.verbose),javaCast('boolean',arguments.preserveAllSemiColons),javaCast('boolean',arguments.disableOptimizations)) />
		<cfelseif arguments.inputType eq 'css'>
			<cfset getJavaLoader().create('com.yahoo.platform.yui.compressor.CssCompressor').init(joInput).compress(joOutput, javaCast('int',arguments.linebreak)) />
		<cfelse>
			<cfthrow message="Invalid input type. If using inputString make sure to specify inputType. Only JS and CSS are supported." />
		</cfif>
		
		<cfset stReturn.results = joOutput.toString() />
		<cfset joOutput.close() />
		<cfset joInput.close() />
			
		<cfif len(arguments.outputFilePath)>
			<cffile action="write" file="#arguments.outputFilePath#" output="#stReturn.results#" charset="#arguments.charset#" />
		</cfif>
		
		<cfset stReturn.inputType = arguments.inputType />
		<cfset stReturn.inputFilePath = arguments.inputFilePath />
		<cfset stReturn.outputFilePath = arguments.outputFilePath />
		
		<cfset stReturn.uncompressed = len(arguments.inputString) />
		<cfset stReturn.compressed = len(stReturn.results) />
		<cfset stReturn.compression = (1 - (stReturn.compressed / stReturn.uncompressed)) * 100 />
		
		<cfreturn stReturn />
	</cffunction>
	
	<!--- PRIVATE --->
	<cffunction name="setupJavaLoader" access="private" returntype="void" output="false">
		<cfargument	name="javaLoader" type="any" required="true" hint="JavaLoader object or path to JavaLoader CFC.">
		<cfargument	name="libPath" type="string" required="false" hint="absolute path to folder containing the library jars">
		<cfargument name="loadColdFusionClassPath" hint="Loads the ColdFusion libraries" type="boolean" required="No" default="false">
		<cfargument name="parentClassLoader" hint="(Expert use only) The parent java.lang.ClassLoader to set when creating the URLClassLoader" type="any" default="" required="false">
		<cfargument name="sourceDirectories" hint="Directories that contain Java source code that are to be dynamically compiled" type="array" required="No">
		<cfargument name="compileDirectory" hint="the directory to build the .jar file for dynamic compilation in, defaults to ./tmp" type="string" required="No" default="#getDirectoryFromPath(getMetadata(this).path)#/tmp">
		<cfargument name="trustedSource" hint="Whether or not the source is trusted, i.e. it is going to change? Defaults to false, so changes will be recompiled and loaded" type="boolean" required="No" default="false">
	
		<cfset var fs = createObject('java','java.lang.System').getProperty('file.separator') />
		<cfset var jars =  '' />
		<cfset var iterator = '' />
		<cfset var file = '' />
		
		<!--- build paths for javaloader --->
		<cfif len(arguments.libPath) and directoryExists(arguments.libPath)>
			<cfdirectory action="list" filter="*.jar" directory="#arguments.libPath#" name="jars" />
			<cfif jars.recordCount>
				<cfset arguments.loadPaths = arrayNew(1) />
				<cfloop query="jars">
					<cfset arrayAppend(arguments.loadPaths,jars.directory & fs & jars.name)  />
				</cfloop>
			</cfif>
		</cfif>
		
		<!--- use existing instance of javaloader --->
		<cfif isObject(arguments.javaLoader)>
			<!--- load yui libraries --->
			<cfif isArray(arguments.loadPaths) and arrayLen(arguments.loadPaths)>
				<cfscript>
					iterator = arguments.loadPaths.iterator();
					while(iterator.hasNext())
					{
						file = createObject("java", "java.io.File").init(iterator.next());
						if(NOT file.exists())
						{
							throwException("javaloader.PathNotFoundException", "The path you have specified could not be found", file.getAbsolutePath() & " does not exist");
						}
						arguments.javaLoader.getURLClassLoader.addUrl(file.toURL());
					}
				</cfscript>
			</cfif>
			<cfset instance.javaLoader = arguments.javaLoader />
		<!--- create instance of javaloader and load yui librarires --->
		<cfelseif isValid('string',arguments.javaLoader) and len(arguments.javaLoader) and isArray(arguments.loadPaths) and arrayLen(arguments.loadPaths)>
			<cfset instance.javaLoader = createObject('component',arguments.javaLoader).init(argumentCollection = arguments) />
		</cfif>
	</cffunction>
	
</cfcomponent>