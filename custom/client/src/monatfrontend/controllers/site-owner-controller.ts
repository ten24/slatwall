declare var hibachiConfig;

class MonatSiteOwnerController {
	public ownerAccount: any;

	// @ngInject
	constructor(
		public publicService
	) {
	    if(hibachiConfig.siteOwner.length){
	        this.getSiteOwner();
	    }
	}
	
	public getSiteOwner=()=>{
	    let accountNumber = hibachiConfig.siteOwner;
	    this.publicService.doAction('getSiteOwnerAccount').then(result => {
	        this.ownerAccount = result.ownerAccount;
	        this.ownerAccount['firstName'] = result.ownerAccount.FIRSTNAME;
	        this.ownerAccount['accountImage'] = result.ownerAccount.ACCOUNTIMAGE;
	    });
	}
}

export { MonatSiteOwnerController };