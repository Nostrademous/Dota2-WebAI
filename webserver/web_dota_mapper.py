import json

class WebMapper():

    def __init__(self,trans_file="../web_data/dotabuff.json"):
        with open(trans_file) as ifile:
            self.mappings = json.load(ifile)

    def item_name(self, web_name):
        return "item_" + self.mappings["items"][web_name]
