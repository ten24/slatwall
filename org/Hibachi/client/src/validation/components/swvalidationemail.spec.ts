/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


import {SWValidationEmail} from "./swvalidationemail";

class test{
    constructor(

    ){
        describe('swvalidationemail Test',()=>{
            var $compile,$rootScope;
            beforeEach(()=>{
                angular.module('ngAnimate',[]);
                angular.module('ngSanitize',[]);
                angular.module('ui.bootstrap',[]);
                angular.module('hibachi.core',['ngAnimate','ngSanitize','ui.bootstrap']);
                angular.mock.module('hibachi.validation');


            });

            beforeEach(angular.mock.inject((_$compile_,_$rootScope_)=>{
                $compile = _$compile_;
                $rootScope = _$rootScope_;
            }));
            it('test something',()=>{
                var element:ng.IAugmentedJQuery;

                element = $compile('<input sw-validation-email value="ryan.marchand@ten24web.com"/>')($rootScope);
                $rootScope.$digest();

                console.info('test');
                angular.mock.dump(element.attr('sw-validation-email-valid'));
               // expect(element.attr('sw-validation-email-valid')).toContain('sw-validation-email-valid');
            });
        });
    }
}
new test();