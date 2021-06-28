component accessors="true" extends="Slatwall.model.transient.HibachiTransient" {
    
    property name="checkpoints" type="array";
    property name="processedData" type="struct" hint="Data that represents collected and generated data by the profiler";
    
    // @hint Primary method used to gather checkpoints for later profiling and analysis
    // @blockName Top-level name for logical grouping of related checkpoints to provide context which allow performance analysis of arbitrary and isolated areas of functionality
    // @description Description used for more meaningful message generation
    // @tags Allows for many ways to categor
    public void function addCheckpoint(required string blockName="Default", string description="", string tags="", any object) {
        if (!structKeyExists(variables, 'checkpoints')) {
            variables.checkpoints = [];
        }
        
        // Sequence number preserves chronological execution order no matter how data might be manipulated or arranged
        arguments.sequenceNumber = arrayLen(variables.checkpoints) + 1;
        arguments.tickCount = getTickCount();
        
        arrayAppend(variables.checkpoints, arguments);
    }
    
    // @hint Data structure containing all relevant profiling data in a processed state. In the future this could be consumed by client-side component fpr visualization
    public struct function getProcessedData() {
        // Initialize default data structure
        // For now let's only track request statistics. 
        // NOTE: In the future could include information about hibachi framework/application, hibachi cache, jvm runtime system envinronment, orm, entity queue, sessions, stack trace, and any other convention derived stats (validation, calculated properties, save, process, etc)
        if (!structKeyExists(variables, 'processedData')) {
            var processedData = {};
            processedData.requestData = {};
            processedData.requestData.threadID = '';
            processedData.requestData.checkpointBlocks = {};
            processedData.requestData.profilerMessages = [];
            
            variables.processedData = processedData;
        }
        
        return variables.processedData;
    }
    
    // @hint Performs processing of raw profiler data to generate statistics and update 'processedData' variable. Runs once per request.
    private void function processRawData() {
        if (!structKeyExists(variables, 'processRawDataExecuted')) {
            variables.processRawDataExecuted = true;
            
            var processedData = getProcessedData();
            
            // Preserves chronological ordering of checkpoint blocks
            var checkpointBlockNameOrder = [];
            
            // Further organize checkpoints by grouping them by by their block name
            if (!isNull(getCheckpoints())) {
                for (var checkpoint in getCheckpoints()) {
                    if (!structKeyExists(processedData.requestData.checkpointBlocks, checkpoint.blockName)) {
                        
                        // Initialize the checkpointBlock data structure
                        processedData.requestData.checkpointBlocks[checkpoint.blockName] = {
                            checkpoints = []
                        };
                        
                        // Checkpoint block may have an entity object associated with it
                        if (structKeyExists(checkpoint, 'object') && checkpoint.object.isPersistent()) {
                            processedData.requestData.checkpointBlocks[checkpoint.blockName].entity = checkpoint.object;
                        }
                        
                        // Preserve the ordering of the blockName
                        arrayAppend(checkpointBlockNameOrder, checkpoint.blockName);
                    }
                    
                    arrayAppend(processedData.requestData.checkpointBlocks[checkpoint.blockName].checkpoints, checkpoint);
                }
                
                // Generate descriptive messages for checkpoints in chronological order
                for (var checkpointBlockName in checkpointBlockNameOrder) {
                    
                    var checkpointBlock = processedData.requestData.checkpointBlocks[checkpointBlockName];
                    
                    // Must have at least two checkpoints to calculate at least one minimum duration between interval
                    if (arrayLen(checkpointBlock.checkpoints) >= 2) {
                        for (var c = 1; c <= arrayLen(checkpointBlock.checkpoints) - 1; c++) {
                            var beginCheckpoint = checkpointBlock.checkpoints[c];
                            var endCheckpoint = '';
                            
                            // Total elapsed duration for entire checkpoint block
                            if (c == 1) {
                                // Check if there is any additional entity information
                                if (structKeyExists(checkpointBlock, 'entity')) {
                                    arrayAppend(processedData.requestData.profilerMessages, '#checkpointBlockName# - entityName: #checkpointBlock.entity.getClassName()#, #checkpointBlock.entity.getPrimaryIDPropertyName()#: #checkpointBlock.entity.getPrimaryIDValue()#');
                                }
                                
                                endCheckpoint = checkpointBlock.checkpoints[arrayLen(checkpointBlock.checkpoints)];
                                arrayAppend(processedData.requestData.profilerMessages, '#checkpointBlockName# - Total Duration - Time elapsed: #(endCheckpoint.tickCount - beginCheckpoint.tickCount) / 1000# sec');
                            }
                            
                            // Elapsed duration between each checkpoint interval
                            if (arrayLen(checkpointBlock.checkpoints) > 2) {
                                endCheckpoint = checkpointBlock.checkpoints[c + 1];
                                
                                // Setup up default checkpoint descriptions if necessary
                                var beginDescription = len(beginCheckpoint.description) ? beginCheckpoint.description : 'Checkpoint #c#';
                                var endDescription = len(endCheckpoint.description) ? endCheckpoint.description : 'Checkpoint #c + 1#';
                                
                                arrayAppend(processedData.requestData.profilerMessages, "#checkpointBlockName# - Period - Time elapsed: #(endCheckpoint.tickCount - beginCheckpoint.tickCount) / 1000# sec - '#beginDescription#' to '#endDescription#'");
                            }
                        }
                    }
                }
            }
        }
    }
    
    private any function getThreadClass() {
        try{
			var threadClass = createObject("java", "java.lang.Thread");
		//java 7
		}catch(any e){
			var threadClass = createObject("java", "java.lang.thread");
		}
		
		return threadClass;
    }
    
    // @hint Writes profiler information to Hibachi log output
    public void function logProfiler() {
        if (!isNull(getCheckpoints()) && arrayLen(getCheckpoints())) {
            // Verify raw data has been processed
            processRawData();
            
            // Thread info
            var threadClass = getThreadClass().currentThread();
            var threadID = threadClass.getId();
            var threadName = threadClass.getName();
            
            // Initialize request counter (FW/1 init resets value)
    		if (!getHibachiScope().hasApplicationValue('profilerRequestCount')) {
    			getHibachiScope().setApplicationValue('profilerRequestCount', 0);
    		}
    		
    		// Increment request counter
    		var profilerRequestCount = getHibachiScope().getApplicationValue('profilerRequestCount') + 1;
    		getHibachiScope().setApplicationValue('profilerRequestCount', profilerRequestCount);
    		
    		// FW/1 action
    		var action = request.action;
    		if (structKeyExists(request.context, 'entityName')) {
    		    action &= '&entityName=#request.context.entityName#';
    		} else if (structKeyExists(request.context, 'processContext')) {
    		    action &= '&processContext=#request.context.processContext#';
    		}
            
            var logPrefix = "Profiler Log (R#profilerRequestCount#)";
            
            // Output to log
            logHibachi(message="Start profiler logging", logPrefix=logPrefix);
            logHibachi(message="Action: #action#", logPrefix=logPrefix);
            logHibachi(message="Thread - id: #threadID#, threadName: '#threadName#'", logPrefix=logPrefix);
            logHibachi(message="HibachiScope.identityHashCode: #getHibachiScope().getIdentityHashCode()# memory object", logPrefix=logPrefix);
            for (var message in getProcessedData().requestData.profilerMessages) {
                logHibachi(message=message, logPrefix=logPrefix);
            }
            logHibachi(message="Finished profiler logging", logPrefix=logPrefix);
        }
    }
}