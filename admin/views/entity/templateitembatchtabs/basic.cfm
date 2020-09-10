<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.templateItemBatch" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.templateItemBatch#" property="templateItemBatchName" edit="#rc.edit#">
			<cfif NOT rc.templateItemBatch.getNewFlag() >
				<hb:HibachiPropertyDisplay object="#rc.templateItemBatch#" property="templateItemBatchStatusType" edit="false" />
			</cfif>
			<hb:HibachiPropertyDisplay 
				object="#rc.templateItemBatch#" 
				property="removalSku" 
				fieldType="typeahead"
				autocompleteNameProperty="skuName"
				autocompletePropertyIdentifiers="skuName,skuCode"
				edit="#rc.edit#" />
			<hb:HibachiPropertyDisplay 
				object="#rc.templateItemBatch#" 
				property="replacementSku"
				fieldType="typeahead"
				autocompleteNameProperty="skuName"
				autocompletePropertyIdentifiers="skuName,skuCode"
				edit="#rc.edit#" />
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
	
</cfoutput>