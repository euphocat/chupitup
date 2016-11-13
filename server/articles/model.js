const cnx = require('../connection');
const ObjectID = require('mongodb').ObjectID;

const articles = Object.create({
    find,
    update,
    list,
    reset
});

function renameProperty(obj, oldPropertyName, newPropertyName) {
    const augmentedObject = Object.assign({}, {[newPropertyName]: obj[oldPropertyName]}, obj);

    return Object.keys(augmentedObject)
        .filter(key => key !== oldPropertyName)
        .reduce(
            (prev, next) => Object.assign(prev, {[next]: augmentedObject[next]}),
            {}
        );
}

function renameId(article) {
    return renameProperty(article, '_id', 'id')
}

function renameIds(articles) {
    return articles.map(renameId);
}

function find(id) {
    return cnx.then(db =>
        db.collection('articles')
            .find({_id: new ObjectID(id)})
            .limit(1)
            .next()
            .then(renameId)
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
            .then(renameIds)
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

