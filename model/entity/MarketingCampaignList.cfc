component displayname="Marketing Campaign List" entityname="SlatwallMarketingCampaignList" table="SwMarketingCampaignList" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_permission="this" {

	// Persistent Properties
	property name="marketingCampaignListID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="listName" ormtype="string";
	property name="listSize" ormtype="integer";
	property name="collectionConfig" ormtype="string" length="8000" hb_formFieldType="json";


	// Related Object Properties (one-to-many)
	//property name="campaignListSurgeons" singularname="campaignListSurgeon" fieldType="one-to-many" type="array" fkColumn="campaignListID" cfc="CampaignListSurgeon" cascade="all-delete-orphan" inverse="true";
	//property name="campaignListActivities" singularname="campaignListActivity" fieldType="one-to-many" type="array" fkColumn="campaignListID" cfc="CampaignListActivity" cascade="all-delete-orphan" inverse="true";

	// Related Object Properties (many-to-one)
	property name="marketingCampaign" cfc="MarketingCampaign" fieldtype="many-to-one" fkcolumn="marketingCampaignID";


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

//// CampaignSurgeon (one-to-many)
	//public void function addCampaignListSurgeon(required any campaignListSurgeon) {
		//arguments.campaignListSurgeon.setCampaignList( this );
	//}
	//public void function removeCampaignListSurgeon(required any campaignListSurgeon) {
		//arguments.campaignListSurgeon.removeCampaignList( this );
	//}
//
//// CampaignActivity (one-to-many)
	//public void function addCampaignListActivity(required any campaignListActivity) {
		//arguments.campaignListActivity.setCampaignList( this );
	//}
	//public void function removeCampaignListActivity(required any campaignListActivity) {
		//arguments.campaignListActivity.removeCampaignList( this );
	//}


	// MarketingCampaign (many-to-one)
	public void function setMarketingCampaign(required any campaign) {
		variables.marketingCampaign = arguments.marketingCampaign;
		if(isNew() || !arguments.marketingCampaign.hasMarketingCampaignList( this )) {
			arrayAppend(arguments.marketingCampaign.getMarketingCampaignLists(), this);
		}
	}
	public void function removeMarketingCampaign(any marketingCampaign) {
		if(!structKeyExists(arguments, "marketingCampaign")) {
			arguments.marketingCampaign = variables.marketingCampaign;
		}
		var index = arrayFind(arguments.marketingCampaign.getMarketingCampaignLists(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.marketingCampaign.getMarketingCampaignLists(), index);
		}
		structDelete(variables, "marketingCampaign");
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

