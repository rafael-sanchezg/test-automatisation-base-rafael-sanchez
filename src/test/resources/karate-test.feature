@REQ_HU-PRUEBA-TECNICA @HU-PRUEBA-TECNICA @gestion_personajes_marvel @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: HU-PRUEBA-TECNICA Gestión de personajes Marvel (microservicio para administración de personajes)
  Background:
    * url port_marvel_characters_api = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    * def generarHeaders =
      """
      function() {
        return {
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers
    * configure ssl = true

  @id:1 @listarPersonajes @exito200
  Scenario: T-API-HU-PRUEBA-TECNICA-CA01-Obtener todos los personajes exitosamente 200 - karate
    When method GET
    Then status 200
  # And match response == []
  # And match response.length == 0

  @id:2 @obtenerPersonaje @exito200
  Scenario: T-API-HU-PRUEBA-TECNICA-CA02-Obtener personaje por ID exitosamente 200 - karate
    Given path '45'
    When method GET
    Then status 200
  # And match response == read('classpath:data/marvel_characters_api/character_response.json')
  # And match response.id == 1

  @id:3 @obtenerPersonaje @noEncontrado404
  Scenario: T-API-HU-PRUEBA-TECNICA-CA03-Obtener personaje por ID no existente 404 - karate
    Given path '999'
    When method GET
    Then status 404
  # And match response == read('classpath:data/marvel_characters_api/character_not_found.json')
  # And match response.error == 'Character not found'

  @id:4 @crearPersonaje @exito201
  Scenario: T-API-HU-PRUEBA-TECNICA-CA04-Crear personaje exitosamente 201 - karate
    * def body = read('classpath:data/marvel_characters_api/characters_valid.json')[0]
    And request body
    When method POST
    Then status 201
  # And match response == read('classpath:data/marvel_characters_api/character_response.json')
  # And match response.name == 'Iron Man'

  @id:5 @crearPersonaje @duplicado400
  Scenario: T-API-HU-PRUEBA-TECNICA-CA05-Crear personaje con nombre duplicado 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/characters_duplicate.json')[0]
    And request jsonData
    When method POST
    Then status 400
  # And match response == read('classpath:data/marvel_characters_api/character_duplicate_error.json')
  # And match response.error == 'Character name already exists'

  @id:6 @crearPersonaje @validacion400
  Scenario: T-API-HU-PRUEBA-TECNICA-CA06-Crear personaje con datos inválidos 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/characters_invalid.json')[0]
    And request jsonData
    When method POST
    Then status 400
  # And match response == read('classpath:data/marvel_characters_api/character_validation_error.json')
  # And match response.name == 'Name is required'

  @id:7 @actualizarPersonaje @exito200
  Scenario: T-API-HU-PRUEBA-TECNICA-CA07-Actualizar personaje exitosamente 200 - karate
    Given path '14'
    * def jsonData = read('classpath:data/marvel_characters_api/character_response.json')
    * set jsonData.description = 'Updated description'
    And request jsonData
    When method PUT
    Then status 200
  # And match response.description == 'Updated description'
  # And match response.id == 1

  @id:8 @actualizarPersonaje @noEncontrado404
  Scenario: T-API-HU-PRUEBA-TECNICA-CA08-Actualizar personaje no existente 404 - karate
    Given path '999'
    * def jsonData = read('classpath:data/marvel_characters_api/character_response.json')
    And request jsonData
    When method PUT
    Then status 404
  # And match response == read('classpath:data/marvel_characters_api/character_not_found.json')
  # And match response.error == 'Character not found'

  @id:9 @eliminarPersonaje @exito204
  Scenario: T-API-HU-PRUEBA-TECNICA-CA09-Eliminar personaje exitosamente 204 - karate
    Given path '1'
    When method DELETE
    Then status 204
  # And match response == null

  @id:10 @eliminarPersonaje @noEncontrado404
  Scenario: T-API-HU-PRUEBA-TECNICA-CA10-Eliminar personaje no existente 404 - karate
    Given path '999'
    When method DELETE
    Then status 404
  # And match response == read('classpath:data/marvel_characters_api/character_not_found.json')
  # And match response.error == 'Character not found'

  @id:11 @errorInterno @error500
  Scenario: T-API-HU-PRUEBA-TECNICA-CA11-Error interno del servidor 500 - karate
    url '/simulate-error'
    * def jsonData = { error: 'Simular error interno' }
    And request jsonData
    When method POST
    Then status 500
  # And match response.error contains 'internal server error'
  # And match response != null

