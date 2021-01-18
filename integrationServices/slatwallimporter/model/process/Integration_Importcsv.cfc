component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiProcess" {

    //injected properties
	property name="integration";

    // data-properties
    property name="mappingCode" hb_formFieldType="select" ;
    property name="uploadFile" hb_formFieldType="file" hb_fileAcceptMIMEType="text/csv" hb_fileAcceptExtension=".csv";
	
	
	public any function getMappingCodeOptions(){
	    
	    var index = this.getService("slatwallImporterService").getAvailableSampleCsvFilesIndex();
	    var options = [];
	    
	    for(var mappingCode in index){
	        options.append({ 
    	        "name"  : index[mappingCode], 
    	        "value" : mappingCode 
	        });
	    }
	    
	    return options;
	}

}