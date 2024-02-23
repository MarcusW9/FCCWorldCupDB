#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#pipe csv in
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
 echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
 
  #This is so that we don't add the column header
  if [[ $YEAR != "year" ]] 
  then
  #normally get teams_id but since we are dealing with losers + winners we can get them separately and aggregate

  #Winner to name
  WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
  echo "Winner's Team ID: $WINNER_ID"
  if [[ -z $WINNER_ID ]] 
  then 
    INSERT_TEAM_ID="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"

  fi

  #Opponent to name
  OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
  if [[ -z $OPPONENT_ID ]] 
  then 
    INSERT_TEAM_ID="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
  fi

#Insert the rows into the games table
  INSERT_INTO_GAMES="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
  VALUES($YEAR,'$ROUND', $WINNER_ID, '$OPPONENT_ID', $WINNER_GOALS, $OPPONENT_GOALS)")"

  fi
done

