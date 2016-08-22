<cfparam name="this.ormSettings.dialect" />
<cfparam name="this.datasource.name" />
<cfparam name="this.datasource.username" default="" />
<cfparam name="this.datasource.password" default="" />

<cfquery name="local.updateSwProductListingPageAddColumn" datasource="#this.datasource.name#">
    ALTER TABLE SwProductListingPage
    ADD productListingPageID VARCHAR(32)
</cfquery>
<cfif this.ormSettings.dialect eq 'MicrosoftSQLServer'>
    <cfquery name="local.updateSwProductListingPage" datasource="#this.datasource.name#">
        UPDATE SwProductListingPage SET productListingPageID=REPLACE(newid(),'-','')
    </cfquery>
<cfelseif ListFind(this.ormSettings.dialect, 'MySQL')>
    <cfquery name="local.updateSwProductListingPage" datasource="#this.datasource.name#">
        UPDATE SwProductListingPage SET productListingPageID=REPLACE(uuid(),'-','')
    </cfquery>
<cfelseif this.ormSettings.dialect eq 'Oracle10g'>
    <cfquery name="local.updateSwProductListingPage" datasource="#this.datasource.name#"> 
        UPDATE SwProductListingPage SET productListingPageID=REPLACE(sys_guid(),'-','')
    </cfquery> 
</cfif>
<cfquery name="local.updateSwProductListingPage" datasource="#this.datasource.name#">
    ALTER TABLE SwProductListingPage
    ADD PRIMARY KEY (productListingPageID)
</cfquery> 
<cflog file="Slatwall" text="General Log - Preupdate Script v4_4 has run with no errors">
