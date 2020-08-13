component extends="Slatwall.org.Hibachi.HibachiController" accessors="true" output="false"{

	property name="fw";
	property name="slatwallImporterIntegrationCFC";


	public any function init(required any fw){
		setFW(arguments.fw);
		return this;
	}
	
	
	//upload CSVs, 
	
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
			var file = FileUpload(pathToImport, "importFile", "text/csv", "Overwrite");
			if (not listFindNoCase("csv", file.serverFileExt)) {
    		 	getHibachiScope().showMessage("The uploaded file is not of type CSV.", "error");
    	    }
			getHibachiScope().showMessage("Uppload success", "success");
		
		}catch (any e) {
    		getHibachiScope().showMessage("An error occurred while uploading your file" & e.Message, "error");
			
		}
		getFW().setView("slatwallimporter:main");
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