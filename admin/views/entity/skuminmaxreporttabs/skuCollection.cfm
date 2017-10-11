<cfparam name="rc.SkuMinMaxReport" type="any" />
<cfoutput>
    <sw-listing-display data-base-entity-name="Sku"
                        data-multi-slot="true"
                        data-has-action-bar="false"
                        data-has-search="true"
                        data-record-detail-action="admin:entity.detailsku"
                        data-record-edit-action="admin:entity.editsku"
                        data-is-angular-route="false"
                        data-angular-links="false">

        <sw-listing-columns>
            <sw-listing-column data-property-identifier="skuCode"></sw-listing-column>
        </sw-listing-columns>

        <sw-collection-configs>
            <sw-collection-config data-entity-name="sku"
                                  data-parent-directive-controller-as-name="swListingDisplay"
                                  data-parent-deferred-property="singleCollectionDeferred"
                                  data-collection-config-property="skuCollectionConfig"
                                  data-filter-flag="true">

                <sw-collection-columns>
                    <sw-collection-column data-property-identifier="skuID" data-is-exportable="true"  data-is-visible="false"></sw-collection-column>
                    <sw-collection-column data-property-identifier="skuCode" data-is-exportable="false"></sw-collection-column>
                </sw-collection-columns>

            </sw-collection-config>
        </sw-collection-configs>
    </sw-listing-display>
</cfoutput>
