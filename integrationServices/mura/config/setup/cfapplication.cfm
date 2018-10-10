
<!---[START_SLATWALL_CONFIG]--->
<cfset this.mappings["/Slatwall"] = "#this.mappings["/muraWRM"]#/Slatwall" />
<cfset this.mappings["/framework"] = "#this.mappings["/muraWRM"]#/Slatwall/org/Hibachi/framework" />
<cfset arrayAppend(this.ormSettings.cfclocation, "/Slatwall/model/entity") />
<cfset this.customTagPaths = listAppend(this.customTagPaths, "#this.mappings["/Slatwall"]#/tags") />
<cfset this.customTagPaths = listAppend(this.customTagPaths, "#this.mappings["/Slatwall"]#/org/Hibachi/HibachiTags") />
<!---[END_SLATWALL_CONFIG]--->