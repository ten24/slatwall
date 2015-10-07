/**
 * This directive will create a form logging in a user.
 * 
 */
angular.module('slatwalladmin').directive('swfLogin', [
        '$slatwall',
        'ProcessObject',
        function($slatwall, ProcessObject) {
            return {
                restrict: 'E',
                transclude: true,
                scope: false,
                templateUrl: '/admin/client/partials/frontend/swfLoginPartial.html',
                replace: false,
                link: 
                        function(scope, element, attrs) {
                         console.log("Instantiated Front-end login directive");   
                         var entityName = "account";
                         var pObject = "login";
                         var processObject = ProcessObject.get({ entityName: entityName, processObject: pObject }, function() {
                                console.log(processObject);
                         }); // get() returns a single entry
                            
                         /*var entries = ProcessObject.query(function() {
                            console.log(entries);
                         }); //query() returns all the entries*/
                        
                         scope.login = new ProcessObject().processObject; //You can instantiate resource class
                         console.log(scope.login);
                        /*
                         scope.entry.data = 'some data';
                        
                         processObject.save(scope.entry, function() {
                            //data saved. do something here.
                         }); //saves an entry. Assuming $scope.entry is the Entry object  
                           */ 
                        }
            };
        }
    ]);