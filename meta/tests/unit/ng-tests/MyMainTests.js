describe('MyMainController', function() {
  // Load the module with MyMainController
  beforeEach(module('MyModule'));

  var ctrl, scope;
  // inject the $controller and $rootScope services in the beforeEach block
  beforeEach(inject(function($controller, $rootScope) {
    // Create a new scope that's a child of the $rootScope
	  scope = $rootScope.$new();
	  // Create the controller
	  ctrl = $controller('MyMainController', {
		  $scope: scope
	  });
  }));

  //Test.
  it('should create $scope.greeting when calling sayHello', 
    function() {
      expect(scope.greeting).toBeUndefined();
      scope.sayHello();
      expect(scope.greeting).toEqual("Hello Ian");
  });
})