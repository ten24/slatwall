component extends="PageObject" {
	
	variables.slatAction = "entity.listintegration";
	variables.title = "Integration | Slatwall";
	variables.locators = {
		pageTwoButton = "//html/body/div[3]/div/div/div/ul/li[12]/a",
		table = '//*[@class="table table-striped table-bordered table-condensed"]',
		muraEditButton = '//*[@href="?slatAction=entity.editintegration&integrationID=8a8080834721af1a01474cb5c94e109a"]'
	};
	
}