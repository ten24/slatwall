/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />

//modules
import {collectionmodule} from "../collection/collection.module";
//services
import {ListingService} from "./services/listingservice";
//directives
import {SWListingDisplay} from "./components/swlistingdisplay";
import {SWListingReport} from "./components/swlistingreport";
import {SWListingDisplayCell} from "./components/swlistingdisplaycell";
import {SWListingControls} from "./components/swlistingcontrols";
import {SWListingAggregate} from "./components/swlistingaggregate";
import {SWListingColorFilter} from "./components/swlistingcolorfilter";
import {SWListingColumn} from "./components/swlistingcolumn";
import {SWListingDisableRule} from "./components/swlistingdisablerule";
import {SWListingExpandableRule} from "./components/swlistingexpandablerule";
import {SWListingFilter} from "./components/swlistingfilter";
import {SWListingFilterGroup} from "./components/swlistingfiltergroup";
import {SWListingOrderBy} from "./components/swlistingorderby";
import {SWListingRowSave} from "./components/swlistingrowsave";
import {SWListingSearch} from "./components/swlistingsearch";
import {SWListingGlobalSearch} from "./components/swlistingglobalsearch";


var listingmodule = angular.module('hibachi.listing', [collectionmodule.name])
.run([function() {
}])
//services
.service('listingService', ListingService)
//directives
.directive('swListingDisplay',SWListingDisplay.Factory())
.directive('swListingReport',SWListingReport.Factory())
.directive('swListingControls',SWListingControls.Factory())
.directive('swListingAggregate',SWListingAggregate.Factory())
.directive('swListingColorFilter',SWListingColorFilter.Factory())
.directive('swListingColumn',SWListingColumn.Factory())
.directive('swListingDisableRule', SWListingDisableRule.Factory())
.directive('swListingExpandableRule', SWListingExpandableRule.Factory())
.directive('swListingDisplayCell',SWListingDisplayCell.Factory())
.directive('swListingFilter',SWListingFilter.Factory())
.directive('swListingFilterGroup',SWListingFilterGroup.Factory())
.directive('swListingOrderBy',SWListingOrderBy.Factory())
.directive('swListingRowSave', SWListingRowSave.Factory())
.directive('swListingSearch', SWListingSearch.Factory())
.directive('swListingGlobalSearch',SWListingGlobalSearch.Factory())
//constants
.constant('listingPartialPath','listing/components/')
;

export{
	listingmodule
}