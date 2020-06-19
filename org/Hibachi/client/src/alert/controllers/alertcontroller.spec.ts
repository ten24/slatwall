/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {AlertController} from "./alertcontroller";

describe('AlertController',()=>{

    beforeEach(angular.mock.module('hibachi.alert'));

    var $controller;

    beforeEach(inject((_$controller_)=>{
        $controller = _$controller_;
    }));
    describe('$scope.alerts',()=>{
        var $scope:any, controller:AlertController;
        beforeEach(()=>{
            $scope = {};
            controller = $controller('alertController',{$scope:$scope});
        });

        it('addAlerts test',()=>{
            expect($scope.alerts.length).toBe(0);
        });
    });

});