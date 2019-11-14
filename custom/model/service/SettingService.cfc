component extends="Slatwall.model.service.SettingService" {
	public struct function getAllSettingMetaData() {
		var settingMetaData = super.getAllSettingMetaData();
		settingMetaData["orderTemplateDaysAllowedToEditNextOrderTemplate"] = {fieldtype="text", defaultValue="2", validate={dataType="numeric",required=true}};
		settingMetaData["globalMPEnrollmentFeeSkuID"] = {fieldtype="text", defaultValue="", validate={required=true}};
		settingMetaData["globalVIPEnrollmentFeeSkuID"] = {fieldtype="text", defaultValue="", validate={required=true}};

		return settingMetaData;
	}
}