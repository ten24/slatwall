<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />


<hb:HibachiListingDisplay
	collectionList="#rc.collection#"
	showSimpleListingControls="false"
	recordEditAction="admin:entity.edit#lcase(rc.collection.getCollectionObject())#"
	recordDetailAction="admin:entity.detail#lcase(rc.collection.getCollectionObject())#"
	collectionConfigFieldName="collectionConfig"
>
</hb:HibachiListingDisplay>

