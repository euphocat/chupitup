const Joi = require('joi');

module.exports = function (server, articles) {

    server.route({
        method: 'GET',
        path: '/articles',
        handler: function (request, reply) {
            const addId = article => Object.assign(article, {id: article._id});
            const addIds = articles => articles.map(addId);

            articles
                .list()
                .then(addIds)
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
        path: '/reset',
        handler: (request, reply) => {
            articles
                .reset()
                .then(reply);
        }
    });

};