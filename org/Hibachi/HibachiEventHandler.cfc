component extends="Slatwall.org.Hibachi.HibachiObject" {
	public void function callEvent(required any eventName, required struct eventData={}){
		if(structKeyExists(this,arguments.eventName)){
			invokeMethod(arguments.eventName,arguments.eventData);	
		}
	}
}
