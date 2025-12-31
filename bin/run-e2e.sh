#!/bin/bash
echo "Installing extension dependencies"
npm install

echo "building extension"
npm run vscode:package:e2e

echo "installing e2e dependencies"
chmod -R 777 src/test/suite/test_data/sample_workspace/.openvscode-server
cd src/test/e2e
npm install
npx playwright install

echo "running openvscode-server docker"
docker compose up -d

echo "running tests"
npm test
EXIT_CODE=$?
cd ../../..

# uncomment the follow lines to block the pipeline when e2e tests fail
# if [ $EXIT_CODE -ne 0 ]; then
#   echo "Tests failed. Exiting..."
#   exit $EXIT_CODE
# fi