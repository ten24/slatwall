/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {coremodule} from '../core/core.module';
//services

import {CollectionConfig} from "./services/collectionconfigservice";
import {CollectionService} from "./services/collectionservice";
//controllers
import {CollectionController} from "./controllers/collections";
import {CreateCollection} from "./controllers/createcollection";
import {ConfirmationController} from "./controllers/confirmationcontroller";
import {CollectionCreateController} from "./controllers/entity_createcollection";
//directives
import {SWCollection} from "./components/swcollection";
import {SWAddFilterButtons} from "./components/swaddfilterbuttons";
import {SWDisplayOptions} from "./components/swdisplayoptions";
import {SWDisplayItem} from "./components/swdisplayitem";
import {SWDisplayItemAggregate} from "./components/swdisplayitemaggregate";
import {SWCollectionTable} from "./components/swcollectiontable";
import {SWColumnItem} from "./components/swcolumnitem";
import {SWConditionCriteria} from "./components/swconditioncriteria";
import {SWCriteria} from "./components/swcriteria";
import {SWCriteriaBoolean} from "./components/swcriteriaboolean";
import {SWCriteriaDate} from "./components/swcriteriadate";
import {SWCriteriaManyToMany} from "./components/swcriteriamanytomany";
import {SWCriteriaManyToOne} from "./components/swcriteriamanytoone";
import {SWCriteriaNumber} from "./components/swcriterianumber";
import {SWCriteriaOneToMany} from "./components/swcriteriaonetomany";
import {SWCriteriaRelatedObject} from "./components/swcriteriarelatedobject";
import {SWCriteriaString} from "./components/swcriteriastring";
import {SWEditFilterItem} from "./components/sweditfilteritem";
import {SWFilterGroups} from "./components/swfiltergroups";
import {SWFilterItem} from "./components/swfilteritem";
import {SWFilterGroupItem} from "./components/swfiltergroupitem";

var collectionmodule = angular.module('hibachi.collection',[coremodule.name])
.config([()=>{

}]).run([()=>{

}])
//constants
.constant('collectionPartialsPath','collection/components/')
//controllers
.controller('collections',CollectionController)
.controller('confirmationController',ConfirmationController)
.controller('createCollection',CreateCollection)
.controller('entity_createcollection',CollectionCreateController)
//services
.factory('collectionConfigService', ['rbkeyService','$hibachi','utilityService','observerService', (rbkeyService,$hibachi: any,utilityService, observerService) => new CollectionConfig(rbkeyService,$hibachi,utilityService,observerService)])
.service('collectionService', CollectionService)
//directives
.directive('swCollection',SWCollection.Factory())
.directive('swAddFilterButtons',SWAddFilterButtons.Factory())
.directive('swDisplayOptions',SWDisplayOptions.Factory())
.directive('swDisplayItem',SWDisplayItem.Factory())
.directive('swDisplayItemAggregate',SWDisplayItemAggregate.Factory())
.directive('swCollectionTable',SWCollectionTable.Factory())
.directive('swColumnItem',SWColumnItem.Factory())
.directive('swConditionCriteria',SWConditionCriteria.Factory())
.directive('swCriteria',SWCriteria.Factory())
.directive('swCriteriaBoolean',SWCriteriaBoolean.Factory())
.directive('swCriteriaDate',SWCriteriaDate.Factory())
.directive('swCriteriaManyToMany',SWCriteriaManyToMany.Factory())
.directive('swCriteriaManyToOne',SWCriteriaManyToOne.Factory())
.directive('swCriteriaNumber',SWCriteriaNumber.Factory())
.directive('swCriteriaOneToMany',SWCriteriaOneToMany.Factory())
.directive('swCriteriaRelatedObject',SWCriteriaRelatedObject.Factory())
.directive('swCriteriaString',SWCriteriaString.Factory())
.directive('swEditFilterItem',SWEditFilterItem.Factory())
.directive('swFilterGroups',SWFilterGroups.Factory())
.directive('swFilterItem',SWFilterItem.Factory())
.directive('swFilterGroupItem',SWFilterGroupItem.Factory())

//filters

;
export{
	collectionmodule
}