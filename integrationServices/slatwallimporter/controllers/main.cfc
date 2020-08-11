component extends="Slatwall.org.Hibachi.HibachiController" accessors="true" output="false"{

	property name="fw";
	property name="slatwallImporterIntegrationCFC";


	public any function init(required any fw){
		setFW(arguments.fw);
		return this;
	}
	
	
	//TODO upload/download CSVs, UI
	
	public any function uploadCSV (required any rc){	
		getService("hibachiTagService").cfsetting(requesttimeout=60000);
        var pathToImport = ExpandPath('/Slatwall') & '/integrationServices/slatwallimporter/assets/csv/'; 
		if(FileExists(pathToImport)){
			FileDelete(pathToImport); 
		} 
		if(!DirectoryExists(pathToImport)){
			DirectoryCreate(pathToImport);
		}	
		try
		{
			var file = FileUpload(pathToImport, "importFile", "*", "Overwrite",".csv");
			getFW().setView("slatwallimporter:main");
		}
		catch(any excpt)
		{
			return excpt.Message;
		}
		
	
	    //FileDelete(pathToImport&file.serverfile);
	}

	
	
	
	public void function after( required struct rc ) {
		if(structKeyExists(arguments.rc, "fRedirectURL") && arrayLen(getHibachiScope().getFailureActions()) ){
				getFW().redirectExact( redirectLocation=arguments.rc.fRedirectURL );
		} 
		else if ( structKeyExists(arguments.rc, "sRedirectURL") && !arrayLen(getHibachiScope().getFailureActions()) ){
				getFW().redirectExact( redirectLocation=arguments.rc.sRedirectURL );
		} 
		else if ( structKeyExists(arguments.rc, "redirectURL") ){
				getFW().redirectExact( redirectLocation=arguments.rc.redirectURL );
		}
	}
	
}