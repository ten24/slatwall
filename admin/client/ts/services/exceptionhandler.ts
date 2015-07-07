loggingmodule
.provider(
	"$exceptionHandler",
	{ 
		$get: function( errorLoggingService ){ 
			return( errorLoggingService ); 
		}
	}
);