component extends="Slatwall.org.Hibachi.HibachiControllerEntity" accessors="true" output="false"{

	property name="fw";
	property name="integrationService";
	property name="slatwallProductSearchDAO";
	property name="slatwallProductSearchService";

	this.publicMethods = "";


	this.secureMethods="reBuildIndex";

	public any function init(required any fw){
		setFW(arguments.fw);
		return this;
	}
	
	public function before( required struct rc ){
		super.before(rc);
    	arguments.rc.integration = this.getIntegrationService().getIntegrationByIntegrationPackage('slatwallProductSearch');
	}
	
	//rebuilds an algolia index
	public void function reBuildIndex(required struct rc){
	    this.getSlatwallProductSearchDAO().rePopulateProductFilterFacetOptionTable();
            
	    getFW().setView("main.blank");
	}

}