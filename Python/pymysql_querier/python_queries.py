import pymysql
import pandas as pd
import numpy as np

# These functions operate for a table "employee" with certain parameters, but can easily be adjusted to any table
# by changing the SQL queries and the respective python list/database formats.

# This part is easier to simply complete through mysql but is included here in case you would like to
# complete all of your queries through python.
def create_table(host = "localhost", port = 3306, u = 'root', p = '', db = 'mysql'):
    # Open database connection
    db = pymysql.connect(host = host, port = port, user = u, passwd = p, db = db)

    # Prepare a cursor object
    cursor = db.cursor()

    # Delete table if it already exists
    cursor.execute("DROP TABLE IF EXISTS EMPLOYEE")

    # Create table in specified sql database
    sql_create = """CREATE TABLE EMPLOYEE (
             FIRST_NAME  CHAR(20) NOT NULL,
             LAST_NAME  CHAR(20),
             AGE INT,
             SEX CHAR(1),
             INCOME FLOAT,
             ID INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT)"""

    cursor.execute(sql_create)

    # Disconnect from server
    cursor.close()
    db.close()


# This function assumes that you will be passing a dataframe (or numpy array/nested list) that matches the table
# in your database and that the columns ARE IN THE SAME ORDER (you may have to reorder the columns of your
# dataframe in python first.
def insert_dataframe(dataframe, host = "localhost", port = 3306, u = 'root', p = '', db = 'mysql'):
    # Open database connection
    db = pymysql.connect(host = host, port = port, user = u, passwd = p, db = db)

    # Prepare a cursor object
    cursor = db.cursor()

    df = pd.DataFrame(dataframe)

    # pandas.values returns
    tuples = [tuple(row) for row in df.values]

    try:
        for x in tuples:
            sql_insert = """INSERT INTO EMPLOYEE(FIRST_NAME,
                   LAST_NAME, AGE, SEX, INCOME)
                   VALUES ('%s', '%s', '%d', '%c', '%d')""" % x
            cursor.execute(sql_insert)
        # Commit changes in the database
        db.commit()
    except:
        # Rollback in case there is any error
        db.rollback()

    # Disconnect from server
    cursor.close()
    db.close()


# Retrieves an SQL table and creates a pandas dataframe.
def retrieve_dataframe(host = "localhost", port = 3306, u = 'root', p = '', db = 'mysql'):
    # Open database connection
    db = pymysql.connect(host = host, port = port, user = u, passwd = p, db = db)

    # Prepare a cursor object
    cursor = db.cursor()

    sql_select = """SELECT * FROM EMPLOYEE"""

    try:
        cursor.execute(sql_select)
        # Fetch all the rows in a list of lists.
        results = cursor.fetchall()
        # Results is a tuple with each row.

        fname, lname, age, sex, income, id = [], [], [], [], [], []

        for row in results:
            fname.append(row[0])
            lname.append(row[1])
            age.append(row[2])
            sex.append(row[3])
            income.append(row[4])
            id.append(row[5])
    except:
        print("Error: unable to fetch data")

    # Disconnect from server
    db.close()
    cursor.close()

    # create a dataframe with our lists
    data = {'fname': fname,
            'lname': lname,
            'age': age,
            'sex': sex,
            'income': income,
            'id': id}

    pandas_dataframe = pd.DataFrame(data)
    # Pandas may alphabetize the order of your columns.

    return pandas_dataframe
