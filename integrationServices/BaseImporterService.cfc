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

	property name = "cachedEntityMappings" type="struct";
	

	public any function init() {
	    super.init(argumentCollection = arguments);
	    this.setCachedEntityMappings( {} );
	}
	
    public any function getIntegration(){
        throw("override this function in your integrtion service to return the associated instance of integration-entity");
    }

	public struct function getEntityMapping( required string entityName ){
	    
	    var entityMappings = this.getCachedEntityMappings();
	    
	    if( !structKeyExists( entityMappings, arguments.entityName) ){
	        
	        //Can be overriden to Read from Files/DB/Function whatever 
	        var mapingJson = FileRead( this.getApplicationValue('applicationRootMappingPath') & '/config/importer/mappings/#arguments.entityName#.json');
	        
	        entityMappings[ arguments.entityName ] = DeserializeJSON(mapingJson);
	    }
	    
        return entityMappings[ arguments.entityName ];
	}


	public any function pushRecordsIntoImportQueue( required string entityName, required struct queryOrArrayOfStruct ){
	    
	    //Create a new Batch
	    var newBatch = this.getHibachiEntityQueueService().newBatch();
	    //populate other details
	    this.getHibachiEntityQueueService().saveBatch(newBatch);
	    
	    this.getHibachiScope().flushORMSession();
	    
	    for( var record in queryOrArrayOfStruct ){
	        this.pushRecordIntoImportQueue( arguments.entityName, record, newBatch.getBatchID() );
	    }
	    
	    //TODO: update initial batch-items values
	}
	
	public struct function pushRecordIntoImportQueue( required string entityName, required struct data, required string batchID, numeric tryCount = 1 ){
	    
	    var validation = this.validateEntityData( entityName = arguments.entityName, data = arguments.data, collectErrors=true);
	    
	    if( !validation.isValid ){
	        
	        var entityQueueData = {
	            'data':  arguments.data,
	            'batchID': arguments.batchID,
	            'tryCount': arguments.tryCount,
	            'entityName': arguments.entityName
	        }
	        
	        // if we're collecting errors we can directly send the item to failures (EntityQueue hisory)
	        this.getEntityQueueDAO().insertEntityQueueFailure(
        	    baseID = '', //not needed
        	    baseObject = arguments.entityName, 
        	    processMethod = 'reQueueImportFailure',
        	    entityQueueData = entityQueueData, 
        	    integrationID = this.getIntegration().getIntegrationID(), 
        	    batchID = arguments.batchID,
        	    mostRecentError = serializeJson( validation.errors ),
        	    tryCount = arguments.tryCount 
        	);
        	
	    } else {
	    
    	    var transformedData = this.transformEntityData( entityName = arguments.entityName, data = arguments.data);
    	    var primaryIDPropertyName = this.getHibachiService().getPrimaryIDPropertyNameByEntityName( arguments.mapping.entityName );
    
    	    this.getEntityQueueDAO().insertEntityQueue(
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
            batch      = arguments.entityQueueData.batchID, 
            tryCount   = arguments.entityQueueData.tryCount + 1,
            entityName = arguments.entityQueueData.entityName 
        );
        
        if(!validation.isValid){
            arguments.entity.setErrors( validation.errors );
        }
	    
	    return arguments.entity;
	}
	
	public any function processEntityImport( any entity, struct entityQueueData ){
	   
	    var entityName = arguments.entity.getClassName();
	    
	    if( structKeyExists(this, 'process#entityName#_import') ){
	        return this.invokeMethod( 'process#entityName#_import', arguments );
	    }
	    
	    var entityService = this.getHibachiService().getServiceByEntityName( entityName=entityName );
	    arguments.entity.populate( arguments.entityQueueData );
	    arguments.entity = entityService.invokeMethod( "save#entityName#", arguments.entity );
	    
	    return arguments.entity;
	}
	
	
    public struct function validateEntityData(required string entityName, required struct data, struct mapping, boolean collectErrors = false ){
        
        if( !structKeyExists(arguments, 'mapping') ){
            arguments.mapping = this.getEntityMapping( arguments.entityName );
        }
        
        var validatorFunctionName = 'validate#arguments.entityName#Data';
        
        if( structKeyExists( this, validatorFunctionName) ){
            
            return this.invokeMethod( validatorFunctionName, arguments );
        } else {
            
    	    return this.validateData( argumentCollection = arguments);
        }
    }

	public struct function validateData( required struct data, required struct mapping, boolean collectErrors = false ){
	    
	    var validationService = this.getHibachiValidationService();
	    var utilityService = this.getHibachiUtilityService();
	   
	    var entityName = arguments.mapping.entityName;
	    var isValid = true;
	    var errors = {};
	    
	    // validate entity properties
	    for( var propertyName in arguments.mapping.properties ){
	        
	        var propertyMeta = arguments.mapping.properties[propertyName];
	        
	        if( structKeyExists(propertyMeta, 'validations') ){
	            
	            for( var constraintType in propertyMeta.validations ){
	                
	                //only a subset of validations is available for direct validation(non-object);
	                var validationFunctionName = 'validate_#constraintType#_real';
	                if( !structKeyExists(validationService, validationFunctionName) ){
	                    throw("invalid validation constraint type : #constraintType#");
	                }
	                
	                var constraintValue = propertyMeta.validations[constraintType];
	                
                    isValid = validationService.invokeMethod( validationFunctionName, { 
                       propertyValue    :  data[propertyName] ?: javaCast('null', 0),
                       constraintValue  :  constraintValue
                    });
	               
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
	                errors = mergeErrors( errors, validation.errors );
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
	
	//utility
	private struct function mergeErrors(required struct errors1, required struct errors2){
	    
	    for(var propertyName in arguments.errors2 ){
	        if( !structKeyExists(arguments.errors1, propertyName) ){
	            arguments.errors1[propertyName] = arguments.errors2[propertyName];
	        } else {
	            arguments.errors1[propertyName] = arguments.errors1[propertyName].merge( arguments.errors2[propertyName] );
	        }
	    }
	    
	    return arguments.errors1;
	}
	
	
    public struct function transformEntityData(required string entityName, required struct data, struct mapping ){
        
        if( !structKeyExists(arguments, 'mapping') ){
            arguments.mapping = this.getEntityMapping( arguments.entityName );
        }

        if( structKeyExists( this, 'transform#arguments.entityName#Data') ){
            return this.invokeMethod( 'transform#arguments.entityName#Data', arguments );
        } 
        else {
    	    return this.transformData( argumentCollection = arguments);
        }
    }
    
	public struct function transformData( required struct data, required struct mapping ){
	    var transformedData = {};
	    
	    for( var sourcePropertyName in arguments.mapping.properties ){
	        var propertyidentifier = arguments.mapping.properties[ sourcePropertyName ].propertyIdentifier;
	        
	        if(structKeyExists(data, sourcePropertyName) ){
	            transformedData[ arguments.mapping.properties[ sourcePropertyName ].propertyIdentifier ] = data[ sourcePropertyName ];
	        }
	    }
	    
	    arguments.data['importRmoteID'] = this.createEntityImportRemoteID( arguments.mapping.entityName, arguments.data );
	  
	    var primaryIDPropertyName = this.getHibachiService().getPrimaryIDPropertyNameByEntityName( arguments.mapping.entityName );
	    if( !structKeyExists( arguments.data, primaryIDPropertyName) ){
	        
    	    var args = {
    	        "entityName"  : arguments.mapping.entityName,
    	        "uniqueKey"   : 'importRmoteID',
    	        "uniqueValue" : arguments.data['importRmoteID']
    	    };
    	    
	        arguments.data[ primaryIDPropertyName ] = this.getHibachiService().getPrimaryIDValueByEntityNameAndUniqueKeyValue( argumentCollection = args ) ?: '';
	    }
	    
	    transformedData['importRmoteID'] = arguments.data['importRmoteID'];
	    transformedData[ primaryIDPropertyName ] = arguments.data[ primaryIDPropertyName ];

	   // transformedData['importRmoteID'] = arguments.data['importRmoteID'];
	   // transformedData[ primaryIDPropertyName ] = '';
	    
	    if( structKeyExists(arguments.mapping, 'relations' ) ){
	        for(var related in arguments.mapping.relations ){
	            transformedData[ related.propertyIdentifier ] = this.transformEntityData( related.entityName, arguments.data );
	        }
	    }
	    
	    return transformedData;
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
	
	// utility
	public string function createImportRemoteIDFromDataAndMapping( required struct data, required struct mapping ){
	    
	    var compositeValue =  arguments.mapping.importIdentifier.keys.reduce( function(result, key){ 
                            	        // it is expected that each key will exist in the data
                            	        return ListAppend( result , hash( data[ key ], 'MD5' ), '_'); 
                        	    }, '');
        return compositeValue;
	}
	
}
