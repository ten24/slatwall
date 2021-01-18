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

	property name="importerMappingDAO" type="any";
	property name="hibachiCacheService" type="any";
	
	property name="mappingCacheLoadedFlag" default=false;
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function getMappingByMappingCode(required string mappingCode){
	    return this.getCachedMappings()[ arguments.mappingCode];
	}
	
	
	public any function saveImporterMapping(required any importerMapping, required struct data) {
		 arguments.importerMapping = super.saveImporterMapping(argumentCollection=arguments);
		 
		 if( !arguments.importerMapping.hasErrors() ){
		     
            var mappingStruct = DeSerializeJson( arguments.importerMapping.getMapping() );
		    mappingStruct['name']        = arguments.importerMapping.getName();
	        mappingStruct['entityName']  = arguments.importerMapping.getBaseObject();
	        mappingStruct['mappingCode'] = arguments.importerMapping.getMappingCode();
	        
	        this.putMappingIntoCache(mappingStruct);
		 }
		 
		 return arguments.importerMapping;
	}
	
	public void function reloadMappings(){
	    
	    var defaultMappings = {};
	    var baseDir = this.getApplicationValue('applicationRootMappingPath') & "/config/importer/mappings/";

	    DirectoryList( 
		    path     = baseDir, 
		    recurse  = false, 
		    listInfo = "name",
			filter   = '*.json',
			type     = 'file'
		)
		.each( function(fileName){

	        var mappingJson = FileRead( baseDir & arguments.fileName);
	        if(!this.isValidImporterMappingConfig(mappingJson)){
	            throw("Importer Mapping File #file# is not valid \n" &mappingJson );
	        }
	        
	        var mappingStruct = deSerializeJSON(mappingJson);
	        mappingStruct['mappingCode'] = listFirst(arguments.fileName, '.');
	        defaultMappings[ mappingStruct.mappingCode ] = mappingStruct;
		});
		
		structAppend( defaultMappings, this.getMappingsFromDB() );
	    
	    this.setCachedMappings(defaultMappings);
	    this.setMappingCacheLoadedFlag(true);
	}
	
	public struct function getMappingsFromDB(){
	    var mappings = {};
	    var dbMappings = this.getImporterMappingDAO().getImporterMappings();
	    
	    for(var dbMapping in dbMappings){
	        var thisMapping            = deSerializeJSON(dbMapping['mapping']);
	        thisMapping['name']        = dbMapping['name'];
	        thisMapping['entityName']  = dbMapping['baseObject'];
	        thisMapping['mappingCode'] = dbMapping['mappingCode'];
	        mappings[thisMapping.mappingCode] = thisMapping;   
	    }
	    
	    return mappings;
	}
	
	public struct function getCachedMappings(){
	    if(!this.getMappingCacheLoadedFlag()){
	        this.reloadMappings();
	    }
	    
	    return this.getHibachiCacheService().getCachedValue('importerMappings');
	}
	
	public void function setCachedMappings( required struct mappings){
	    this.getHibachiCacheService().setCachedValue('importerMappings', arguments.mappings);
	}
	
	public void function putMappingIntoCache(required struct mapping ){
	    var mappings = this.getCachedMappings();
	    mappings[arguments.mapping.mappingCode] = arguments.mapping;
	    this.setCachedMappings(mappings);
	}
	
	public boolean function isValidImporterMappingConfig(required string mapping){
	    
        if( !IsJSON( arguments.mapping )){
            return false;
        }
        
	    // TODO: add more checks, for relations, properties, generator-functions
        
        return true;
	}
	
	
	
	public struct function createMappingCSVHeaderMetaDataRecursively( required string mappingCode, string sourceDataKeysPrefix = '' ){
  	    
        var headers = {};
        var mapping = this.getMappingByMappingCode( arguments.mappingCode );
    
        if(structKeyExists(mapping, 'properties') ){
            for( var sourcePropertyName in mapping.properties ){
                if( !this.hibachiIsEmpty(arguments.sourceDataKeysPrefix) ){
                    sourcePropertyName = arguments.sourceDataKeysPrefix & sourcePropertyName;
                }
                // we can add a way to either define or infer data-type if needed
                headers[ ucFirst(sourcePropertyName, true) ] = "VarChar"; 
            }
        }
  	    
  	    if( structKeyExists(mapping, 'relations') ){
  	        // ( if required) we can add relationship-type-check to check if the property can be availabe in a csv ( only *-to-one relations )
  	        for(var thisRelation in mapping.relations){
  	            // includeInCSVTemplate is a flag in thisRelation mappings; 
  	            // being used to handle recursive-relations, like productType and parentProductType
  	            if( !structKeyExists(thisRelation, 'excludeFromTemplate') || !thisRelation.excludeFromTemplate ){
  	                headers.append( this.createMappingCSVHeaderMetaDataRecursively(
                        mappingCode          = thisRelation.mappingCode ?: thisRelation.entityName,
                        sourceDataKeysPrefix = thisRelation.sourceDataKeysPrefix ?: ''
                    ));
  	            }
	        }
  	    }
  	    
  	    if( structKeyExists(mapping, 'dependencies') ){
  	        for(var dependency in mapping.dependencies ){
  	            // add prefix if needed
  	            var sourcePropertyName = dependency.key;
  	            if( !this.hibachiIsEmpty(arguments.sourceDataKeysPrefix) ){
                    sourcePropertyName = arguments.sourceDataKeysPrefix & sourcePropertyName;
                }
                
  	            headers[ ucFirst(sourcePropertyName, true) ] = 'VarChar';
	        }
  	    }
  	    
  	    return headers;
    }

	public struct function getMappingCSVHeaderMetaData( required string mappingCode ){
	    
	    var cacheKey = "getMappingCSVHeaderMetaData_" &arguments.mappingCode;
	    
	    if( !structKeyExists(variables, cacheKey) ){
	        
      	    var columnNamesAndTypes = this.createMappingCSVHeaderMetaDataRecursively( arguments.mappingCode );
      	    
      	    var columns = columnNamesAndTypes.keyArray().sort('textNoCase');
      	    var columnTypes = columns.map( function( column ){ 
      	        return columnNamesAndTypes[ column ]; 
      	    });
      	    
      	    variables[ cacheKey ] = { "columns": columns.toList(), "columnTypes": columnTypes.toList() };
	    }
	    
  	    return variables[ cacheKey ];
  	}
  	
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}

