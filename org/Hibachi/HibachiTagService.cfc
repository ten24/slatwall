<cfcomponent output="false" accessors="true" extends="HibachiService">
	
	<cffunction name="cfcookie">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		<cfargument name="secure" type="boolean" default="false" />
		<cfargument name="httpOnly" type="boolean"  default="true" />	
		<cfargument name="expires" type="string" />
		<cfargument name="domain" type="string" />
		<!--- cfcookie cannot accept null arguments so using struct to make this easier to work with--->

		<cfif !structKeyExists(arguments, "domain") and len(getApplicationValue("hibachiConfig").sessionCookieDomain)>
			<cfset arguments.domain = getApplicationValue("hibachiConfig").sessionCookieDomain />
		</cfif>
		
		<cfset arguments = removeNullStructValues(arguments)>
		<cfcookie attributeCollection="#arguments#" />
	</cffunction>
	
	<cffunction name="cfimap">
		<cfargument name="action" default="GetHeaderOnly"/>
		<cfargument name="attachmentpath" default=""/>
		<cfargument name="Connection" default=""/>
		<cfargument name="Folder" default=""/>
		<cfargument name="GenerateUniqueFilenames" default=""/>
		<cfargument name="MaxRows" default=""/>
		<cfargument name="MessageNumber" default=""/>
		<cfargument name="Name" default=""/>
		<cfargument name="NewFolder" default=""/>
		<cfargument name="Password" default=""/>
		<cfargument name="Port" default=""/>
		<cfargument name="Recurse" default=""/>
		<cfargument name="Secure" default=""/>
		<cfargument name="Server" default=""/>
		<cfargument name="StartRow" default=""/>
		<cfargument name="StopOnError" default=""/>
		<cfargument name="Timeout" default=""/>
		<cfargument name="Uid" default=""/>
		<cfargument name="Username" default=""/>
		<cfargument name="delimiter" default=""/>
		<cfimap attributeCollection="#arguments#" />
	</cffunction>
	
	<cffunction name="removeNullStructValues" returntype="struct" >
		<cfargument name="oldStruct" type="struct">
		<cfset var newStruct = {}/>
		<cfloop collection="#arguments.oldStruct#" item="local.key">
			<cfif structKeyExists(arguments.oldStruct,local.key) AND NOT isNull(arguments.oldStruct[local.key])>
				<cfset newStruct[local.key] = arguments.oldStruct[local.key]/>
			</cfif>
		</cfloop>
		<cfreturn newStruct/>
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
		<cfargument name="cc" default="" />
		<cfargument name="bcc" default="" />
		<cfargument name="charset" default="" />
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
