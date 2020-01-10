<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.updateDefaultLocation">
        UPDATE swlocation SET locationName = 'US Warehouse' , calculatedLocationPathName = 'US Warehouse', locationCode='usWarehouse', currencyCode='USD' WHERE locationID = '88e6d435d3ac2e5947c81ab3da60eba2'
    </cfquery>
    <cfquery name="local.insertCaWarehouse">
        INSERT INTO `swlocation` (`locationID`, `locationIDPath`, `locationName`, `activeFlag`, `remoteID`, `calculatedLocationPathName`, `createdDateTime`, `createdByAccountID`, `modifiedDateTime`, `modifiedByAccountID`, `locationAddressID`, `parentLocationID`, `locationCode`, `currencyCode`)
        VALUES
        	('a484e3441ab011ea9fa612bff9d404c8', 'a484e3441ab011ea9fa612bff9d404c8', 'CA Warehouse', 1, NULL, 'CA Warehouse', NULL, NULL, NULL, NULL, NULL, NULL, 'caWarehouse', 'CAD')
    </cfquery>
    <cfquery name="local.insertUkWarehouse">
        INSERT INTO `swlocation` (`locationID`, `locationIDPath`, `locationName`, `activeFlag`, `remoteID`, `calculatedLocationPathName`, `createdDateTime`, `createdByAccountID`, `modifiedDateTime`, `modifiedByAccountID`, `locationAddressID`, `parentLocationID`, `locationCode`, `currencyCode`)
        VALUES
        	('afd4055e1ab011ea9fa612bff9d404c8', 'afd4055e1ab011ea9fa612bff9d404c8', 'UK Warehouse', 1, NULL, 'UK Warehouse', NULL, NULL, NULL, NULL, NULL, NULL, 'ukWarehouse', 'GBP')
    </cfquery>
    <cfquery name="local.insertIrePolWarehouse">
        INSERT INTO `swlocation` (`locationID`, `locationIDPath`, `locationName`, `activeFlag`, `remoteID`, `calculatedLocationPathName`, `createdDateTime`, `createdByAccountID`, `modifiedDateTime`, `modifiedByAccountID`, `locationAddressID`, `parentLocationID`, `locationCode`, `currencyCode`)
        VALUES
        	('b57e048a1ab011ea9fa612bff9d404c8', 'b57e048a1ab011ea9fa612bff9d404c8', 'Ire/Pol Warehouse', 1, NULL, 'Ire/Pol Warehouse', NULL, NULL, NULL, NULL, NULL, NULL, 'irePolWarehouse', NULL)
	</cfquery>
    <cfcatch>
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Create warehouse locations">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script locations had errors when running">
	<cfthrow detail="Part of Script locations had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script locations has run with no errors">
</cfif>
