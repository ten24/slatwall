<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

--->
<cfcomponent extends="HibachiDAO">

	<cffunction name="getUniquePreviousSubscriptionOrderPayments">
		<cfargument name="subscriptionUsageID" type="string" required="true" />

		<cfreturn ormExecuteQuery("SELECT DISTINCT op FROM SlatwallSubscriptionOrderItem soi INNER JOIN soi.orderItem oi INNER JOIN oi.order o INNER JOIN o.orderPayments op WHERE soi.subscriptionUsage.subscriptionUsageID = :subscriptionUsageID AND op.referencedOrderPayment IS NULL AND op.orderPaymentStatusType.systemCode = 'opstActive'", {subscriptionUsageID=arguments.subscriptionUsageID}) />
	</cffunction>

	<cffunction name="getSubscriptionCurrentStatus">
		<cfargument name="subscriptionUsageID" type="string" required="true" />

		<cfset var hql = "FROM SlatwallSubscriptionStatus ss
							WHERE ss.subscriptionUsage.subscriptionUsageID = :subscriptionUsageID
							AND ss.effectiveDateTime <= :now
							ORDER BY ss.effectiveDateTime DESC " />


		<cfreturn ormExecuteQuery(hql, {subscriptionUsageID=arguments.subscriptionUsageID, now=now()}, true, {maxresults=1}) />
	</cffunction>

	<cffunction name="getSubscriptionUsageForRenewal">

		<cfset var getsu = "" />
		<!--- can't figure out top 1 hql so, doing query: Sumit --->
		<cfif getApplicationValue("databaseType") eq "MySQL">
			<cfquery name="getsu">
				SELECT DISTINCT su.subscriptionUsageID
				FROM SwSubsUsage su
				WHERE (su.nextBillDate <= <cfqueryparam value="#dateformat(now(),'mm-dd-yyyy 23:59')#" cfsqltype="cf_sql_timestamp" />)
					AND 'sstActive' = (SELECT systemCode FROM SwSubscriptionStatus
								INNER JOIN SwType ON SwSubscriptionStatus.subscriptionStatusTypeID = SwType.typeID
								WHERE SwSubscriptionStatus.subscriptionUsageID = su.subscriptionUsageID
								AND SwSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
								ORDER BY changeDateTime DESC LIMIT 1)
			</cfquery>
		<cfelseif getApplicationValue("databaseType") eq "Oracle10g">
			<cfquery name="getsu">
				SELECT DISTINCT su.subscriptionUsageID
				FROM SwSubsUsage su
				WHERE (su.nextBillDate <= <cfqueryparam value="#dateformat(now(),'mm-dd-yyyy 23:59')#" cfsqltype="cf_sql_timestamp" />)
					AND 'sstActive' = (SELECT systemcode FROM (SELECT systemCode,subscriptionUsageID FROM SwSubscriptionStatus
				                    INNER JOIN SwType ON SwSubscriptionStatus.subscriptionStatusTypeID = SwType.typeID
				                    WHERE SwSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
				                    ORDER BY changeDateTime DESC)
									WHERE subscriptionUsageID = su.subscriptionUsageID
				                    AND rownum <= 1)
			</cfquery>
		<cfelse>
			<cfquery name="getsu">
				SELECT DISTINCT su.subscriptionUsageID
				FROM SwSubsUsage su
				WHERE (su.nextBillDate <= <cfqueryparam value="#dateformat(now(),'mm-dd-yyyy 23:59')#" cfsqltype="cf_sql_timestamp" />)
					AND 'sstActive' = (SELECT TOP 1 systemCode FROM SwSubscriptionStatus
								INNER JOIN SwType ON SwSubscriptionStatus.subscriptionStatusTypeID = SwType.typeID
								WHERE SwSubscriptionStatus.subscriptionUsageID = su.subscriptionUsageID
								AND SwSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
								ORDER BY changeDateTime DESC)
			</cfquery>
		</cfif>

		<cfif getsu.recordCount>
			<cfset var hql = "FROM SlatwallSubscriptionUsage WHERE subscriptionUsageID IN (:subscriptionUsageIDs)" />

			<cfreturn ormExecuteQuery(hql, {subscriptionUsageIDs=listToArray(valueList(getsu.subscriptionUsageID))}) />
		</cfif>
		<cfreturn [] />

	</cffunction>

	<cffunction name="getSubscriptionUsageForRenewalReminder">

		<cfset var getsu = "" />
		<!--- can't figure out top 1 hql so, doing query: Sumit --->
		<cfif getApplicationValue("databaseType") eq "MySQL">
			<cfquery name="getsu">
				SELECT DISTINCT su.subscriptionUsageID
				FROM SwSubsUsage su
				WHERE (su.nextReminderEmailDate <= <cfqueryparam value="#dateformat(now(),'mm-dd-yyyy 23:59')#" cfsqltype="cf_sql_timestamp" />)
					AND 'sstActive' = (SELECT systemCode FROM SwSubscriptionStatus
								INNER JOIN SwType ON SwSubscriptionStatus.subscriptionStatusTypeID = SwType.typeID
								WHERE SwSubscriptionStatus.subscriptionUsageID = su.subscriptionUsageID
								AND SwSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
								ORDER BY changeDateTime DESC LIMIT 1)
			</cfquery>
		<cfelseif getApplicationValue("databaseType") eq "Oracle10g">
			<cfquery name="getsu">
				SELECT DISTINCT su.subscriptionUsageID
				FROM SwSubsUsage su
				WHERE (su.nextReminderEmailDate <= <cfqueryparam value="#dateformat(now(),'mm-dd-yyyy 23:59')#" cfsqltype="cf_sql_timestamp" />)
					AND 'sstActive' = (SELECT systemcode FROM (SELECT systemCode,subscriptionUsageID FROM SwSubscriptionStatus
				                    INNER JOIN SwType ON SwSubscriptionStatus.subscriptionStatusTypeID = SwType.typeID
				                    WHERE SwSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
				                    ORDER BY changeDateTime DESC)
									WHERE subscriptionUsageID = su.subscriptionUsageID
				                    AND rownum <= 1)
			</cfquery>
		<cfelse>
			<cfquery name="getsu">
				SELECT DISTINCT su.subscriptionUsageID
				FROM SwSubsUsage su
				WHERE (su.nextReminderEmailDate <= <cfqueryparam value="#dateformat(now(),'mm-dd-yyyy 23:59')#" cfsqltype="cf_sql_timestamp" />)
					AND 'sstActive' = (SELECT TOP 1 systemCode FROM SwSubscriptionStatus
								INNER JOIN SwType ON SwSubscriptionStatus.subscriptionStatusTypeID = SwType.typeID
								WHERE SwSubscriptionStatus.subscriptionUsageID = su.subscriptionUsageID
								AND SwSubscriptionStatus.effectiveDateTime <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
								ORDER BY changeDateTime DESC)
			</cfquery>
		</cfif>

		<cfif getsu.recordCount>
			<cfset var hql = "FROM SlatwallSubscriptionUsage WHERE subscriptionUsageID IN (:subscriptionUsageIDs)" />

			<cfreturn ormExecuteQuery(hql, {subscriptionUsageIDs=listToArray(valueList(getsu.subscriptionUsageID))}) />
		</cfif>
		<cfreturn [] />

	</cffunction>

	<cffunction name="getUnusedProductSubscriptionTerms">
		<cfargument name="productID" required="true" type="string" />

		<cfset var hql = "SELECT new map(st.subscriptionTermName as name, st.subscriptionTermID as value)
			FROM
				SlatwallSubscriptionTerm st
			WHERE
				st.subscriptionTermID NOT IN (SELECT skust.subscriptionTermID FROM SlatwallSku sku INNER JOIN sku.subscriptionTerm skust INNER JOIN sku.product skup WHERE skup.productID = :productID)" />

		<cfreturn ormExecuteQuery(hql, {productID=arguments.productID}) />
	</cffunction>
	
	<cffunction name="getSubscriptionOrderItemByOrderItemID">
		<cfargument name="orderItemID" type="string" required="true"/>
		<cfreturn ORMExecuteQuery('SELECT soi FROM SlatwallSubscriptionOrderItem soi where soi.orderItem.orderItemID=:orderItemID',{orderItemID=arguments.orderItemID},true)/>
	</cffunction>
	
	<cffunction name="getDeferredActiveSubscriptionData">
		<cfargument name="subscriptionTypeSystemCode" type="string"/>
		<cfargument name="productTypeID" type="string"/>
		<cfargument name="productID" type="string"/>
		<cfargument name="minDate" type="date"/>
		<cfargument name="maxDate" type="date"/>
		
		<cfquery name="local.deferredActiveSubscriptionQuery">
			
			<cfset var from = Month(arguments.minDate)-1/>
			<cfset var diff = DateDiff('m',createDateTime(Year(arguments.minDate),Month(arguments.minDate),1,0,0,0),createDateTime(Year(arguments.maxDate),Month(arguments.maxDate),DaysInMonth(arguments.maxDate),0,0,0))/>
			<cfset var to = from + diff/>
			<cfset var startYear = Year(arguments.minDate)/>
			select * FROM (
			<cfloop from="#from#" to="#to#" index="local.i">
				<cfif i % 12 eq 0 and i neq 0>
					<cfset startYear++/>
				</cfif>
				
				<cfset var beginningOfMonthTimeStamp = CreateDateTime(startYear,i%12+1,1,0,0,0)/>
				<cfset var endOfMonthTimeStamp = CreateDateTime(startYear,i%12+1,DaysInMonth(beginningOfMonthTimeStamp),0,0,0)/>
				(
					select count(distinct su.subscriptionUsageID) as subscriptionUsageCount,DATE_FORMAT(<cfqueryparam value="#beginningOfMonthTimeStamp#" cfsqltype="cf_sql_timestamp"/>,'%Y-%M') as thisMonth
					FROM SwSubsUsage su 
					inner join SwSubscriptionStatus ss on su.currentSubscriptionStatusID = ss.subscriptionStatusID
					inner join SwSubscriptionOrderItem soi on su.subscriptionUsageID = soi.subscriptionUsageID
					inner join SwType t on soi.subscriptionOrderItemTypeID = t.typeID
					inner join SwOrderItem oi on oi.orderItemID = soi.orderItemID
					inner join SwSku s on s.skuID = oi.skuID
					inner join SwProduct p on p.productID = s.productID
					inner join SwProductType pt on pt.productTypeID = p.productTypeID
					where ss.subscriptionStatusTypeID = (Select typeID from swType where systemCode = 'sstActive')
					<cfif !isNull(arguments.subscriptionTypeSystemCode) AND len(arguments.subscriptionTypeSystemCode)>
						AND t.systemCode IN (<cfqueryparam value="#arguments.subscriptionTypeSystemCode#" cfsqltype="cf_sql_string" list="YES"/>)
					</cfif>
					<cfif !isNull(arguments.productTypeID) AND len(arguments.productTypeID)>
						AND pt.productTypeID IN (<cfqueryparam value="#arguments.productTypeID#" cfsqltype="cf_sql_string" list="YES"/>)
					</cfif>
					<cfif !isNull(arguments.productID) AND len(arguments.productID)>
						AND p.productID IN (<cfqueryparam value="#arguments.productID#" cfsqltype="cf_sql_string" list="YES"/>)
					</cfif>
					
					AND su.expirationDate >= <cfqueryparam value="#endOfMonthTimeStamp#" cfsqltype="cf_sql_timestamp"/>
					and ss.effectiveDateTime <= <cfqueryparam value="#endOfMonthTimeStamp#" cfsqltype="cf_sql_timestamp"/>
					group by DATE_FORMAT(<cfqueryparam value="#beginningOfMonthTimeStamp#" cfsqltype="cf_sql_timestamp"/>,'%Y-%M')
				)
				<cfif i neq to>
					UNION ALL
				</cfif>
				
			</cfloop>
			) t1
			ORDER BY STR_TO_DATE(thisMonth,'%Y-%M')
		</cfquery>
		<cfreturn local.deferredActiveSubscriptionQuery/>
	</cffunction>
	
	<cffunction name="getDeferredExpiringSubscriptionData">
		<cfargument name="subscriptionTypeSystemCode" type="string"/>
		<cfargument name="productTypeID" type="string"/>
		<cfargument name="productID" type="string"/>
		<cfargument name="minDate" type="date"/>
		<cfargument name="maxDate" type="date"/>
		
		<cfquery name="local.deferredExpiringSubscriptionQuery">
			select count(distinct su.subscriptionUsageID) as subscriptionUsageCount,DATE_FORMAT(su.expirationDate,'%Y-%M') as thisMonth
			FROM SwSubsUsage su 
			inner join SwSubscriptionStatus ss on su.currentSubscriptionStatusID = ss.subscriptionStatusID
			inner join SwSubscriptionOrderItem soi on su.subscriptionUsageID = soi.subscriptionUsageID
			inner join SwType t on soi.subscriptionOrderItemTypeID = t.typeID
			inner join SwOrderItem oi on oi.orderItemID = soi.orderItemID
			inner join SwSku s on s.skuID = oi.skuID
			inner join SwProduct p on p.productID = s.productID
			inner join SwProductType pt on pt.productTypeID = p.productTypeID
			where ss.subscriptionStatusTypeID = (Select typeID from swType where systemCode = 'sstActive')
			
			<cfif !isNull(arguments.subscriptionTypeSystemCode) AND len(arguments.subscriptionTypeSystemCode)>
				AND t.systemCode IN (<cfqueryparam value="#arguments.subscriptionTypeSystemCode#" cfsqltype="cf_sql_string" list="YES"/>)
			</cfif>
			<cfif !isNull(arguments.productTypeID) AND len(arguments.productTypeID)>
				AND pt.productTypeID IN (<cfqueryparam value="#arguments.productTypeID#" cfsqltype="cf_sql_string" list="YES"/>)
			</cfif>
			<cfif !isNull(arguments.productID) AND len(arguments.productID)>
				AND p.productID IN (<cfqueryparam value="#arguments.productID#" cfsqltype="cf_sql_string" list="YES"/>)
			</cfif>
			
			<cfif !isNull(arguments.minDate) AND !isNull(arguments.maxDate)>
				AND su.expirationDate >= <cfqueryparam value="#CreateDateTime(Year(arguments.minDate),Month(arguments.minDate),1,0,0,0)#" cfsqltype="cf_sql_timestamp"/>
				AND su.expirationDate <= <cfqueryparam value="#CreateDateTime(Year(arguments.maxDate),Month(arguments.maxDate),DaysInMonth(arguments.maxDate),23,59,59)#" cfsqltype="cf_sql_timestamp"/>
			</cfif>
			
			group by DATE_FORMAT(su.expirationDate,'%Y-%M')
			ORDER BY STR_TO_DATE(thisMonth,'%Y-%M')
		</cfquery>
		<cfreturn local.deferredExpiringSubscriptionQuery/>
	</cffunction>
	
	<cffunction name="getDeferredRevenueLeftToBeRecognizedData" access="public" returntype="any">
		<cfargument name="subscriptionTypeSystemCode" type="string"/>
		<cfargument name="productTypeID" type="string"/>
		<cfargument name="productID" type="string"/>
		<cfargument name="minDate" type="date"/>
		<cfargument name="maxDate" type="date"/>
		
		<cfset var monthbegin = createDateTime(Year(arguments.minDate),Month(arguments.minDate),DaysInMonth(arguments.minDate),0,0,0)/>
    	<cfset var monthend = createDateTime(Year(arguments.maxDate),Month(arguments.maxDate),DaysInMonth(arguments.maxDate),23,59,59)/>
		<cfset var monthcount = DateDiff('m',monthbegin,monthend)/> 
		
		<cfset var currentRecordsCount = 0/>
		<cfquery name="local.deferredRevenueLeftToBeRecognizedQuery">
			select * FROM(
			<cfloop from="0" to="#monthcount#" index="local.i">
				<cfset currentRecordsCount++/>
				<cfset var currentMonth = DATEADD('m',i,monthbegin)/>
				<!---total or orderitems--->
				
				select COALESCE(
					COALESCE((
						select Sum(oi.calculatedExtendedPrice) from swSubsUsage su
						inner join SwSubscriptionStatus ss on su.currentSubscriptionStatusID = ss.subscriptionStatusID
						inner join SwSubscriptionOrderItem soi on su.subscriptionUsageID = soi.subscriptionUsageID
						inner join SwType t on soi.subscriptionOrderItemTypeID = t.typeID
						inner join SwOrderItem oi on oi.orderItemID = soi.orderItemID
						inner join SwSku s on s.skuID = oi.skuID
						inner join SwProduct p on p.productID = s.productID
						inner join SwProductType pt on pt.productTypeID = p.productTypeID
						where ss.subscriptionStatusTypeID = (Select typeID from swType where systemCode = 'sstActive')
						<cfif !isNull(arguments.subscriptionTypeSystemCode) AND len(arguments.subscriptionTypeSystemCode)>
							AND t.systemCode IN (<cfqueryparam value="#arguments.subscriptionTypeSystemCode#" cfsqltype="cf_sql_string" list="YES"/>)
						</cfif>
						<cfif !isNull(arguments.productTypeID) AND len(arguments.productTypeID)>
							AND pt.productTypeID IN (<cfqueryparam value="#arguments.productTypeID#" cfsqltype="cf_sql_string" list="YES"/>)
						</cfif>
						<cfif !isNull(arguments.productID) AND len(arguments.productID)>
							AND p.productID IN (<cfqueryparam value="#arguments.productID#" cfsqltype="cf_sql_string" list="YES"/>)
						</cfif>
						and ss.effectiveDateTime <= <cfqueryparam value="#currentMonth#" cfsqltype="cf_sql_timestamp"/>
						and p.deferredRevenueFlag=1
					),0) -
					<!---total of currently earned --->
					COALESCE((
					
						select SUM(sodi.earned) from swSubscriptionOrderDeliveryItem sodi
						inner join SwSubscriptionOrderItem soi on sodi.subscriptionOrderItemID= soi.subscriptionOrderItemID
						inner join SwSubsUsage su on su.subscriptionUsageID = soi.subscriptionUsageID
						inner join SwSubscriptionStatus ss on su.currentSubscriptionStatusID = ss.subscriptionStatusID
						inner join SwType t on soi.subscriptionOrderItemTypeID = t.typeID
						inner join SwOrderItem oi on oi.orderItemID = soi.orderItemID
						inner join SwSku s on s.skuID = oi.skuID
						inner join SwProduct p on p.productID = s.productID
						inner join SwProductType pt on pt.productTypeID = p.productTypeID
						where ss.subscriptionStatusTypeID = (Select typeID from swType where systemCode = 'sstActive')
						<cfif !isNull(arguments.subscriptionTypeSystemCode) AND len(arguments.subscriptionTypeSystemCode)>
							AND t.systemCode IN (<cfqueryparam value="#arguments.subscriptionTypeSystemCode#" cfsqltype="cf_sql_string" list="YES"/>)
						</cfif>
						<cfif !isNull(arguments.productTypeID) AND len(arguments.productTypeID)>
							AND pt.productTypeID IN (<cfqueryparam value="#arguments.productTypeID#" cfsqltype="cf_sql_string" list="YES"/>)
						</cfif>
						<cfif !isNull(arguments.productID) AND len(arguments.productID)>
							AND p.productID IN (<cfqueryparam value="#arguments.productID#" cfsqltype="cf_sql_string" list="YES"/>)
						</cfif>
						and sodi.createdDateTime < <cfqueryparam value="#currentMonth#" cfsqltype="cf_sql_timestamp"/>
					),0)
				,0) as deferredRevenueLeftToBeRecognized,
				COALESCE(
					COALESCE((
						select Sum(oi.calculatedTaxAmount) from swSubsUsage su
						inner join SwSubscriptionStatus ss on su.currentSubscriptionStatusID = ss.subscriptionStatusID
						inner join SwSubscriptionOrderItem soi on su.subscriptionUsageID = soi.subscriptionUsageID
						inner join SwType t on soi.subscriptionOrderItemTypeID = t.typeID
						inner join SwOrderItem oi on oi.orderItemID = soi.orderItemID
						inner join SwSku s on s.skuID = oi.skuID
						inner join SwProduct p on p.productID = s.productID
						inner join SwProductType pt on pt.productTypeID = p.productTypeID
						where ss.subscriptionStatusTypeID = (Select typeID from swType where systemCode = 'sstActive')
						<cfif !isNull(arguments.subscriptionTypeSystemCode) AND len(arguments.subscriptionTypeSystemCode)>
							AND t.systemCode IN (<cfqueryparam value="#arguments.subscriptionTypeSystemCode#" cfsqltype="cf_sql_string" list="YES"/>)
						</cfif>
						<cfif !isNull(arguments.productTypeID) AND len(arguments.productTypeID)>
							AND pt.productTypeID IN (<cfqueryparam value="#arguments.productTypeID#" cfsqltype="cf_sql_string" list="YES"/>)
						</cfif>
						<cfif !isNull(arguments.productID) AND len(arguments.productID)>
							AND p.productID IN (<cfqueryparam value="#arguments.productID#" cfsqltype="cf_sql_string" list="YES"/>)
						</cfif>
						and ss.effectiveDateTime <= <cfqueryparam value="#currentMonth#" cfsqltype="cf_sql_timestamp"/>
						and p.deferredRevenueFlag=1
					),0) -
					<!---total of currently earned --->
					COALESCE((
					
						select SUM(sodi.taxAmount) from swSubscriptionOrderDeliveryItem sodi
						inner join SwSubscriptionOrderItem soi on sodi.subscriptionOrderItemID= soi.subscriptionOrderItemID
						inner join SwSubsUsage su on su.subscriptionUsageID = soi.subscriptionUsageID
						inner join SwSubscriptionStatus ss on su.currentSubscriptionStatusID = ss.subscriptionStatusID
						inner join SwType t on soi.subscriptionOrderItemTypeID = t.typeID
						inner join SwOrderItem oi on oi.orderItemID = soi.orderItemID
						inner join SwSku s on s.skuID = oi.skuID
						inner join SwProduct p on p.productID = s.productID
						inner join SwProductType pt on pt.productTypeID = p.productTypeID
						where ss.subscriptionStatusTypeID = (Select typeID from swType where systemCode = 'sstActive')
						<cfif !isNull(arguments.subscriptionTypeSystemCode) AND len(arguments.subscriptionTypeSystemCode)>
							AND t.systemCode IN (<cfqueryparam value="#arguments.subscriptionTypeSystemCode#" cfsqltype="cf_sql_string" list="YES"/>)
						</cfif>
						<cfif !isNull(arguments.productTypeID) AND len(arguments.productTypeID)>
							AND pt.productTypeID IN (<cfqueryparam value="#arguments.productTypeID#" cfsqltype="cf_sql_string" list="YES"/>)
						</cfif>
						<cfif !isNull(arguments.productID) AND len(arguments.productID)>
							AND p.productID IN (<cfqueryparam value="#arguments.productID#" cfsqltype="cf_sql_string" list="YES"/>)
						</cfif>
						and sodi.createdDateTime < <cfqueryparam value="#currentMonth#" cfsqltype="cf_sql_timestamp"/>
					),0)
				,0) as deferredTaxLeftToBeRecognized,
				DATE_FORMAT(#currentMonth#,'%Y-%M') as thisMonth
				<cfif i neq monthcount>
					UNION ALL 
				</cfif>
				
			</cfloop>
			) t1
			ORDER BY STR_TO_DATE(thisMonth,'%Y-%M')
		</cfquery>
		<cfreturn local.deferredRevenueLeftToBeRecognizedQuery>
	</cffunction>
	
	<cffunction name="getDeferredRevenueData" access="public" returntype="any">
		<cfargument name="subscriptionTypeSystemCode" type="string"/>
		<cfargument name="productTypeID" type="string"/>
		<cfargument name="productID" type="string"/>
		<cfargument name="minDate" type="date"/>
		<cfargument name="maxDate" type="date"/>
		
		<cfif DateCompare(arguments.minDate,now()) neq 1>
			<cfset arguments.minDate = now()/>
		</cfif>
		
		
		<cfquery name="local.subscriptionOrderItemQuery">
			select 
			    soi.subscriptionOrderItemID, 
			    st.itemsToDeliver-COALESCE(Sum(sodi.quantity),0) as totalItemToDeliver, 
			    (oi.calculatedExtendedPrice/st.itemsToDeliver) as pricePerDelivery, 
			    (oi.calculatedTaxAmount/st.itemsToDeliver) as taxPerDelivery
			FROM swSubscriptionOrderItem soi
			inner join SwType t on t.typeID = soi.subscriptionOrderItemTypeID
			left join SwSubscriptionOrderDeliveryItem sodi on sodi.subscriptionOrderItemID = soi.subscriptionOrderItemID
			inner join SwSubsUsage su on su.subscriptionUsageID = soi.subscriptionUsageID
			inner join SwSubscriptionTerm st on su.subscriptionTermID = st.subscriptionTermID
			inner join SwSubscriptionStatus ss on su.currentSubscriptionStatusID = ss.subscriptionStatusID
			inner join swOrderItem oi on soi.orderItemID = oi.orderItemID
			inner join swOrder o on o.orderID = oi.orderID
			inner join swSku s on s.skuID = oi.skuID
			inner join swProduct p on p.productID = s.productID
			inner join swproducttype pt on pt.productTypeID = p.productTypeID
			where ss.subscriptionStatusTypeID = (Select typeID from swType where systemCode = 'sstActive')
			and p.deferredRevenueFlag = 1
			and (select COALESCE(SUM(sodi2.quantity),0) FROM swSubscriptionOrderDeliveryItem sodi2 where sodi2.subscriptionOrderItemID = soi.subscriptionOrderItemID) < st.itemsToDeliver
			<cfif !isNull(arguments.subscriptionTypeSystemCode) AND len(arguments.subscriptionTypeSystemCode)>
				AND t.systemCode IN (<cfqueryparam value="#arguments.subscriptionTypeSystemCode#" cfsqltype="cf_sql_string" list="YES"/>)
			</cfif>
			<cfif !isNull(arguments.productTypeID) AND len(arguments.productTypeID)>
				AND pt.productTypeID IN (<cfqueryparam value="#arguments.productTypeID#" cfsqltype="cf_sql_string" list="YES"/>)
			</cfif>
			<cfif !isNull(arguments.productID) AND len(arguments.productID)>
				AND p.productID IN (<cfqueryparam value="#arguments.productID#" cfsqltype="cf_sql_string" list="YES"/>)
			</cfif>
			
			<cfif !isNull(arguments.minDate) AND !isNull(arguments.maxDate)>
				AND su.expirationDate >= <cfqueryparam value="#CreateDateTime(Year(arguments.minDate),Month(arguments.minDate),Day(arguments.minDate),0,0,0)#" cfsqltype="cf_sql_timestamp"/>
				
			</cfif>
			group by soi.subscriptionOrderItemID
		</cfquery>
		<cfset var currentRecordsCount = 0/>
		<cfif local.subscriptionOrderItemQuery.recordCount>
			<cfquery name="local.deferredRevenueQuery">
				select thisMonth,SUM(pricePerDelivery) as deferredRevenue,SUM(taxPerDelivery) as deferredTax from (
					<cfloop query="local.subscriptionOrderItemQuery">
						<cfset currentRecordsCount++/>	
							(
								SELECT DATE_FORMAT(dsd.deliveryScheduleDateValue,'%Y-%M') as thisMonth, 
								'#local.subscriptionOrderItemQuery.pricePerDelivery#' as pricePerDelivery,
								'#local.subscriptionOrderItemQuery.taxPerDelivery#' as taxPerDelivery
								FROM swDeliveryScheduleDate dsd
								inner join swProduct p on p.productID = dsd.productID
								inner join swSku s on s.productID = p.productID
								inner join swOrderItem oi on oi.skuID = s.skuID
								inner join swSubscriptionOrderItem soi on soi.subscriptionOrderItemID = '#local.subscriptionOrderItemQuery.subscriptionOrderItemID#'
								inner join swsubsusage su on su.subscriptionusageID = soi.subscriptionusageID
								where dsd.deliveryScheduleDateValue > <cfqueryparam value="#arguments.minDate#" cfsqltype="cf_sql_timestamp"/>
								and su.expirationDate > dsd.deliveryScheduleDateValue
								GROUP BY DATE_FORMAT(dsd.deliveryScheduleDateValue,'%Y-%M')
								ORDER BY dsd.deliveryScheduleDateValue ASC
								limit #local.subscriptionOrderItemQuery.totalItemToDeliver#
							)
							<cfif local.subscriptionOrderItemQuery.recordCount neq currentRecordsCount>
								UNION ALL 
							</cfif>
					</cfloop>
				) t1
				GROUP BY thisMonth
				ORDER BY STR_TO_DATE(thisMonth,'%Y-%M')
			</cfquery>
			
			<cfreturn local.deferredRevenueQuery/>
		</cfif>
	</cffunction>

</cfcomponent>
