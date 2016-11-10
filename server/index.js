'use strict';

const Hapi = require('hapi');

const SERVER_PORT = 3000;

const server = new Hapi.Server({debug: {request: ['error', 'received']}});
server.connection({
    port: SERVER_PORT, routes: {
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

server.route({
    method: 'GET',
    path: '/articles',
    handler: function (request, reply) {
        const articles = require('./mocks/articles.json');
        setTimeout(() => reply(articles), 0);
    }
});

server.start((err) => {

    if (err) {
        throw err;
    }
    console.log(`Server running at: ${server.info.uri}`);
});
