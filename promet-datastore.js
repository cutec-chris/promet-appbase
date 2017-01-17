function newPrometDataStore(aName,aSheme) {
  var aDS = new dhtmlXDataStore({ datatype:"json" });
  aDS.TableName = aName;
  if (aSheme) {
    aDS.data.sheme(aSheme);
  }
  /*
  aDS.attachEvent("onAfterAdd", function(id) {
    console.log('new Record');
  });
  aDS.attachEvent("onAfterDelete",function(id) {
    console.log('deleted Record');
  });
  */
  aDS.attachEvent("onStoreUpdated", function(id, data, mode){
    console.log('updated Record');
  });
  aDS.attachEvent("onDataRequest", function(start, count){
    console.log('Data Request');
  });
  aDS.attachEvent("onAfterCursorChange", function(id){
    console.log('Cursor changed');
  });
  return aDS;
}
