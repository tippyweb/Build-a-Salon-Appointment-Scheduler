#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

######################################################################
Salon Appointment Scheduler - 2024-09-29 - All tests passed
######################################################################

echo -e "\n~~~~~ My Salon ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  else
    echo -e "\nWelcome to My Salon, how can I help you?\n"
  fi

  # get available services
  SERVICES=$($PSQL "SELECT * FROM services;")
    
  # display available services
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) MAKE_APPOINTMENT 1 ;;
    2) MAKE_APPOINTMENT 2 ;;
    3) MAKE_APPOINTMENT 3 ;;
    4) MAKE_APPOINTMENT 4 ;;
    5) MAKE_APPOINTMENT 5 ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

MAKE_APPOINTMENT() {
  SERVICE_ID_SELECTED=$1;
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")

 # get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
        
  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
      
    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
  fi

  # get appointment time
  echo -e "\nWhat time would you like your $(echo $SERVICE_NAME | sed -E 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')?"
  read SERVICE_TIME

  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
        
  # insert appointment data
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")

  # display a confirmation message
  echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -E 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g').\n"
 
}

MAIN_MENU