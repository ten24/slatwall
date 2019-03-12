<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.auditTypeList" type="string" default="create,update,rollback,delete,archive" />
	<cfparam name="attributes.baseObjectList" type="string" default="" />
	<cfparam name="attributes.object" type="any" default="" />
	<cfparam name="attributes.recordsShow" type="string" default="10" />
	<cfparam name="attributes.auditSmartList" type="any" default="" />
	<cfparam name="attributes.auditCollectionList" type="any" default="" />
	
	<cfset thisTag.hibachiAuditService = attributes.hibachiScope.getService('HibachiAuditService') />
	<cfset thisTag.mode = "" />
	<cfset thisTag.auditArray = [] />
	<!--- AuditSmartList was passed in, so use as is --->
	<cfif isObject(attributes.auditSmartList)>
		<cfset thisTag.mode = "auditSmartList" />
		
	<!--- There is a specific entity, so use that entities auditSmartList --->
	<cfelseif isObject(attributes.object) && attributes.object.isPersistent()>
		<cfset thisTag.mode = "object" />
		<cfset attributes.auditCollectionList = attributes.object.getAuditCollectionList() />
		
	<!--- No AuditSmartList was pased in, and no object was passed in so just create a new auditSmartList --->
	<cfelse>
		<cfset thisTag.mode = "baseObjectList" />
		<cfset attributes.auditCollectionList = thisTag.hibachiAuditService.getAuditCollectionList() />
		
		<!--- Determine which base object types to display --->
		<cfif listLen(attributes.baseObjectList)>
			<cfset attributes.auditCollectionList.addFilter("baseObject", attributes.baseObjectList,'IN') />
		</cfif>
		
		<!--- Only add the orderBy here, because all other options would already have an orderBy defined --->
		<cfset attributes.auditCollectionList.setOrderBy("auditDateTime|DESC") />
	</cfif>
	
	<cfif listLen(attributes.auditTypeList)>
		<cfset attributes.auditCollectionList.addFilter("auditType", attributes.auditTypeList,'IN') />
	</cfif>
	
	<!---
		
		SELECT a FROM SlatwallAudit a INNER JOIN FETCH
		
	--->
	
	<!--- Display page or all --->
	<cfif isNumeric(attributes.recordsShow) and attributes.recordsShow gt 0>
		<cfset attributes.auditCollectionList.setPageRecordsShow(attributes.recordsShow) />
		<cfset thisTag.auditArray = attributes.auditCollectionList.getPageRecords() />
	<cfelse>
		<cfset thisTag.auditArray = attributes.auditCollectionList.getRecords() />
	</cfif>
	
	<cfset thisTag.columnCount = 5 />
	<cfoutput>
		<div class="table-responsive">	
			<table class="table table-bordered table-hover">
				<cfif arraylen(thisTag.auditArray)>
					<!--- Remove time for day comparison --->
					<cfset nowDate = createDate(year(now()), month(now()), day(now())) />
					
					<!--- Used for determining when to display date row for grouping --->
					<cfset dateGroupingUsageFlags = {today=false, yesterday=false, thisweek=false, thismonth=false} />
					
					<cfloop array="#thisTag.auditArray#" index="currentAudit">
						<!--- Remove time for day comparison --->
						<cfset auditDate = createDate(year(currentAudit['auditDateTime']), month(currentAudit['auditDateTime']), day(currentAudit['auditDateTime'])) />
						
						<cfset daysDiffNow = dateDiff('d', auditDate, nowDate) />
						<cfset monthDiffNow = dateDiff('m', auditDate, nowDate) />
						
						<cfset showTime = false />
						<cfset dateGroupUsageKey = "" />
						<cfset dateGroupText = "" />
						
						<!--- Group by today --->
						<cfif daysDiffNow eq 0>
							<cfset dateGroupUsageKey = "today" />
							<cfset dateGroupText = "Today, #dateFormat(auditDate, 'mmmm dd, yyyy')#" />
							<cfset showTime = true />
						<!--- Group by yesterday --->
						<cfelseif daysDiffNow eq 1>
							<cfset dateGroupUsageKey = "yesterday" />
							<cfset dateGroupText = "Yesterday, #dateFormat(auditDate, 'mmmm dd, yyyy')#" />
							<cfset showTime = true />
						<cfelse>
							<!--- Group by day of current month --->
							<cfif monthDiffNow eq 0>
								<cfset dateGroupUsageKey = "#dateFormat(auditDate, 'mmmddyyyy')#" />
								<cfset dateGroupText = "#dateFormat(auditDate, 'dddd, mmmm dd, yyyy')#" />
								<cfset showTime = true />
							<!--- Group by month --->
							<cfelse>
								<cfset dateGroupUsageKey = "#dateFormat(auditDate, 'mmmyyyy')#" />
								<cfset dateGroupText = "#dateFormat(auditDate, 'mmmm yyyy')#" />
							</cfif>
							<cfif not structKeyExists(dateGroupingUsageFlags, dateGroupUsageKey)>
								<cfset dateGroupingUsageFlags[dateGroupUsageKey] = false />
							</cfif>
						</cfif>
						
						<!--- Output the date row --->
						<cfif not dateGroupingUsageFlags[dateGroupUsageKey]>
							<thead>
								<!--- Determine which format to show --->
								<tr>
									<th colspan="3">#dateGroupText#</th>
								</tr>
							</thead>
							<cfset dateGroupingUsageFlags[dateGroupUsageKey] = true />
						</cfif>
						<tr>
							<cfset formattedAuditDateTime = attributes.hibachiScope.getService("hibachiUtilityService").formatValue(currentAudit['auditDateTime'],'time')/>
							
							<td style="white-space:nowrap;width:1%;"><cfif showTime>#formattedAuditDateTime#</cfif><cfif len(currentAudit['sessionAccountFullName'])> - #attributes.hibachiScope.getService("HibachiUtilityService").hibachiHTMLEditFormat(currentAudit['sessionAccountFullName'])#</cfif></td>
							<td class="primary">
								<cfif not listFindNoCase("login,loginInvalid,logout", currentAudit['auditType'])>
									#currentAudit['auditType']#<cfif thisTag.mode neq 'object'> #currentAudit['baseObject']# - </cfif>
									<cfif listFindNoCase("create,update,rollback,archive", currentAudit['auditType'])>
										<hb:HibachiActionCaller action="admin:entity.detail#currentAudit['baseObject']#" queryString="#currentAudit['baseObject']#ID=#currentAudit['baseID']#" text="#currentAudit['title']#" />
									<cfelse>
										#currentAudit['title']#
									</cfif>
									<br />
									<cfif listFindNoCase('update,rollback,archive', currentAudit['auditType']) or (currentAudit['auditType'] eq 'create' and thisTag.mode eq "object")>
										<em>#attributes.hibachiScope.rbKey("entity.audit.changeDetails.propertyChanged.#currentAudit['auditType']#")#: 
										<cfset data = deserializeJSON(currentAudit['data']) />
										<cfset indexCount = 0 />
										<cfloop collection="#data.newPropertyData#" item="propertyName">
											<cfset indexCount++ />
											<!--- propertyName is attribute --->
											<cfif !thisTag.hibachiAuditService.getEntityHasPropertyByEntityName(entityName=currentAudit['baseObject'], propertyName=propertyName) and attributes.hibachiScope.getService('hibachiService').getEntityHasAttributeByEntityName(entityName=currentAudit['baseObject'], attributeCode=propertyName)>
												<cfset attributeName = attributes.hibachiScope.getService('AttributeService').getAttributeNameByAttributeCode(propertyName) />
												<cfif len(attributeName)>
													#attributeName#<cfif indexCount neq structCount(data.newPropertyData)>,</cfif>
												<cfelse>
													#attributes.hibachiScope.rbKey("entity.#currentAudit['baseObject']#.#propertyName#")#<cfif indexCount neq structCount(data.newPropertyData)>,</cfif>
												</cfif>
											<!--- propertyName is entity property --->
											<cfelse>
												#attributes.hibachiScope.rbKey("entity.#currentAudit['baseObject']#.#propertyName#")#<cfif indexCount neq structCount(data.newPropertyData)>,</cfif>
											</cfif>
										</cfloop>
										</em>
									</cfif>
								<cfelse>
									#currentAudit['auditType']#<br/>
									#currentAudit['sessionAccountEmailAddress']# (#currentAudit['sessionIPAddress']#)
								</cfif>
							</td>
							<td class="admin admin1">
								<hb:HibachiActionCaller 
									action="admin:entity.preprocessaudit" 
									queryString="processContext=rollback&auditID=#currentAudit['auditID']#&redirectAction=admin:entity.detail#currentAudit['baseObject']#" class="btn btn-xs" modal="true" icon="eye-open" iconOnly="true" />
							</td>
						</tr>
					</cfloop>
					<cfif isObject(attributes.object) and attributes.object.hasProperty('createdDateTime') and attributes.object.getCreatedDateTime() lt attributes.auditCollectionList.getRecords()[arrayLen(attributes.auditCollectionList.getRecords())]['auditDateTime']>
						<tr><td colspan="#thisTag.columnCount#" style="text-align:center;"><em>#attributes.hibachiScope.rbKey("entity.audit.frontEndAndAdmin")#</em></td></tr>
					</cfif>
				<cfelseif isObject(attributes.object) and attributes.object.hasProperty('createdDateTime') and attributes.object.hasProperty('modifiedDateTime') and attributes.object.getCreatedDateTime() lt attributes.object.getModifiedDateTime()>
					<tr><td colspan="#thisTag.columnCount#" style="text-align:center;"><em>#attributes.hibachiScope.rbKey("entity.audit.frontEndOnly")#</em></td></tr>
				<cfelse>
					<tr><td colspan="#thisTag.columnCount#" style="text-align:center;"><em>#attributes.hibachiScope.rbKey("entity.audit.norecords")#</em></td></tr>
				</cfif>
			
			</table>
		</div>
	</cfoutput>
</cfif>