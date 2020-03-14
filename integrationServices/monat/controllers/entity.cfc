component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerEntity" {
    
    this.publicMethods = '';
	this.secureMethods=listAppend(this.secureMethods, 'processOrder_placeInProcessingOne');
	this.secureMethods=listAppend(this.secureMethods, 'processOrder_placeInProcessingTwo');
    
}