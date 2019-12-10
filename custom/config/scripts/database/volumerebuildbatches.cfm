<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.volumerebuildbatch">
        CREATE TABLE IF NOT EXISTS `swvolumerebuildbatch` (
            `volumeRebuildBatchID` varchar(32) NOT NULL,
            `createdDateTime` datetime DEFAULT NULL,
            `modifiedDateTime` datetime DEFAULT NULL,
            `createdByAccountID` varchar(32) DEFAULT NULL,
            `modifiedByAccountID` varchar(32) DEFAULT NULL,
            `volumeRebuildBatchStatusTypeID` varchar(32) DEFAULT NULL,
            `volumeRebuildBatchName` varchar(255) DEFAULT NULL,
            PRIMARY KEY (`volumeRebuildBatchID`),
            KEY `volumeRebuildBatchStatusTypeID` (`volumeRebuildBatchStatusTypeID`),
            CONSTRAINT `swvolumerebuildbatch_ibfk_1` FOREIGN KEY (`volumeRebuildBatchStatusTypeID`) REFERENCES `swtype` (`typeID`)
        )
    </cfquery>
    <cfquery name="local.volumerebuildbatchorder">
        CREATE TABLE IF NOT EXISTS `swvolumerebuildbatchorder` (
          `volumeRebuildBatchOrderID` varchar(32) NOT NULL DEFAULT '',
          `volumeRebuildBatchID` varchar(32) DEFAULT NULL,
          `orderID` varchar(32) DEFAULT NULL,
          `createdDateTime` datetime DEFAULT NULL,
          `modifiedDateTime` datetime DEFAULT NULL,
          `createdByAccountID` varchar(32) DEFAULT NULL,
          `modifiedByAccountID` varchar(32) DEFAULT NULL,
          PRIMARY KEY (`volumeRebuildBatchOrderID`),
          KEY `volumeRebuildBatchID` (`volumeRebuildBatchID`),
          KEY `orderID` (`orderID`),
          CONSTRAINT `swvolumerebuildbatchorder_ibfk_1` FOREIGN KEY (`volumeRebuildBatchID`) REFERENCES `swvolumerebuildbatch` (`volumeRebuildBatchID`),
          CONSTRAINT `swvolumerebuildbatchorder_ibfk_2` FOREIGN KEY (`orderID`) REFERENCES `sworder` (`orderID`)
        )
    </cfquery>
    <cfquery name="local.volumerebuildbatchorderitem">
        CREATE TABLE IF NOT EXISTS `swvolumerebuildbatchorderitem` (
          `volumeRebuildBatchOrderItemID` varchar(32) NOT NULL DEFAULT '',
          `volumeRebuildBatchOrderID` varchar(32) DEFAULT NULL,
          `orderItemID` varchar(32) DEFAULT NULL,
          `oldPersonalVolume` decimal(19,2) DEFAULT NULL,
          `newPersonalVolume` decimal(19,2) DEFAULT NULL,
          `oldTaxableAmount` decimal(19,2) DEFAULT NULL,
          `newTaxableAmount` decimal(19,2) DEFAULT NULL,
          `oldCommissionableVolume` decimal(19,2) DEFAULT NULL,
          `newCommissionableVolume` decimal(19,2) DEFAULT NULL,
          `oldRetailCommission` decimal(19,2) DEFAULT NULL,
          `newRetailCommission` decimal(19,2) DEFAULT NULL,
          `oldProductPackVolume` decimal(19,2) DEFAULT NULL,
          `newProductPackVolume` decimal(19,2) DEFAULT NULL,
          `oldRetailValueVolume` decimal(19,2) DEFAULT NULL,
          `newRetailValueVolume` decimal(19,2) DEFAULT NULL,
          `createdDateTime` datetime DEFAULT NULL,
          `modifiedDateTime` datetime DEFAULT NULL,
          `createdByAccountID` varchar(32) DEFAULT NULL,
          `modifiedByAccountID` varchar(32) DEFAULT NULL,
          `skuCode` varchar(255) DEFAULT NULL,
          `volumeRebuildBatchID` varchar(32) DEFAULT NULL,
          PRIMARY KEY (`volumeRebuildBatchOrderItemID`),
          KEY `volumeRebuildOrderID` (`volumeRebuildBatchOrderID`),
          KEY `orderItemID` (`orderItemID`),
          KEY `volumeRebuildBatchID` (`volumeRebuildBatchID`),
          CONSTRAINT `swvolumerebuildbatchorderitem_ibfk_1` FOREIGN KEY (`volumeRebuildBatchOrderID`) REFERENCES `swvolumerebuildbatchorder` (`volumeRebuildBatchOrderID`),
          CONSTRAINT `swvolumerebuildbatchorderitem_ibfk_2` FOREIGN KEY (`orderItemID`) REFERENCES `sworderitem` (`orderItemID`),
          CONSTRAINT `swvolumerebuildbatchorderitem_ibfk_3` FOREIGN KEY (`volumeRebuildBatchID`) REFERENCES `swvolumerebuildbatch` (`volumeRebuildBatchID`)
        )
	</cfquery>
	<cfquery name="local.volumestatustypes">
	    INSERT INTO `swtype` (`typeID`, `typeIDPath`, `typeName`, `typeCode`, `typeDescription`, `sortOrder`, `systemCode`, `childRequiresSystemCodeFlag`, `remoteID`, `createdDateTime`, `createdByAccountID`, `modifiedDateTime`, `modifiedByAccountID`, `parentTypeID`, `typeSummary`)
        VALUES
            ('2c9180846e6a89e3016e6a9db7f20016', '2c9180846e6a89e3016e6a9db7f20016', 'Volume Rebuild Batch Status Types', 'volumeRebuildBatchStatusType', NULL, 38, NULL, NULL, NULL, '2019-11-14 10:52:31', NULL, '2019-11-14 10:52:31', NULL, NULL, NULL),
            ('2c9180846e6a89e3016e6a9e45750017', '2c9180846e6a89e3016e6a9db7f20016,2c9180846e6a89e3016e6a9e45750017', 'Processed', 'vrbstProcessed', NULL, 39, NULL, NULL, NULL, '2019-11-14 10:53:07', NULL, '2019-11-14 10:53:07', NULL, '2c9180846e6a89e3016e6a9db7f20016', NULL),
            ('2c91808e6e6a89db016e6a9e0f2a0019', '2c9180846e6a89e3016e6a9db7f20016,2c91808e6e6a89db016e6a9e0f2a0019', 'New', 'vrbstNew', NULL, 39, NULL, NULL, NULL, '2019-11-14 10:52:53', NULL, '2019-11-14 10:52:53', NULL, '2c9180846e6a89e3016e6a9db7f20016', NULL)
	</cfquery>
    <cfcatch>
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Create volume rebuild batch tables and types">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script locations had errors when running">
	<cfthrow detail="Part of Script locations had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script locations has run with no errors">
</cfif>
