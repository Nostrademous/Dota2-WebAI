from pathlib import Path
import json

class GameData():
    game_data_json_dir = "../game_data"
    web_trans_file = "../web_data/dotabuff.json"

    def __init__(self,):
        files = Path(GameData.game_data_json_dir).glob("*.json")
        for filepath in files:
            with open(str(filepath)) as ifile:
                data = json.load(ifile)
                #print("{}".format(data))
                self.__dict__.update({filepath.stem : data})

        with open(GameData.web_trans_file) as ifile:
            self.mappings = json.load(ifile)

    def item_name(self, web_name):
        return "item_" + self.mappings["items"][web_name]

if __name__ == "__main__":
    gd = GameData()
