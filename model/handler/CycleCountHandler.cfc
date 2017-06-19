component extends="HibachiEventHandler" {
	
	public any function afterCycleCountBatchSaveSuccess() {
		writeLog(file="Slatwall",text="afterCycleCountBatchSaveSuccess:hasCycleCountBatchItems=#arrayLen(arguments.cycleCountBatch.getCycleCountBatchItems())#");
		
		if(!arrayLen(arguments.cycleCountBatch.getCycleCountBatchItems())) {
			var cycleCountGroupSmartList = getService('physicalService').getCycleCountGroupSmartList();
			cycleCountGroupSmartList.addFilter('activeFlag',1);
			for(var cycleCountGroup in cycleCountGroupSmartList.getRecords()) {
				var skuList = cycleCountGroup.getCycleCountGroupsSkusCollection().getPageRecords();
				for(var skuDetails in cyclecountgroup.getCycleCountGroupsSkusCollection().getPageRecords(formatRecords=false)) {
					var sku = arguments.slatwallScope.getEntity('Sku', skuDetails['skuID']);
					for(var stock in sku.getStocks()) {
						if(stock.hasInventory()) {
							var newcCycleCountBatchItem = arguments.slatwallScope.newEntity('cycleCountBatchItem');
							newcCycleCountBatchItem.setCycleCountBatch(arguments.cycleCountBatch);
							newcCycleCountBatchItem.setStock(stock);
							arguments.slatwallScope.saveEntity(newcCycleCountBatchItem);
						}
					}
				}
			}
		}

		return;
	}

}