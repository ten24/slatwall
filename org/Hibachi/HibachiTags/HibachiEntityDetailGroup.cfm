<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
<cfparam name="attributes.object" type="any" default="" />
<cfparam name="attributes.subsystem" type="string" default="#request.context.fw.getSubsystem( request.context[ request.context.fw.getAction() ])#">
<cfparam name="attributes.section" type="string" default="#request.context.fw.getSection( request.context[ request.context.fw.getAction() ])#">
<cfparam name="attributes.tabLocation" type="string" default="left" />
<cfparam name="attributes.createOrModalFlag" type="boolean" default="false" />

<cfif (isObject(attributes.object) && attributes.object.isNew())|| (structKeyExists(request.context, "modal") and request.context.modal)>
	<cfset attributes.createOrModalFlag = true />
</cfif>

<cfif thisTag.executionMode is "end">

	<cfparam name="thistag.tabs" default="#arrayNew(1)#" />
	<cfparam name="activeTab" default="basic" />

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

		<cfif not len(tab.tabcontent) and (not attributes.createOrModalFlag or tab.showOnCreateFlag)>
			<cfif fileExists(expandPath(request.context.fw.parseViewOrLayoutPath(tab.view, 'view')))>
				<cfset tab.tabcontent = request.context.fw.view(tab.view, {rc=request.context, params=tab.params}) />
			<cfelseif len(tab.property)>
				<cfsavecontent variable="tab.tabcontent">
					<hb:HibachiPropertyDisplay object="#attributes.object#" property="#tab.property#" edit="#request.context.edit#" displaytype="plain" />
				</cfsavecontent>
			</cfif>
		</cfif>
	</cfloop>

	<cfoutput>
		<cfif not attributes.createOrModalFlag>
			<div class="row s-pannel-control">
				<div class="col-md-12 s-toggle-panels">
					<a href="##" class="j-openall j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Expand All"><i class="fa fa-expand"></i></a>
					<a href="##" class="j-closeall j-tool-tip-item" data-toggle="tooltip" data-placement="bottom" title="Collapse All"><i class="fa fa-compress"></i></a>
				</div>
			</div>

			<cfset iteration = 0 />
			<div class="panel-group s-pannel-group" id="accordion">
				<cfloop array="#thistag.tabs#" index="tab">
					<cfset iteration++ />
					<div class="j-panel panel panel-default">
						<a data-toggle="collapse"  href="##collapse#iteration#">
							<div class="panel-heading">
								<h4 class="panel-title">
									<span>#tab.text#</span><cfif len(tab.count) and tab.count gt 0> <span class="badge">#tab.count#</span></cfif>
									<i class="fa fa-caret-left s-accordion-toggle-icon"></i>
								</h4>
							</div>
						</a>
						<div id="collapse#iteration#" class="panel-collapse collapse<cfif tab.open> in</cfif>">
							<content class="s-body-box">
								<cfoutput>
									<div <cfif activeTab eq tab.tabid>class="tab-pane active"<cfelse>class="tab-pane"</cfif> id="#tab.tabid#">
										#tab.tabcontent#
									</div>
								</cfoutput>
							</content><!--- s-body-box --->
						</div><!--- panel-collapse collapse in --->
					</div><!--- j-panel panel-default --->
				</cfloop>
				<cfif isObject(attributes.object)>
					<!---system tab --->
					<div class="j-panel panel panel-default">
						<a data-toggle="collapse" href="##tabSystem">
							<div class="panel-heading">
								<h4 class="panel-title">
									<span>#attributes.hibachiScope.rbKey('define.system')#</span>
									<i class="fa fa-caret-left s-accordion-toggle-icon"></i>
								</h4>
							</div>
						</a>
						<div id="tabSystem" class="panel-collapse collapse">
							<content class="s-body-box">
								<cfoutput>
									<div <cfif !isNull(tab) && structKeyExists(tab, "tabid") && activeTab eq tab.tabid> class="tab-pane active" <cfelse> class="tab-pane" </cfif> id="tabSystem">

											<hb:HibachiPropertyList>
												<hb:HibachiPropertyDisplay object="#attributes.object#" property="#attributes.object.getPrimaryIDPropertyName()#" />
												<cfif attributes.object.hasProperty('remoteID') and attributes.hibachiScope.setting('globalRemoteIDShowFlag')>
													<hb:HibachiPropertyDisplay object="#attributes.object#" property="remoteID" edit="#attributes.hibachiScope.getService('hibachiUtilityService').hibachiTernary(request.context.edit && attributes.hibachiScope.setting('globalRemoteIDEditFlag'), true, false)#" />
												</cfif>
												<cfif len( attributes.object.getShortReferenceID() )>
													<hb:HibachiFieldDisplay title="#attributes.hibachiScope.rbkey('entity.define.shortreferenceid')#" value="#attributes.object.getshortReferenceID()#" edit="false" displayType="dl">
												</cfif>
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
											</hb:HibachiPropertyList>

											<hb:HibachiTimeline object="#attributes.object#" />

									</div>
								</cfoutput>
							</content><!--- s-body-box --->

					</div><!--- panel panel-default --->
				</cfif>
			</div>
		<cfelse>
			<cfloop array="#thistag.tabs#" index="tab">
				<cfif tab.showOnCreateFlag>
					#tab.tabcontent#
				</cfif>
			</cfloop>
		</cfif>
	</cfoutput>
</cfif>
