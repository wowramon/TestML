import json # importamos la libreria json
import requests # importamos la libreria requests para instalar el modulo Pip install requests
import logging  # Importamos La libreria de Logging la cual nos ayudara a crear el fichero log para Instalar el modulo pip install logging


SITE_ID =  "MLA"  # Declaramos variables Para el site ID


def Inputseller():  #Funcion que nos retorna el Seller_ID
    
 
    AnswerBool = False #Creamos un Boolean y la iniciamos en FALSE
    num = 0  #declaramos un int para guardar nuestra respuesta
    
    while(not AnswerBool): #Bucle mientras que el boolean sea False este se ejecutara continuamente
        try:
            num = int(input("Introduce El Seller_ID :\n ")) #Input funcion que espera una respuesta del usuario dicha respuesta es almacenada en NUM = INT
            AnswerBool = True #Declaramos True al boolean para salir del bucle
        except ValueError: #en caso de que ingreses un campo no valido, el ID debe ser INT
            print('Error, introduce Solo numeros en el Campo del Seller_ID')
     
    return num #retornamos el ID que ingresamos

def InputNameF(): #Repetimos funcion pero esta vez para darle un nombre al archivo, en el caso de que queramos hacer consultas con diferentes ID
    AnswerBool = False
    Fichename = 'default' #Variable donde se guardara la respuesta del input declarado en default
    
    while(not AnswerBool):
        try:
            Fichename = str(input("Introduce El Nombre del Fichero :\n "))
            AnswerBool = True
        except ValueError:
            print('Error al ingresar nombre')

     
    return Fichename

def processing(Seller): #Metodo que hace el request al Api e inicia el recorrido por el json

    curl = ' https://api.mercadolibre.com/sites/' + SITE_ID + '/search?seller_id=' + str(Seller) + ''  # creamos el cURL

    res = requests.get(curl)  # realizamos la solicitud de Get para obtener el archivo Json
    listJson = json.loads(res.content) #Cargamos en memoria el contenido del Json

    if listJson['paging']['total'] != 0 : #Verificamos si el SELLER_ID ingresado existe

        Name = InputNameF() #Iniciamos el Input para el nombre del archivo
        Search(listJson, Name) #Iniciamos el metodo que recorre y genera el el fichero

    else:
        print('Error,SELLER_ID No existe') #Mensaje de error
        exit() #Interrupcion del Script

def Search(listJson, NameFichero):  # creamos un metodo para crear y registrar el archivo log


    for item in listJson['results']:  # creamos un for que recorre por cada uno de los items del Json
                                           # ListJson['results'] selecciona el Json apartir del campo results

        id = item['id']  # Seleccionamos cada uno de los campos del Json y lo guardamos en variables
        title = item['title']
        cate = item['category_id']

        curl2 = 'https://api.mercadolibre.com/categories/' + item['category_id']+''  # Api para buscar el nombre de la categoria
        res2 = requests.get(curl2)  # realizamos la solicitud de Get para obtener el archivo Json
        listJson2 = json.loads(res2.content)

        for item2 in listJson2['path_from_root']:  # Repetimos procedimiento pero esta vez desde el Json obtenido por el id de la categoria

            name = item2['name']  # extraemos el Nombre de la categoria

            result = {'id': id,
                          'title': title,  # Creamos un Json con los datos extraidos del API de ML
                          'category_id': cate,
                          'Name_category': name}

        print('Procesando....')

        logging.basicConfig(filename=NameFichero + '.log',# Luego usamos el Logging para crear nuestro Archivo
                                    format=' %(message)s',  # El format nos indica los campos que queremos guardar en este caso solo guardamos mensaje
                                    filemode='a')  # En este caso el archivo se reescribe cada vez que el loop se reinicia
        logging.warning(result) #Escribiendo el contenido de result en el Fichero



def Menu():

    print('Bienvenido, Para comenzar debe escoger entre una de las opciones')
    print('Presione 1 para Buscar un solo Usuario')         # Pequeño Menu del script
    print('Presione 2 para Buscar una Lista de Usuarios')

    option = int(input('Elija entre las Opciones mencionadas:\n')) #Tomamos el Input de las opciones

    if option == 1: #opcion 1

        Seller_id = Inputseller()  # Iniciamos la funcion y guardamos lo que retorna en una variable
        processing(Seller_id)  # Iniciamos el metodo central del codigo y le pasamos el Seller_id como parametro
        print('Generando archivo...')
        print('Archivo Generado con Exito!!')

    elif option == 2: #opcion 2
        print('DEBE INGRESAR LOS CAMPOS EN UNA SOLA LINEA SEPARADOS POR ESPACIO EJEM: ')
        print('15236 253253 .... N_ID ')
        ListID = list(map(int, input("Ingresar Todos los Seller_ID que desea Buscar:\n ").split())) #Input que toma multiples campos es separado por la funcion split

        for i in range(len(ListID)): #Guardamos el Input como una lista y la recorremos con for range
            Seller_id = ListID[i]  # Iniciamos la funcion indexando cada uno de los elementos de la lista
            processing(Seller_id)  # Iniciamos el metodo central del codigo y le pasamos el Seller_id como parametro
            print('Generando archivo...')
        print('Archivos Generados con Exito!!')

    else:
        print(str(option)+" No es valido") #En caso de escoger una opcion no valida
        Menu() #Volvemos a iniciar el menu


def main():
    Menu()






if __name__ == "__main__":
 main() #Definimos la Funcion Main() del archivo


