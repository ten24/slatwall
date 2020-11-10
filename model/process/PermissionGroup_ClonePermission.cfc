component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="permissionGroup";

	property name="fromPermissionGroupID" hb_formFieldType="select";
	property name="actionPermissionFlag" hb_formFieldType="yesno" default=0;
	property name="dataPermissionFlag" hb_formFieldType="yesno" default=0;



	public array function getFromPermissionGroupIDOptions(){
		if(!structKeyExists(variables,'fromPermissionGroupOptions')){
			variables.fromPermissionGroupOptions = [];

			var collectionList = getService("hibachiService").getCollectionList("PermissionGroup");
			collectionList.addDisplayProperty("permissionGroupID|value");
			collectionList.addDisplayProperty("permissionGroupName|name");
			collectionList.addOrderBy("permissionGroupName|ASC");

			variables.fromPermissionGroupOptions = collectionList.getRecords();
		}
		return variables.fromPermissionGroupOptions;
	}
}