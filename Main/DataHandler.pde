JSONObject json;

/**********************
*Handles Savestates
**********************/
class DataHandler{
  //TODO: Handles Upgrades
  //TODO: Handles stuff to buy
  //TODO: Handles bought stuff
  
  DataHandler(){

  }

  void savetoJson(){
    String path = "savestate.json";
    if (isAndroid == false)
      path = "data/"+path;

    json = new JSONObject();
    json.setInt("maxFood", maxFood);
    json.setInt("maxLevel", maxLevel);
    json.setInt("SnakeColorSelected",SnakeColorSelected);
    for(int i=0;i<SnakeColor.length;i++)
      json.setBoolean("Skin_"+i,boughtItems[i]);
    saveJSONObject(json, path);

  }
  
  void readJson(){
    String path = "savestate.json";
    if (isAndroid == false)
      path = "data/"+path;

    json = loadJSONObject(path);
    if (json == null)
      return;
    maxFood = json.getInt("maxFood");
    maxLevel = json.getInt("maxLevel");
    SnakeColorSelected = json.getInt("SnakeColorSelected");
    
    for(int i=0;i<SnakeColor.length;i++)
      boughtItems[i] = json.getBoolean("Skin_"+i);
  }
}
