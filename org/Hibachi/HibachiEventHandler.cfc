component extends="Slatwall.org.Hibachi.HibachiObject" {

	public void function callEvent(required any eventName, required struct eventData={}){
		invokeMethod(arguments.eventName,arguments.eventData);
	}
	
}
