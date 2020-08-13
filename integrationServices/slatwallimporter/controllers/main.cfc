component extends="Slatwall.org.Hibachi.HibachiController" accessors="true" output="false"{

	property name="fw";
	property name="slatwallImporterIntegrationCFC";


	public any function init(required any fw){
		setFW(arguments.fw);
		return this;
	}
	
	
	//TODO upload/download CSVs, UI
	
	
	
	public void function after( required struct rc ) {
		if(structKeyExists(arguments.rc, "fRedirectURL") && arrayLen(getHibachiScope().getFailureActions()) ){
				getFW().redirectExact( redirectLocation=arguments.rc.fRedirectURL );
		} 
		else if ( structKeyExists(arguments.rc, "sRedirectURL") && !arrayLen(getHibachiScope().getFailureActions()) ){
				getFW().redirectExact( redirectLocation=arguments.rc.sRedirectURL );
		} 
		else if ( structKeyExists(arguments.rc, "redirectURL") ){
				getFW().redirectExact( redirectLocation=arguments.rc.redirectURL );
		}
	}
	
}