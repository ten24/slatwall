<cfcomponent extends="Slatwall.model.dao.OrderDAO">


    <cffunction name="placeOrdersInProcessingTwo" returntype="void" access="public">
        <cfargument name="data" />
        
        <cfset local.loggedinAccount = getHibachiScope().getAccount() />
        <cfset local.loggedinAccountID = len(local.loggedinAccount.getAccountID()) ? local.loggedinAccount.getAccountID() : 'NULL'  />
        <cfset local.loggedinAccountEmailAddress = len(local.loggedinAccount.getEmailAddress()) ? local.loggedinAccount.getEmailAddress() : 'NULL'  />
        <cfset local.loggedinAccountFullName = len(local.loggedinAccount.getFullName()) ? local.loggedinAccount.getFullName() : 'NULL'  />
        
        <cfset local.processing1Type = getHibachiScope().getService('typeService').getTypeByTypeCode('processing1') />
        <cfset local.processing2Type = getHibachiScope().getService('typeService').getTypeByTypeCode('processing2') />
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
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#getHibachiScope().getIPAddress()#" /> sessionIPAddress,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.loggedinAccountID#" /> sessionAccountID,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.loggedinAccountEmailAddress#" /> sessionAccountEmailAddress,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.loggedinAccountFullName#" />  sessionAccountFullName
                FROM swOrder o
                INNER JOIN swType t ON t.typeID = o.orderStatusTypeID AND t.typeCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.processing1Type.getTypeCode()#" />
                <cfif Len(local.siteID)>
                    INNER JOIN swSite s ON s.siteID = o.orderCreatedSiteID AND s.siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.siteID#" />
                </cfif>
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
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.loggedinAccountID#" /> createdByAccountID,
                    NOW() modifiedDateTime,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.loggedinAccountID#" /> modifiedByAccountID,
                    o.orderID orderID,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.processing2Type.getTypeID()#" /> orderStatusHistoryTypeID
                FROM swOrder o
                INNER JOIN swType t ON t.typeID = o.orderStatusTypeID AND t.typeCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.processing1Type.getTypeCode()#" />
                <cfif Len(local.siteID)>
                    INNER JOIN swSite s ON s.siteID = o.orderCreatedSiteID AND s.siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.siteID#" />
                </cfif>
	        </cfquery>
            
            
     		<cfquery name="local.updateOrdersStatus">
                Update swOrder 
                Set 
                    orderStatusTypeID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.processing2Type.getTypeID()#" />,
                    modifiedDateTime = NOW(),
                    modifiedByAccountID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.loggedinAccountID#" />
                WHERE 
                    orderStatusTypeID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.processing1Type.getTypeID()#" />
                <cfif Len(local.siteID)>
                    AND orderCreatedSiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.siteID#" />
                </cfif>
            </cfquery>
        
        </cftransaction>

	</cffunction>
	
	
	<cffunction name="setScheduleOrderProcessingFlag" access="public" returntype="void" output="false">
		<cfargument name="orderTemplateID" type="string" required="true" />
		<cfargument name="value" type="boolean" required="true" />

		<cfset var rs = "" />

		<cfquery name="rs">
			UPDATE SwOrderTemplate SET scheduleOrderProcessingFlag = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.value#" /> WHERE orderTemplateID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderTemplateID#" />
		</cfquery>
	</cffunction>
	
	
    <cfscript>
		public any function getMostRecentNotPlacedOrderByAccountID( required string accountID ) {
			return ormExecuteQuery(" FROM SlatwallOrder o WHERE o.account.accountID = :accountID AND o.orderStatusType.systemCode = :orderStatusType AND o.orderType.systemCode = :orderType AND o.orderCreatedSite.siteID = :requestSite ORDER BY modifiedDateTime DESC", 
			{accountID:arguments.accountID,orderStatusType:'ostNotPlaced',orderType:'otSalesOrder', requestSite:getHibachiScope().getCurrentRequestSite().getSiteID()}, true, {maxResults=1}
			);
		}	
	</cfscript>
	
	
</cfcomponent>