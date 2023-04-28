class Constants {

    static final String MASTER_BRANCH = 'dev'

    static final String QA_BUILD = 'Debug'
    static final String RELEASE_BUILD = 'Release'

    static final String INTERNAL_TRACK = 'internal'
    static final String RELEASE_TRACK = 'release'
}

def getBuildType() {
    switch (env.BRANCH_NAME) {
        case Constants.MASTER_BRANCH:
            return Constants.RELEASE_BUILD
        default:
            return Constants.QA_BUILD
    }
}

def getTrackType() {
    switch (env.BRANCH_NAME) {
        case Constants.MASTER_BRANCH:
            return Constants.RELEASE_TRACK
        default:
            return Constants.INTERNAL_TRACK
    }
}

def isDeployCandidate() {
    return ("${env.BRANCH_NAME}" =~ /(dev|main)/)
}

pipeline {
    agent { dockerfile true }
    environment {
        appName = 'AndriodApp'
        APPCENTER_API_TOKEN = credentials('emmanuel-appcenter-api-token')

        // KEY_PASSWORD = credentials('keyPassword')
        // KEY_ALIAS = credentials('keyAlias')
        // KEYSTORE = credentials('keystore')
        // STORE_PASSWORD = credentials('storePassword')
    }
    stages {
        stage('Run Tests') {
            steps {
                echo 'Running Tests'
                script {
                    VARIANT = getBuildType()
                    sh "./gradlew test${VARIANT}UnitTest"
                }
            }
        }
        stage('Build Bundle') {
            when { expression { return isDeployCandidate() } }
            steps {
                echo 'Building'
                script {
                    VARIANT = getBuildType()
                    sh "./gradlew  bundle${VARIANT}"
                }
            }
        }
        stage('Deploy App to App Center') {
            when { expression { return isDeployCandidate() } }
            steps {
                echo 'Deploying'
                script {
                    VARIANT = getBuildType()
                    TRACK = getTrackType()

                    if (TRACK == Constants.RELEASE_TRACK) {
                        timeout(time: 5, unit: 'MINUTES') {
                            input "Proceed with deployment to ${TRACK}?"
                        }
                    }

                    try {
                        CHANGELOG = readFile(file: 'CHANGELOG.txt')
                    } catch (err) {
                        echo "Issue reading CHANGELOG.txt file: ${err.localizedMessage}"
                        CHANGELOG = ''
                    }

                    appCenter apiToken: APPCENTER_API_TOKEN,
                        ownerName: 'emmanuel ogah',
                        appName: 'andriod-app-cicd',
                        pathToApp: "**/outputs/bundle/${VARIANT.toLowerCase()}/*.apk",
                        distributionGroups: 'emmanuel ogah'
                }
            }
        }
    }
}
