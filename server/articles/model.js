const cnx = require('../connection');
const ObjectID = require('mongodb').ObjectID;

const articles = Object.create({
    find,
    update,
    list,
    reset
});

function find(id) {
    return cnx.then(db =>
        db.collection('articles')
            .find({_id: new ObjectID(id)})
            .limit(1)
            .next()
    );
}

function update(id, article) {
    return cnx.then(db =>
        db.collection('articles')
            .updateOne(
                {_id: new ObjectID(id)},
                {$set: article}
            )
    );
}

function list() {
    return cnx.then(db =>
        db.collection('articles')
            .find({})
            .toArray()
    );
}

function reset() {
    const mocks = require('./mocks.json')
        .map(({title, body, photoThumbnail, description, tags, place}) => ({
            title,
            body,
            photoThumbnail,
            description,
            tags,
            place
        }));

    const recreateDb = () =>
        cnx.then(db => db.collection('articles')
            .insertMany(mocks)
        );

    return cnx.then(db =>
        db.dropCollection('articles')
            .then(recreateDb, recreateDb)
    );
}

module.exports = articles;

