<cfcomponent extends="Slatwall.model.dao.OrderDAO">


    <cffunction name="placeOrdersInProcessingTwo" returntype="void" access="public">
        <cfargument name="data" />
        
        <cfset local.loggedinAccount = getHibachiScope().getAccount() />
        <cfset local.loggedinAccountID = len(local.loggedinAccount.getAccountID()) ? local.loggedinAccount.getAccountID() : 'NULL'  />
        <cfset local.loggedinAccountEmailAddress = len(local.loggedinAccount.getEmailAddress()) ? local.loggedinAccount.getEmailAddress() : 'NULL'  />
        <cfset local.loggedinAccountFullName = len(local.loggedinAccount.getFullName()) ? local.loggedinAccount.getFullName() : 'NULL'  />
        
        <cfset local.processing1Type = getHibachiScope().getService('typeService').getTypeByTypeCode('ostProcessing1') />
        <cfset local.processing2Type = getHibachiScope().getService('typeService').getTypeByTypeCode('ostProcessing2') />
        <cfset local.siteID = arguments.data.siteID ?: '' />
	    
	    <cftransaction>

     		<cfquery name="local.createAudits">
     		    INSERT INTO swaudit 
                    ( 
                        auditID, auditType, auditDateTime, baseObject, baseID, data, title, 
                        sessionIPAddress, sessionAccountID, sessionAccountEmailAddress, sessionAccountFullName
                    )
                SELECT 
                    LOWER(REPLACE(CAST(UUID() as char character set utf8), '-', '')) auditID,
                    'update' auditType,
                     NOW() auditDateTime,
                    'Order' baseObject,
                     o.orderID baseID,
                    CONCAT('{"newPropertyData":{"orderStatusType":{"typeID":"#local.processing2Type.getTypeID()#", "title":"#local.processing2Type.getTypename()#"}}, "oldPropertyData":{"orderStatusType": {"typeID": "',o.orderStatusTypeID,'","title": "',t.typeName,'"}}}') data,
                    'Order' title,
                    '#getHibachiScope().getIPAddress()#' sessionIPAddress,
                    '#local.loggedinAccountID#' sessionAccountID,
                    '#local.loggedinAccountEmailAddress#' sessionAccountEmailAddress,
                    '#local.loggedinAccountFullName#' sessionAccountFullName
                FROM swOrder o
                <cfif Len(local.siteID)>
                    WHERE o.orderCreatedSite.siteID = '#local.siteID#'
                </cfif>
                INNER JOIN swType t ON t.typeID = o.orderStatusTypeID AND t.typeCode = 'ostprocessing1'
            </cfquery>
                
                
     		<cfquery name="local.createOrderStatusHistories">
     		    INSERT INTO sworderstatushistory 
                    (
                    	orderStatusHistoryID, changeDateTime, effectiveDateTime, createdDateTime, 
                    	createdByAccountID, modifiedDateTime, modifiedByAccountID, orderID, orderStatusHistoryTypeID
                    )
                SELECT 
                    LOWER(REPLACE(CAST(UUID() as char character set utf8), '-', '')) orderStatusHistoryID,
                    NOW() changeDateTime,
                    NOW() effectiveDateTime,
                    NOW() createdDateTime,
                    '#local.loggedinAccountID#' createdByAccountID,
                    NOW() modifiedDateTime,
                    '#local.loggedinAccountID#' modifiedByAccountID,
                    o.orderID orderID,
                    '#local.processing2Type.getTypeID()#' orderStatusHistoryTypeID
                FROM swOrder o
                <cfif Len(local.siteID)>
                    WHERE o.orderCreatedSite.siteID = '#local.siteID#'
                </cfif>
                INNER JOIN swType t ON t.typeID = o.orderStatusTypeID AND t.typeCode = 'ostprocessing1'
	        </cfquery>
            
            
     		<cfquery name="local.updateOrdersStatus">
                Update swOrder 
                Set 
                    orderStatusTypeID = '#local.processing2Type.getTypeID()#',
                    modifiedDateTime = NOW(),
                    modifiedByAccountID = '#local.loggedinAccountID#'
                WHERE 
                    orderStatusTypeID = '#local.processing1Type.getTypeID()#'
                <cfif Len(local.siteID)>
                    AND o.orderCreatedSite.siteID = '#local.siteID#'
                </cfif>
            </cfquery>
        
        </cftransaction>

	</cffunction>
	
	
    <cfscript>
		public any function getMostRecentNotPlacedOrderByAccountID( required string accountID ) {
			return ormExecuteQuery(" FROM SlatwallOrder o WHERE o.account.accountID = :accountID AND o.orderStatusType.systemCode = :orderStatusType AND o.orderType.systemCode = :orderType AND o.orderCreatedSite.siteID = :requestSite ORDER BY modifiedDateTime DESC", 
			{accountID:arguments.accountID,orderStatusType:'ostNotPlaced',orderType:'otSalesOrder', requestSite:getHibachiScope().getCurrentRequestSite().getSiteID()}, true, {maxResults=1}
			);
		}	
	</cfscript>
	
</cfcomponent>