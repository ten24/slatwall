<cfif thisTag.executionMode eq "end">
	<!--- Implicit --->
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />	
	
	<!--- Required --->
	<cfparam name="attributes.smartList" type="any" />
	<cfparam name="attributes.edit" type="boolean" default="#request.context.edit#" />
	
	<!--- Admin Actions --->
	<cfparam name="attributes.recordEditAction" type="string" default="" />
	<cfparam name="attributes.recordEditQueryString" type="string" default="" />
	<cfparam name="attributes.recordEditModal" type="boolean" default="false" />
	<cfparam name="attributes.recordEditDisabled" type="boolean" default="false" />
	<cfparam name="attributes.recordDetailAction" type="string" default="" />
	<cfparam name="attributes.recordDetailQueryString" type="string" default="" />
	<cfparam name="attributes.recordDetailModal" type="boolean" default="false" />
	<cfparam name="attributes.recordDeleteAction" type="string" default="" />
	<cfparam name="attributes.recordDeleteQueryString" type="string" default="" />
	<cfparam name="attributes.recordProcessAction" type="string" default="" />
	<cfparam name="attributes.recordProcessQueryString" type="string" default="" />
	<cfparam name="attributes.recordProcessContext" type="string" default="" />
	<cfparam name="attributes.recordProcessEntity" type="any" default="" />
	<cfparam name="attributes.recordProcessUpdateTableID" type="any" default="" />
	<cfparam name="attributes.recordProcessButtonDisplayFlag" type="any" default="true" />
	
	<!--- Hierarchy Expandable --->
	<cfparam name="attributes.parentPropertyName" type="string" default="" />  <!--- Setting this value will turn on Expandable --->
	
	<!--- Sorting --->
	<cfparam name="attributes.sortProperty" type="string" default="" />  			<!--- Setting this value will turn on Sorting --->
	<cfparam name="attributes.sortContextIDColumn" type="string" default="" />  		
	<cfparam name="attributes.sortContextIDValue" type="string" default="" />  					
	
	<!--- Single Select --->
	<cfparam name="attributes.selectFieldName" type="string" default="" />			<!--- Setting this value will turn on single Select --->
	<cfparam name="attributes.selectValue" type="string" default="" />
	<cfparam name="attributes.selectTitle" type="string" default="" />
	
	<!--- Multiselect --->
	<cfparam name="attributes.multiselectFieldName" type="string" default="" />		<!--- Setting this value will turn on Multiselect --->
	<cfparam name="attributes.multiselectPropertyIdentifier" type="string" default="" />	<!--- This is used for the show selected / all --->
	<cfparam name="attributes.multiselectValues" type="string" default="" />
	
	<!--- Helper / Additional / Custom --->
	<cfparam name="attributes.tableattributes" type="string" default="" />  <!--- Pass in additional html attributes for the table --->
	<cfparam name="attributes.tableclass" type="string" default="" />  <!--- Pass in additional classes for the table --->	
	<cfparam name="attributes.adminattributes" type="string" default="" />
	
	<!--- ThisTag Variables used just inside --->
	<cfparam name="thistag.columns" type="array" default="#arrayNew(1)#" />
	<cfparam name="thistag.allpropertyidentifiers" type="string" default="" />
	<cfparam name="thistag.allprocessobjectproperties" type="string" default="" />
	<cfparam name="thistag.selectable" type="string" default="false" />
	<cfparam name="thistag.multiselectable" type="string" default="false" />
	<cfparam name="thistag.expandable" type="string" default="false" />
	<cfparam name="thistag.sortable" type="string" default="false" />
	<cfparam name="thistag.exampleEntity" type="string" default="" />

	<cfsilent>
		<cfif isSimpleValue(attributes.smartList)>
			<cfset attributes.smartList = attributes.hibachiScope.getService("hibachiService").getServiceByEntityName( attributes.smartList ).invokeMethod("get#attributes.smartList#SmartList") />
		</cfif>
		
		<!--- Setup the example entity --->
		<cfset thistag.exampleEntity = entityNew(attributes.smartList.getBaseEntityName()) />
		
		<!--- Setup the default table class --->
		<cfset attributes.tableclass = listPrepend(attributes.tableclass, 'table table-striped table-bordered table-condensed', ' ') />
		
		<!--- Setup Select --->
		<cfif len(attributes.selectFieldName)>
			<cfset thistag.selectable = true />
			
			<cfset attributes.tableclass = listAppend(attributes.tableclass, 'table-select', ' ') />
			<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-selectfield="#attributes.selectFieldName#"', " ") />
		</cfif>
		
		<!--- Setup Multiselect --->
		<cfif len(attributes.multiselectFieldName)>
			<cfset thistag.multiselectable = true />
			
			<cfset attributes.tableclass = listAppend(attributes.tableclass, 'table-multiselect', ' ') />
			<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-multiselectfield="#attributes.multiselectFieldName#"', " ") />
			<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-multiselectpropertyidentifier="#attributes.multiselectPropertyIdentifier#"', " ") />
		</cfif>
		<cfif thistag.multiselectable and not arrayLen(thistag.columns) >
			<cfif thistag.exampleEntity.hasProperty('activeFlag')>
				<cfset attributes.smartList.addFilter("activeFlag", 1) />
			</cfif>
		</cfif>
		
		<!--- Look for Hierarchy in example entity --->
		<cfif not len(attributes.parentPropertyName)>
			<cfset thistag.entityMetaData = getMetaData(thisTag.exampleEntity) />
			<cfif structKeyExists(thisTag.entityMetaData, "hb_parentPropertyName")>
				<cfset attributes.parentPropertyName = thisTag.entityMetaData.hb_parentPropertyName />
			</cfif>
		</cfif>
		
		<!--- Setup Hierarchy Expandable --->
		<cfif len(attributes.parentPropertyName)>
			<cfset thistag.expandable = true />
			
			<cfset attributes.tableclass = listAppend(attributes.tableclass, 'table-expandable', ' ') />
			
			<cfset attributes.smartList.joinRelatedProperty( attributes.smartList.getBaseEntityName() , attributes.parentPropertyName, "LEFT") />
			<cfset attributes.smartList.addFilter("#attributes.parentPropertyName#.#thistag.exampleEntity.getPrimaryIDPropertyName()#", "NULL") />
			
			<cfset thistag.allpropertyidentifiers = listAppend(thistag.allpropertyidentifiers, "#thisTag.exampleEntity.getPrimaryIDPropertyName()#Path") />
			
			<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-parentidproperty="#attributes.parentPropertyName#.#thistag.exampleEntity.getPrimaryIDPropertyName()#"', " ") />
			
			<cfset attributes.smartList.setPageRecordsShow(1000000) />
		</cfif>
		
		<!--- Setup Sortability --->
		<cfif len(attributes.sortProperty)>
			<cfif not arrayLen(attributes.smartList.getOrders())>
				<cfset thistag.sortable = true />
				
				<cfset attributes.tableclass = listAppend(attributes.tableclass, 'table-sortable', ' ') />
				
				<cfset attributes.smartList.addOrder("#attributes.sortProperty#|ASC") />
				
				<cfset thistag.allpropertyidentifiers = listAppend(thistag.allpropertyidentifiers, "#attributes.sortProperty#") />
				
				<cfif len(attributes.sortContextIDColumn) and len(attributes.sortContextIDValue)>
					<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-sortcontextidcolumn="#attributes.sortContextIDColumn#"', " ") />
					<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-sortcontextidvalue="#attributes.sortContextIDValue#"', " ") />
				</cfif>
			</cfif>
		</cfif>
		
		<!--- Setup the admin meta info --->
		<cfset attributes.administativeCount = 0 />
		
		<!--- Detail --->
		<cfif len(attributes.recordDetailAction)>
			<cfset attributes.administativeCount++ />
			
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-detailaction="#attributes.recordDetailAction#"', " ") />
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-detailquerystring="#attributes.recordDetailQueryString#"', " ") />
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-detailmodal="#attributes.recordDetailModal#"', " ") />
		</cfif>
		
		<!--- Edit --->
		<cfif len(attributes.recordEditAction)>
			<cfset attributes.administativeCount++ />
			
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-editaction="#attributes.recordEditAction#"', " ") />
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-editquerystring="#attributes.recordEditQueryString#"', " ") />
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-editmodal="#attributes.recordEditModal#"', " ") />
		</cfif>
		
		<!--- Delete --->
		<cfif len(attributes.recordDeleteAction)>
			<cfset attributes.administativeCount++ />
			
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-deleteaction="#attributes.recordDeleteAction#"', " ") />
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-deletequerystring="#attributes.recordDeleteQueryString#"', " ") />
		</cfif>
		
		<!--- Process --->
		<cfif len(attributes.recordProcessAction) and attributes.recordProcessButtonDisplayFlag>
			<cfset attributes.administativeCount++ />
			
			<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-processcontext="#attributes.recordProcessContext#"', " ") />
			<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-processentity="#attributes.recordProcessEntity.getClassName()#"', " ") />
			<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-processentityid="#attributes.recordProcessEntity.getPrimaryIDValue()#"', " ") />
			
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-processaction="#attributes.recordProcessAction#"', " ") />
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-processcontext="#attributes.recordProcessContext#"', " ") />
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-processquerystring="#attributes.recordProcessQueryString#"', " ") />
			<cfset attributes.adminattributes = listAppend(attributes.adminattributes, 'data-processupdatetableid="#attributes.recordProcessUpdateTableID#"', " ") />
		</cfif>
		
		
		<!--- Setup the primary representation column if no columns were passed in --->
		<cfif not arrayLen(thistag.columns)>
			<cfset arrayAppend(thistag.columns, {
				propertyIdentifier = thistag.exampleentity.getSimpleRepresentationPropertyName(),
				title = "",
				tdClass="primary",
				search = true,
				sort = true,
				filter = false,
				range = false,
				editable = false
			}) />
		</cfif>
		
		<!--- Setup the list of all property identifiers to be used later --->
		<cfloop array="#thistag.columns#" index="column">
			
			<!--- If this is a standard propertyIdentifier --->
			<cfif len(column.propertyIdentifier)>
				
				<!--- Add to the all property identifiers --->
				<cfset thistag.allpropertyidentifiers = listAppend(thistag.allpropertyidentifiers, column.propertyIdentifier) />
				
				<!--- Check to see if we need to setup the dynamic filters, ect --->
				<cfif not len(column.search) || not len(column.sort) || not len(column.filter) || not len(column.range)>
					
					<!--- Get the entity object to get property metaData --->
					<cfset thisEntityName = attributes.hibachiScope.getService("hibachiService").getLastEntityNameInPropertyIdentifier( attributes.smartList.getBaseEntityName(), column.propertyIdentifier ) />
					<cfset thisPropertyName = listLast( column.propertyIdentifier, "." ) />
					<cfset thisPropertyMeta = attributes.hibachiScope.getService("hibachiService").getPropertyByEntityNameAndPropertyName( thisEntityName, thisPropertyName ) />
					
					<!--- Setup automatic search, sort, filter & range --->
					<cfif not len(column.search) && (!structKeyExists(thisPropertyMeta, "persistent") || thisPropertyMeta.persistent) && (!structKeyExists(thisPropertyMeta, "ormType") || thisPropertyMeta.ormType eq 'string')>
						<cfset column.search = true />
					<cfelseif !isBoolean(column.search)>
						<cfset column.search = false />
					</cfif>
					<cfif not len(column.sort) && (!structKeyExists(thisPropertyMeta, "persistent") || thisPropertyMeta.persistent)>
						<cfset column.sort = true />
					<cfelseif !isBoolean(column.sort)>
						<cfset column.sort = false />
					</cfif>
					<cfif not len(column.filter) && (!structKeyExists(thisPropertyMeta, "persistent") || thisPropertyMeta.persistent)>
						<cfset column.filter = false />
						
						<cfif structKeyExists(thisPropertyMeta, "ormtype") && thisPropertyMeta.ormtype eq 'boolean'>
							<cfset column.filter = true />
						</cfif>
						<!---
						<cfif !column.filter && listLen(column.propertyIdentifier, '._') gt 1>
							
							<cfset oneUpPropertyIdentifier = column.propertyIdentifier />
							<cfset oneUpPropertyIdentifier = listDeleteAt(oneUpPropertyIdentifier, listLen(oneUpPropertyIdentifier, '._'), '._') />
							<cfset oneUpPropertyName = listLast(oneUpPropertyIdentifier, '.') />
							<cfset twoUpEntityName = attributes.hibachiScope.getService("hibachiService").getLastEntityNameInPropertyIdentifier( attributes.smartList.getBaseEntityName(), oneUpPropertyIdentifier ) />
							<cfset oneUpPropertyMeta = attributes.hibachiScope.getService("hibachiService").getPropertyByEntityNameAndPropertyName( twoUpEntityName, oneUpPropertyName ) />
							<cfif structKeyExists(oneUpPropertyMeta, "fieldtype") && oneUpPropertyMeta.fieldtype eq 'many-to-one' && (!structKeyExists(thisPropertyMeta, "ormtype") || listFindNoCase("boolean,string", thisPropertyMeta.ormtype))>
								<cfset column.filter = true />
							</cfif>
						</cfif>
						--->
					<cfelseif !isBoolean(column.filter)>
						<cfset column.filter = false />
					</cfif>
					<cfif not len(column.range) && (!structKeyExists(thisPropertyMeta, "persistent") || thisPropertyMeta.persistent) && structKeyExists(thisPropertyMeta, "ormType") && (thisPropertyMeta.ormType eq 'integer' || thisPropertyMeta.ormType eq 'big_decimal' || thisPropertyMeta.ormType eq 'timestamp')>
						<cfset column.range = true />
					<cfelseif !isBoolean(column.range)>
						<cfset column.range = false />
					</cfif>
				</cfif>
			<!--- Otherwise this is a processObject property --->
			<cfelseif len(column.processObjectProperty)>
				<cfset column.search = false />
				<cfset column.sort = false />
				<cfset column.filter = false />
				<cfset column.range = false />
				
				<cfset thistag.allprocessobjectproperties = listAppend(thistag.allprocessobjectproperties, column.processObjectProperty) />
			</cfif>
			<cfif findNoCase("primary", column.tdClass) and thistag.expandable>
				<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-expandsortproperty="#column.propertyIdentifier#"', " ") />
				<cfset column.sort = false />
			</cfif>
		</cfloop>
		
		<!--- Setup a variable for the number of columns so that the none can have a proper colspan --->
		<cfset thistag.columnCount = arrayLen(thisTag.columns) />
		<cfif thistag.selectable>
			<cfset thistag.columnCount += 1 />
		</cfif>
		<cfif thistag.multiselectable>
			<cfset thistag.columnCount += 1 />
		</cfif>
		<cfif thistag.sortable>
			<cfset thistag.columnCount += 1 />
		</cfif>
		<cfif attributes.administativeCount>
			<cfset thistag.columnCount += 1 />
		</cfif>
		<cfif attributes.administativeCount>
		</cfif>
	</cfsilent>
	<cfoutput>
		<table id="LD#replace(attributes.smartList.getSavedStateID(),'-','','all')#" class="#attributes.tableclass#" data-norecordstext="#attributes.hibachiScope.rbKey("entity.#thistag.exampleEntity.getClassName()#.norecords", {entityNamePlural=attributes.hibachiScope.rbKey('entity.#thistag.exampleEntity.getClassName()#_plural')})#" data-savedstateid="#attributes.smartList.getSavedStateID()#" data-entityname="#attributes.smartList.getBaseEntityName()#" data-idproperty="#thistag.exampleEntity.getPrimaryIDPropertyName()#" data-processobjectproperties="#thistag.allprocessobjectproperties#" data-propertyidentifiers="#thistag.exampleEntity.getPrimaryIDPropertyName()#,#thistag.allpropertyidentifiers#" #attributes.tableattributes#>
			<thead>
				<tr>
					<!--- Selectable --->
					<cfif thistag.selectable>
						<cfset class="select">
						<cfif not attributes.edit>
							<cfset class &= " disabled" />
						</cfif>
						<input type="hidden" name="#attributes.selectFieldName#" value="#attributes.selectValue#" />
						<th class="#class#">#attributes.selectTitle#</th>
					</cfif>
					<!--- Multiselectable --->
					<cfif thistag.multiselectable>
						<cfset class="multiselect">
						<cfif not attributes.edit>
							<cfset class &= " disabled" />
						</cfif>
						<input type="hidden" name="#attributes.multiselectFieldName#" value="#attributes.multiselectValues#" />
						<th class="#class#">
							<cfif not thistag.expandable and len(attributes.multiselectPropertyIdentifier)>
								<div class="dropdown">
									<a href="##" class="dropdown-toggle" data-toggle="dropdown">&nbsp;<i class="icon-check"></i> </a>
									<ul class="dropdown-menu nav">
										<li><a href="##" class="multiselect-checked-filter"><i class="hibachi-ui-checkbox#IIF(attributes.edit, DE(''), DE('-checked'))#"></i> Show Selected</a></li>
									</ul>				
								</div>
							<cfelse>
								&nbsp;
							</cfif>
						</th>
					</cfif>
					<!--- Sortable --->
					<cfif thistag.sortable>
						<th class="sort">&nbsp;</th>
					</cfif>
					<!--- Columns --->
					<cfloop array="#thistag.columns#" index="column">
						<cfsilent>
							<cfif not len(column.title) and len(column.propertyIdentifier)>
								<cfset column.title = thistag.exampleEntity.getTitleByPropertyIdentifier(column.propertyIdentifier) />
							</cfif>
						</cfsilent>
						<th class="data #column.tdClass#" <cfif len(column.propertyIdentifier)>data-propertyIdentifier="#column.propertyIdentifier#"<cfelseif len(column.processObjectProperty)>data-processobjectproperty="#column.processObjectProperty#"<cfif structKeyExists(column, "fieldClass")> data-fieldclass="#column.fieldClass#"</cfif></cfif>>
							<cfif (not column.sort or thistag.expandable) and (not column.search or thistag.expandable) and (not column.filter or thistag.expandable) and (not column.range or thistag.expandable)>
								#column.title#
							<cfelse>
								<div class="dropdown">
									<a href="##" class="dropdown-toggle" data-toggle="dropdown">#column.title#</a>
									<ul class="dropdown-menu nav scrollable">
										<cf_HibachiDividerHider>
											<cfif column.sort and not thistag.expandable>
												<li class="nav-header">#attributes.hibachiScope.rbKey('define.sort')#</li>
												<li><a href="##" class="listing-sort" data-sortdirection="ASC"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
												<li><a href="##" class="listing-sort" data-sortdirection="DESC"><i class="icon-arrow-up"></i> Sort Decending</a></li>
												<li class="divider"></li>
											</cfif>
											<cfif column.search and not thistag.expandable>
												<li class="nav-header">#attributes.hibachiScope.rbKey('define.search')#</li>
												<li class="search-filter"><input type="text" class="listing-search" name="FK:#column.propertyIdentifier#" value="" /> <i class="icon-search"></i></li>
												<li class="divider"></li>
											</cfif>
											<cfif column.range and not thistag.expandable>
												<cfsilent>
													<cfset local.rangeClass = "text" />
													<cfset local.fieldType = thistag.exampleEntity.getFieldTypeByPropertyIdentifier(column.propertyIdentifier) />
													<cfif local.fieldType eq "dateTime">
														<cfset local.rangeClass = "datetimepicker" />	
													</cfif>
												</cfsilent>
												<li class="nav-header">#attributes.hibachiScope.rbKey('define.range')#</li>
												<li class="range-filter"><label for="">From</label><input type="text" class="#local.rangeClass# range-filter-lower" name="R:#column.propertyIdentifier#" value="" /></li>
												<li class="range-filter"><label for="">To</label><input type="text" class="#local.rangeClass# range-filter-upper" name="R:#column.propertyIdentifier#" value="" /></li>
												<li class="divider"></li>
											</cfif>
											<cfif column.filter and not thistag.expandable>
												<li class="nav-header">#attributes.hibachiScope.rbKey('define.filter')#</li>
												<cfset filterOptions = attributes.smartList.getFilterOptions(valuePropertyIdentifier=column.propertyIdentifier, namePropertyIdentifier=column.propertyIdentifier) />
												<input type="hidden" name="F:#column.propertyIdentifier#" value="#attributes.smartList.getFilters(column.propertyIdentifier)#" />
												<cfloop array="#filterOptions#" index="filter">
													<li><a href="##" class="listing-filter" data-filtervalue="#filter['value']#"><i class="hibachi-ui-checkbox"></i> #filter['name']#</a></li>
												</cfloop>
											</cfif>
										</cf_HibachiDividerHider>
									</ul>
								</div>
							</cfif>
						</th>
					</cfloop>
					<!--- Admin --->
					<cfif attributes.administativeCount>
						<th class="admin admin#attributes.administativeCount#" #attributes.adminattributes#>&nbsp;</th>
					</cfif>
				</tr>
			</thead>
			<tbody <cfif thistag.sortable>class="sortable"</cfif>>
				<cfset thistag.loopIndex = 0 />
				<cfif not attributes.edit and thistag.multiselectable and not len(attributes.parentPropertyName) and len(attributes.multiselectPropertyIdentifier)>
					<cfif len(attributes.multiselectValues)>
						<cfset attributes.smartList.addInFilter(attributes.multiselectPropertyIdentifier, attributes.multiselectValues) />
					<cfelse>
						<cfset attributes.smartList.addInFilter(attributes.multiselectPropertyIdentifier, '_') />
					</cfif>
				</cfif>
				<cfloop array="#attributes.smartList.getPageRecords()#" index="record">
					<cfset thistag.loopIndex++ />
					<!--- If there is a recordProcessEntity then find the processObject and inject the necessary values --->
					<cfif isObject(attributes.recordProcessEntity)>
						<cfset injectValues = structNew() />
						<cfset injectValues[ "#record.getClassName()#" ] = record />
						<cfset injectValues[ "#record.getPrimaryIDPropertyName()#" ] = record.getPrimaryIDValue() />
						<cfset attributes.recordProcessEntity.clearProcessObject( attributes.recordProcessContext ) />
						<cfset thisRecordProcessObject = attributes.recordProcessEntity.getProcessObject( attributes.recordProcessContext, injectValues ) />
					</cfif>
					<tr id="#record.getPrimaryIDValue()#" <cfif thistag.expandable>idPath="#record.getValueByPropertyIdentifier( propertyIdentifier="#thistag.exampleEntity.getPrimaryIDPropertyName()#Path" )#"</cfif>>
						<!--- Selectable --->
						<cfif thistag.selectable>
							<td><a href="##" class="table-action-select#IIF(attributes.edit, DE(""), DE(" disabled"))#" data-idvalue="#record.getPrimaryIDValue()#"><i class="hibachi-ui-radio"></i></a></td>
						</cfif>
						<!--- Multiselectable --->
						<cfif thistag.multiselectable>
							<td><a href="##" class="table-action-multiselect#IIF(attributes.edit, DE(""), DE(" disabled"))#" data-idvalue="#record.getPrimaryIDValue()#"><i class="hibachi-ui-checkbox"></i></a></td>
						</cfif>
						<!--- Sortable --->
						<cfif thistag.sortable>
							<td><a href="##" class="table-action-sort" data-idvalue="#record.getPrimaryIDValue()#" data-sortPropertyValue="#record.getValueByPropertyIdentifier( attributes.sortProperty )#"><i class="icon-move"></i></a></td>
						</cfif>
						<cfloop array="#thistag.columns#" index="column">
							<!--- Expandable Check --->
							<cfif column.tdclass eq "primary" and thistag.expandable>
								<td class="#column.tdclass#"><a href="##" class="table-action-expand depth0" data-depth="0"><i class="icon-plus"></i></a> #record.getValueByPropertyIdentifier( propertyIdentifier=column.propertyIdentifier, formatValue=true )#</td>
							<cfelse>
								<td class="#column.tdclass#">
									<cfif len(column.propertyIdentifier)>
										#record.getValueByPropertyIdentifier( propertyIdentifier=column.propertyIdentifier, formatValue=true )#
									<cfelseif len(column.processObjectProperty)>
										<cfset attData = duplicate(column) />
										<cfset attData.object = thisRecordProcessObject />
										<cfset attData.property = column.processObjectProperty />
										<cfset attData.edit = attributes.edit />
										<cfset attData.displayType = "plain" />
										<cfif structKeyExists(attData, "recordFieldNamePrefix") and len(attData.recordFieldNamePrefix)>
											<cfset attData.fieldName = "#attData.recordFieldNamePrefix#[#thistag.loopIndex#].#attData.fieldName#" />
										</cfif>
										<cf_HibachiPropertyDisplay attributeCollection="#attData#" />
									</cfif>
								</td>
							</cfif>
						</cfloop>
						<cfif attributes.administativeCount>
							<td class="admin admin#attributes.administativeCount#">
								<!--- Detail --->
								<cfif len(attributes.recordDetailAction)>
									<cf_HibachiActionCaller action="#attributes.recordDetailAction#" queryString="#listPrepend(attributes.recordDetailQueryString, '#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#', '&')#" class="btn btn-mini" icon="eye-open" iconOnly="true" modal="#attributes.recordDetailModal#" />
								</cfif>
								
								<!--- Edit --->
								<cfif len(attributes.recordEditAction)>
									<cfset local.editErrors = attributes.hibachiScope.getService("hibachiValidationService").validate(object=record, context="edit", setErrors=false) />
									<cfset local.disabled = local.editErrors.hasErrors() />
									<cfset local.disabledText = local.editErrors.getAllErrorsHTML() />
									<cf_HibachiActionCaller action="#attributes.recordEditAction#" queryString="#listPrepend(attributes.recordEditQueryString, '#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#', '&')#" class="btn btn-mini" icon="pencil" iconOnly="true" disabled="#local.disabled#" disabledText="#local.disabledText#" modal="#attributes.recordEditModal#" />
								</cfif>
								
								<!--- Delete --->
								<cfif len(attributes.recordDeleteAction)>
									<cfset local.deleteErrors = attributes.hibachiScope.getService("hibachiValidationService").validate(object=record, context="delete", setErrors=false) />
									<cfset local.disabled = local.deleteErrors.hasErrors() />
									<cfset local.disabledText = local.deleteErrors.getAllErrorsHTML() />
									<cf_HibachiActionCaller action="#attributes.recordDeleteAction#" queryString="#listPrepend(attributes.recordDeleteQueryString, '#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#', '&')#" class="btn btn-mini" icon="trash" iconOnly="true" disabled="#local.disabled#" disabledText="#local.disabledText#" confirm="true" />
								</cfif>
								
								<!--- Process --->
								<cfif len(attributes.recordProcessAction)>
									<cf_HibachiProcessCaller action="#attributes.recordProcessAction#" entity="#attributes.recordProcessEntity#" processContext="#attributes.recordProcessContext#" queryString="#listPrepend(attributes.recordProcessQueryString, '#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#', '&')#" class="btn hibachi-ajax-submit" />
								</cfif>
							</td>
						</cfif>
					</tr>
				</cfloop>
				<cfif !arrayLen(attributes.smartList.getPageRecords())>
					<tr><td colspan="#thistag.columnCount#" style="text-align:center;"><em>#attributes.hibachiScope.rbKey("entity.#thistag.exampleEntity.getClassName()#.norecords", {entityNamePlural=attributes.hibachiScope.rbKey('entity.#thistag.exampleEntity.getClassName()#_plural')})#</em></td></tr>
				</cfif>
			</tbody>
		</table>
		
		<!--- Pager --->
		<cfsilent>
			<cfset local.pageStart = 1 />
			<cfset local.pageCount = 2 />
			
			<cfif attributes.smartList.getTotalPages() gt 6>
				<cfif attributes.smartList.getCurrentPage() lte 3>
					<cfset local.pageCount = 4 />
				<cfelseif attributes.smartList.getCurrentPage() gt 3 and attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages() - 3>
					<cfset local.pageStart = attributes.smartList.getCurrentPage()-1 />
				<cfelseif attributes.smartList.getCurrentPage() gte attributes.smartList.getTotalPages() - 3>
					<cfset local.pageStart = attributes.smartList.getTotalPages()-3 />
					<cfset local.pageCount = 4 />
				</cfif>
			<cfelse>
				<cfset local.pageCount = attributes.smartList.getTotalPages() - 1 />
			</cfif>
			
			<cfset local.pageEnd = local.pageStart + local.pageCount />
		</cfsilent>
		
		<cfif attributes.smartList.getTotalPages() gt 1>
			<div class="pagination" data-tableid="LD#replace(attributes.smartList.getSavedStateID(),'-','','all')#">
				<ul>
					<li><a href="##" class="paging-show-toggle">#attributes.hibachiScope.rbKey('define.show')# <span class="details">(#attributes.smartList.getPageRecordsStart()# - #attributes.smartList.getPageRecordsEnd()# #lcase(attributes.hibachiScope.rbKey('define.of'))# #attributes.smartList.getRecordsCount()#)</span></a></li>
					<li><a href="##" class="show-option" data-show="10">10</a></li>
					<li><a href="##" class="show-option" data-show="25">25</a></li>
					<li><a href="##" class="show-option" data-show="50">50</a></li>
					<li><a href="##" class="show-option" data-show="100">100</a></li>
					<li><a href="##" class="show-option" data-show="500">500</a></li>
					<li><a href="##" class="show-option" data-show="ALL">ALL</a></li>
					<cfif attributes.smartList.getCurrentPage() gt 1>
						<li><a href="##" class="listing-pager page-option prev" data-page="#attributes.smartList.getCurrentPage() - 1#">&laquo;</a></li>
					<cfelse>
						<li class="disabled"><a href="##" class="page-option prev">&laquo;</a></li>
					</cfif>
					<cfif attributes.smartList.getTotalPages() gt 6 and attributes.smartList.getCurrentPage() gt 3>
						<li><a href="##" class="listing-pager page-option" data-page="1">1</a></li>
						<li><a href="##" class="listing-pager page-option" data-page="#attributes.smartList.getCurrentPage()-3#">...</a></li>
					</cfif>
					<cfloop from="#local.pageStart#" to="#local.pageEnd#" index="i" step="1">
						<li <cfif attributes.smartList.getCurrentPage() eq i>class="active"</cfif>><a href="##" class="listing-pager page-option" data-page="#i#">#i#</a></li>
					</cfloop>
					<cfif attributes.smartList.getTotalPages() gt 6 and attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages() - 3>
						<li><a href="##" class="listing-pager page-option" data-page="#attributes.smartList.getCurrentPage()+3#">...</a></li>
						<li><a href="##" class="listing-pager page-option" data-page="#attributes.smartList.getTotalPages()#">#attributes.smartList.getTotalPages()#</a></li>
					</cfif>
					<cfif attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages()>
						<li><a href="##" class="listing-pager page-option next" data-page="#attributes.smartList.getCurrentPage() + 1#">&raquo;</a></li>
					<cfelse>
						<li class="disabled"><a href="##" class="page-option next">&raquo;</a></li>
					</cfif>
				</ul>
			</div>
		</cfif>
	</cfoutput>
</cfif>
