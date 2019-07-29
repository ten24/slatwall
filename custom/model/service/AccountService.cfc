component extends="Slatwall.model.service.AccountService" {

	public string function getCustomAvailableProperties() {
        return 'priceGroups, accountType';
    }
    
}