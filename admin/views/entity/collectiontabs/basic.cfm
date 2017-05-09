<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.collection" type="any">
<cfparam name="rc.edit" type="boolean">

<cfset mergeCollectionCollection = request.slatwallScope.getService('hibachiService').getCollectionCollectionList() />
<cfset mergeCollectionCollection.setDisplayProperties('collectionID,collectionName') />
<cfset mergeCollectionCollection.addFilter('collectionID', rc.collection.getCollectionID(), '!=') />
<cfset mergeCollectionCollection.addFilter('collectionObject', rc.collection.getCollectionObject()) />
<cfset mergeCollectionCollection.addOrderBy('collectionName') />

<cfoutput>
	<div class="col-md-6">
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<hb:HibachiPropertyDisplay object="#rc.collection#" property="collectionName" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.collection#" property="collectionObject" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.collection#" property="collectionDescription" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.collection#" property="collectionCode" edit="#rc.edit#">
				<cfif !isNull(rc.collection.getParentCollection())>
					<hb:HibachiPropertyDisplay object="#rc.collection#" property="parentCollection" edit="false" valueLink="/?slatAction=entity.detailcollection&collectionID=#rc.collection.getParentCollection().getCollectionID()#" >
				</cfif>
				<hb:HibachiPropertyDisplay title="Merge Collection" object="#rc.collection#" property="mergeCollection" fieldType="select" valueOptions="#mergeCollectionCollection.getOptionsByPropertyNames('collectionName','collectionID', true)#" edit="#rc.edit#">
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
	</div>
</cfoutput>
