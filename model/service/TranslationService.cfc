component extends="HibachiService" accessors="true" output="false" {
    
    // ===================== START: Logical Methods ===========================
    
    // =====================  END: Logical Methods ============================
    
    // ===================== START: DAO Passthrough ===========================
    
    // =====================  END: DAO Passthrough ============================
    
    // ===================== START: Process Methods ===========================
    
    public any function processTranslation_updateProperty(required any entity, required struct data, required any processObject) {

        if (isArray(arguments.processObject.getTranslationData())) {
            for (var translationData in arguments.processObject.getTranslationData()) {
                var translation = this.getTranslationByBaseObjectANDBaseIDANDBasePropertyNameANDLocale([arguments.processObject.getBaseObject(), arguments.processObject.getBaseID(), arguments.processObject.getBasePropertyName(), translationData.locale], true);
                
                if (translation.getNewFlag()) {
                    translation.setBaseObject(arguments.processObject.getBaseObject());
                    translation.setBaseID(arguments.processObject.getBaseID());
                    translation.setBasePropertyName(arguments.processObject.getBasePropertyName());
                    translation.setLocale(translationData.locale);
                }
                
                // Delete existing translation that are set to an empty value
                if (!translation.getNewFlag() && !len(translationData.value)) {
                    this.deleteTranslation(translation);
                
                } else if (len(translationData.value)) {
                    translation.setValue(translationData.value);
                    this.saveTranslation(translation);
                }
            }
        }

        return arguments.entity;
    }

    // =====================  END: Process Methods ============================
    
    // ====================== START: Status Methods ===========================
    
    // ======================  END: Status Methods ============================
    
    // ====================== START: Save Overrides ===========================
    
    // ======================  END: Save Overrides ============================
    
    // ====================== START: Get Overrides ============================
    
    // ======================  END: Get Overrides =============================
    
    // ===================== START: Delete Overrides ==========================
    
    // =====================  END: Delete Overrides ===========================
    
    // ===================== START: Private Helper Functions ==================
    
    // =====================  END:  Private Helper Functions ==================
    
    // =================== START: Deprecated Functions ========================
    
    // ===================  END: Deprecated Functions =========================
    
}