import tkinter.font as tkFont
from tkinter import *
# from tkinter import StringVar
from PIL import ImageTk, Image
import tkinter.messagebox as tkMessageBox
from tktimepicker import AnalogPicker, AnalogThemes
import pickle
import os
import subprocess
from imutils import paths
import cv2
from pymongo import MongoClient
import pprint
from tkcalendar import *
import time
import datetime
from datetime import date as dt
from reportlab.pdfgen import canvas
from fpdf import FPDF
import pyqrcode
import png
import json
from escpos import *
# from escpos import printer
from subprocess import call
from time import sleep
import pandas as pd
import requests
import urllib.request
from tkcalendar import Calendar
import glob
from tkinter.simpledialog import askstring
from tkinter import ttk  
import tkinter.font as tkfont


Traceback (most recent call last):
  File "/home/bitsgate/Downloads/Entry_Exit_User_module_RM.py", line 23, in <module>
    from escpos import *
  File "/usr/local/lib/python3.9/dist-packages/escpos/escpos.py", line 6, in <module>
    import qrcode
  File "/usr/local/lib/python3.9/dist-packages/qrcode/__init__.py", line 1, in <module>
    from qrcode.main import QRCode
  File "/usr/local/lib/python3.9/dist-packages/qrcode/main.py", line 15, in <module>
    from typing_extensions import Literal
ModuleNotFoundError: No module named 'typing_extensions'

typing_extensions
requests