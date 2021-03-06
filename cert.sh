#!/usr/bin/env bash
#* Copyright 2020 John Melody Me
#* Licensed under the Apache License, Version 2.0 (the "License");
#* you may not use this file except in compliance with the License.
#* You may obtain a copy of the License at
#
#* http://www.apache.org/licenses/LICENSE-2.0
#
#* Unless required by applicable law or agreed to in writing, software
#* distributed under the License is distributed on an "AS IS" BASIS,
#* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#* See the License for the specific language governing permissions and
#* limitations under the License.
# Please Do not Edit Without consent 
# @contact johnmelodyme@yandex.com
# Check isKeyToolInstalled?
# shellcheck disable=SC2078
if [/usr/bin/keytool]; then
    echo '*** Generating Encryption Key ***'
    # Generate 2048 bits RSA 256 Encryption with validity of 99999 days
    Keytool -genkey -v -keystore app.keystore -alias app_key -keyalg RSA -keysize 2048 -validity 99999
    echo '*** Done ***'
    sleep 3
    clear

    # shellcheck disable=SC2034
    for i in {1..1}
    do
        # shellcheck disable=SC2028
        echo '*** [Warning] DO NOT SKIP THIS INSTRUCTION UNLESS FAMILIAR *** \n'
        sleep 2
        echo 'After the key file {file_name_.keystore} generated, Please do not hesitate' 
        sleep 1
        echo 'to copy the file to the path of the project /path-to-project/android/app/'
        sleep 1 
        echo 'edit the {.~gradle/gradle.properties} add these lines'
        sleep 0.5
        echo "  
            MYAPP_RELEASE_STORE_FILE= <file_name_.keystore>
            MYAPP_RELEASE_KEY_ALIAS= <my-key-alias-something>
            MYAPP_RELEASE_STORE_PASSWORD= <The password you choose earlier with the keytool>
            MYAPP_RELEASE_KEY_PASSWORD= <The password you choose earlier with the keytool>
        "
        echo 'Finally update file {android/app/build.gradle} as the format following below : '
        sleep 1 
        echo "
            android {
            ...
            defaultConfig { ... }
            signingConfigs {
                release {
                    if (project.hasProperty('MYAPP_RELEASE_STORE_FILE')) {
                        storeFile file(MYAPP_RELEASE_STORE_FILE)
                        storePassword MYAPP_RELEASE_STORE_PASSWORD
                        keyAlias MYAPP_RELEASE_KEY_ALIAS
                        keyPassword MYAPP_RELEASE_KEY_PASSWORD
                    }
                }
            }
            buildTypes {
                release {
                    ...
                    signingConfig signingConfigs.release
                }
            }
        }
        "
        sleep 2
        # shellcheck disable=SC2162
        read  -p  'Are you really want to build this app? [Y/N]' prompt
        if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
        then 
            echo '*** building *** '
            ./gradlew assembleRelease
            echo 'Build Complete'
        else 
            echo 'You Cancelled Compilation.'
            sleep 1
            exit 0
        fi
    done 
else 
    echo 'KeyTool Not Found !Please Install Keytool'
fi