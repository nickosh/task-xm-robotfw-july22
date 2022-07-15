*** Settings ***
Library             Collections
Library             Process
Library             OperatingSystem
Library             RequestsLibrary
Library             DateTime

Suite Setup         Start API mock server    ${MOCK_IP}    ${MOCK_PORT}    ${MOCK_DELAY}
Suite Teardown      Terminate All Processes    kill=True


*** Variables ***
${MOCK_IP}          127.0.0.1
${MOCK_PORT}        8000
${MOCK_DELAY}       1


*** Test Cases ***
Performance test of people end-point
    [Documentation]    Lest test the 'people' endpoint performance with random delay on server side.
    [Setup]    Create Session    perf    http://${MOCK_IP}:${MOCK_PORT}
    ${resp_time_dict}=    Create List
    FOR    ${index}    IN RANGE    50
        ${session_exist}=    Session Exists    perf
        IF    not ${session_exist}
            Fail    ERROR: Perf session unexpectedly ends!
        END

        ${before_time}=    Get Current Date    result_format=epoch
        ${response}=    GET On Session    perf    /people/55
        ${after_time}=    Get Current Date    result_format=epoch
        ${resp_time}=    Subtract Time From Time    ${after_time}    ${before_time}
        Append To List    ${resp_time_dict}    ${resp_time}
        Log    №${index} ${response.json()}    console=True
        Log    №${index} Responce time: ${resp_time}    console=True
        Status Should Be    OK    ${response}
    END

    #Results calculation
    Set Local Variable    ${mean_time}    0
    Set Local Variable    ${variance_time}    0
    ${items_count}=    Evaluate    len(${resp_time_dict})

    #Mean response time
    FOR    ${resp_time}    IN    @{resp_time_dict}
        ${mean_time}=    Evaluate    ${mean_time}+${resp_time}
    END
    ${mean_time_raw}=    Evaluate    ${mean_time}/${items_count}
    ${mean_time_round}=    Evaluate    round(${mean_time_raw}, 2)
    Log    Mean response time: ${mean_time_round} seconds. Raw value: ${mean_time_raw}    console=True

    #Variance response time
    FOR    ${resp_time}    IN    @{resp_time_dict}
        ${variance_time}=    Evaluate    ${variance_time}+math.pow((${resp_time}-${mean_time_raw}), 2)
    END
    ${variance_time_raw}=    Evaluate    ${variance_time}/${items_count}
    ${variance_time_round}=    Evaluate    round(${variance_time_raw}, 2)
    Log    Variance response time: ${variance_time_round} seconds. Raw value: ${variance_time_raw}    console=True

    #Standard deviation time
    ${st_deviation_time_raw}=    Evaluate    math.sqrt(${variance_time_raw})
    ${st_deviation_time_round}=    Evaluate    round(${st_deviation_time_raw}, 2)
    Log
    ...    Standard deviation time: ${st_deviation_time_round} seconds. Raw value: ${st_deviation_time_raw}
    ...    console=True

    [Teardown]    Delete All Sessions


*** Keywords ***
Start API mock server
    [Arguments]    ${address}    ${port}    ${delay}
    Set environment variable    MOCK_IP    ${address}
    Set environment variable    MOCK_PORT    ${port}
    Set environment variable    MOCK_DELAY    ${delay}
    ${server}=    Start Process    ./start_mock.sh
    Sleep    1 seconds
