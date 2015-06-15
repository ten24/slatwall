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

