<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
<cfparam name="attributes.object" type="any" default="" />
<cfparam name="attributes.subsystem" type="string" default="#request.context.fw.getSubsystem( request.context[ request.context.fw.getAction() ])#">
<cfparam name="attributes.section" type="string" default="#request.context.fw.getSection( request.context[ request.context.fw.getAction() ])#">
<cfparam name="attributes.tabLocation" type="string" default="left" />

<cfif (not isObject(attributes.object) || not attributes.object.isNew()) and (not structKeyExists(request.context, "modal") or not request.context.modal)>
	<cfif thisTag.executionMode is "end">

		<cfparam name="thistag.tabs" default="#arrayNew(1)#" />
		<cfparam name="activeTab" default="tabSystem" />

		<cfloop array="#thistag.tabs#" index="tab">
			<!--- Make sure there is a view --->
			<cfif not len(tab.view) and len(tab.property)>
				<cfset tab.view = "#attributes.subsystem#:#attributes.section#/#lcase(attributes.object.getClassName())#tabs/#lcase(tab.property)#" />

				<cfset propertyMetaData = attributes.object.getPropertyMetaData( tab.property ) />

				<cfif not len(tab.text)>
					<cfset tab.text = attributes.object.getPropertyTitle( tab.property ) />
				</cfif>

				<cfif not len(tab.count) and structKeyExists(propertyMetaData, "fieldtype") and listFindNoCase("many-to-one,one-to-many,many-to-many", propertyMetaData.fieldtype)>
					<cfset thisCount = attributes.object.getPropertyCount( tab.property ) />
				</cfif>
			</cfif>

			<!--- Make sure there is a tabid --->
			<cfif not len(tab.tabid)>
				<cfset tab.tabid = "tab" & listLast(tab.view, '/') />
			</cfif>

			<!--- Make sure there is text for the tab name --->
			<cfif not len(tab.text)>
				<cfset tab.text = attributes.hibachiScope.rbKey( replace( replace(tab.view, '/', '.', 'all') ,':','.','all' ) ) />
			</cfif>

			<cfif not len(tab.tabcontent)>
				<cfif fileExists(expandPath(request.context.fw.parseViewOrLayoutPath(tab.view, 'view')))>
					<cfset tab.tabcontent = request.context.fw.view(tab.view, {rc=request.context, params=tab.params}) />
				<cfelseif len(tab.property)>
					<cfsavecontent variable="tab.tabcontent">
						<hb:HibachiPropertyDisplay object="#attributes.object#" property="#tab.property#" edit="#request.context.edit#" displaytype="plain" />
					</cfsavecontent>
				</cfif>
			</cfif>
		</cfloop>

		<cfif arrayLen(thistag.tabs)>
			<cfset activeTab = thistag.tabs[1].tabid />
		</cfif>

		<cfoutput>
			<div class="row">
				<div class="col-sm-12 s-header-nav">
					<div class="navbar-header">
						<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="##main-tab-nav">
							<span class="sr-only">Toggle navigation</span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
						</button>
					</div>
					<div class="row collapse navbar-collapse" id="main-tab-nav">
						<ul class="nav nav-tabs s-negative">
							<cfloop array="#thistag.tabs#" index="tab">
								<li <cfif activeTab eq tab.tabid>class="active"</cfif>>
									<a href="###tab.tabid#" data-toggle="tab">
										<span class="s-title">#tab.text# </span>
										<cfif len(tab.count) and tab.count gt 0> 
											<span class="badge">#tab.count#</span>
										</cfif>
									</a>
								</li>
							</cfloop>
							<cfif isObject(attributes.object)>
								<li><a href="##tabSystem" data-toggle="tab">#attributes.hibachiScope.rbKey('define.system')#</a></li>
							</cfif>
						</ul>
					</div>
				</div>
				<div class="tab-content col-sm-12">
					<cfloop array="#thistag.tabs#" index="tab">
						<cfoutput>
							<div <cfif activeTab eq tab.tabid> class="tab-pane active"<cfelse> class="tab-pane"</cfif> id="#tab.tabid#">
								#tab.tabcontent#
							</div>
						</cfoutput>
					</cfloop>
					<cfif isObject(attributes.object)>
						<div <cfif arrayLen(thistag.tabs)>class="tab-pane"<cfelse>class="tab-pane active"</cfif> id="tabSystem">
							<div class="row">
								<hb:HibachiPropertyList>
									<hb:HibachiPropertyDisplay object="#attributes.object#" property="#attributes.object.getPrimaryIDPropertyName()#" />
									<cfif attributes.object.hasProperty('remoteID')>
										<hb:HibachiPropertyDisplay object="#attributes.object#" property="remoteID" edit="#attributes.hibachiScope.getService('hibachiUtilityService').hibachiTernary(request.context.edit && attributes.hibachiScope.setting('globalRemoteIDEditFlag'), true, false)#" />
									</cfif>
									<cfif !attributes.object.getAuditSmartList().getRecordsCount()>
										<cfif attributes.object.hasProperty('createdDateTime')>
											<hb:HibachiPropertyDisplay object="#attributes.object#" property="createdDateTime" />
										</cfif>
										<cfif attributes.object.hasProperty('createdByAccount')>
											<hb:HibachiPropertyDisplay object="#attributes.object#" property="createdByAccount" />
										</cfif>
										<cfif attributes.object.hasProperty('modifiedDateTime')>
											<hb:HibachiPropertyDisplay object="#attributes.object#" property="modifiedDateTime" />
										</cfif>
										<cfif attributes.object.hasProperty('modifiedByAccount')>
											<hb:HibachiPropertyDisplay object="#attributes.object#" property="modifiedByAccount" />
										</cfif>
									</cfif>
								</hb:HibachiPropertyList>

								<hb:HibachiTimeline object="#attributes.object#" />
							</div>
						</div>
					</cfif>
				</div>
			</div>
		</cfoutput>
	</cfif>
</cfif>
