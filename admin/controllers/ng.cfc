component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {

	public void function before(required struct rc) {
		request.layout = false;
	}
	
	public void function collection(required struct rc) {
		if(arguments.rc.ajaxRequest) {
			var collection = arguments.rc.$.slatwall.getService("collectionService").getCollection("", true);
			
			arguments.rc.ajaxResponse['collection'] = collection;
		}
	}
}
