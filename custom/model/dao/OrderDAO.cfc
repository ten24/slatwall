component extends="Slatwall.model.dao.OrderDAO"{

	public any function getSkuIDByOrderItemRemoteID(required string OrderItemRemoteID){
		var skuIDSQL = 'SELECT DISTINCT(skuID) from sworderitem where remoteID = :OrderItemRemoteID';
		var OrderItemRemoteIDParams = {OrderItemRemoteID: arguments.OrderItemRemoteID};
			return queryExecute(skuIDSQL,OrderItemRemoteIDParams);
		}
}