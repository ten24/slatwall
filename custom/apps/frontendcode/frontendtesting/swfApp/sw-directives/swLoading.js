/**
 * This directive will show or hide a loading overlay on a section of code
    Usage: 
    <section>
    <div>
      <sw:loading on="myLoaderOn" off="myLoaderOff" attribute1=''...></sw:loading>
    </div>
    </section>
    
    The sw:loading directive will load an image with a translucent background that fills the 
    parent dom element.
    
    The directive is activated when the event given by your defined attribute name 'on' is called.
    For the above example, calling $scope.$emit("myLoaderOn") will turn the loader on, etc.
    
    Attributes and defaults:
      name = attrs.name || "swLoading";
      on = attrs.on || attrs.name + "On";
      off = attrs.off || attrs.name + "Off";
      image = attrs.image || "loading.gif";
      background = attrs.background || "#ffffff";
      opacity = attrs.opacity || ".8";
      color = attrs.color || "#000000";
      zindex = attrs.zindex || "100";
      borderRadius = attrs.borderRadius || '10px';
      marginTop = attrs.marginTop || '10px';
      position = attrs.position || 'absolute';
      xTop = attrs.top || "0";
      xLeft = attrs.left || "0";
      yBottom = attrs.bottom || "0";
      yRight = attrs.right || "0";
      
    */
angular.module('hibachiScope')
    .directive('swLoading', [
        '$slatwall',
        function($slatwall) {
            return {
                restrict: 'E',
                transclude: true,
                scope: false,
                replace: false,
                link: 
                    function(scope, element, attrs) {
                     
                      /** attribute options and default */
                      name = attrs.name;
                      on = attrs.on || attrs.name + "On";
                      off = attrs.off || attrs.name + "Off";
                      image = attrs.image || "http://placehold.it/350x150";
                      background = attrs.background || "#ffffff";
                      opacity = attrs.opacity || ".8";
                      color = attrs.color || "#000000";
                      zindex = attrs.zindex || "100";
                      borderRadius = attrs.borderRadius || "10px";
                      marginTop = attrs.marginTop || "10px";
                      position = attrs.position || "absolute";
                      xTop = attrs.top || "0";
                      xLeft = attrs.left || "0";
                      yBottom = attrs.bottom || "0";
                      yRight = attrs.right || "0";
                      var styleConfig = 
                        "style='position:"+position+";top:"+xTop+";left:"+xLeft+";bottom:"+yBottom+
                        ";right:"+yRight+";color:"+color+";background: "+background+" url("+image+") center center no-repeat; z-index: "+zindex+
                        "; border-radius: "+borderRadius+"; margin-top: "+marginTop+"; opacity: "+opacity+";'";
                        
                      var loadingOverlay = angular.element("<div class='"+name+"' "+styleConfig+"></div>");
                      
                      element.append(loadingOverlay);//add it.
                      element.hide();//hide it until we need it.
                     
                      /** end attribute options and default */
                      
                      console.log("Loading ", this.on, this.off);
                      
                      /**
                       * Shows the loading overlay
                       */
                      scope.showOverlay = function(data) {
                      	console.log("showing loader");
                        element.show();
                      }
                      
                      /**
                       * Removes the loading overlay
                       */
                      scope.hideOverlay = function(data){
                     	
                      	element.hide();
                      	console.log("removing loader");
                      	
                      }
                      
                      /** listeners for state control */
                      scope.$on(this.on, function(loading) { 
                      	scope.showOverlay();
                      });
                      scope.$on(this.off, function(unloading) { 
                        scope.hideOverlay();
                      });
                      	
                      
                        
                    }//<--end link
            };
        }
    ]);