/** An example step executor factory that adds a single step type: "meow". */
exports.get = function(stepType) {
  if (stepType == "meow") {
    return {
      'run': function(tr, cb) {
        console.log("meow!");
        cb({'success': true});
      }
    };
  }
  
  return null;
};