component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiProcess" {
	property name="integration";
    property name="uploadFile" hb_formFieldType="file" hb_fileAcceptMIMEType="text/csv" hb_fileAcceptExtension=".csv";
    property name="entityName" hb_formFieldType="select" ;
    property name="donwloadLink"; 
   
	
	
	public any function getEntityNameOptions()
	{
	    var optoin=[{name:"Ex",value:"entity1"},{name:"BX",value:"entity1"}];
	    return optoin;
	}

}