component output="false" accessors="true" extends="HibachiProcess" {
    
    // Injected Entity
    property name="translation";
    
    // Lazy / Injected Objects
    
    // New Properties
    
    // Data Properties (ID's)
    
    // Data Properties (Inputs)
    property name="baseObject";
    property name="baseID";
    property name="basePropertyName";
    property name="currentAction";
    
    // Data Properties (Related Entity Populate)
    property name="translationData" hb_populateArray="true";
    
    // Option Properties
    
    // Helper Properties
    property name="translationValue";
    
    // ======================== START: Defaults ============================
    
    // ========================  END: Defaults =============================
    
    // ====================== START: Data Options ==========================
    
    // ======================  END: Data Options ===========================
    
    // ================== START: New Property Helpers ======================
    
    /**
     * Parameters:
     * locale (string): the regions locale abbreviation (e.g. en_us)
     * Returns:
     * The translated string for the property is the provided locale
     */ 
    public string function getTranslationValue(string locale) {
        var translatedValue = "";
        if (hasTranslatedPropertyObject()) {
            var translationEntity = getHibachiScope().getService('TranslationService').getTranslationByBaseObjectANDBaseIDANDBasePropertyNameANDLocale(
                this.getBaseObject(),
                this.getBaseID(),
                this.getBasePropertyName(),
                arguments.locale);
                
            if (!isNull(translationEntity) && len(translationEntity.getTranslationID())) {
                translatedValue = translationEntity.getValue();
            }
        }
        return translatedValue;
    }
    
    public boolean function hasTranslatedPropertyObject() {
        return !isNull(this.getBaseObject()) && !isNull(this.getBaseID()) && !isNull(this.getBasePropertyName());
    }
    
    // ==================  END: New Property Helpers =======================
    
    // ===================== START: Helper Methods =========================
    
    // =====================  END: Helper Methods ==========================
    
    // =============== START: Custom Validation Methods ====================
    
    // ===============  END: Custom Validation Methods =====================
    
}