component accessors="true" extends="Slatwall.org.Hibachi.HibachiController"{
    
    property name="fw" type="any";
    property name="hibachiService" type="any";
    property name="hibachiUtilityService" type="any";
    
    this.publicMethods='';
//    this.publicMethods=listAppend(this.publicMethods, 'generateEntityJson');
//    this.publicMethods=listAppend(this.publicMethods, 'generateBaseComponentJson');
//    this.publicMethods=listAppend(this.publicMethods, 'generateServiceJson');
//    this.publicMethods=listAppend(this.publicMethods, 'generateDaoJson');
//    this.publicMethods=listAppend(this.publicMethods, 'generateProcessJson');
//    this.publicMethods=listAppend(this.publicMethods, 'generateValidationJson');
    this.publicMethods=listAppend(this.publicMethods, 'generateDocsJson');
    
    public any function before( required struct rc ) {
        getFW().setView("public:main.blank");
    }
    
    public struct function generateEntityJson(){
    	
    	//get all metadata for components related to model
    	
    	//get all metadata for base components that model extends
    	
    	var entitiesMetaData = getService('hibachiService').getEntitiesMetaData();
    	
    	var entitiesDocData = {};
    	
    	for(var objectKey in entitiesMetaData){
    		var object = entitiesMetaData[objectKey];
    		var entityDocData = {};
    		entityDocData['entityName'] = object.entityName;
    		entityDocData['table'] = object.table;
    		if(structKeyExists(object,'hb_serviceName')){
    			entityDocData['hb_serviceName'] = object.hb_servicename;
    		}
    		entityDocData['extends'] = getExtended(object);
    		entityDocData['functions'] = getFunctions(object.functions);
    		entityDocData['properties'] = object.properties;
    		if(structKeyExists(object,'cacheuse')){
    			entityDocData['cacheUse'] = object.cacheuse;
    		}
    		if(structKeyExists(object,'HB_DEFAULTORDERPROPERTY')){
    			entityDocData['hb_defaultOrderProperty'] = object.HB_DEFAULTORDERPROPERTY;
    		}
    		if(structKeyExists(object,'displayName')){
    			entityDocData['displayName'] = object.displayName;
    		}
    		if(structKeyExists(object,'HB_PARENTPROPERTYNAME')){
    			entityDocData['hb_parentPropertyName'] = object.HB_PARENTPROPERTYNAME;
    		}
    		if(structKeyExists(object,'HB_ChildPROPERTYNAME')){
    			entityDocData['hb_childPropertyName'] = object.hb_childPropertyName;
    		}
    		
    		entityDocData['persistent'] = object.persistent;
    		if(structKeyExists(object,'hb_permission')){
    			entityDocData['hb_permission'] = object.hb_permission;
    		}
    		if(structKeyExists(object,'hb_processContext')){
    			entityDocData['hb_processContext'] = object.hb_processcontext;
    		}
    		entityDocData['validations'] = getService('hibachiValidationService').getValidationStructByName(listlast(object.fullname,'.'));
    		
    		entitiesDocData[listlast(object.fullname,'.')] = entityDocData;
    		
    	}
    	return entitiesDocData;
    }
    
    public void function generateDocsJson(){
    	var docJson = {
    		baseComponents = generateBaseComponentJson(),
    		entities = generateEntityJson(),
    		services = generateServiceJson(),
    		processes = generateProcessJson(),
    		dao = generateDaoJson()
    	};
    	var docsJsonPath = expandPath('/'&getService('hibachiDao').getApplicationKey()) & '/meta/docs/json/docs.json';
    	fileWrite(docsJsonPath,serializeJson(docJson));
    	
    }
    
    public struct function generateBaseComponentJson(){
    	var baseComponentMetaData = {};
    	
    	var baseComponentDirectoryPath = expandPath('/'&getDao('hibachiDao').getApplicationKey()) & '/org/Hibachi';
    	var baseComponentDirectoryListing = directoryList(baseComponentDirectoryPath,false,'name','*.cfc');
    	
    	var baseComponentPath = getDao('hibachiDao').getApplicationValue('applicationKey')&'.org.Hibachi.';
    	
    	for(var componentCFCName in baseComponentDirectoryListing){
    		var componentName = listFirst(componentCFCName,'.');
    		var componentMetaData = getComponentMetaData(baseComponentPath&componentName);
    		baseComponentMetaData[componentName] = {};
    		baseComponentMetaData[componentName]['extends'] = getExtended(componentMetaData);
    		baseComponentMetaData[componentName]['functions'] = getFunctions(componentMetaData.functions);
    	}
    	return baseComponentMetaData;
    }
    
    public struct function generateServiceJson(){
    	var serviceComponentMetaData = {};
    	
    	var serviceComponentDirectoryPath = expandPath('/'&getDao('hibachiDao').getApplicationKey()) & '/model/service';
    	var serviceComponentDirectoryListing = directoryList(serviceComponentDirectoryPath,false,'name','*.cfc');
    	
    	var serviceComponentPath = getDao('hibachiDao').getApplicationValue('applicationKey')&'.model.service.';
    	
    	for(var componentCFCName in serviceComponentDirectoryListing){
    		var componentName = listFirst(componentCFCName,'.');
    		var componentMetaData = getComponentMetaData(serviceComponentPath&componentName);
    		serviceComponentMetaData[componentName] = {};
    		serviceComponentMetaData[componentName]['extends'] = getExtended(componentMetaData);
    		if(structKeyExists(componentMetaData,'functions')){
    			serviceComponentMetaData[componentName]['functions'] = getFunctions(componentMetaData.functions);
    		}
    		if(structKeyExists(componentMetaData,'properties')){
    			serviceComponentMetaData[componentName]['properties'] = componentMetaData.properties;
    		}
    	}
    	return serviceComponentMetaData;
    }
    
    public struct function generateDaoJson(){
    	var daoComponentMetaData = {};
    	
    	var daoComponentDirectoryPath = expandPath('/'&getDao('hibachiDao').getApplicationKey()) & '/model/dao';
    	var daoComponentDirectoryListing = directoryList(daoComponentDirectoryPath,false,'name','*.cfc');
    	
    	var daoComponentPath = getDao('hibachiDao').getApplicationValue('applicationKey')&'.model.dao.';
    	
    	for(var componentCFCName in daoComponentDirectoryListing){
    		var componentName = listFirst(componentCFCName,'.');
    		var componentMetaData = getComponentMetaData(daoComponentPath&componentName);
    		daoComponentMetaData[componentName] = {};
    		daoComponentMetaData[componentName]['extends'] = getExtended(componentMetaData);
    		if(structKeyExists(componentMetaData,'functions')){
    			daoComponentMetaData[componentName]['functions'] = getFunctions(componentMetaData.functions);
    		}
    		if(structKeyExists(componentMetaData,'properties')){
    			daoComponentMetaData[componentName]['properties'] = componentMetaData.properties;
    		}
    	}
    	return daoComponentMetaData;
    }
    
    public struct function generateProcessJson(){
    	var processComponentMetaData = {};
    	
    	var processComponentDirectoryPath = expandPath('/'&getDao('hibachiDao').getApplicationKey()) & '/model/process';
    	var processComponentDirectoryListing = directoryList(processComponentDirectoryPath,false,'name','*.cfc');
    	
    	var processComponentPath = getDao('hibachiDao').getApplicationValue('applicationKey')&'.model.process.';
    	
    	for(var componentCFCName in processComponentDirectoryListing){
    		var componentName = listFirst(componentCFCName,'.');
    		var componentMetaData = getComponentMetaData(processComponentPath&componentName);
    		processComponentMetaData[componentName] = {};
    		processComponentMetaData[componentName]['extends'] = getExtended(componentMetaData);
    		if(structKeyExists(componentMetaData,'functions')){
    			processComponentMetaData[componentName]['functions'] = getFunctions(componentMetaData.functions);
    		}
    		if(structKeyExists(componentMetaData,'properties')){
    			processComponentMetaData[componentName]['properties'] = componentMetaData.properties;
    		}
    	}
    	return processComponentMetaData;
    }
    
    public array function getExtended(required struct object, array extended=[]){
    	
    	arrayAppend(arguments.extended,object.fullname);
    	if(structKeyExists(arguments.object,'extends')){
    		arguments.extended = getExtended(arguments.object.extends,arguments.extended);
    	}
    	return arguments.extended;
    }
    
    public array function getFunctions(required array functions){
    	var functionArray = [];
    	for(var f in arguments.functions){
    		var functionItem = {};
    		functionItem['name'] = f.NAME;
    		if(structKeyExists(f,'RETURNTYPE')){
    			functionItem['returntype'] = f.RETURNTYPE;
    		}
    		if(structKeyExists(f,'PARAMETERS')){
    			functionItem['parameters'] = f.PARAMETERS;
    		}
    		if(structKeyExists(f,'DESCRIPTION')){
    			functionItem['description'] = f.DESCRIPTION;
    		}
    		arrayAppend(functionArray,functionItem);
    	}
    	
    	return functionArray;
    }
    
}
