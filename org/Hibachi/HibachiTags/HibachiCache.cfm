<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.cacheKey" type="string" default="" />
	<cfparam name="attributes.timespan" type="string" default="#createTimeSpan(0,0,0,60)#" />
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#"/>
	<!--- figure out if we are in the CMS context based on content --->
	
	<cfif !len(attributes.cacheKey) && !isNull(attributes.hibachiScope.getContent())>
		<cfset attributes.cacheKey = attributes.hibachiScope.getContent().getContentCacheKey()/>

		<cfset attributes.timespan = createTimeSpan(0,0,0,"#attributes.hibachiScope.getContent().setting('contentTemplateCacheInSeconds')#")/>		
	</cfif>
	<cfif attributes.timespan eq 0>
		<cfcache action="flush" id="#attributes.cacheKey#">
	</cfif>
	<!--- used to clear template cache --->
	<cfset expireUrl= "*#attributes.hibachiScope.getContent().getUrlTitlePath()#?clearTemplateCache=true"/>
	<cfcache name="cacheContent" action="get" id="#attributes.cacheKey#" timespan="#attributes.timespan#"><!--- /> breaks cfcache in cf10 ---> 
	
	<cfif !isNull(cacheContent)>
		<cfsavecontent variable="hibachiTagContent" >
			<cfoutput>#cacheContent#</cfoutput>
		</cfsavecontent>
		<cfset templateString = "\$\[\[insertUnCachedKey\]\]"/>
		<cfset uncachedStrings =  reMatchNoCase(templateString,hibachiTagContent)>
		<cfif arrayLen(uncachedStrings)>
			<cfset count = 1/>
			<cfloop array="#uncachedStrings#" index="value">
				<cfset hibachiTagContent = rereplace(hibachiTagContent,templateString,thisTag.attributes['contentData'][count].contentData,'one')/>
				<cfset count++/>
			</cfloop>
		</cfif>
		<cfoutput>#hibachiTagContent#</cfoutput>
		<cfexit>
	<cfelse>
		<cfcache action="flush" id="#attributes.cacheKey#"><!--- /> breaks cfcache in cf10 ---> 
	</cfif>
	
</cfif>

<cfif thisTag.executionMode is 'end'>
	
	<cfsavecontent variable="hibachiTagContent" >
		<cfoutput>#thisTag.generatedContent#</cfoutput>
	</cfsavecontent>
	<cfcache value="#hibachiTagContent#" action="put" id="#attributes.cacheKey#" timespan="#attributes.timespan#"><!--- /> breaks cfcache in cf10 ---> 
	
	<cfset templateString = "\$\[\[insertUnCachedKey\]\]"/>
	<cfset uncachedStrings =  reMatchNoCase(templateString,hibachiTagContent)>
	<cfif arrayLen(uncachedStrings)>
		<cfset count = 1/>
		<cfloop array="#uncachedStrings#" index="value">
			<cfset hibachiTagContent = rereplace(hibachiTagContent,templateString,thisTag.attributes['contentData'][count].contentData,'one')/>
			<cfset count++/>
		</cfloop>
	</cfif>
	
	<cfset thisTag.generatedContent = hibachiTagContent/>
</cfif>
