<cfcomponent extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" output="false" hint="Amazon S3 Slatwall v3 Integration">

<cffunction name="init" returnType="any" access="public">
	<cfset verifyBeanFactory() />
	<cfset verifyTemplates() />
	<cfset verifyEntitiesMetaData() />
	<cfset verifyAttributeSets() />
	<cfset verifyAttributes() />
	<cfset verifyEmailTemplates() />
	<cfset verifyEventTriggers() />

	<cfset variables.eventHandlers = [
		'Slatwall.integrationServices.s3.eventHandler'
	] />

	<cfreturn this />
</cffunction>


<cffunction name="getIntegrationTypes" returnType="string" access="public">
	<cfreturn 'fw1' />
</cffunction>


<cffunction name="getDisplayName" returnType="string" access="public">
	<cfreturn 'Amazon S3' />
</cffunction>


<cffunction name="getSettings" returnType="struct" access="public">
	<cfreturn {
		accessKeyId							= { fieldType='text' },
		awsSecretKey						= { fieldType='text' },
		bucketName							= { fieldType='text' },
		limitDownloadAttempts		= { fieldType='text',defaultValue=0 },
		limitDownloadTimeFrame	= { fieldType='text',defaultValue=0 },
		logOrderDeliveryEmails	= { fieldType='yesno',defaultValue=0 }
	} />
</cffunction>


<cffunction name="getAttributeSets" returnType="array" access="public">
	<cfreturn [
		{
			attributeSetName='Amazon S3',
			attributeSetCode='s3Product',
			attributeSetType={
				systemCode='astProduct'
			}
		}
	] />
</cffunction>


<cffunction name="getAttributes" returnType="array" access="public">
	<cfreturn [
		{
			attributeName='Filename',
			attributeCode='s3Filename',
			attributeSet={
				attributeSetCode='s3Product'
			},
			attributeType={
				systemCode='atText'
			}
		},{
			attributeName='S3 download active',
			attributeCode='s3IsEnabled',
			attributeSet={
				attributeSetCode='s3Product'
			},
			attributeType={
				systemCode='atYesNo'
			}
		}
	] />
</cffunction>


<cffunction name="getEventHandlers" returnType="array" access="public">
	<cfreturn variables.eventHandlers />
</cffunction>


<cffunction name="verifyBeanFactory" returnType="void" access="public">
	<cfset getBeanFactory().declareBean('integrationS3RequestService','Slatwall.integrationServices.s3.model.service.IntegrationS3RequestService') />
</cffunction>


<cffunction name="verifyTemplates" returnType="void" access="public">
	<cfset getBeanFactory().getBean('hibachiUtilityService').duplicateDirectory('#getDirectoryFromPath(getCurrentTemplatePath())#templates',expandPath('/Slatwall/custom/templates')) />
</cffunction>


<cffunction name="verifyEntitiesMetaData" returnType="void" access="public">
	<cfset local.hibachiService = getBeanFactory().getBean('hibachiService') />

	<cfset local.hibachiService._inject = variables.helperInject />
	<cfset local.hibachiService._inject('_appendEntitiesMetaData',variables.helperAppendEntitiesMetaData) />

	<cfset local.hibachiService._appendEntitiesMetaData(expandPath('/Slatwall/integrationServices/s3/model/entity'),'Slatwall.integrationServices.s3.model.entity') />
</cffunction>


<cffunction name="verifyAttributeSets" returnType="void" access="public">
	<cfset local.hibachiService				= getBeanFactory().getBean('hibachiService') />
	<cfset local.attributeSetService	= local.hibachiService.getServiceByEntityName('attributeSet') />

	<cfloop array="#getAttributeSets()#" index="local.attributeSetItem">
		<cfset local.attributeSet = local.attributeSetService.getAttributeSet(local.attributeSetItem.attributeSetCode) />
		<cfif isNull(local.attributeSet)>
			<cfset local.attributeSet = local.attributeSetService.newAttributeSet() />
		</cfif>

		<cfset local.attributeSet.populate(local.attributeSetItem) />
		<cfset local.attributeSet.setAttributeSetType(local.attributeSetService.getType(local.attributeSetItem.attributeSetType)) />

		<cfset local.attributeSetService.saveAttributeSet(local.attributeSet) />
	</cfloop>

	<cfset getBeanFactory().getBean('hibachiDAO').flushORMSession() />
</cffunction>


<cffunction name="verifyAttributes" returnType="void" access="public">
	<cfset local.hibachiService		= getBeanFactory().getBean('hibachiService') />
	<cfset local.attributeService	= local.hibachiService.getServiceByEntityName('attribute') />

	<cfloop array="#getAttributes()#" index="local.attributeItem">
		<cfset local.attribute = local.attributeService.getAttributeByAttributeCode(local.attributeItem.attributeCode) />
		<cfif isNull(local.attribute)>
			<cfset local.attribute = local.attributeService.newAttribute() />
		</cfif>
		<cfset local.attribute.populate(local.attributeItem) />

		<cfset local.attribute.setAttributeSet(local.attributeService.getAttributeSet(local.attributeItem.attributeSet)) />
		<cfset local.attribute.setAttributeType(local.attributeService.getType(local.attributeItem.attributeType)) />

		<cfset local.attributeService.saveAttribute(local.attribute) />
	</cfloop>

	<cfset getBeanFactory().getBean('hibachiDAO').flushORMSession() />
</cffunction>


<cffunction name="verifyEmailTemplates" returnType="void" access="public">
	<cfset local.hibachiService					= getBeanFactory().getBean('hibachiService') />
	<cfset local.emailTemplateRemoteID	= lCase(hash('s3:DownloadURL')) />
	<cfset local.emailTemplateService		= local.hibachiService.getServiceByEntityName('emailTemplate') />

	<cfset local.emailTemplate = local.emailTemplateService.getEmailTemplateByRemoteID(local.emailTemplateRemoteID) />

	<cfif isNull(local.emailTemplate)>
		<cfset local.emailTemplate = local.emailTemplateService.newEmailTemplate() />

		<cfset local.emailTemplate.setRemoteID(local.emailTemplateRemoteID) />
		<cfset local.emailTemplate.setEmailTemplateName('Amazon S3 Download URL Template') />
		<cfset local.emailTemplate.setEmailTemplateObject('OrderDelivery') />
		<cfset local.emailTemplate.setEmailTemplateFile('AmazonS3.cfm') />
		<cfset local.emailTemplateService.saveEmailTemplate(local.emailTemplate) />

		<cfset getBeanFactory().getBean('hibachiDAO').flushORMSession() />
	</cfif>
</cffunction>


<cffunction name="verifyEventTriggers" returnType="void" access="public">
	<cfset local.hibachiService				= getBeanFactory().getBean('hibachiService') />
	<cfset local.eventTriggerRemoteID	= lCase(hash('s3:afterOrderDeliverySaveSuccess')) />
	<cfset local.eventTriggerService	= local.hibachiService.getServiceByEntityName('eventTrigger') />

	<cfset local.eventTrigger = local.eventTriggerService.getEventTriggerByRemoteID(local.eventTriggerRemoteID) />

	<cfif isNull(local.eventTrigger)>
		<cfset local.eventTrigger = local.eventTriggerService.newEventTrigger() />

		<cfset local.eventTrigger.setRemoteID(local.eventTriggerRemoteID) />
		<cfset local.eventTrigger.setEventTriggerName('Amazon S3 Send E-Mail With Download URLs') />
		<cfset local.eventTrigger.setEventTriggerType('email') />
		<cfset local.eventTrigger.setEventTriggerObject('OrderDelivery') />
		<cfset local.eventTrigger.setEventName('afterOrderDeliverySaveSuccess') />
		<cfset local.eventTrigger.setEmailTemplate(local.hibachiService.getServiceByEntityName('emailTemplate').getEmailTemplateByRemoteID(lCase(hash('s3:DownloadURL')))) />
		<cfset local.eventTriggerService.saveEventTrigger(local.eventTrigger) />

		<cfset getBeanFactory().getBean('hibachiDAO').flushORMSession() />
	</cfif>
</cffunction>


<cffunction name="helperInject" returnType="void" access="private">
	<cfargument name="methodName"		type="string"	required="true" />
	<cfargument name="methodObject"	type="any"		required="true" />

	<cfset variables[arguments.methodName] = arguments.methodObject />
	<cfset this[arguments.methodName] = arguments.methodObject />
</cffunction>


<cffunction name="helperAppendEntitiesMetaData" returnType="void" access="private">
	<cfargument name="filePath"		type="string"	required="true" />
	<cfargument name="classPath"	type="string"	required="true" />

	<cfset local.entityDirectoryArray = directoryList(arguments.filePath) />

	<cfloop array="#local.entityDirectoryArray#" index="local.entityFile">
		<cfif listLast(local.entityFile,'.') EQ 'cfc'>
			<cfset local.entityShortName	= listFirst(listLast(replace(local.entityFile,'\','/','all'),'/'),'.') />
			<cfset local.entityMetaData		= createObject('component','#arguments.classPath#.#local.entityShortName#').getThisMetaData() />

			<cfif structKeyExists(local.entityMetaData,'persistent') AND local.entityMetaData.persistent>
				<cfset variables.entitiesMetaData[local.entityShortName] = local.entityMetaData />
			</cfif>
		</cfif>
	</cfloop>
</cffunction>

</cfcomponent>