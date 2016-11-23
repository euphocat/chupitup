function uniqVal (tag, index, self) {
    return self.indexOf(tag) === index;
}

module.exports = {uniqVal};