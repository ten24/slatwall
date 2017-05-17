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
		<cfset arguments.navClass=arguments.ulTopClass>
	</cfif>
	
	<cfloop array="#arguments.contentCollection#" index="contentCollectionItem">
		<cfsilent>
		
			<cfset current=current+1>
			
			<cfset itemClass="">

			<cfif current eq 1>
				<cfset itemClass=listAppend(itemClass,'first',' ')>
			</cfif>
			<cfif current eq arraylen(arguments.contentCollection)>
				<cfset itemClass=listAppend(itemClass,'last',' ')>
			</cfif>
			
			<cfset isCurrent=listFind(getHibachiScope().getContent().getContentIDPath(),"#contentCollectionItem.getContentID()#") />
		
			<cfif isCurrent and len(arguments.liActiveClass)>
				<cfset itemClass=listAppend(itemClass,arguments.liActiveClass," ")>
			</cfif>

			<cfset linkArgs=structNew()>
			<cfset linkArgs.aKidsClass=arguments.aKidsClass>
			<cfset linkArgs.aKidsAttributes=arguments.aKidsAttributes>
			<cfset linkArgs.aActiveClass=arguments.aActiveClass>
			<cfset linkArgs.aActiveAttributes=arguments.aActiveAttributes>
			<cfset linkArgs.title=contentCollectionItem.getTitle()>
			<cfset linkArgs.content=contentCollectionItem>
			<cfset linkArgs.site=contentCollectionItem.getSite()>
			<cfset link=addlink(argumentCollection=linkArgs)>
		</cfsilent>
		<cfif not started>
			<cfset started=true>
			<ul
				<cfif arguments.currDepth eq 1 and len(arguments.navClass)>
					class="#arguments.navClass#"
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
			<cfif len(arguments.liActiveAttributes)> 
				#arguments.liActiveAttributes#
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

