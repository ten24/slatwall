component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController"{
	
	property name="fw" type="any";
	property name="collectionService" type="any";
	property name="hibachiService" type="any";
	property name="hibachiUtilityService" type="any";
	
	public void function init( required any fw ) {
		setFW( arguments.fw );
	}
	
	public void function jsentity( required struct rc ) {
		param name="arguments.rc.entityName" default="";
		
		rc.entity = arguments.rc.$.slatwall.newEntity( arguments.rc.entityName ); 
	}
}
