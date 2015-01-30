describe('Unit Test: Slatwall NgTest Controller', function() {
  // Load the module with MyMainController
  beforeEach(module("slatwalladmin"));

  var ctrl, scope;
  // inject the $controller and $rootScope services in the beforeEach block
  beforeEach(inject(function($controller, $rootScope) {
    // Create a new scope that's a child of the $rootScope
	  scope = $rootScope.$new();
	  // Create the controller
	  ctrl = $controller('ngtest', {
		  $scope: scope
	  });
  }));

  //Test.
  it('should define a copy of  slatwall, and add to scope test', 
    function() {
      expect(scope.test).toEqual("Slatwall Test Runner");//Before running function
      scope.defineTest(); //Modifies it.
      expect(scope.test).toEqual("Slatwall Test Runner Works");
  });
})