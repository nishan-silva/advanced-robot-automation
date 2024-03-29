*** Settings ***
Documentation    Keywords that can be used in all suites are stored here.
Library    AppiumLibrary
Library    OperatingSystem
Library    Process
Variables    ../../TestData/Staging_Frontend_TestData.py
Resource    ../../KeywordLibraries/Frontend/OnboardingAndLogin.robot
Resource    ../../PageObjects/Android/Logout.robot
Resource    ../../PageObjects/Android/HamburgerMenu.robot
Resource    ../../PageObjects/Android/BottomSheet.robot

*** Variables ***

#*** Application Variables ***
${APP_PACKAGE}     lk.tc.finpal
${APP_ACTIVITY}    lk.tc.finpal.SplashScreenActivity
${APPIUM_PORT_DEVICE_1}        4723
${APPIUM_PORT_DEVICE_2}        4725
${PLATFORM_ANDROID}        Android
${PLATFORM_IOS}        iOS
${APK_PATH}     /Users/nishansilva/Test_Automation/ADL/genie-app-automation/Apps/Android/Genie.apk
${IPA_PATH}    /Users/nishansilva/Test_Automation/ADL/genie-app-automation/Apps/iOS/calculator.ipa


*** Keywords ***
####################################################################################################################
# *** Common ***
####################################################################################################################
Open_Android_Genie_App
    [Arguments]    ${APPIUM_PORT}=${APPIUM_PORT_DEVICE_1}
    Open Application    http://127.0.0.1:${APPIUM_PORT}/wd/hub    platformName=${PLATFORM_ANDROID}    deviceName=emulator-5554    appPackage=${APP_PACKAGE}    appActivity=${APP_ACTIVITY}    automationName=UiAutomator2    app=${APK_PATH}

Open_iOS_Genie_App
    [Arguments]    ${APPIUM_PORT}=${APPIUM_PORT_DEVICE_1}
    Open Application    http://127.0.0.1:${APPIUM_PORT}/wd/hub    automationName=XCUITest    platformName=${PLATFORM_IOS}    platformVersion=17.2    bundleId=com.petri.calculator.calculator    deviceName=iPhone 15    app=${IPA_PATH}

Capture Screenshot
    ${screenshot_path}=    Capture Page Screenshot
    Log    ${screenshot_path}    # Log the screenshot path if needed
    Run Keyword If    '${screenshot_path}' != 'None'    Log    Taking screenshot: ${screenshot_path}
    Run Keyword If    '${screenshot_path}' != 'None'    Capture Screenshot Locally    ${screenshot_path}

Capture Screenshot Locally
    [Arguments]    ${screenshot_path}
    Run Keyword If    '${screenshot_path}' != 'None'    Capture Page Screenshot    ${screenshot_path}

Scroll Element Into View If Not Visible
    [Arguments]    ${locator}
    ${element_visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    timeout=5s
    Run Keyword If    not ${element_visible}    Scroll Down

Scroll Down
    Swipe    500    1800    500    100    # Adjust the coordinates as per your app's scrolling needs

Login_Device_1
    [Arguments]    ${permission_button_text}    ${language_button_text}    ${select_skip_or_proceed}    ${select_skip}    ${mobile_no}    ${button_text_continue}    ${enter_otp_value}    ${enter_nic_value}    ${select_continue}
    Open_Genie_App_Device_1
    Permission_Can_Be_Allowed_Or_Denied    ${button_text_permisson_allow}
    Language_Can_Be_Selected    ${button_text_language_english}
    Skip_Button_Can_Be_Selected_in_Referral_Screen    ${button_text_skip}
    Welcome_Screen_Should_Be_Visible    ${button_text_skip}
    Mobile_Number_Can_Be_Entered_In_The_Mobile_Number_Enter_Screen    ${MOBILE_NUMBER} 
    Check_Box_Can_Be_Selected_In_The_Mobile_Number_Enter_Screen
    Continue_Button_Can_Be_Selected_In_The_Mobile_Number_Enter_Screen    ${button_text_continue}
    OTP_Can_Be_Enterd_In_OTP_Enter_Screen    ${OTP}
    NIC_Can_Be_Enterd_In_NIC_Enter_Screen    ${NIC}    ${button_text_continue}
    PIN_Can_Be_Enterd_In_PIN_Enter_Screen

Login_Device_2
    [Arguments]    ${permission_button_text}    ${language_button_text}    ${select_skip_or_proceed}    ${select_skip}    ${mobile_no}    ${button_text_continue}    ${enter_otp_value}    ${enter_nic_value}    ${select_continue}
    Open_Genie_App_Device_2
    Permission_Can_Be_Allowed_Or_Denied    ${button_text_permisson_allow}
    Language_Can_Be_Selected    ${button_text_language_english}
    Skip_Button_Can_Be_Selected_in_Referral_Screen    ${button_text_skip}
    Welcome_Screen_Should_Be_Visible    ${button_text_skip}
    Mobile_Number_Can_Be_Entered_In_The_Mobile_Number_Enter_Screen    ${MOBILE_NUMBER} 
    Check_Box_Can_Be_Selected_In_The_Mobile_Number_Enter_Screen
    Continue_Button_Can_Be_Selected_In_The_Mobile_Number_Enter_Screen    ${button_text_continue}
    OTP_Can_Be_Enterd_In_OTP_Enter_Screen    ${OTP}
    NIC_Can_Be_Enterd_In_NIC_Enter_Screen    ${NIC}    ${button_text_continue}
    PIN_Can_Be_Enterd_In_PIN_Enter_Screen
    
Uninstall APK
    ${package_name}=    Set Variable    ${APP_PACKAGE}   # Replace with your package name
    ${result}=    Run Process    adb    uninstall    ${package_name}
    Should Be Equal As Strings    ${result.rc}    0    # Check if the process was successful (return code 0)
    Log    Uninstallation completed successfully

Logout
    [Arguments]    ${bottom_sheet_button_text}    ${hamburger_button_text}    ${logout_popup_button_text}
    ${bottom_sheet_xpath}    ANDROID_GET_BOTTOM_SHEET_XPATH    ${bottom_sheet_button_text}
    Wait Until Element Is Visible    ${bottom_sheet_xpath}
    Click Element    ${bottom_sheet_xpath}
    ${hamburger_xpath}    ANDROID_GET_HAMBURGER_MENU_XPATH    ${hamburger_button_text}
    Scroll Element Into View If Not Visible    ${hamburger_xpath}
    Wait Until Element Is Visible    ${hamburger_xpath}
    Click Element    ${hamburger_xpath}
    ${logout_popup_button_xpath}    ANDROID_GET_LOGOUT_POPUP_XPATH    ${logout_popup_button_text}
    Wait Until Element Is Visible    ${logout_popup_button_xpath}
    Click Element    ${logout_popup_button_xpath}
    Close Application
