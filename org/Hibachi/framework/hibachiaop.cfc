component extends="framework.aop" {
   //extension points for aop/ioc as seen on http://framework-one.github.io/documentation/using-di-one.html#overriding-di1-behavior
   
   //this is called for each bean after its dependencies have been injected prior to calling initMethod (if specified).
   private void function setupInitMethod( string name, any bean ){
        super.setupInitMethod(argumentCollection=arguments);
   }
   
   //this is called to construct each CFC: the default implementation is return createObject( "component", dottedPath );.
   private any function construct( string dottedPath ){
        return super.construct(argumentCollection=arguments);
   }
   
   /*this is called to obtain the metdata for each CFC: the default implementation is return getComponentMetadata( dottedPath ); 
   although it wraps that in try/catch and attempts to provide a more useful exception message in the case that 
   getComponentMetadata() fails. An example from Adam Tuttle is the ability to silently ignore beans that have syntax errors 
   during development, so the rest of the beans are loaded: you would override metadata() and have it wrap a call 
   to super.metadata( dottedPath ) in try/catch and return an empty struct if an exception is thrown.
   */
   private any function metadata( string dottedPath ){
        return super.metadata(argumentCollection=arguments);
   }
   
   //this is called from missingBean() to log DI/1’s inability to find a dependency: the default implementation writes a 
   //message to the application server’s console log.
   private void function logMissingBean( string beanName, string resolvingBeanName = "" ){
        super.logMissingBean(argumentCollection=arguments);
   }
   
   //this is called when DI/1 cannot find a dependency and, new in FW/1 4.0 / DI/1 1.2, also when getBean() 
   //cannot find the specified bean. The default implementation is explained below.
   private any function missingBean( string beanName, string resolvingBeanName = "", boolean dependency = true ){
        return super.missingBean(argumentCollection=arguments);
   }
}