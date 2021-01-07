<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.createApiLog">
        
        CREATE TABLE `swapilog` (
          `apiLogID` varchar(32) NOT NULL,
          `requestIdentifier` varchar(32) DEFAULT NULL,
          `accountID` varchar(32) DEFAULT NULL,
          `apiLogType` varchar(10) DEFAULT NULL,
          `source` varchar(25) DEFAULT NULL,
          `targetUrl` longtext,
          `data` longtext,
          `header` longtext,
          `response` longtext,
          `statusCode` int(11) DEFAULT NULL,
          `responseTime` int(11) DEFAULT NULL,
          `createdDateTime` datetime DEFAULT NULL,
          PRIMARY KEY (`apiLogID`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
          
	</cfquery>
    <cfcatch >
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Create ApiLog Table (#cfcatch.detail#)">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script Create ApiLog Table had errors when running">
	<cfthrow detail="Part of Script Create ApiLog Table had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script Create ApiLog Table has run with no errors">
</cfif>
