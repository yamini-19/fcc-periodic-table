#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 1
fi

ELEMENT=$1

# Check if ELEMENT is a number
if [[ $ELEMENT =~ ^[0-9]+$ ]]; then
    # If it's a number, query by atomic_number
    OUTPUT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
                    FROM elements AS e 
                    JOIN properties AS p ON e.atomic_number = p.atomic_number 
                    WHERE e.atomic_number = $ELEMENT;")
else
    # If it's not a number, query by symbol or name
    OUTPUT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
                    FROM elements AS e 
                    JOIN properties AS p ON e.atomic_number = p.atomic_number 
                    WHERE e.symbol = '$ELEMENT' OR e.name = '$ELEMENT';")
fi

if [[ -z $OUTPUT ]]; then
  echo "I could not find that element in the database."
else
  echo "$OUTPUT" | while IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL ATOMIC_MASS MELTING_POINT BOILING_POINT; do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a nonmetal, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
fi

