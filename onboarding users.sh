# Shell Scripting.
# This script will: 
# Read a CSV file that contains 20 new Linux users.
# Create each user on the server and add to an existing group called 'Developers'.
# Check for the existence of the user on the system, before it will attempt to create that it.
# The user that is being created also must also have a default home folder
# Each user should have a .ssh folder within its HOME folder. If it does not exist, then it will be created.
# For each user’s SSH configuration, We will create an authorized_keys file and add the below public key.

#!/bin/bash
userfile=$(cat names.csv)
PASSWORD=password123

# Ensure the user running this script has sudo privilege
    if [ $(id -u) -eq 0 ]; then

# Reading the CSV file
        for user in $userfile;
        do
            echo $user
        if id "$user" &>/dev/null
        then
            echo "User Exist"
        else

# Create a new user
        useradd -m -d /home/$user -s /bin/bash -g developers $user
        echo "New User Created"
        echo


# Create a ssh folder in the user home folder
        su - -c "mkdir ~/.ssh" $user
        echo ".ssh directory created for new user"
        echo

# Set the user permission for the ssh dir
         su - -c "chmod 700 ~/.ssh" $user
         echo "user permission for .ssh directory set"
         echo

# Create an authorized-key file
        su - -c "touch ~/.ssh/authorized_keys" $user
        echo "Authorized Key File Created"
        echo

# Set permission for the key file
        su - -c "chmod 600 ~/.ssh/authorized_keys" $user
        echo "user permission for the Authorized Key File set"
        echo

# Create and set public key for users in the server
        cp -R "/home/ubuntu/shell/id_rsa.pub" "/home/$user/.ssh/authorized_keys"
        echo "Copyied the Public Key to New User Account on the server"
        echo
        echo

        echo "USER CREATED"

# Generate a password.
sudo echo -e "$PASSWORD\n$PASSWORD" | sudo passwd "$user" 
sudo passwd -x 5 $user
            fi
        done
    else
    echo "Only an Administrator Can Onboard A User"
    fi