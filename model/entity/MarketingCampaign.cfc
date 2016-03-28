component displayname="Marketing Campaign" entityname="SlatwallMarketingCampaign" table="SwMarketingCampaign" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_permission="this" {

	// Persistent Properties
	property name="marketingCampaignID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="campaignName" ormtype="string";
	property name="campaignDescription" ormtype="string";
	property name="startDateTime"  ormtype="timestamp" hb_formatType="date";
	property name="endDateTime" ormtype="timestamp" hb_formatType="date";

	// Related Object Properties (many-to-one)
	//property name="marketingCampaignType" cfc="Type" fieldtype="many-to-one" fkcolumn="marketingCampaignTypeID" hb_optionsSmartListData="f:parentType.systemCode=MarketingCampaignType&OrderBy=typeName|ASC";

	// Related Object Properties (one-to-many)
	property name="marketingCampaignLists" singularname="marketingCampaignList" fieldType="one-to-many" type="array" fkColumn="marketingCampaignID" cfc="MarketingCampaignList" inverse="true" cascade="all-delete-orphan";

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)

	// Remote properties

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";


	// ============ START: Non-Persistent Property Methods =================
	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// CampaignList (one-to-many)
	public void function addMarketingCampaignList(required any marketingCampaignList) {
		arguments.marketingCampaignList.setMarketingCampaign( this );
	}
	public void function removeMarketingCampaignList(required any marketingCampaignList) {
		arguments.marketingCampaignList.removeMarketingCampaign( this );
	}

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

