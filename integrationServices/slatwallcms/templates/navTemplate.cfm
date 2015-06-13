<cfoutput>
	<cfset adjust=0>
	<cfset current=0>
	<cfset link=''>
	<cfset itemClass=''>
	<cfset isCurrent=false>
	<cfset nest=''>
	<cfset subnav=false>
	<cfset theNav="">
	<cfset nestedArgs=structNew()>
	<cfset linkArgs=structNew()>
	<cfset started=false>
	
	<cfif isDefined("arguments.ulTopClass") and arguments.currDepth eq 1>
		<cfset arguments.class=arguments.ulTopClass>
	</cfif>
	
	<cfloop array="#arguments.contentCollection#" index="contentCollectionItem">
		<cfsilent>
			<!---<cfif len(arguments.subNavExpression)>
				<cfset subnav=evaluate(arguments.subNavExpression)>
			<cfelse>
				<cfset subnav=
				(
					(
						ListFind("Page,Folder,Calendar",rsSection.type)
						and arguments.openCurrentOnly 
						and ListFindNoCase(ArrayToList(this.crumbData[this.navSelfIdx].parentArray), rsSection.contentid)
					) or (
						ListFindNoCase("Page,Calendar",rsSection.type)
						and not arguments.openCurrentOnly
					)
				) 
				and arguments.currDepth lt arguments.viewDepth 
				and rsSection.type neq 'Gallery' 
				and not (rsSection.restricted and not session.mura.isLoggedIn) />
			</cfif>--->
		
			<cfset current=current+1>
			<!---<cfset nest=''>--->
			<!---<cfif subnav>
				<cfset nestedArgs.contentID=rssection.contentid>
				<cfset nestedArgs.currDepth=arguments.currDepth+1>
				<cfset nestedArgs.type=iif(rssection.type eq 'calendar',de('fixed'),de('default'))>
				<cfset nestedArgs.sortBy=rsSection.sortBy>
				<cfset nestedArgs.sortDirection=rsSection.sortDirection>
				<cfset nestedArgs.class="">
				<cfset nestedArgs.ulTopClass="">
				<cfset structAppend(nestedArgs,arguments,false)>
				<cfset nest=dspNestedNav(argumentCollection=nestedArgs) />
				<cfset subnav=subnav and find("<li",nest)>
			</cfif>--->
			
			<!---<cfif subnav and arguments.currDepth gt 1 and len(arguments.liHasKidsNestedClass)>
				<cfset itemClass=arguments.liHasKidsNestedClass>
			<cfelse>
				<cfset itemClass="">
			</cfif>--->
			
			<cfset itemClass="">

			<cfif current eq 1>
				<cfset itemClass=listAppend(itemClass,'first',' ')>
			</cfif>
			<cfif current eq arraylen(arguments.contentCollection)>
				<cfset itemClass=listAppend(itemClass,'last',' ')>
			</cfif>
			
			<cfset isCurrent=listFind(getHibachiScope().getContent().getContentIDPath(),"#contentCollectionItem.getContentID()#") />
		
			<cfif isCurrent and len(arguments.liCurrentClass)>
				<cfset itemClass=listAppend(itemClass,arguments.liCurrentClass," ")>
			</cfif>
			<!---<cfif subnav and len(arguments.liHasKidsClass)>
				<cfset itemClass=listAppend(itemClass,arguments.liHasKidsClass," ")/>
			</cfif>--->

			<cfset linkArgs=structNew()>
			<cfset linkArgs.aHasKidsClass=arguments.aHasKidsClass>
			<cfset linkArgs.aHasKidsAttributes=arguments.aHasKidsAttributes>
			<cfset linkArgs.aNotCurrentClass=arguments.aNotCurrentClass>
			<cfset linkArgs.aCurrentClass=arguments.aCurrentClass>
			<cfset linkArgs.aCurrentAttributes=arguments.aCurrentAttributes>
			<!---<cfset linkArgs.type=rsSection.type>
			<cfset linkArgs.filename=rsSection.filename>--->
			<cfset linkArgs.title=contentCollectionItem.getTitle()>
			<cfset linkArgs.content=contentCollectionItem>
			<cfset linkArgs.site=contentCollectionItem.getSite()>
			<!---<cfset linkArgs.target=rsSection.target>
			<cfset linkArgs.targetParams=rsSection.targetParams>
			
			<cfset linkArgs.querystring=arguments.querystring>
			<cfset linkArgs.isParent=subnav>--->
			<cfset link=addlink(argumentCollection=linkArgs)>
		</cfsilent>
		<cfif not started>
			<cfset started=true>
			<ul
				<cfif arguments.currDepth eq 1 and len(arguments.class)>
					class="#arguments.class#"
				<cfelse>
					<cfif len(arguments.ulNestedClass)>
						class="#arguments.ulNestedClass#"
					</cfif>
					<cfif len(arguments.ulNestedAttributes)> 
						#arguments.ulNestedAttributes#
					</cfif>
				</cfif>
			>
		</cfif>
		<li
			<cfif len(itemClass)> 
				class="#itemClass#"
			</cfif>
			<cfif len(arguments.liCurrentAttributes)> 
				#arguments.liCurrentAttributes#
			</cfif>
		>
			#link#
			<cfif subnav>
				#nest#
			</cfif>
		</li>
	</cfloop>
	<cfif started>
		</ul>
	</cfif>
</cfoutput>

<cffunction name="addlink" output="false" returntype="string">
	<!---<cfargument name="type" required="true">
	<cfargument name="filename" required="true">--->
	<cfargument name="title" required="true">
	<cfargument name="target" type="string"  default="">
	<cfargument name="targetParams" type="string"  default="">
	<cfargument name="content" required="true">
	<cfargument name="site" required="true">
	<cfargument name="querystring" type="string" required="true" default="">
	<!---<cfargument name="context" type="string" required="true" default="#application.configBean.getContext()#">
	<cfargument name="stub" type="string" required="true" default="#application.configBean.getStub()#">--->
	<cfargument name="indexFile" type="string" required="true" default="">
	<cfargument name="showMeta" type="string" required="true" default="0">
	<cfargument name="showCurrent" type="string" required="true" default="1">
	<cfargument name="class" type="string" required="true" default="">
	<cfargument name="complete" type="boolean" required="true" default="false">
	<cfargument name="id" type="string" required="true" default="">
	<cfargument name="aHasKidsClass" required="true" default="#this.aHasKidsClass#">
	<cfargument name="aHasKidsAttributes" required="true" default="#this.aHasKidsAttributes#">
	<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
	<cfargument name="aCurrentAttributes" required="true" default="#this.aCurrentAttributes#">
	<cfargument name="isParent" required="true" default="false">
	<cfargument name="aNotCurrentClass" required="true" default="#this.aNotCurrentClass#">
			
	<cfset var link ="">
	<cfset var href ="">
	<cfset var theClass =arguments.class>

	<!--- Supporting Old Arguments--->
	<cfif structKeyExists(arguments,'aHasKidsCustomString')>
		<cfset arguments.aHasKidsAttributes=arguments.aHasKidsCustomString>
	</cfif>
	<cfif structKeyExists(arguments,'aCurrentCustomString')>
		<cfset arguments.aCurrentAttributes=arguments.aCurrentCustomString>
	</cfif>
	<!--- --->

	<cfif arguments.showCurrent>
		<cfset arguments.showCurrent=listFind(arguments.content.getContentIDPath(),arguments.content.getContentID())>
	</cfif>
	<cfif arguments.showCurrent>					
		<cfset theClass=listAppend(theClass,arguments.aCurrentClass," ") />
	<cfelseif len(arguments.aNotCurrentClass)>
		<cfset theClass=listAppend(theClass,arguments.aNotCurrentClass," ") />
	</cfif>
	<cfif arguments.isParent>					
		<cfset theClass=listAppend(theClass,arguments.aHasKidsClass," ") />
	</cfif>
		
	<cfset href=createHREF(
		arguments.content
		)
	>
	<cfset link='<a href="#href#"#iif(len(arguments.target) and arguments.target neq '_self',de(' target="#arguments.target#"'),de(""))##iif(len(theClass),de(' class="#theClass#"'),de(""))##iif(len(arguments.id),de(' id="#arguments.id#"'),de(""))##iif(arguments.showCurrent,de(' #replace(arguments.aCurrentAttributes,"##","####","all")#'),de(""))##iif(arguments.isParent and len(arguments.aHasKidsAttributes),de(' #replace(arguments.aHasKidsAttributes,"##","####","all")#'),de(""))#>#HTMLEditFormat(arguments.title)#</a>' />
	<cfreturn link>
</cffunction>

<cffunction name="createHREF" returntype="string" output="false" access="public">
	<cfargument name="content" required="true" default="">
	<cfargument name="queryString" default="">
	<cfset var href="#arguments.content.getURLTitlePath()#"/>
	<cfset var tp=""/>
	<!---<cfset var begin=iif(
		arguments.complete or isDefined('variables.$') and len(variables.$.event('siteID')) and variables.$.event('siteID') neq arguments.siteID,
		de('http://#application.settingsManager.getSite(arguments.siteID).getDomain()##application.configBean.getServerPort()#'),
		de('')) />

	<cfif len(arguments.querystring) and not left(arguments.querystring,1) eq "?">
		<cfset arguments.querystring="?" & arguments.querystring>
	</cfif>

	<cfif not isDefined('arguments.bean') 
		and (
				(
					not len(arguments.filename) 
					and len(arguments.contentID) 
					and arguments.contentid neq '00000000000000000000000000000000001'
				)
			or 
				request.muraExportHTML and listFindNoCase("Link,File",arguments.type)
			)
		>
		<cfset arguments.bean=application.serviceFactory.getBean("content").loadBy(contentID=arguments.contentID,siteID=arguments.siteID)>
		<cfset argument.filename=arguments.bean.getFilename()>
	</cfif>
	
	<cfif isBoolean(application.configBean.getAllowUnicodeInFilenames()) and application.configBean.getAllowUnicodeInFilenames()>
		<cfset arguments.filename=urlEncodedFormat(arguments.filename)>
		<cfset arguments.filename=replace(arguments.filename,'%2F','/')>
	</cfif>
	
	<cfswitch expression="#arguments.type#">
		<cfcase value="Link,File">
			<cfif not request.muraExportHTML>
				<cfset href=HTMLEditFormat("#begin##arguments.context##getURLStem(arguments.siteid,'#arguments.filename#')##arguments.querystring#") />
			<cfelseif arguments.type eq "Link">
				<cfset href=arguments.bean.getBody()>
			<cfelse>
				<cfset href="#arguments.context#/#arguments.siteID#/cache/file/#arguments.bean.getFileID()#/#arguments.bean.getBody()#">
			</cfif>
		</cfcase>
		<cfdefaultcase>
			<cfset href=HTMLEditFormat("#begin##arguments.context##getURLStem(arguments.siteid,'#arguments.filename#')##arguments.querystring#") />
		</cfdefaultcase>
	</cfswitch>--->

	<cfreturn href />
</cffunction>