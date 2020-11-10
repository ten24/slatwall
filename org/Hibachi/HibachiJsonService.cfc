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
		var configDirectoryPath = expandPath('/#getDao("HibachiDao").getApplicationKey()#') & '/custom/system/';
		if(!directoryExists(configDirectoryPath)){
			directoryCreate(configDirectoryPath);
		}
		var filePath = configDirectoryPath & 'config.json';
		fileWrite(filePath,json,'utf-8');
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
    	var permissionGroupSmartlist = getService('accountService').getPermissionGroupSmartlist();
    	var permissionGroups = permissionGroupSmartList.getRecords();
    	for(var permissionGroup in permissionGroups){
    	    createPermissionJson(permissionGroup.getPermissionGroupID(),permissionGroup.getPermissionsByDetails(true));
    	}
    }
    
    //permission types are entity and action
    public void function createPermissionJson(required string permissionType,required struct permissionDetails){
         var systemrbpath = expandPath('/#getDAO("hibachiDAO").getApplicationKey()#') & "/custom/system/permissions";
        if(!directoryExists(systemrbpath)){
        	directoryCreate(systemrbpath);
        }
        //remove meta data we already have in config.json
        if(arguments.permissionType=='entity'){
            var jsonStruct = {};
            for(var entityName in arguments.permissionDetails){
                entityName = lcase(entityName);
                var entityStruct = arguments.permissionDetails[entityName];
                jsonStruct[entityName] = {};
                for(var propertyRelationshipTypeKey in entityStruct){
                    propertyRelationshipTypeKey=lcase(propertyRelationshipTypeKey);
                    var propertyRelationshipTypeValue = arguments.permissionDetails[entityName][propertyRelationshipTypeKey];
                    jsonStruct[entityName][propertyRelationshipTypeKey]={};
                    for(var propertyName in propertyRelationshipTypeValue){
                        propertyName = lcase(propertyName);
                        jsonStruct[entityName][propertyRelationshipTypeKey][propertyName]=true;
                    }
                }
            }
            arguments.permissionDetails = jsonStruct;
        }
        //check if permission type is a permission group uuid vs a string
        //format permission group data to lighten json
        if(getService('HibachiUtilityService').isHibachiUUID(arguments.permissionType)){
            var jsonStruct = {};
            for(var permissionTypeKey in arguments.permissionDetails){
                var permissionTypeValue = arguments.permissionDetails[permissionTypeKey];
                if(permissionTypeKey=='action'){
                    var jsonStruct['action']={};
                    jsonStruct['action']['subsystems']={};
                    for(var subsystemKey in permissionTypeValue.subsystems){
                        jsonStruct['action']['subsystems'][subsystemKey]={};
                        var subsystemValue = permissionTypeValue.subsystems[subsystemKey];
                        if(structKeyExists(subsystemValue,'permission')){
                            for(var key in subsystemValue.permission){
                                if(structKeyExists(subsystemValue.permission,key)){
                                    jsonStruct['action']['subsystems'][subsystemKey]['permission'][key]=subsystemValue.permission[key];
                                }
                            }
                        }
                        if(structKeyExists(subsystemValue,'sections')){
                            for(var sectionKey in subsystemValue.sections){
                                var sectionValue = subsystemValue.sections[sectionKey];
                                if(structKeyExists(sectionValue,'permission')){
                                    for(var key in sectionValue.permission){
                                        if(structKeyExists(sectionValue.permission,key)){
                                            jsonStruct['action']['subsystems'][subsystemKey]['sections'][sectionKey]['permission'][key]=sectionValue.permission[key];
                                        }
                                    }
                                }
                                if(structKeyExists(sectionValue,'items')){
                                    for(var itemKey in sectionValue.items){
                                        var itemValue = sectionValue.items[itemKey];
                                        for(var key in itemValue){
                                            if(structKeyExists(itemValue,key)){
                                                jsonStruct['action']['subsystems'][subsystemKey]['sections'][sectionKey]['items'][itemKey][key]=itemValue[key];
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }else if(permissionTypeKey=='entity'){
                    
                    var jsonStruct['entity']={};
                    
                    if(structKeyExists(permissionTypeValue,'permission')){
                        jsonStruct['entity']['permission']={};
                        for(var key in permissionTypevalue.permission){
                            if(structKeyExists(permissionTypevalue.permission,key)){
                                jsonStruct['entity']['permission'][key]=permissionTypevalue.permission[key];
                            }
                        }
                    }
                    if(structKeyExists(permissionTypeValue,'entities')){
                        for(var entityName in permissionTypeValue.entities){
                            entityName = lcase(entityName);
                            var entityNameValue = permissionTypeValue.entities[entityName];
                            jsonStruct['entity']['entities'][entityName]={};
                            if(structKeyExists(entityNameValue,'permission')){
                                jsonStruct['entity']['entities'][entityName]['permission']={};
                                for(var key in entityNameValue.permission){
                                    if(structKeyExists(entityNameValue.permission,key)){
                                        jsonStruct['entity']['entities'][entityName]['permission'][key]=entityNameValue.permission[key];
                                    }
                                }
                            }
                            if(structKeyExists(entityNameValue,'properties')){
                                jsonStruct['entity']['entities'][entityName]['properties']={};
                                for(var propertyNameKey in entityNameValue.properties){
                                    propertyNameKey = lcase(propertyNameKey);
                                    var propertyNameValue = entityNameValue.properties[propertyNameKey];
                                    jsonStruct['entity']['entities'][entityName]['properties'][propertyNameKey]={};
                                    for(var key in propertyNamevalue){
                                        if(structKeyExists(propertyNameValue,key)){
                                            jsonStruct['entity']['entities'][entityName]['properties'][propertyNameKey][key]=propertyNameValue[key];
                                        }                                        
                                    }
                                }
                            }
                        }
                    }
                    
                }else if(permissionTypeKey=='process'){
                    var jsonStruct['process']={};
                    
                    if(structKeyExists(permissionTypeValue,'entities')){
                        for(var entityName in permissionTypeValue.entities){
                            entityName = lcase(entityName);
                            var entityNameValue = permissionTypeValue.entities[entityName];
                            jsonStruct['process']['entities'][entityName]={};
                            if(structKeyExists(entityNameValue,'context')){
                                jsonStruct['process']['entities'][entityName]['context']={};
                                for(var contextNameKey in entityNameValue.context){
                                    contextNameKey = lcase(contextNameKey);
                                    var contextNameValue = entityNameValue.context[contextNameKey];
                                    jsonStruct['process']['entities'][entityName]['context'][contextNameKey]={};
                                    for(var key in contextNameValue){
                                        if(structKeyExists(contextNameValue,key)){
                                            jsonStruct['process']['entities'][entityName]['context'][contextNameKey][key]=contextNameValue[key];
                                        }                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
            arguments.permissionDetails=jsonStruct;
        }
        
        var json = serializeJson(arguments.permissionDetails);
		var filePath = systemrbpath & '/#arguments.permissionType#.json';
        fileWrite(filePath,json,'utf-8');
        
    }
    
    public void function createRBJson(){
        var rbpath = expandPath('/#getDAO("hibachiDAO").getApplicationKey()#') & "/config/resourceBundles";
        var directorylisting = [];
        if(DirectoryExists(rbpath)){
            directorylisting = directorylist(rbpath,false,"name","*.properties");
        }

        var customrbpath = expandPath('/#getDAO("hibachiDAO").getApplicationKey()#') & "/custom/resourceBundles";

        if(!directoryExists(customrbpath)){
            directoryCreate(customrbpath);
        }
        
        var systemrbpath = expandPath('/#getDAO("hibachiDAO").getApplicationKey()#') & "/custom/system/resourceBundles";
        
        if(!directoryExists(systemrbpath)){
            directoryCreate(systemrbpath);
        }
        
        var customDirectoryListing = directorylist(customrbpath,false,"name","*.properties");
        for(var item in customDirectoryListing){
            if(!ArrayFind(directoryListing,item)){
                arrayAppend(directoryListing,item);
            }
        }

        for(var rb in directoryListing){
            var locale = listFirst(rb,'.');
            var resourceBundle = getService('HibachiRBService').getResourceBundle(locale);

            var data = {};
            //cache RB for 1 day or until a reload
            //lcase all the resourceBundle keys so we can have consistent casing for the js
            for(var key in resourceBundle){
                key = REReplace(trim(key), '[^\x00-\x7F]', '', "ALL");
                if(!len(key)){
                    continue;
                }
                data[lcase(key)] = resourceBundle[key];
            }
            var json = serializeJson(data);
            var filePath = systemrbpath & '/#locale#.json';
            fileWrite(filePath,json,'utf-8');
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
