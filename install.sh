#!/bin/bash

backup () 
{
    for file in ".bashrc" ".bash_profile" ".zshrc"
    do
        #If we find a file, back it up
        if [ -e ~/"$file" ]; then

            #create backup directory if we need to
            if [ ! -d ~/backup_dotfiles ]; then
                echo "Creating configuration backup directory, ~/backup_dotfiles"
                mkdir ~/backup_dotfiles
            fi

            echo "Backing up $file to ~/backup_dotfiles"
            mv ~/"$file" ~/backup_dotfiles/"$file"
        fi
    done

    if [ -d ~/.oh-my-zsh ]; then
        mv ~/.oh-my-zsh ~/backup_dotfiles/
    fi
}


install () 
{
    echo -e "\nInstalling new configuration"

    if [ ! -d ~/backup_dotfiles ]; then
        backup
    fi

    cp ~/cs190lab3/.zshrc ~/cs190lab3/.bashrc ~/cs190lab3/.bash_profile ~/
    cp -r ~/cs190lab3/.oh-my-zsh ~/ 2>/dev/null
}


restore_personal_backups() 
{
    rm -f ~/.bash_profile
    rm -rf ~/.oh-my-zsh
    cp ~/backup_dotfiles/.zshrc ~/backup_dotfiles/.bashrc ~/backup_dotfiles/.bash_profile ~/ 2>/dev/null
    cp -r ~/backup_dotfiles/.oh-my-zsh ~/ 2>/dev/null

    echo -e "\nBackup configuration restored.\n"
}


restore_cs_defaults() 
{
    rm -f ~/.bash_profile
    rm -rf ~/.oh-my-zsh
    cp /usr/local/adm/nu/.zshrc /usr/local/adm/nu/.bashrc /usr/local/adm/nu/.zprofile ~/
    ypchsh $USER /bin/bash

    echo -e "\nDefault CS configuration restored.\n"

    exit;
}


change_default_shell() 
{
    # change the default shell
    echo -e "\nAssign a default shell"
    select resp in "Bash" "Zsh" "No_Change"; do
        case $resp in
            Bash )      ypchsh $USER /bin/bash; break;;
            Zsh )       ypchsh $USER /bin/zsh;  break;;
            No_Change ) exit;;
        esac
    done
}


echo -e "Welcome to the awesome shell configuration tool, made by Tyler!"
echo -e "This tool comes with no warranty. If it messes something up, I"
echo -e "am not liable, but it should work."
echo -e "\nThis tool will backup dotfiles to the folder \"~/backup_dotfiles\""

echo -e "\nNOTE: To see changes after running the script you must close your\n"
echo -e "terminal and open a new one.\n"

echo -e "Enjoy!\n"

# intro question
echo "What would you like to do?"
select resp in "Install_CS190_Shell" "Restore_My_Old_Configuration" "Restore_To_CS_Defaults" "Change_Default_Shell" "Exit"; do
    case $resp in
        Install_CS190_Shell )           install; break;;
        Restore_My_Old_Configuration )  restore_personal_backups;  break;;
        Restore_To_CS_Defaults )        restore_cs_defaults; break;;
        Change_Default_Shell )          change_default_shell; exit;;
        Exit ) exit;;
    esac
done

change_default_shell

# ending prompt
echo -e "\nDone. Please logout+login to see the changes"