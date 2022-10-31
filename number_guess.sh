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
else
  echo $USER_DETAIL
  echo "Welcome back, $USERNAME! You have played 4 games, and your best game took 10 guesses."
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
    ((NO_OF_GUESSES++))
    echo $SECRET
    # if secret number is higher than guess
    if [[ $SECRET -gt $GUESS ]]
    then
      START_GAME "It's higher than that, guess again:"
    # if secret number is lower than guess
    elif [[ $SECRET -lt $GUESS ]]
    then
      START_GAME "It's lower than that, guess again:"
    # guess must to equal to secret 
    else
      echo "You guessed it in $NO_OF_GUESSES tries. The secret number was $SECRET. Nice job!"
    fi
}

START_GAME