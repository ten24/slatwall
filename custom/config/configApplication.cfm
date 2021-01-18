<cfset this.name = "StoneAndBerg" & hash(getCurrentTemplatePath()) />
<cfset this.datasource.name = "StoneAndBerg" />
<cfset this.CORSEnabled = true />
<!--- CORS Whitelist: uses regex matching to test request origins against whitelist array--->
<cfset this.CORSWhitelist = ['^http(s?):\/\/(.*\.)?stoneandberg\.com','^http(s?):\/\/(.*\.)?api\.stoneandberg\.com','^http(s?):\/\/(.*\.)?stoneandberg\.ten24dev\.com','^http(s?):\/\/(.*\.)?stoneandberg:8906','^http(s?):\/\/(.*\.)?stoneandberg:3006','^http(s?):\/\/(.*\.)?localhost:3006'] />