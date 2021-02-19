component extends="Slatwall.integrationServices.BaseDataProviderHandler" implements="Slatwall.integrationServices.DataProviderHandlerInterface" {
	
	
	property name="slatwallProductSearchSearchCFC";



    public struct function getHibachiScopeData(){
	    return this.getSlatwallProductSearchSearchCFC().getHibachiScopeData();
	}
	
	public void function setHibachiScopeData( struct data = {} ){
	    return this.getSlatwallProductSearchSearchCFC().setHibachiScopeData(arguments.data);
	}
	
	public void function collectModifiedEntityID(required string entityName, required string entityID ){
	    var hibachiScopeData = this.getHibachiScopeData();
	    
	    if( !structKeyExists( hibachiScopeData, 'modifiedEntities') ){
	        hibachiScopeData['modifiedEntities'] = {};
	    }
	    
	    var modifiedEntities = hibachiScopeData['modifiedEntities'];
	    if( !structKeyExists(modifiedEntities, arguments.entityName) ){
	        modifiedEntities[arguments.entityName] = '';
	    }
	    
	    modifiedEntities[arguments.entityName] = listAppend( modifiedEntities[arguments.entityName], arguments.entityID );
	}

	public void function collectDeletedEntityID(required string entityName, required string entityID ){
	    var hibachiScopeData = this.getHibachiScopeData();
	    
	    if( !structKeyExists( hibachiScopeData, 'deletedEntities') ){
	        hibachiScopeData['deletedEntities'] = {};
	    }
	    
	    var deletedEntities = hibachiScopeData['deletedEntities'];
	    if( !structKeyExists(deletedEntities, arguments.entityName) ){
	        deletedEntities[arguments.entityName] = '';
	    }
	    
	    deletedEntities[arguments.entityName] = listAppend( deletedEntities[arguments.entityName], arguments.entityID );
	}
	
	public void function clearModifiedEntities(){
	    this.getHibachiScopeData().delete('modifiedEntities');
	}
	
	public void function clearDeletedEntities(){
	    this.getHibachiScopeData().delete('deletedEntities');
	}
	
	
	public void function beforeORMFlush(required any eventName, required struct eventData={}){
		var hibachiScopeData = this.getHibachiScopeData();
	    
	    if( 
	        !structKeyExists( hibachiScopeData, 'deletedEntities') 
	        || this.hibachiIsStructEmpty(hibachiScopeData.deletedEntities) 
	    ){
	        return;
	    }
	        
        for(var entityName in hibachiScopeData.deletedEntities ){
            this.getSlatwallProductSearchDAO().removeProductFilterFacetOprionsByEntityNameAndIDs( 
                entityName =  entityName,
                entityIDs = hibachiScopeData.deletedEntities[ entityName ]
            );
        }
	    
		this.clearDeletedEntities();
	}
	
	public void function afterORMFlush(required any eventName, required struct eventData={}){
		var hibachiScopeData = this.getHibachiScopeData();
	    
	    if( 
	        !structKeyExists( hibachiScopeData, 'modifiedEntities') 
	        || this.hibachiIsStructEmpty(hibachiScopeData.modifiedEntities) 
	    ){
	        return;
	    }
	        
        for(var entityName in hibachiScopeData.modifiedEntities ){
            this.getSlatwallProductSearchDAO().updateProductFilterFacetOptionsByEntityNameAndIDs( 
                entityName =  entityName,
                entityIDs = hibachiScopeData.modifiedEntities[ entityName ]
            );
        }

	    // if some product or sku has been modified, re-calculate filter options
	    if( 
	        structKeyExists( hibachiScopeData.modifiedEntities, 'product' ) 
	        || structKeyExists( hibachiScopeData.modifiedEntities, 'sku'  ) 
	    ){
	        
	        this.getSlatwallProductSearchDAO().recalculateProductFilterFacetOprionsForProductsAndSkus(
	                skuIDs      = hibachiScopeData.modifiedEntities['sku']     ?: '',
	                productIDs  = hibachiScopeData.modifiedEntities['product'] ?: ''
	            );
	    }
	    
		this.clearDeletedEntities();
	}
	
	public void function beforeORMClearSession(required any eventName, required struct eventData={}){
		// if session is cleared then we don't need to update anything
		this.setHibachiScopeData({});
	}
	
// 	public void function onApplicationEnd(){
		
// 	}
	
	
}
