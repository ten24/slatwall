component displayname="Marketing Campaign List Activity Account" entityname="SlatwallMarketingCampaignListActivityAccount" table="SwMarketingCampaignListActivitySurgeon" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_permission="this"{

// Persistent Properties
	property name="marketingCampaignListActivityAccountID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";

// Related Object Properties (one-to-one)

// Related Object Properties (one-to-many)

// Related Object Properties (many-to-one)
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="marketingCampaignListActivity" cfc="MarketingCampaignListActivity" fieldtype="many-to-one" fkcolumn="marketingCampaignListActivityID";

// Related Object Properties (many-to-many - owner)


// Related Object Properties (many-to-many

// Remote properties

// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";


// ============ START: Non-Persistent Property Methods =================


// ============  END:  Non-Persistent Property Methods =================

// ============= START: Bidirectional Helper Methods ===================

// =============  END:  Bidirectional Helper Methods ===================

// ============= START: Overridden Smart List Getters ==================

// =============  END: Overridden Smart List Getters ===================

// ================== START: Overridden Methods ========================

// ==================  END:  Overridden Methods ========================

// =================== START: ORM Event Hooks  =========================

// ===================  END:  ORM Event Hooks  =========================

// ================== START: Deprecated Methods ========================

// ==================  END:  Deprecated Methods ========================

}
