<cfoutput>
	<cfset currentIndex = 0 />
	<cfset filterCountGroupsCount = arraylen(thistag.filterCountGroups)/>
	<cfloop array="#thistag.filterCountGroups#" index="filterCountGroup">
		<cfset currentIndex++/>	
		<cfoutput>
			#filterCountGroup.htmlContent#
		</cfoutput>
		<!--- apply url data to main collection at the end --->
		<cfif currentIndex eq filterCountGroupsCount>
			<cfset filterCountGroup.collectionList.applyData(url)/>
		</cfif>
	</cfloop>
</cfoutput>
