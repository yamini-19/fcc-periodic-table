#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Set up PSQL variable
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Query for the element based on the input
RESULT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                FROM elements e
                JOIN properties p ON e.atomic_number = p.atomic_number
                WHERE e.atomic_number::text = '$1' OR e.symbol = '$1' OR e.name ILIKE '$1';")

# Check if the result is empty
if [ -z "$RESULT" ]; then
  echo "I could not find that element in the database."
else
  # Parse the result into variables
  IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$RESULT"

  # Format the output
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a nonmetal, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi

