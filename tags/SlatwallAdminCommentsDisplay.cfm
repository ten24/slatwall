<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

	Notes:

--->
<cfimport prefix="swa" taglib="../tags" />
<cfimport prefix="hb" taglib="../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.object" type="any" />
	<cfparam name="attributes.edit" type="boolean" default="#request.context.edit#" />
	<cfparam name="attributes.adminComments" type="boolean" default="true" />
	<cfparam name="attributes.parentObject" type="any" default="#structNew()#" />
	<cfparam name="attributes.childObjects" type="any" default="#arrayNew(1)#" />

	<cfif attributes.edit>
		<cfset attributes.redirectAction = "admin:entity.edit#attributes.object.getClassName()#" />
	<cfelse>
		<cfset attributes.redirectAction = "admin:entity.detail#attributes.object.getClassName()#" />
	</cfif>

	<div class="tab-pane" id="tabComments">
		<cfoutput>
			<table class="table table-bordered table-hover">
				<thead>
					<tr>
						<th class="primary">#attributes.hibachiScope.rbKey("entity.comment.comment")#</th>
						<th>#attributes.hibachiScope.rbKey("entity.comment.publicFlag")#</th>
						<th>#attributes.hibachiScope.rbKey("entity.define.createdByAccount")#</th>
						<th>#attributes.hibachiScope.rbKey("entity.define.createdDateTime")#</th>
						<cfif attributes.adminComments><th class="admin1">&nbsp;</th></cfif>
					</tr>
				</thead>
				<cfloop array="#attributes.object.getComments()#" index="commentRelationship">
					<tr>
						<cfif commentRelationship['referencedRelationshipFlag']>
							<cfset originalEntity = commentRelationship['comment'].getPrimaryRelationship().getRelationshipEntity() />
							<cfswitch expression="#originalEntity.getClassName()#">
								<cfcase value="Order">
									<td class="primary highlight-ltblue" colspan="2">This #attributes.object.getClassName()# was referenced in a comment on <a href="?slatAction=entity.detailorder&orderID=#originalEntity.getOrderID()###tabComments">Order Number #originalEntity.getOrderNumber()#</a></td>
									<td class="highlight-ltblue">#commentRelationship['comment'].getCreatedByAccount().getFullName()#</td>
									<td class="highlight-ltblue">#attributes.hibachiScope.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</td>
									<cfif attributes.adminComments><td class="admin1 highlight-ltblue">&nbsp;</td></cfif>
								</cfcase>
								<cfdefaultcase>
									<td class="primary" colspan="<cfif attributes.adminComments>5<cfelse>4</cfif>">??? Programming Issue for #originalEntity.getClassName()# entity comments</td>
								</cfdefaultcase>
							</cfswitch>
						<cfelse>
							<td class="primary" style="white-space:normal;">#commentRelationship['comment'].getCommentWithLinks()#</td>
							<td>#attributes.hibachiScope.formatValue(commentRelationship['comment'].getPublicFlag(), "yesno")#</td>
							<td><cfif !isNull(commentRelationship['comment'].getCreatedByAccount())>#commentRelationship['comment'].getCreatedByAccount().getFullName()#</cfif></td>
							<td>#attributes.hibachiScope.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</td>
							<cfif attributes.adminComments><td class="admin1"><hb:HibachiActionCaller action="admin:entity.editcomment" queryString="commentID=#commentRelationship['comment'].getCommentID()#&#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&sRenderItem=detail#attributes.object.getClassName()#&fRenderItem=detail#attributes.object.getClassName()#" modal="true" class="btn btn-default btn-xs" icon="pencil" iconOnly="true" /></td></cfif>
						</cfif>
					</tr>
				</cfloop>
				<cfif arrayLen(attributes.object.getComments()) eq 0>
					<tr><td colspan="<cfif attributes.adminComments>5<cfelse>4</cfif>" style="text-align:center;"><em>#attributes.hibachiScope.rbKey("entity.comment.norecords", {entityNamePlural=attributes.hibachiScope.rbKey('entity.comment_plural')})#</em></td></tr>
				</cfif>
			</table>
			<cfif attributes.adminComments>
				<hb:HibachiActionCaller action="admin:entity.createcomment" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&redirectAction=#request.context.slatAction#" modal="true" class="btn btn-default" icon="plus" />
			</cfif>

			<br><br>

			<!---- ======= Comments from Parent ====== --->
			<cfif !structIsEmpty(attributes.parentObject)>
				<table class="table table-bordered table-hover">
					<tr>
						<th class="primary">#attributes.hibachiScope.rbKey("entity.comment.parentComment")#</th>
						<th>#attributes.hibachiScope.rbKey("entity.comment.publicFlag")#</th>
						<th>#attributes.hibachiScope.rbKey("entity.define.createdByAccount")#</th>
						<th>#attributes.hibachiScope.rbKey("entity.define.createdDateTime")#</th>
						<cfif attributes.adminComments><th class="admin1">&nbsp;</th></cfif>
					</tr>

					<cfloop array="#attributes.parentObject.getComments()#" index="commentRelationship">
						<tr>
							<cfif commentRelationship['referencedRelationshipFlag']>
								<cfset originalEntity = commentRelationship['comment'].getPrimaryRelationship().getRelationshipEntity() />
								<cfswitch expression="#originalEntity.getClassName()#">
									<cfcase value="Order">
										<td class="primary highlight-ltblue" colspan="2">This #attributes.object.getClassName()# was referenced in a comment on <a href="?slatAction=order.detailorder&orderID=#originalEntity.getOrderID()###tabComments">Order Number #originalEntity.getOrderNumber()#</a></td>
										<td class="highlight-ltblue">#commentRelationship['comment'].getCreatedByAccount().getFullName()#</td>
										<td class="highlight-ltblue">#attributes.hibachiScope.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</td>
										<cfif attributes.adminComments><td class="admin1 highlight-ltblue">&nbsp;</td></cfif>
									</cfcase>
									<cfdefaultcase>
										<td class="primary" colspan="<cfif attributes.adminComments>5<cfelse>4</cfif>">??? Programming Issue for #originalEntity.getClassName()# entity comments</td>
									</cfdefaultcase>
								</cfswitch>
							<cfelse>
								<td class="primary" style="white-space:normal;">#commentRelationship['comment'].getCommentWithLinks()#</td>
								<td>#attributes.hibachiScope.formatValue(commentRelationship['comment'].getPublicFlag(), "yesno")#</td>
								<td><cfif !isNull(commentRelationship['comment'].getCreatedByAccount())>#commentRelationship['comment'].getCreatedByAccount().getFullName()#</cfif></td>
								<td>#attributes.hibachiScope.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</td>
								<cfif attributes.adminComments><td class="admin1"><hb:HibachiActionCaller action="admin:entity.editcomment" queryString="commentID=#commentRelationship['comment'].getCommentID()#&#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&sRenderItem=detail#attributes.object.getClassName()#&fRenderItem=detail#attributes.object.getClassName()#" modal="true" class="btn btn-default btn-xs" icon="pencil" iconOnly="true" /></td></cfif>
							</cfif>
						</tr>
					</cfloop>

					<cfif arrayLen(attributes.object.getComments()) eq 0>
						<tr><td colspan="<cfif attributes.adminComments>5<cfelse>4</cfif>" style="text-align:center;"><em>#attributes.hibachiScope.rbKey("entity.comment.norecords", {entityNamePlural=attributes.hibachiScope.rbKey('entity.comment_plural')})#</em></td></tr>
					</cfif>
				</table>
			</cfif>

			<!--- ======= Comments on all Children ====== --->
			<cfif arrayLen(attributes.childObjects)>
				<table class="table table-bordered table-hover">
					<tr>
						<th class="primary">#attributes.hibachiScope.rbKey("entity.comment.childComment")#</th>
						<th>#attributes.hibachiScope.rbKey("entity.comment.publicFlag")#</th>
						<th>#attributes.hibachiScope.rbKey("entity.define.createdByAccount")#</th>
						<th>#attributes.hibachiScope.rbKey("entity.define.createdDateTime")#</th>
						<cfif attributes.adminComments><th class="admin1">&nbsp;</th></cfif>
					</tr>
					<cfloop array="#attributes.childObjects#" index="childObject">
						<cfloop array="#childObject.getComments()#" index="commentRelationship">
							<tr>
								<cfif commentRelationship['referencedRelationshipFlag']>
									<cfset originalEntity = commentRelationship['comment'].getPrimaryRelationship().getRelationshipEntity() />
									<cfswitch expression="#originalEntity.getClassName()#">
										<cfcase value="Order">
											<td class="primary highlight-ltblue" colspan="2">This #attributes.object.getClassName()# was referenced in a comment on <a href="?slatAction=order.detailorder&orderID=#originalEntity.getOrderID()###tabComments">Order Number #originalEntity.getOrderNumber()#</a></td>
											<td class="highlight-ltblue">#commentRelationship['comment'].getCreatedByAccount().getFullName()#</td>
											<td class="highlight-ltblue">#attributes.hibachiScope.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</td>
											<cfif attributes.adminComments><td class="admin1 highlight-ltblue">&nbsp;</td></cfif>
										</cfcase>
										<cfdefaultcase>
											<td class="primary" colspan="<cfif attributes.adminComments>5<cfelse>4</cfif>">??? Programming Issue for #originalEntity.getClassName()# entity comments</td>
										</cfdefaultcase>
									</cfswitch>
								<cfelse>
									<td class="primary" style="white-space:normal;">#commentRelationship['comment'].getCommentWithLinks()#</td>
									<td>#attributes.hibachiScope.formatValue(commentRelationship['comment'].getPublicFlag(), "yesno")#</td>
									<td><cfif !isNull(commentRelationship['comment'].getCreatedByAccount())>#commentRelationship['comment'].getCreatedByAccount().getFullName()#</cfif></td>
									<td>#attributes.hibachiScope.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</td>
									<cfif attributes.adminComments><td class="admin1"><hb:HibachiActionCaller action="admin:entity.editcomment" queryString="commentID=#commentRelationship['comment'].getCommentID()#&#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&sRenderItem=detail#attributes.object.getClassName()#&fRenderItem=detail#attributes.object.getClassName()#" modal="true" class="btn btn-default btn-xs" icon="pencil" iconOnly="true" /></td></cfif>
								</cfif>
							</tr>
						</cfloop>
					</cfloop>
					<cfif arrayLen(attributes.object.getComments()) eq 0>
						<tr><td colspan="<cfif attributes.adminComments>5<cfelse>4</cfif>" style="text-align:center;"><em>#attributes.hibachiScope.rbKey("entity.comment.norecords", {entityNamePlural=attributes.hibachiScope.rbKey('entity.comment_plural')})#</em></td></tr>
					</cfif>
				</table>
			</cfif>
		</cfoutput>
	</div>
</cfif>
