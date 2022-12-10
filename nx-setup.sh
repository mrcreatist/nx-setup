PROJECT_NAME=$1
APP_NAME=$2
SERVER_NAME = $3
RED='\033[0;31m'

echo -e "${RED}-------------------"
echo -e "${RED}Creating Nx project"
echo -e "${RED}-------------------"
npx create-nx-workspace@latest $PROJECT_NAME --nxCloud=false --preset=apps
cd $PROJECT_NAME

echo -e "${RED}------------------------"
echo -e "${RED}Installing ionic-angular"
echo -e "${RED}------------------------"
npm install --save-dev --exact @nxext/ionic-angular
nx generate @nxext/ionic-angular:application $APP_NAME --unitTestRunner none --e2eTestRunner none

echo -e "${RED}--------------------"
echo -e "${RED}Installing capacitor"
echo -e "${RED}--------------------"
npm install --save-dev --exact @nxext/capacitor --legacy-peer-deps

echo -e "${RED}-------------------"
echo -e "${RED}Installing Electron"
echo -e "${RED}-------------------"
npm i -D nx-electron

echo -e "${RED}--------------------"
echo -e "${RED}Installing Nest-js"
echo -e "${RED}--------------------"
npm install --save-dev --exact @nrwl/nest --legacy-peer-deps

echo -e "${RED}--------------------"
echo -e "${RED}Genrating Server App"
echo -e "${RED}--------------------"
nx g @nrwl/nest:app $SERVER_NAME

echo -e "${RED}------------------"
echo -e "${RED}Building $APP_NAME"
echo -e "${RED}------------------"
nx build $APP_NAME

echo -e "${RED}----------------------"
echo -e "${RED}Adding Android Support"
echo -e "${RED}----------------------"
nx run $APP_NAME:add:android

echo -e "${RED}------------------"
echo -e "${RED}Adding iOS Support"
echo -e "${RED}------------------"
nx run $APP_NAME:add:ios

echo -e "${RED}----------------------------------"
echo -e "${RED}Adding workspace.json for Electron"
echo -e "${RED}----------------------------------"
echo "{
  \"version\": 2,
  \"projects\": {
    \"${APP_NAME}\": \"apps/${APP_NAME}\"
    }
  }">workspace.json

echo -e "${RED}-----------------------"
echo -e "${RED}Adding Electron Support"
echo -e "${RED}-----------------------"
nx g nx-electron:app electron-app --frontendProject=$APP_NAME
nx build electron-app

echo -e "${RED}--------------"
echo -e "${RED}Setup complete"
echo -e "${RED}--------------"

echo -e "${RED}-------------------------------"
echo -e "${RED}Script-actions for package.json"
echo -e "${RED}-------------------------------"

echo \"'web'\": \"'nx build && nx serve'\",
echo \"'ios'\": \"'nx build && nx run '$APP_NAME':run:ios'\",
echo \"'android'\": \"'nx build && nx run '$APP_NAME':sync:android'\",
echo \"'electron'\": \"'npm run web & nx serve electron-app'\"