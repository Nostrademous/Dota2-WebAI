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
        self.lastUpdate = timeSinceStart(datetime.datetime.now())

    def __repr__(self):
        return 'Last Update TimeStamp: %ull' % (self.lastUpdate)

    def decision(self):
        retJSON = {}
        
        retJSON["Timestamp"] = timeSinceStart(datetime.datetime.now())
        
        return retJSON
    
    def update(self, data):
        print('\nUpdate Time: ', data['updateTime'])

        self.updateEnemyHeroes(data['enemyHeroes'])
        self.updateAlliedHeroes(data['alliedHeroes'])
        
        self.updateOtherEnemyUnits(data['enemyHeroesOther'])
        self.updateOtherAlliedUnits(data['alliedHeroesOther'])
        
        self.updateEnemyCreep(data['enemyCreep'])
        self.updateAlliedCreep(data['alliedCreep'])
        self.updateNeutralCreep(data['neutralCreep'])
        
        self.updateEnemyWards(data['enemyWards'])
        self.updateAlliedWards(data['alliedWards'])
        
        self.updateIncomingTeleports(data['incomingTeleports'])

    def updateEnemyHeroes(self, heroData):
        print('Enemies:\n')
        for hero in heroData:
            cHero = Hero(hero, heroData[hero]['ID'], heroData[hero]['Team'], heroData[hero])
            print(cHero)
        
    def updateAlliedHeroes(self, heroData):
        print('Allies:\n')
        for hero in heroData:
            cHero = Hero(hero, heroData[hero]['ID'], heroData[hero]['Team'], heroData[hero])
            print(cHero)
    
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
        
    def updateAlliedWards(self, data):
        print('Allied Wards:\n')
    
    def updateIncomingTeleports(self, data):
        print('Incoming Teleports:\n')
        for tp in data:
            print(tp)