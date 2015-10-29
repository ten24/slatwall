<cfcomponent output="false" accessors="true" extends="HibachiService">
	
	<cffunction name="cfcookie">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		<cfargument name="expires" type="string" />
		<cfargument name="secure" type="boolean" default="false" />
		
		<cfif structKeyExists(arguments, "expires")>
			<cfcookie name="#arguments.name#" value="#arguments.value#" expires="#arguments.expires#" secure="#arguments.secure#" httponly="true">
		<cfelse>
			<cfcookie name="#arguments.name#" value="#arguments.value#" secure="#arguments.secure#" httponly="true">
		</cfif>
	</cffunction>
	
	<cffunction name="cfhtmlhead">
		<cfargument name="text" type="string" required="true" />
		<cfhtmlhead text="#arguments.text#">
	</cffunction>
	
	<cffunction name="cfinvoke" output="false">
		<cfargument name="component" type="any" required="true" hint="CFC name or instance." />
		<cfargument name="method" type="string" required="true" hint="Method name to be invoked." />
		<cfargument name="theArgumentCollection" type="struct" default="#structNew()#" hint="Argument collection to pass to method invocation." />

		<cfset var returnVariable = 0 />
		
		<cfinvoke
			component="#arguments.component#"
			method="#arguments.method#"
			argumentcollection="#arguments.theArgumentCollection#"
			returnvariable="returnVariable"
		/>

		<cfif not isNull( returnVariable )>
			<cfreturn returnVariable />
		</cfif>
	
	</cffunction>
	
	<cffunction name="cfmail" output="false">
		<cfargument name="from" type="string" required="true" />
		<cfargument name="to" type="string" required="true" />
		<cfargument name="subject" default="" />
		<cfargument name="body" default="" />
		<cfargument name="type" default="html" />
		
		<cftry>
			<cfmail attributeCollection="#arguments#">
				#arguments.body#
			</cfmail>
			<cfcatch type="any">
				<cfset logHibachiException(cfcatch) />
			</cfcatch>
		</cftry>

	</cffunction>
	
	<!--- The script version of http doesn't suppose tab delimiter, it throws error.
		Use this method only when you want to return a query. --->
	<cffunction name="cfhttp" output="false">
		<cfargument name="method" default="" />
		<cfargument name="url" default="" />
		<cfargument name="delimiter" default="" />
		<cfargument name="textqualifier" default="" />
		
		<cfhttp method="#arguments.method#" url="#arguments.url#" name="result" firstrowasheaders="true" textqualifier="#arguments.textqualifier#" delimiter="#arguments.delimiter#">
		
		<cfreturn result />
	</cffunction>
	
	<cffunction name="cfsetting" output="false">
		<cfargument name="enablecfoutputonly" type="boolean" default="false" />
		<cfargument name="requesttimeout" type="numeric" default="30" />
		<cfargument name="showdebugoutput" type="boolean" default="false" />
		
		<cfsetting attributecollection="#arguments#" />
	</cffunction>
	
	<cffunction name="cffile" output="false">
		<cfargument name="action" type="string" />
		
		<cfset var result = "" />
		<cfset var attributes = duplicate(arguments) />
		<cfset structDelete(attributes, "action") />
		
		<cffile attributecollection="#attributes#" action="#arguments.action#" result="result" >
		
		<cfreturn result />
	</cffunction>
	
	<cffunction name="cfdirectory" output="false">
		<cfargument name="action" type="string" />
		
		<cfset var result = "" />
		<cfset var attributes = duplicate(arguments) />
		<cfset structDelete(attributes, "action") />
		
		<cfdirectory attributecollection="#attributes#" action="#arguments.action#" name="result" >
		
		<cfreturn result />
	</cffunction>
	
	<cffunction name="cfcontent" output="false">
		<cfargument name="type" type="string" />
		<cfargument name="file" type="string" />
		<cfargument name="deletefile" type="boolean" default="false" />
		
		<cfcontent attributecollection="#arguments#"  />
	</cffunction>
	
	<cffunction name="cfheader" output="false">
		<cfargument name="name" type="string" />
		<cfargument name="value" type="string" />
		
		<cfheader attributecollection="#arguments#"  />
	</cffunction>
	
	<cffunction name="cfmodule">
		<cfargument name="name" type="string" />
		<cfargument name="template" type="string" />
		<cfargument name="attributeCollection" type="struct" required="true" />
		
		<cfset var returnContent = "" /> 
		<cfif structKeyExists(arguments, "name")>
			<cfsavecontent variable="returnContent">
				<cfmodule name="#arguments.name#" attributecollection="#arguments.attributeCollection#" />
			</cfsavecontent>
		<cfelseif structKeyExists(arguments, "template")>
			<cfsavecontent variable="returnContent">
				<cfmodule template="#arguments.template#" attributecollection="#arguments.attributeCollection#" />
			</cfsavecontent>
		</cfif>
		
		<cfreturn returnContent />
	</cffunction>
</cfcomponent>