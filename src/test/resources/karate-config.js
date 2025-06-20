function fn() {
    var env = karate.env || 'local';
    karate.log('karate.env system property was:', env);
    var config = {
        port_marvel_characters_api: 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters',
    };
    return config;
}
