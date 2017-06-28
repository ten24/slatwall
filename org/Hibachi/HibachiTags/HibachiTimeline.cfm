<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.auditTypeList" type="string" default="create,update,rollback,delete,archive" />
	<cfparam name="attributes.baseObjectList" type="string" default="" />
	<cfparam name="attributes.object" type="any" default="" />
	<cfparam name="attributes.recordsShow" type="string" default="10" />
	<cfparam name="attributes.auditSmartList" type="any" default="" />
	
	<cfset thisTag.hibachiAuditService = attributes.hibachiScope.getService('HibachiAuditService') />
	<cfset thisTag.mode = "" />
	<cfset thisTag.auditArray = [] />
	
	<!--- AuditSmartList was passed in, so use as is --->
	<cfif isObject(attributes.auditSmartList)>
		<cfset thisTag.mode = "auditSmartList" />
		
	<!--- There is a specific entity, so use that entities auditSmartList --->
	<cfelseif isObject(attributes.object) && attributes.object.isPersistent()>
		<cfset thisTag.mode = "object" />
		<cfset attributes.auditSmartList = attributes.object.getAuditSmartList() />
		
	<!--- No AuditSmartList was pased in, and no object was passed in so just create a new auditSmartList --->
	<cfelse>
		<cfset thisTag.mode = "baseObjectList" />
		<cfset attributes.auditSmartList = thisTag.hibachiAuditService.getAuditSmartList() />
		
		<!--- Determine which base object types to display --->
		<cfif listLen(attributes.baseObjectList)>
			<cfset attributes.auditSmartList.addInFilter("baseObject", attributes.baseObjectList) />
		</cfif>
		
		<!--- Only add the orderBy here, because all other options would already have an orderBy defined --->
		<cfset attributes.auditSmartList.addOrder("auditDateTime|DESC") />
	</cfif>
	
	<cfif listLen(attributes.auditTypeList)>
		<cfset attributes.auditSmartList.addInFilter("auditType", attributes.auditTypeList) />
	</cfif>
	
	<!---
		
		SELECT a FROM SlatwallAudit a INNER JOIN FETCH
		
	--->
	
	<!--- Display page or all --->
	<cfif isNumeric(attributes.recordsShow) and attributes.recordsShow gt 0>
		<cfset attributes.auditSmartList.setPageRecordsShow(attributes.recordsShow) />
		<cfset thisTag.auditArray = attributes.auditSmartList.getPageRecords() />
	<cfelse>
		<cfset thisTag.auditArray = attributes.auditSmartList.getRecords() />
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
						<cfset auditDate = createDate(year(currentAudit.getAuditDateTime()), month(currentAudit.getAuditDateTime()), day(currentAudit.getAuditDateTime())) />
						
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
							<td style="white-space:nowrap;width:1%;"><cfif showTime>#currentAudit.getFormattedValue("auditDateTime", "time")#</cfif><cfif len(currentAudit.getSessionAccountFullName())> - #attributes.hibachiScope.getService("HibachiUtilityService").hibachiHTMLEditFormat(currentAudit.getSessionAccountFullName())#</cfif></td>
							<td class="primary">
								<cfif not listFindNoCase("login,loginInvalid,logout", currentAudit.getAuditType())>
									#currentAudit.getFormattedValue('auditType')#<cfif thisTag.mode neq 'object'> #currentAudit.getBaseObject()# - </cfif>
									<cfif listFindNoCase("create,update,rollback,archive", currentAudit.getAuditType())>
										<hb:HibachiActionCaller action="admin:entity.detail#currentAudit.getBaseObject()#" queryString="#currentAudit.getBaseObject()#ID=#currentAudit.getBaseID()#" text="#currentAudit.getTitle()#" />
									<cfelse>
										#currentAudit.getTitle()#
									</cfif>
									<br />
									<cfif listFindNoCase('update,rollback,archive', currentAudit.getAuditType()) or (currentAudit.getAuditType() eq 'create' and thisTag.mode eq "object")>
										<em>#attributes.hibachiScope.rbKey("entity.audit.changeDetails.propertyChanged.#currentAudit.getAuditType()#")#: 
										<cfset data = deserializeJSON(currentAudit.getData()) />
										<cfset indexCount = 0 />
										<cfloop collection="#data.newPropertyData#" item="propertyName">
											<cfset indexCount++ />
											<!--- propertyName is attribute --->
											<cfif !thisTag.hibachiAuditService.getEntityHasPropertyByEntityName(entityName=currentAudit.getBaseObject(), propertyName=propertyName) and attributes.hibachiScope.getService('hibachiService').getEntityHasAttributeByEntityName(entityName=currentAudit.getBaseObject(), attributeCode=propertyName)>
												<cfset attributeName = attributes.hibachiScope.getService('AttributeService').getAttributeNameByAttributeCode(propertyName) />
												<cfif len(attributeName)>
													#attributeName#<cfif indexCount neq structCount(data.newPropertyData)>,</cfif>
												<cfelse>
													#attributes.hibachiScope.rbKey("entity.#currentAudit.getBaseObject()#.#propertyName#")#<cfif indexCount neq structCount(data.newPropertyData)>,</cfif>
												</cfif>
											<!--- propertyName is entity property --->
											<cfelse>
												#attributes.hibachiScope.rbKey("entity.#currentAudit.getBaseObject()#.#propertyName#")#<cfif indexCount neq structCount(data.newPropertyData)>,</cfif>
											</cfif>
										</cfloop>
										</em>
									</cfif>
								<cfelse>
									#currentAudit.getFormattedValue('auditType')#<br/>
									#currentAudit.getSessionAccountEmailAddress()# (#currentAudit.getSessionIPAddress()#)
								</cfif>
							</td>
							<td class="admin admin1">
								<hb:HibachiActionCaller action="admin:entity.preprocessaudit" queryString="processContext=rollback&#currentAudit.getPrimaryIDPropertyName()#=#currentAudit.getPrimaryIDValue()#&redirectAction=admin:entity.detail#currentAudit.getBaseObject()#" class="btn btn-xs" modal="true" icon="eye-open" iconOnly="true" />
							</td>
						</tr>
					</cfloop>
					<cfif isObject(attributes.object) and attributes.object.hasProperty('createdDateTime') and attributes.object.getCreatedDateTime() lt attributes.auditSmartList.getRecords()[arrayLen(attributes.auditSmartList.getRecords())].getAuditDateTime()>
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