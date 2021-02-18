component extends="Slatwall.org.Hibachi.HibachiControllerEntity" accessors="true" output="false"{

	property name="fw";
	property name="integrationService";
	property name="slatwallDefaultListingDAO";
	property name="slatwallDefaultListingService";

	this.publicMethods = "";


	this.secureMethods="reBuildIndex";

	public any function init(required any fw){
		setFW(arguments.fw);
		return this;
	}
	
	public function before( required struct rc ){
		super.before(rc);
    	arguments.rc.integration = this.getIntegrationService().getIntegrationByIntegrationPackage('slatwallDefaultListing');
	}
	
	//rebuilds an algolia index
	public void function reBuildIndex(required struct rc){
	    this.getSlatwallDefaultListingDAO().rePopulateProductFilterFacetOptionTable();
            
	    getFW().setView("main.blank");
	}

}