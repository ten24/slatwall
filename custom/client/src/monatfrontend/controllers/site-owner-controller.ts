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
	    this.publicService.doAction('getSiteOwnerAccount', {identifier: accountNumber, identifierType: 'accountNumber' }).then(result => {
	        this.ownerAccount = result.ownerAccount;
	    });
	}
}

export { MonatSiteOwnerController };