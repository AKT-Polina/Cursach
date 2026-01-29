from multiprocessing.connection import default_family
from random import choice

import psycopg2
from psycopg2.extensions import register_type, UNICODE
CONN_STR = "host='localhost' dbname='postgres' user='postgres' password='1234'"
def print_user():#Выводит таблицу с пользователями
    register_type(UNICODE)
    conn = psycopg2.connect(CONN_STR)
    cur = conn.cursor()
    cur.execute('select * from "user"')
    cols = cur.description
    row = cur.fetchone()
    while row:
        for i in range(len(cols)): print(row[i])
        print('#'*10)
        row = cur.fetchone()
    cur.close()
    conn.close()

def add_user(login, password):#Добавление пользователя запросом
    conn = psycopg2.connect(CONN_STR)
    cur = conn.cursor()
    cur.execute('insert into "user" (login, password) values\
    (%s, %s)', [login, password])
    conn.commit()
    cur.close()
    conn.close()

def add_user_func():#Добавление пользователся с помощью ранее созданной функции
    login = input("Логин: ")
    password = input("Пароль: ")
    conn = psycopg2.connect(CONN_STR)
    cur = conn.cursor()
    cur.callproc('create_new_user', [login, password])#Вставка данных в запрос
    conn.commit()
    cur.close()
    conn.close()

def add_Character_func():#Добавление персонажа
    eyeColor = input("Цвет глаз: ")
    hairColor = input("Цвет волос: ")
    hairStyle = input("Прическа: ")
    outfit = input("Одежда: ")
    currentPosition = int(input("Позиция: "))
    isWinner = bool(input("Выиграл ли: "))
    idUser = int(input("id Пользователя: "))
    cell = int(input("Клетка:  "))
    conn = psycopg2.connect(CONN_STR)
    cur = conn.cursor()#вставка данных введенных пользователем
    cur.execute('insert into "Character" (eyecolor, haircolor, hairstyle, outfit, currentposition, iswinner, iduser, cell) values\
        (%s, %s, %s, %s, %s, %s, %s, %s)', [eyeColor, hairColor, hairStyle, outfit, currentPosition, isWinner, idUser, cell])
    conn.commit()
    cur.close()
    conn.close()

def add_question_func():#Добавление вопроса
    text = input("Текст вопроса: ")
    correctAnswer = input("Правильный ответ: ")
    imagePath = input("Путь до картинки: ")
    conn = psycopg2.connect(CONN_STR)
    cur = conn.cursor() #вставка данных
    cur.execute('insert into "question" (text, correctanswer, imagepath) values\
            (%s, %s, %s)',
                [text, correctAnswer, imagePath])
    conn.commit()
    cur.close()
    conn.close()

def delete_user_func():#Удаление пользователя
    id = input("id Пользователя: ")
    conn = psycopg2.connect(CONN_STR)
    cur = conn.cursor()
    cur.execute(f'delete from "user" where iduser = {id}')#поd
    conn.commit()
    cur.close()
    conn.close()

def delete_Character_func():#Удаление персонажа
    id = input("id Персонажа: ")
    conn = psycopg2.connect(CONN_STR)
    cur = conn.cursor()
    cur.execute(f'delete from Character where idсharacter = {id}')#по id
    conn.commit()
    cur.close()
    conn.close()

def delete_question_func():#Удаление вопроса
    id = input("id вопроса: ")
    conn = psycopg2.connect(CONN_STR)
    cur = conn.cursor()
    cur.execute(f'delete from question where idquestion = {id}') #по id
    conn.commit()
    cur.close()
    conn.close()



def print_table(table):#Выводит любую таблицу
    register_type(UNICODE)
    conn = psycopg2.connect(CONN_STR)
    cur = conn.cursor()
    cur.execute(f'select * from "{table}"')
    cols = cur.description
    row = cur.fetchone()
    while row:
        for i in range(len(cols)): print(row[i])
        print('#'*10)
        row = cur.fetchone()
    cur.close()
    conn.close()

while(True): #Меню в цикле
    print("Меню")
    print("Посмотреть таблицу - 1")
    print("Добавить данные - 2")
    print("Удалить данные - 3")
    print("Выход - 4")
    choice = int(input("Ввод: "))
    if choice == 1:
        table = input("Введите имя таблицы")
        #функция для вывода таблицы
        print_table(table)
    if choice == 2:
        table = input("Введите имя таблицы")
        # функция для добавления данных в таблицу
        if table == 'user':
            add_user_func()
        elif table == 'Character':
            add_Character_func()
        elif table == 'question':
            add_question_func()
        else:
            print("Некорректные данные")
    if choice == 3:
        table = input("Введите имя таблицы")
        # функция для удаления данных из таблицы
        if table == 'user':
            delete_user_func()
        elif table == 'Character':
            delete_Character_func()
        elif table == 'question':
            delete_question_func()
        else:
            print("Некорректные данные")
    if choice == 4:
        print("Выход из программы...")
        break
