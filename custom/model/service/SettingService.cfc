component extends="Slatwall.model.service.SettingService" {
	public struct function getAllSettingMetaData() {
		var settingMetaData = super.getAllSettingMetaData();
		settingMetaData["orderTemplateDaysAllowedToEditNextOrderTemplate"] = {fieldtype="text", defaultValue="2", validate={dataType="numeric",required=true}};
		settingMetaData["orderSecondaryReturnReasonTypeOptions"] = {
			fieldType="listingMultiselect",
			listingMultiselectEntityName="Type"
		}

		settingMetaData["orderInitialEnrollmentPeriodForMarketPartner"] = {fieldtype="text", defaultValue="7"};
		settingMetaData["orderMaxAmountAllowedToSpendInInitialEnrollmentPeriod"] = {fieldtype="text", defaultValue="200"};
		settingMetaData["orderMaxDaysAfterAccountCreate"] = {fieldtype="text", defaultValue="30"};
		
		return settingMetaData;
	}
}