component extends="Slatwall.model.service.PublicService" accessors="true" output="false" {
    
    /**
     * Function to delete Account
     * This is a test method to be used in jMeter for now,
     * It is not part of core APIs, should be removed.
     * @return none
    */
    public void function deleteJmeterAccount() {
        if( getHibachiScope().getLoggedInFlag() ) {
            var deleteOk = getAccountService().deleteAccount(  getHibachiScope().getAccount() );
            getHibachiScope().addActionResult( "public:account.deleteAccount", !deleteOK );
        } else {
            getHibachiScope().addActionResult( "public:account.deleteAccount", true );   
        }
    }
}