component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiProcess" {

    //injected properties
	property name="integration";

    // data-properties
    property name="entityName" hb_formFieldType="select" ;
    property name="uploadFile" hb_formFieldType="file" hb_fileAcceptMIMEType="text/csv" hb_fileAcceptExtension=".csv";
	
	
	public any function getEntityNameOptions()
	{
	    var optoin=[
	        {   name:"Account",    value:"Account"  },
	        {   name:"Order",      value:"Order"    }
	    ];
	    return optoin;
	}

}