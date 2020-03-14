<cfcomponent extends="Slatwall.model.dao.OrderDAO">

    <cfscript>
		public any function getMostRecentNotPlacedOrderByAccountID( required string accountID ) {
			return ormExecuteQuery(" FROM SlatwallOrder o WHERE o.account.accountID = :accountID AND o.orderStatusType.systemCode = :orderStatusType AND o.orderType.systemCode = :orderType AND o.orderCreatedSite.siteID = :requestSite ORDER BY modifiedDateTime DESC", 
			{accountID:arguments.accountID,orderStatusType:'ostNotPlaced',orderType:'otSalesOrder', requestSite:getHibachiScope().getCurrentRequestSite().getSiteID()}, true, {maxResults=1}
			);
		}	
	</cfscript>
	
</cfcomponent>