from __future__ import print_function

import cherrypy
import json
import world

myWorld = world.World()

@cherrypy.expose
@cherrypy.tools.json_out()
@cherrypy.tools.json_in()
class Root(object):

    @cherrypy.tools.accept(media='application/json')
    def GET(self):
        return {"operation": "GET", "result": "success"}

    @cherrypy.tools.accept(media='application/json')
    def POST(self):
        input_json = cherrypy.request.json
        myWorld.update(input_json)
        return myWorld.decision()
    
    @cherrypy.expose
    def shutdown(self):
        print('shutting down')
        cherrypy.engine.exit()

def start():
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

if __name__ == "__main__":
    print('starting web server')
    start()
    print('done')
