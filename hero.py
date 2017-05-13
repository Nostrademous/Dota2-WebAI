class Hero(object):
    def __init__(self, fields):
        self.name   = fields[0]
        self.id     = fields[1]
        self.team   = fields[2]

    def __repr__(self):
        return 'Hero ID: %d, %s - %s' % (self.id, self.name, self.team)
