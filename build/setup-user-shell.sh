#!/bin/bash
# @package exadra37-docker-images/dockerize-graphical-user-interface-app
# @link    https://gitlab.com/u/exadra37-docker-images/dockerize-graphical-user-interface-app
# @since   11 March 2017
# @license GPL-3.0
# @author  Exadra37(Paulo Silva) <exadra37ingmailpointcom>
#
# Social Links:
# @link    Auhthor:  https://exadra37.com
# @link    Gitlab:   https://gitlab.com/Exadra37
# @link    Github:   https://github.com/Exadra37
# @link    Linkedin: https://uk.linkedin.com/in/exadra37
# @link    Twitter:  https://twitter.com/Exadra37

########################################################################################################################
# Functiions
########################################################################################################################

    function Print_Text_With_Label()
    {
        local _label_text="${1}"

        local _text="${2}"

        local _label_background_color="${3:-42}"

        local _text_background_color="${4:-229}"

        printf "\n\e[1;${_label_background_color}m ${_label_text}:\e[30;48;5;${_text_background_color}m ${_text} \e[0m \n"
    }


########################################################################################################################
# Variables Arguments
########################################################################################################################

    container_user="${1?}"

    container_shell="${2?}"

    host_setup_user_shell_file="${3}"


########################################################################################################################
# Execution
########################################################################################################################

    Print_Text_With_Label "Container User" "${container_user}"
    Print_Text_With_Label "Container Shell" "${container_shell}"
    Print_Text_With_Label "Host Setup User Shell File" "${host_setup_user_shell_file}"

    # Let's give the User the chance to customize the Shell
    if [ -f "${host_setup_user_shell_file}" ]
        then
            bash "${host_setup_user_shell_file}" "${container_user}" "${container_shell}"

    # If setup user shell file is found in the given path and the Shell to setup is ZSH we will install ZSH with awesome
    #  Oh My Zsh package to increase the Shell functionality and productivity, with the added benefit of coloured output.
    elif [ 'zsh' == "${container_shell##*/}" ]
        then
            # Curl and Git are dependencies necessary to install Oh My Zsh
            apt-get -y install \
                zsh \
                curl \
                git && \
            su "${container_user}" -c 'bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"' &&
            chsh -s "/usr/bin/zsh" "${container_user}"
    fi
