component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="app";

	// Data Properties
	property name="appName" hb_rbKey="entity.app.appName";
	property name="appCode" hb_rbKey="entity.app.appCode";
	property name="createAppTemplatesFlag" ormtype="boolean"; 
	
}
