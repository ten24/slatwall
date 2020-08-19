component extends="Slatwall.org.Hibachi.HibachiController" accessors="true" output="false"{

	property name="fw";
	property name="slatwallImporterIntegrationCFC";

	this.secureMethods='';
	this.secureMethods=listAppend(this.secureMethods, 'default');
	public any function init(required any fw){
		setFW(arguments.fw);
		return this;
	}
	
	
	public function before(required struct rc)
	{
        arguments.rc.entityActionDetails = {};
       
        arguments.rc.entityActionDetails['thisAction'] = arguments.rc[ getFW().getAction() ];
		arguments.rc.entityActionDetails['subsystemName'] = getFW().getSubsystem( arguments.rc.entityActionDetails.thisAction );
		arguments.rc.entityActionDetails['sectionName'] = getFW().getSection( arguments.rc.entityActionDetails.thisAction );
		arguments.rc.entityActionDetails['itemName'] = getFW().getItem( arguments.rc.entityActionDetails.thisAction );
	
		arguments.rc.entityActionDetails['itemEntityName'] = "";
		arguments.rc.entityActionDetails['backAction'] = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails['cancelAction'] = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails['createAction'] = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails['deleteAction'] = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails['detailAction'] = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails['editAction'] = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails['exportAction'] = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails['listAction'] = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails['multiPreProcessAction'] = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails['multiProcessAction'] = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails['preProcessAction'] = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails['processAction'] = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails['saveAction'] = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails.actionItemEntityName="integration";
		arguments.rc.entityActionDetails.sRedirectURL = "";
		arguments.rc.entityActionDetails.sRedirectAction = "";
		arguments.rc.entityActionDetails.fRedirectURL = "";
		arguments.rc.entityActionDetails.fRedirectAction = "";
		arguments.rc.entityActionDetails.fRenderItem = "";
		arguments.rc.entityActionDetails.sRedirectQS = "";
		arguments.rc.entityActionDetails.fRedirectQS = "";
		arguments.rc.entityActionDetails.sRenderItem = "";
		arguments.rc.integration=getService('integrationService').getIntegrationByIntegrationPackage('slatwallImporter');
	   	arguments.rc.processObject =arguments.rc.integration.getProcessObject( 'Importcsv' );//getHibachiScope().getAccount().getProcessObject('Importcsv'); 
	   
	    
	}
	
	
	public void function preprocessintegratoin(required struct rc)
	{
			var arrayOfLocalFiles = directoryList( expandPath( "/Slatwall/integrationServices/slatwallimporter/assets/downloadsample/" ), false, "name" );
   			arguments.rc.fileslist = arrayOfLocalFiles;
			arguments.rc.entityActionDetails.processAction = 'slatwallimporter:main.uploadCSV';
			arguments.rc.entityActionDetails.sRedirectAction = 'slatwallimporter:main';
			arguments.rc.edit = true;
    		arguments.rc.pageTitle ="ImportCsv"; 
    		getFW().setView("main.preprocessintegratoin_importcsv");
	}

	//upload CSVs, 
	
	public any function uploadCSV (required any rc){	
		getService("hibachiTagService").cfsetting(requesttimeout=60000);
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