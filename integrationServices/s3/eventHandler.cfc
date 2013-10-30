<cfcomponent extends="Slatwall.integrationServices.BaseIntegration" output="false" hint="Amazon S3 Slatwall v3 eventHandler">

<cffunction name="afterOrderDeliverySaveSuccess" returnType="any" access="public">
	<cfargument name="slatwallScope"	type="any"		required="true" />
	<cfargument name="entity"					type="any"		required="true" />
	<cfargument name="eventName"			type="string"	required="true" />

	<cfset logHibachi('EventHandler Execution: Slatwall.integrationServices.s3.eventHandler: #arguments.eventName#') />

	<cfset local.hasAnyS3DeliveryItem	= false />
	<cfset local.orderDelivery				= arguments.entity />

	<cfif local.orderDelivery.hasOrderDeliveryItem()>
		<cfloop array="#local.orderDelivery.getOrderDeliveryItems()#" index="local.orderDeliveryItem">
			<cfset local.product = local.orderDeliveryItem.getOrderItem().getSku().getProduct() />

			<cfif yesNoFormat(local.product.getAttributeValue('s3IsEnabled'))>
				<cfset local.hasAnyS3DeliveryItem = true />
				<cfbreak />
			</cfif>
		</cfloop>
	</cfif>

	<cfif local.hasAnyS3DeliveryItem>
		<cfset local.eventTrigger = getBeanFactory().getBean('eventTriggerService').getEventTriggerByRemoteID(lCase(hash('s3:afterOrderDeliverySaveSuccess'))) />

		<cfif NOT isNull(local.eventTrigger) AND NOT isNull(local.eventTrigger.getEmailTemplate())>
			<cfset local.emailService	= getBeanFactory().getBean('emailService') />

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


<cffunction name="setting" returnType="any" access="private">
	<cfargument name="settingName"		type="string"		required="true" />
	<cfargument name="filterEntities"	type="array"		required="false"	default="#arrayNew(1)#" />
	<cfargument name="formatValue"		type="boolean"	required="false"	default="false" />

	<cfset local.integrationService	= getBeanFactory().getBean('integrationService') />
	<cfset local.settingService			= getBeanFactory().getBean('settingService') />

	<cfif structKeyExists(local.integrationService.getIntegrationByIntegrationPackage('s3').getIntegrationCFC().getSettings(),arguments.settingName)>
		<cfreturn local.settingService.getSettingValue(settingName='integrations3#arguments.settingName#',object=this,filterEntities=arguments.filterEntities,formatValue=arguments.formatValue) />
	</cfif>
</cffunction>

</cfcomponent>