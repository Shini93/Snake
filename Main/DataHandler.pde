JSONObject json;
class DataHandler{
 
  //TODO: Handles levelprogress
  //TODO: Handles Upgrades
  //TODO: Handles stuff to buy
  //TODO: Handles bought stuff
  
  DataHandler(){
    
    
  }

  void savetoJson(){
    json = new JSONObject();
    json.setInt("maxFood", maxFood);
    json.setInt("maxLevel", maxLevel);
    json.setInt("colorSnakeRed",colorSnake[0]);
    json.setInt("colorSnakeGreen",colorSnake[1]);
    json.setInt("colorSnakeBlue",colorSnake[2]);
    saveJSONObject(json, "data/savestate.json");
  }
  
  void readJson(){
    json = loadJSONObject("data/savestate.json");
    if (json == null)
      return;
    maxFood = json.getInt("maxFood");
    maxLevel = json.getInt("maxLevel");
    colorSnake[0] = json.getInt("colorSnakeRed");
    colorSnake[1] = json.getInt("colorSnakeGreen");
    colorSnake[2] = json.getInt("colorSnakeBlue");
  }  
}
