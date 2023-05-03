#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE games, teams;")"

# Insert into table teams
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    # Insert WINNER teams
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")"
    if [[ -z $WINNER_ID ]]
    then
      WINNER_ID="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');SELECT currval('teams_team_id_seq');")"
      #echo "Inserted Winner team - $WINNER into teams table. team_id: $WINNER_ID"
    fi

    # Insert OPPONENT teams
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")"
    if [[ -z $OPPONENT_ID ]]
    then
      OPPONENT_ID="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');SELECT currval('teams_team_id_seq');")"
      #echo "Inserted Opponent team - $OPPONENT into teams table. team_id: $OPPONENT_ID"
    fi

    # Insert into table games
    echo "$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID)")"
  fi
done