#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ ! $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

input=$1;

element=$($PSQL "select 
  e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type
from elements e
left join properties p on e.atomic_number = p.atomic_number
left join types t on p.type_id = t.type_id
where e.atomic_number=$((input)) or e.symbol='${input}' or e.name='${input}'
limit 1")

if [[ -z $element ]]; then
  echo "I could not find that element in the database."
  exit
else
  oldIFS=$IFS
  IFS='|'
  read -ra cols <<< "$element"
  IFS=$oldIFS
  echo "The element with atomic number ${cols[0]} is ${cols[2]} (${cols[1]}). It's a ${cols[6]}, with a mass of ${cols[3]} amu. ${cols[2]} has a melting point of ${cols[4]} celsius and a boiling point of ${cols[5]} celsius."
fi
