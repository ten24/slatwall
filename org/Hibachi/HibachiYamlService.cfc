component output="false" accessors="true" extends="HibachiService" {
	variables.yamlJarPath = '/org/Hibachi/yaml/lib/jyaml-1.3.jar';
	// ===================== START: Logical Methods ===========================
	public any function getYaml(){
		if(!structKeyExists(variables,'yaml')){
			var jarPath = expandPath('/#getDao('hibachiDao').getApplicationKey()#'&variables.yamlJarPath);
			var lib = [jarPath];
			var loader = createObject("component", "#getDao('hibachiDao').getApplicationKey()#.org.Hibachi.yaml.io.javaloader.JavaLoader").init( lib );
			variables.yaml = loader.create( 'org.ho.yaml.Yaml' );
		}
		return variables.yaml;
	}
	
	public any function loadYamlFile(required string filepath){
		var file = createObject( 'java', 'java.io.File' ).init( arguments.filepath );
		
		return getYaml().load(file);
	}
	
	public any function dumpYaml(required any object){
		return getYaml().dump(arguments.object,true);
	}
	
	public any function writeYamlToFile(required any filePath, required any yamlStruct){
		var yamlString = dumpYaml(arguments.yamlStruct);
		//purge types from string
		yamlString = ReReplace(yamlString, "(!(\w.\S*))",'','All');
		fileWrite(arguments.filePath,yamlString);
	}

	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	// =====================  END: Process Methods ============================

	// ====================== START: Status Methods ===========================

	// ======================  END: Status Methods ============================

	// ====================== START: Save Overrides ===========================

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

	// ===================== START: Delete Overrides ==========================

	// =====================  END: Delete Overrides ===========================

}
