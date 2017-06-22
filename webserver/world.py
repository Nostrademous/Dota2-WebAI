from __future__ import print_function

import datetime
from hero import Hero
import json
import constants as const

startTime = datetime.datetime.now()

enemies = {}
allies  = {}

def timeSinceStart(dt):
    return (dt - startTime).total_seconds()

class World(object):
    def __init__(self):
        self.reply = {}

    def __repr__(self):
        return 'Last Reply %s' % (self.reply)

    def decision(self):
        return self.reply
    
    def update(self, data):
        dataType = data['Type']
        
        # X -- Authentication Packet
        if dataType == 'X':
            self.generateAuthenticationReply(data['Time'])
        # W -- World Update Packet
        elif dataType == 'W':
            self.updateCourierData(data['CourierData'])
            '''
            self.updateEnemyHeroes(data['enemyHeroes'])
            self.updateAlliedHeroes(data['alliedHeroes'])
            
            self.updateOtherEnemyUnits(data['enemyHeroesOther'])
            self.updateOtherAlliedUnits(data['alliedHeroesOther'])
            
            self.updateEnemyCreep(data['enemyCreep'])
            self.updateAlliedCreep(data['alliedCreep'])
            self.updateNeutralCreep(data['neutralCreep'])
            
            self.updateEnemyWards(data['enemyWards'])
            self.updateAlliedWards(data['alliedWards'])
            
            self.updateAOEs(data['dangerousAOEs'])
            self.updateProjectiles(data['dangerousProjectiles'])
            self.updateIncomingTeleports(data['incomingTeleports'])
            
            self.updateCastCallback(data['castCallback'])
            '''
            self.generateWorldUpdateReply(data['Time'])
        # E -- Enemies Update Packet
        elif dataType == 'E':
            self.updateEnemyHeroes(data['Data'])
            self.generateEnemiesReply(data['Time'])
        # A -- Allies Update Packet (for Human and not-our-bot Bots)
        elif dataType == 'A':
            self.generateAlliesReply(data['Time'])
        # P* -- Player Update Packet
        elif dataType[0] == 'P':
            cHero = self.updateHero(data['Data'], int(dataType[1:]))
            cHero.processHero()
            self.generatePlayerUpdateReply(data['Time'], dataType, cHero.getReply())
        # ? -- Unknown
        else:
            print('Error:', 'Unknown Packet Type:', dataType)

    def generateAuthenticationReply(self, time):
        self.reply = {}
        self.reply["Type"] = 'X'
        self.reply["Time"] = time
        
    def generateWorldUpdateReply(self, time):
        self.reply = {}
        self.reply["Type"] = 'W'
        self.reply["Time"] = time
        
    def generateEnemiesReply(self, time):
        self.reply = {}
        self.reply["Type"] = 'E'
        self.reply["Time"] = time
        
    def generateAlliesReply(self, time):
        self.reply = {}
        self.reply["Type"] = 'A'
        self.reply["Time"] = time

    def generatePlayerUpdateReply(self, time, pID, reply):
        self.reply = {}
        self.reply["Type"] = pID
        self.reply["Time"] = time
        if reply != None and len(reply) > 0:
            print('Have Data: ', reply)
            self.reply["Data"] = reply
    
    def updateCourierData(self, data):
        print('Courier Data:\n')
        for entry in data:
            print(entry, ' ', data[entry])

    def updateEnemyHeroes(self, data):
        print('Enemies:\n')
        for hero in data:
            print(hero, ' ', data[hero])
        
    def updateHero(self, heroData, pID):
        cHero = Hero(heroData['Name'], pID, heroData['Team'], heroData)
        #print(cHero)
        return cHero
    
    def updateOtherEnemyUnits(self, data):
        print('Other Enemy Units:\n')
        for unit in data:
            print(unit)
    
    def updateOtherAlliedUnits(self, data):
        print('Other Allied Units:\n')
        for unit in data:
            print(unit)
    
    def updateEnemyCreep(self, data):
        print('Enemy Creep:\n')
        for creep in data:
            print(creep)
    
    def updateAlliedCreep(self, data):
        print('Allied Creep:\n')
        for creep in data:
            print(creep)
    
    def updateNeutralCreep(self, data):
        print('Neutral Creep:\n')
        for creep in data:
            print(creep)
    
    def updateEnemyWards(self, data):
        print('Enemy Wards:\n')
        for ward in data:
            print(ward)
        
    def updateAlliedWards(self, data):
        print('Allied Wards:\n')
        for ward in data:
            print(ward)
    
    def updateAOEs(self, data):
        print('Dangerous AOEs:\n')
        for aoe in data:
            print(aoe)
        
    def updateProjectiles(self, data):
        print('Dangerous Projectiles:\n')
        for projectile in data:
            print(projectile)
    
    def updateIncomingTeleports(self, data):
        print('Incoming Teleports:\n')
        for tp in data:
            print(tp)
            
    def updateCastCallback(self, data):
        print('Cast Callbacks:\n')
        for call in data:
            print(call)
