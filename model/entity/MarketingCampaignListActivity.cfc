component displayname="Marketing Campaign List Activity" entityname="SlatwallMarketingCampaignListActivity" table="SwMarketingCampaignListActivity" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_permission="this" hb_parentPropertyName="parentCampaignListActivity" hb_childPropertyName="childCampaignListActivities" {

	// Persistent Properties
	property name="marketingCampaignListActivityID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="marketingCampaignListActivityIDPath" ormtype="string" length="4000";
	property name="activityName" ormtype="string";

	// Related Object Properties (one-to-many)
	property name="marketingCampaignListActivityAccounts" singularname="marketingCampaignListActivityAccount" fieldType="one-to-many" type="array" fkColumn="marketingCampaignListActivityID" cfc="MarketingCampaignListActivityAccount" cascade="all-delete-orphan" inverse="true";

	// Related Object Properties (many-to-one)
	property name="marketingCampaignList" cfc="MarketingCampaignList" fieldtype="many-to-one" fkcolumn="marketingCampaignListID";
	property name="parentMarketingCampaignListActivity" cfc="MarketingCampaignListActivity" fieldtype="many-to-one" fkcolumn="parentMarketingCampaignListActivityID";

	// Related Object Properties (one-to-many)
	property name="childMarketingCampaignListActivities" singularname="childMarketingCampaignListActivity" cfc="MarketingCampaignListActivity" type="array" fieldtype="one-to-many" fkcolumn="parentMarketingCampaignListActivityID" cascade="all-delete-orphan" inverse="true";

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (one-to-one - inverse)

	// Remote properties

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// ============ START: Non-Persistent Property Methods =================

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Child Marketing Campaign List Activity (one-to-many)
	public void function addChildMarketingCampaignListActivity(required any childMarketingCampaignListActivity) {
		arguments.childMarketingCampaignListActivity.setParentMarketingCampaignListActivity( this );
	}

	public void function removeChildMarketingCampaignListActivity(required any childMarketingCampaignListActivity) {
		arguments.childMarketingCampaignListActivity.removeParentMarketingCampaignListActivity( this );
	}

	// MarketingCampaignList (many-to-one)
	public void function setMarketingCampaignList(required any marketingCampaignList) {
		variables.marketingCampaignList = arguments.marketingCampaignList;
		if(isNew() || !arguments.marketingCampaignList.hasMarketingCampaignListActivity( this )) {
			arrayAppend(arguments.marketingCampaignList.getMarketingCampaignListActivities(), this);
		}
	}
	public void function removeMarketingCampaignList(any marketingCampaignList) {
		if(!structKeyExists(arguments, "marketingCampaignList")) {
			arguments.marketingCampaignList = variables.marketingCampaignList;
		}
		var index = arrayFind(arguments.marketingCampaignList.getMarketingCampaignListActivities(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.marketingCampaignList.getMarketingCampaignListActivities(), index);
		}
		structDelete(variables, "marketingCampaignList");
	}


	// Parent Marketing Campaign List Activity (many-to-one)
	public void function setParentMarketingCampaignListActivity(required any parentMarketingCampaignListActivity) {
		variables.parentMarketingCampaignListActivity = arguments.parentMarketingCampaignListActivity;
		if(isNew() or !arguments.parentMarketingCampaignListActivity.hasChildMarketingCampaignListActivity( this )) {
			arrayAppend(arguments.parentMarketingCampaignListActivity.getChildMarketingCampaignListActivities(), this);
		}
	}

	public void function removeMarketingParentCampaignListActivity(any parentMarketingCampaignListActivity) {
		if(!structKeyExists(arguments, "parentMarketingCampaignListActivity")) {
			arguments.parentMarketingCampaignListActivity = variables.parentMarketingCampaignListActivity;
		}
		var index = arrayFind(arguments.parentMarketingCampaignListActivity.getChildMarketingCampaignListActivities(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.parentMarketingCampaignListActivity.getChildMarketingCampaignListActivities(), index);
		}
		structDelete(variables, "parentMarketingCampaignListActivity");
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ============= START: Overridden Smart List Getters ==================

	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================
	public void function preInsert(){
		super.preInsert();
		setMarketingCampaignListActivityIDPath(buildIDPathList("parentCampaignListActivity"));
	}

	public void function preUpdate(struct oldData){
		super.preUpdate(argumentcollection=arguments);
		setCampaignListActivityIDPath(buildIDPathList("parentCampaignListActivity"));
	}
	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================

}

