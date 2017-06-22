from __future__ import print_function

from items import ItemKB

class Unit(object):
    def __init__(self, name, id, team, jsonData):
        self.jsonReply = None
    
        self.name   = name
        self.id     = id
        self.team   = team
        
        self.health     = jsonData['Health']
        self.max_health = jsonData['MaxHealth']
        
        self.mana       = jsonData['Mana']
        self.max_mana   = jsonData['MaxMana']
        
        self.move_speed = jsonData['MS']
        
        self.location   = (jsonData['X'], jsonData['Y'], jsonData['Z'])

    def __repr__(self):
        str = 'Unit ID: %d, %s - %s' % (self.id, self.name, self.team)
        str += '\tHealth: %d / %d\n' % (self.health, self.max_health)
        return str

class Hero(Unit):
    def __init__(self, name, id, team, jsonData):
        Unit.__init__(self, name, id, team, jsonData)
        self.health_regen   = jsonData['HealthReg']
        self.mana_regen     = jsonData['ManaReg']
        self.level          = jsonData['Level']
        self.gold           = jsonData['Gold']
        self.ability_pts    = jsonData['AP']
        self.next_abilities = jsonData['NextAbs']
        self.next_items     = jsonData['NextItems']
        
        self.items          = []
        for item in jsonData['Items']:
            self.items.append(item)
    
    def __repr__(self):
        str = 'Hero ID: %d, %s - %d :: %s\n' % (self.id, self.name, self.level, self.team)
        str += '\tHealth: %d / %d (regen: %f)\n' % (self.health, self.max_health, self.health_regen)
        str += '\tMana: %d / %d (regen: %f)\n' % (self.mana, self.max_mana, self.mana_regen)
        str += '\tLocation: <%f, %f, %f>\n' % (self.location[0],self.location[1],self.location[2])
        str += '\tGold: %f\n' % (self.gold)
        return str
        
    def canLevelUp(self):
        return self.ability_pts > 0
        
    def pickAbility(self):
        # TODO - Fill Me Out
        level_abs = None # <-- fill this with scraped info
        self.jsonReply['LevelAbs'] = level_abs
        
    def needsStartingItems(self):
        return len(self.items) == 0
        
    def sendStartingItems(self):
        itemkb = ItemKB()
        start_items = itemkb.getStartingItems(self.name, "Safe Lane")
        self.jsonReply['StartItems'] = start_items
        
    def processHero(self):
        self.jsonReply = {}
        
        if self.canLevelUp():
            self.pickAbility()
            
        if self.needsStartingItems():
            self.sendStartingItems()
            
    def getReply(self):
        if len(self.jsonReply) == 0:
            return None
        return self.jsonReply