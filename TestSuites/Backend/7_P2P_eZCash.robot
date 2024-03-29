*** Settings ***
Documentation       Test Genie Onboarding API's

Suite Setup         DatabaseKeywords.Connecting_To_eZCash_Database
Suite Teardown      Disconnect From Database

Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library    String
Library    JSONLibrary
Library    DatabaseLibrary
Resource    ../../KeywordLibraries/Backend/Backend_CommonKeywords.robot

*** Keywords ***
GET /api/beneficiary/p2p/beneficiary
    [Documentation]    This API will be used to retrieve sof
    [Arguments]    ${expected_status_code}    ${parameter_name}    ${expected_value}    @{expected_values}

    Set Log Level    TRACE

    #    1. Send request: POST /api/beneficiary/p2p/beneficiary
    #    2. Verify response status code: 200

    ${request_headers}=    Backend_CommonKeywords.Token_Headers
    ${response}=    Backend_CommonKeywords.Calling_API_GET    ${BACKEND_URL}/api/beneficiary/p2p/beneficiary    ${expected_status_code}    ${request_headers}    ${TIMEOUT}

    #    3. Call the keyword to validate the response parameter and its expected value

    Backend_CommonKeywords.Response_Validation_Parameters    ${response.content}    ${expected_values}

GET /api/tokenization/p2p/sof
    [Documentation]    This API will be used to retrieve sof
    [Arguments]    ${expected_status_code}    ${parameter_name}    ${expected_value}    @{expected_values}

    Set Log Level    TRACE

    #    1. Send request: POST /api/tokenization/p2p/sof
    #    2. Verify response status code: 200

    ${request_headers}=    Backend_CommonKeywords.Token_Headers
    ${response}=    Backend_CommonKeywords.Calling_API_GET    ${BACKEND_URL}/api/tokenization/p2p/sof    ${expected_status_code}    ${request_headers}    ${TIMEOUT}
    ${account_number}=    Capture_SOF_If_Available    ${response}    ezcash

    #    3. Call the keyword to validate the response parameter and its expected value

    Backend_CommonKeywords.Response_Validation_Parameters    ${response.content}    ${expected_values}


POST /api/tokenization/p2p/txn/request
    [Documentation]    This API will be used to validate PIN and retrieve app token
    [Tags]    Login    Dashboard    Regression
    [Arguments]    ${data}    ${expected_status_code}    ${parameter_name}    ${expected_value}    @{expected_values}

    Set Log Level    TRACE

    #    1. Generate Request ID from RequestIDLibrary.py

    Backend_CommonKeywords.Generate_Request_ID_And_Set_Variable    ${data}    requestId

    #    1. Send request: POST /api/tokenization/p2p/txn/request
	#    2. Verify response status code: 200

    ${request_headers}=    Backend_CommonKeywords.Token_Headers
    ${response}=    Backend_CommonKeywords.Calling_API_POST    ${BACKEND_URL}/api/tokenization/p2p/txn/request    ${expected_status_code}    ${data}    ${request_headers}    ${TIMEOUT}
    ${TRAN_TOKEN_P2P_EZCASH}=    Capture_Transaction_Token_If_Available    ${response}  # Capture OTP data from the response if available
    Set Global Variable    ${TRAN_TOKEN_P2P_EZCASH}

    #    3. Call the keyword to validate the response parameter and its expected value

    Backend_CommonKeywords.Response_Validation_Parameters    ${response.content}    ${expected_values}
    
POST /api/ezcash/p2p/payment
    [Documentation]    This API will be used to validate PIN and retrieve app token
    [Tags]    Login    Dashboard    Regression
    [Arguments]    ${data}    ${expected_status_code}    ${parameter_name}    ${expected_value}    @{expected_values}

    Set Log Level    TRACE

    #    1. Send request: POST /api/ezcash/p2p/payment
	#    2. Verify response status code: 200
    Run Keyword If    "${TRAN_TOKEN_P2P_EZCASH}" != "None"    Set To Dictionary    ${data}    txnToken=${TRAN_TOKEN_P2P_EZCASH}    requestId=${request_id_new}
    
    ${request_headers}=    Backend_CommonKeywords.Token_Headers
    ${response}=    Backend_CommonKeywords.Calling_API_POST    ${BACKEND_URL}/api/ezcash/p2p/payment    ${expected_status_code}    ${data}    ${request_headers}    ${TIMEOUT}

    #    3. Call the keyword to validate the response parameter and its expected value

    Backend_CommonKeywords.Response_Validation_Parameters    ${response.content}    ${expected_values}

*** Test Cases ***

Resetting_eZCash_User_Status
    [Tags]    P2P_eZCash    Regression    DB
    Resetting_eZCash_User

GET /api/beneficiary/p2p/beneficiary - Success
    [Documentation]    Send request with valid data
    [Tags]    P2P_eZCash    Regression
    [Template]    GET /api/beneficiary/p2p/beneficiary

           200
    ...    Mention_actual_param    Mention_param_value
    ...    STATUS        SUCCESS

GET /api/tokenization/p2p/sof - Success
    [Documentation]    Send request with valid data
    [Tags]    P2P_eZCash    Regression
    [Template]    GET /api/tokenization/p2p/sof

           200
    ...    Mention_actual_param    Mention_param_value
    ...    MESSAGE       GET_ALL_SOF_SUCCESS
    ...    STATUS        SUCCESS

POST /api/tokenization/p2p/txn/request - Success
    [Documentation]    Send request with valid data
    [Tags]    P2P_eZCash    Regression
    [Template]    POST /api/tokenization/p2p/txn/request

    ${P2P_EZCASH_TXN_REQUEST}    200
    ...    Mention_actual_param    Mention_param_value
    ...    MESSAGE       P2P_TXN_FEE_REQUEST_SUCCESS
    ...    STATUS        SUCCESS

POST /api/ezcash/p2p/payment - Success
    [Documentation]    Send request with valid data
    [Tags]    P2P_eZCash    Regression
    [Template]    POST /api/ezcash/p2p/payment

    ${P2P_EZCASH_TXN}    200
    ...    Mention_actual_param    Mention_param_value
    ...    MESSAGE       PAYMENT_PROCESSING
    ...    STATUS        SUCCESS

