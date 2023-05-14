JSONObject json;

/**********************
 *Handles Savestates
 **********************/
class DataHandler {
  //TODO: Handles Upgrades
  //TODO: Handles stuff to buy
  //TODO: Handles bought stuff

  DataHandler() {
  }

  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  void savetoJson() {
    String path = "savestate.json";
    if (isAndroid == false)
      path = "data/"+path;

    //json = new JSONObject();
    //json.setInt("maxFood", maxFood);
    //json.setInt("maxLevel", maxLevel);
    //json.setInt("SnakeColorSelected",SnakeColorSelected);
    //for(int i=0;i<SnakeColor.length;i++)
    //  json.setBoolean("Skin_"+i,boughtItems[i]);
    //saveJSONObject(json,path);

    JSONArray  values = new JSONArray();
    
    //progress in food and lvl reached
    JSONObject progress = new JSONObject();
    progress.setInt("maxFood", maxFood);
    progress.setInt("maxLevel", maxLevel);
    
    //available skins
    JSONObject skins = new JSONObject();
    skins.setInt("SnakeColorSelected", SnakeColorSelected);
    for (int i=0; i<SnakeColor.length; i++)
      skins.setBoolean("Skin_"+i, boughtItems[i]);
    
    JSONObject upgrades =  new JSONObject();
    String[] upgradeNames = {"maxSpeed","maxRockets","maxMiniSnakes","MiniMovement","upgradeProcessing","FurtherSight","BroaderSight"};
    for (int i=0; i<boughtUpgrades.length; i++)
      upgrades.setInt(upgradeNames[i],boughtUpgrades[i]);


    //saves JSONArray 
    values.setJSONObject(0, progress);
    values.setJSONObject(1, skins);
    values.setJSONObject(2, upgrades);
    saveJSONArray(values, path);
  }

  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  void readJson() {
    String path = "savestate.json";
    if (isAndroid == false)
      path = "data/"+path;
    JSONArray values = loadJSONArray(path);
    
    JSONObject progress = values.getJSONObject(0);
    maxFood = progress.getInt("maxFood");
    maxLevel = progress.getInt("maxLevel");
    
    JSONObject skins = values.getJSONObject(1);
    SnakeColorSelected = skins.getInt("SnakeColorSelected");

    for (int i=0; i<SnakeColor.length; i++)
      boughtItems[i] = skins.getBoolean("Skin_"+i);
      
    JSONObject upgrades = values.getJSONObject(2);
    String[] upgradeNames = {"maxSpeed","maxRockets","maxMiniSnakes","MiniMovement","upgradeProcessing","FurtherSight","BroaderSight"};
    for (int i=0; i<upgradeNames.length; i++)
      boughtUpgrades[i] = upgrades.getInt(upgradeNames[i]);
  }
}
