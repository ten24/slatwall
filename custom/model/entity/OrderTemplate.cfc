component {

	//For flexships we only want to give the admin the choice between Monthly and Bi-Montly
	public array function getFrequencyTermOptions(){
		var termCollection = getService('SettingService').getTermCollectionList();
		termCollection.setDisplayProperties('termName|name,termID|value');
		termCollection.addFilter('termHours','null','is');
		termCollection.addFilter('termDays','null','is');
		termCollection.addFilter('termYears','null','is');
		termCollection.addfilter('termMonths','1,2','in');	
		return termCollection.getRecords(); 
	}

}
