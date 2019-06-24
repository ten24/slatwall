component {
    // Non Persistent
    property name="fullNameWithPermissionGroups" persistent="false";
    property name="permissionGroupNameList" persistent="false";
    
    //CUSTOM FUNCTIONS BEGIN
    public string function getFullNameWithPermissionGroups() {
		if(!getNewFlag()){
			if(!structKeyExists(variables,'permissionGroupNameList')){
				var records = getDao('permissionGroupDao').getPermissionGroupCountByAccountID(getAccountID());
				var permissionGroupNameList = '';
				
				if(arraylen(records) && records[1]['permissionGroupsCount']){
					
					var permissionGroupCollectionList = this.getPermissionGroupsCollectionList();
					permissionGroupCollectionList.setEnforceAuthorization(false);
					permissionGroupCollectionList.setDisplayProperties('permissionGroupName,permissionGroupID' );
					permissionGroupCollectionList.setPermissionAppliedFlag(true);
					var permissionGroupRecords = permissionGroupCollectionList.getRecords(formatRecords=false);
					for(var permissionGroupRecord in permissiongroupRecords){
						permissionGroupNameList =  listAppend(permissionGroupNameList,'<a href="?slatAction=admin:entity.detailpermissiongroup&permissionGroupID=#permissionGroupRecord["permissionGroupID"]#">#permissionGroupRecord["permissionGroupName"]#</a>');
					}
					
					permissionGroupNameList = '( #permissionGroupNameList# )';
				}
				variables.permissionGroupNameList = permissionGroupNameList;
			}
		}
		return hibachiHtmlEditFormat(getFullname()) & variables.permissionGroupNameList;
	}
}