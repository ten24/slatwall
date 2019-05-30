component extends="Slatwall.model.service.LoyaltyService" {
    public array function getAccruementEventOptions() {
		var options = super.getAccruementEventOptions();
		arrayAppend(options,{name=rbKey('entity.accountLoyaltyAccruement.accruementEvent.referAFriend'), value="referAFriend"})
	    return options;
    }
}