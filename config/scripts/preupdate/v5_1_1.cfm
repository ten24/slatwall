<cfparam name="this.ormSettings.dialect" />
<cfparam name="this.datasource.name" />
<cfparam name="this.datasource.username" default="" />
<cfparam name="this.datasource.password" default="" />
<cfsetting requesttimeout="1200" />

    
  
<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="tables" name="currenttables" pattern="SwShipMethodRateIntegrationMethod" />

<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="tables" name="hasNewTable" pattern="SwShipMethRateIntegrationMeth" />

<cfif currenttables.recordCount AND !hasNewTable.recordCount>
    <cfquery name="local.updateColumnForOracle" datasource="#this.datasource.name#">
         ALTER TABLE swshipmethodrateintegrationmethod CHANGE COLUMN shipMethodRateIntegrationMethodID shipMethRateIntegrationMethID VARCHAR(32) NOT NULL
    </cfquery>
	<cfquery name="local.updateTableForOracle" datasource="#this.datasource.name#">
	    RENAME TABLE swshipmethodrateintegrationmethod TO swshipmethrateintegrationmeth
	</cfquery>
	
    <cflog file="Slatwall" text="General Log - Preupdate Script v5_1_1 has run with no errors">
</cfif>
<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="tables" name="currenttables" pattern="SwOrderFulfillment" />
<cfif currenttables.recordCount>
    <cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="columns" name="hasColumn" table="SwOrderFulfillment" pattern="thirdPartyShippingAccountIdentifier" />
    <cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="columns" name="hasNewColumn" table="SwOrderFulfillment" pattern="thirdPartyShipAccntIdentifier" />
    <cfif hascolumn.recordCount AND !hasNewColumn.recordCount>
    	<cfquery name="local.updateColumnForOracle2" datasource="#this.datasource.name#">
    	    ALTER TABLE sworderfulfillment CHANGE COLUMN thirdPartyShippingAccountIdentifier thirdPartyShipAccntIdentifier VARCHAR(32)
    	</cfquery>
	</cfif>
    <cflog file="Slatwall" text="General Log - Preupdate Script v5_1_1 has run with no errors">
</cfif>