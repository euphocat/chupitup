var MongoClient = require("mongodb");

// Connection URL
const url = 'mongodb://localhost:27017/blog';

const cnx = MongoClient.connect(url)
    .catch(err => console.error(err.message));

module.exports = cnx;