<cfparam name="rc.permissionGroup" type="any" />
<cfoutput>

    <sw-listing-display data-base-entity-name="PermissionRecordRestriction"
                        data-multi-slot="true"
                        data-has-action-bar="false"
                        data-has-search="true"
                        data-record-detail-action="admin:entity.detailpermissionrecordrestriction"
                        data-record-edit-action="admin:entity.editpermissionrecordrestriction"
                        data-is-angular-route="false"
                        data-angular-links="false">

        <sw-listing-columns>
            <sw-listing-column data-property-identifier="permission.entityClassName"></sw-listing-column>
            <sw-listing-column data-property-identifier="permissionRecordRestrictionName"></sw-listing-column>
        </sw-listing-columns>

    <sw-collection-configs>
    <sw-collection-config data-entity-name="PermissionRecordRestriction"
                          data-parent-directive-controller-as-name="swListingDisplay"
                          data-parent-deferred-property="singleCollectionDeferred"
                          data-collection-config-property="collectionConfig"
                          data-filter-flag="true">

        <sw-collection-columns>
            <sw-collection-column data-property-identifier="permissionRecordRestrictionID" data-is-exportable="true"  data-is-visible="false"></sw-collection-column>
            <sw-collection-column data-property-identifier="permission.entityClassName" data-is-exportable="false"></sw-collection-column>
            <sw-collection-column data-property-identifier="permissionRecordRestrictionName" data-is-exportable="false"></sw-collection-column>
        </sw-collection-columns>
    <sw-collection-filters>
            <sw-collection-filter data-hidden="true" data-property-identifier="permission.permissionGroup.permissionGroupID" data-comparison-value="#rc.permissionGroup.getPermissionGroupID()#"></sw-collection-filter>
</sw-collection-filters>

</sw-collection-config>
</sw-collection-configs>
</sw-listing-display>

</cfoutput>
