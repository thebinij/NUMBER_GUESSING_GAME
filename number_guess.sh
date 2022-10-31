#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess --tuples-only --no-align -c"
# Initializing Random number between 1 to 1000
SECRET="$(echo $(($RANDOM % 1000 + 1)))"

echo "Enter your username: "
read USERNAME
USER_DETAIL=$($PSQL "SELECT * FROM users WHERE name = '$USERNAME'")

# if user not found
if [[ -z $USER_DETAIL ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME') ")  
else
  echo $USER_DETAIL | while IFS='|' read NAME GAME_PLAYED BEST_NO_GUESS
  do
  echo "Welcome back, $NAME! You have played $GAME_PLAYED games, and your best game took $BEST_NO_GUESS guesses."
  done
fi
NO_OF_GUESSES=0

START_GAME(){
    if [[ -z $1 ]]
    then
      echo "Guess the secret number between 1 and 1000:"
    else
      echo $1
    fi
    read GUESS
    # increment guess
    ((NO_OF_GUESSES++))

    # if guess is not integer
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      START_GAME "That is not an integer, guess again:"
    else
      # if secret number is higher than guess
      if [[ $SECRET -gt $GUESS ]]
      then
      START_GAME "It's higher than that, guess again:"

      # if secret number is lower than guess
      elif [[ $SECRET -lt $GUESS ]]
      then
        START_GAME "It's lower than that, guess again:"
      else
        echo "You guessed it in $NO_OF_GUESSES tries. The secret number was $SECRET. Nice job!"
        # update games played
        UPDATE_GAME_PLAYED=$($PSQL "UPDATE users SET games_played = games_played +1 WHERE name = '$USERNAME'") 
        # update best_game if lower than previous
        if [[ $NO_OF_GUESSES -lt $BEST_NO_GUESS ]]
        then
          UPDATE_BEST_GAME=$($PSQL "UPDATE users SET guesses_in_best_game = $NO_OF_GUESSES WHERE name = '$USERNAME'") 
        fi
      fi
    fi
}
 
START_GAME