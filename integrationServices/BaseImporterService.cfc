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
component extends="Slatwall.model.service.HibachiService" persistent="false" accessors="true" output="false"{
	
	
	property name = "locationService";
	property name = "stockService";
	property name = "addressService";
	property name = "importerMappingService";
	
	property name = "hibachiService";
	property name = "hibachiUtilityService";
	property name = "hibachiValidationService";
	property name = "hibachiEntityQueueService";
	property name = "hibachiEntityQueueDAO";
	property name = "OptionDAO";
	
	property name = "cachedEntityMappings" type="struct";
	property name = "cachedMappingPropertiesValidations" type="struct";
	
	
	public any function init() {
	    super.init(argumentCollection = arguments);
	    this.setCachedEntityMappings( {} );
	    this.setCachedMappingPropertiesValidations( {} );
	}
	
	
	
	/*****************                      Meta-Data                 ******************/
	
    public any function getIntegration(){
        throw("override this function in your integrtion service to return the associated instance of integration-entity");
    }

	public struct function getMappingByMappingCode( required string mappingCode ){
	    return this.getImporterMappingService().getMappingByMappingCode(arguments.mappingCode);
	}
    
    // TODO: remove [renamed getEntityCSVHeaderMetaData]
  	public struct function getMappingCSVHeaderMetaData( required string mappingCode ){
	    return this.getImporterMappingService().getMappingCSVHeaderMetaData(argumentCollection=arguments);
  	}
  	
  	
  	
  	/*****************              Process - Queue - Process                 ******************/

    public any function createNewImportBatch(required struct mapping, required any queryOrArrayOfStruct){
	    //Create a new Batch
	    var newBatch = this.getHibachiEntityQueueService().newBatch();
	    
	    if(isQuery(arguments.queryOrArrayOfStruct)){
	        var batchItemsCount = arguments.queryOrArrayOfStruct.recordCount; // query
	    } else {
	        var batchItemsCount = arguments.queryOrArrayOfStruct.len() // array
	    }
	    
	    newBatch.setBaseObject( arguments.mapping.entityName );
	    newBatch.setInitialEntityQueueItemsCount(batchItemsCount);
	    newBatch.setBatchDescription("Import Batch for Entity-#arguments.maping.entityName#. Mapping-[#arguments.mapping.mappingCode#] of length [#batchItemsCount#]  created on " & dateFormat(now(), "long") );
	    
	    this.getHibachiEntityQueueService().saveBatch(newBatch);
	    this.getHibachiScope().flushORMSession();
	    
        return newBatch;
    }


	public any function pushRecordsIntoImportQueue( required string mappingCode, required any queryOrArrayOfStruct, any batch ){
	    
	    var mapping = this.getMappingByMappingCode(arguments.mappingCode);
	    if( isNull(arguments.batch) ){
	        arguments.batch = this.createNewImportBatch(mapping=mapping, queryOrArrayOfStruct=arguments.queryOrArrayOfStruct);
	    }
	    
	    for( var record in queryOrArrayOfStruct ){
	        this.pushRecordIntoImportQueue( mapping, record, arguments.batch.getBatchID() );
	    }
	    
	    return arguments.batch;
	}
	
	public any function pushRecordIntoImportQueue( required struct mapping, required struct data, required string batchID ){
	    
	    var preProcessFunctionName = "preProcess#arguments.mapping.mappingCode#Data";
	    if( structKeyExists(this, preProcessFunctionName) ){
            arguments.data = this.invokeMethod( preProcessFunctionName, { "data" : arguments.data } );
	    }
	    
	    // if preprocess data is null then skip rest of the logic
	    if( isNull(arguments.data) ){
	    	return;
	    }
		
        var validation = this.validateMappingData( 
            data          = arguments.data, 
            mapping       = arguments.mapping,
            collectErrors = true
        );
    
        if( !validation.isValid ){
            
            var entityQueueData = {
                'data'          : arguments.data,
                'batchID'       : arguments.batchID,
                'mappingCode'   : arguments.mapping.mappingCode
            }
            
            // if we're collecting errors we can directly send the item to failures (EntityQueue hisory)
            this.getHibachiEntityQueueDAO().insertEntityQueueFailure(
        	    baseID              = '', //not needed
        	    baseObject          = arguments.mapping.entityName, 
        	    processMethod       = 'reQueueImportFailure',
        	    entityQueueData     = entityQueueData, 
        	    integrationID       = this.getIntegration().getIntegrationID(), 
        	    batchID             = arguments.batchID,
        	    mostRecentError     = serializeJson( validation.errors )
        	);
        	
        } else {
        
    	    var transformedData = this.transformMappingData( 
    	        data           = arguments.data,
    	        mapping        = arguments.mapping,
    	        emptyRelations = validation.emptyRelations
    	    );
    	    
    
    	    var primaryIDPropertyName = this.getHibachiService().getPrimaryIDPropertyNameByEntityName( arguments.mapping.entityName );
    
    	    this.getHibachiEntityQueueDAO().insertEntityQueue(
        	    baseID              = transformedData[ primaryIDPropertyName ], 
        	    baseObject          = arguments.mapping.entityName, 
        	    processMethod       = 'processEntityImport',
        	    entityQueueData     = transformedData, 
        	    integrationID       = this.getIntegration().getIntegrationID(), 
            	batchID             = arguments.batchID
        	);
	    }
	
	    return validation;
	}
	
	public any function reQueueImportFailure( required any entity, required struct entityQueueData ){

        var validation = this.pushRecordIntoImportQueue(
            data    = arguments.entityQueueData.data, 
            batchID = arguments.entityQueueData.batchID, 
            mapping = this.getMappingByMappingCode(arguments.entityQueueData.mappingCode) 
        );
        
        if(!validation.isValid){
            arguments.entity.setErrors( validation.errors );
        }
	    
	    return arguments.entity;
	}
	
	public struct function resolveMappingLazyProperties(
	    required struct transformedData, 
	    required struct mapping,
	    struct sourceData
    ){
	    
	    var extentionFunctionName = "resolve#arguments.mapping.mappingCode#LazyProperties";
	    if( structKeyExists(this, extentionFunctionName) ){
	        return this.invokeMethod( extentionFunctionName, arguments );
	    }
        
        if(!structKeyExists(arguments, 'sourceData') || this.hibachiIsEmpty(arguments.sourceData)){
            arguments.sourceData = arguments.transformedData['__sourceData'];
        }
	    
	    if( structKeyExists(arguments.transformedData.__lazy, 'properties') ){
	        var properties = arguments.transformedData.__lazy.properties;
	        
	        for(var sourcePropertyName in properties){
	            var propertyMetaData = properties[sourcePropertyName];
	            
	            var propertyValue = this.getOrGeneratePropertyValue(
    	            data                 = arguments.sourceData, 
        	        mapping              = arguments.mapping,
        	        propertyMetaData     = propertyMetaData,
        	        sourcePropertyName   = sourcePropertyName,
        	        sourceDataKeysPrefix = arguments.transformedData['__sourceDataKeysPrefix']
    	        );
    	        
    	        if( !isNull(propertyValue) ){
            	    arguments.transformedData[ propertyMetaData.propertyIdentifier ] = propertyValue;
    	        }
	        }
	    }
	    
	    if( structKeyExists(arguments.transformedData.__lazy, 'generatedProperties') ){
	        for(var propertyMetaData in arguments.transformedData.__lazy.generatedProperties ){
	            var propertyValue = this.getOrGeneratePropertyValue(
    	            data               = arguments.sourceData, 
        	        mapping            = arguments.mapping,
        	        propertyMetaData   = propertyMetaData
        	    );
        	   
    	        if( !isNull(propertyValue) ){
            	    arguments.transformedData[ propertyMetaData.propertyIdentifier ] = propertyValue;
    	        }
	        }
	    }
	    
	    if( structKeyExists(arguments.transformedData.__lazy, 'relations') ){
	        for( var thisRelation in arguments.transformedData.__lazy.relations ){
	            
	            var transformedRelationData = arguments.transformedData[ thisRelation.propertyIdentifier ];
	            var relationMapping = this.getMappingByMappingCode( thisRelation.mappingCode );
	            
	            transformedRelationData = this.resolveMappingLazyProperties( 
	                mapping         = relationMapping,
	                sourceData      = arguments.sourceData,
	                transformedData = transformedRelationData
	            );
	            
	            arguments.transformedData[ thisRelation.propertyIdentifier ] = transformedRelationData;
	        }    
	    }
	    
	    return arguments.transformedData;
	}
	
	public void function resolveEntityDependencies(required any entity, required struct entityQueueData, required struct mapping ){
	    
	    var extentionFunctionName = "resolve#arguments.mapping.mappingCode#Dependencies";
	    if( structKeyExists(this, extentionFunctionName) ){
            this.invokeMethod( extentionFunctionName, arguments );
	    } else {
	        this.genericResolveEntityDependencies( argumentCollection=arguments );
	    }
	}
	
	public void function genericResolveEntityDependencies(required any entity, required struct entityQueueData ){
	    
	    for( var dependency in arguments.entityQueueData.__dependencies ){
	    	
        	 /**
	         * Fallback order 
	         * 1. resolver-function provided in the dependencyMetaData
	         * 
	         * 2. resolve it using regular `resolveEntityDependencies` flow
	         * 
	        */
	        
	        if( structKeyExists(dependency, 'resolverFunction') ){
	            return this.invokeMethod( dependency.resolverFunction, arguments );
	        }
	        
	        
            if( structKeyExists(dependency, 'lookupValue') ){
                var dependencyPrimaryIDValue = this.getHibachiService().getPrimaryIDValueByEntityNameAndUniqueKeyValue(
                    "entityName"    = dependency.entityName,
        	        "uniqueKey"     = dependency.lookupKey,
        	        "uniqueValue"   = dependency.lookupValue
                );

            }   
            if( !structKeyExists(dependency, 'isNullable') ){
                // by default every dependency is treated as required [ not-nullable ]
                dependency.isNullable = false; 
            }
            
            var dependencyPrimaryIDProperty = this.getHibachiService().getPrimaryIDPropertyNameByEntityName( dependency.entityName );
            
            if( !isNull(dependencyPrimaryIDValue) && !this.hibachiIsEmpty(dependencyPrimaryIDValue) ){
                
                arguments.entityQueueData[ dependency.propertyIdentifier ] = { "#dependencyPrimaryIDProperty#" : dependencyPrimaryIDValue }
                
            } else if( !dependency.isNullable ){
                
                // if the dependency contains a default-value, use that
                if( structKeyExists(dependency, 'defaultValue') ){
                    arguments.entityQueueData[ dependency.propertyIdentifier ] = { "#dependencyPrimaryIDProperty#" : dependency.defaultValue }
                    continue;
                }
            
                // if any required dependency is not resolved then we can't continue with the import 
                arguments.entity.addError( 
                    dependency.propertyIdentifier, 
                    "Depandancy for propertyIdentifier [#dependency.propertyIdentifier#] on Entity [#arguments.entity.getClassName()#] could not be resolved."    
                );
                break;
            }
            // else we're ignoreing if the dependency is not resolved, as it's nullable
        }
	}

	public void function resolveMappingVolatileRelations(required string mappingCode, required struct entityData ){
	    
	    var extentionFunctionName = "resolve#arguments.mappingCode#VolatileRelations";
	    if( structKeyExists(this, extentionFunctionName) ){
	        return this.invokeMethod( extentionFunctionName, arguments );
	    }
	      
        for( var relation in arguments.entityData.__volatiles ){
             
            var relationData = arguments.entityData[ relation.propertyIdentifier ];
            
            if( relation.isVolatile ){
                
                var relationPrimaryIDValue = this.getHibachiService().getPrimaryIDValueByEntityNameAndUniqueKeyValue(
                    "entityName"  = relation.entityName,
        	        "uniqueKey"   = 'importRemoteID',
        	        "uniqueValue" = relationData.importRemoteID
                );
                
                if( !isNull(relationPrimaryIDValue) && !this.hibachiIsEmpty(relationPrimaryIDValue) ){
                    var relationPrimaryIDProperty = this.getHibachiService().getPrimaryIDPropertyNameByEntityName( relation.entityName );
                    // replaces the nested struct in arguments.entityData
                    arguments.entityData[ relation.propertyIdentifier ] = { "#relationPrimaryIDProperty#" : relationPrimaryIDValue }; 
                }
                
            } else if(relation.hasVolatiles) {
                this.resolveMappingVolatileRelations( relation.mappingCode, relationData );
            }
        }
	}
	
	public any function invokePostPopulateMethodsRecursively(required any entity, required struct mapping){
	    
	    if( structKeyExists(arguments.mapping, 'postPopulateMethods') && isArray(arguments.mapping.postPopulateMethods) ){
	        for( var methodName in arguments.mapping.postPopulateMethods ){
	            arguments.entity.invokeMethod( methodName );
	        }
	    }
	    
	    if( structKeyExists(arguments.mapping, 'relations') ){
	       
	        for(var related in arguments.mapping.relations ){
	        	
	            if(structKeyExists(related, 'excludeFromPostPopulateMethod') && related.excludeFromPostPopulateMethod ){
	               // TODO use better naming-convention  or find a different solution
	                continue;
	            }

	            // this might return an entity or an array in case of *-to-many relations
  	            var relatedEntityOrArray = arguments.entity.invokeMethod( 'get'&related.propertyIdentifier );
  	         
  	            if( !isNull(relatedEntityOrArray) ){
  	                
                    if( !isArray(relatedEntityOrArray) ){
                        relatedEntityOrArray = [ relatedEntityOrArray ];
                    }
                    
                    for( var relatedEntity in relatedEntityOrArray ){
                        this.invokePostPopulateMethodsRecursively( 
                            entity   = relatedEntity,
                            mapping = this.getMappingByMappingCode( related.mappingCode )
                        ); 
                    }
  	            }
	        }
	        
	    }
	}
	
	public any function invokePostSaveMethodsRecursively(required any entity, required struct mapping){
	    
	    if( structKeyExists(arguments.mapping, 'postSaveMethods') && isArray(arguments.mapping.postSaveMethods) ){
	        for( var methodName in arguments.mapping.postSaveMethods ){
	            arguments.entity.invokeMethod( methodName );
	        }
	    }
	    
	    if( structKeyExists(arguments.mapping, 'relations') ){
	       
	        for(var related in arguments.mapping.relations ){
	        	
	        	if(structKeyExists(related, 'excludeFromPostSaveMethod') && related.excludeFromPostSaveMethod ){
	               // TODO use better naming-convention  or find a different solution
	                continue;
	            }
	            
	            // this might return an entity or an array in case of *-to-many relations
  	            var relatedEntityOrArray = arguments.entity.invokeMethod( 'get'&related.propertyIdentifier );
  	         
  	            if( !isNull(relatedEntityOrArray) ){
  	                
                    if( !isArray(relatedEntityOrArray) ){
                        relatedEntityOrArray = [ relatedEntityOrArray ];
                    }
                    
                    for( var relatedEntity in relatedEntityOrArray ){
                        this.invokePostSaveMethodsRecursively( 
                            entity   = relatedEntity,
                            mapping = this.getMappingByMappingCode( related.mappingCode )
                        ); 
                    }
  	            }
	        }
	        
	    }
	}

	public any function processEntityImport( required any entity, required struct entityQueueData, struct mapping ){

	    var entityName = arguments.entity.getClassName();
	    
	    if(isNull(arguments.mapping)){
	        arguments.mapping = this.getMappingByMappingCode( arguments.entityQueueData.mappingCode );
	    }
        
        var extensionFunctionName = 'process#entityName#_import';
	    if( structKeyExists(this, extensionFunctionName) ){
	        return this.invokeMethod( extensionFunctionName, arguments );
	    }
	    
	    if( !structKeyExists(arguments, 'mapping') ){
            arguments.mapping = this.getMappingByMappingCode( entityName );
        }
        
        if( structKeyExists(arguments.entityQueueData, '__lazy')){
            this.resolveMappingLazyProperties( 
                transformedData = arguments.entityQueueData,
                mapping = arguments.mapping
            );
        }

        // make-sure all of the dependencies had been resolved, 
        // like Product is required before SKU can be created for that Product	    
	    if( structKeyExists(arguments.entityQueueData, '__dependencies') ){
            this.resolveEntityDependencies(argumentCollection = arguments);
    	    if(arguments.entity.hasErrors()){
    	        return arguments.entity;
    	    }
	    }
	    
	    // make-sure that volatile-relaions are resolved
	    // volatile-relaions --> 
	    // related-entities which can be created by one of many records in the queue, 
	    // for example, Brand can be created by one of multiple-products(which belongs to the same brand) getting imported 
	    if( structKeyExists(arguments.entityQueueData, '__volatiles') ){
            this.resolveMappingVolatileRelations(arguments.mapping.mappingCode, arguments.entityQueueData);
	    }
	    
	    // we're populating in private-mode, which will set properties having hb_populateEnabled = [ true, public, private ]
	    arguments.entity.populate( data=arguments.entityQueueData, objectPopulateMode='private' );

	    // will invoke Functions to be called after populating the entity, like `updateCalculatedProperties`
	    this.invokePostPopulateMethodsRecursively( arguments.entity, arguments.mapping );
	    
	    
	    var entityService = this.getHibachiService().getServiceByEntityName( entityName=entityName );
	    if( !structKeyExists(arguments.mapping, 'validationContext') ){
	        arguments.mapping['validationContext'] = 'save';
	    }
	    
	    arguments.entity = entityService.invokeMethod( "save"&entityName,  { 
	        // "#entityName#" needs to be unwrapped, as variables are not allowed as keys in stucts
	        "#entityName#"  : arguments.entity, 
	        "context"       : arguments.mapping.validationContext
	    });
	    
	    
        // will invoke Functions to be called after saving the entity, like `updateCalculatedProperties`
        this.invokePostSaveMethodsRecursively( arguments.entity, arguments.mapping );
   
	    
	    return arguments.entity;
	}
	
	
	
	/*****************                      VALIDATE                 ******************/

    public struct function validateMappingData(
        required struct data, 
        string mappingCode, 
        struct mapping, 
        boolean collectErrors = false,
        string sourceDataKeysPrefix = ''
    ){
        
        if( !structKeyExists(arguments, 'mapping') ){
            arguments.mapping = this.getMappingByMappingCode( arguments.mappingCode );
        }
        
        var validatorFunctionName = 'validate#arguments.mappingCode#Data';
        
        if( structKeyExists( this, validatorFunctionName) ){
            return this.invokeMethod( validatorFunctionName, arguments );
        } else {
    	    return this.genericValidateMappingData( argumentCollection = arguments);
        }
    }
    
    public struct function getMappingPropertiesValidations( required struct mapping ){
        
        var cachedMappingPropertiesValidations = this.getCachedMappingPropertiesValidations();
        var cacheKey = hash(serializeJson(arguments.mapping), 'md5');
        
        if(structKeyExists(cachedMappingPropertiesValidations, cacheKey) ){
            return cachedMappingPropertiesValidations[ cacheKey ];
        }
        
        var propertiesValidations = {};
        // loop over all of the properties and grab all of the properties having validation rules
	    if( structKeyExists(arguments.mapping, 'properties') ){
    	    for( var sourcePropertyName in arguments.mapping.properties ){
    	        var propertyMetaData = arguments.mapping.properties[sourcePropertyName];
    	        if( structKeyExists(propertyMetaData, 'validations') ){
    	            propertiesValidations[ sourcePropertyName ] = propertyMetaData.validations;
    	        }
    	    }
	    }
	    
	    // loop over all of the entity dependencies and make sure the dependency-key prop is required in the validations
	    if( structKeyExists(arguments.mapping, 'dependencies') ){
	        for( var dependency in arguments.mapping.dependencies ){
	            // skip nullble dependencies
  	            if(structKeyExists(dependency, 'isNullable') && dependency.isNullable ){
  	                continue;
  	            }
  	            // skip dependencies having a default-value
  	            if(structKeyExists(dependency, 'defaultValue') && !this.hibachiIsEmpty(dependency.defaultValue) ){
  	                continue;
  	            }
  	            
  	            if( !structKeyExists(propertiesValidations, dependency.key) ){
  	                propertiesValidations[ dependency.key ] = {};
  	            }
  	            // make sure dependency-key[sourcePropertyName] is required
  	            propertiesValidations[ dependency.key ]['required'] = true;
	        }
	    }
        
	    // loop over all of the keys in importIdentifier and make sure these are required in the validations
	    for(var sourcePropertyName in mapping.importIdentifier.keys ){

            if( !structKeyExists(propertiesValidations, sourcePropertyName) ){
                propertiesValidations[ sourcePropertyName ] = {};
            }
            // make sure dependency sourcePropertyName is required
            propertiesValidations[ sourcePropertyName ]['required'] = true;
	    }
        
        
        // put it into cache
        cachedMappingPropertiesValidations[ cacheKey ] = propertiesValidations;
        
	    return propertiesValidations;
    }

	public struct function genericValidateMappingData(
	    required struct data, 
	    required struct mapping, 
	    boolean collectErrors = false,
	    string sourceDataKeysPrefix = ''
	){
	    
	    var validationService = this.getHibachiValidationService();
	    var entityName = arguments.mapping.entityName;
	    
	    var isValid = true;
	    var errors = {};
	    var emptyRelations = {};
	    var hasAllRequiredProperties = true;
	    
	    var entityPropertiesValidations = this.getMappingPropertiesValidations( arguments.mapping, arguments.sourceDataKeysPrefix);
	    
	    for( var propertyName in entityPropertiesValidations ){
	        
	        var propertyValidations = entityPropertiesValidations[propertyName];
	        
	        /*
	            Notes - on source-data-key-prefix:
	            
	            source-data-key-prefix is used in scenarios where we need to process multiple relations with same entity.
	  
	            e.g. when we're importing orders we can have a BillingAddress and a ShippingAddress, but both of these relations are with the same entity 
	            and we only have one mapping. As a solution we can prefix the address keys with something like `billing` and `shipping` respectively.
	        */
	        if( !this.hibachiIsEmpty(arguments.sourceDataKeysPrefix) ){
	            propertyName = arguments.sourceDataKeysPrefix & propertyName;
	        }
	        
            for( var constraintType in propertyValidations ){
                var constraintValue = propertyValidations[constraintType];
                
                isValid = this.validateConstraintType(
                    constraintType  = constraintType, 
                    constraintValue = constraintValue, 
                    propertyValue   = arguments.data[propertyName] ?: javaCast('null', 0)
                );
               
                if( !isValid ){
                
                    if( constraintType == 'required' && constraintValue == true ){
                        hasAllRequiredProperties = false;
                    }
                
                    // if we're instructed to collecth the errors.
                    if( arguments.collectErrors ){
                        var errorMessage = this.createErrorMessageForFailedConstraint(
                            entityName      = entityName,
                            propertyName    = propertyName,
                            constraintType  = constraintType,
                            constraintValue = constraintValue
                        );
                		// collecting the error
                		if( !structKeyExists(errors, propertyName) ){
                		    errors[propertyName] = [];
                		}
                        ArrayAppend( errors[propertyName],  errorMessage );  
                		//resetting the flag to continue validating;
                        isValid = true;
                    } else { 
                        break;
                    }
                }
            }
        
	        if( !isValid && !arguments.collectErrors ){
	            break;
	        }
	    }

	    // validate related sub-entities as well
	    if( (isValid || arguments.collectErrors) && structKeyExists(arguments.mapping, 'relations') ){
	       
	        for(var thisRelation in arguments.mapping.relations ){
	        
	           	if( structKeyExists(thisRelation, 'excludeFromValidation') && thisRelation.excludeFromValidation){
	           	    continue;
	           	}
	           	
           	    if( !structKeyExists(thisRelation, 'isNullable') ){
                    // by default every relation is treated as required [ not-nullable ]
                    thisRelation.isNullable = false; 
                }
                
                thisRelation['isEmptyRelation'] = false;
                thisRelation['hasEmptyRelations'] = false;
                
                var relationValidation = this.validateMappingData(
                    data                 = arguments.data,  
                    mappingCode          = thisRelation.mappingCode, 
                    collectErrors        = arguments.collectErrors,
                    sourceDataKeysPrefix = thisRelation.sourceDataKeysPrefix ?: ''
                );
                
                if( !relationValidation.emptyRelations.isEmpty() ){
                    thisRelation['hasEmptyRelations'] = true;
                    thisRelation['emptyRelations'] = relationValidation.emptyRelations;
                }
                
                if( !relationValidation.isValid ){
                
                    if( !relationValidation.hasAllRequiredProperties && thisRelation.isNullable ){
                        /*
                         if all of the required fields for the relation are not available in the source-data 
                         and it's nullable relation; 
                         than we carry-forward this info into transform-entity-data function, 
                         so that it can ignore createing data for this relation;
                         
                         if the relation is not-nullable then the validation will still errors-out;
                         
                        */
                        
                        thisRelation.isEmptyRelation = true;
                        
                        // NOTE: validation errors for nullable-relations are ignored
                        
                    } else if( arguments.collectErrors ){
                    
                            errors = this.mergeErrors( errors, relationValidation.errors );
                            
                    } else {
                        // else if the validation has failed and the relations is not nullable 
                        // and we're not collecting errors than we can break the loop;
                        break;
                    }
                }

                if( thisRelation.isEmptyRelation || thisRelation.hasEmptyRelations ){
                    emptyRelations[ thisRelation.propertyIdentifier ] = thisRelation;
                }
	        }
	    }
	    
	    
	    return { 
	        'isValid'                     : arguments.collectErrors ? StructIsEmpty( errors ) : isValid, 
	        'errors'                      : errors,
	        'emptyRelations'              : emptyRelations,
	        'hasAllRequiredProperties'    : hasAllRequiredProperties
	    };
	}
	
	public boolean function validateConstraintType(required string constraintType, required string constraintValue, any propertyValue){
	    
	    var validationFunctionName = 'validate_#arguments.constraintType#_value';
        var validationService = this.getHibachiValidationService();
        
        if( structKeyExists(this, validationFunctionName) ){
            return this.invokeMethod( validationFunctionName, { 
               propertyValue    =  arguments.propertyValue ?: javaCast('null', 0),
               constraintValue  =  arguments.constraintValue
            });
        }  
        
        if( structKeyExists( validationService, validationFunctionName) ){
            return validationService.invokeMethod( validationFunctionName, { 
               propertyValue    =  arguments.propertyValue ?: javaCast('null', 0),
               constraintValue  =  arguments.constraintValue
            });
        } 
        
        throw("invalid validation constraint type : #constraintType#, function #validationFunctionName# does not exist");
	}
	
	public string function createErrorMessageForFailedConstraint(
	    required string entityName,
	    required string propertyName,
	    required string constraintType,
	    required string constraintValue
	){
	    
	    var rbKey = "validate.import.#arguments.entityName#.#arguments.propertyName#.#arguments.constraintType#";
	    if( arguments.constraintType eq "dataType" ){
            rbKey &= ".#arguments.constraintValue#";
		}
		
		return this.getHibachiUtilityService().replaceStringTemplate( this.getHibachiScope().rbKey( rbKey ), {
		    "className"         : entityName,
		    "propertyName"      : propertyName,
		    "constraintValue"   : constraintValue 
	    });
	}
	
	/**
	 * utility function to merge 2 errro structs
	 * 
	 * Error struct looks like 
	 *  { 
	 *      errorName1: ["error message one", "one more error message"] 
	 *      errorName2: ["error message two"]
	 *      ......
	 *  }
	 * 
	 */
	public struct function mergeErrors(required struct errors1, required struct errors2){
	    
	    for(var propertyName in arguments.errors2 ){
	        if( !structKeyExists(arguments.errors1, propertyName) ){
	            arguments.errors1[propertyName] = arguments.errors2[propertyName];
	        } else {
	            arguments.errors1[propertyName] = arguments.errors1[propertyName].merge( arguments.errors2[propertyName] );
	        }
	    }
	    
	    return arguments.errors1;
	}
	
	
	
	/*****************         VALIDATOR-FUNCTIONS                 ******************/
	/**
        Conventional validate-functions `validate_constraintType` in the service, 
        as an override to hibachi-validation-service functions
        Ex. validate_constraintType_value(){......} 
	*/
	
	
	
	
	/*****************      END : VALIDATOR-FUNCTIONS                 ******************/
	
	
	
	/*****************                      TRANSFORM                 ******************/

    public struct function transformMappingData(
        required struct mapping, 
        required struct data, 
        struct emptyRelations = {}, 
        boolean nested = false,
        string sourceDataKeysPrefix = ''
    ){
        if( structKeyExists( this, 'transform#arguments.mapping.mappingCode#Data') ){
            return this.invokeMethod( 'transform#arguments.mapping.mappingCode#Data', arguments );
        } 
        
    	return this.genericTransformMappingData( argumentCollection = arguments);
    }
    
	public struct function genericTransformMappingData( 
	    required struct data, 
	    required struct mapping, 
	    struct emptyRelations = {}, 
	    boolean nested = false,
        string sourceDataKeysPrefix = ''
    ){
	    var entityName = arguments.mapping.entityName;
	    var transformedData = {};
	    
	    if(!arguments.nested){
	        // snapshot source-data and mapping-Code so that we can have multiple mapings per entity and use the source-data later on;
	        transformedData['__sourceData'] = arguments.data;
	        transformedData['mappingCode'] = arguments.mapping.mappingCode;
	    }
	    
        transformedData['__sourceDataKeysPrefix'] = arguments.sourceDataKeysPrefix;
	    
	    // Inferd properties, importRemoteID and `primaryIDProperty`
	    var importRemoteIDValue = this.createMappingImportRemoteID(argumentCollection=arguments);
	  	
	  	transformedData['importRemoteID'] = importRemoteIDValue;
	  
	    var primaryIDPropertyName = this.getHibachiService().getPrimaryIDPropertyNameByEntityName( entityName );
	    /**
	      * if there's no promaryIDValue in the data, 
	      * try to infer from the database( in case of upserts ) 
	      * otherwise set it to empty string (in case of insert)
	      * 
	    */
	    if( !structKeyExists( arguments.data, primaryIDPropertyName ) || this.hibachiIsEmpty( arguments.data[ primaryIDPropertyName ] ) ){
	        
    	    /** 
    	     * This will execute a query against the DB like:
    	     *  
    	     *  Select
    	     *      accountPhoneNumberID 
    	     *  From 
    	     *      swAccountPhoneNubmer 
    	     *  Where 
    	     *      "importRemoteID" ="3CEF96DCC9B8035D23F69E30BB19218A_544C0D3D51EFBA18DB26C48C7B69E025"
    	     * 
    	    */
	        var primaryIDValue = this.getHibachiService().getPrimaryIDValueByEntityNameAndUniqueKeyValue(
    	        "entityName"  = entityName,
    	        "uniqueKey"   = 'importRemoteID',
    	        "uniqueValue" = importRemoteIDValue
    	    );

	        arguments.data[ primaryIDPropertyName ] =  primaryIDValue ?: '';
	    }
	    
	    transformedData[ primaryIDPropertyName ] = arguments.data[ primaryIDPropertyName ];
	    
	    
	    // First level properties from mapping everything inside `mapping.properties`
	    if( structKeyExists(arguments.mapping, 'properties') ){
	        
    	    for( var sourcePropertyName in arguments.mapping.properties ){
    	        
    	        var propertyMetaData = arguments.mapping.properties[ sourcePropertyName ];
    	        
    	        // SKIP if it's a create-only property, and we're upserting
    	        if(structKeyExists(propertyMetaData, 'allowUpdate') && !propertyMetaData.allowUpdate ){
    	            // primaryIdProperty value Is Not Empty, skipping this property
    	            if( !this.hibachiIsEmpty( transformedData[ primaryIDPropertyName ] ) ){
    	                continue;
    	            }
    	        }
    	        
    	        if(structKeyExists(propertyMetaData, 'evaluationMode') ){
                    if( propertyMetaData.evaluationMode == 'lazy'){
                        
                        if( !structKeyExists(transformedData, '__lazy') ){
                            transformedData['__lazy'] = {};
                        }
                        
                        if( !structKeyExists(transformedData['__lazy'], 'properties') ){
                            transformedData['__lazy']['properties'] = {}
                        }
                        
                        transformedData['__lazy']['properties'][ sourcePropertyName ] = propertyMetaData;
                        
                        continue;
                    }
                }
    	        
    	        var propertyValue = this.getOrGeneratePropertyValue(
    	            data                 = arguments.data, 
        	        mapping              = arguments.mapping,
        	        propertyMetaData     = propertyMetaData,
        	        sourcePropertyName   = sourcePropertyName,
        	        sourceDataKeysPrefix = arguments.sourceDataKeysPrefix ?: ''
    	        );
                
    	        if( !isNull(propertyValue) ){
            	    transformedData[ propertyMetaData.propertyIdentifier ] = propertyValue;
    	        }
    	    }
	    }
	    
	    
	    // generated-properties, properties which don't have a source-property and are completely generated in slatwall, like `url-title`
	    if( structKeyExists(arguments.mapping, 'generatedProperties') ){
	        
	        for(var propertyMetaData in arguments.mapping.generatedProperties ){

	            // SKIP if it's a create-only property, and we're upserting
    	        if(structKeyExists(propertyMetaData, 'allowUpdate') && !propertyMetaData.allowUpdate ){
    	            // primaryIdProperty value Is Not Empty, skipping this property
    	            if( !this.hibachiIsEmpty( transformedData[primaryIDPropertyName] ) ){
    	                continue;
    	            }
    	        }
    	        
	            if(structKeyExists(propertyMetaData, 'evaluationMode') ){
                    if( propertyMetaData.evaluationMode == 'lazy'){
                        
                        if( !structKeyExists(transformedData, '__lazy') ){
                            transformedData['__lazy'] = {};
                        }
                        
                        if( !structKeyExists(transformedData['__lazy'], 'generatedProperties') ){
                            transformedData['__lazy']['generatedProperties'] = []
                        }
                        
                        // carry forward this info, so we that we can use it later.
                        transformedData['__lazy']['generatedProperties'].append(propertyMetaData);

                        continue;
                    }
                }
	            
    	        var propertyValue = this.getOrGeneratePropertyValue(
    	            data               = arguments.data, 
        	        mapping            = arguments.mapping,
        	        propertyMetaData   = propertyMetaData
        	    );
        	   
    	        if( !isNull(propertyValue) ){
            	    transformedData[ propertyMetaData.propertyIdentifier ] = propertyValue;
    	        }
	        }
	    }
	    
	    
	    // relational dependencies[ entities which should be present bofore this record can be processed],
	    // like `Product` should be present before SKU can be imported 
	    if( !arguments.nested && structKeyExists(arguments.mapping, 'dependencies') ){
	        
	        transformedData['__dependencies'] = [];
	        for( var dependency in arguments.mapping.dependencies ){
	        
	            if(structKeyExists(arguments.data, dependency.key) ){
	                dependency['lookupValue'] = arguments.data[ dependency.key ];
	            }
	            
	            transformedData['__dependencies'].append( dependency );
	        }
	    }
	    
	    // relations, properties which belong to some slatwall entity, like `email` is stored in AccountEmailAddress
	    if( structKeyExists(arguments.mapping, 'relations' ) ){
	        
	        for(var thisRelation in arguments.mapping.relations ){
	        
	            // we're creting a duplicate here, as we're maintainaing some state in this variable down the line and 
	            // if we don't duplicate then it's polutes the global mapping, which means the functionality will not work as expected;
	            thisRelation = structCopy(thisRelation); 
	            
	            if( structKeyExists(arguments.emptyRelations, thisRelation.propertyIdentifier) ){
	                // if we have this relation in empty-relations that let's use that, so we have additional info down the line
	                thisRelation = arguments.emptyRelations[ thisRelation.propertyIdentifier ];
	            }
	            
	            // SKIP if it's a create-only relation, and we're upserting
    	        if( structKeyExists(thisRelation, 'allowUpdate') && !thisRelation.allowUpdate ){
    	            // if primaryId-value Is Not Empty, then we're upsearting an existing record,
    	            // hence skip create-only relations
    	            if( !this.hibachiIsEmpty( transformedData[ primaryIDPropertyName ] ) ){
    	                continue;
    	            }
    	        }
	            
                var transformedRelationData = this.getOrGenerateRelationData(
                    data                = arguments.data,
                    parentEntityMapping = arguments.mapping,
                    relationMetaData    = thisRelation
                );
	                
                if( !isNull(transformedRelationData) && !this.hibachiIsEmpty(transformedRelationData) ){
                    
                    transformedData[ thisRelation.propertyIdentifier ] = transformedRelationData;
                    
                    // ************* Volatile-Relations *********//
                    
                    if( !isStruct(transformedRelationData) ){
                        continue;
                        // currently we're only supporting struct as volatiles and __lazy, [ many-to-one & one-to-one ] relations
                    }
                    
                    // collect and carry forward __lazy properties info for the relations. 
                    if( structKeyExists(transformedRelationData, '__lazy') ){
                        
                        if( !structKeyExists(transformedData, '__lazy') ){
                            transformedData['__lazy'] = {};
                        }
                        if( !structKeyExists(transformedData.__lazy, 'relations') ){
                            transformedData['__lazy']['relations'] = [];
                        }
                    
                        transformedData['__lazy']['relations'].append( thisRelation );
                    }
                    
                    /**********************************************************************************************
                     * A volatile relation is any relation which can be generated by multiple recoards in the queue,
                     * 
                     * for example we're importing Product and ProductType and Brand all together, 
                     * and when there is not a brand for a given name, a new Brand will get created automatically. 
                     * But there can be a scenario when there are multiple products in the queue that belongs to the same brnad 
                     * and the brand does not exist in Slatwall; in that case we'd want to create the brand 
                     * when the first product get's created and for the rest of them we'd want to re-use that same recoard.
                     * 
                     * if this relation is-volatile or if it has-volatiles we'll carrying it forward to the `processEntityImport` function
                     * so before creating actual entity-record we can query the DB and replace volatiles with already created entities
                     * 
                     ***********************************************************************************************/
                    
                    // if relation has one or ore sub-entities which are volatile
                    thisRelation['hasVolatiles'] = structKeyExists(transformedRelationData, '__volatiles');
                    
                    if( !structKeyExists(thisRelation, 'isVolatile') ){
                        thisRelation['isVolatile'] = false;
                    }
                    
                    // when the relation was volatile, but we're not creating a new recoard for this  
                    // as we have the primaaryID for the related entity
                    var relationPrimaryIdPropertyName = this.getHibachiService().getPrimaryIDPropertyNameByEntityName( thisRelation.entityName );
                    var relationPrimaryIdValue = transformedRelationData[ relationPrimaryIdPropertyName ];
                    if( thisRelation.isVolatile && !this.hibachiIsEmpty( relationPrimaryIdValue )  ){
                        thisRelation['isVolatile'] = false;
                    }
                    
                    if( thisRelation.isVolatile || thisRelation.hasVolatiles ){
                        
                        if( !structKeyExists(transformedData, '__volatiles') ){
                            transformedData['__volatiles'] = [];
                        }
                        
                        transformedData.__volatiles.append(thisRelation);
                    }
                    
                }
	        }
	        
	    }
	   
	   
	    return transformedData;
	}
	
    
    /**
     * utility function to get property value either from @data or generated using some helper functions  
     * 
    */ 
    public any function getOrGeneratePropertyValue( 
        required struct data, 
        required struct mapping,
        required struct propertyMetaData
        string sourcePropertyName,
        string sourceDataKeysPrefix = '',
    ){
        
        /**
         * Fallback order 
         * 1. generator-function provided in the propertyMetadata
         * 
         * 2. value in the incoming data
         * 
         * 3. default value from the propertyMetadata
        */
        
        // if the property is only for validation, it will not have a property identifier.
        if( !structKeyExists(arguments.propertyMetaData, 'propertyIdentifier') ){
            return;
        }
        
        var entityName = arguments.mapping.entityName;
        
        if( !structKeyExists(arguments, 'mapping')){
            arguments[ 'mapping' ] = this.getMappingByMappingCode( entityName );
        }
        
        if( structKeyExists(arguments.propertyMetaData, 'generatorFunction') ){
            return this.invokeMethod( arguments.propertyMetaData.generatorFunction, arguments );
        }  
        
        if( structKeyExists(arguments, 'sourcePropertyName') ){
            
            if( !this.hibachiIsEmpty(arguments.sourceDataKeysPrefix) ){
    	        arguments.sourcePropertyName = arguments.sourceDataKeysPrefix & arguments.sourcePropertyName;
    	    }
    	    
    	    if( structKeyExists(arguments.data, arguments.sourcePropertyName) ){
                var sourcePropertyValue = arguments.data[ arguments.sourcePropertyName ];
                
                // if the source value has length then we're returning that, otherwise we're treating empty as NULL
                // so in case of when source value is empty, it can return a default from the next if statement if available, otherwise it will be NULL implicitly
                if( !this.hibachiIsEmpty(sourcePropertyValue) ){
                    return sourcePropertyValue;
                }
    	    }
        }  
        
        if( structKeyExists(arguments.propertyMetaData, 'defaultValue') ){
            return arguments.propertyMetaData.defaultValue;
        }
	        
    }
    
    
    /**
     * utility function to get relation value either from @data or generated using some helper functions  
     * 
    */ 
    public any function getOrGenerateRelationData( 
        required struct data, 
        required struct parentEntityMapping,
        required struct relationMetaData
    ){
        
        if( structKeyExists(arguments.relationMetaData, 'isEmptyRelation') && arguments.relationMetaData.isEmptyRelation ){
            // if the validation failed for this relation and its nullable relation
            // then we need to skip it, as transform-data function won't have valid & enough data to process;
            return; 
        }
        
        /**
         * Fallback order 
         * 1. generator-function provided in the relationMetaData
         * 
         * 2. transform it using regular `transformMappingData` flow
         * 
        */
        
        if( structKeyExists(arguments.relationMetaData, 'generatorFunction') ){
            return this.invokeMethod( arguments.relationMetaData.generatorFunction, arguments );
        }
        
        //TODO: ( if-needed ) properly handle scenarios for -to-Many relations
        // if source-property for the relation already exist in the incoming-data, than it should be an array
        // otherwise if the incoming-data is a flat struct, then there will be only one new record in the generated-array
        var relationMapping = this.getMappingByMappingCode( arguments.relationMetaData.mappingCode );
        var transformedRelationData = this.transformMappingData( 
            mapping              = relationMapping, 
            data                 = arguments.data,
            emptyRelations       = arguments.relationMetaData.emptyRelations ?: {},
            nested               = true,
            sourceDataKeysPrefix = arguments.relationMetaData.sourceDataKeysPrefix ?: ''
        );
        
        if( listFindNoCase('oneToOne,manyToOne', arguments.relationMetaData.type) ){
            return transformedRelationData;
        }  
        
        if(  arguments.relationMetaData.type == 'oneToMany' ){
            // currently this expect only one item for [ -to-many ] array
            return [ transformedRelationData ];
        }
    }
    
	public string function createMappingImportRemoteID( 
	    required struct data, 
	    required struct mapping, 
	    string sourceDataKeysPrefix = ''
	){
        // explicit generator-function
        if( structKeyExists(arguments.mapping.importIdentifier, 'generatorFunction') ){
            return this.invokeMethod(arguments.mapping.importIdentifier.generatorFunction, arguments);
        }
        
	    return this.genericCreateMappingImportRemoteID( argumentCollection = arguments);
	}
	
	// generic function to create a `importRemoteID` from mapping and input-data
	public string function genericCreateMappingImportRemoteID( required struct data, required struct mapping, string sourceDataKeysPrefix = '' ){
	    return arguments.mapping.importIdentifier.keys.reduce( function(accumulated, key){ 
    	        // it is expected that each key exists in the data
    	        var value = trim(data[sourceDataKeysPrefix&key]);
    	        value = lcase(hash(value, 'MD5')); // we're l-casing the hash-value, as this's how all of the IDs are stored in the DB;
    	        return ListAppend( accumulated, value, '_'); 
	    }, '');
	}
	
	
	/*****************         GENERATOR-FUNCTIONS                 ******************/
	
	/////////////////.                 Account
	
	
	public any function generateAccountAuthenticationPassword( struct data, struct mapping, struct propertyMetaData ){
	    return this.getHibachiUtilityService().generateRandomPassword(10);
	}
	
	public boolean function generateAccountactiveFlag( struct data, struct mapping, struct propertyMetaData ){
	    return true;
	}
	
	
	
	
	/////////////////.                  Product 
	
	
	public any function generateProductUrlTitle( required struct data, required struct mapping, required struct propertyMetaData){
	   
	   return this.getHibachiUtilityService().createUniqueProperty(
	        entityName    = arguments.mapping.entityName, 
	        propertyName  = arguments.propertyMetaData.propertyIdentifier,
	        propertyValue = arguments.data.productName & arguments.data.productCode
	   );
	   
	}
	
	public any function generateBrandUrlTitle( required struct data, required struct mapping, required struct propertyMetaData){
	   
	   return this.getHibachiUtilityService().createUniqueProperty(
	        entityName    = arguments.mapping.entityName, 
	        propertyName  = arguments.propertyMetaData.propertyIdentifier,
	        propertyValue = arguments.data.brandName
	   );
	   
	}

	public any function generateProductProductType( 
	    required struct data, 
        required struct parentEntityMapping,
        required struct relationMetaData 
    ){
        var mapping = this.getMappingByMappingCode(arguments.relationMetaData.mappingCode );
	   	var productTypeImportRemoteID = this.createMappingImportRemoteID( mapping=mapping, data=arguments.data );
	    	    
	    var productTypeID = this.getHibachiService().getPrimaryIDValueByEntityNameAndUniqueKeyValue(
	        "entityName"  = 'ProductType',
	        "uniqueKey"   = 'importRemoteID',
	        "uniqueValue" = productTypeImportRemoteID
	    );

    	if( !isNull(productTypeID) && !this.hibachiIsEmpty(productTypeID) ){
    	    return { "productTypeID" : productTypeID }
    	} 
    	
    	// create new product-type
    	return this.transformMappingData( 
            mapping     = mapping, 
            data        = arguments.data,
            nested      = true
        );
	}
	
	public any function generateProductTypeParentProductType( struct data, struct mapping, struct propertyMetaData ){
	  return {
            'productTypeID' : '444df2f7ea9c87e60051f3cd87b435a1' // Merchandise is the default Parent-Product-type
        }
	}
	
	
	public any function generateProductTypeUrlTitle( required struct data, required struct mapping, required struct propertyMetaData){
	   return this.getHibachiUtilityService().createUniqueProperty(
	        entityName    = arguments.mapping.entityName, 
	        propertyName  = arguments.propertyMetaData.propertyIdentifier,
	        propertyValue = arguments.data.productTypeName
	   );
	}
	
	public string function createProductTypeImportRemoteID( required struct data, required struct mapping ){
	   
	   var formattedProductTypeName = reReplace(arguments.data['productTypeName'],"\s", "", "all");
	    
	   formattedProductTypeName = lcase( trim( formattedProductTypeName ) );
	    
	   // this lcase used to lcase hash
	   
	   return lcase( hash( formattedProductTypeName,  'MD5' ) );
	}
	
	
	/////////////////.                  SKU
	
	
	public any function generateSkuImageFile( struct data, struct mapping, struct propertyMetaData ){
		return arguments.data.skuCode & "-.jpeg";
	}
	
	
	public string function createSkuPriceImportRemoteID( required struct data, required struct mapping ){
	    var formattedData = {
	        'remoteSkuID'        : data['remoteSkuID'], 
	        'currencyCode'       : data['currencyCode']       ?: 'USD', 
	        'minQuantity'        : data['minQuantity']        ?: '', 
	        'maxQuantity'        : data['maxQuantity']        ?: '', 
	        'remotePriceGroupID' : data['remotePriceGroupID'] ?: ''
	    };
	    
	   return lcase( hash( trim( formattedData.remoteSkuID  ),  'MD5' ) ) & '_' &
	          lcase( hash( trim( formattedData.currencyCode ),  'MD5' ) )& '_' &
	          lcase( hash( trim( formattedData.minQuantity  ),  'MD5' ) )& '_' &
	          lcase( hash( trim( formattedData.maxQuantity  ),  'MD5' ) )& '_' &
	          lcase( hash( trim( formattedData.remotePriceGroupID ), 'MD5' ) );
	}
	
	public any function generateSkuPricePriceGroup( 
	    required struct data, 
        required struct parentEntityMapping,
        required struct relationMetaData 	
    ){
        
	    var mapping = this.getMappingByMappingCode(arguments.relationMetaData.mappingCode );
	   	var priceGroupImportRemoteID = this.createMappingImportRemoteID( mapping=mapping, data=arguments.data );
	    
	    var priceGroupID = this.getHibachiService().getPrimaryIDValueByEntityNameAndUniqueKeyValue(
	        "entityName"  = 'PriceGroup',
	        "uniqueKey"   = 'importRemoteID',
	        "uniqueValue" = priceGroupImportRemoteID
	    );
    	    
    	if( !isNull(priceGroupID) && !this.hibachiIsEmpty(priceGroupID) ){
    	    return { "priceGroupID" : priceGroupID }
    	}
    	
    	// create a new price-group
    	return this.transformMappingData( 
            mapping     = mapping, 
            data        = arguments.data,
            nested      = true
        );
	}
	
	//TODO: on hold, need to add volatile support for to-many relations
	public array function generateSkuOptionsAndCreateNewOnes( struct data, struct mapping, struct propertyMetaData ){
	    
	    var skuOptionGroups = this.getOptionDAO().getOptionGroupCodeIndex();
	    
	    var options = [];
	    
	    for(var optionGroupCode in skuOptionGroups ){
	    	if( structKeyExists(arguments.data, optionGroupCode) && !this.hibachiIsEmpty(arguments.data[optionGroupCode]) ){
	            
	            var optionID = this.getOptionDAO().getOptionIDByOptionGroupIDAndOptionName( 
	                skuOptionGroups[optionGroupCode], 
	                arguments.data[optionGroupCode] 
	            );
	            
	    	    if( !isNull(optionID) && !this.hibachiIsEmpty(optionID) ){
	    	        options.append({
    	    	        'optionID': optionID 
	    	        });
	    	    } else {
	    	        // create a new option inside the optionGroup
	    	        options.append({
	    	            'optionID' : '',
	    	            'optionName' : arguments.data[optionGroupCode],
	    	            "optionGroup" : {
	    	                'optionGroupID' : skuOptionGroups[optionGroupCode]
	    	            }
	    	        });
	    	    }
	    	}
	    }
	    
	    return options;
	}
	
	public any function generateSkuOptions( struct data, struct mapping, struct propertyMetaData ){
	    
        var optionsData = {};
        var skuOptionGroups = this.getOptionDAO().getOptionGroupCodeIndex();
        
        for(var optionGroupCode in skuOptionGroups ){
            if( structKeyExists(arguments.data, optionGroupCode) && !this.hibachiIsEmpty(arguments.data[optionGroupCode]) ){
                optionsData[ optionGroupCode ] = arguments.data[ optionGroupCode ];
            }
        }
        
        if(!structIsEmpty(optionsData)){
            return this.getOptionDAO().getOptionIDsByOptionGroupCodeAndOptionNames( optionsData );
        }
	}
	
	
	/////////////////.                  INVENTORY
	
	
	public any function generateInventoryStock( struct data, struct mapping, struct propertyMetaData ){
		
	    var skuID = this.getHibachiService().getPrimaryIDValueByEntityNameAndUniqueKeyValue(
            	        "entityName"  : 'Sku',
            	        "uniqueKey"   : 'remoteID',
            	        "uniqueValue" : arguments.data.remoteSkuID
            	    );
            	    
        var locationID = this.getHibachiService().getPrimaryIDValueByEntityNameAndUniqueKeyValue(
            	        "entityName"  : 'Location',
            	        "uniqueKey"   : 'remoteID',
            	        "uniqueValue" : arguments.data.remoteLocationID
            	    ); 
            	    
        if (!isNull(skuID) && !this.hibachiIsEmpty(skuID) ){
            
            if( isNull(locationID) || this.hibachiIsEmpty(locationID) ){
                // fallback to `Default Location` 
                locationID="88e6d435d3ac2e5947c81ab3da60eba2"; // default locationID
            }
            
    	    //Find if we have a stock for this sku and location.
		    var stock = this.getStockService().getStockBySkuIdAndLocationId(skuID,locationID);
		    
		    if( !isNull(stock) ){
		    	return { "stockID" : stock.getstockID() };
		    }
		    
		    //create new stock
		    return {
	            "stockID" : "",
	            "sku": {
	                    "skuID": skuID
	           },
	            "location" :{
	                "locationID" : locationID
	            }
	        };
        }
        
        //dont create stock if there is no locationID / skuID
	}
	
	
    /////////////////.                  ORDER-PAYMENT

    public array function generateOrderPaymentTransactions( struct data, struct mapping, struct propertyMetaData ){
    	if( structKeyExists(arguments.data, 'transactionID') || structKeyExists(arguments.data, 'authorizationCode') ){
            var transactionData = {
                'paymentTransactionID' : '',
                'amount' : arguments.data.amount
            };
            if(structKeyExists(arguments.data, 'transactionID')){
                transactionData['providerTransactionID'] = arguments.data.transactionID;
            }
            if(structKeyExists(arguments.data, 'authorizationCode')){
                transactionData['authorizationCode'] = arguments.data.authorizationCode;
            }

            return [ transactionData ];
        }

        return [];
    }
    
    /////////////////.                  ORDER

    public array function generateOrderOrderFulfillments( 
    	struct data, 
    	struct mapping, 
    	struct propertyMetaData
    ){
    	
		//create new fullfillment
	    return [{
	    	"orderFulfillmentID"	   : "",
            "remoteOrderFulfillmentID" : arguments.data.remoteOrderID,
            "currencyCode"			   : arguments.data.currency_code,
            //this defaultValue for FulfillmentMethod is `Shipping`
            "fulfillmentMethod"        : {
            	"fulfillmentMethodID"  :"444df2fb93d5fa960ba2966ba2017953"
            },
            "shippingAddress"		   : {
            		  "name"		   : this.getAddressService().getAddressName(arguments.data.Address),
	                  "streetAddress"  : arguments.data.ShippingAddress_streetAddress,
	                  "street2Address" : arguments.data.ShippingAddress_street2Address,
	                  "city"           : arguments.data.ShippingAddress_city,
	                  "countryCode"	   : arguments.data.ShippingAddress_countryCode,
	                  "stateCode"	   : arguments.data.ShippingAddress_stateCode,
	                  "postalCode"	   : arguments.data.ShippingAddress_postalCode,
	           },
        }];
    }
	/*****************         END : GENERATOR-FUNCTIONS                 ******************/
}
