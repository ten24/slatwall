<cfparam name="this.ormSettings.dialect" />
<cfparam name="this.datasource.name" />
<cfparam name="this.datasource.username" default="" />
<cfparam name="this.datasource.password" default="" />

<cfquery name="local.updateSwProductListingPage">
    ALTER TABLE SwProductListingPage
    ADD PRIMARY KEY (productListingPageID)
</cfquery> 

<cfif this.ormSetting.dialect != 'Oracle10g'>
    <cfquery name="local.updateSwProductListingPage">
        UPDATE SwProductListingPage SET productListingPageID=REPLACE(newid(),'-','')
    </cfquery>
<cfelse>
    <cfquery name="local.updateSwProductListingPage"> 
        UPDATE SwProductListingPage SET productListingPageID=REPLACE(sys_guid(),'-','')
    </cfquery> 
</cfif>
<cflog file="Slatwall" text="General Log - Preupdate Script v4_4 has run with no errors">
