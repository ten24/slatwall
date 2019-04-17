component displayname="OrderTemplateScheduleDateChangeReason" entityname="SlatwallOrderTemplateScheduleDateChangeReason" table="SwOrderTemplateScheduleDateChangeReason" persistent="true" output="false" accessors="true" extends="HibachiEntity" hb_permission="this" hb_processContexts="" hb_serviceName="OrderService" {
	
	property name="orderTemplateScheduleDateChangeReasonID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	property name="otherScheduleDateChangeReasonNotes" ormtype="string";

	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID"; 
	property name="orderTemplateScheduleDateChangeReasonType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderTemplateScheduleDateChangeReasonTypeID"; 
	property name="orderTemplate" cfc="OrderTemplate" fieldtype="many-to-one" fkcolumn="orderTemplateID"; 

	// Remote properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";	


 
}
