<cfcomponent extends="Slatwall.integrationServices.BaseIntegration" output="false" hint="Amazon S3 Slatwall v3 eventHandler">

<cffunction name="afterOrderDeliverySaveSuccess" returnType="any" access="public">
	<cfargument name="slatwallScope"	type="any"		required="true" />
	<cfargument name="entity"			type="any"		required="true" />
	<cfargument name="eventName"		type="string"	required="true" />

	<cfset logHibachi('EventHandler Execution: Slatwall.integrationServices.s3.eventHandler: #arguments.eventName#') />

	<cfset local.orderDelivery = arguments.entity />

	<cfif hasAnyS3DeliveryItem(local.orderDelivery)>
		<cfset local.eventTrigger = getBeanFactory().getBean('eventTriggerService').getEventTriggerByRemoteID(lCase(hash('s3:afterOrderDeliverySaveSuccess'))) />

		<cfif NOT isNull(local.eventTrigger) AND NOT isNull(local.eventTrigger.getEmailTemplate())>
			<cfset local.emailService = getBeanFactory().getBean('emailService') />

			<cfset local.email = local.emailService.newEmail() />
			<cfset local.email.setLogEmailFlag(yesNoFormat(setting('logOrderDeliveryEmails'))) />

			<cfset local.emailData = {
				emailTemplateID = local.eventTrigger.getEmailTemplate().getEmailTemplateID(),
				orderDeliveryID = local.orderDelivery.getOrderDeliveryId()
			} />

			<cfset local.email = local.emailService.processEmail(local.email,local.emailData,'createFromTemplate') />
			<cfset local.emailService.processEmail(local.email,{},'addToQueue') />

			<cfset getBeanFactory().getBean('hibachiDAO').flushORMSession() />
		</cfif>
	</cfif>
</cffunction>


<cffunction name="afterEmailProcess_addToQueueSuccess" returnType="void" access="public" output="false">
	<cfargument name="slatwallScope"	type="any"		required="true" />
	<cfargument name="entity"			type="any"		required="true" />
	<cfargument name="eventName"		type="string"	required="true" />
	<cfargument name="data"				type="struct"	required="true" />

	<cfif structKeyExists(arguments.data,'orderDeliveryId')>
		<cfset local.orderDelivery = entityLoadByPk('SlatwallOrderDelivery',arguments.data.orderDeliveryId) />

		<cfif NOT isNull(local.orderDelivery) AND hasAnyS3DeliveryItem(local.orderDelivery)>
			<cfset local.orderDeliveryItemIds = arrayNew(1) />
			
			<cfloop array="#local.orderDelivery.getOrderDeliveryItems()#" index="local.orderDeliveryItem">
				<cfset arrayAppend(local.orderDeliveryItemIds,local.orderDeliveryItem.getOrderDeliveryItemID()) />
			</cfloop>
			
			<cfsavecontent variable="local.hql">	<!--- get all S3 requests for orderDeliveryItems --->
				SELECT s3r.s3RequestID FROM SlatwallIntegrationS3Request AS s3r
					INNER JOIN s3r.orderDeliveryItem AS odi
				WHERE odi.orderDeliveryItemID IN ( :orderDeliveryItemIds )
			</cfsavecontent>
			<cfset local.s3RequestIds = ormExecuteQuery(local.hql,{ orderDeliveryItemIds=local.orderDeliveryItemIds }) />

			<cfif arrayLen(local.s3RequestIds)>
				<cfsavecontent variable="local.hql">
					UPDATE SlatwallIntegrationS3Request AS s3r
						SET s3r.takeIntoAccountForRequestLimiting = :takeIntoAccountForRequestLimiting
					WHERE s3r.s3RequestID IN ( :s3RequestIds )
				</cfsavecontent>
				<cfset ormExecuteQuery(local.hql,{ takeIntoAccountForRequestLimiting=false,s3RequestIds=local.s3RequestIds }) />
			</cfif>
		</cfif>
	</cfif>
</cffunction>


<cffunction name="setting" returnType="any" access="private">
	<cfargument name="settingName"		type="string"		required="true" />
	<cfargument name="filterEntities"	type="array"		required="false"	default="#arrayNew(1)#" />
	<cfargument name="formatValue"		type="boolean"	required="false"	default="false" />

	<cfset local.integrationService	= getBeanFactory().getBean('integrationService') />
	<cfset local.settingService		= getBeanFactory().getBean('settingService') />

	<cfif structKeyExists(local.integrationService.getIntegrationByIntegrationPackage('s3').getIntegrationCFC().getSettings(),arguments.settingName)>
		<cfreturn local.settingService.getSettingValue(settingName='integrations3#arguments.settingName#',object=this,filterEntities=arguments.filterEntities,formatValue=arguments.formatValue) />
	</cfif>
</cffunction>


<cffunction name="hasAnyS3DeliveryItem" returnType="boolean" access="private" output="false">
	<cfargument name="orderDelivery" type="any" required="true" />
	
	<cfset local.has = false />
	
	<cfif arguments.orderDelivery.hasOrderDeliveryItem()>
		<cfloop array="#arguments.orderDelivery.getOrderDeliveryItems()#" index="local.orderDeliveryItem">
			<cfset local.product = local.orderDeliveryItem.getOrderItem().getSku().getProduct() />

			<cfif yesNoFormat(local.product.getAttributeValue('s3IsEnabled'))>
				<cfset local.has = true />
				<cfbreak />
			</cfif>
		</cfloop>
	</cfif>
	
	<cfreturn local.has />
</cffunction>

</cfcomponent>