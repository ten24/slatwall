component extends="Slatwall.model.service.SettingService" {
	public struct function getAllSettingMetaData() {
		var settingMetaData = super.getAllSettingMetaData();
		settingMetaData["orderTemplateDaysAllowedToEditNextOrderTemplate"] = {fieldtype="text", defaultValue="2", validate={dataType="numeric",required=true}};
		settingMetaData["orderSecondaryReturnReasonTypeOptions"] = {
			fieldType="listingMultiselect",
			listingMultiselectEntityName="Type"
		}
		
		settingMetaData['emailAccountPropertyIdentifier'] = {fieldtype="text",defaultValue="Please-Override-Account-PropertyIdentifier-in-EmailTemplate-Settings"};
		settingMetaData["siteInitialEnrollmentPeriodForMarketPartner"] = {fieldtype="text", defaultValue="7"};
		settingMetaData["siteMaxAmountAllowedToSpendInInitialEnrollmentPeriod"] = {fieldtype="text", defaultValue="200"};
		settingMetaData["siteMaxDaysAfterAccountCreate"] = {fieldtype="text", defaultValue="30"};
		settingMetaData["siteDefaultOFYSkuCode"] = {fieldtype="text",defaultValue=""};
		settingMetaData["siteOrderTemplateEligibleShippingMethods"] = {fieldType="listingMultiselect", listingMultiselectEntityName="ShippingMethod"};
		return settingMetaData;
	}
}
