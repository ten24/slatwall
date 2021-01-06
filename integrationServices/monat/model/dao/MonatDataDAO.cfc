<cfcomponent extends="Slatwall.org.Hibachi.HibachiDAO">

	<cffunction name="updateGeoIPDatabase" output="false" returntype="void">
		<cfargument name="geoIPDatabase" type="any" required="true" />
		<cfset var rs = "" />
		
		<cftransaction>
		
			<cfquery name="local.truncate">
				delete from ip2location
			</cfquery>
			<cfset local.total = arguments.geoIPDatabase.recordCount /> 
			<cfset local.i = 1 /> 
			<cfset local.insertList = '' /> 
			<cfloop query="arguments.geoIPDatabase">
				<cfif listFind('US,GB,PL,IE,AU,CA', country_code)>
					<cfset local.i++ />
					<cfset local.insertList = listAppend(local.insertList, '(#ip_from#, #ip_to#, "#country_code#")')  /> 
				</cfif>
				<cfif local.i MOD 5000  AND listLen(local.insertList)>
					<cfquery name="local.rs">
						INSERT INTO ip2location (ip_from,ip_to,country_code) VALUES #local.insertList#
					</cfquery>
					<cfset local.insertList = '' />
				</cfif>
			</cfloop>
			
			<cfif listLen(local.insertList)>
				<cfquery name="local.rs">
					INSERT INTO ip2location (ip_from,ip_to,country_code) VALUES #local.insertList#
				</cfquery>
			</cfif>
		
		</cftransaction> 
		
	</cffunction>

</cfcomponent>