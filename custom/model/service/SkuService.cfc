component extends="Slatwall.model.service.SkuService" accessors="true" output="false" {

	public any function processSku_skuImport() {
		var data = {
			'days' : 1
		}
		getHibachiScope().getService('integrationService').getIntegrationByIntegrationPackage('monat').getIntegrationCFC("data").importMonatProducts(data);

		return this.new('Sku');
	}
}