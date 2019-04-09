component displayname="FlexshipSurveyResponse" entityname="SlatwallSurveyResponse" table="SwFlexshipSurveyResponse" persistent="true" output="false" accessors="true" extends="HibachiEntity" hb_permission="this" hb_processContexts="" hb_serviceName="MonatFlexshipService" {
	
	property name="flexshipSurveyResponseID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";

	property name="tooMuchFlexshipFlag" ormtype="boolean";
	property name="tooExpensiveFlexshipFlag" ormtype="boolean";
	property name="notNeededFlexshipFlag" ormtype="boolean";
	property name="onlyForYouNotWantedFlexshipFlag" ormtype="boolean";
	property name="alreadyPurchasedItemFromFlexshipFlag" ormtype="boolean";
	property name="otherFlexshipCancellationReasonFlag" ormtype="boolean";
	property name="otherFlexshipCancellationNotes" ormtype="string";

	// Remote properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";	
}
