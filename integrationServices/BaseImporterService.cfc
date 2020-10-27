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
	
	property name = "hibachiService";
	property name = "hibachiUtilityService";
	property name = "hibachiValidationService";
	property name = "hibachiEntityQueueService";
	property name = "hibachiEntityQueueDAO";

	property name = "cachedEntityMappings" type="struct";
	
	
	public any function init() {
	    super.init(argumentCollection = arguments);
	    this.setCachedEntityMappings( {} );
	}
	
	
	
	/*****************                      Meta-Data                 ******************/
	
    public any function getIntegration(){
        throw("override this function in your integrtion service to return the associated instance of integration-entity");
    }

	public struct function getEntityMapping( required string entityName ){
	    
	    var extentionFunctionName = 'get#arguments.entityName#Mapping';
	    if( structKeyExists(this, extentionFunctionName) ){
	        return this.invokeMethod( extentionFunctionName, arguments );
	    }
	    
	    
	    var cachedMappings = this.getCachedEntityMappings();
	    
	    if( !structKeyExists( cachedMappings, arguments.entityName) ){
	        
	        //Can be overriden to Read from Files/DB/Function whatever 
	        var mappingJson = FileRead( this.getApplicationValue('applicationRootMappingPath') & '/config/importer/mappings/#arguments.entityName#.json');
	        
	        if( isJson(mappingJson) ){
	            cachedMappings[ arguments.entityName ] = DeserializeJSON(mappingJson);
	        } else {
	            throw( "Mapping for #arguments.entityName#.json is not valid : \n" &mappingJson );
	        }
	    }
	    
        return cachedMappings[ arguments.entityName ];
	}

  	public struct function createEntityCSVHeaderMetaDataRecursively( required string entityName ){
        var headers = {};
        var mapping = this.getEntityMapping( arguments.entityName );
    
        if(structKeyExists(mapping, 'properties') ){
      	    mapping.properties.each( function(key, propertyMeta ){
      	        headers[ ucFirst(key, true) ] = "VarChar"; // we can add a way to either define or infer this
      	    });
        }
  	    
  	    if( structKeyExists(mapping, 'relations') ){
  	        
  	        // ( if required) we can add relationship-type-check to check if the property can be availabe in a csv ( only *-to-one relations )
  	        for(var related in mapping.relations ){
  	            headers.append( this.createEntityCSVHeaderMetaDataRecursively(related.entityName) );
	        }
  	    }
  	    
  	    return headers;
    }

	public struct function getEntityCSVHeaderMetaData( required string entityName ){
	    
	    var cacheKey = "getEntityCSVHeaderMetaData_" &arguments.entityName;
	    
	    if( !structKeyExists(variables, cacheKey) ){
	        
      	    var columnNamesAndTypes = this.createEntityCSVHeaderMetaDataRecursively( arguments.entityName );
      	    
      	    var columns = columnNamesAndTypes.keyArray().sort('textNoCase');
      	    var columnTypes = columns.map( function( column ){ 
      	        return columnNamesAndTypes[ column ]; 
      	    });
      	    
      	    variables[ cacheKey ] = { "columns": columns.toList(), "columnTypes": columnTypes.toList() };
	    }
	    
  	    return variables[ cacheKey ];
  	}
  	
  	
  	
  	/*****************              Process - Queue - Process                 ******************/

	public any function pushRecordsIntoImportQueue( required string entityName, required any queryOrArrayOfStruct ){
	    
	    //Create a new Batch
	    var newBatch = this.getHibachiEntityQueueService().newBatch();
	    
	    newBatch.setBaseObject( arguments.entityName );
	    newBatch.setBatchDescription("#arguments.entityName# Import Batch created on " & dateFormat(now(), "long") );
	    
	    if( isArray(arguments.queryOrArrayOfStruct) ){
	        newBatch.setInitialEntityQueueItemsCount( arguments.queryOrArrayOfStruct.len() );
	    } else {
	        newBatch.setInitialEntityQueueItemsCount( arguments.queryOrArrayOfStruct.recordCount );
	    }

	    this.getHibachiEntityQueueService().saveBatch(newBatch);
	    this.getHibachiScope().flushORMSession();
	    
	    for( var record in queryOrArrayOfStruct ){
	        this.pushRecordIntoImportQueue( arguments.entityName, record, newBatch.getBatchID() );
	    }
	    
	    return newBatch;
	}
	
	public struct function pushRecordIntoImportQueue( required string entityName, required struct data, required string batchID ){
	    
	    var validation = this.validateEntityData( entityName = arguments.entityName, data = arguments.data, collectErrors=true);
	    
	    if( !validation.isValid ){
	        
	        var entityQueueData = {
	            'data':  arguments.data,
	            'batchID': arguments.batchID,
	            'entityName': arguments.entityName
	        }
	        
	        // if we're collecting errors we can directly send the item to failures (EntityQueue hisory)
	        this.getHibachiEntityQueueDAO().insertEntityQueueFailure(
        	    baseID = '', //not needed
        	    baseObject = arguments.entityName, 
        	    processMethod = 'reQueueImportFailure',
        	    entityQueueData = entityQueueData, 
        	    integrationID = this.getIntegration().getIntegrationID(), 
        	    batchID = arguments.batchID,
        	    mostRecentError = serializeJson( validation.errors )
        	);
        	
	    } else {
	    
    	    var transformedData = this.transformEntityData( entityName = arguments.entityName, data = arguments.data);
    	    var primaryIDPropertyName = this.getHibachiService().getPrimaryIDPropertyNameByEntityName( arguments.entityName );
    
    	    this.getHibachiEntityQueueDAO().insertEntityQueue(
        	    baseID = transformedData[ primaryIDPropertyName ], 
        	    baseObject = arguments.entityName, 
        	    processMethod ='processEntityImport',
        	    entityQueueData = transformedData, 
        	    integrationID = this.getIntegration().getIntegrationID(), 
            	batchID = arguments.batchID
        	);
	        
	    }
	    
    	return validation;
	}
	
	public any function reQueueImportFailure( any entity, struct entityQueueData ){

        var validation = this.pushRecordIntoImportQueue(
            data       = arguments.entityQueueData.data, 
            batchID    = arguments.entityQueueData.batchID, 
            entityName = arguments.entityQueueData.entityName 
        );
        
        if(!validation.isValid){
            arguments.entity.setErrors( validation.errors );
        }
	    
	    return arguments.entity;
	}
	
	
	public void function resolveEntityDependencies(required any entity, required struct entityQueueData, struct mapping ){
	    
	    var extentionFunctionName = "resolve#arguments.entity.getClassName()#Dependencies"
	    if( structKeyExists(this, extentionFunctionName) ){
	        return this.invokeMethod( extentionFunctionName, arguments );
	    }
	      
	      
        for( var dependency in arguments.entityQueueData.__dependancies ){
             
            var primaryIDValue = this.getHibachiService().getPrimaryIDValueByEntityNameAndUniqueKeyValue(
                                        "entityName"  : dependency.entityName,
                            	        "uniqueKey"   : dependency.lookupKey,
                            	        "uniqueValue" : dependency.lookupValue
                                    );
                
                                    
            if( this.hibachiIsEmpty(primaryIDValue) ){
                
                arguments.entity.addError( 
                    dependency.propertyIdentifier, 
                    "Depandancy for propertyIdentifier [#dependency.propertyIdentifier#] on Entity [#dependency.entityName#] could not be resolved yet"    
                );
                
                break;
            }
                         
            var primaryIDProperty = this.getHibachiService().getPrimaryIDPropertyNameByEntityName( dependency.entityName );
            
            arguments.entityQueueData[ dependency.propertyIdentifier ] = { "#primaryIDProperty#" : primaryIDValue }
        }
	}


	public void function resolveEntityVolatileRelations(required string entityName, required struct entityData ){
	    
	    var extentionFunctionName = "resolve#arguments.entityName#VolatileRelations"
	    if( structKeyExists(this, extentionFunctionName) ){
	        return this.invokeMethod( extentionFunctionName, arguments );
	    }
	      
        for( var relation in arguments.entityData.__volatiles ){
             
            var relationData = arguments.entityData[ relation.propertyIdentifier ];
            if( relation.isVolatile ){
                
                var relationPrimaryIDValue = this.getHibachiService()
                    .getPrimaryIDValueByEntityNameAndUniqueKeyValue(
                        "entityName"  : relation.entityName,
            	        "uniqueKey"   : 'importRemoteID',
            	        "uniqueValue" : relationData.importRemoteID
                    );
                
                if( !this.hibachiIsEmpty(relationPrimaryIDValue) ){
                    
                    var relationPrimaryIDProperty = this.getHibachiService()
                        .getPrimaryIDPropertyNameByEntityName( relation.entityName );
                        
                    // mutates the nested struct in arguments.entityData
                    relationData = { "#relationPrimaryIDProperty#" : relationPrimaryIDValue }; 
                }
                
            } else if(relation.hasVolatiles) {
                this.resolveEntityVolatileRelations( relation.entityName, relationData );
            }
        }
	}


	public any function processEntityImport( required any entity, required struct entityQueueData, struct mapping ){
	    
	    this.getHibachiScope().setObjectPopulateMode( 'private' );

	    var entityName = arguments.entity.getClassName();
	    
	    if( structKeyExists(this, 'process#entityName#_import') ){
	        return this.invokeMethod( 'process#entityName#_import', arguments );
	    }
	    
	    
	    if( !structKeyExists(arguments, 'mapping') ){
            arguments.mapping = this.getEntityMapping( entityName );
        }
	    
	    if( structKeyExists(arguments.entityQueueData, '__dependancies') ){
            this.resolveEntityDependencies(argumentCollection = arguments);
    	    if(arguments.entity.hasErrors()){
    	        return arguments.entity;
    	    }
	    }
	    
	    if( structKeyExists(arguments.entityQueueData, '__volatiles') ){
            this.resolveEntityVolatileRelations(entityName, arguments.entityQueueData);
	    }
	    
	    
	    arguments.entity.populate( data=arguments.entityQueueData, objectPopulateMode='private' );

	    // Functions to be called after populating the entity, like `updateCalculatedProperties`
	    if( structKeyExists(arguments.mapping, 'postPopulateMethods') && isArray(arguments.mapping.postPopulateMethods) ){
	        for( var methodName in arguments.mapping.postPopulateMethods ){
	            arguments.entity.invokeMethod( methodName );
	        }
	    }
	    
	    var entityService = this.getHibachiService().getServiceByEntityName( entityName=entityName );

	    if( !structKeyExists(arguments.mapping, 'validationContext') ){
	        arguments.mapping['validationContext'] = 'save';
	    }

	    arguments.entity = entityService.invokeMethod( "save"&entityName,  { 
	        "#entityName#"  : arguments.entity, // "#entityName#" needs to be unwrapped, as variables are not allowed as keys in stucts
	        "context"       : arguments.mapping.validationContext
	    });
	    
	    return arguments.entity;
	}
	
	
	
	/*****************                      VALIDATE                 ******************/

    public struct function validateEntityData(required string entityName, required struct data, struct mapping, boolean collectErrors = false ){
        
        if( !structKeyExists(arguments, 'mapping') ){
            arguments.mapping = this.getEntityMapping( arguments.entityName );
        }
        
        var validatorFunctionName = 'validate#arguments.entityName#Data';
        
        if( structKeyExists( this, validatorFunctionName) ){
            
            return this.invokeMethod( validatorFunctionName, arguments );
        } else {
            
    	    return this.genericValidateEntityData( argumentCollection = arguments);
        }
    }

	public struct function genericValidateEntityData( required struct data, required struct mapping, boolean collectErrors = false ){
	    
	    var validationService = this.getHibachiValidationService();
	    var utilityService = this.getHibachiUtilityService();
	   
	    var entityName = arguments.mapping.entityName;
	    var isValid = true;
	    var errors = {};
	    
	    // validate entity properties
	    if( structKeyExists(arguments.mapping, 'properties') ){
	        
    	    for( var propertyName in arguments.mapping.properties ){
    	        
    	        var propertyMeta = arguments.mapping.properties[propertyName];
    	        
    	        if( structKeyExists(propertyMeta, 'validations') ){
    	            
    	            for( var constraintType in propertyMeta.validations ){
    	                var constraintValue = propertyMeta.validations[constraintType];
    	                var validationFunctionName = 'validate_#constraintType#_value';
    	                
    	                if( structKeyExists(this, validationFunctionName) ){
    	                    
                            isValid = this.invokeMethod( validationFunctionName, { 
                               propertyValue    :  data[propertyName] ?: javaCast('null', 0),
                               constraintValue  :  constraintValue
                            });
                            
    	                } else if( structKeyExists(validationService, validationFunctionName) ){
    	                    
                                isValid = validationService.invokeMethod( validationFunctionName, { 
                                   propertyValue    :  data[propertyName] ?: javaCast('null', 0),
                                   constraintValue  :  constraintValue
                                });
            	                    
    	                } else {
    	                    throw("invalid validation constraint type : #constraintType#, function #validationFunctionName# does not exist");
    	                }
    	               
                        if( !isValid ){
                           
                            // if we're instructed to collecth the errors.
                            if( arguments.collectErrors ){
                                
                                if( constraintType eq "dataType" ){
                        	        var errorMessage = getHibachiScope().rbKey('validate.import.#entityName#.#propertyName#.#constraintType#.#constraintValue#');
                        		} 
                        		else {
                        			var errorMessage = getHibachiScope().rbKey('validate.import.#entityName#.#propertyName#.#constraintType#');
                        		}
                        		
                        		errorMessage = utilityService.replaceStringTemplate( errorMessage, {
                        		    "className":        entityName,
                        		    "propertyName":     propertyName,
                        		    "constraintValue":  constraintValue 
                        		});
                        		
                        		// collecting the error
                        		if( !structKeyExists(errors, propertyName) ){
                        		    errors[propertyName] = [];
                        		}
                        		
                                ArrayAppend( errors[propertyName] ,  errorMessage );  
                        		
                        		//resetting the flag to continue validating;
                                isValid = true;
                            } 
                            else { 
                                break;
                            }
                        }
    
    	            }
    	        }
    	        
    	        if( !isValid && !arguments.collectErrors){
    	            break;
    	        }
    	    }
	    }
	    
	    // validate related sub-entities as well
	    if(  (isValid || arguments.collectErrors) && structKeyExists(arguments.mapping, 'relations' ) ){
	        
	        for(var related in arguments.mapping.relations ){
	         
                var validation = this.validateEntityData(
                    data =  arguments.data,  
                    entityName = related.entityName, 
                    collectErrors = arguments.collectErrors 
                );
                
                isValid = validation.isValid;
                
                if(arguments.collectErrors){
                    errors = this.mergeErrors( errors, validation.errors );
                }
                
                if( !isValid && !arguments.collectErrors){
                    break;
                } 
	        }
	    }
	    
	    
	    // validate that importIdentifier exists
	    return { 
	        isValid: arguments.collectErrors ?  StructIsEmpty( errors ) : isValid, 
	        errors: errors 
	    };
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

    public struct function transformEntityData(required string entityName, required struct data, struct mapping, boolean nested=false ){
        
        if( !structKeyExists(arguments, 'mapping') ){
            arguments.mapping = this.getEntityMapping( arguments.entityName );
        }

        if( structKeyExists( this, 'transform#arguments.entityName#Data') ){
            return this.invokeMethod( 'transform#arguments.entityName#Data', arguments );
        } 
        else {
    	    return this.genericTransformEntityData( argumentCollection = arguments);
        }
    }
    
	public struct function genericTransformEntityData( required struct data, required struct mapping, boolean nested=false){
	    var entityName = arguments.mapping.entityName;
	    var transformedData = {};
	    
	    // Inferd properties, importRemoteID and `primaryIDProperty`
	    var importRemoteIDValue = this.createEntityImportRemoteID( entityName, arguments.data );
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
    	     * This will execute a query to the DB like:
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
    	        "entityName"  : entityName,
    	        "uniqueKey"   : 'importRemoteID',
    	        "uniqueValue" : importRemoteIDValue
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
    	            if( this.hibachiIsEmpty( transformedData[ primaryIDPropertyName ] ) ){
    	                continue;
    	            }
    	        }
    	        
    	        var propertyValue = this.getOrGeneratePropertyValue(
    	            data               : arguments.data, 
        	        mapping            : arguments.mapping,
        	        propertyMetaData   : propertyMetaData,
        	        sourcePropertyName : sourcePropertyName
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
    	            if( this.hibachiIsEmpty( transformedData[ primaryIDPropertyName ] ) ){
    	                continue;
    	            }
    	        }
	            
    	        var propertyValue = this.getOrGeneratePropertyValue(
    	            data               : arguments.data, 
        	        mapping            : arguments.mapping,
        	        propertyMetaData   : propertyMetaData
        	    );
        	   
    	        if( !isNull(propertyValue) ){
            	    transformedData[ propertyMetaData.propertyIdentifier ] = propertyValue;
    	        }
	        }
	    }
	    
	    
	    // relational dependancies[ entities which should be present bofore this record can be processed],
	    // like `Product` should be present before SKU can be imported 
	    if( !arguments.nested && structKeyExists(arguments.mapping, 'dependencies') ){
	        
	        transformedData['__dependancies'] = [];
	        for( var dependency in arguments.mapping.dependencies ){
	            dependency['lookupValue'] = arguments.data[ dependency.key ];
	            transformedData['__dependancies'].append( dependency );
	        }
	    }
	    
	    // relations, properties which belong to some slatwall entity, like `email` is stored in AccountEmailAddress
	    if( structKeyExists(arguments.mapping, 'relations' ) ){
	        
	        for(var relation in arguments.mapping.relations ){
	            
	            // SKIP if it's a create-only relation, and we're upserting
    	        if( structKeyExists(relation, 'allowUpdate') && !relation.allowUpdate ){
    	            if( this.hibachiIsEmpty( transformedData[ primaryIDPropertyName ] ) ){
    	                continue;
    	            }
    	        }
	            
                var transformedRelationData = this.getOrGenerateRelationData(
                    data                = arguments.data,
                    parentEntityMapping = arguments.mapping,
                    relationMetaData    = relation
                );
	                
                if( !isNull(transformedRelationData) ){
                    
                    transformedData[ relation.propertyIdentifier ] = transformedRelationData;
                    
                    if( !isStruct(transformedRelationData) ){
                        continue;
                        // we're only supporting struct as volatiles, [ many-to-one & one-to-one ] relations
                    }
                    
                    /**********************************************************************************************
                     * A volatile relation is any relation which can be generated by multiple recoards in the queue,
                     * 
                     * for example we'll import Product and ProductType and Brand all together, and when there is not a brand for a given name, 
                     * a new Brand will get created automatically. But there can be a scenario 
                     * when there are multiple products in the queue that belongs to the same brnad and the brand does not exist in Slatwall,
                     * in that case we'd want to create the brand when the first product get's created 
                     * and for the rest of them we'd want to re-use that same recoard.
                     * 
                     * 
                     * if this relation is-volatile or if it has-volatiles we'll carrying it forward to the `processEntityImport` function
                     * so before creating actual entity-record we can query the DB and replace volatiles with already created entities
                     * 
                     ***********************************************************************************************/
                    
                    // if relation has one or ore sub-entities which are volatile
                    relation['hasVolatiles'] = structKeyExists(transformedRelationData, '__volatiles');
                    
                    if( !structKeyExists(relation, 'isVolatile') ){
                        relation['isVolatile'] = false;
                    }
                    
                    // when the relation was volatile, but we're not creating a new recoard for this  
                    // as we have the primaaryID for the related entity
                    var relationPrimaryIdPropertyName = this.getHibachiService().getPrimaryIDPropertyNameByEntityName( relation.entityName );
                    var relationPrimaryIdValue = transformedRelationData[ relationPrimaryIdPropertyName ];
                    if( relation.isVolatile && !this.hibachiIsEmpty( relationPrimaryIdValue )  ){
                        relation['isVolatile'] = false;
                    }
                    
                    
                    if( relation.isVolatile || relation.hasVolatiles ){
                        
                        if( !structKeyExists(transformedData, '__volatiles') ){
                            transformedData['__volatiles'] = [];
                        }
                        
                        transformedData.__volatiles.append(relation);
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
        string sourcePropertyName
    ){
        
        /**
         * Fallback order 
         * 1. generator-function provided in the propertyMetadata
         * 
         * 2. conventional generator-functions `generate[entityName][PropertyName]` in the service, 
         *    where ProertyName ==> propertyMetaData.propertyIdentifier
         *    
         *    Ex. generateAccountActiveFlag(){......}
         * 
         * 3. value in the incoming data
         * 
         * 4. default value from the propertyMetadata
        */

        var entityName = arguments.mapping.entityName;
        
        if( !structKeyExists(arguments, 'mapping')){
            arguments[ 'mapping' ] = this.getEntityMapping( entityName );
        }
        
        if( structKeyExists(arguments.propertyMetaData, 'generatorFunction') ){
            return this.invokeMethod( arguments.propertyMetaData.generatorFunction, arguments );
        }  
        
        var conventionalGeneratorFunctionName = 'generate'&entityName&arguments.propertyMetaData.propertyIdentifier;
        if( structKeyExists(this, conventionalGeneratorFunctionName) ){
            return this.invokeMethod( conventionalGeneratorFunctionName, arguments );
        }  
        
        if( structKeyExists(arguments, 'sourcePropertyName') && structKeyExists(arguments.data, arguments.sourcePropertyName) ){
            return arguments.data[ arguments.sourcePropertyName ];
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
        
        /**
         * Fallback order 
         * 1. generator-function provided in the relationMetaData
         * 
         * 2. conventional generator-functions `generate[entityName][relatedProertyName]` in the service, 
         *    where ProertyName ==> relationMetaData.propertyIdentifier
         *    
         *    Ex. generateAccountPrimaryEmailAddress(){......}
         * 
         * 3. transform it using regular `transformEntityData` flow
         * 
        */
        
        if( structKeyExists(arguments.relationMetaData, 'generatorFunction') ){
            return this.invokeMethod( arguments.relationMetaData.generatorFunction, arguments );
        }
        
        var conventionalGeneratorFunctionName = 'generate'&arguments.parentEntityMapping.entityName&arguments.relationMetaData.propertyIdentifier;
        if( structKeyExists(this, conventionalGeneratorFunctionName) ){
            return this.invokeMethod( conventionalGeneratorFunctionName, arguments );
        }
        
        
        //TODO: ( if-needed ) properly handle scenarios for -to-Many relations
        // if source-property for the relation already exist in the incoming-data, than it should be an array
        // otherwise if the incoming-data is a flat struct, then there will be only one new record in the generated-array
        
        var transformedRelationData = this.transformEntityData( 
            entityName  = arguments.relationMetaData.entityName, 
            data        = arguments.data,
            nested      = true
        );
        
        if( listFindNoCase('oneToOne,manyToOne', arguments.relationMetaData.type) ){
            return transformedRelationData;
        }  
        
        if(  arguments.relationMetaData.type == 'oneToMany' ){
            // currently this expect only one item for [ -to-many ] array
            return [ transformedRelationData ];
        }
    }
    
	public string function createEntityImportRemoteID( required string entityName, required struct data, struct mapping){
	    
	    if( !structKeyExists(arguments, 'mapping') ){
            arguments.mapping = this.getEntityMapping( arguments.entityName );
        }
        
        var importRemoteIDGeneratorFunctionName = 'create#arguments.entityName#ImportRemoteID';
        
        if( structKeyExists(this, importRemoteIDGeneratorFunctionName) ){
            return this.invokeMethod( importRemoteIDGeneratorFunctionName, arguments );
        } else {
    	    return this.createImportRemoteIDFromDataAndMapping( argumentCollection = arguments);
        }
	}
	
	// utility function to create a `importRemoteID` from mapping and input-data
	public string function createImportRemoteIDFromDataAndMapping( required struct data, required struct mapping ){
	    
	    var compositeValue =  arguments.mapping.importIdentifier.keys.reduce( function(result, key){ 
                            	        // it is expected that each key will exist in the data
                            	        return ListAppend( result , hash( trim( data[ key ] ), 'MD5' ), '_'); 
                        	    }, '');
        return compositeValue;
	}
	
	
	/*****************         GENERATOR-FUNCTIONS                 ******************/
	/**
	    Conventional generator-functions `generate[entityName][examplePropertyIdentifier]` in the service, 
        where ProertyName ==> propertyMetaData.propertyIdentifier
        
        Ex. generateAccountActiveFlag(){......}
	*/
	
	/**
	 * Example function, is getting used to generate passwords for imported accounts 
	*/
	public any function generateAccountAuthenticationPassword( struct data, struct mapping, struct propertyMetaData ){
	    return this.getHibachiUtilityService().generateRandomPassword(10);
	}
	
	public boolean function generateAccountActiveFlag( struct data, struct mapping, struct propertyMetaData ){
	    return true;
	}
	
	
	/*****************         END : GENERATOR-FUNCTIONS                 ******************/

}
