# -*- coding: utf-8 -*-
import wx
import wx.grid
import psycopg2
from psycopg2.extensions import register_type, UNICODE
CONN_STR = "host='localhost' dbname='postgres' user='postgres' password='1234'"
class DatabaseFrame(wx.Frame):
    def __init__(self, parent, id):
        wx.Frame.__init__(self, parent, id, 'Working with Database', \
            size=(550, 400), style=wx.DEFAULT_FRAME_STYLE)
        self.window1 = wx.SplitterWindow(self, -1, style=wx.NO_BORDER)
        self.panel1 = wx.Panel(self.window1, -1)
        self.panel2 = wx.Panel(self.window1, -1)

        self.Bind(wx.EVT_CLOSE, lambda event: self.Destroy())
        self.download = wx.Button(self.panel2, -1, 'download')
        self.new = wx.Button(self.panel2, -1, 'new')
        self.update = wx.Button(self.panel2, -1, 'update')
        self.delete = wx.Button(self.panel2, -1, 'delete')

        self.table_choice = wx.Choice(self.panel2, -1, choices=['question', 'user', 'Character'])
        self.table_choice.SetSelection(0)  # Выпадающий список для выбора таблицы

        self.grid = wx.grid.Grid(self.panel1, -1, size=(1,1))
        self.grid.CreateGrid(100, 4)
        self.grid.SetRowLabelSize(40)
        self.grid.SetColLabelSize(40)
        self.grid.SetMinSize((500, 300))
        self.grid.SetColLabelValue(0, 'id')
        self.grid.SetColSize(0, 40)
        self.grid.SetColLabelValue(1, 'text')
        self.grid.SetColSize(1, 150)
        self.grid.SetColLabelValue(2, 'correctanswer')
        self.grid.SetColSize(2, 150)
        self.grid.SetColLabelValue(3, 'imagepath')
        self.grid.SetColSize(3, 150)

        self.Bind(wx.EVT_BUTTON, self.on_download, self.download)#self.Bind(wx.EVT_BUTTON, self.on_download, self.download)
        self.Bind(wx.EVT_BUTTON, self.on_new, self.new)
        self.Bind(wx.EVT_BUTTON, self.on_update, self.update)
        self.Bind(wx.EVT_BUTTON, self.on_delete, self.delete)
        self.grid.Bind(wx.EVT_KEY_DOWN, self.keydown)

        self.panel1.SetMinSize((550, 370))
        self.panel2.SetMinSize((550, 30))
        self.window1.SetMinSize((550, 400))

        sizer = wx.BoxSizer(wx.VERTICAL)
        sizer1 = wx.BoxSizer(wx.VERTICAL)
        sizer2 = wx.BoxSizer(wx.HORIZONTAL)
        sizer1.Add(self.grid, -1, wx.EXPAND|wx.ADJUST_MINSIZE, 0)
        sizer2.AddMany([(self.download, -1, wx.EXPAND|wx.ADJUST_MINSIZE, 0),
            (self.new, -1, wx.EXPAND|wx.ADJUST_MINSIZE, 0),
            (self.update, -1, wx.EXPAND|wx.ADJUST_MINSIZE, 0),
            (self.delete, -1, wx.EXPAND|wx.ADJUST_MINSIZE, 0)])
        sizer2.Add(self.table_choice, 0, wx.ALL | wx.CENTER, 5)
        self.panel1.SetSizer(sizer1)
        self.panel2.SetSizer(sizer2)
        self.window1.SplitHorizontally(self.panel1, self.panel2)
        sizer.Add(self.window1, 1, wx.ALL|wx.EXPAND, 0)
        self.SetAutoLayout(True)
        self.SetSizer(sizer)
        self.Layout()
        self.Centre()

    def on_download(self, event):#ЗАГРУЗКА ДАННЫХ
        try:
            table_name = self.table_choice.GetStringSelection()  # имя таблиццы выбранной пользователем

            conn = psycopg2.connect(CONN_STR)
            cur = conn.cursor()

            # очистка таблицы
            if self.grid.GetNumberRows() > 0:
                self.grid.DeleteRows(0, self.grid.GetNumberRows())

            # запрос на выборку данных
            cur.execute(f'SELECT * FROM "{table_name}"')

            rows = cur.fetchall()
            cols_desc = cur.description

            # добавление строк
            self.grid.AppendRows(len(rows) if rows else 1)

            # Меняем заголовки колонок динамически
            for i, col_info in enumerate(cols_desc):
                self.grid.SetColLabelValue(i, col_info.name)

            # вывод данных
            for i, row in enumerate(rows):
                for col in range(len(row)):
                    self.grid.SetCellValue(i, col, str(row[col] if row[col] is not None else ""))

            cur.close()
            conn.close()

        except Exception as e:
            print(f"Ошибка при загрузке: {e}")

    def keydown(self, event):
        if event.GetKeyCode() == wx.WXK_INSERT:
            self.grid.InsertRows(self.grid.GetNumberRows(), 1, False)

    def on_new(self, event):#ДОБАВЛЕНИЕ ДАННЫХ
        table_name = self.table_choice.GetStringSelection()
        row_idx = self.grid.GetGridCursorRow()  # Индекс строки, на которой стоит курсор

        conn = psycopg2.connect(CONN_STR)
        cur = conn.cursor()

        try:
            if table_name == 'question':#Таблица с вопросами
                # Для question нам нужны колонки 1, 2, 3 (text, answer, image)
                data = [self.grid.GetCellValue(row_idx, col) for col in range(1, 4)]
                query = 'INSERT INTO "question" (text, correctanswer, imagepath) VALUES (%s, %s, %s)'#вставка данных
                cur.execute(query, data)

            elif table_name == 'user': #Таблица с пользователями
                # Для user нам нужны колонки 1, 2 (login, password)
                data = [self.grid.GetCellValue(row_idx, col) for col in range(1, 3)]
                query = 'INSERT INTO "user" (login, password) VALUES (%s, %s)'#вставка данных
                cur.execute(query, data)

            elif table_name == 'Character':#Таблица с персонажами
                data = [self.grid.GetCellValue(row_idx, col) for col in range(1, 3)]
                query = 'insert into "Character" (eyecolor, haircolor, hairstyle, outfit, currentposition, iswinner, iduser, cell) values\
            (%s, %s, %s, %s, %s, %s, %s, %s)'#вставка данных
                cur.execute(query, data)

            conn.commit()
            print(f"Готово")
            self.on_download(None)

        except Exception as e:
            conn.rollback()
            print(f"Ошибка добавления: {e}")
        finally:
            cur.close()
            conn.close()

    def on_update(self, event):
        print("Нажата кнопка Update")

    def on_delete(self, event):
        # получаем текущую выбранную строку
        row_idx = self.grid.GetGridCursorRow()
        if row_idx < 0:
            print("Сначала выберите строку в таблице!")
            return

        # ид первой выбранной строчки (выбьранная стркоа)
        record_id = self.grid.GetCellValue(row_idx, 0)

        if not record_id:
            print("Нельзя удалить пустую строку или строку без ID")
            return

        # имя таблицы
        table_name = self.table_choice.GetStringSelection()

        # подтверждение удаления
        dial = wx.MessageDialog(None, f'Удалить запись с ID {record_id} из таблицы {table_name}?',
                                'Подтверждение', wx.YES_NO | wx.NO_DEFAULT | wx.ICON_QUESTION)

        if dial.ShowModal() == wx.ID_YES: #сообщенгие пользователю
            conn = psycopg2.connect(CONN_STR)
            cur = conn.cursor()
            try:
                # удаление строки если ид равен тому что в выбранной строке
                query = f'DELETE FROM "{table_name}" WHERE id = %s'
                cur.execute(query, (record_id,))
                conn.commit()

                # обновление интерфейса
                self.grid.DeleteRows(row_idx, 1)
                print(f"Запись {record_id} успешно удалена.")
            except Exception as e:
                conn.rollback()
                print(f"Ошибка при удалении: {e}")
            finally:
                cur.close()
                conn.close()

if __name__ == '__main__':
    app = wx.App()
    frame = DatabaseFrame(parent=None, id=-1)
    frame.Show()
    app.MainLoop()