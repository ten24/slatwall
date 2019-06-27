component {
    property name="firstFlexshipOrder" persistent="false";
    property name="accountTypeList" persistent="false";

    public boolean function hasAccountType(required string accountTypeList){
        var fullAccountTypeList = this.getAccountTypeList();
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
