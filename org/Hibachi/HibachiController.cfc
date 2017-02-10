component output="false" accessors="true" extends="HibachiObject" {
	
	property name="fw" type="any";
	
	this.publicMethods = "";
	this.anyAdminMethods = "";
	this.anyLoginMethods = "";
	this.secureMethods = "";
	this.entityController = false;
	this.restController = false;
	
	public void function init( required any fw ) {
		setFW(arguments.fw);
	}
}
