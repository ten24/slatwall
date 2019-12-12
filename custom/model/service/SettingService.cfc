component extends="Slatwall.model.service.SettingService" {
	public struct function getAllSettingMetaData() {
		var settingMetaData = super.getAllSettingMetaData();
		settingMetaData["orderTemplateDaysAllowedToEditNextOrderTemplate"] = {fieldtype="text", defaultValue="2", validate={dataType="numeric",required=true}};
		settingMetaData["orderSecondaryReturnReasonTypeOptions"] = {
			fieldType="listingMultiselect",
			listingMultiselectEntityName="Type"
		}
		return settingMetaData;
	}
}