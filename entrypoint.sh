#!/bin/bash


echo "Applying database migrations..."
python manage.py migrate --noinput

# echo "Creating superuser..."
# python manage.py shell << END
# from django.contrib.auth.models import User
# import os

# username = os.getenv('DJANGO_SUPERUSER_USERNAME', 'admin')
# email = os.getenv('DJANGO_SUPERUSER_EMAIL', 'admin@example.com')
# password = os.getenv('DJANGO_SUPERUSER_PASSWORD', 'admin123')

# if not User.objects.filter(username=username).exists():
#     User.objects.create_superuser(username=username, email=email, password=password)
#     print("Superuser created.")
# else:
#     print("Superuser already exists.")
# END

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Starting server..."
gunicorn web.wsgi:application --bind 0.0.0.0:8000