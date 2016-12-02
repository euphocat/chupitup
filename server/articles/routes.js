const Joi = require('joi');
const _ = require('lodash');

module.exports = function (server, articles) {

    server.route({
        method: 'GET',
        path: '/articles',
        config: {
            validate: {
                query: {
                    places: Joi.array().items(Joi.string()).single(),
                    categories: Joi.array().items(Joi.string()).single()
                }
            }
        },
        handler: function (request, reply) {
            const {places, categories} = request.query;

            const placeFilter = ({place}) => places ? _.includes(places, place) : true;
            const tagsFilter = ({tags}) => categories ? _.some(categories, _.partial(_.includes, tags)) : true;

            articles
                .list()
                .then(articles => articles.filter(placeFilter))
                .then(articles => articles.filter(tagsFilter))
                .then(reply);
        }
    });

    server.route({
        method: 'GET',
        path: '/articles/{id}',
        handler: function (request, reply) {
            articles
                .find(request.params.id)
                .then(reply);
        },
        config: {
            validate: {
                params: {
                    id: Joi.string()
                }
            }
        }
    });

    server.route({
        method: 'PATCH',
        path: '/articles/{id}',
        handler: function (request, reply) {
            const article = request.payload;
            const id = request.params.id;

            articles
                .update(id, article)
                .then(_ => articles.find(id))
                .then(reply);

        },
        config: {
            validate: {
                params: {
                    id: Joi.string()
                },
                payload: {
                    body: Joi.string(),
                    description: Joi.string()
                }
            }
        }
    });

    server.route({
        method: 'GET',
        path: '/categories',
        handler: (request, reply) => {
            articles
                .getAllCategories()
                .then(reply);
        }
    });

    server.route({
        method: 'GET',
        path: '/places',
        handler: (request, reply) => {
            articles
                .getAllPlaces()
                .then(reply);
        }
    });

    server.route({
        method: 'GET',
        path: '/reset',
        handler: (request, reply) => {
            articles
                .reset()
                .then(reply);
        }
    });

};