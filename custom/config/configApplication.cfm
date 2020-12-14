<cfset this.name = "slatwall" & hash(getCurrentTemplatePath()) />
<cfset this.datasource.name = "SlatwallDevelop" />
<cfset this.CORSEnabled = false />
<!--- CORS Whitelist: uses regex matching to test request origins against whitelist array--->
<cfset this.CORSWhitelist = [] />