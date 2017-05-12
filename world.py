import datetime
import hero

epoch = datetime.datetime.utcfromtimestamp(0)

def unix_time_millis(dt):
    return (dt - epoch).total_seconds() * 1000.0

class World():
    def __init__(self):
        self.lastUpdate = unix_time_millis(datetime.datetime.now())

    def __repr__(self):
        return 'Last Update TimeStamp: %ull' % (self.lastUpdate)

    def update(self, data):
        print '\nEnemies:\n\t', data['enemyHeroes']
        print 'Allies:\n\t', data['alliedHeroes']
        print 'Other Enemy Units:\n\t', data['enemyHeroesOther']
        print 'Other Allied Units:\n\t', data['alliedHeroesOther']
