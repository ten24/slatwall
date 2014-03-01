<cfset versionFile = getDirectoryFromPath(getBaseTemplatePath()) & "version.txt" />
<cfset version = trim(fileRead(versionFile)) />
<cfif listLen(version, ".") gt 3>
	<cfset this.datasource.name = "slatwall-develop" />
<cfelse>
	<cfset this.datasource.name = "slatwall-master" />
</cfif>