<cfset local.scriptHasErrors = false />

<cftry>
	<cfquery name="local.ip2location">
		
		CREATE TABLE `ip2location`(
			`ip_from` DECIMAL(39,0) UNSIGNED NULL DEFAULT NULL,
			`ip_to` DECIMAL(39,0) UNSIGNED NOT NULL,
			`country_code` CHAR(2),
			`country_name` VARCHAR(64),
			INDEX `idx_ip_from` (`ip_from`),
			INDEX `idx_ip_to` (`ip_to`),
			INDEX `idx_ip_from_to` (`ip_from`, `ip_to`)
		);
		
		ALTER TABLE swsession
            LOCK=NONE,
            ALGORITHM=INPLACE,
            ADD COLUMN countryCode varchar(3) DEFAULT NULL;
	</cfquery>
	<cfcatch >
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - IP2Location (#cfcatch.detail#)">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script ip2location had errors when running">
	<cfthrow detail="Part of Script ip2location had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script ip2location has run with no errors">
</cfif>
