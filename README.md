Chatsockets by Adriem
=====================

This is a demo project to experiment with WebSockets technology over the MEAN
stack. It makes use of [socket.io](http://socket.io), a library that simplifies
the use of WebSockets over [node.js](http://nodejs.org) and the client, which is
built with AngularJS.

Run this project!
-----------------

In order to run this project you have to have installed
[node.js](http://nodejs.org) and npm. Once you have them, follow these steps:

  1. Clone this repo :D
  2. Open a terminal on the root folder of this project.
  3. Run `npm install`. This must be done the first time only, in order to
  install the dependencies of the project.
  4. Run `gulp` in order to compile the front-end
  5. Run `npm start` in order to launch the server on port 3000.
  Alternatively, you can also use `node server.js`.

How does Chatsockets work?
--------------------------

Chatsockets is a completely open chat, so every message sent will be seen by all
the people who are connected by the moment the message is received on the
server. However, these messages aren't stored, so they will be completely lost
once all the people who received them get disconnected.

There are no user accounts; every user is given a random nickname every time he
or she reloads the page.

Is Chatsockets safe?
--------------------

**Definitely NOT.** Chatsockets is a little prototype developed for learning
purposes. It's focused on how websockets work, so there is no security here. All
messages are sent as plain text and can be seen by anyone who is in the chat
room.

Any suggestions?
----------------

If you have any suggestions, find any bugs or just want to tell me how this
wonderful project solved all your life's problems, drop me an email at
[admoreno@outlook.com](mailto:admoreno@outlook.com). If you prefer, you can also
open an issue on this repo. I will respond any of them as soon as I can.

**Have fun with this project!**
