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
	
	public void function clearModifiedEntities(){
	    var hibachiScopeData = this.getHibachiScopeData();
	    hibachiScopeData.delete('modifiedEntities');
	}
	
	public void function clearDeletedEntities(){
	    hibachiScopeData.delete('deletedEntities');
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
	
	
	
	public void function onEvent(required any eventName, required struct eventData={}){
		
		
	}
	
	public void function onApplicationEnd(){
		
	}
	
	
	
	
	

}
