<cfcomponent accessors="true" extends="Slatwall.org.Hibachi.HibachiService" persistent="false" output="false">

<cfproperty name="integrationService" />
<cfproperty name="settingService" />
<cfproperty name="hibachiEventService" />
<cfproperty name="hibachiDAO" />


<cffunction name="newIntegrationS3RequestFromOrderDeliveryItem" returnType="any" access="public">
	<cfargument name="orderDeliveryItem" type="any" required="true" />

	<cfset local.product		= arguments.orderDeliveryItem.getOrderItem().getSku().getProduct() />
	<cfset local.s3FilePath	= 's3://#setting("accessKeyId")#:#setting("awsSecretKey")#@#setting("bucketName")#/#local.product.getAttributeValue('s3Filename')#' />

	<cfif yesNoFormat(local.product.getAttributeValue('s3IsEnabled'))
		AND len(local.product.getAttributeValue('s3Filename'))
		AND isTimeFrameBetweenDownloadsAcceptable(arguments.orderDeliveryItem)>

		<cfif isLimitDownloadTimeFrameExceeded(arguments.orderDeliveryItem)>
			<cfset getHibachiEventService().announceEvent('integrationS3DownloadTimeFrameLimitExceeded',{ orderDeliveryItem=arguments.orderDeliveryItem }) />

		<cfelseif isLimitDownloadAttemptsExceeded(arguments.orderDeliveryItem)>
			<cfset getHibachiEventService().announceEvent('integrationS3DownloadAttemptLimitExceeded',{ orderDeliveryItem=arguments.orderDeliveryItem }) />

		<cfelse>
			<cfset local.integrationS3Request = this.newIntegrationS3Request() />
			<cfset local.integrationS3Request.setOrderDeliveryItem(arguments.orderDeliveryItem) />
			<cfset local.integrationS3Request.setUserAgent(cgi.http_user_agent) />
			<cfset local.integrationS3Request.setRemoteIP(cgi.remote_addr) />

			<cfif NOT fileExists(local.integrationS3Request.cachePath()) AND NOT fileExists(local.s3FilePath)>
				<cfset logHibachi('Amazon S3: File Not Found For Download: s3://#chr(35)#setting("accessKeyId")#chr(35)#:#chr(35)#setting("awsSecretKey")#chr(35)#@#setting("bucketName")#/#local.product.getAttributeValue('s3Filename')#') />

			<cfelse>
				<cfif NOT fileExists(local.integrationS3Request.cachePath())>
					<cfset local.s3Success = false />

					<cfloop condition="NOT local.s3Success">
						<cftry>
							<cffile action="readBinary" file="#local.s3FilePath#" variable="local.s3BinaryFileContent" />
							<cffile action="write" file="#local.integrationS3Request.cachePath()#" output="#local.s3BinaryFileContent#" />
							<cfset local.s3Success = true />

							<cfcatch type="any">
								<cfset logHibachiException(cfcatch) />
								<cfset sleep(1200) />
							</cfcatch>
						</cftry>
					</cfloop>
				</cfif>

				<cfset this.saveIntegrationS3Request(local.integrationS3Request) />
				<cfset getHibachiDAO().flushORMSession() />

				<cfreturn local.integrationS3Request />
			</cfif>
		</cfif>
	</cfif>
</cffunction>


<cffunction name="listIntegrationS3RequestByOrderDelivery" returnType="array" access="public">
	<cfargument name="orderDelivery" type="any" required="true" />

	<cfset local.orderDeliveryItemIDs = arrayNew(1) />
	<cfloop array="#arguments.orderDelivery.getOrderDeliveryItems()#" index="local.orderDeliveryItem">
		<cfset arrayAppend(local.orderDeliveryItemIDs,local.orderDeliveryItem.getOrderDeliveryItemId()) />
	</cfloop>

	<cfsavecontent variable="local.hql">
		SELECT s3r FROM SlatwallIntegrationS3Request AS s3r
			LEFT JOIN s3r.orderDeliveryItem AS odi
		WHERE odi.orderDeliveryItemID IN (:orderDeliveryItemIDs)
		ORDER BY s3r.createdDateTime DESC
	</cfsavecontent>

	<cfreturn ormExecuteQuery(local.hql,{ orderDeliveryItemIDs=local.orderDeliveryItemIDs }) />
</cffunction>


<cffunction name="isTimeFrameBetweenDownloadsAcceptable" returnType="boolean" access="public">
	<cfargument name="orderDeliveryItem" type="any" required="true" />

	<cfsavecontent variable="local.hql">
		SELECT s3r.createdDateTime FROM SlatwallIntegrationS3Request AS s3r
			INNER JOIN s3r.orderDeliveryItem AS odi
		WHERE odi.orderDeliveryItemID = :orderDeliveryItemID
		ORDER BY s3r.createdDateTime DESC
	</cfsavecontent>
	<cfset local.createdDateTime = ormExecuteQuery(local.hql,{ orderDeliveryItemID=arguments.orderDeliveryItem.getOrderDeliveryItemID() },{ maxResults=1 }) />

	<cfreturn arrayIsEmpty(local.createdDateTime) OR dateDiff('s',local.createdDateTime[1],now()) GT 5 />
</cffunction>


<cffunction name="isLimitDownloadAttemptsExceeded" returnType="boolean" access="public">
	<cfargument name="orderDeliveryItem" type="any" required="true" />

	<cfset local.limitExceeded					= false />
	<cfset local.limitDownloadAttempts	= setting('limitDownloadAttempts') />

	<cfif isNumeric(local.limitDownloadAttempts) AND local.limitDownloadAttempts GT 0>
		<cfsavecontent variable="local.hql">
			SELECT COUNT(*) FROM SlatwallIntegrationS3Request AS s3r
				INNER JOIN s3r.orderDeliveryItem AS odi
			WHERE odi.orderDeliveryItemID = :orderDeliveryItemID
		</cfsavecontent>
		<cfset local.requestCount = ormExecuteQuery(local.hql,{ orderDeliveryItemID=arguments.orderDeliveryItem.getOrderDeliveryItemID() },true) />

		<cfset local.limitExceeded = local.requestCount GTE local.limitDownloadAttempts />
	</cfif>

	<cfreturn local.limitExceeded />
</cffunction>


<cffunction name="isLimitDownloadTimeFrameExceeded" returnType="boolean" access="public">
	<cfargument name="orderDeliveryItem" type="any" required="true" />

	<cfset local.limitExceeded					= false />
	<cfset local.limitDownloadTimeFrame	= setting('limitDownloadAttempts') />

	<cfif isNumeric(local.limitDownloadTimeFrame) AND local.limitDownloadTimeFrame GT 0 AND NOT isNull(arguments.orderDeliveryItem.getOrderDelivery().getOrder().getOrderCloseDateTime())>
		<cfset local.limitExceeded = dateAdd('d',local.limitDownloadTimeFrame,arguments.orderDeliveryItem.getOrderDelivery().getOrder().getOrderCloseDateTime()) LT now() />
	</cfif>

	<cfreturn local.limitExceeded />
</cffunction>


<cffunction name="cleanTempDirectory" returnType="void" access="public" output="false">
	<cfset local.tempListing		= directoryList(getTempDirectory(),false,'query','s3-*') />
	<cfset local.cleanOlderThan	= dateAdd('d',-1,now()) />

	<cfloop query="#local.tempListing#">
		<cfif local.tempListing.dateLastModified[local.tempListing.currentRow] LT local.cleanOlderThan>
			<cfset fileDelete('#local.tempListing.directory[local.tempListing.currentRow]#/#local.tempListing.name[local.tempListing.currentRow]#') />
		</cfif>
	</cfloop>
</cffunction>


<cffunction name="setting" returnType="any" access="private">
	<cfargument name="settingName"		type="string"		required="true" />
	<cfargument name="filterEntities"	type="array"		required="false"	default="#arrayNew(1)#" />
	<cfargument name="formatValue"		type="boolean"	required="false"	default="false" />

	<cfset local.integrationService	= getBeanFactory().getBean('integrationService') />
	<cfset local.settingService			= getBeanFactory().getBean('settingService') />

	<cfif structKeyExists(getIntegrationService().getIntegrationByIntegrationPackage('s3').getIntegrationCFC().getSettings(),arguments.settingName)>
		<cfreturn getSettingService().getSettingValue(settingName='integrations3#arguments.settingName#',object=this,filterEntities=arguments.filterEntities,formatValue=arguments.formatValue) />
	</cfif>
</cffunction>

</cfcomponent>