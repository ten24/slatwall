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
	
	property name = "hibachiUtilityService";
	property name = "hibachiValidationService";
	property name = "hibachiEntityQueueService";
	
	

    public any function getIntegration(){
        throw("override this function in your integrtion service to return the ")
    }



	//////////////////////////////////////////  Importer functions for [ Account ]  ////////////////////////////////////////////

	public struct function getAccountMapping(){
	    
	    if( !structKeyExists(variables, 'accountMappingStruct') ){

	        //Read from file/DB whatever 
	        var mapingJson = FileRead( ExpandPath('/Slatwall') & '/config/importer/mappings/Account.json');
	        
	        variables.accountMappingStruct = deSerializeJson(mapingJson);
	    }
	    
        return variables.accountMappingStruct;
	}
	
	public any function importAccounts( required struct queryOrArrayOfStruct ){
	    
	    //Create a new Batch
	    var newBatch = this.getHibachiEntityQueueService().newBatch();
	    //populate other details
	    this.getHibachiEntityQueueService().saveBatch(newBatch);
	    
	    for( var accountData in queryOrArrayOfStruct ){
	        this.importAccount(accountData, newBatch);
	    }
	}
	
	public any function importAccount( required struct data, required any batch ){
	    
	    var validation = this.validateAccountData( data = arguments.data, collectErrors=true );
	    
	    if( !validation.isValid ){
	        // if we're collecting errors we can directly send the item to failures (EntityQueue hisory)
	        this.getEntityQueueDAO().insertEntityQueueFailure(
        	    baseID = '', 
        	    baseObject = "Account", 
        	    processMethod = 'importAccount',
        	    entityQueueData = arguments.data, 
        	    entityQueueType = '' // Question ???
        	    integrationID = this.getIntegration().getIntegrationID(), 
        	    batchID = arguments.batch.getBatchID(),
        	   mostRecentErro r= Serializejson( validation.errors ),
        	   tryCount = 1 
        	);
	    }
	    
	    var transformedData = this.transformAccountData(arguments.data);
	    
	    this.getEntityQueueDAO().insertEntityQueue(
    	    baseID = '', 
    	    baseObject = 'Account', 
    	    processMethod ='processAccount_import || processAccount_create', // Question: which process method?? 
    	    entityQueueData = transformedData, 
    	    integrationID = this.getIntegration().getIntegrationID(), // Q ^^^ 
        	batchID = arguments.batch.getBatchID()
    	);
    	
	}
	
	public struct function validateAccountData( required struct data, struct mapping = this.getAccountMapping(), boolean collectErrors = false ){
	    return this.validateData( argumentCollection = arguments);
	}
	
	public struct function transformAccountData( required struct data, struct mapping = this.getAccountMapping() ){
	    return this.transformData( argumentCollection = arguments);
	}
	
	
	
	////////////////////////////////////////// TODO Importer functions for other Entities  ////////////////////////////////////////////
	////////////////////////////////////////// TODO Importer functions for other Entities  ////////////////////////////////////////////
	////////////////////////////////////////// TODO Importer functions for other Entities  ////////////////////////////////////////////
	////////////////////////////////////////// TODO Importer functions for other Entities  ////////////////////////////////////////////
	////////////////////////////////////////// TODO Importer functions for other Entities  ////////////////////////////////////////////

	
	//////////////////////////////////////// Utility functions//////////////////////////////////////////////

	public struct function validateData( required struct data, required struct mapping, boolean collectErrors = false ){
	    
	    var validationService = this.getHibachiValidationService();
	    var utilityService = this.getHibachiUtilityService();
	   
	    var entityName = arguments.mapping.entity;
	    var isValid = true;
	    var errors = {};
	    
	    for( var propertyName in arguments.mapping.properties ){
	        
	        var propertyMeta = arguments.mapping.properties[propertyName];
	        
	        if( structKeyExists(propertyMeta, 'validations') ){
	            
	            var constraints = propertyMeta.validations;
	            
	            for( var constraintType in constraints ){
	                
	                //only a subset of validations is available for direct validation(non-object);
	                var validationFunctionName = 'validate_#constraintType#_real';
	                if( !structKeyExists(validationService, validationFunctionName) ){
	                    throw("invalid validation constraint type : #constraintType#");
	                }
	                
	                var constraintValue = constraints[constraintType];
	                
	               isValid = validationService.invokeMethod( validationFunctionName, { 
	                   propertyValue    :  data[propertyName] ?: javaCast('null',0),
	                   constraintValue  :  constraintValue,
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
	    
	    return { 
	        isValid:  !arguments.collectErrors ? isValid : StructIsEmpty( errors ), 
	        errors: errors 
	    };
	}
	
	
	public struct function transformData( required struct data, required struct mapping ){
	    var transformedData = {};
	    
	    for( var property in arguments.mapping.properties ){
	        
	        var propertyMeta = arguments.mapping.properties[property];
	        var propertyIdentifier = propertyMeta.propertyIdentifier;
	        
	        var lastStruct = transformedData;
	        var lastPropertyName = propertyIdentifier;
	        
	        if( listLen(propertyIdentifier, '.') > 1 ){
	            
	            lastPropertyName = listLast(propertyIdentifier, '.');
	            propertyIdentifier = listDeleteAt( propertyIdentifier, listLen(propertyIdentifier, '.'), '.');
	            
	            var entities = listToArray( propertyIdentifier, '.' );

                for(var entityName in entities){
                    if( !structKeyExists(lastStruct, entityName) ){
                        lastStruct[entityName] = {};
                    }
                    lastStruct = lastStruct[entityName];
                }
	        }
	        
	        lastStruct[lastPropertyName] = data[property];
	    }
	    
	    return transformedData;
	}
	
}
