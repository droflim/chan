##############################################################################################
##  ##  channelinfo.tcl for eggdrop by Ford_Lawnmower irc.geekshed.net #Script-Help     ##  ##
##############################################################################################
## To use this script you must set channel flag +cinfo (ie .chanset #chan +cinfo)           ##
##############################################################################################
##      ____                __                 ###########################################  ##
##     / __/___ _ ___ _ ___/ /____ ___   ___   ###########################################  ##
##    / _/ / _ `// _ `// _  // __// _ \ / _ \  ###########################################  ##
##   /___/ \_, / \_, / \_,_//_/   \___// .__/  ###########################################  ##
##        /___/ /___/                 /_/      ###########################################  ##
##                                             ###########################################  ##
##############################################################################################
##  ##                             Start Setup.                                         ##  ##
##############################################################################################
namespace eval channelinfo {
## change cmdchar to the trigger you want to use                                        ##  ##
  variable cmdchar "!"
## change command to the word trigger you would like to use.                            ##  ##
## Keep in mind, This will also change the .chanset +/-command                          ##  ##
  variable command "cinfo"
## change textf to the colors you want for the text.                                    ##  ##
  variable textf "\017\00304"
## change tagf to the colors you want for tags:                                         ##  ##  
  variable tagf "\017\002"
## Change logo to the logo you want at the start of the line.                           ##  ##  
  variable logo "\017\00314\002C\00304hannel \00314I\00304nfo\00314:\017"
## Change lineout to the results you want. Valid results are channel users modes topic  ##  ##
  variable lineout "channel users modes topic"
##############################################################################################
##  ##                           End Setup.                                              ## ##
##############################################################################################  
  variable channel ""
  setudef flag $channelinfo::command
  bind pub -|- [string trimleft $channelinfo::cmdchar]${channelinfo::command} channelinfo::list
  bind raw -|- "322" channelinfo::main
}
proc channelinfo::main {from key text} {

  if {[regexp -- {(#.*?)\s(.*?)\s:\[(.*?)\]\s(.*)$} $text fullmatch channel users modes topic]} {
    set channel "${channelinfo::tagf}Channel: ${channelinfo::textf}${channel}"
    set users "${channelinfo::tagf}Users: ${channelinfo::textf}${users}"
    set modes "${channelinfo::tagf}Modes: ${channelinfo::textf}${modes}"
    set topic "${channelinfo::tagf}Topic: ${channelinfo::textf}[encoding convertto utf-8 ${topic}]"
    putserv "PRIVMSG $channelinfo::channel :$channelinfo::logo $channelinfo::textf [subst [regsub -all -nocase {(\S+)} $channelinfo::lineout {$\1}]]"
  } elseif {[regexp -- {(#.*?)\s(.*?)\s:(.*)$} $text fullmatch channel users topic]} {
    set modes ""
    set channel "${channelinfo::tagf}Channel: ${channelinfo::textf}${channel}"
    set users "${channelinfo::tagf}Users: ${channelinfo::textf}${users}"
    set topic "${channelinfo::tagf}Topic: ${channelinfo::textf}[encoding convertto utf-8 ${topic}]"
    putserv "PRIVMSG $channelinfo::channel :$channelinfo::logo $channelinfo::textf [subst [regsub -all -nocase {(\S+)} $channelinfo::lineout {$\1}]]"
  }
}
proc channelinfo::list {nick host hand chan text} {
  if {[lsearch -exact [channel info $chan] "+${channelinfo::command}"] != -1} {
    namespace eval channelinfo {
      variable channel ""
    }
    variable channelinfo::channel $chan
    putserv "LIST #[string trimleft $text "#"]"
  }
}
putlog "\002*Loaded* \017\00314\002C\00304hannel \00314I\00304nfo\00314:\017 \002by \
Ford_Lawnmower irc.GeekShed.net #Script-Help" 
