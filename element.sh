#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT_FINDER() {
  if [[ $1 =~ ^[0-9]+$ ]]
  then
  ATOMIC_NUMBER=$1
  ELEMENT=$($PSQL "select name, symbol from elements where atomic_number = '$ATOMIC_NUMBER';")
  IFS='|' read -r NAME SYMBOL <<< "$ELEMENT"
  fi

  if [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
  SYMBOL=$1
  ELEMENT=$($PSQL "select name, atomic_number from elements where symbol = '$SYMBOL';")
  IFS='|' read -r NAME ATOMIC_NUMBER <<< "$ELEMENT"
  fi

  if [[ $1 =~ ^[A-Z][a-z][a-z]+$ ]]
  then
  NAME=$1
  ELEMENT=$($PSQL "select symbol, atomic_number from elements where name = '$NAME';")
  IFS='|' read -r SYMBOL ATOMIC_NUMBER <<< "$ELEMENT"
  fi

  if [[ $ELEMENT ]]
  then
  PROPERTIES=$($PSQL "select atomic_mass, melting_point_celsius, boiling_point_celsius, type_id from properties where atomic_number = '$ATOMIC_NUMBER';")
  IFS='|' read -r MASS MPC BPC TYPE_ID <<< "$PROPERTIES"
  TYPE=$($PSQL"select type from types where type_id = $TYPE_ID;")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
  else echo I could not find that element in the database.
  fi
}

if [[ $1 ]]
then
ELEMENT_FINDER "$1"
else 
  echo Please provide an element as an argument.
fi