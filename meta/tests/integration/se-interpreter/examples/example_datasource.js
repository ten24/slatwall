exports.name = 'example';
exports.load = function(cfg, scriptPath) {
  return [{'examplekey': 'examplevalue'}]; // Return a single row with a single column, "examplekey", containing "examplevalue".
};