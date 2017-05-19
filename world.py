from __future__ import print_function

import datetime
import hero

epoch = datetime.datetime.utcfromtimestamp(0)

def unix_time_millis(dt):
    return (dt - epoch).total_seconds() * 1000.0

class World(object):
    def __init__(self):
        self.lastUpdate = unix_time_millis(datetime.datetime.now())

    def __repr__(self):
        return 'Last Update TimeStamp: %ull' % (self.lastUpdate)

    def update(self, data):
        print('\nUpdate Time: ', data['updateTime'])
        print('Enemies:\n\t', data['enemyHeroes'])
        print('Allies:\n\t', data['alliedHeroes'])
        print('Other Enemy Units:\n\t', data['enemyHeroesOther'])
        print('Other Allied Units:\n\t', data['alliedHeroesOther'])
        print('Enemy Creep:\n\t', data['enemyCreep'])
        print('Allied Creep:\n\t', data['alliedCreep'])
        print('Neutral Creep:\n\t', data['neutralCreep'])
        print('Enemy Wards:\n\t', data['enemyWards'])
        print('Allied Wards:\n\t', data['alliedWards'])
