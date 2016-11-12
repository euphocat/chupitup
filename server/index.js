const Hapi = require("hapi");
const articles = require('./articles/model');

const SERVER_PORT = 3000;

const server = new Hapi.Server({
    debug: {
        request: ['error', 'received']
    }
});

server.connection({
    port: SERVER_PORT,
    routes: {
        cors: true
    }
});

server.route({
    method: 'GET',
    path: '/',
    handler: function (request, reply) {
        reply('It works !');
    }
});

require('./articles/routes')(server, articles);

server.start((err) => {
    if (err) {
        throw err;
    }
    console.log(`Server running at: ${server.info.uri}`);
});