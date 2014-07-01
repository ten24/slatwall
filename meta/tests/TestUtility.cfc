component {
	
	public any function init(required any slatwallApplication) {
		
		variables.slatwallApplication = arguments.slatwallApplication;
		
		return this;
	}
	
	// Thanks to Joe Rinehart and Brian Kotek
	public function readLocalConfiguration(){
		var configStruct = structNew();
		var hostname = createObject( "java", "java.net.InetAddress" ).getLocalHost().getHostName();
		var configPath = expandPath( "/Slatwall/meta/tests/config/#hostname#.ini" );
		if(not fileExists(configPath)){
			throw("Can't load local configuration: #configPath# should exist! If you're seeing this, copy /Slatwall/meta/tests/config/sample.ini and name it #hostname#.ini, then update any values with your environment-specific details");
		}
		
		var sections = getProfileSections(configPath);
		for(var section in sections){
			configStruct[section] = structNew();
			if(!isArray(sections[section])) {
				sections[section] = listToArray(sections[section]);
			}
			for(var key in sections[section]){
				configStruct[ section ][ key ] = getProfileString(configPath, section, key);
			}
		}
		return configStruct;
	}
	
	public function updateTestData(){
		
		writeLog(file="Slatwall", text="test");
		writeLog(file="Slatwall", text="#expandPath('/Slatwall/meta/tests/config/testdbdata')#");
		
		variables.slatwallApplication.getBeanFactory().getBean("dataService").loadDataFromXMLDirectory(xmlDirectory = expandPath("/Slatwall/meta/tests/config/testdbdata"));
	}
	
}