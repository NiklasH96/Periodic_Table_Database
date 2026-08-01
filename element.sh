#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Ask the DB directly. atomic_number::TEXT lets a number, symbol, or name all be compared safely.
ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius
                 FROM elements
                 JOIN properties USING(atomic_number)
                 JOIN types USING(type_id)
                 WHERE atomic_number::TEXT = '$1' OR symbol = '$1' OR name = '$1'")

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
else
  IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE MASS MELTING BOILING <<< "$ELEMENT"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi