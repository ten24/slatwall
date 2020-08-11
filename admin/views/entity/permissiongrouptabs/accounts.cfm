<cfparam name="rc.permissionGroup" type="any" />
<cfoutput>

    <sw-listing-display data-base-entity-name="Account"
                        data-multi-slot="true"
                        data-has-action-bar="false"
                        data-has-search="true"
                        data-record-detail-action="admin:entity.detailaccount"
                        data-record-edit-action="admin:entity.editaccount"
                        data-is-angular-route="false"
                        data-angular-links="false">

        <sw-listing-columns>
            <sw-listing-column data-property-identifier="firstName"></sw-listing-column>
            <sw-listing-column data-property-identifier="lastName"></sw-listing-column>
            <sw-listing-column data-property-identifier="company"></sw-listing-column>
            <sw-listing-column data-property-identifier="primaryPhoneNumber.phoneNumber"></sw-listing-column>
            <sw-listing-column data-property-identifier="primaryEmailAddress.emailAddress"></sw-listing-column>
        </sw-listing-columns>

        <sw-collection-configs>
            <sw-collection-config data-entity-name="Account"
                                  data-parent-directive-controller-as-name="swListingDisplay"
                                  data-parent-deferred-property="singleCollectionDeferred"
                                  data-collection-config-property="collectionConfig"
                                  data-filter-flag="true">

                <sw-collection-columns>
                    <sw-collection-column data-property-identifier="accountID" data-is-exportable="true"  data-is-visible="false"></sw-collection-column>
                    <sw-collection-column data-property-identifier="firstName" data-is-exportable="false"></sw-collection-column>
                    <sw-collection-column data-property-identifier="lastName" data-is-exportable="false"></sw-collection-column>
                    <sw-collection-column data-property-identifier="company" data-is-exportable="false"></sw-collection-column>
                    <sw-collection-column data-property-identifier="primaryPhoneNumber.phoneNumber" data-is-exportable="false"></sw-collection-column>
                    <sw-collection-column data-property-identifier="primaryEmailAddress.emailAddress" data-is-exportable="false"></sw-collection-column>
                </sw-collection-columns>
				<sw-collection-filters>
					<sw-collection-filter data-hidden="true" data-property-identifier="permissionGroups.permissionGroupID" data-comparison-value="#rc.permissionGroup.getPermissionGroupID()#"></sw-collection-filter>
				</sw-collection-filters>

            </sw-collection-config>
        </sw-collection-configs>
    </sw-listing-display>

</cfoutput>
