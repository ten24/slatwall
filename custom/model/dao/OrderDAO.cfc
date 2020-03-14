<cfcomponent extends="Slatwall.model.dao.OrderDAO">


    <cffunction name="placeOrdersInProcessingTwo" returntype="void" access="public">
        <cfargument name="data" />
        
        <cfset local.processing1Type = getHibachiScope().getService('typeService').getTypeByTypeCode('ostProcessing1') />
        <cfset local.processing2Type = getHibachiScope().getService('typeService').getTypeByTypeCode('ostProcessing2') />
	    
	    <cftransaction action="begin" />

            <cfif getHibachiScope().getLoggedInFlag()>
                <cftry>
             		<cfquery name="local.createAudits">
             		    INSERT INTO swaudit 
                            ( 
                                auditID, auditType, auditDateTime, baseObject, baseID, data, title, 
                                sessionIPAddress, sessionAccountID, sessionAccountEmailAddress, sessionAccountFullName
                            )
                        SELECT 
                            LOWER(
                                REPLACE(CAST(UUID() as char character set utf8), '-', '')
                            ) auditID,
                            'update' auditType,
                             NOW() auditDateTime,
                            'Order' baseObject,
                             o.orderID baseID,
                            CONCAT('{"newPropertyData":{"orderStatusType":{"typeID":"#local.processing2Type.getTypeID()#", "title":"#local.processing2Type.getTypename()#"}}, "oldPropertyData":{"orderStatusType": {"typeID": "',o.orderStatusTypeID,'","title": "',t.typeName,'"}}}') data,
                            'Order' title,
                            '#getHibachiScope().getIPAddress()#' sessionIPAddress,
                            '#getHibachiScope().getAccount().getAccountID()#' sessionAccountID,
                            '#getHibachiScope().getAccount().getEmailAddress()#' sessionAccountEmailAddress,
                            '#getHibachiScope().getAccount().getFullName()#' sessionAccountFullName
                        FROM swOrder o
                        INNER JOIN swType t ON t.typeID = o.orderStatusTypeID AND t.typeCode = 'ostprocessing1';
                    </cfquery>
                    
                    <cfcatch >
                        <cftransaction action="rollback" />
                        <cflog file="Slatwall" text="ERROR IN QUERY - placeOrdersInProcessingTwo.createAudits  (#cfcatch.detail#)">
                    	<cfrethrow>
                    </cfcatch>
                </cftry>
            </cfif>
            
            <cftry>
         		<cfquery name="local.createOrderStatusHistories">
         		    INSERT INTO sworderstatushistory 
                    (
                    	orderStatusHistoryID, changeDateTime, effectiveDateTime, createdDateTime, modifiedDateTime, orderID, orderStatusHistoryTypeID
                    )
                    SELECT 
                    LOWER(REPLACE(CAST(UUID() as char character set utf8), '-', '')) orderStatusHistoryID,
                    NOW() changeDateTime,
                    NOW() effectiveDateTime,
                    NOW() createdDateTime,
                    NOW() modifiedDateTime,
                    o.orderID orderID,
                    '#local.processing2Type.getTypeID()#' orderStatusHistoryTypeID
                    from swOrder o
                    INNER JOIN swType t ON t.typeID = o.orderStatusTypeID AND t.typeCode = 'ostprocessing1'
    	        </cfquery>
                
                <cfcatch >
                    <cftransaction action="rollback" />
                    <cflog file="Slatwall" text="ERROR IN QUERY - placeOrdersInProcessingTwo.createOrderStatusHistories  (#cfcatch.detail#)">
                	<cfrethrow>
                </cfcatch>
            </cftry>
            
            <cftry>
         		<cfquery name="local.updateOrdersStatus">
                    Update swOrder 
                        Set orderStatusTypeID = '#local.processing2Type.getTypeID()#'
                        Where orderStatusTypeID = '#local.processing1Type.getTypeID()#'
                </cfquery>
                <cfcatch >
                    <cftransaction action="rollback" />
                    <cflog file="Slatwall" text="ERROR IN QUERY - placeOrdersInProcessingTwo.updateOrdersStatus  (#cfcatch.detail#)">
                	<cfrethrow>
                </cfcatch>
            </cftry>
            
            
            <cftransaction action="commit" />

	</cffunction>
	
	
    <cfscript>
		public any function getMostRecentNotPlacedOrderByAccountID( required string accountID ) {
			return ormExecuteQuery(" FROM SlatwallOrder o WHERE o.account.accountID = :accountID AND o.orderStatusType.systemCode = :orderStatusType AND o.orderType.systemCode = :orderType AND o.orderCreatedSite.siteID = :requestSite ORDER BY modifiedDateTime DESC", 
			{accountID:arguments.accountID,orderStatusType:'ostNotPlaced',orderType:'otSalesOrder', requestSite:getHibachiScope().getCurrentRequestSite().getSiteID()}, true, {maxResults=1}
			);
		}	
	</cfscript>
	
</cfcomponent>