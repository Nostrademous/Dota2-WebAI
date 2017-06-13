from __future__ import print_function

class Unit(object):
    def __init__(self, name, id, team, jsonData):
        self.name   = name
        self.id     = id
        self.team   = team
        
        self.health     = jsonData['Health']
        self.max_health = jsonData['MaxHealth']
        
        self.location   = (jsonData['Loc_X'], jsonData['Loc_Y'], jsonData['Loc_Z'])

    def __repr__(self):
        str = 'Unit ID: %d, %s - %s' % (self.id, self.name, self.team)
        str += '\tHealth: %d / %d\n' % (self.health, self.max_health)
        return str

class Hero(Unit):
    def __init__(self, name, id, team, jsonData):
        Unit.__init__(self, name, id, team, jsonData)
    
    def __repr__(self):
        str = 'Hero ID: %d, %s - %s\n' % (self.id, self.name, self.team)
        str += '\tHealth: %d / %d\n' % (self.health, self.max_health)
        str += '\tLocation: <%f, %f, %f>\n' % (self.location[0],self.location[1],self.location[2])
        return str