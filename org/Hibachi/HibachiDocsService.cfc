component accessors="true" output="false" extends="HibachiService" {
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
			entityDocData['functions'] = getFunctions(object);
			entityDocData['properties'] = object.properties;
    		
    		for(var property in entityDocData['properties']){
    			//use description on the property else find an rbkey hint
    			if(!structKeyExists(property,'description')){
    				property['description'] = getHibachiScope().rbkey('entity.#object.entityName#.#property.name#_description');
    				if(right(property['description'], "8") == "_missing") {
    					property['description'] = getHibachiScope().rbkey('entity.#object.entityName#.#property.name#_hint');
    				}
    				if(right(property['description'], "8") == "_missing") {
						property['description'] = "";
					}
    			}
    		}
    		
    		if(structKeyExists(object,'description')){
    			entityDocData['description'] = object.description;
    		}else{
    			entityDocData['description'] = getHibachiScope().rbkey('entity.#object.entityName#_description');
				if(right(entityDocData['description'], "8") == "_missing") {
					entityDocData['description'] = getHibachiScope().rbkey('entity.#object.entityName#_hint');
				}
				if(right(entityDocData['description'], "8") == "_missing") {
					entityDocData['description'] = "";
				}
    		}
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

			entitiesDocData[listlast(object.fullname,'.')] = entityDocData;

		}
		return entitiesDocData;
	}

	public void function generateDocsJson(){
		var docsJson = {};
		docsJson['basecomponents'] = generateBaseComponentJson();
		docsJson['entities'] = generateEntityJson();
		docsJson['services'] = generateServiceJson();
		docsJson['processes'] = generateProcessJson();
		docsJson['daos'] = generateDaoJson();
		docsJson['validationInfo'] = generateValidationJson();
		var docsJsonPath = expandPath('/'&getService('hibachiDao').getApplicationKey()) & '/meta/docs/json/docs.json';
		fileWrite(docsJsonPath,serializeJson(docsJson));
	}

	public struct function generateValidationJson(){
		var validationInfo = {};
		var entityContexts = ['save','delete'];
		var entitiesProcessContexts = duplicate(getService('hibachiService').getEntitiesProcessContexts());
		var entitiesMetaData = getService('hibachiService').getEntitiesMetaData();
		var entityNamesArray = listtoArray(structKeyList(entitiesMetaData));
		for(var entityName in entityNamesArray){
			var entity = getService('hibachiService').getEntityObject(entityName);
			if(structKeyExists(entitiesProcessContexts,entityName)){
				var entityProcessContexts = duplicate(entitiesProcessContexts[entityName]);
			}else{
				var entityProcessContexts = [];
			}
			if(!ArrayFind(entityProcessContexts,'save')){
				arrayAppend(entityProcessContexts,'save');
			}
			if(!ArrayFind(entityProcessContexts,'delete')){
				arrayAppend(entityProcessContexts,'delete');
			}
			validationInfo[entityName]['validations'] = {};

			var validationStruct = getService('hibachiValidationService').getValidationStruct(entity);
			if(structKeyExists(validationStruct,'conditions')){
				validationInfo[entityName]['conditions'] = validationStruct.conditions;
			}
		}
		for(var entityName in entityNamesArray){
			var entity = getService('hibachiService').getEntityObject(entityName);
			var validationStruct = getService('hibachiValidationService').getValidationStruct(entity);
			if(structKeyExists(validationStruct,'populatedPropertyValidation')){
				
				validationInfo[entityName]['populatedPropertyValidation'] = validationStruct.populatedPropertyValidation;
				for(var relatedProperty in validationStruct.populatedPropertyValidation){
					var populatedPropertyValidation = validationInfo[entityName]['populatedPropertyValidation'][relatedProperty];
					var relatedObjectName = getService('hibachiService').getPropertiesStructByEntityName( entityName )[relatedProperty].cfc;
					var relatedObject = getService('hibachiService').getEntityObject(relatedObjectName);
					for(var item in populatedPropertyValidation){
						var validationContexts = listToArray(item.validate);
						for(var validationContext in validationContexts){
							if(!structKeyExists(entitiesProcessContexts,relatedObjectName)){
								entitiesProcessContexts[relatedObjectName] = [];
							}
							if(!ArrayFind(entitiesProcessContexts[relatedObjectName],validationContext)){
								arrayAppend(entityContexts,validationContext);
								arrayAppend(entitiesProcessContexts[relatedObjectName],validationContext);
							}
						}
					}
				}
			}
		}
		for(var entityName in entityNamesArray){
			var entity = getService('hibachiService').getEntityObject(entityName);
			if(structKeyExists(entitiesProcessContexts,entityName)){
				var entityProcessContexts = duplicate(entitiesProcessContexts[entityName]);
			}else{
				var entityProcessContexts = [];
			}
			if(!ArrayFind(entityProcessContexts,'save')){
				arrayAppend(entityProcessContexts,'save');
			}
			if(!ArrayFind(entityProcessContexts,'delete')){
				arrayAppend(entityProcessContexts,'delete');
			}
			if(!structKeyExists(validationInfo[entityName],'validations')){
				validationInfo[entityName]['validations'] = {};
			}
			
			//get all validations by context
			for(var processContext in entityProcessContexts){
				var validationsByContext = getService('hibachiValidationService').getValidationsByContext(entity,processContext);
				if(!isNull(validationsByContext)){
					validationInfo[entityName]['validations'][processContext] = {};
					if(arrayFind(entityContexts,processContext)){
						for(var propertyKey in validationsByContext){
							for(var constraint in validationsByContext[propertyKey]){
								var rbkey = getHibachiScope().rbkey(
									'validate.#entity.getClassName()#.#propertyKey#.#constraint.constraintType#',
									{
										entityName=entity.getClassName(),
										propertyName=propertyKey
									}
								);
								if(!right(rbkey,8) == '_missing'){
									constraint['rbkey'] = rbkey;
								}
							}
						}
						validationInfo[entityName]['validations'][processContext]['validations'] = validationsByContext;
					}else{
						var entityValidationsByContext = {};
						for(var key in validationsByContext){
							var processEntityName = lcase(left(entityName,1))&right(entityName,len(entityName)-1);
							var propertyIdentifier = "#processEntityName#.#key#";
							entityValidationsByContext[propertyIdentifier] = validationsByContext[key];
						}
						validationInfo[entityName]['validations'][processContext]['validations'] = entityValidationsByContext;
					}

				}

				if(!arrayFind(entityContexts,processContext)){
					var processValidationStruct = getService('hibachiValidationService').getValidationsByContext(entity.getProcessObject(processContext));
					for(var propertyKey in processValidationStruct){
						for(var constraint in processValidationStruct[propertyKey]){
							var rbkey = getHibachiScope().rbkey(
								'validate.#entity.getClassName()#_#processContext#.#propertyKey#.#constraint.constraintType#',
								{
									entityName=entity.getClassName(),
									propertyName=propertyKey
								}
							);
							if(!right(rbkey,8) == '_missing'){
								constraint['rbkey'] = rbkey;
							}
						}
						
						if(!structKeyExists(validationInfo[entityName]['validations'][processContext]['validations'],propertyKey)){
							validationInfo[entityName]['validations'][processContext]['validations'][propertyKey] = processValidationStruct[propertyKey];
						}else{
							structAppend(validationInfo[entityName]['validations'][processContext]['validations'][propertyKey],processValidationStruct[propertyKey]);
						}
					}
				}

				try{
					if(arrayFind(entityContexts,processContext)){
						var processObject = entity;
					}else{
						var processObject = entity.getProcessObject(processContext);
					}
					validationStruct = getService('hibachiValidationService').getValidationStruct(processObject);
					if(structKeyExists(validationStruct,'conditions')){
						validationInfo[entityName]['validations'][processContext]['conditions'] =validationStruct.conditions;
					}
					if(structKeyExists(validationStruct,'populatedPropertyValidation')){
						validationInfo[entityName]['validations'][processContext]['populatedPropertyValidation'] =validationStruct.populatedPropertyValidation;
					}
				}catch(any e){

				}

			}
		}
		return validationInfo;
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
			baseComponentMetaData[componentName]['functions'] = getFunctions(componentMetaData);
    		if(structKeyExists(componentMetaData,'description')){
    			baseComponentMetaData['description'] = componentMetaData.description;
			}
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
    		if(structKeyExists(componentMetaData,'description')){
    			serviceComponentMetaData[componentName]['description'] = componentMetaData.description;
    		}
			if(structKeyExists(componentMetaData,'functions')){
				serviceComponentMetaData[componentName]['functions'] = getFunctions(componentMetaData);
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
    		if(structKeyExists(componentMetaData,'description')){
    			daoComponentMetaData[componentName]['description'] = componentMetaData.description;
    		}
			if(structKeyExists(componentMetaData,'functions')){
				daoComponentMetaData[componentName]['functions'] = getFunctions(componentMetaData);
			}
			if(structKeyExists(componentMetaData,'properties')){
				daoComponentMetaData[componentName]['properties'] = componentMetaData.properties;
			}
		}
		return daoComponentMetaData;
	}

	public struct function generateProcessJson(){
		var processComponentDirectoryListing = getService('hibachiService').getProcessComponentDirectoryListing();

		var processComponentMetaData = {};

		for(var componentCFCName in processComponentDirectoryListing){
			if(componentCFCName != 'HibachiProcess.cfc'){
				var componentName = listFirst(componentCFCName,'.');
			var componentMetaData = getComponentMetaData(getService('hibachiService').getProcessComponentPath()&componentName);
			processComponentMetaData[componentName] = {};
			processComponentMetaData[componentName]['extends'] = getExtended(componentMetaData);
			if(structKeyExists(componentMetaData,'functions')){
				processComponentMetaData[componentName]['functions'] = getFunctions(componentMetaData);
			}
			if(structKeyExists(componentMetaData,'properties')){
					for(var property in componentMetaData['properties']){
		    			//use description on the property else find an rbkey hint
		    			if(!structKeyExists(property,'description')){
		    				property['description'] = getHibachiScope().rbkey('processObject.#componentName#.#property.name#_description');
		    				if(right(property['description'], "8") == "_missing") {
		    					property['description'] = getHibachiScope().rbkey('processObject.#componentName#.#property.name#_hint');
		    				}
		    				if(right(property['description'], "8") == "_missing") {
								property['description'] = "";
							}
		    			}
		    		}
				processComponentMetaData[componentName]['properties'] = componentMetaData.properties;
			}
				
				if(structKeyExists(componentMetaData,'description')){
	    			processComponentMetaData[componentName]['description'] = componentMetaData.description;
	    		}else{
	    			processComponentMetaData[componentName]['description'] = getHibachiScope().rbkey('processObject.#componentName#_description');
					if(right(processComponentMetaData[componentName]['description'], "8") == "_missing") {
						processComponentMetaData[componentName]['description'] = getHibachiScope().rbkey('processObject.#componentName#_hint');
					}
					if(right(processComponentMetaData[componentName]['description'], "8") == "_missing") {
						processComponentMetaData[componentName]['description'] = "";
					}
				}
			}
		}
		return processComponentMetaData;
	}

	public array function getExtended(required struct object, array extended=[]){
		if(arguments.object.fullname != 'lucee.Component'){
			arrayAppend(arguments.extended,object.fullname);
		}

		if(structKeyExists(arguments.object,'extends')){
			arguments.extended = getExtended(arguments.object.extends,arguments.extended);
		}
		return arguments.extended;
	}

	public array function getFunctions(required any object){
		var functionArray = [];
    	for(var f in object.functions){
    		var functionItem = {};
    		functionItem['name'] = f.NAME;
    		
    		var firstThreeChars = left(f.NAME,3);
    		var firstSixChars = left(f.NAME,6);
    		var modelComponentPath = 'Slatwall.model.entity';
    		if(left(object.fullname,len(modelComponentPath)) == modelComponentPath ){
    			if(
	    			(
	    				firstThreeChars == 'get'
		    			|| firstThreeChars == 'set'
		    		) 
		    		&& 
		    		(
		    			getService('hibachiService').getEntityHasPropertyByEntityName(listLast(arguments.object.name,'.'),right(f.name,len(f.name)-3))
						|| getService('hibachiService').hasPropertyByEntityNameAndSinuglarName(listLast(arguments.object.name,'.'),right(f.name,len(f.name)-3))
					)
				){
	    			 functionItem['isImplicit'] = true;
	    		}else if(
	    			(
		    			firstThreeChars == 'add'
						|| firstThreeChars == 'has'
					)
					&& (
						getService('hibachiService').hasPropertyByEntityNameAndSinuglarName(listLast(arguments.object.name,'.'),right(f.name,len(f.name)-3))
						|| getService('hibachiService').getHasPropertyByEntityNameAndPropertyIdentifier(listLast(arguments.object.name,'.'),right(f.name,len(f.name)-3))
					)
				){
	    			functionItem['isImplicit'] = true;
	    		}else if(
	    			(
	    				firstSixChars == 'remove'
		    		) 
		    		&& (
		    			getService('hibachiService').hasPropertyByEntityNameAndSinuglarName(listLast(arguments.object.name,'.'),right(f.name,len(f.name)-6))
		    			|| getService('hibachiService').getHasPropertyByEntityNameAndPropertyIdentifier(listLast(arguments.object.name,'.'),right(f.name,len(f.name)-6))
		    		)
	    		){
	    			
	    			functionItem['isImplicit'] = true;
	    		}else{
	    			
	    			functionItem['isImplicit'] = false;
	    		}
    		}else{
	    			
    			functionItem['isImplicit'] = false;
    		}
    		
    		if(structKeyExists(f,'RETURNTYPE')){
    			functionItem['returntype'] = f.RETURNTYPE;
    		}
    		if(structKeyExists(f,'PARAMETERS')){
    			functionItem['parameters'] = f.PARAMETERS;
    		}
    		if(structKeyExists(f,'DESCRIPTION')){
    			functionItem['description'] = f.DESCRIPTION;
    		}
    		if(structKeyExists(f,'ProcessMethod')){
    			functionItem['ProcessMethod'] = f.ProcessMethod;
    		}
    		arrayAppend(functionArray,functionItem);
    	}
    	
    	return functionArray;
	}

}
