#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 

echo -ne "\033]0;Bums Bot by @MeoMunDep\007"

print_green() {
    echo -e "${GREEN}$1${NC}"
}

print_yellow() {
    echo -e "${YELLOW}$1${NC}"
}

print_red() {
    echo -e "${RED}$1${NC}"
}

check_node() {
    if ! command -v node &> /dev/null; then
        print_red "Node.js not found, installing..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt update && sudo apt install -y nodejs npm
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install node
        elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
            echo "Please install Node.js manually on Windows."
        fi
        print_green "Node.js installation completed."
    else
        print_green "Node.js is already installed."
    fi
}
check_node

check_git() {
    if ! command -v git &> /dev/null; then
        print_red "Git not found, installing..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt update && sudo apt install -y git
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install git
        elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
            echo "Please install Git manually on Windows."
        fi
        print_green "Git installation completed."
    else
        print_green "Git is already installed."
    fi
}
check_git

chmod +x "$0"

if [ -d "../node_modules" ]; then
    print_green "Found node_modules in parent directory"
    MODULES_DIR=".."
else
    print_green "Using current directory for node_modules"
    MODULES_DIR="."
fi

create_default_configs() {
    cat > configs.json << EOL
{
  "limit": 100,
  "countdown": 300,
  "delayEachAccount": [5, 8],
  "isSkipInvalidProxy": false,
  "howManyEnergyUpgrade": 10,
  "howManyRecoveryUpgrade": 10,
  "howManyTapUpgrade": 10,
  "howManyBonusChanceUpgrade": 10,
  "howManyBonusRatioUpgrade": 10,
  "maxCardPrice": 1000000,
  "combo": "101,102,103",
  "isDoTasks": true,
  "howManyTapsInOneTime": [10, 100],
  "isBuyBoosts": true,
  "isUpgradeCards": true,
  "infinityTapping": true,
  "trackingTapPoints": true,
  "openNoelGifts": true,
  "doSpin": true,
  "referralCode": "OVMEplvN"
}
EOL
}

check_configs() {
    if ! node -e "const cfg=require('./configs.json');if(typeof cfg.howManyAccountsRunInOneTime !== 'number' || cfg.howManyAccountsRunInOneTime < 1) throw new Error('Invalid config');" 2>/dev/null; then
        print_red "Invalid configuration detected. Resetting to default values..."
        create_default_configs
        print_green "Configuration reset completed."
    fi
}

while true; do
    clear
    echo "============================================================================"
    echo "    Bums BOT SETUP AND RUN SCRIPT by @MeoMunDep"
    echo "============================================================================"
    echo
    echo "Current directory: $(pwd)"
    echo "Node modules directory: $MODULES_DIR/node_modules"
    echo
    echo "1. Install/Update Node.js Dependencies"
    echo "2. Create/Edit Configuration Files"
    echo "3. Run the Bot"
    echo "4. Exit"
    echo
    read -p "Enter your choice (1-4): " choice

    case $choice in
        1)
            clear
            print_yellow "Installing/Updating Node.js dependencies..."
            cd "$MODULES_DIR"
            npm install user-agents axios colors https-proxy-agent socks-proxy-agent form-data
            cd - > /dev/null
            print_green "Dependencies installation completed!"
            read -p "Press Enter to continue..."
            ;;
        2)
            clear
            print_yellow "Setting up configuration files..."

            if [ ! -f configs.json ]; then
                create_default_configs
                print_green "Created configs.json with default values"
            fi

            check_configs

            for file in datas.txt proxies.txt tokens.txt; do
                if [ ! -f "$file" ]; then
                    touch "$file"
                    print_green "Created $file"
                fi
            done

            print_green "\nConfiguration files have been created/checked."
            print_yellow "Please edit the files with your data before running the bot."
            read -p "Press Enter to continue..."
            ;;
        3)
            clear
            print_yellow "Checking configuration before starting..."
            if ! check_configs; then
                print_red "Error: Invalid configuration detected. Please run option 2 to fix configuration."
                read -p "Press Enter to continue..."
                continue
            fi

            print_green "Starting the bot..."
            if [ -d "../node_modules" ]; then
                print_green "Using node_modules from parent directory"
            else
                print_green "Using node_modules from current directory"
            fi
            node meomundep
            read -p "Press Enter to continue..."
            ;;
        4)
            print_green "Exiting..."
            exit 0
            ;;
        *)
            print_red "Invalid option. Please try again."
            read -p "Press Enter to continue..."
            ;;
    esac
done
