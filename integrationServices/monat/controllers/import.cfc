component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerEntity" {
 
    public void function importProducts(){
        param name="arguments.rc.fileLocation" default="/default/assets/";
		param name="arguments.rc.fileName" default="whateverMcButtever.csv";

		getService("UtilityTagService").cfsetting(requesttimeout="60000");
		var columnTypeList = 'varchar,varchar,varchar';
		var skuQuery = getService('hibachiDataService').loadQueryFromCSVFileWithColumnTypeList(arguments.rc.fileLocation&arguments.rc.fileName, columnTypeList);

    }
    
}