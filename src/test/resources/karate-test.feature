@REQ_HU-PRUEBA-TECNICA @HU-PRUEBA-TECNICA @gestion_personajes_marvel @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: HU-PRUEBA-TECNICA Gestión de personajes Marvel (microservicio para administración de personajes)
  Background:
    * url port_marvel_characters_api
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

  @id:1 @listarPersonajes @get @exito200
  Scenario: T-API-HU-PRUEBA-TECNICA-CA01-Obtener todos los personajes exitosamente 200 - karate
    When method GET
    Then status 200
    And assert response.length > 0

  @id:2 @obtenerPersonaje @get @exito200
  Scenario Outline: T-API-HU-PRUEBA-TECNICA-CA02-Obtener personaje por ID <id> exitosamente 200 - karate
    Given path <id>
    When method GET
    Then status 200
    # And match response == read('classpath:data/marvel_characters_api/character_response.json')
    And match response.id == <id>
    Examples:
      | id   |
      | 1024 |

  @id:3 @obtenerPersonaje @get @noEncontrado404
  Scenario Outline: T-API-HU-PRUEBA-TECNICA-CA03-Obtener personaje por ID <id> no existente 404 - karate
    Given path <id>
    When method GET
    Then status 404
    And match response == read('classpath:data/marvel_characters_api/character_not_found.json')
    And match response.error == 'Character not found'
    Examples:
      | read('classpath:data/marvel_characters_api/notfoundid.csv') |


  @id:4 @crearPersonaje @post @exito201
  Scenario: T-API-HU-PRUEBA-TECNICA-CA04-Crear personaje exitosamente 201 - karate
    * def body = read('classpath:data/marvel_characters_api/characters_valid.json')[0]
    * set body.name = 'Iron Man Rafael' + Math.random().toString(36).substring(2, 10)
    And request body
    When method POST
    Then status 201
    And match response.name == body.name
    * def characterCreatedId = response.id
    * print 'Character created with ID: ' + characterCreatedId

  @id:5 @crearPersonaje @post @duplicado400
  Scenario: T-API-HU-PRUEBA-TECNICA-CA05-Crear personaje con nombre duplicado 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/characters_duplicate.json')[0]
    And request jsonData
    When method POST
    Then status 400
    And match response == read('classpath:data/marvel_characters_api/character_duplicate_error.json')
    And match response.error == 'Character name already exists'

  @id:6 @crearPersonaje @post @validacion400
  Scenario: T-API-HU-PRUEBA-TECNICA-CA06-Crear personaje con datos inválidos 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/characters_invalid.json')[0]
    And request jsonData
    When method POST
    Then status 400
    And match response == read('classpath:data/marvel_characters_api/character_validation_error.json')
    And match response.name == 'Name is required'

  @id:7 @actualizarPersonaje @put @exito200
  Scenario Outline: T-API-HU-PRUEBA-TECNICA-CA07-Actualizar personaje exitosamente 200 - karate
    Given path <id>
    * def jsonData = read('classpath:data/marvel_characters_api/character_response.json')
    * set jsonData.description = 'Updated description' + Math.random().toString(36).substring(2, 10)
    And request jsonData
    When method PUT
    Then status 200
    And match response.description == jsonData.description
    And match response.id == <id>
    Examples:
      | id   |
      | 1024 |

  @id:8 @actualizarPersonaje @put @noEncontrado404
  Scenario Outline: T-API-HU-PRUEBA-TECNICA-CA08-Actualizar personaje no existente 404 ID <id> - karate
    Given path <id>
    * def jsonData = read('classpath:data/marvel_characters_api/character_response.json')
    And request jsonData
    When method PUT
    Then status 404
    # And match response == read('classpath:data/marvel_characters_api/character_not_found.json')
    # And match response.error == 'Character not found'
    Examples:
      | read('classpath:data/marvel_characters_api/notfoundid.csv') |

  @id:9 @eliminarPersonaje @delete @exito204
  Scenario: T-API-HU-PRUEBA-TECNICA-CA09-Eliminar personaje exitosamente 204 - karate
    * def body = read('classpath:data/marvel_characters_api/characters_valid.json')[0]
    * set body.name = 'Ant Man' + Math.random().toString(36).substring(2, 10)
    And request body
    When method POST
    Then status 201
    * def characterCreatedId = response.id
    * print 'Character created with ID to be deleted: ' + characterCreatedId

    Given path characterCreatedId
    When method DELETE
    Then status 204
    And match response == ''

  @id:10 @eliminarPersonaje @delete @noEncontrado404
  Scenario: T-API-HU-PRUEBA-TECNICA-CA10-Eliminar personaje no existente 404 - karate
    Given path '999'
    When method DELETE
    Then status 404
    And match response == read('classpath:data/marvel_characters_api/character_not_found.json')
    And match response.error == 'Character not found'

  @id:11 @errorInterno @error @error500
  Scenario: T-API-HU-PRUEBA-TECNICA-CA11-Error interno del servidor 500 - karate
  path '/simulate-error'
    * def jsonData = { error: 'Simular error interno' }
    And request jsonData
    When method POST
    Then status 400
  # And match response.error contains 'internal server error'
  # And match response != null

