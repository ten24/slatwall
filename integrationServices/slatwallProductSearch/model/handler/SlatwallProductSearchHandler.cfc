component accessors="true" output="false" extends="Slatwall.integrationServices.BaseDataProviderHandler"{

	property name="slatwallProductSearchSearchCFC";
	property name="slatwallProductSearchDAO";


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
            this.getSlatwallProductSearchDAO().removeProductFilterFacetOptionsByEntityNameAndIDs( 
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
	        
	        this.getSlatwallProductSearchDAO().recalculateProductFilterFacetOptionsForProductsAndSkus(
	                skuIDs      = hibachiScopeData.modifiedEntities['sku']     ?: '',
	                productIDs  = hibachiScopeData.modifiedEntities['product'] ?: ''
	            );
	    }
	    
		this.clearModifiedEntities();
	}
	
	public void function beforeORMClearSession(required any eventName, required struct eventData={}){
		// if session is cleared then we don't need to update anything
		this.setHibachiScopeData({});
	}
	
	
	/* ************************* DELETE EVENTS ****************************** */
	
	public any function beforeProductDelete(required any product){
	    if( !arguments.product.isNew() && !arguments.product.hasErrors() ){
	        this.collectDeletedEntityID('product', arguments.product.getProductID() );
	    }
	}
	
	public any function beforeSkuDelete(required any sku){
	    if( !arguments.sku.isNew() && !arguments.sku.hasErrors() ){
	        this.collectDeletedEntityID('sku', arguments.sku.getSkuID() );
	    }
	}
	
	public any function beforeBrandDelete(required any brand){
	    if( !arguments.brand.isNew() && !arguments.brand.hasErrors() ){
	        this.collectDeletedEntityID('brand', arguments.brand.getBrandID() );
	    }
	}
	
	public any function beforeCategoryDelete(required any category){
	    if( !arguments.category.isNew() && !arguments.category.hasErrors() ){
	        this.collectDeletedEntityID('category', arguments.category.getCategoryID() );
	    }
	}
	
	public any function beforeOptionDelete(required any option){
	    if( !arguments.option.isNew() && !arguments.option.hasErrors() ){
	        this.collectDeletedEntityID('option', arguments.option.getOptionID() );
	    }
	}
	
	public any function beforeOptionGroupDelete(required any optionGroup){
	    if( !arguments.optionGroup.isNew() && !arguments.optionGroup.hasErrors() ){
	        this.collectDeletedEntityID('optionGroup', arguments.optionGroup.getOptionGroupID() );
	    }
	}
	
	public any function beforeProductTypeDelete(required any productType){
	    if( !arguments.productType.isNew() && !arguments.productType.hasErrors() ){
	        this.collectDeletedEntityID('productType', arguments.productType.getProductTypeID() );
	    }
	}
	
	public any function beforeSiteDelete(required any site){
	    if( !arguments.site.isNew() && !arguments.site.hasErrors() ){
	        this.collectDeletedEntityID('site', arguments.site.getSiteID() );
	    }
	}
	
	public any function beforeAttributeDelete(required any attribute){
	    if( !arguments.attribute.isNew() && !arguments.attribute.hasErrors() ){
	        this.collectDeletedEntityID('attribute', arguments.attribute.getAttributeID() );
	    }
	}
	
	public any function beforeAttributeSetDelete(required any attributeSet){
	    if( !arguments.attributeSet.isNew() && !arguments.attributeSet.hasErrors() ){
	        this.collectDeletedEntityID('attributeSet', arguments.attributeSet.getAttributeSetID() );
	    }
	}
	
	public any function beforeAttributeOptionDelete(required any attributeOption){
	    if( !arguments.attributeOption.isNew() && !arguments.attributeOption.hasErrors() ){
	        this.collectDeletedEntityID('attributeOption', arguments.attributeOption.getAttributeOptionID() );
	    }
	}
	
	/* ************************* SAVE EVENTS ****************************** */
    
    public any function afterProductSaveSuccess(required any product){
	    this.collectModifiedEntityID('product', arguments.product.getProductID() );
	}
	
	public any function afterSkuSaveSuccess(required any sku){
	    this.collectModifiedEntityID('sku', arguments.sku.getSkuID() );
	}
	
	public any function afterBrandSaveSuccess(required any brand){
	    this.collectModifiedEntityID('brand', arguments.brand.getBrandID() );
	}
	
	public any function afterCategorySaveSuccess(required any category){
	    this.collectModifiedEntityID('category', arguments.category.getCategoryID() );
	}
	
	public any function afterOptionSaveSuccess(required any option){
	    this.collectModifiedEntityID('option', arguments.option.getOptionID() );
	}
	
	public any function afterOptionGroupSaveSuccess(required any optionGroup){
	    this.collectModifiedEntityID('optionGroup', arguments.optionGroup.getOptionGroupID() );
	}
	
	public any function afterProductTypeSaveSuccess(required any productType){
	    this.collectModifiedEntityID('productType', arguments.productType.getProductTypeID() );
	}
	
	public any function afterSiteSaveSuccess(required any site){
	    this.collectModifiedEntityID('site', arguments.site.getSiteID() );
	}
	
	public any function afterAttributeSaveSuccess(required any attribute){
	    this.collectModifiedEntityID('attribute', arguments.attribute.getAttributeID() );
	}
	
	public any function afterAttributeSetSaveSuccess(required any attributeSet){
	    this.collectModifiedEntityID('attributeSet', arguments.attributeSet.getAttributeSetID() );
	}
	
	public any function afterAttributeOptionSaveSuccess(required any attributeOption){
	    this.collectModifiedEntityID('attributeOption', arguments.attributeOption.getAttributeOptionID() );
	}
	
}
