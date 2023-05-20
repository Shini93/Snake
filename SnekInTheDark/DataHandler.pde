JSONObject json; //<>//

void initJson() {
  //log.append("initJson");
  String filePath = getJsonPath();
  if (isAndroid == true) {
    File file = new File(filePath);
    if (file.exists() == true) {
      datahandler.readJson(filePath);      //reads variables from json like food eaten and snakes bought
      return;
    }
    datahandler.savetoJson(filePath);
    return;
  }
  //On pc
  Path path = Paths.get(filePath);
  if (Files.exists(path) == true)
    datahandler.readJson(filePath);
  else
    datahandler.savetoJson(filePath);
}

String getJsonPath() {
  //log.append("getJsonPath");
  String path = "savestate.json";
  if (isAndroid == false)
    path = sketchPath("data/"+path);
  else
    path = sketchPath(path);
  return path;
}

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
  void savetoJson(String path) {
    //log.append("savetoJson");
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
    progress.setInt("maxLevel", maxReachedLvl);

    //available skins
    JSONObject skins = new JSONObject();
    skins.setInt("SnakeColorSelected", SnakeColorSelected);
    for (int i=0; i<SnakeColor.length; i++)
      skins.setBoolean("Skin_"+i, boughtItems[i]);

    JSONObject upgrades =  new JSONObject();
    String[] upgradeNames = {"maxSpeed", "maxRockets", "maxMiniSnakes", "MiniMovement", "upgradeProcessing", "FurtherSight", "BroaderSight"};
    for (int i=0; i<boughtUpgrades.length; i++)
      upgrades.setInt(upgradeNames[i], boughtUpgrades[i]);

    ////saves JSONArray
    values.setJSONObject(0, progress);
    values.setJSONObject(1, skins);
    values.setJSONObject(2, upgrades);

    if (    saveJSONArray(values, path) == false) {
      exit();
    } else {
      println("saving worked");
    }
  }

  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  void readJson(String path) {
    //log.append("readJson");
    //better way
    //JSONObject test = loadJSONObject(path);
    //test = test.getJSONObject("progress");
    //println(test.getInt("maxFood"));
    
    //depricated
    JSONArray values = loadJSONArray(path);

    JSONObject progress = values.getJSONObject(0);
    maxFood = progress.getInt("maxFood");
    println("ergebnis ist   "+maxFood);
    maxReachedLvl = byte(progress.getInt("maxLevel"));

    JSONObject skins = values.getJSONObject(1);
    SnakeColorSelected = skins.getInt("SnakeColorSelected");

    for (int i=0; i<SnakeColor.length; i++)
      boughtItems[i] = skins.getBoolean("Skin_"+i);

    JSONObject upgrades = values.getJSONObject(2);
    String[] upgradeNames = {"maxSpeed", "maxRockets", "maxMiniSnakes", "MiniMovement", "upgradeProcessing", "FurtherSight", "BroaderSight"};
    for (int i=0; i<upgradeNames.length; i++)
      boughtUpgrades[i] = upgrades.getInt(upgradeNames[i]);
  }

}
