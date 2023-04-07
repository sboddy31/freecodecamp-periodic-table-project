#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
 echo "Please provide an element as an argument."
 exit
else
ELEMENT_INPUT=$1
fi

# if input is atomic number
if [[ $ELEMENT_INPUT =~ ^[1-9]+$ ]]
then
  #get element info from atomic number
  ELEMENT_INFO=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $ELEMENT_INPUT")

# if input is name or symbol
else
 #get element info from element name
  ELEMENT_INFO=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$ELEMENT_INPUT' OR symbol = '$ELEMENT_INPUT'")
fi  

# if input is invalid
if [[ -z $ELEMENT_INFO ]]
then
  echo "I could not find that element in the database."
  exit
fi

echo "$ELEMENT_INFO" | while IFS="|" read ID NUMBER SYMBOL NAME MASS MELTING BOILING TYPE
do 
echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done
