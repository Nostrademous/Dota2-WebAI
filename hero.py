from __future__ import print_function

class Unit(object):
    def __init__(self, fields):
        self.name   = fields[0]
        self.id     = fields[1]
        self.team   = fields[2]

    def __repr__(self):
        return 'Unit ID: %d, %s - %s' % (self.id, self.name, self.team)

class Hero(Unit):
    def __init__(self, fields):
        super(Unit, self).__init__(fields)