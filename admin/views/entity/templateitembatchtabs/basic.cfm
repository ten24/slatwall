<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.templateItemBatch" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<span ng-init="replacementFlag=#rc.templateItemBatch.getReplacementFlag()#" style="display:none;"></span>
			<hb:HibachiPropertyDisplay object="#rc.templateItemBatch#" property="templateItemBatchName" edit="#rc.edit#">
			<cfif NOT rc.templateItemBatch.getNewFlag() >
				<hb:HibachiPropertyDisplay object="#rc.templateItemBatch#" property="templateItemBatchStatusType" edit="false" />
			</cfif>
			
			<hb:HibachiPropertyDisplay object="#rc.templateItemBatch#" property="replacementFlag" fieldAttributes="ng-model='replacementFlag'" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay 
				object="#rc.templateItemBatch#" 
				property="removalSku" 
				fieldType="typeahead"
				autocompleteNameProperty="skuName"
				autocompletePropertyIdentifiers="skuName,skuCode"
				edit="#rc.edit#" />
			<div ng-cloak ng-show="replacementFlag == true || (#rc.templateItemBatch.getReplacementFlag()# && !#rc.edit#)">
				<hb:HibachiPropertyDisplay 
					object="#rc.templateItemBatch#" 
					property="replacementSku"
					fieldType="typeahead"
					autocompleteNameProperty="skuName"
					autocompletePropertyIdentifiers="skuName,skuCode"
					edit="#rc.edit#" />
			</div>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
	
</cfoutput>