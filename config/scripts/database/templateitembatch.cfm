<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.templateitembatch">
        CREATE TABLE IF NOT EXISTS `swtemplateitembatch` (
            `templateItemBatchID` varchar(32) NOT NULL,
            `replacementFlag` boolean DEFAULT NULL,
            `createdDateTime` datetime DEFAULT NULL,
            `modifiedDateTime` datetime DEFAULT NULL,
            `createdByAccountID` varchar(32) DEFAULT NULL,
            `modifiedByAccountID` varchar(32) DEFAULT NULL,
            `templateItemBatchStatusTypeID` varchar(32) DEFAULT NULL,
            `replacementSkuID` varchar(32) DEFAULT NULL,
            `removalSkuID` varchar(32) DEFAULT NULL,
            `templateItemBatchName` varchar(255) DEFAULT NULL,
            `orderTemplateCollectionConfig` text DEFAULT NULL,
            PRIMARY KEY (`templateItemBatchID`),
            KEY `templateItemBatchStatusTypeID` (`templateItemBatchStatusTypeID`),
            CONSTRAINT `swtemplateitembatch_ibfk_1` FOREIGN KEY (`templateItemBatchStatusTypeID`) REFERENCES `swtype` (`typeID`),
            CONSTRAINT `swtemplateitembatch_ibfk_2` FOREIGN KEY (`removalSkuID`) REFERENCES `swsku` (`skuID`),
            CONSTRAINT `swtemplateitembatch_ibfk_3` FOREIGN KEY (`replacementSkuID`) REFERENCES `swsku` (`skuID`)
        )
    </cfquery>
    <cfcatch>
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Create template item batch table">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script templateitembatch had errors when running">
	<cfthrow detail="Part of Script templateitembatch had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script templateitembatch has run with no errors">
</cfif>
