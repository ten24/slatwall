<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.attribute" type="any">
<cfparam name="rc.edit" type="boolean">
<cfoutput>
	<span ng-init="relatedObjectCollectionConfig=$root.hibachiScope.$injector.get('collectionConfigService').newCollectionConfig().loadJson(#rereplace(rc.attribute.getRelatedObjectCollectionConfig(),'"',"'",'all')#)"></span>
	
	<sw-listing-display
		ng-if="relatedObjectCollectionConfig.collectionConfigString"
	    data-collection-config="relatedObjectCollectionConfig"
	    data-has-search="true"
	    data-has-action-bar="false"
	    data-show-filters="true"
	    show-simple-listing-controls="false"
	    data-multi-slot="false"
	>
	</sw-listing-display>
	<input name="relatedObjectCollectionConfig" ng-model="relatedObjectCollectionConfig.collectionConfigString" ng-show="false"/>
</cfoutput>
 
