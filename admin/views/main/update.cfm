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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfparam name="rc.currentVersion" type="string" />
<cfparam name="rc.currentBranch" type="string" />
<cfparam name="rc.availableDevelopVersion" type="string" />
<cfparam name="rc.availableMasterVersion" type="string" />

<cfset local.updateOptions = [{name="Stable", value="master"},{name="Bleeding Edge", value="develop"},{name="Hotfix", value="hotfix"}] />

<cfif rc.currentBranch eq 'master'>
	<cfset local.currentReleaseType = $.slatwall.rbKey('define.master') />
<cfelseif rc.currentBranch eq 'hotfix'>
	<cfset local.currentReleaseType = $.slatwall.rbKey('define.hotfix') />
<cfelse>
	<cfset local.currentReleaseType = $.slatwall.rbKey('define.develop') />
</cfif>

<cfoutput>
	<div class="row s-body-nav">
	    <nav class="navbar navbar-default" role="navigation">
	      <div class="col-md-4 s-header-info">
				<!--- Page Title --->
				<h1 class="actionbar-title">#$.slatwall.rbKey('admin.main.update')#</h1>
			</div>
		 </div>
	   </nav>
	</div>
	<hb:HibachiPropertyList divClass="col-md-12">
		<div class="s-no-tab-wrapper">
			<h3>#$.slatwall.rbKey('admin.main.update.backup')#</h3>
			<hr />
			<hb:HibachiFieldDisplay title="#$.slatwall.rbKey('admin.main.update.currentVersion')#" value="#rc.currentVersion#" />
			<cfif rc.currentBranch eq 'master'>
				<hb:HibachiFieldDisplay title="#$.slatwall.rbKey('admin.main.update.currentReleaseType')#" value="#$.slatwall.rbKey('admin.main.update.stable')#" />
			<cfelse>
				<hb:HibachiFieldDisplay title="#$.slatwall.rbKey('admin.main.update.currentReleaseType')#" value="#$.slatwall.rbKey('admin.main.update.bleedingEdge')#" />
			</cfif>
			<hb:HibachiFieldDisplay title="#$.slatwall.rbKey('admin.main.update.availableStableVersion')#" value="#rc.availableMasterVersion#" />
			<hb:HibachiFieldDisplay title="#$.slatwall.rbKey('admin.main.update.availableBleedingEdgeVersion')#" value="#rc.availableDevelopVersion#" />
			<hr />
			<form method="post" action="?s=1" class="s-update-branch">
				<input type="hidden" name="slatAction" value="admin:main.update" />
				<input type="hidden" name="process" value="1" />

				
				<!--- Custom Branch --->
				<cfif $.slatwall.setting('globalAllowCustomBranchUpdates')>
					<div class="form-group">
						<label class="col-xs-2 control-label"><input type="radio" name="branchType" value="custom" /></label>
						<input type="text" class="col-xs-10" name="customBranch" value="" placeholder="Custom Branch (ex: feature-newadmin)" /><br />
					</div>
				</cfif>
				
				<!--- Standard --->
				<div class="form-group">
					<label class="col-xs-2 control-label"><input type="radio" name="branchType" value="standard" checked="checked" /></label>
					<div class="col-xs-10" style="padding:0px;">
						<select name="updateBranch" class="form-control j-custom-select">
							<cfloop array="#local.updateOptions#" index="local.updateOption">
								<option value="#local.updateOption.value#" <cfif rc.currentBranch eq local.updateOption.value>selected="selected"</cfif>>#local.updateOption.name#</option>
							</cfloop>
						</select>
					</div>
				</div>
				

				<button class="btn adminmainupdate btn-primary" title="#$.slatwall.rbKey('admin.main.update_title')#" type="submit">#$.slatwall.rbKey('admin.main.update_title')#</button>
			</form>
		</div>
	</hb:HibachiPropertyList>
</cfoutput>
