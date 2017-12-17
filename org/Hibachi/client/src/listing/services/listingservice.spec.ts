/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {ListingService} from "./listingservice";

describe('listingService Test',()=>{
    var listingService:ListingService;
    var collectionConfigService;
    var $httpBackend:ng.IHttpBackendService;

    beforeEach(()=>{
        angular.mock.module('hibachi.listing');
        angular.mock.inject((_listingService_)=>{
            // The injector unwraps the underscores (_) from around the parameter names when matching
            listingService = _listingService_;
            console.log(listingService);
        });
    });

    var listingID = 'testlistingID';

   


});