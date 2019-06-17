component {
    property name="firstFlexshipOrder" persistent="false";
    property name="accountTypeList" persistent="false";
    
    public any function getFirstFlexshipOrder(){
        var orderList = getService("OrderService").getOrderCollectionList();
        orderList.setDisplayProperties("orderID");
        orderList.addFilter("Account.accountID",this.getAccountID());
        orderList.addFilter("OrderTemplate.orderTemplateID","NULL","IS NOT");
        orderList.addOrderBy("orderCloseDateTime|ASC");
        var orders = orderList.getPageRecords(formatRecords=false);
        if(!arrayIsEmpty(orders)){
            return getService("OrderService").getOrder(orders[1]['orderID']);
        }
    }
    
    public boolean function hasAccountType(required string accountTypeList){
        fullAccountTypeList = this.getAccountTypeList();
        for(var accountType in arguments.accountTypeList){
            if(!listFindNoCase(fullAccountTypeList,accountType)){
                return false;
            }
        }
        return true;
    }
    
    public string function getAccountTypeList(){
        if(!structKeyExists(variables,"accountTypeList")){
            variables.accountTypeList = "";
            var priceGroupCollection = getService("PriceGroupService").getPriceGroupCollectionList();
            priceGroupCollection.setDisplayProperties("priceGroupID,priceGroupCode");
            priceGroupCollection.addFilter("accounts.accountID",this.getAccountID());
            var priceGroups = priceGroupCollection.getRecords();
            for(var priceGroup in priceGroups){
                variables.accountTypeList = listAppend(variables.accountTypeList,priceGroup['priceGroupCode']);
            }
        }
        return variables.accountTypeList;
    }
}