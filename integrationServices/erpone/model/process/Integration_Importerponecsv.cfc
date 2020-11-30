component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiProcess" {

    //injected properties
	property name="integration";

    // data-properties
    property name="entityName" hb_formFieldType="select" ;
    property name="uploadFile" hb_formFieldType="file" hb_fileAcceptMIMEType="text/csv" hb_fileAcceptExtension=".csv";
	
	
	public any function getEntityNameOptions(){
	    
	    var index = this.getService("erpOneService").getAvailableSampleCsvFilesIndex();
	    var options = [];
	    
	    for(var entityName in index){
	        options.append( {"name": entityName, "value": entityName} );
	    }
	    
	    return options;
	}

}