<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "end">
	<cfset trimedContent = trim(thistag.generatedContent)>
	<cfset found = true />
	<cfloop condition="found eq true">
		<cfif left(trimedContent, 25) eq '<li class="divider"></li>'>
			<cfif len(trimedContent) gt 25>
				<cfset trimedContent = trim(right(trimedContent, len(trimedContent)-25)) />
			<cfelse>
				<cfset trimedContent = "" />
			</cfif>
		<cfelseif right(trimedContent, 25) eq '<li class="divider"></li>'>
			<cfif len(trimedContent) gt 25>
				<cfset trimedContent = trim(left(trimedContent, len(trimedContent)-25)) />
			<cfelse>
				<cfset trimedContent = "" />
			</cfif>
		<cfelse>
			<cfset found = false />	
		</cfif>
	</cfloop>
	<cfset thisTag.generatedContent = trimedContent />
</cfif>