# Dota2-WebAI

### What is this
This will be my attempt at writing Dota 2 bots using a webserver backend that 
will provide all the decision making logic for the bots. The bots will then
be instructed what they are supposed to be doing at the *macro*-level, and 
know how to execute those instructions inside the Dota 2 world through the 
exposed Bot-Scripting API.

### What's the Plan?
The plan is to have the web-based Python framework control all the high-level/meta 
decisions for the bots. It will ingest raw data about the game provided by the 
Dota 2 API (i.e., hero/unit information, building status information, game 
progression information, etc.) and decided what each bot on the team should 
be doing at the high-level. Each bot will still have a LUA implementation 
in-game and knowledge of how to execute directives passed down from the 
web-based game decision-making system.

For example - the web-based system might tell the bot "farm BOT_LANE". The bot 
will know how to do this by issuing appropriate move or teleport commands to get 
there, then how to properly last hit/deny as the web-based framework will not 
tell the bot how to last hit, when to last hit, when to deny, etc. At least not 
for now, maybe later if we truly move into the Reinforcement Learning AI.

Eventually, I might even have a web-based GUI that will show you a replica of 
your game as represented by the world state of the web-server and allow you to 
manual issue commands (or toggle toggles) to get the bots to take certain actions. 
As an example, I might have a button that you can press on the GUI that will 
instruct the bots to go to Roshan.

### Where is the AI?
It won't exist for now until all the plumbing is complete; meaning, until I 
have basic bot play-ability and hard-coded logic working as orchestrated by 
the web-based back-end framework. Once that is complete I can start leveraging 
available AI/Machine Learning/Reinforcement Learning Python libraries to start 
learning over certain aspects of the game (like formations, fight priority, 
etc.). The plan is to eventually get there, but it won't be in the near future. 
However, the whole reason and design choice of this project is TO GET THERE!

For even the possibility of having future AI in this I needed a back-end server 
implementation of the logic so that I can in the future allow for proxy servers 
to feed a final aggregator server (perhaps existing in AWS). Then everyone using 
this bot can run Python scripts I will write which will redirect their localhost 
servers to the main server so that it can learn "at scale". This is because no 
single instance will most likely have enough test data (aka games played) to 
really train on and analyze.

### What about your Dota2-FullOverwrite Project?
It is not going away currently, but ultimately it will become this new project. 
I plan to leverage a lot of the code from that project into this one. There was a 
reason I did a "full overwrite" and that is to allow for this project to eventually 
happen. The way that project was coded allows for easy transition of the control 
logic to occur. Much of that code will become the in-game directive execution API 
for the bots as instructed by the web-server.

I needed to port the decision logic to Python to leverage multi-threading, existence 
of many research-based 3rd-party libraries, etc. in order to eventually reach the 
dream of Dota 2 AI. It could have been C/C++/Java, but honestly, it essentially 
will be anyways. I say this because most/many Python AI libraries leverage numpy 
or pandas which is all C++ code under-the-hood anyways.

### Can I Contribute?
Sure. As with my other project, you are welcome to help. All I ask is that you drop 
me a note saying what you are doing and when you expect to be done (and if you 
happen to decide you don't have time, that's fine too, just let me know). If you 
have no idea how to help, just ask. 

This is a learning experience for me and a fun one (hopefully) as I'm passionate 
about AI. I tend to be very active about things I like doing so I am typically 
around to answer questions, discuss strategy, or just even chat about life.

### How to run
Run the *main.py* file provided (code is Python 2.5+ and 3.0+ compatible)
[Then follow these directions](https://github.com/Nostrademous/Dota2-FullOverwrite/wiki/Workflow-for-Debugging-Bots)