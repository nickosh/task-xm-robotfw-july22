*** Settings ***
Library             Collections
Library             Process
Library             OperatingSystem
Library             RequestsLibrary
Library             JSONLibrary

Suite Setup         Start API mock server    ${MOCK_IP}    ${MOCK_PORT}    ${MOCK_DELAY}
Suite Teardown      Terminate All Processes    kill=True


*** Variables ***
${MOCK_IP}          127.0.0.1
${MOCK_PORT}        8000
${MOCK_DELAY}       0


*** Test Cases ***
Valid responce from people end-point
    [Documentation]    Lest test the valid responce from 'people' endpoint
    ${response}=    GET    http://${MOCK_IP}:${MOCK_PORT}/people/12
    Log To Console    ${response.json()}
    Status Should Be    OK    ${response}

    Should Be Equal As Strings    ${response.reason}    OK
    Dictionary Should Contain Value    ${response.json()}    Hi there! Your human ID: 12 Delay: 0

Valid responce from planets end-point
    [Documentation]    Lest test the valid responce from 'planets' endpoint
    ${response}=    GET    http://${MOCK_IP}:${MOCK_PORT}/planets/38
    Log To Console    ${response.json()}
    Status Should Be    OK    ${response}

    Should Be Equal As Strings    ${response.reason}    OK
    Dictionary Should Contain Value    ${response.json()}    Hi there! Your planet ID: 38 Delay: 0

Valid responce from starships end-point
    [Documentation]    Lest test the valid responce from 'starships' endpoint
    ${response}=    GET    http://${MOCK_IP}:${MOCK_PORT}/starships/100
    Log To Console    ${response.json()}
    Status Should Be    OK    ${response}

    Should Be Equal As Strings    ${response.reason}    OK
    Dictionary Should Contain Value    ${response.json()}    Hi there! Your starship ID: 100 Delay: 0

Test people end-point with wrong ID
    [Documentation]    Lest test the 'people' endpoint with invalid ID
    ${response}=    GET    http://${MOCK_IP}:${MOCK_PORT}/people/121    expected_status=404
    Log To Console    ${response.json()}
    Status Should Be    404    ${response}

    Should Be Equal As Strings    ${response.reason}    Not Found
    Dictionary Should Contain Value    ${response.json()}    Item with ID 121 is not found

Test planets end-point with wrong ID
    [Documentation]    Lest test the 'planets' endpoint with invalid ID
    ${response}=    GET    http://${MOCK_IP}:${MOCK_PORT}/planets/9999    expected_status=404
    Log To Console    ${response.json()}
    Status Should Be    404    ${response}

    Should Be Equal As Strings    ${response.reason}    Not Found
    Dictionary Should Contain Value    ${response.json()}    Item with ID 9999 is not found

Test starships end-point with wrong ID
    [Documentation]    Lest test the 'starships' endpoint with invalid ID
    ${response}=    GET    http://${MOCK_IP}:${MOCK_PORT}/starships/-5    expected_status=404
    Log To Console    ${response.json()}
    Status Should Be    404    ${response}

    Should Be Equal As Strings    ${response.reason}    Not Found
    Dictionary Should Contain Value    ${response.json()}    Item with ID -5 is not found

Test people end-point with unexpected ID
    [Documentation]    Lest test the 'people' endpoint with unexpected ID
    ${response}=    GET    http://${MOCK_IP}:${MOCK_PORT}/people/abc    expected_status=422
    Log To Console    ${response.json()}
    Status Should Be    422    ${response}

    Should Be Equal As Strings    ${response.reason}    Unprocessable Entity
    ${msg}=    Get Value From Json    ${response.json()}    $..msg
    Should Contain    ${msg}    value is not a valid integer

Test planets end-point with unexpected ID
    [Documentation]    Lest test the 'planets' endpoint with unexpected ID
    ${response}=    GET    http://${MOCK_IP}:${MOCK_PORT}/planets/@#$%    expected_status=422
    Log To Console    ${response.json()}
    Status Should Be    422    ${response}

    Should Be Equal As Strings    ${response.reason}    Unprocessable Entity
    ${msg}=    Get Value From Json    ${response.json()}    $..msg
    Should Contain    ${msg}    value is not a valid integer

Test starships end-point with unexpected ID
    [Documentation]    Lest test the 'starships' endpoint with unexpected ID
    ${response}=    GET    http://${MOCK_IP}:${MOCK_PORT}/starships/-1-    expected_status=422
    Log To Console    ${response.json()}
    Status Should Be    422    ${response}

    Should Be Equal As Strings    ${response.reason}    Unprocessable Entity
    ${msg}=    Get Value From Json    ${response.json()}    $..msg
    Should Contain    ${msg}    value is not a valid integer


*** Keywords ***
Start API mock server
    [Arguments]    ${address}    ${port}    ${delay}
    Set environment variable    MOCK_IP    ${address}
    Set environment variable    MOCK_PORT    ${port}
    Set environment variable    MOCK_DELAY    ${delay}
    ${server}=    Start Process    ./start_mock.sh
    Sleep    1 seconds
