#!/bin/bash
CONFIG_DIR=~/.fado;
DEFAULT_WORKSPACE=$CONFIG_DIR/.default_workspace;
[ -d $CONFIG_DIR ] || mkdir -p $CONFIG_DIR;
[ -f $DEFAULT_WORKSPACE ] || touch $DEFAULT_WORKSPACE;
#
# $1 - workspace path
# $2 - workspace name
# $3 - [-default] mark workspace as default
function init(){
  local WORKSPACE_CONFIG=$CONFIG_DIR/$2;
  #create config directory if not exisitng
  [ -d $CONFIG_DIR ] || mkdir -p $CONFIG_DIR;
  #create workspace directory if not exisitng
  [ -f $WORKSPACE_CONFIG ] || touch $WORKSPACE_CONFIG;
  echo "# maven one liner config file" | cat >  $WORKSPACE_CONFIG;
  echo "# WORKSPACE" | cat >>  $WORKSPACE_CONFIG;
  echo "#  - name: "$2 | cat >> $WORKSPACE_CONFIG;
  echo "#  - workspace path: "$1 | cat >> $WORKSPACE_CONFIG;
  echo "# PROJECTS" | cat >> $WORKSPACE_CONFIG;
  #declare associative array
  echo "delcare -A PROJECTS" | cat >> $WORKSPACE_CONFIG;

  #find all maven projects in worskpace path
  find $1 -name pom.xml | while read project; do
    #echo "Processing file '$project'"
    local project_path=`dirname $project`
    local project_name=`basename $project_path`
    echo "PROJECTS['$project_name']='$project_path';" | cat >> $WORKSPACE_CONFIG;
  done


  #set current workspace as default
  if [[ "$3" == "-default" ]];then
    echo $2 | cat > $DEFAULT_WORKSPACE
  fi
}

function list_workspaces(){
  echo 'Configured workspaces:';
  ls $CONFIG_DIR | while read workspace; do
    if [ "$workspace" == "$(cat $DEFAULT_WORKSPACE)" ];then
      echo " "$workspace" (default)";
    else
      echo " "$workspace"";
    fi
  done
}
