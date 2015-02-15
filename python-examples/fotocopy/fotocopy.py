import sys
import os
import shutil
from datetime import date
from collections import defaultdict

class Utils:
    @staticmethod
    def getficheros(folder):
        """devuelve todos los ficheros de folder"""
        return [os.path.join(folder,fichero) for fichero in os.listdir(folder) if os.path.isfile(os.path.join(folder,fichero))]
    
    @staticmethod            
    def getcarpetas(folder):
        """devuelve todas las carpetas de folder"""
        return [os.path.join(folder, carpeta) for carpeta in os.listdir(folder) if os.path.isdir(os.path.join(folder, carpeta))]
        
class Main:
    def copiar(self, origen, destino, fecha, descripcion):
        carpeta = fecha.strftime('%Y%m%d')+' ('+fecha.strftime('%d_%m_%Y')+') '+descripcion
        destino = os.path.join(destino, carpeta)
        try:
            os.makedirs(destino)
        except:
            pass
        destino = os.path.join(destino, os.path.basename(origen))
        print origen
        print destino
        shutil.copyfile(origen, destino)
        
    def procesar(self, folderOrigen, folderDestino):
        #obtener un diccionario con todas las fotos
        lista = defaultdict(list)
        for fichero in Utils.getficheros(folderOrigen):
            fecha = date.fromtimestamp(os.path.getmtime(fichero))
            lista[fecha].append(fichero)
        #listar resumen al usuario
        print 'Fecha capt.   fotos'
        print '-------------------'
        for captura in lista:
            print captura.strftime('%d-%m-%Y'), '    ', len(lista[captura])
        #pedir descripcion para cada una de las fechas
        for captura in lista:
            pregunta = 'describa las fotos capturadas en fecha (enter=saltar)' + captura.strftime('%d-%m-%Y') + ': '
            descripcion = raw_input(pregunta)
            if descripcion != '':
                for foto in lista[captura]:
                    Main.copiar(self, foto, folderDestino, captura, descripcion)


if __name__ == '__main__':
    if len(sys.argv) == 1:
        origen = raw_input('path origen?: ')
        destino = raw_input('path destino?: ');
        if (origen != '') & (destino != ''):
            main = Main()
            main.procesar(origen, destino)
    elif len(sys.argv.count) == 3:
        main = Main()
        main.procesar(sys.argv[1],sys.argv[2])
    else:
        print 'fotocopy <path origen> <path destino>'
        
