<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.cacheKey" type="string" default="" />
	<cfparam name="attributes.timespan" type="string" default="#createTimeSpan(0,0,0,60)#" />
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#"/>
	<!--- figure out if we are in the CMS context based on content --->
	
	<cfif !isNull(attributes.hibachiScope.getContent())>
		<cfset attributes.cacheKey = ""/>
		<cfset attributes.cacheKey &= attributes.hibachiScope.getDao('hibachiDao').getApplicationKey()/>
		<cfset attributes.cacheKey &= attributes.hibachiScope.site().getSiteCode()/>
		<cfset attributes.cacheKey &= attributes.hibachiScope.getContent().getUrlTitlePath()/>
		<cfset attributes.cacheKey &= CGI.QUERY_STRING/> 
		<cfset attributes.cacheKey = hash(attributes.cacheKey,'MD5')/>
		
		
		<cfset attributes.timespan = createTimeSpan(0,0,0,"#attributes.hibachiScope.getContent().setting('contentTemplateCacheInSeconds')#")/>
		
	</cfif>
	<cfif attributes.timespan eq 0>
		<cfcache action="flush" id="#attributes.cacheKey#"/>
	</cfif>
	<!--- used to clear template cache --->
	<cfif !isNull(attributes.hibachiScope.getContent()) AND !isNull(attributes.hibachiScope.getContent().getUrlTitlePath())> 
		<cfset expireUrl= "*#attributes.hibachiScope.getContent().getUrlTitlePath()#?clearTemplateCache=true"/>
	</cfif>
	<cfif len(attributes.cacheKey)> 
		<cfcache name="cacheContent" action="get" id="#attributes.cacheKey#" timespan="#attributes.timespan#"/>
	</cfif> 
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
		<cfif len(attributes.cacheKey)> 
			<cfcache action="flush" id="#attributes.cacheKey#"/>
		</cfif>
	</cfif>
	
</cfif>

<cfif thisTag.executionMode is 'end'>
	
	<cfsavecontent variable="hibachiTagContent" >
		<cfoutput>#thisTag.generatedContent#</cfoutput>
	</cfsavecontent>
	
	<cfif len(attributes.cacheKey)> 
		<cfcache value="#hibachiTagContent#" action="put" id="#attributes.cacheKey#" timespan="#attributes.timespan#"/>
	</cfif> 	
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
