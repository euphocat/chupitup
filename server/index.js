'use strict';

const Hapi = require('hapi');
const Joi = require('joi');


const SERVER_PORT = 3000;

const MongoClient = require('mongodb').MongoClient;

// Connection URL
const url = 'mongodb://localhost:27017/blog';

const db = MongoClient.connect(url)
    .catch(err => console.error(err.message));

const server = new Hapi.Server({debug: {request: ['error', 'received']}});
server.connection({
    port: SERVER_PORT, routes: {
        cors: true
    }
});

server.route({
    method: 'GET',
    path: '/reset',
    handler: (request, reply) => {
        const recreateDb = () => {
            db.then(db => {
                db.createCollection('articles', (err, collection) => {
                    const articles = require('./mocks/articles.json')
                        .map(({title, body, photoThumbnail, description, tags, place}) => ({ title,
                            body,
                            photoThumbnail, description, tags, place}));
                    collection.insertMany(articles).then(reply);
                });
            });

        };

        db.then(db => {

            db.dropCollection('articles')
                .then(recreateDb, recreateDb);
        });

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

        db.then(db => {
            db.collection('articles', function (err, collection) {
                collection.find({})
                    .toArray()
                    .then(docs => {
                        reply(docs.map(doc => Object.assign(doc, {id: doc._id}) ))
                    });
            });
        });

    }
});

server.route({
    method: 'GET',
    path: '/articles/{id}',
    handler: function (request, reply) {
        const articles = require('./mocks/articles.json') || [];

        const filterArticleById = article => article.id === request.params.id;
        const article = articles.filter(filterArticleById);

        setTimeout(() => reply(article), 0);
    },
    config: {
        validate: {
            params: {
                id: Joi.number().integer()
            }
        }
    }
});


server.start((err) => {

    if (err) {
        throw err;
    }
    console.log(`Server running at: ${server.info.uri}`);
});
