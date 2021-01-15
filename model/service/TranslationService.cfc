component extends="HibachiService" accessors="true" output="false" {
	
	property name="settingService" type="any";
	property name="translationDAO" type="any";
	property name="translations" type="struct";
	property name="translatableProperties" type="struct";

	// ===================== START: Logical Methods ===========================
	
	public array function getEntityNameOptions() {
		var entitiesMetaData = getService("hibachiService").getEntitiesMetaData();

		var entityNames = [];
		for (var entityName in entitiesMetaData) {
			if (!structKeyExists(entitiesMetaData[entityName], 'hb_translate') || entitiesMetaData[entityName].hb_translate) {
				arrayAppend(entityNames, entityName);
			}
		}
		arraySort(entityNames,"text");

		var options = [];
		for(var value in entityNames) {
			var option = {};
			option["name"] = rbKey('entity.#value#');
			option["value"] = value;
			arrayAppend(options, option);
		}

		return options;
	}

	// Returns a subset of all available locales filtered by the locales that have translation enabled.
	public array function getSiteAvailableLocalesOptions() {
		return getHibachiRBService().getAvailableLocaleOptions(localeFilterList=getService('settingService').getSettingValue('globalTranslateLocales'));
	}
	
	public array function getTranslatablePropertiesByEntityName(required string entityName){
		if(!structKeyExists(variables, 'translatableProperties')){
			variables.translatableProperties = {};
		}
		
		 if(!structKeyExists(variables.translatableProperties, entityName)){
			variables.translatableProperties[arguments.entityName] = [];
			var properties = getTranslationDAO().getTranslatablePropertyNamesByEntityName(argumentCollection=arguments);
			for(var property in properties){
				arrayAppend(variables.translatableProperties[arguments.entityName], property['basePropertyName']);
			}
		}
		
		return variables.translatableProperties[arguments.entityName];
		
	}
	
	public string function setCachedTranslationValue(required string translationKey, string translationValue){
		if( !structKeyExists(variables,  'translations') ){
			variables.translations = {};
		}
		if( structKeyExists(arguments, 'translationValue') && !isNull(arguments.translationValue) ){
			variables.translations[arguments.translationKey] = arguments.translationValue;
		}else{
			structDelete(variables.translations,arguments.translationKey);
		}
	}
	
	public boolean function hasCachedTranslationValue(required string translationKey){
		return structKeyExists(variables,  'translations') && structKeyExists(variables.translations, arguments.translationKey);
	}
	
	public string function getCachedTranslationValue(required string translationKey){
		if( !structKeyExists(variables,  'translations') ){
			variables.translations = {};
		}
		return variables.translations[arguments.translationKey];
	}
	
	public any function getTranslationValue(required string baseObject, required string baseID, required string basePropertyName, required string locale){
		// Check if entity is translatable
		if(!listFindNoCase(getHibachiScope().setting('globalTranslateEntities'), arguments.baseObject)){
			return;
		}
		var cacheKey = 'translate_#arguments.baseObject#_#arguments.baseID#_#arguments.basePropertyName#_#arguments.locale#';
		
		if( !hasCachedTranslationValue(cacheKey) ){
			var translation = getTranslationByBaseObjectANDBaseIDANDBasePropertyNameANDLocale(argumentCollection=arguments);
			
			if( !isNull(translation) && len(translation) ){
				setCachedTranslationValue(cacheKey, translation.getValue());
			}else{
				return;
			}
		}
		
		return getCachedTranslationValue(cacheKey);
	}
	
	public array function getTranslatedCollectionRecords(required string baseObject, required array collectionRecords, string locale){
		
		if(!structKeyExists(arguments, 'locale')){
			arguments.locale = getHibachiScope().getSession().getRbLocale();
		}
		
		if( !listFindNoCase(getHibachiScope().setting('globalTranslateEntities'), arguments.baseObject) ){
			return arguments.collectionRecords;
		}
		
		var primaryIDPropertyName = getService("HibachiService").getPrimaryIDPropertyNameByEntityName( arguments.baseObject );
		
		if( !arrayLen(arguments.collectionRecords) || !structKeyExists(arguments.collectionRecords[1], primaryIDPropertyName) || !len(arguments.collectionRecords[1][primaryIDPropertyName]) ){
			return arguments.collectionRecords;
		}
		
		var collectionRecordProperties = StructKeyArray(arguments.collectionRecords[1]);
		
		var translatableProperties = getTranslatablePropertiesByEntityName(arguments.baseObject);
		
		collectionRecordProperties = arrayFilter(collectionRecordProperties, function(value){
			return ArrayContains(translatableProperties,value);
		});
		
		for( var record in arguments.collectionRecords){
			var primaryID = record[primaryIDPropertyName];
			
			for(var translatableProperty in collectionRecordProperties){
				var translatedValue = getTranslationValue(arguments.baseObject, primaryID, translatableProperty, arguments.locale);
				if(isNull(translatedValue)){
					continue;
				}
				record[translatableProperty] = translatedValue;
			}
			
		}
		
		return arguments.collectionRecords;
	}

	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public any function getTranslationByBaseObjectANDBaseIDANDBasePropertyNameANDLocale(required string baseObject, required string baseID, required string basePropertyName, required string locale){
		return getTranslationDAO().getTranslationByBaseObjectANDBaseIDANDBasePropertyNameANDLocale(argumentCollection=arguments);
	}
	
	// =====================  END: DAO Passthrough ============================
	
	// ===================== START: Process Methods ===========================
	
	public any function processTranslation_updateProperty(required any entity, required struct data, required any processObject) {
		var objectTranslationData = arguments.processObject.getTranslationData();
		
		//Clear Cache
		if(structKeyExists(variables, 'translatableProperties')){
			structDelete(variables.translatableProperties, arguments.processObject.getBaseObject());
		}
		
		
		if (isArray(objectTranslationData)) {
			
			for (var translationData in objectTranslationData) {
				
				// Default Locale will contain a null value
				if (isNull(translationData)) {
					continue;
				}
				
				var translation = getHibachiScope().getService('TranslationService').newTranslation();
				
				var hasTranslationEntityArguments = arguments.processObject.hasTranslatedPropertyObject() && !isNull(translationData['locale']);
				if (hasTranslationEntityArguments) {
					var translationEntity = this.getTranslationByBaseObjectANDBaseIDANDBasePropertyNameANDLocale(arguments.processObject.getBaseObject(), arguments.processObject.getBaseID(), arguments.processObject.getBasePropertyName(), translationData['locale']);
					var hasTranslationEntity = !isNull(translationEntity);
					if (hasTranslationEntity) {
						translation = translationEntity;
					}
				}
				
				if (translation.getNewFlag()) {
					translation.setBaseObject(arguments.processObject.getBaseObject());
					translation.setBaseID(arguments.processObject.getBaseID());
					translation.setBasePropertyName(arguments.processObject.getBasePropertyName());
					translation.setLocale(translationData.locale);
				}
				
				var cacheKey = 'translate_#arguments.processObject.getBaseObject()#_#arguments.processObject.getBaseID()#_#arguments.processObject.getBasePropertyName()#_#translationData.locale#';
				
				// Delete existing translation that are set to an empty value
				if (!translation.getNewFlag() && !len(translationData.value)) {
					this.deleteTranslation(translation);
					setCachedTranslationValue(cacheKey)
				} else if (len(translationData.value)) {
					translation.setValue(translationData.value);
					this.saveTranslation(translation);
					setCachedTranslationValue(cacheKey, translationData.value);
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