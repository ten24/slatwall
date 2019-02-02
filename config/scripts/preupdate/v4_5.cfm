<cfparam name="this.ormSettings.dialect" />
<cfparam name="this.datasource.name" />
<cfparam name="this.datasource.username" default="" />
<cfparam name="this.datasource.password" default="" />
<cfsetting requesttimeout="1200" />
<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="tables" name="currenttables" pattern="SwProductListingPage" />

<cfif currenttables.recordCount>
	<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="columns" name="productlistingpagecolumns" table="SwProductListingPage" />
	<cfset local.found = false /> 
	<cfloop query="#productlistingpagecolumns#">
		<cfif Column_Name eq 'productListingPageID'>
			<cfset local.found = true /> 
			<cfbreak> 
		</cfif> 
	</cfloop>
	<cfif !local.found>
		<cfquery name="local.addproductListingPageID" datasource="#this.datasource.name#"> 
			ALTER TABLE SwProductListingPage ADD productListingPageID varchar(32)
		</cfquery> 
	</cfif>
	<!--- Just in case the it picks up on the entity first --->
	<cfif this.ormSettings.dialect eq 'MicrosoftSQLServer'>
	    <cfquery name="local.updateSwProductListingPage" datasource="#this.datasource.name#">
	        UPDATE SwProductListingPage SET productListingPageID=REPLACE(newid(),'-','')
	    </cfquery>
	<cfelseif ListFind(this.ormSettings.dialect, 'MySQL')>
	    <cfquery name="local.updateSwProductListingPage" datasource="#this.datasource.name#">
	        UPDATE SwProductListingPage SET productListingPageID=(SELECT md5(UUID()))
	    </cfquery>
	<cfelseif this.ormSettings.dialect eq 'Oracle10g'>
	    <cfquery name="local.updateSwProductListingPage" datasource="#this.datasource.name#"> 
	        UPDATE SwProductListingPage SET productListingPageID=REPLACE(sys_guid(),'-','')
	    </cfquery> 
	</cfif>
	<cflog file="Slatwall" text="General Log - Preupdate Script v4_5 has run with no errors">
</cfif>
