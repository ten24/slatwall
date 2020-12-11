<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.importermapping" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
    <span data-ng-controller="entity_createimportermapping as entity_createimportermappingCtrl" data-ng-init="entity_createimportermappingCtrl.selectedOption = 'Access'">
	<hb:HibachiEntityDetailForm object="#rc.importermapping#" edit="#rc.edit#">
		<hb:HibachiEntityActionBar type="detail" object="#rc.importermapping#" edit="#rc.edit#" />
		<div class="s-top-spacer">
			<hb:HibachiPropertyRow>
				
				<!--- inject angular here --->
				<cfset fieldAttributes = 'ng-model="entity_createimportermappingCtrl.selectedOption" ng-change="entity_createimportermappingCtrl.baseObjectChanged()"'/>
				<hb:HibachiPropertyList>
					<hb:HibachiPropertyDisplay object="#rc.importermapping#" property="name" edit="#rc.edit#">
					<hb:HibachiPropertyDisplay object="#rc.importermapping#" property="description" edit="#rc.edit#">
					<hb:HibachiPropertyDisplay object="#rc.importermapping#" property="baseObject" edit="#rc.edit#" fieldAttributes="#fieldAttributes#">
                    <hb:HibachiPropertyDisplay object="#rc.importermapping#" property="mapping" edit="#rc.edit#">

				</hb:HibachiPropertyList>
			</hb:HibachiPropertyRow>
		</div>
	</hb:HibachiEntityDetailForm>
	</span>
</cfoutput>