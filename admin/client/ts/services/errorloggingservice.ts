loggingmodule
.factory(
	"errorLoggingService", 
	["$log", "$window", "traceService",
	function($log, $window, traceService){ 
		function error( exception, cause ) { 
			//log to console
			$log.error.apply( $log, arguments );
							
			try { 
				var errorMessage = exception.toString(); 
				var stackTrace = traceService.print({e:exception}); 
								
				console.warn("HITAJAX"); 
								
				$.ajax({
					type: "POST", 
					url: "/builttofail", 
					contentType: "application/json", 
					data: angular.toJson({
						url: $window.location.href,
						message: errorMessage, 
						type: "exception",
						stackTrace: stackTrace,
						cause: ( cause || "")
					})
										
				});
								
			} catch ( loggingError ) { 
				$log.warn( "Error logging to server."); 
				$log.log( loggingError ); 
			}
		}
	return(error); 
	}]
);