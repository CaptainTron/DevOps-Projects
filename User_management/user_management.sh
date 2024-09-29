#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

show_menu() {
    echo "===================="
    echo "User Management Menu"
    echo "===================="
    echo "1. Add User"
    echo "2. Delete User"
    echo "3. Modify User"
    echo "4. Create Group"
    echo "5. Backup Directory"
    echo "6. Exit"
}

add_user() {
    read -p "Enter username: " username
    useradd $username
    passwd $username
    echo "User $username added successfully!"
}

delete_user() {
    read -p "Enter username to delete: " username
    userdel -r $username
    echo "User $username deleted successfully!"
}

modify_user() {
    read -p "Enter username to modify: " username
    read -p "Enter new shell for user (e.g., /bin/bash): " shell
    usermod -s $shell $username
    echo "User $username modified successfully!"
}

create_group() {
    read -p "Enter group name: " groupname
    groupadd $groupname
    echo "Group $groupname created successfully!"
}

backup_directory() {
    read -p "Enter directory to backup: " dir
    read -p "Enter backup destination (e.g., /backup/): " backup_dest
    if [ -d "$dir" ]; then
        backup_name=$(basename $dir)_$(date +%F).tar.gz
        tar -czvf $backup_dest/$backup_name $dir
        echo "Backup completed: $backup_dest/$backup_name"
    else
        echo "Directory $dir does not exist."
    fi
}

while true; do
    show_menu
    read -p "Choose an option [1-6]: " option
    case $option in
        1) add_user ;;
        2) delete_user ;;
        3) modify_user ;;
        4) create_group ;;
        5) backup_directory ;;
        6) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option, please try again." ;;
    esac
done
