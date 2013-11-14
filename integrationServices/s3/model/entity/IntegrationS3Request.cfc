<cfcomponent displayName="S3Request" entityName="SlatwallIntegrationS3Request" table="SlatwallIntegrationS3Request" extends="Slatwall.org.Hibachi.HibachiEntity" persistent="true" accessors="true">

<cfproperty name="s3RequestID" ormType="string" length="32" fieldType="id" generator="uuid" unsavedValue="" default="" />

<cfproperty name="createdDateTime"	ormType="timestamp" />
<cfproperty name="userAgent"		ormType="string"	length="250" />
<cfproperty name="remoteIP"			ormType="string"	length="25" />
<cfproperty name="takeIntoAccountForRequestLimiting"	ormType="boolean"	notNull="true"	default="true"	dbDefault="1" />

<cfproperty name="createdByAccount"		cfc="Account"						fieldType="many-to-one"	fkColumn="createdByAccountID" />
<cfproperty name="orderDeliveryItem"	cfc="OrderDeliveryItem"	fieldType="many-to-one"	fkColumn="orderDeliveryItemID" />


<cffunction name="cachePath" returnType="string" access="public">
	<cfset local.path = '' />

	<cfif NOT isNull(getOrderDeliveryItem())>
		<cfset local.path = '#getTempDirectory()#s3-#lCase(hash(fileName()))#' />
	</cfif>

	<cfreturn local.path />
</cffunction>


<cffunction name="fileName" returnType="string" access="public">
	<cfset local.fileName = '' />

	<cfif NOT isNull(getOrderDeliveryItem())>
		<cfif len(getOrderDeliveryItem().getOrderItem().getSku().getProduct().getAttributeValue('s3Filename'))>
			<cfset local.fileName = getOrderDeliveryItem().getOrderItem().getSku().getProduct().getAttributeValue('s3Filename') />
		<cfelse>
			<cfset local.fileName = getOrderDeliveryItem().getOrderItem().getSku().getProduct().getProductId() />
		</cfif>
	</cfif>

	<cfreturn local.fileName />
</cffunction>

</cfcomponent>