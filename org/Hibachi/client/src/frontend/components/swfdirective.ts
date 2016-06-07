/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWFDirectiveController{
    private hibachiScope;
    //@ngInject
    constructor(private $log, private frontendPartialsPath, public $rootScope){
        this.$rootScope         = $rootScope;
        this.hibachiScope       = this.$rootScope.hibachiScope;
    } 
}

class SWFDirective implements ng.IDirective{
    
    public restrict:string = 'E';
    public scope : any;
    public bindToController={
		variables:"=",
		directive:"=",
        templateUrl:"@"
    };
    public controller=SWFDirectiveController
    public controllerAs="SWFDirective";
    public templatePath:string = "";
    public url:string = "";
    public $compile;
	public path:string;
	
    // @ngInject
    constructor(hibachiPathBuilder, private frontendPartialsPath:any, $compile){
        this.templatePath = hibachiPathBuilder.buildPartialsPath(frontendPartialsPath);
        this.url = hibachiPathBuilder.buildPartialsPath(frontendPartialsPath)+'swfdirectivepartial.html';
		this.$compile = $compile;
    }
    
    /** allows you to build a directive without using another controller and directive config. */
    // @ngInject
	public link:ng.IDirectiveLinkFn = (scope:ng.IScope, element: ng.IAugmentedJQuery, attrs:any) =>{
        this.scope = scope;
        this.path  = attrs.partialPath || this.templatePath;
        //Developer specifies the path and name of a partial for creating a custom directive.
        if (attrs.partialName){
            //returns the attrs.path or the default if not configured.
            var template = "<span ng-include = " + "'\"" + this.path + attrs.partialName +  ".html\"'" + "></span>";
            element.html('').append(this.$compile(template)(scope));
        //Recompile a directive either as attribute or element directive
        }else{
            //this.templateUrl = this.url;
            if (!attrs.type) { attrs.type = "A"}
            if (attrs.type == "A" || !attrs.type){
                var template = '<span ' + attrs.directive + ' ';
                if(angular.isDefined(this.scope.variables)){
                    angular.forEach(this.scope.variables, function(value,key){
                        template += ' ' + key + '=' + value + ' ';
                    });
                }
                template += + '>';
                template += '</span>';
            }else{
                var template = '<' + attrs.directive + ' ';
                if(this.scope.variables){
                    angular.forEach(this.scope.variables, function(value,key){
                        template += ' ' + key + '=' + value + ' ';
                    });
                }
                template += + '>';
                template += '</'+ attrs.directive +'>'; 
            }
            
            // Render the template.
            element.html('').append(this.$compile(template)(scope));
        }
	}
    
    
    public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    hibachiPathBuilder,
			frontendPartialsPath,
			$compile
        ) => new SWFDirective(
            hibachiPathBuilder,
			frontendPartialsPath,
			$compile
        );
        directive.$inject = [
            'hibachiPathBuilder',
            'frontendPartialsPath',
            '$compile'
        ];
        return directive;
    }
}
export {SWFDirectiveController, SWFDirective};
	
	
