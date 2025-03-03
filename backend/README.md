 python -m venv env  
.\env\Scripts\activate 
pip install django
pip install channels
pip install daphne
django-admin startproject chatapp .
django-admin startapp chat
pip freeze > requirements.txt   
daphne -b 0.0.0.0 -p 8000 chatapp.asgi:application
py manage.py runserver