component extends="Slatwall.model.service.ProductService" accessors="true" output="false" {


	public string function getProductURLByUrlTitle(string urlTitle){
		var urlTitleString = "";
		if(structKeyExists(arguments,'urlTitle')){
			urlTitleString = arguments.urlTitle;
		}
		
		if(!len(getHibachiScope().setting('globalURLKeyProduct'))) {
			return "/#urlTitleString#/";
		} else {
			return "/#getHibachiScope().setting('globalURLKeyProduct')#/#urlTitleString#/";
		}
	}
	
	
}

