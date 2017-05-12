import cherrypy
import json

@cherrypy.expose
@cherrypy.tools.json_out()
@cherrypy.tools.json_in()
class Root:

    @cherrypy.tools.accept(media='application/json')
    def GET(self):
        return {"operation": "GET", "result": "success"}

    @cherrypy.tools.accept(media='application/json')
    def POST(self):
        input_json = cherrypy.request.json
        processData(input_json)
        return {"operation": "POST", "result": "success"}
    
    @cherrypy.expose
    def shutdown(self):
        print 'shutting down'
        cherrypy.engine.exit()

def web_server():
    conf = {
        'global' : {
            'server.socket_host' : '127.0.0.1',
            'server.socket_port' : 2222,
            'server.thread_pool' : 8
        },
        '/': {
            'request.dispatch': cherrypy.dispatch.MethodDispatcher(),
            'tools.sessions.on': True,
        }
    }
    cherrypy.quickstart(Root(), '/', conf)

def processData(data):
    print '\nEnemies:\n\t', data['enemyHeroes']
    print 'Allies:\n\t', data['alliedHeroes']
    print 'Other Enemy Units:\n\t', data['enemyHeroesOther']
    print 'Other Allied Units:\n\t', data['alliedHeroesOther']

if __name__ == "__main__":
    print 'starting web server'
    web_server()
    print 'done'
