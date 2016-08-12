/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="HibachiService" persistent="false" accessors="true" output="false" {
	
	public void function createConfigJson(){
		var json = {};
		var config = {};
		config = getService('HibachiSessionService').getConfig();
		config[ 'modelConfig' ] = getModel();
		json['data'] = config;
		json = serializeJson(json);
		var filePath = expandPath('/Slatwall') & '/custom/config/config.json';
		fileWrite(filePath,json);
    }

	private any function getModel(){
        var model = {};
        var entities = [];
        var processContextsStruct = getService('hibachiService').getEntitiesProcessContexts();
        var entitiesListArray = listToArray(structKeyList(getService('hibachiService').getEntitiesMetaData()));


        model['entities'] = {};
        model['validations'] = {};
        model['defaultValues'] = {};

        for(var entityName in entitiesListArray) {
            var entity = getService('hibachiService').getEntityObject(entityName);

            formatEntity(entity,model);
            //add process objects to the entites array
            if(structKeyExists(processContextsStruct,entityName)){
                var processContexts = processContextsStruct[entityName];
                for(var processContext in processContexts){
                    if(entity.hasProcessObject(processContext)){

                        formatEntity(entity.getProcessObject(processContext),model);
                    }

                }
            }
        }

        ORMClearSession();
        
        return model;
    }
    
    public void function createJson(){
    	createConfigJson();
    	createRBJson();
    }
    
    public void function createRBJson(){
    	var rbpath = expandPath('/Slatwall') & "/config/resourceBundles";
    	var directorylisting = [];
    	if(DirectoryExists(rbpath)){
    		directorylisting = directorylist(rbpath,false,"name","*.properties");
    	}
    	var customrbpath = expandPath('/Slatwall') & "/custom/config/resourceBundles";
    	if(DirectoryExists(customrbpath)){
    		var customDirectoryListing = directorylist(customrbpath,false,"name","*.properties");
    		for(var item in customDirectoryListing){
    			if(!ArrayFind(directoryListing,item)){
    				arrayAppend(directoryListing,item);
    			}
    		}
    	}
    	
    	for(var rb in directoryListing){
    		var locale = listFirst(rb,'.');
    		var resourceBundle = getService('HibachiRBService').getResourceBundle(locale);
	        var data = {};
	        //cache RB for 1 day or until a reload
	        //lcase all the resourceBundle keys so we can have consistent casing for the js
	        for(var key in resourceBundle){
	            data[lcase(key)] = resourceBundle[key];
	        }
	        var json = serializeJson(data);
			var filePath = expandPath('/Slatwall') & '/custom/config/resourceBundles/#locale#.json';	        
	        fileWrite(filePath,json);
    	}
        
    }
    
    private void function formatEntity(required any entity, required any model){

        model.entities[entity.getClassName()] = entity.getPropertiesStruct();
        model.entities[entity.getClassName()]['className'] = entity.getClassName();

        var metaData = getMetaData(entity);
        var isProcessObject = Int(Find('_',entity.getClassName()) gt 0);

        if (structKeyExists(metaData,'hb_parentPropertyName')){
            model.entities[entity.getClassName()]['hb_parentPropertyName'] = metaData.hb_parentPropertyName;
        }
        if(structKeyExists(metaData,'hb_childPropertyName')){
            model.entities[entity.getClassName()]['hb_childPropertyName'] = metaData.hb_childPropertyName;
        }

        model.validations[entity.getClassName()] = getService('hibachiValidationService').getValidationStruct(entity);
        model.defaultValues[entity.getClassName()] = {};


        for(var property in entity.getProperties()){
            //<!--- Make sure that this property is a persistent one --->
            if (!structKeyExists(property, "persistent") && ( !structKeyExists(property,"fieldtype") || listFindNoCase("column,id", property.fieldtype) )){
                if(!isProcessObject){
                    try{
                        var defaultValue = entity.invokeMethod('get#property.name#');
                    }catch(any e){
                        defaultValue = javacast('null','');
                    }
                    if (isNull(local.defaultValue)){
                        model.defaultValues[entity.getClassName()][property.name] = javacast('null','');
                    }else if (structKeyExists(local.property, "ormType") and listFindNoCase('boolean,int,integer,float,big_int,big_decimal', local.property.ormType)){
                        model.defaultValues[entity.getClassName()][property.name] = defaultValue;
                    }else if (structKeyExists(local.property, "ormType") and listFindNoCase('string', local.property.ormType)){
                        if(structKeyExists(local.property, "hb_formFieldType") and local.property.hb_formFieldType eq "json"){
                            model.defaultValues[entity.getClassName()][property.name] = deserializeJson(defaultValue);
                        }else{
                            model.defaultValues[entity.getClassName()][property.name] = defaultValue;
                        }
                    }else if(structKeyExists(local.property, "ormType") and local.property.ormType eq 'timestamp'){
                        model.defaultValues[entity.getClassName()][property.name] = defaultValue;
                    }else{
                        model.defaultValues[entity.getClassName()][property.name] = defaultValue;
                    }
                }else{
                    try{
                        var defaultValue = entity.invokeMethod('get#property.name#');
                    }catch(any e){
                        defaultValue = javacast('null','');
                    }
                    if (!isNull(defaultValue)){
                        if(isObject(defaultValue)){
                            model.defaultValues[entity.getClassName()][property.name] = '';
                        }else{
                            if(isStruct(defaultValue)){
                                model.defaultValues[entity.getClassName()][property.name] = defaultValue;
                            }else{
                                model.defaultValues[entity.getClassName()][property.name] = '#defaultValue#';
                            }
                        }

                    }else{
                        //model.defaultValues[entity.getClassName()][property.name] = '#defaultValue#';
                    }
                }
            }
        }
    }
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}
