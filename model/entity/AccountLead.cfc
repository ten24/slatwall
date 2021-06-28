component extends="Slatwall.model.entity.HibachiEntity" displayname="AccountLead" entityname="SlatwallAccountLead" table="SwAccountLead" persistent="true" output="false" accessors="true" cacheuse="transactional" hb_serviceName="accountService" hb_permission="account.accountLeads" {
    
    property name="accountLeadID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
    
    // Related Object Properties (one-to-many)

    // Related Object Properties (many-to-one)
    property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
    property name="leadAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="leadAccountID";
    
    // Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	
}