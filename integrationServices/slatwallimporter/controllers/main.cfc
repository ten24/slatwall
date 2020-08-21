component extends="Slatwall.org.Hibachi.HibachiControllerEntity" accessors="true" output="false"{

	property name="slatwallImporterIntegrationCFC";

	public function before(required struct rc)
	{
		super.before(rc);
    	arguments.rc.integration=getService('integrationService').getIntegrationByIntegrationPackage('slatwallImporter');


	}
    
    public function default(required struct rc)
    {
    	arguments.rc.fileslist = getService('SlatwallImporterService').getDownloadLink();
    }
    
	public void function preprocessintegratoin(required struct rc)
	{
			
   		   	arguments.rc.processObject =arguments.rc.integration.getProcessObject( 'Importcsv' );//getHibachiScope().getAccount().getProcessObject('Importcsv'); 
   			arguments.rc.entityActionDetails.processAction = 'slatwallimporter:main.uploadCSV';
			arguments.rc.entityActionDetails.sRedirectAction = 'slatwallimporter:main';
			arguments.rc.edit = true;
    		arguments.rc.pageTitle ="ImportCsv"; 
    		getFW().setView("main.preprocessintegratoin_importcsv");
	}

	//upload CSVs, 
	
	public any function uploadCSV (required any rc){	
		getService("hibachiTagService").cfsetting(requesttimeout=60000);
		arguments.rc.processObject =arguments.rc.integration.getProcessObject( 'Importcsv' );
        var pathToImport = ExpandPath('/Slatwall') & '/integrationServices/slatwallimporter/assets/csv/'; 
      
      	if(!DirectoryExists(pathToImport)){
			DirectoryCreate(pathToImport);
		}	
		try
		{
			var file = FileUpload(pathToImport, "uploadFile", "text/csv", "Overwrite");
		
			if (not listFindNoCase("csv", file.serverFileExt)) {
    		 	getHibachiScope().showMessage("The uploaded file is not of type CSV.", "error");
    	    }
			getHibachiScope().showMessage("Uppload success", "success");
		
		}catch (any e) {
    		getHibachiScope().showMessage("An error occurred while uploading your file" & e.Message, "error");
			
		}
		getFW().setView("main");
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