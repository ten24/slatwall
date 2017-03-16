<cfcomponent accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerEntity" output="false">

<cffunction name="before" returntype="struct" access="public" output="false">
	<cfargument name="rc" type="struct" required="true" hint="Request-Context" />

	<cfif isNull(rc.$.slatwall.currentAccount()) OR NOT rc.$.slatwall.currentAccount().getSuperUserFlag()>
		<cfset getFW().redirect('s3:public.#getFW().getItem()#') />
	</cfif>
	<cfset super.before(argumentCollection=arguments) />

	<cfreturn rc />
</cffunction>


<cffunction name="listorder" returntype="struct" access="public" output="false">
	<cfargument name="rc" type="struct" required="true" hint="Request-Context" />

	<cfset genericListMethod(entityName='order',rc=arguments.rc) />

	<cfsavecontent variable="local.hql">
		SELECT o.orderID FROM SlatwallOrder AS o
			INNER JOIN o.orderDeliveries AS od
			INNER JOIN od.orderDeliveryItems AS odi
			INNER JOIN odi.orderItem AS oi
			INNER JOIN oi.sku AS s
			INNER JOIN s.product AS p
			INNER JOIN p.attributeValues AS av
			INNER JOIN av.attribute AS a
		WHERE a.attributeCode = :attributeCode
			AND (
				av.attributeValue = :attributeValueInteger
				OR av.attributeValue = :attributeValueBoolean
				OR av.attributeValue = :attributeValueString
			)
	</cfsavecontent>
	<cfset local.orderIDs = arrayToList(ormExecuteQuery(local.hql,{ attributeCode='s3IsEnabled', attributeValueInteger=1, attributeValueBoolean=true, attributeValueString='yes' })) />

	<cfif len(local.orderIDs)>
		<cfset rc.orderSmartList.addInFilter('orderID',local.orderIDs) />
	<cfelse>
		<cfset rc.orderSmartList.addWhereCondition('1=2') />
	</cfif>
	<cfset rc.orderSmartList.addOrder('orderOpenDateTime|DESC') />

	<cfreturn rc />
</cffunction>


<cffunction name="detailorder" returntype="struct" access="public" output="false">
	<cfargument name="rc" type="struct" required="true" hint="Request-Context" />

	<cfparam name="rc.orderId"	type="string"	default="" />

	<cfif NOT len(rc.orderId)>
		<cfset getFW().redirect('.listorder','all') />
	</cfif>

	<cfset genericDetailMethod(entityName='order',rc=arguments.rc) />
	<cfset genericListMethod(entityName='orderDeliveryItem',rc=arguments.rc) />

	<cfset rc.orderDeliveryItemSmartList.joinRelatedProperty('SlatwallOrderDeliveryItem','orderDelivery','inner') />
	<cfset rc.orderDeliveryItemSmartList.joinRelatedProperty('SlatwallOrderDelivery','Order','inner') />
	<cfset rc.orderDeliveryItemSmartList.addWhereCondition('aslatwallorder.orderID = :orderId',{ orderId=rc.orderId }) />
	<cfset rc.orderDeliveryItemSmartList.addOrder('createdDateTime|DESC') />

	<cfreturn rc />
</cffunction>

</cfcomponent>