#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~~~~ THE SALON'S FABY ~~~~~\n"

echo -e "\nWelcome to Salon's Faby. \n"

MAIN_MENU() {
 
echo -e "What would you like today:\n"
#récuperer la liste des services
SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
#affichage de la liste
 echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE_NAME
do
 echo "$SERVICE_ID) $SERVICE_NAME"
done
 #choix du client
 echo -e "\nPlease choose a service"
read SERVICE_ID_SELECTED 

#vérification de l'existence du service
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
if [[  -z $SERVICE_NAME ]]; 
then
     echo -e "\Invalid option. Please try again."
     MAIN_MENU
      
    else
      echo -e "\nYou chose the service: $SERVICE_NAME"
      GET_CUSTOMER_INFO 
    fi
}


GET_CUSTOMER_INFO () {
# obtenir le téléphone 
        echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE

#données du client
 CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
 # si n'est pas déjà enregistré
        if [[ -z $CUSTOMER_NAME ]]
        then
          #demander la donnéee
          echo -e "\nI couldn't find your phone number. What's your name?"
          read CUSTOMER_NAME

        # récupérer customer_id
          CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
          # l'insérer dans base de données
          INSERT_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
          echo -e "\nWelcome $CUSTOMER_NAME"
        else 
        echo -e "\nWelcome back, $CUSTOMER_NAME !"
fi
         
}

MAIN_MENU

#enregistrement du rdv
echo -e "\nWhat time would you like your $SERVICE_NAME ?"
read SERVICE_TIME
#on récupère l'id du client
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
#on insère le rdv dans la table des rdv pour le client
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."