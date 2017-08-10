import pyodbc

cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=DESKTOP-F4TU9PM\LOCAL;DATABASE=ItemComparer;TRUSTED_CONNECTION=yes;')

cursor = cnxn.cursor()

cursor.execute("SELECT ShopId, [Name] FROM dbo.Shop WHERE [Name] = 'Tesco'")
row = cursor.fetchone()
if row:
    print(row)