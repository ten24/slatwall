<cfparam name="this.ormSettings.dialect" />
<cfparam name="this.datasource.name" />
<cfparam name="this.datasource.username" default="" />
<cfparam name="this.datasource.password" default="" />
<!--- Just in case the it picks up on the entity first --->
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
<cflog file="Slatwall" text="General Log - Preupdate Script v4_4 has run with no errors">
