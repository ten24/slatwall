<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.cacheKey" type="string" default="" />
	<cfparam name="attributes.timespan" type="string" default="#createTimeSpan(0,0,0,60)#" />
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#"/>
	<!--- figure out if we are in the CMS context based on content --->
	<cfif !structKeyExists(server,'lucee') && !structKeyExists(server,'railo')>
		<cfif !isNull(attributes.hibachiScope.getContent())>
			<cfset attributes.cacheKey &= attributes.hibachiScope.getContent().getContentCacheKey()/>
			<cfset attributes.timespan = createTimeSpan(0,0,0,"#attributes.hibachiScope.content().setting('contentTemplateCacheInSeconds')#")/>
			
		</cfif>
		
		<cfif structKeyExists(url,'clearTemplateCache')>
			<cfset attributes.timespan = 0/>
		</cfif>
		
		<cfif attributes.timespan neq 0>
		<!--- used to clear template cache --->
		<cfset expireUrl= "*#attributes.hibachiScope.content().getUrlTitlePath()#?clearTemplateCache=true"/>
		<cfcache action="flush" expireURL="#expireUrl#">
		<cfcache name="cacheContent" action="get" id="#attributes.cacheKey#" timespan="#attributes.timespan#">
		
		<cfif !isNull(cacheContent)>
		
			<cfsavecontent variable="hibachiTagContent" >
				<cfoutput>#cacheContent#</cfoutput>
			</cfsavecontent>
			<cfoutput>#hibachiTagContent#</cfoutput>
			<cfexit>
		</cfif>
	</cfif>
</cfif>
</cfif>

<cfif thisTag.executionMode is 'end'>
	
	<cfsavecontent variable="hibachiTagContent" >
		<cfoutput>#thisTag.generatedContent#</cfoutput>
	</cfsavecontent>
	<cfif !structKeyExists(server,'lucee') && !structKeyExists(server,'railo') && attributes.timespan neq 0>
		<cfcache value="#hibachiTagContent#" action="put" id="#attributes.cacheKey#" timespan="#attributes.timespan#">
	</cfif>
	<cfset thisTag.generatedContent = hibachiTagContent/>
</cfif>