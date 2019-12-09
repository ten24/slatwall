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
	    this.publicService.doAction('getSiteOwnerAccount').then(result => {
	        this.ownerAccount = result.ownerAccount;
	    });
	}
}

export { MonatSiteOwnerController };