#!/bin/bash

# Function to display the selection menu
display_menu() {
  echo "-------------------------------------------------------------"
  echo "Step 1: Please select the resource tier for your kubelife installation:"
  echo "1. Tier 1: 500MB RAM, 1GB Storage"
  echo "2. Tier 2: 1GB RAM, 2GB Storage"
  echo "3. Tier 3: 2GB RAM, 4GB Storage"
  echo "-------------------------------------------------------------"
  echo "Please enter the number corresponding to your choice (1-3):"
}

# Function to set up kubelife based on the selected tier
configure_tier() {
  case $1 in
    1)
      RAM="500MB"
      STORAGE="1GB"
      ;;
    2)
      RAM="1GB"
      STORAGE="2GB"
      ;;
    3)
      RAM="2GB"
      STORAGE="4GB"
      ;;
    *)
      echo "Invalid choice. Exiting script."
      exit 1
      ;;
  esac
}

# Function to ask for backup option
ask_for_backup() {
  echo "-------------------------------------------------------------"
  echo "Step 2: Do you want to enable backups for your kubelife server? (y/n)"
  echo "-------------------------------------------------------------"
  echo "Please enter 'y' for yes or 'n' for no:"
}

# Function to back up kubelife data
backup_kubelife_data() {
  BACKUP_DIR="/kubelife_backup"
  TIMESTAMP=$(date +"%Y%m%d%H%M%S")

  # Create backup directory if it doesn't exist
  mkdir -p $BACKUP_DIR

  # Backup kubernetes-related files
  echo "Backing up kubelife data..."
  cp -r /etc/kubernetes $BACKUP_DIR/kubernetes_config_$TIMESTAMP
  cp -r /var/lib/kubelet $BACKUP_DIR/kubelet_data_$TIMESTAMP
  cp -r /var/lib/minikube $BACKUP_DIR/minikube_data_$TIMESTAMP

  # Inform the user about the backup location
  echo "Backup complete. Your Kubelife server data is stored in: $BACKUP_DIR"
}

# Start the script execution
echo "-------------------------------------------------------------"
echo "Step 3: Starting the kubelife installation..."
echo "-------------------------------------------------------------"

# Display the menu and capture user input
display_menu
read -p "Enter your choice (1, 2, or 3): " choice

# Configure based on the user's selection
configure_tier $choice

# Ask for backup option
ask_for_backup
read -p "Enter your choice (y or n): " backup_choice

if [[ "$backup_choice" == "y" || "$backup_choice" == "Y" ]]; then
  # Step 4: Back up kubelife data
  backup_kubelife_data
elif [[ "$backup_choice" == "n" || "$backup_choice" == "N" ]]; then
  echo "Backup not selected. Continuing with installation..."
else
  echo "Invalid input. Exiting script."
  exit 1
fi

# Inform the user of the selected configuration
echo "-------------------------------------------------------------"
echo "Step 4: You have selected Tier $choice"
echo "Allocated Resources: $RAM RAM, $STORAGE Storage"
echo "-------------------------------------------------------------"

# Proceed with kubelife installation based on the selected tier

# Step 5: Create the kubelife directory if it doesn't exist
echo "Step 5: Creating directory /kubelife if it doesn't already exist..."
mkdir -p /kubelife

# Step 6: Check Docker status and start it if not running
echo "-------------------------------------------------------------"
echo "Step 6: Checking Docker status..."
if ! systemctl is-active --quiet docker; then
  echo "Docker is not running. Starting Docker..."
  systemctl start docker
else
  echo "Docker is already running."
fi
echo "-------------------------------------------------------------"

# Step 7: Download and install Minikube
echo "Step 7: Downloading Minikube binary..."
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
mv minikube /usr/local/bin/

# Step 8: Download kubelife (renaming Minikube to kubelife)
echo "Step 8: Creating symbolic link for Kubelife..."
ln -s /usr/local/bin/minikube /usr/local/bin/kubelife

# Step 9: Set up the virtual machine (Minikube with the selected resources)
echo "-------------------------------------------------------------"
echo "Step 9: Setting up kubelife with $RAM RAM and $STORAGE storage..."
case $choice in
  1)
    echo "Allocating 500MB RAM and 1GB Storage for Minikube with --force flag..."
    minikube start --memory 512mb --disk-size 1g --driver=docker --force > /dev/null 2>&1
    ;;
  2)
    echo "Allocating 1GB RAM and 2GB Storage for Minikube with --force flag..."
    minikube start --memory 1g --disk-size 2g --driver=docker --force > /dev/null 2>&1
    ;;
  3)
    echo "Allocating 2GB RAM and 4GB Storage for Minikube with --force flag..."
    minikube start --memory 2g --disk-size 4g --driver=docker --force > /dev/null 2>&1
    ;;
esac

# Step 10: Final message indicating the completion of setup
echo "-------------------------------------------------------------"
echo "Step 10: Kubelife setup complete. You can use the 'kubelife' command to interact with your Kubernetes cluster."
echo "-------------------------------------------------------------"

# Step 11: Verify if kubelife started successfully
echo "Step 11: Verifying kubelife status..."
kubelife status
echo "With your dedicated resources and powerful tools, you're now ready to deploy and manage containers like a pro on a singleNode!"

root@laravelapp:/kubelife# 
root@laravelapp:/kubelife# cat install_kubelife.sh 
#!/bin/bash

# Function to display the selection menu
display_menu() {
  echo "-------------------------------------------------------------"
  echo "Step 1: Please select the resource tier for your kubelife installation:"
  echo "1. Tier 1: 500MB RAM, 1GB Storage"
  echo "2. Tier 2: 1GB RAM, 2GB Storage"
  echo "3. Tier 3: 2GB RAM, 4GB Storage"
  echo "-------------------------------------------------------------"
  echo "Please enter the number corresponding to your choice (1-3):"
}

# Function to set up kubelife based on the selected tier
configure_tier() {
  case $1 in
    1)
      RAM="500MB"
      STORAGE="1GB"
      ;;
    2)
      RAM="1GB"
      STORAGE="2GB"
      ;;
    3)
      RAM="2GB"
      STORAGE="4GB"
      ;;
    *)
      echo "Invalid choice. Exiting script."
      exit 1
      ;;
  esac
}

# Function to ask for backup option
ask_for_backup() {
  echo "-------------------------------------------------------------"
  echo "Step 2: Do you want to enable backups for your kubelife server? (y/n)"
  echo "-------------------------------------------------------------"
  echo "Please enter 'y' for yes or 'n' for no:"
}

# Function to back up kubelife data
backup_kubelife_data() {
  BACKUP_DIR="/kubelife_backup"
  TIMESTAMP=$(date +"%Y%m%d%H%M%S")

  # Create backup directory if it doesn't exist
  mkdir -p $BACKUP_DIR

  # Backup kubernetes-related files
  echo "Backing up kubelife data..."
  cp -r /etc/kubernetes $BACKUP_DIR/kubernetes_config_$TIMESTAMP
  cp -r /var/lib/kubelet $BACKUP_DIR/kubelet_data_$TIMESTAMP
  cp -r /var/lib/minikube $BACKUP_DIR/minikube_data_$TIMESTAMP

  # Inform the user about the backup location
  echo "Backup complete. Your Kubelife server data is stored in: $BACKUP_DIR"
}

# Start the script execution
echo "-------------------------------------------------------------"
echo "Step 3: Starting the kubelife installation..."
echo "-------------------------------------------------------------"

# Display the menu and capture user input
display_menu
read -p "Enter your choice (1, 2, or 3): " choice

# Configure based on the user's selection
configure_tier $choice

# Ask for backup option
ask_for_backup
read -p "Enter your choice (y or n): " backup_choice

if [[ "$backup_choice" == "y" || "$backup_choice" == "Y" ]]; then
  # Step 4: Back up kubelife data
  backup_kubelife_data
elif [[ "$backup_choice" == "n" || "$backup_choice" == "N" ]]; then
  echo "Backup not selected. Continuing with installation..."
else
  echo "Invalid input. Exiting script."
  exit 1
fi

# Inform the user of the selected configuration
echo "-------------------------------------------------------------"
echo "Step 4: You have selected Tier $choice"
echo "Allocated Resources: $RAM RAM, $STORAGE Storage"
echo "-------------------------------------------------------------"

# Proceed with kubelife installation based on the selected tier

# Step 5: Create the kubelife directory if it doesn't exist
echo "Step 5: Creating directory /kubelife if it doesn't already exist..."
mkdir -p /kubelife

# Step 6: Check Docker status and start it if not running
echo "-------------------------------------------------------------"
echo "Step 6: Checking Docker status..."
if ! systemctl is-active --quiet docker; then
  echo "Docker is not running. Starting Docker..."
  systemctl start docker
else
  echo "Docker is already running."
fi
echo "-------------------------------------------------------------"

# Step 7: Download and install Minikube
echo "Step 7: Downloading Minikube binary..."
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
mv minikube /usr/local/bin/

# Step 8: Download kubelife (renaming Minikube to kubelife)
echo "Step 8: Creating symbolic link for Kubelife..."
ln -s /usr/local/bin/minikube /usr/local/bin/kubelife

# Step 9: Set up the virtual machine (Minikube with the selected resources)
echo "-------------------------------------------------------------"
echo "Step 9: Setting up kubelife with $RAM RAM and $STORAGE storage..."
case $choice in
  1)
    echo "Allocating 500MB RAM and 1GB Storage for Minikube with --force flag..."
    minikube start --memory 512mb --disk-size 1g --driver=docker --force > /dev/null 2>&1
    ;;
  2)
    echo "Allocating 1GB RAM and 2GB Storage for Minikube with --force flag..."
    minikube start --memory 1g --disk-size 2g --driver=docker --force > /dev/null 2>&1
    ;;
  3)
    echo "Allocating 2GB RAM and 4GB Storage for Minikube with --force flag..."
    minikube start --memory 2g --disk-size 4g --driver=docker --force > /dev/null 2>&1
    ;;
esac

# Step 10: Final message indicating the completion of setup
echo "-------------------------------------------------------------"
echo "Step 10: Kubelife setup complete. You can use the 'kubelife' command to interact with your Kubernetes cluster."
echo "-------------------------------------------------------------"

# Step 11: Verify if kubelife started successfully
echo "Step 11: Verifying kubelife status..."
kubelife status
echo "With your dedicated resources and powerful tools, you're now ready to deploy and manage containers like a pro on a singleNode!"

