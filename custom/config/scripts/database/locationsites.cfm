<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.locationSites">
        INSERT INTO `swlocationsite` (`siteID`, `locationID`)
        VALUES
        	('2c9280846974b77e016974ee40cb0019', 'a484e3441ab011ea9fa612bff9d404c8'),
        	('2c97808468a979b50168a97b20290021', '88e6d435d3ac2e5947c81ab3da60eba2'),
        	('2c9280846974b77e016974fe89070025', 'afd4055e1ab011ea9fa612bff9d404c8'),
        	('2c9280846974b77e016974fe999e002f', 'b57e048a1ab011ea9fa612bff9d404c8'),
        	('2c9280846974b77e016974fea1e90034', 'b57e048a1ab011ea9fa612bff9d404c8')
	</cfquery>
    <cfcatch>
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Add Location Sites">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script locationsites had errors when running">
	<cfthrow detail="Part of Script locationsites had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script locationsites has run with no errors">
</cfif>
