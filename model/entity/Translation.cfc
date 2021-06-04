component displayname="Translation" entityname="SlatwallTranslation" table="SwTranslation" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="TranslationService" {
    
    // Persistent Properties
    property name="translationID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
    property name="baseObject" ormtype="string" index="EI_BASEOBJECT";
    property name="baseID" ormtype="string" length="32" index="EI_BASEID";
    property name="basePropertyName" ormtype="string";
    property name="locale" ormtype="string";
    property name="value" ormtype="string";
    
    // Related Object Properties (many-to-one)
    
    // Related Object Properties (one-to-many)
    
    // Related Object Properties (many-to-many - owner)
    
    // Related Object Properties (many-to-many - inverse)
    
    // Remote Properties
    property name="remoteID" ormtype="string";
    
    // Audit Properties
    property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
    property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
    property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
    property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
    
    // Non-Persistent Properties
    
    // ============ START: Non-Persistent Property Methods =================
    
    // ============  END:  Non-Persistent Property Methods =================
    
    // ============= START: Bidirectional Helper Methods ===================
    
    // =============  END:  Bidirectional Helper Methods ===================
    
    // =============== START: Custom Validation Methods ====================
    
    // ===============  END: Custom Validation Methods =====================
    
    // =============== START: Custom Formatting Methods ====================
    
    // ===============  END: Custom Formatting Methods =====================
    
    // ============== START: Overridden Implicet Getters ===================
    
    // ==============  END: Overridden Implicet Getters ====================
    
    // ================== START: Overridden Methods ========================
    
    // ==================  END:  Overridden Methods ========================
    
    // =================== START: ORM Event Hooks  =========================
    
    // ===================  END:  ORM Event Hooks  =========================
    
    // ================== START: Deprecated Methods ========================
    
    // ==================  END:  Deprecated Methods ========================
}