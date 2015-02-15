from kivy.app import App
from kivy.uix.widget import Widget
from math import sqrt
from kivy.properties import NumericProperty, StringProperty


class MyCalc(Widget):
    operand = NumericProperty(0)
    func = StringProperty('')

    @property
    def d_text(self):
        return self.display.text

    @d_text.setter
    def d_text(self, value):
        if value == '':
            value = '0'
        self.display.text = value
    
    @property
    def d_float(self):
        return float(self.display.text)

    @d_float.setter
    def d_float(self, value):
        if int(value) == value:
            self.display.text = str(int(value))
        else:
            self.display.text = str(value)

    def key(self, key):
        if self.func != '':
            self.operand = self.d_float
            self.d_text = key
        else:
            self.d_text = (self.d_text + key).lstrip('0')

    def function(self, func):      
        if func == '=' and self.d_text != "":
            if self.func == '+':
                self.d_float = self.operand + self.d_float
            if self.func == '-':
                self.d_float = self.operand - self.d_float
            if self.func == '/':
                self.d_float = self.operand / self.d_float
            if self.func == '*':
                self.d_float = self.operand * self.d_float
            if self.func == '%':
                 self.d_float = self.operand * (100/self.d_float)
            self.operand = 0
            self.func = ''
        elif func == '+-':
            self.d_float = -self.d_float
        elif func == 'sqrt':
            self.d_float = sqrt(self.d_float)
        else:
            self.func = func

    def back(self):
        self.d_text = self.d_text[:-1]

    def clear(self):
        self.d_float= 0
        self.operand = 0
        self.func = ''
   
class CalcApp(App):
    def build(self):
        pass
 
if __name__=="__main__":
    CalcApp().run()
