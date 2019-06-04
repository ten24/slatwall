component extends="HibachiService" persistent="false" accessors="true" output="false" {
    
    public string function getDefaultCollectionPropertiesList(){
        return "skuPriceID,sku.skuCode,sku.calculatedSkuDefinition,minQuantity,maxQuantity,price,priceGroup.priceGroupCode";
    } 
}